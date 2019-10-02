--[[ skeletonWarriorAreaConf guide
    litPillarID = INT,          itemID for pillar what turns into unlitPillarID | pillars changed with globalevent > skeletonWarriorRoom_spawn
    unlitPillarID = INT,        itemID for pillar what will summon Skeleton Warrior
    leverID = INT,              levers which will be registered for each room leverPosT*
    
    skeleOpensDoorTime = INT,   in milliseconds when skeleton can open door again
    closeDoorTime = INT,        in milliseconds when skeleton doors close after they opened
    
    rooms = {{
        upCorner = POS
        downCorner = POS
        leavePos = POS          position where player will be sent from teleport out tile or with logout
        
        -- AUTOMATIC
        leverState = INT        either 1 or 2 | used in openDoors()
        leverDoorPosT = {POS}   lever door position which will be opened or closed
        leverPosT = {POS}       lever positions which will be switched
    }}
    leverDoors = {              in which direction items move
        [INT] = STR,            INT = itemID | STR = direction ("N", "S", "W", "E")
    },
    skeletonDoors = {           in which direction items move
        [INT] = STR,            INT = itemID | STR = direction ("N", "S", "W", "E")
    },
]]

local AIDT = AID.areas.skeletonWarriorRoom
if not skeletonWarriorAreaConf then
skeletonWarriorAreaConf = {
    litPillarID = 7059,
    unlitPillarID = 7058,
    leverID = 9827,
    skeleOpensDoorTime = 25000,
    closeDoorTime = 10000,
    
    rooms = {
        [1] = {
            upCorner = {x = 555, y = 755, z = 8},
            downCorner = {x = 593, y = 788, z = 8},
            leavePos = {x = 594, y = 758, z = 8},
        },
        [2] = {
            upCorner = {x = 552, y = 788, z = 9},
            downCorner = {x = 590, y = 824, z = 9},
            leavePos = {x = 562, y = 788, z = 9},
        }
    },
    leverDoors = {
        [12940] = "N",
        [12941] = "S",
        [12938] = "W",
        [12939] = "E",
    },
    skeletonDoors = {
        [12857] = "N",
        [12859] = "S",
        [12860] = "W",
        [12862] = "E",
    },
}

local areaCorners = {{upCorner = {x = 560, y = 786, z = 9}, downCorner = {x = 563, y = 787, z = 9}}}
for _, roomT in ipairs(skeletonWarriorAreaConf.rooms) do table.insert(areaCorners, {upCorner = roomT.upCorner, downCorner = roomT.downCorner}) end

rootedCatacombsSkeletonWarriorsRoom = {
    name = "Skeleton Warrior room",
    startUpFunc = "skeletonWarriorRoom_startUp",
    area = {
        areaCorners = areaCorners,
        setActionID = {
            [415] = AIDT.escapeTile,
            [skeletonWarriorAreaConf.litPillarID] = AIDT.litPillar,
            [skeletonWarriorAreaConf.leverID] = AIDT.doorLevers,
        },
    },
    AIDItems = {
        [AIDT.doorLevers] = {funcSTR = "skeletonWarriorRoom_lever"},
        [AIDT.ladderUp] = {teleport = {x = 594, y = 758, z = 8}},
        [AIDT.litPillar] = {transform = {itemID = 7058, itemAID = AIDT.unlitPillar}},
        [AIDT.unlitPillar] = {transform = {itemID = 7059, itemAID = AIDT.litPillar}},
        [AIDT.room2_rail] = {funcSTR = "skeletonWarrionRoom2_closeDoorsRail"},
    },
    AIDItems_onLook = {
        [AIDT.escapeTile] = {text = {msg = "Wait on this tile for 60 seconds if you want to teleport out of this maze."}},
        [AIDT.litPillar] = {text = {msg = "Skeleton Warrior Altar - activated"}},
        [AIDT.unlitPillar] = {text = {msg = "Skeleton Warrior Altar"}},
        [AIDT.skeletonBomb] = {text = {msg = "Skeleton Warrior Bomb"}},
    },
    AIDTiles_stepIn = {
        [AIDT.escapeTile] = {funcSTR = "skeletonWarriorRoom_escapeTileStepIn"},
    },
    AIDTiles_stepOut = {
        [AIDT.escapeTile] = {funcSTR = "skeletonWarriorRoom_escapeTileStepOut"},
    },
}
centralSystem_registerTable(rootedCatacombsSkeletonWarriorsRoom)
end

