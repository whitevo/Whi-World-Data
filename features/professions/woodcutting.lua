function woodCutting_useSaw(player, item, itemEx)
    if not item:isSaw() then return end
    if not itemEx:isItem() then return end
    if not itemEx:isTree() then return end
    if itemEx:getActionId() >= 100 then return player:sendTextMessage(GREEN, "Can not chop/saw down this tree. It's most likely unique tree used for quests or missions") end
local charges = tools_getCharges(item)
local treeCharges = woodCutting_getTreeCharges(itemEx)
local requiredCharges = treeCharges - player:getWoodCuttingLevel()

    if requiredCharges < 1 then requiredCharges = 1 end
    if charges < requiredCharges then return player:sendTextMessage(GREEN, "You need at least "..requiredCharges.." charges to chop/saw this tree down.") end
    tools_setCharges(player, item, charges - requiredCharges) 
    woodCutting_cutTree(player, itemEx)
    return true
end

function woodCutting_cutTree(player, tree)
local treeStumpID = woodCutting_getStumpID(tree)
local treePos = tree:getPosition()
local growTime = woodCutting_getGrowTime(tree)
local materialID = woodCutting_getMaterialID(tree)
local materialCount = woodCutting_getMaterialCount(player)
local exp = woodCutting_getTreeExp(tree)

    player:addWoodCuttingExp(exp)
    doSendMagicEffect(treePos, 4)
    if materialCount > 0 then player:giveItem(materialID, materialCount) end
    
    if building_getHouseID(treePos) and not chanceSuccess(farmingConf.treeRespawnChance) then 
        tree:remove()
        building_saveHouseTile(treePos)
        building_registerFloor(Tile(treePos):getGround():getId(), 0, treePos)
        return true
    end
    
    createItem(treeStumpID, treePos)
    addEvent(removeItemFromPos, growTime, treeStumpID, treePos)
    addEvent(createItem, growTime, tree:getId(), treePos)
    tree:remove()
end

function woodCutting_createChanceT(level) return createFormulaChanceT(woodCuttingConf.levelChances, level) end

function createFormulaChanceT(levelChancesT, level)
    local totalPercent = 0
    local chanceT = levelChancesT[level]
    
    if not chanceT then
        local newChanceT = {}
        local modifierT
        local highestLevelFormula = 0
        
        for requiredLevel, chanceT in pairs(levelChancesT.formulas) do
            if level >= requiredLevel and requiredLevel > highestLevelFormula then
                highestLevelFormula = requiredLevel
                modifierT = chanceT
            end
        end
        local levelDifference = level - highestLevelFormula
        
        for key, chance in pairs(levelChancesT[highestLevelFormula]) do
            local mod = modifierT[key] or 0
            local newChance = mod * levelDifference + chance
            if newChance > 0 then newChanceT[key] = newChance end
        end
        chanceT = newChanceT
    end
    
    for _, chance in pairs(chanceT) do totalPercent = totalPercent + chance end
    local multiplier = math.floor(1000/totalPercent)
    local newChanceT = {}
    local tableAmount = tableCount(chanceT)
    local previousValue = 0

    while tableCount(newChanceT) ~= tableAmount do
        local lowestValue = 1001
        local logAmount
        
        for logAmount2, chance in pairs(chanceT) do
            if lowestValue > chance and not newChanceT[logAmount2] then
                lowestValue = chance
                logAmount = logAmount2
            end
        end
        
        local newChance = lowestValue*multiplier
        
        if previousValue == 0 then
            newChanceT[logAmount] = {min = 1, max = newChance}
        elseif tableCount(newChanceT) == tableAmount - 1 then
            newChanceT[logAmount] = {min = previousValue + 1, max = 1000}
        else
            newChance = newChance + previousValue
            newChanceT[logAmount] = {min = previousValue + 1, max = newChance}
        end
        previousValue = newChance
    end
    return newChanceT
end

function woodCutting_treeChargesMW_choices(player)
local choiceT = {}
local level = player:getWoodCuttingLevel()

    for treeID, treeT in pairs(woodCuttingConf.trees) do
        local name = ItemType(treeID):getName()
        local charges = treeT.takeCharge - level
        
        if charges < 1 then charges = 1 end
        choiceT[treeT.ID] = name.." takes "..plural("charge", charges).." from your tool at once"
    end
    return choiceT
