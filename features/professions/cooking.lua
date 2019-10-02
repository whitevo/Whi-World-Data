--[[ recipes (AUTO GENERATED)
    [potionName/dishName] = {
        recipeSV = INT,         has player learned recipe or not
        ingredients = {STR},    name of the ingredients to create it
        infoT = {STR},          effects what does this potion do
        learnedSV = {INT},      herb storage values
    }
    [foodName] = {
        herb = STR              full name of the herb what can spice up food
        infoT = {STR},          effects what does this food do if spiced 5 times
        learnedSV = {INT},      herb storage value
    }
]]
if not cookingConf then
recipes = {} -- strores some needed information about potions, spicing and cooking

--[[    cookingConf guide    -- experience gains are written on foodConf
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    },
]]
cookingConf = {
    professionT = {
        professionStr = "cooking",
        expSV = SV.cookingExp,
        levelSV = SV.cookingLevel,
        mwID = MW.cookBook,
    }
}

local feature_cooking = {
    startUpFunc = "cooking_startUp",
    startUpPriority = 1,
    AIDItems = {
        [AID.other.cookBook] = {funcSTR = "cookBook_use"},
    },
    IDItems = {
        [12287] = {funcSTR = "cooking_useEmptyBowl"},
        [12289] = {funcSTR = "cooking_useFilledBowl"},
    },
    IDItems_onLook = {
        [12289] = {funcStr = "cooking_onLook_filledBowl"},
    },
    modalWindows = {
        [MW.cookBook] = {
            name = "cookBookMW_name",
            title = "cookBookMW_title",
            choices = "cookBookMW_choices",
            buttons = {
                [100] = "Check",
                [101] = "Close",
            },
            say = "checking recipe book",
            func = "cookBookMW",
        },
    }
}
centralSystem_registerTable(feature_cooking)
end

function cooking_startUp()
    addProfession(cookingConf.professionT)
    
    for potionName, potionT in pairs(potions) do
        local recipeT = {}
        
        recipeT.recipeSV = potionT.recipeSV
        recipeT.ingredients = potionT.ingredients
        recipeT.learnedSV = {}
        recipeT.infoT = {potionT.buff.effect, potionT.nerf.effect}
        
        for _, herbName in pairs(potionT.ingredients) do
            local herbT = herbs_getHerbT(herbName)
            table.insert(recipeT.learnedSV, herbT.learnedSV)
        end
        recipes[potionName] = recipeT
    end

    for foodID, foodT in pairs(foodConf.food) do
        local recipeT = {}
        
        if foodT.effect then
            recipeT.learnedSV = foodT.recipeStorage
            recipeT.ingredients = foodT.ingredients
            recipeT.infoT = {food_getDishEffect(foodT.effect)}
        elseif foodT.spice then
            for herbPowderAID, spiceT in pairs(foodT.spice) do -- careful, recipes only support 1 spiceUp atm
                local herbT = herbs_getHerbT(herbPowderAID)
                recipeT.learnedSV = herbT.learnedSV
                recipeT.herb = herbT.name
                recipeT.infoT = {food_getSpiceEffect(5, foodT.spice)}
            end
        end
        recipes[foodT.foodName] = recipeT
    end
end

function cookBook_use(player, item)
    if getSV(player, SV.recipeBookLearned) == 1 then return player:sendTextMessage(GREEN, "You already collect recipe information automatically. You can see recipes by looking yourself.") end
    setSV(player, SV.recipeBookLearned, 1)
    player:sendTextMessage(GREEN, "You can now collect information automatically about recipes")
    player:sendTextMessage(ORANGE, "You can see your recipe book by looking your player")
    item:remove()
end