function skeleton_getDoor(pos)
    for itemID, direction in pairs(skeletonWarriorAreaConf.leverDoors) do
        local door = findItem(itemID, pos)
        if door then return door, "leverDoors" end
    end
    for itemID, direction in pairs(skeletonWarriorAreaConf.skeletonDoors) do
        local door = findItem(itemID, pos)
        if door then return door, "skeletonDoors" end
    end
end

function skeletonWarriorRoom_startUp()
    local pillarPosT = {}
    local leverPosT = {}
    local leverDoorPosT = {}
        
    local function registerDoor(pos)
        local door, doorTKey = skeleton_getDoor(pos)
        if not door then return end
        local direction = skeletonWarriorAreaConf[doorTKey][door:getId()]
        
        if not direction then return end
        if doorTKey == "leverDoors" then
            table.insert(leverDoorPosT, pos)
            table.insert(leverDoorPosT, getDirectionPos(pos, direction))
        end
        return door:setText("direction", direction)
    end
    
    local function registerObject(pos)
        if registerDoor(pos) then return end
        if findItem(skeletonWarriorAreaConf.leverID, pos) then return table.insert(leverPosT, pos) end
        if findItem(skeletonWarriorAreaConf.litPillarID, pos) then return table.insert(pillarPosT, pos) end
    end
    
    for _, roomT in ipairs(skeletonWarriorAreaConf.rooms) do
        local area = createSquare(roomT.upCorner, roomT.downCorner)
        leverPosT = {}
        leverDoorPosT = {}
        
        for _, pos in pairs(area) do registerObject(pos) end
        roomT.leverPosT = leverPosT
        roomT.leverDoorPosT = leverDoorPosT
        roomT.leverState = 2
    end
    
    skeletonWarriorAreaConf.pillarPosT = pillarPosT
end

local function autoCloseDoor(pos)
    local door = skeleton_getDoor(pos)
    if door then skeletonWarriorRoom_changeDoor(door, "close") end
end

function skeletonWarrionRoom2_closeDoorsRail(player, item)
    local roomT = getSkeletonWarriorRoomT(player)
        
    climbOn(player, item)
    
    for _, pos in pairs(roomT.leverDoorPosT) do
        local door = skeleton_getDoor(pos)
        if door then skeletonWarriorRoom_changeDoor(door, "close") end
    end
end

function skeletonWarriorRoom_changeDoor(door, action, autoClose)
    local itemText = door:getAttribute(TEXT)
    local doorState = getFromText("state", itemText) or "close"

    action = action or "open"
    if action == "open" and doorState == "open" then return end
    if action == "close" and doorState == "close" then return end

    local doorPos = door:getPosition()
    local openDirection = getFromText("direction", itemText)
    local moveDirection = openDirection

    if action == "close" then moveDirection = reverseDir(openDirection) end
    local newPos = getDirectionPos(doorPos, moveDirection)

    door:moveTo(newPos)
    door:setText("state", action)
    if autoClose then addEvent(autoCloseDoor, autoClose, newPos) end
end

local function openDoors(pos)
    local door = skeleton_getDoor(pos)
    if not door then return end

    local openDirection = door:getText("direction")
    local roomT = getSkeletonWarriorRoomT(door)
    local directions = {
        [1] = {"W", "E"},
        [2] = {"N", "S"},
    }
    if isInArray(directions[roomT.leverState], openDirection) then
        skeletonWarriorRoom_changeDoor(door)
    else
        skeletonWarriorRoom_changeDoor(door, "close")
    end
end

