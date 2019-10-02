-- if variable has "--" in front of it, then it is added automatically

--[[ bombermanConf guide
    destroyable = {INT}                 list of itemID's which are destroyed by bomb explosions
    enterPositions = {                  positions from where the players are entered to game
        [INT] = {POS}                   INT is the leverAID | item actionID which onUse chooses bomberman map and teleports players from {POS} to mapT.startPositions
    },
    leavePos = POS or townPos           position where player is teleported when bomberman event ends for him
    mapSV = INT                         storage value what holds the bomberman mapID where player is
    bombsLeftSV = INT                   how many bombs can player place down more
    bombPowerSV = INT                   how strong is bomb explosion
    bombID = INT                        itemID what bomb looks like
    bombExplosionSec = INT or 3         in seconds when bomb explodes after planting
    bombExplosionEffect = INT or 7      ENUM for the explosion effect
    kickMsg = STR                       message what payer gets when they get kicked out of event
    winMsg = STR                        message what payer gets when they win event
    
    bonusItems = {
        [STR] = {                       bonus name
            chance = INT or 10          chance to drop in % when destroyable has been destroyed with bomb
            itemID = INT                
            itemAID = INT
            effects = {INT}             magic effects when item is picked up
        }
    },
    
    rewardItems = {{                    items what player receives when they win event
        itemID = INT,                   if itemID is table then picks random ID
        count = INT or 1,
        itemAID = INT,
        itemText = STR,
        fluidType = INT
    }},
    
    maps = {
        [INT] = {                       mapID
            upCorner = POS,             map most left up position
            downCorner = POS,           map most right down position
            startPositions = {POS},     positions where player start bomberman (in sequence)
            --mapID = INT               table key
            --players = {INT}           list of player:getId() who are playing on the map
            --maxPlayerCount = INT      how many players can this map have
        },
    },
    
    --bonusItemChances = {              table generated to accurately calculate what bonus drops
        [STR] = {min = INT, max = INT}  STR == bonusName
    }
]]

local AIDT = AID.games.bomberman
bombVersion2 = true     -- if true then all bomb explosions are sequenced and explosion travels 1 tile by tile

bombermanConf = {
    destroyable = {2767, 4010, 4012, 4013, 4014, 4018},
    enterPositions = {
        [AIDT.lever1] = {
            {x = 704, y = 739, z = 7},
            {x = 702, y = 740, z = 7},
            {x = 703, y = 740, z = 7},
            {x = 704, y = 740, z = 7},
            {x = 705, y = 740, z = 7},
            {x = 706, y = 740, z = 7},
        },
    },
    leavePos = {x = 704, y = 741, z = 7},
    mapSV = SV.bomberman_mapID,
    bombsLeftSV = SV.bomberman_bombsLeft,
    bombPowerSV = SV.bomberman_bombPower,
    bombID = 9469,
    bombExplosionSec = 3,
    bombExplosionEffect = 7,
    kickMsg = "You have been kicked out bomberman event! Time for revenge! Right?",
    winMsg = "Why you so sad? You won!!",
    rewardItems = {itemID = ITEMID.other.coin, count = 2},
    
    bonusItems = {
        ["speed boost"] = {
            chance = 12,
            itemID = 2195,
            itemAID = AIDT.bonus_speed,
            info = "Step on item to increase player speed",
            effects = {5, 15},
            stackSV = SV.bomberman_speedStack,  -- storage value what keeps track of how many times player speed is stacked
            speedAmount = 25,                   -- how much extra speed players gets for each collected speed boost
        },
        ["extra bomb"] = {
            chance = 12,
            itemID = 4850,
            itemAID = AIDT.bonus_bomb,
            info = "Step on item to get additional bomb",
            effects = {18, 19},
        },
        ["bomb power"] = {
            chance = 12,
            itemID = 10988,
            itemAID = AIDT.bonus_power,
            info = "Step on item to increase bomb explosion radius",
            effects = {30, 37},
        },
    },
    
    maps = {
        [1] = {
            upCorner = {x = 710, y = 735, z = 7},
            downCorner = {x = 726, y = 745, z = 7},
            startPositions = {
                {x = 714, y = 740, z = 7},
                {x = 722, y = 740, z = 7},
                {x = 710, y = 735, z = 7},
                {x = 726, y = 745, z = 7},
                {x = 710, y = 745, z = 7},
                {x = 726, y = 735, z = 7},
            },
        },
    },
}