function cookBookMW_name(player)
local learnedRecipes, recipeAmount = 0,0

    for recipeName, t in pairs(recipes) do
        recipeAmount = recipeAmount + 1
        
        if t.recipeSV and getSV(player, t.recipeSV) == 2 then
            learnedRecipes = learnedRecipes + 1
        elseif compareSV(player, t.learnedSV, "==", 2) then
            setSV(player, t.recipeSV, 2)
            learnedRecipes = learnedRecipes + 1
        end
    end
    return "all cooking and brewing recipes ["..learnedRecipes.."/"..recipeAmount.."]"
end

function cookBookMW_title(player) return "Your cooking level: "..player:getCookingLevel().." ["..player:getCookingExp().."/"..player:getCookingTotalExp().."] and brewing level: "..player:getBrewingLevel().." ["..player:getBrewingExp().."/"..player:getBrewingTotalExp().."]" end

function cookBookMW_choices(player)
local choiceT = {}
local loopID = 0

    for recipeName, t in pairs(recipes) do
        local choiceMsg = "["..recipeName.."] = "
        loopID = loopID + 1
        
        if type(t.learnedSV) == "number" then -- 1 sv = food upgrade
            if getSV(player, t.learnedSV) == 2 then
                if t.ingredients then
                    choiceT[loopID] = choiceMsg.."["..t.ingredients[1].."] + ["..t.ingredients[2].."]"
                else
                    choiceT[loopID] = recipeName.." can be spiced with "..t.herb
                end
            end
        elseif t.ingredients and getSV(player, t.recipeSV) == 2 then
            for i, herbName in ipairs(t.ingredients) do
                if i > 1 then choiceMsg = choiceMsg.."+ " end
                choiceMsg = choiceMsg.."["..herbName.."] "
            end
            choiceT[loopID] = choiceMsg
        elseif t.ingredients then
            local herbLearned = false
            
            local function placeHerbName(i, herbName)
                if getSV(player, t.learnedSV[i]) == 2 then
                    herbLearned = true
                    return herbName 
                end
                return "unknown"
            end
            
            for i, herbName in ipairs(t.ingredients) do
                if i > 1 then choiceMsg = choiceMsg.."+ " end
                choiceMsg = choiceMsg.."["..placeHerbName(i, herbName).."] "
            end
            
            if herbLearned then choiceT[loopID] = choiceMsg end
        end
    end
    return choiceT
end

function cookBookMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if choiceID == 255 then return end
local loopID = 0

    for recipeName, t in pairs(recipes) do
        loopID = loopID + 1
        if choiceID == loopID then
            player:sendTextMessage(BLUE, "--- "..recipeName.." ---")
            for _, info in pairs(t.infoT) do player:sendTextMessage(ORANGE, info) end
            break
        end
    end
    return player:createMW(mwID)
end

function cooking_useEmptyBowl(player, item, itemEx)
    if not itemEx then return end
local itemID = itemEx:getId()
local foodT = foodConf.food[itemID]
    if not foodT then return end
local itemCount = 1
    if itemID == 2677 then itemCount = 10 end
    if itemEx:getCount() < itemCount then return player:sendTextMessage(GREEN, "You need "..itemCount.." "..itemEx:getName().."s") end
local filledBowl = player:giveItem(12289)

    filledBowl:setText("ingredientID", itemID)
    player:sendTextMessage(GREEN, "Unfinished dish has been created with: "..foodT.foodName)
    doSendMagicEffect(getParentPos(itemEx), 28)
    item:remove(1)
    itemEx:remove(itemCount)
end

function cooking_useFilledBowl(player, item, itemEx)
    if not itemEx then return end
local itemID = itemEx:getId()
local foodT = foodConf.food[itemID]
    if not foodT then return end
local bowlIngredientID = item:getText("ingredientID")

    if bowlIngredientID == itemID then return player:sendTextMessage(GREEN, "you already have "..itemEx:getName().." in your bowl.") end
local itemCount = 1
    if itemID == 2677 then itemCount = 10 end
    if itemEx:getCount() < itemCount then return player:sendTextMessage(GREEN, "You need "..itemCount.." "..itemEx:getName().."s") end