function skeletonWarriorRoom_lever(player, item)
    local roomT = getSkeletonWarriorRoomT(item)
    local newState = roomT.leverState == 1 and 2 or 1

    for _, pos in pairs(roomT.leverDoorPosT) do openDoors(pos) end
    for _, pos in pairs(roomT.leverPosT) do changeLever(pos) end
    roomT.leverState = newState
end

local skeleOpenedDoor = {}
function skeletonWarriorAI(monster)
    if monster:getRealName() ~= "skeleton warrior" then return end
    local mid = monster:getId()
    if skeleOpenedDoor[mid] then return end
    local monsterPos = monster:getPosition()
    local area = getAreaAround(monsterPos, 3)
    
    for _, pos in pairs(area) do
        local door = skeleton_getDoor(pos)
        
        if door then
            local dir = skeletonWarriorAreaConf.skeletonDoors[door:getId()]
            if dir == "W" or dir == "E" then
                skeleOpenedDoor[mid] = true
                skeletonWarriorRoom_changeDoor(door, "open", skeletonWarriorAreaConf.closeDoorTime)
                addEvent(function() skeleOpenedDoor[mid] = nil end, skeletonWarriorAreaConf.skeleOpensDoorTime)
            end
        end
    end
end

function skeletonWarriorRoom_TPOut(player)
    local roomT = getSkeletonWarriorRoomT(player)
    return roomT and teleport(player, roomT.leavePos)
end

function skeletonWarriorRoom_escapeTileStepIn(player, tile)
    local waitTime = 45*1000
    local roomT = getSkeletonWarriorRoomT(player)
    local playerID = player:getId()
    local eventData = {teleport, playerID, roomT.leavePos}

    doSendMagicEffect(player:getPosition(), 14)
    registerAddEvent("SWRoom_escapeTile", playerID, waitTime, eventData)
end

function getSkeletonWarriorRoomT(object)
    local objectPos = object:getPosition()
    
    for _, roomT in ipairs(skeletonWarriorAreaConf.rooms) do
        if isInRange(objectPos, roomT.upCorner, roomT.downCorner) then return roomT end
    end
end

function skeletonWarriorRoom_escapeTileStepOut(player, item)
    doSendMagicEffect(player:getPosition(), 24)
    stopAddEvent("SWRoom_escapeTile", player:getId())
end

local function turnLightsOff(pos) return doTransform(skeletonWarriorAreaConf.litPillarID, pos, skeletonWarriorAreaConf.unlitPillarID, AIDT.unlitPillar) end

function skeletonWarriorRoom_spawn(minutesPassed)
    if minutesPassed%2 == 0 then return end
    local skelePawnsPosT = skeletonWarriorAreaConf.pillarPosT

    for _, pos in pairs(skelePawnsPosT) do
        if not turnLightsOff(pos) then trySummonSkeletonWarrior(pos) end
    end
end

function trySummonSkeletonWarrior(pos)
    local pillar = findItem(skeletonWarriorAreaConf.unlitPillarID, pos)
    if not pillar then return end

    local itemText = pillar:getAttribute(TEXT)
    local monsterID = getFromText("monsterID", itemText) 
    if monsterID and Monster(monsterID) then return end
    local postions = getAreaAround(pos)

    for i, pos2 in pairs(postions) do
        addEvent(doSendDistanceEffect, i*250,pos2, pos, 37)
        addEvent(doSendMagicEffect, 2000, pos2, 10)
    end
    addEvent(doSendMagicEffect, 2500, pos, 10)
    addEvent(summonSkeletonWarrior, 2500, pos)
end

function summonSkeletonWarrior(pos)
    local pillar = findItem(skeletonWarriorAreaConf.unlitPillarID, pos)
    if not pillar then return print("ERROR in summonSkeletonWarrior()") end
    local monster = createMonster("skeleton warrior", pos)    
    pillar:setText("monsterID", monster:getId())
    doTransform(skeletonWarriorAreaConf.unlitPillarID, pos, skeletonWarriorAreaConf.litPillarID, AIDT.litPillar)
end