bomberman_objects = {
    startUpFunc = "bomberman_startUp",
    AIDItems = {
        [AIDT.lever1] = {funcStr = "bomberman_onUseLever"},
        [AIDT.enter] = {funcStr = "bomberman_enter"},
    },
    AIDTiles_stepIn = {
        [AIDT.bonus_speed] = {funcStr = "bomberman_stepIn_speedBoost"},
        [AIDT.bonus_bomb] = {funcStr = "bomberman_stepIn_extraBomb"},
        [AIDT.bonus_power] = {funcStr = "bomberman_stepIn_bombPower"},
        [AIDT.leave] = {funcStr = "bomberman_leave"},
    },
    onLogin = {funcStr = "bomberman_onLogin"},
    mapEffects = {
        ["bomberman sign"] = {pos = {x = 572, y = 656, z = 7}, me = 37},
    },
}

centralSystem_registerTable(bomberman_objects)

function bomberman_startUp()
local configKeys = {"destroyable", "enterPositions", "leavePos", "maps", "bombID", "bombsLeftSV", "bombPowerSV", "mapSV", "bombExplosionSec", "bombExplosionEffect", "kickMsg", "winMsg", "rewardItems", "bonusItems"}
local errorMsg = "bombermanConf"
local IDList = {}

    local function missingError(missingKey, errorMsg) print("ERROR - missing value in "..errorMsg..missingKey) end
    
    if not bombermanConf.bombID then missingError("bombID", errorMsg) end
    if not bombermanConf.bombsLeftSV then missingError("bombsLeftSV", errorMsg) end
    if not bombermanConf.bombPowerSV then missingError("bombPowerSV", errorMsg) end
    if not bombermanConf.mapSV then missingError("mapSV", errorMsg) end
    if not bombermanConf.destroyable then missingError("destroyable", errorMsg) end
    if not bombermanConf.bonusItems then return missingError("bonusItems", errorMsg) end
    if not bombermanConf.enterPositions then return missingError("enterPositions", errorMsg) end
    if not bombermanConf.maps then return missingError("maps", errorMsg) end
    if not bombermanConf.bombExplosionSec then bombermanConf.bombExplosionSec = 3 end
    if not bombermanConf.bombExplosionEffect then bombermanConf.bombExplosionEffect = 7 end
    if bombermanConf.rewardItems and bombermanConf.rewardItems.itemID then bombermanConf.rewardItems = {bombermanConf.rewardItems} end
    
    for key, v in pairs(bombermanConf) do
        if not isInArray(configKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
    end
    
    local function checkPos(pos, errorMsg)
        if type(pos) ~= "table" then return print("ERROR - WRONG VALUE in "..errorMsg.." (POS should be written like this: {x=INT, y=INT, z=INT})") end
        if not pos.x or not pos.y or not pos.z then return print("ERROR - WRONG VALUE in "..errorMsg.."(POS should be written like this: {x=INT, y=INT, z=INT})") end
        if not Tile(pos) then return print("ERROR - Position("..pos.x..", "..pos.y..", "..pos.z..") does no exist on the map (pos taken from: "..errorMsg) end
    end
    
    local function checkPosT(t, key, errorMsg, requiredPositionAmount)
        local posT = t[key]
        if not posT then return missingError(key, errorMsg) end
        errorMsg = errorMsg..key
        if not requiredPositionAmount then return checkPos(posT, errorMsg) end
        if tableCount(posT) < requiredPositionAmount then print("ERROR - need more positions inside "..errorMsg) end
        for _, pos in pairs(posT) do checkPos(pos, errorMsg) end
    end
    
    for leverAID, posT in pairs(bombermanConf.enterPositions) do
        local errorMsg = errorMsg..".enterPositions["..leverAID.."]"
        if not tonumber(leverAID) then print("ERROR - leverAID must be number ["..leverAID.."] in "..errorMsg) end
        checkPosT(bombermanConf.enterPositions, leverAID, errorMsg, 2)
    end
local totalPercent = 0

    for bonusName, bonusT in pairs(bombermanConf.bonusItems) do
        local errorMsg = errorMsg..".bonusItems["..bonusName.."]"
        if not bonusT.chance then bonusT.chance = 10 end
        if not bonusT.itemID then missingError("itemID", errorMsg) end
        if not bonusT.info then missingError("info", errorMsg) end
        if not bonusT.itemAID then
            missingError("itemAID", errorMsg)
        else
            AIDItems_onLook[bonusT.itemAID] = {text = {msg = bonusT.info}}
        end
        totalPercent = totalPercent + bonusT.chance
    end
    
    if totalPercent < 100 then
        bombermanConf.bonusItems.nothing = {chance = 100-totalPercent}
        totalPercent = 100
    end
local chanceT = {}
local multiplier = math.floor(1000/totalPercent)
local tableAmount = tableCount(bombermanConf.bonusItems)
local previousValue = 0

    while tableCount(chanceT) ~= tableAmount do
        local lowestValue = 1001
        local tempID
        
        for bonusName, bonusT in pairs(bombermanConf.bonusItems) do
            if lowestValue > bonusT.chance and not chanceT[bonusName] then
                lowestValue = bonusT.chance
                tempID = bonusName
            end
        end
        
        local newChance = lowestValue * multiplier
        
        if previousValue == 0 then
            chanceT[tempID] = {min = 1, max = newChance}
        elseif tableCount(chanceT) == tableAmount - 1 then
            chanceT[tempID] = {min = previousValue + 1, max = 1000}
        else
            newChance = newChance + previousValue
            chanceT[tempID] = {min = previousValue + 1, max = newChance}
        end
        previousValue = newChance
    end
    
    for mapID, mapT in pairs(bombermanConf.maps) do
        local errorMsg = errorMsg..".maps["..mapID.."]"
        local configKeys = {"upCorner", "downCorner", "startPositions"}
        local loopID = 0
        
        if not tonumber(mapID) then print("ERROR - mapID must be number ["..mapID.."] in "..errorMsg) end
        if IDList[mapID] then print("ERROR - duplicated mapID ["..mapID.."] in "..errorMsg) end
        for key, v in pairs(mapT) do
            if not isInArray(configKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
        end
        checkPosT(mapT, "upCorner", errorMsg)
        checkPosT(mapT, "downCorner", errorMsg)
        checkPosT(mapT, "startPositions", errorMsg, 2)
        mapT.noSpawnPosT = {}
        
        for _, pos in pairs(mapT.startPositions) do
            local area = getAreaAround(pos)
            loopID = loopID + 1
            mapT.noSpawnPosT[loopID] = pos
            
            for _, pos in ipairs(area) do
                loopID = loopID + 1
                mapT.noSpawnPosT[loopID] = pos
            end
        end
        
        mapT.maxPlayerCount = tableCount(mapT.startPositions)
        mapT.mapID = mapID
        mapT.players = {}
        IDList[mapID] = true
    end
    
    bombermanConf.bonusItemChances = chanceT
    if bombermanConf.leavePos then checkPosT(bombermanConf, "leavePos", errorMsg) end
    IDList = nil
end

function bomberman_onLogin(player)
    if player:getLevel() < 3 then player:sendTextMessage(ORANGE, "You can enter bomberman event with command !bomberman") end
end

function bomberman_onUseLever(player, item)
local playerList = bomberman_getPlayersFromEnterPos(item:getActionId())
local playerCount = tableCount(playerList)
local mapT = bomberman_findMap(player, playerCount)
    
    changeLever(item)
    if not mapT then return end
    bomberman_resetMap(mapT.mapID)
    
    for i, player in ipairs(playerList) do
        mapT.players[i] = player:getId()
        teleport(player, mapT.startPositions[i])
        setSV(player, bombermanConf.bombsLeftSV, 1)
        setSV(player, bombermanConf.bombPowerSV, 1)
        setSV(player, bombermanConf.mapSV, mapT.mapID)
        player:sendTextMessage(BLUE, "You can put down bomb with command !bomb")
        player:sendTextMessage(GREEN, "You can put down bomb with command !bomb")
    end
end

function bomberman_unregister(player, notFullCode)
local mapT = bomberman_getMapT(player)
    if not mapT then return end
local leavePos = bombermanConf.leavePos or player:homePos()
    
    teleport(player, leavePos)
    removeSV(player, bombermanConf.mapSV)
    removeCondition(player, "bomberman_speed")
    
    for bonusName, bonusT in pairs(bombermanConf.bonusItems) do
        if bonusT.stackSV then removeSV(player, bonusT.stackSV) end
    end
    
    if notFullCode then return end
    mapT.players = removeFromTable(mapT.players, player:getId())
    if tableCount(mapT.players) == 1 then bomberman_endEvent(mapT.mapID) end
end

function bomberman_endEvent(mapID)
local mapT = bomberman_getMapT(mapID)
    if not mapT then return print("ERROR in bomberman_endEvent() - bomberman event doesnt have map with mapID: "..mapID) end
local winnerID
local noWinners = false
    
    local function abortEvent(playerID)
        local player = Player(playerID)
        if not player then return end
        player:sendTextMessage(GREEN, "Bomberman event has ended forcefully. No rewards were handed out")
        bomberman_unregister(player, true)
    end
    
    for _, playerID in pairs(mapT.players) do
        if winnerID then noWinners = true else winnerID = playerID end
        if noWinners then abortEvent(playerID) end
    end
    
    mapT.players = {}
    if noWinners then return abortEvent(winnerID) end
local player = Player(winnerID)

    if not player then return end
    bomberman_unregister(player, true)
    player:sendTextMessage(GREEN, bombermanConf.winMsg)
    if bombermanConf.rewardItems then player:rewardItems(bombermanConf.rewardItems, true) end
end

local function removeBonusFromPos(pos)
    for bonusName, bonusT in pairs(bombermanConf.bonusItems) do
        if bonusT.itemID then removeItemFromPos(bonusT.itemID, pos) end
    end
end

local function spawnDestroyableObject(mapT, pos)
    if comparePositionT(mapT.noSpawnPosT, pos) then return end
local itemID = randomValueFromTable(bombermanConf.destroyable)
    
    createItem(itemID, pos)
end

function bomberman_resetMap(mapID)
local mapT = bomberman_getMapT(mapID)
local map = createSquare(mapT.upCorner, mapT.downCorner)
    
    map = removePositions(map, "solid")
    
    for _, pos in pairs(map) do
        removeBonusFromPos(pos)
        spawnDestroyableObject(mapT, pos)
    end
end

function bomberman_findMap(player, playerCount)
    if playerCount < 2 then return false, player:sendTextMessage(GREEN, "You need at least 2 participants to enter bomberman event") end
    
    for mapID, mapT in pairs(bombermanConf.maps) do
        if playerCount <= mapT.maxPlayerCount and tableCount(mapT.players) == 0 then return mapT end
    end
    
    player:sendTextMessage(GREEN, "All bomberman maps for "..playerCount.." are in use.")
end

function bomberman_bomb_plant(player)
local mapT = bomberman_getMapT(player)
    if not mapT then return end
local bombsLeft = getSV(player, bombermanConf.bombsLeftSV)
    if bombsLeft < 1 then return player:sendTextMessage(GREEN, "You don't have any more bombs left") end
local playerPos = player:getPosition()
    if findItem(bombermanConf.bombID, playerPos) then return player:sendTextMessage(GREEN, "You can't stack bombs on same position") end

    createItem(bombermanConf.bombID, playerPos, 1, nil, nil, "playerID("..player:getId()..")")
    addSV(player, bombermanConf.bombsLeftSV, -1)
    addEvent(bomberman_bomb_explode, bombermanConf.bombExplosionSec*1000, playerPos)
end

function bomberman_bomb_explode(pos)
local bomb = findItem(bombermanConf.bombID, pos)
    if not bomb then return end
local playerID = bomb:getText("playerID")
local bombPower = getSV(playerID, bombermanConf.bombPowerSV) or 1
    
    local function destroyObject(pos)
        local destroyableItem
        
        for _, itemID in ipairs(bombermanConf.destroyable) do
            destroyableItem = findItem(itemID, pos)
            if destroyableItem then break end
        end
        
        if not destroyableItem then return not findItem(bombermanConf.bombID, pos) and hasObstacle(pos, "solid") end
        bomberman_createBonus(pos)
        return destroyableItem:remove()
    end
    
    local function explode2(pos)
        doSendMagicEffect(pos, bombermanConf.bombExplosionEffect)
        if destroyObject(pos) then return true end
        bomberman_kick(pos)
        removeBonusFromPos(pos)
        addEvent(bomberman_bomb_explode, 150, pos)
    end
    
    local function explode(startPos, currentDistance, bombPower, direction)
        if currentDistance > bombPower then return end
        local pos = getDirectionPos(startPos, direction, currentDistance)
        if not Tile(pos) then return end
        local destroyableItem
        
        for _, itemID in ipairs(bombermanConf.destroyable) do
            destroyableItem = findItem(itemID, pos)
            if destroyableItem then break end
        end
        
        doSendMagicEffect(pos, bombermanConf.bombExplosionEffect)
        
        if destroyableItem then 
            bomberman_createBonus(pos)
            return destroyableItem:remove()
        end
        
        bomberman_kick(pos)
        removeBonusFromPos(pos)
        addEvent(bomberman_bomb_explode, 100, pos)
        if hasObstacle(pos, "solid") and not findItem(bombermanConf.bombID, pos) then return end
        addEvent(explode, 100, startPos, currentDistance + 1, bombPower, direction)
    end
    
    addSV(playerID, bombermanConf.bombsLeftSV, 1)
    bomb:remove()
    explode2(pos)
    
    for _, direction in ipairs(compass1) do explode(pos, 1, bombPower, direction) end
end

function bomberman_createBonus(pos)
local randomN = math.random(1, 1000)
    
    for bonusName, chanceT in pairs(bombermanConf.bonusItemChances) do
        if randomN >= chanceT.min and randomN <= chanceT.max then
            local bonusT = bombermanConf.bonusItems[bonusName]
            if bonusT.itemID then createItem(bonusT.itemID, pos, 1, bonusT.itemAID) end
            return
        end
    end
end

function bomberman_kick(player)
    if type(player) == "table" and player.x then player = Tile(player):getBottomCreature() end
    if not Player(player) then return end
    if bombermanConf.kickMsg then player:sendTextMessage(GREEN, bombermanConf.kickMsg) end
    bomberman_unregister(player)
end

function bomberman_stepIn_speedBoost(player, item)
local bonusT = bomberman_getBonusT(item:getActionId())
    addSV(player, bonusT.stackSV, 1)
local stack = getSV(player, bonusT.stackSV)
local newSpeed = bonusT.speedAmount * stack
    
    bindCondition(player, "bomberman_speed", -1, {speed = newSpeed})
    doSendMagicEffect(item:getPosition(), bonusT.effects)
    item:remove()
end

function bomberman_stepIn_extraBomb(player, item)
local bonusT = bomberman_getBonusT(item:getActionId())
    
    addSV(player, bombermanConf.bombsLeftSV, 1)
    doSendMagicEffect(item:getPosition(), bonusT.effects)
    item:remove()
end

function bomberman_stepIn_bombPower(player, item)
local bonusT = bomberman_getBonusT(item:getActionId())
    
    addSV(player, bombermanConf.bombPowerSV, 1)
    doSendMagicEffect(item:getPosition(), bonusT.effects)
    item:remove()
end

function bomberman_enter(player, item) teleport(player, {x = 704, y = 741, z = 7}) end

function bomberman_leave(player, item)
    if player:getSV(SV.tutorial) ~= 1 then return teleport(player, {x = 524, y = 738, z = 8}) end
    teleport(player, player:homePos())
end

-- get functions
function bomberman_getBonusT(itemAID)
    for bonusName, bonusT in pairs(bombermanConf.bonusItems) do
        if bonusT.itemAID and bonusT.itemAID == itemAID then return bonusT end
    end
end

function bomberman_getMapT(object)
    if type(object) == "number" then return bombermanConf.maps[object] end
    if type(object) == "userdata" then return bomberman_getMapT(getSV(object, bombermanConf.mapSV)) end
end

function bomberman_getPlayersFromEnterPos(leverAID)
local playerList = {}

    for _, pos in ipairs(bombermanConf.enterPositions[leverAID]) do
        local tile = Tile(pos)
        local creature = tile:getBottomCreature()
        if creature and creature:isPlayer() then table.insert(playerList, creature) end
    end
    return playerList
end