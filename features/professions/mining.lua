function mining_destroyStone(player, item, itemEx)
    if not isInArray(miningConf.brickStones, itemEx:getId()) then return end
    if itemEx:getActionId() >= 100 then return player:sendTextMessage(GREEN, "Can not detroy this stone.") end
local stonePos = itemEx:getPosition()

    addEvent(createItem, 2*60*1000, randomValueFromTable(miningConf.brickStones), stonePos)
    createItem(ITEMID.materials.brick, stonePos)
    doSendMagicEffect(stonePos, {27,3})
    tools_addCharges(player, item, -1)
    cyclopsDagosil(nil, nil, stonePos, true) -- dagosil replace delay 2*61*1000
    return itemEx:remove()
end

function mining_mineOre(player, item, itemEx)
    if not itemEx:isItem() then return end
    if itemEx:isDepletedOre() then return player:sendTextMessage(GREEN, "This stone has no more minerals on it and can't be destroyed") end
    if not itemEx:isMiningOre() then return end
local materialID = mining_getMaterialID(player)
local exp = mining_getMaterialExp(materialID)
local gemChance = miningConf.gemChangePerLevel*player:getMiningLevel() + miningConf.gemChance
local newLevel = player:addMiningExp(exp)

    if chanceSuccess(gemChance) then player:rewardItems({itemID = miningConf.gems}, true) end
    tools_addCharges(player, item, -1)
    mining_depleteOre(itemEx)
    player:rewardItems({itemID = materialID}, true)
    if newLevel then
        player:sendTextMessage(GREEN, "Your mining skill is now level "..newLevel.."!")
        player:sendTextMessage(ORANGE, "mining levelUp: Chances to get better minerals from ores is increased")
    end
    return true
end

function mining_depleteOre(ore)
local itemPos = ore:getPosition()
local depletedOreID = randomValueFromTable(miningConf.depletedOres)
local miningOreID = randomValueFromTable(miningConf.miningOres)

    createItem(depletedOreID, itemPos, 1, AID.other.depletedOre)
    addEvent(removeItemFromPos, miningConf.oreSpawnTime, depletedOreID, itemPos)
    addEvent(createItem, miningConf.oreSpawnTime, miningOreID, itemPos)
    ore:remove()
end

function mining_createChanceT(level) return createFormulaChanceT(miningConf.levelChances, level) end

function miningMW_title(player) return "Your mining level is: "..player:getMiningLevel().." ["..player:getMiningExp().."/"..player:getMiningTotalExp().."]" end

function miningMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    local level = player:getMiningLevel()
    local chanceT = mining_createChanceT(level)
    local chanceStr = "chance to get % - ore name"
    local gemChance = miningConf.gemChangePerLevel*player:getMiningLevel() + miningConf.gemChance

    for oreID, chanceT in pairs(chanceT) do
        local max = chanceT.max
        local min = chanceT.min
        local difference = max - min + 1
        local percent = difference/10
        local oreName = ItemType(oreID):getName()
        
        chanceStr = chanceStr.."\n"..percent.."% chance to get '"..oreName
    end
    chanceStr = chanceStr.."\n"..gemChance.."% chance to get random `small elemental gem"
    player:showTextDialog(4874, chanceStr)
    player:createMW(mwID)
end

-- get functions, is functions
function mining_getMaterialID(player)
local level = player:getMiningLevel()
local chanceT = mining_createChanceT(level)
local randomN = math.random(1, 1000)
    
    for materialID, chanceT in pairs(chanceT) do
        if randomN >= chanceT.min and randomN <= chanceT.max then return materialID end
    end
    print("ERROR - something messed up chances in mining_getMaterialID()")
    Uprint(chanceT, "chanceT")
    Vprint(level, "miningLevel")
end

function mining_getOreT(itemID) return miningConf.ores[itemID] or {} end
function mining_getMaterialExp(materialID) return mining_getOreT(materialID).exp or miningConf.defaults.exp end

function Player.addMiningExp(player, amount) return professions_addExp(player, amount, miningConf.professionT.professionStr) end
function Player.getMiningExp(player) return professions_getExp(player, miningConf.professionT.professionStr) end
function Player.getMiningTotalExp(player) return professions_getTotalExpNeeded(player, miningConf.professionT.professionStr) end
function Player.getMiningLevel(player) return professions_getLevel(player, miningConf.professionT.professionStr) end

function Item.isMiningOre(item) return isInArray(miningConf.miningOres, item:getId()) end
function Item.isDepletedOre(item) return item:getActionId() == AID.other.depletedOre end
function Item.isMineral(item) return miningConf.ores[item:getId()] and true end