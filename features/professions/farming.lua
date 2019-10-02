function farming_useShovel(player, item, itemEx)
    if farming_getHerbSeed(player, item, itemEx) then return true end
    if farming_getTreeSeed(player, item, itemEx) then return true end
end

function farming_getHerbSeed(player, item, itemEx)
    if not itemEx:isItem() then return end
local herbT = herbs_getHerbT(itemEx:getActionId())
    
    if not herbT then return end
    if not herbT.respawnSeconds then return true end
    if not compareSV(player, herbT.allSV, "==") then return true end
    if tools_getCharges(item) < 1 then return player:sendTextMessage(GREEN, "You need at least 1 charge on your shovel") end
local lastUsed = itemEx:getText("lastUsed") or 0

    if lastUsed + herbT.respawnSeconds > os.time() then return player:sendTextMessage(GREEN, "Someone has already looked for seeds here") end
    tools_addCharges(player, item, -1)
    doSendMagicEffect(itemEx:getPosition(), 27)
    removeHerb(player, itemEx, herbT)
    if not farming_foundSeed(player, herbT.chanceToGet) then return player:sendTextMessage(GREEN, "Did not get good "..itemEx:getName().." seed this time") end
    seedBag_autoLoot(player, player:giveItem(farmingConf.seedID, 1, herbT.seedAID))
    return player:sendTextMessage(GREEN, "You got "..herbT.name.." seed")
end

function farming_foundSeed(player, chanceToGet)
    chanceToGet = chanceToGet + farming_getBonusFindSeedChance(player) 
    return chanceSuccess(chanceToGet) 
end

function farming_getTreeSeed(player, item, itemEx)
local treeT = farming_getGrowT(itemEx:getId())
    if not treeT or not treeT.isTree then return end
    if tools_getCharges(item) < 1 then return player:sendTextMessage(GREEN, "You need at least 1 charge on your shovel") end    
local lastUsed = itemEx:getText("lastUsed") or 0

    if lastUsed + farmingConf.treeSeedRespawnMin*60 > os.time() then return player:sendTextMessage(GREEN, "Someone has already looked for seeds here") end
    itemEx:setText("lastUsed", os.time())
    tools_addCharges(player, item, -1)
    doSendMagicEffect(itemEx:getPosition(), 27)
    if not farming_foundSeed(player, treeT.chanceToGet) then return player:sendTextMessage(GREEN, "Did not find "..itemEx:getName().." seed this time") end
    seedBag_autoLoot(player, player:giveItem(farmingConf.seedID, 1, treeT.seedAID))
    return player:sendTextMessage(GREEN, "You found "..itemEx:getName().." seed")
end

function farming_treeSeedOnLook(player, item)
    if item:isGround() then return player:sendTextMessage(GREEN, "Here is growing "..farming_getGrowT(item:getActionId()).name) end
    player:sendTextMessage(GREEN, "You see "..farming_getGrowT(item:getActionId()).name.." seed")
end

function farming_herbSeedOnLook(player, item)
local herbT = herbs_getHerbT(item:getActionId())
    
    if item:isGround() then return player:sendTextMessage(GREEN, "Here is growing "..herbT.name) end
    player:sendTextMessage(GREEN, "You see "..herbT.name.." seed")
end

function farming_startGrowing(pos, seedAID)
local growT = farming_getGrowT(seedAID)
    if not growT then return end
local stageID = 1
local nextStageT = growT.stages[stageID]
    
    addEvent(farming_sprout, 5000, pos, growT, stageID)
   -- addEvent(farming_sprout, nextStageT.growTimeMin*60*1000, pos, growT, stageID)
end

function farming_sprout(pos, growT, stageID)
    growT = growT or farming_getGrowT(pos)
    if not growT then return end
local nextStageT
    if stageID then nextStageT = growT.stages[stageID] else nextStageT = farming_getStageT(pos, growT) end
    if not nextStageT then return end
local previousStageT = growT.stages[nextStageT.stageID-1]
local failChance = nextStageT.failChance

    if previousStageT then
        local itemRemoved = false
        for _, itemID in ipairs(previousStageT.itemID) do
            local item = findItem(itemID, pos)
            
            if item then
                local itemText = item:getAttribute(TEXT)
                
                for bonusStr, amount in pairs(farmingConf.nurture) do
                    if getFromText(bonusStr, itemText) then failChance = failChance - amount end
                end
                
                item:remove()
                itemRemoved = true
                break
            end
        end
        if not itemRemoved then return end
    end