end

function woodCutting_treeChargesMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.woodCutting) end
local treeT = woodCutting_getTreeT(choiceID)
local itemName = ItemType(treeT.itemID):getName()
local text = itemName..":\n"
    
    text = text.."takes about "..getTimeText(treeT.growTime/1000).." before tree grows back after chopping down.\n\n"
    text = text.."Gives "..treeT.exp.." woodcutting experience, every time you take a swing at tree.\n\n"
    text = text.."You get '"..ItemType(treeT.materialID):getName().."' out of this tree"
    player:showTextDialog(treeT.itemID, text)
    player:createMW(mwID)
end

function woodCuttingMW_title(player) return "Your woodcutting level is: "..player:getWoodCuttingLevel().." ["..player:getWoodCuttingExp().."/"..player:getWoodCuttingTotalExp().."]" end

function woodCuttingMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if choiceID == 2 then return player:createMW(MW.treeCharges) end
local level = player:getWoodCuttingLevel()
local chanceT = woodCutting_createChanceT(level)
local chanceStr = "log amount - chance to get in 1 hit"
    
    for logAmount, chanceT in pairs(chanceT) do
        local max = chanceT.max
        local min = chanceT.min
        local difference = max - min + 1
        local percent = difference/10
        
        chanceStr = chanceStr.."\n"..plural("log", logAmount).." at once - "..percent.."%"
    end
    player:showTextDialog(ITEMID.materials.log, chanceStr)
    player:createMW(mwID)
end

-- get functions and is functions
function woodCutting_getTreeT(object)
    if type(object) == "number" then
        for treeID, treeT in pairs(woodCuttingConf.trees) do
            if object == treeT.ID then return treeT end
        end
    end
    return woodCuttingConf.trees[object:getId()] or {}
end

function woodCutting_getStumpID(tree) return woodCutting_getTreeT(tree).stumpID or woodCuttingConf.defaults.stumpID end
function woodCutting_getMaterialID(tree) return woodCutting_getTreeT(tree).materialID or woodCuttingConf.defaults.materialID end
function woodCutting_getGrowTime(tree) return woodCutting_getTreeT(tree).growTime or woodCuttingConf.defaults.growTime end
function woodCutting_getTreeExp(tree) return woodCutting_getTreeT(tree).exp or woodCuttingConf.defaults.exp end
function woodCutting_getTreeCharges(tree) return woodCutting_getTreeT(tree).takeCharge or woodCuttingConf.defaults.takeCharge end

function woodCutting_getMaterialCount(player, amount)
local level = player:getWoodCuttingLevel()
local chanceT = woodCutting_createChanceT(level)
local randomN = math.random(1, 1000)

    for logAmount, chanceT in pairs(chanceT) do
        if randomN >= chanceT.min and randomN <= chanceT.max then return logAmount end
    end
    print("ERROR - something messed up chances in woodCutting_getMaterialCount()")
    Uprint(chanceT, "chanceT")
    Vprint(level, "woodCuttingLevel")
end

function Player.addWoodCuttingExp(player, amount)
local newLevel = professions_addExp(player, amount, woodCuttingConf.professionT.professionStr)

    if not newLevel then return end
    player:sendTextMessage(GREEN, "Your woodcutting skill is now level "..newLevel.."!")
    player:sendTextMessage(ORANGE, "woodcutting levelUp: Chances to get more logs increased")
    player:sendTextMessage(ORANGE, "woodcutting levelUp: Stronger trees take now less charges")
end

function Player.getWoodCuttingExp(player) return professions_getExp(player, woodCuttingConf.professionT.professionStr) end
function Player.getWoodCuttingLevel(player) return professions_getLevel(player, woodCuttingConf.professionT.professionStr) end
function Player.getWoodCuttingTotalExp(player) return professions_getTotalExpNeeded(player, woodCuttingConf.professionT.professionStr) end

function Item.isTree(item) return woodCuttingConf.trees[item:getId()] end