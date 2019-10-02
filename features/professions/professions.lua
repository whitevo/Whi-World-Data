--[[ EXP TABLE  | 100 + 100*(currentLevel*currentLevel)
    100     | 2600
    200     | 3700
    500     | 5000
    1000    | 6500
    1700    | 8200
]]
--[[ professions guide
    recipes = {
        [INT] = {                       recipe itemAID
            learnSV = INT,          
            name = STR,                 what you see when you look recipe
            professionActivity = STR    learn to do what
        }
    },
    
    -- automatic
    professions = {                     created with addProfession()
        [STR] = {                       professionStr
            professionStr = STR
            expSV = INT
            levelSV = INT
            mwID = INT
        }
    }
]]

professionsConf = {
    recipes = {
        [AID.recipes.warriorBoots] = {
            learnSV = SV.recipe_warriorBoots,
            name = "warrior boots",
            professionActivity = "smith",
        }
    },
    professions = {}
}

local feature_professions = {
    startUpFunc = "professions_startUp",
    modalWindows = {
        [MW.professions] = {
            name = "player professions",
            title = "List of your professions",
            choices = "professionsMW_choices",
            buttons = {
                [100] = "show",
                [101] = "close",
            },
            func = "professionsMW",
            say = "*checking professions*",
        }
    }
}

centralSystem_registerTable(feature_professions)

function professions_startUp()
    for itemAID, recipeT in pairs(professionsConf.recipes) do
        central_register_actionEvent({[itemAID] = {funcSTR = "professions_learnRecipe"}}, "AIDItems")
        AIDItems_onLook[itemAID] = {text = {msg = {"Use this item to learn how to "..recipeT.professionActivity.." "..recipeT.name}}}
    end
end

function addProfession(professionT) professionsConf.professions[professionT.professionStr] = professionT end

function professionsMW_choices(player)
    local choiceT = {}
    local loopID = 0

    for _, professionT in pairs(professionsConf.professions) do
        loopID = loopID + 1
        if professionT.mwID == MW.cookBook then
            if getSV(player, SV.recipeBookLearned) == 1 then choiceT[loopID] = professionT.professionStr end
        elseif professionT.mwID == MW.houseMW then
            if player:hasHouse() then choiceT[loopID] = professionT.professionStr end
        else
            choiceT[loopID] = professionT.professionStr
        end
    end
    return choiceT
end

function professionsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    local loopID = 0
        
    for _, professionT in pairs(professionsConf.professions) do
        loopID = loopID + 1
        if loopID == choiceID then return player:createMW(professionT.mwID) end
    end
end

function professions_learnRecipe(player, item)
    local recipeT = professionsConf.recipes[item:getActionId()]
        
    if getSV(player, recipeT.learnSV) == 1 then return player:sendTextMessage(GREEN, "You already know how to create "..recipeT.name) end
    setSV(player, recipeT.learnSV, 1)
    return player:sendTextMessage(GREEN, "You learned to "..recipeT.professionActivity.." "..recipeT.name)
end

function professions_showAll(player, target)
    if not target then target = player end
    player:sendTextMessage(BLUE, target:getName().." professions:")
    for professionStr, professionT in pairs(professionsConf.professions) do player:sendTextMessage(ORANGE, professionStr.." level: "..professions_getLevel(target, professionStr)) end
end

function professions_createMW(player) return player and player:createMW(MW.professions) end

-- get functions
function professions_getExp(player, professionStr)
    local professionT = professionsConf.professions[professionStr]
    local expSV = professionT.expSV
    local currentExp = getSV(player, expSV)
        
    if currentExp > -1 then return currentExp end
    setSV(player, expSV, 0)
    return 0
end

function professions_getLevel(player, professionStr)
    local professionT = professionsConf.professions[professionStr]
    local levelSV = professionT.levelSV
    local level = getSV(player, levelSV)
        
    if level > -1 then return level end
    setSV(player, levelSV, 0)
    return 0
end

function professions_setExp(player, amount, professionStr) return setSV(player, professionsConf.professions[professionStr].expSV, amount) end
function professions_setLevel(player, amount, professionStr) return setSV(player, professionsConf.professions[professionStr].levelSV, amount) end

function professions_getTotalExpNeeded(player, professionStr)
    local currentLevel = professions_getLevel(player, professionStr)
    local totalExp = 100 + 100*(currentLevel*currentLevel)
    return totalExp
end

function professions_addExp(player, amount, professionStr, newLevel)
    if not amount or amount == 0 then return newLevel end
    local currentExp = professions_getExp(player, professionStr)
    local totalExpNeeded = professions_getTotalExpNeeded(player, professionStr)
    local newExp = currentExp + amount

    if newExp >= totalExpNeeded then
        local currentLevel = professions_getLevel(player, professionStr)
        local newLevel = currentLevel + 1
        
        professions_setExp(player, 0, professionStr)
        professions_setLevel(player, newLevel, professionStr)
        return professions_addExp(player, newExp - totalExpNeeded, professionStr, newLevel)
    end
   
    player:say("+"..amount.." exp", ORANGE)
    professions_setExp(player, newExp, professionStr)
    if not newLevel then return end
    
    for i, posT in pairs(getAreaPos(player:getPosition(), areas["5x5_1 circle"])) do
        for _, pos in pairs(posT) do doSendMagicEffect(pos, math.random(29, 31), math.random(0, 3000)) end
    end
    return newLevel
end