local ground = Tile(pos):getGround()
local groundID = ground:getId()
local farmingLevel = ground:getText("farmingLevel") or 0

    failChance = failChance - farmingLevel * farmingConf.growLevelMultiplier
    if isInArray(farmingConf.grassTiles, groundID) then failChance = failChance - farmingConf.grassTileGrowBonus end
    
    if chanceSuccess(failChance) then
        if nextStageT.failID then createItem(randomValueFromTable(nextStageT.failID), pos) end
        doSendMagicEffect(pos, 17)
        ground:setActionId(0)
        building_registerFloor(groundID, 0, pos)
        return
    end
local plantID = randomValueFromTable(nextStageT.itemID)

    if nextStageT.nextStageID then
        local anotherStageT = growT.stages[nextStageT.nextStageID]
        createItem(plantID, pos, 1, nextStageT.itemAID, nil, "seedAID("..growT.seedAID..")")
        addEvent(farming_sprout, 5000, pos, growT, nextStageT.nextStageID)
   -- addEvent(farming_sprout, anotherStageT.growTimeMin*60*1000, pos, growT, nextStageT.nextStageID)
    else
        createItem(plantID, pos, 1, nextStageT.itemAID)
    end
    
    doSendMagicEffect(pos, 15)
    ground:setActionId(growT.backUpAID)
    building_registerFloor(groundID, 0, pos)
    building_saveHouseTile(pos)
end

function farming_loadPlant(pos, itemAID)
    for seedAID, growT in pairs(farmingConf.growT) do
        if growT.backUpAID and growT.backUpAID == itemAID then
            local herbT = herbs_getHerbT(seedAID)
            removeItemFromPos(8786, pos)
            
            if herbT then
                if findItem(herbT.itemID) then return true end
                return createItem(herbT.itemID, pos, 1, herbT.herbAID)
            end
            
            for _, itemID in ipairs(growT.plantID) do
                if findItem(itemID) then return true end
            end
            return createItem(randomValueFromTable(growT.plantID), pos)
        end
    end
end

function farmingMW_title(player) return "Your farming level is: "..player:getFarmingLevel().." ["..player:getFarmingExp().."/"..player:getFarmingTotalExp().."]" end

function farmingMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if choiceID == 1 then return player:createMW(MW.farming_herbs) end
    if choiceID == 2 then return player:createMW(MW.farming_trees) end
end

local function addChoice(player, growT)
    if not compareSV(player, growT.allSV, "==") then return end
    if not compareSV(player, growT.bigSV, ">=") then return end
    return true
end

function farming_treesMW_choices(player)
local choiceT = {}

    for seedAID, growT in pairs(farmingConf.growT) do
        if growT.isTree and addChoice(player, growT) then choiceT[growT.choiceID] = growT.name end
    end
    return choiceT
end

function farming_herbsMW_choices(player)
local choiceT = {}

    for seedAID, growT in pairs(farmingConf.growT) do
        if not growT.isTree and addChoice(player, growT) then choiceT[growT.choiceID] = growT.name end
    end
    return choiceT
end

local function  createDialogText(player, growT, objectStr, mwID)
    local chanceToGet = growT.chanceToGet + farming_getBonusFindSeedChance(player)
    local reqMsg = itemRequirementStr(growT.reqT)
    local totalGrowTime = 0
    local averageFailChance = 0
    local floorNames = {}

    for stageID, stageT in ipairs(growT.stages) do
        totalGrowTime = totalGrowTime + stageT.growTimeMin
        averageFailChance = averageFailChance + stageT.failChance
    end
    averageFailChance = math.ceil(averageFailChance/#growT.stages)

    for _, floorID in ipairs(growT.floorID) do
        local name = ItemType(floorID):getName()
        if not isInArray(floorNames, name) then table.insert(floorNames, name) end
    end
    local tipStr = "You can grow "..objectStr.."s only in your house!\n"
    local howToGetStr = "Use shovel on "..growT.name.." to find a seed.\n\n"
    local chanceToGetStr = "You have "..chanceToGet.."% chance to find "..growT.name.." seed.\n\n"
    local whereToPlantStr = "This "..objectStr.." can be planted on: "..tableToStr(floorNames, "-, ").." tiles.\n\n"
    local shovelChargesStr = "takes "..plural("charge", growT.shovelCharges).." from shovel when planting.\n\n"
    local growTimeStr = "It takes total of "..totalGrowTime.." minutes for "..objectStr.." to fully grow up.\n\n"
    local failStr = "Average fail chance troughout all stages is: "..averageFailChance.."%\n\n"
    local expStr = "planting "..growT.name.." gives "..growT.farmingExp.." farming experience."
        
    player:showTextDialog(growT.plantID[1], tipStr..howToGetStr..chanceToGetStr..whereToPlantStr..shovelChargesStr..growTimeStr..failStr..expStr)
    player:createMW(mwID)
end

function farming_treesMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.farming) end
    return createDialogText(player, farming_getGrowT(choiceID), "tree", mwID)