local mixID = tonumber(itemID..bowlIngredientID)
local itemPos = getParentPos(itemEx)
    
    if itemID > bowlIngredientID then mixID = tonumber(bowlIngredientID..itemID) end
    foodT = getFoodTByMixID(mixID)
    doSendMagicEffect(itemPos, 28)
    item:remove(1)
    itemEx:remove(itemCount)
    
    if not foodT then
        player:sendTextMessage(GREEN, "Good Job! You ruined your food.")
        return player:giveItem(12287)
    end
    player:rewardItems({itemID = foodT.itemID, itemAID = AID.other.food})
    setSV(player, foodT.recipeStorage, 2)
    player:addCookingExp(foodT.cookingExp)
end

function cooking_onLook_filledBowl(player, item)
local bowlIngredientID = item:getText("ingredientID")
    
    player:sendTextMessage(GREEN, "You see bowl with "..ItemType(bowlIngredientID):getName())
end

function cooking_spiceFood(player, item, itemEx, toPos)
    if not itemEx:isFood() then return end
local foodT = food_getFoodT(itemEx)
local herbT = herbs_getHerbT(item)
    if not foodT or not herbT then return end
    if not foodT.spice then return player:sendTextMessage(GREEN, "This food can't be upgraded with herb powder.") end
local herbAID = item:getActionId()
local spiceAID = itemEx:getText("spiceAID")
    
    if spiceAID and spiceAID ~= herbAID then return player:sendTextMessage(GREEN, "Food can only be spiced up with 1 spice type at once") end
local spiceT = foodT.spice[herbAID]

    if not spiceT then 
        item:remove(1)
        itemEx:remove(1)
        return player:sendTextMessage(GREEN, "GOOD JOB! you just ruined your food.")
    end
local spiceCount = itemEx:getText("spiceCount") or 0
local highestSpiceAmount = 0

    for spiceAmount, _ in pairs(spiceT) do
        if highestSpiceAmount < spiceAmount then highestSpiceAmount = spiceAmount end
    end
    
    if spiceCount == highestSpiceAmount then return player:sendTextMessage(GREEN, "This food has been spiced up enough already.") end
    local moveToBag = false

    if isContainerPos(toPos) then
        if not ownerIsPlayer(player, toPos) then
            if not player:checkWeight(itemEx:getWeight(), "Not enough cap to spice all the food and pick it up.") then return end
        end
        
        if not player:hasBagRoom() then return player:sendTextMessage(GREEN, "You need 1 empty slot in your bag to pick up the food") end
        moveToBag = true
    end
    local foodID = itemEx:getId()
    local parentPos = getParentPos(itemEx)
    local newFood = createItem(foodID, parentPos, 1, AID.other.food, nil, "spiceCount("..(spiceCount+1)..") spiceAID("..herbAID..")")
        
    player:addCookingExp(foodT.cookingExp)
    setSV(player, herbT.learnedSV, 2)
    doSendMagicEffect(parentPos, 28)
    itemEx:remove(1)
    item:remove(1)
    if moveToBag then newFood:moveTo(player:getBag()) end
    return true
end

-- get functions
function Player.addCookingExp(player, amount)
local newLevel = professions_addExp(player, amount, cookingConf.professionT.professionStr)

    if not newLevel then return end
    player:sendTextMessage(GREEN, "Your cooking skill is now level "..newLevel.."!")
    player:sendTextMessage(ORANGE, "See if Alice the cook has something new to teach for you.")
end
function Player.getCookingExp(player) return professions_getExp(player, cookingConf.professionT.professionStr) end
function Player.getCookingTotalExp(player) return professions_getTotalExpNeeded(player, cookingConf.professionT.professionStr) end
function Player.getCookingLevel(player) return professions_getLevel(player, cookingConf.professionT.professionStr) end

function getFoodTByMixID(mixID)
    for _, foodT in pairs(foodConf.food) do
        if mixID == foodT.foodID then return foodT end
    end
end