end

function farming_herbsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.farming) end
    return createDialogText(player, farming_getGrowT(choiceID), "herb", mwID)
end

-- get functions
function farming_getGrowT(object)
    if not object then return end
    
    if type(object) == "number" then
        for seedAID, growT in pairs(farmingConf.growT) do
            if isInArray(growT.plantID, object) or seedAID == object or growT.choiceID == object then return growT end
        end
    elseif type(object) == "table" and object.x then
        local itemList = Tile(object):getItemList()
        
        for _, itemT in ipairs(itemList) do
            local seedAID = getFromText("seedAID", itemT.itemText)
            if seedAID then return farming_getGrowT(seedAID) end
        end
    end
end

function farming_getStageT(pos, growT)
    for stageID, stageT in ipairs(growT) do
        for _, itemID in ipairs(stageT.plantID) do
            if findItem(itemID, pos) then return stageT end
        end
    end
end

function farming_getSeedName(itemAID, itemName)
    if not itemAID then return itemName end
    if itemAID == AID.building.smallFirTreeSeed then return "small fir tree seed" end
    if itemAID == AID.building.mireSproutSeed then return "mire sprout bush seed" end
    
    for seedAID, growT in pairs(farmingConf.growT) do
        if itemAID == seedAID then return growT.name.." seed" end
    end
    return itemName
end

function Player.addFarmingExp(player, amount)
local newLevel = professions_addExp(player, amount, farmingConf.professionT.professionStr)

    if not newLevel then return end
local msgT = farmingConf.levelUpMessages[newLevel] or {}

    player:sendTextMessage(GREEN, "Your farming skill is now level "..newLevel.."!")
    player:sendTextMessage(ORANGE, "farming levelUp: smaller chance for plant to fail when growing them")
    player:sendTextMessage(ORANGE, "farming levelUp: bigger chance to dig up and find good seeds")
    for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
end

function Player.getFarmingExp(player) return professions_getExp(player, farmingConf.professionT.professionStr) end
function Player.getFarmingLevel(player) return professions_getLevel(player, farmingConf.professionT.professionStr) end
function Player.getFarmingTotalExp(player) return professions_getTotalExpNeeded(player, farmingConf.professionT.professionStr) end

function farming_getBonusFindSeedChance(player) return player:getFarmingLevel(player) * farmingConf.findSeedLevelMultiplier end

-- other functions
function farming_fertilizeMud(player, item, toPos)
local tile = Tile(toPos)
    if not tile then return end
local ground = tile:getGround()
    if not ground then return end
    if not isInArray(farmingConf.mudTiles, ground:getId()) then return end
local grassTileID = randomValueFromTable(farmingConf.grassTiles)
    
    doSendMagicEffect(toPos, 15)
    ground:transform(grassTileID)
    return item:remove()
end

function farming_waterPlants(player, item, itemEx)
local toPos = itemEx:getPosition()
local tile = Tile(toPos)
    if not tile then return end
    
    for _, itemID in ipairs(farmingConf.growingPlants) do
        local plant = findItem(itemID, toPos)
        if plant then 
            doSendMagicEffect(toPos, 13)
            item:transform(item:getId(), 0)
            plant:setText("watered", "true")
            return true
        end
    end
end

function farming_herbRemove(item, herbT)
local itemPos = item:getPosition()
    
    item:remove()
    if not building_getHouseID(itemPos) then return  end
    if not chanceSuccess(farmingConf.herbRespawnChance) then
        building_saveHouseTile(itemPos)
        building_registerFloor(Tile(itemPos):getGround():getId(), 0, itemPos)
        return 
    end
local spawnSec = herbT.respawnSeconds or herbT.houseSpawnSec

    addEvent(createItem, spawnSec*1000, herbT.itemID, itemPos, 1, herbT.herbAID)
end