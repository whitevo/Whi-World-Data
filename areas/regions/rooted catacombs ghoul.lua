--[[ ghoul area config guide
    poisonFieldArea = {         -- passage to ghoul rooms
        areaCorners = {upCorner = POS, downCorner = POS},
        poisonFieldID = INT,    -- itemID
        minDam = INT,           -- poison field damage
        maxDam = INT,           -- poison field damage
    }
    
    ghoulRoomConf = {
        goodTileID = 419,           -- has to step on these
        badTileID = 790,            -- good tiles turn into this, stepping twice on this will fail the the room
        ladderDownID = 428,
        ladderUpID = 1386,
        requiredTilePercent = INT   -- percent amount how many tiles need to be turned
        
        ghoulRooms = {{
            areaCorners = {upCorner = POS, downCorner = POS},
            ghoulPos = {POS},       -- positions where ghouls spawn
            teleportToPos = POS     -- position where player is teleported when room is completed
            restartPos = POS        -- position where player is teleported when room is failed
            finishPos = POS         -- object appears on this position when room is completed
            itemID = INT            -- object what is created on finishPos
            itemAID = INT           -- actionID for itemID
            nextFloorID = INT       -- used to reset next room if this one is completed
            
            AUTOMATIC
            ghoulIDT = {},          -- stores all ghoul ID's
            tilesLeft = INT         -- how many tiles has been stepped on
            totalTiles = INT        -- total amount of good tiles in the room
            floorPosZ = INT         -- z position taken from upCorner
            floorTileID = INT       -- itemID for original floorID | makes it possible to use ground tiles for itemID
        }}
    }
]]

local AIDT = AID.areas.ghoulRoom
if not ghoulAreaConf then
ghoulAreaConf = {
    poisonFieldArea = {
        areaCorners = {upCorner = {x = 614, y = 732, z = 8}, downCorner = {x = 623, y = 747, z = 8}},
        poisonFieldID = 1496,
        minDam = 200,
        maxDam = 300,
    },
    
    ghoulRoomConf = {
        goodTileID = 419,
        badTileID = 790,
        ladderDownID = 428,
        ladderUpID = 1386,
        requiredTilePercent = 90,   
        
        ghoulRooms = {
            [1] = {
                areaCorners = {upCorner = {x = 624, y = 725, z = 8}, downCorner = {x = 642, y = 741, z = 8}},
                ghoulPos = {
                    {x = 639, y = 733, z = 8},
                    {x = 640, y = 728, z = 8},
                    {x = 640, y = 738, z = 8},
                    {x = 616, y = 732, z = 8},
                },
                teleportToPos = {x = 632, y = 732, z = 9},
                restartPos = {x = 621, y = 733, z = 8},
                finishPos = {x = 633, y = 733, z = 8},
                nextFloorID = 2,
                itemID = 8280,
                itemAID = AIDT.ladderDown,
            },
            [2] = {
                areaCorners = {upCorner = {x = 623, y = 724, z = 9}, downCorner = {x = 641, y = 740, z = 9}},
                ghoulPos = {
                    {x = 625, y = 731, z = 9},
                    {x = 625, y = 732, z = 9},
                    {x = 625, y = 733, z = 9},
                },
                teleportToPos = {x = 632, y = 731, z = 10},
                restartPos = {x = 626, y = 726, z = 9},
                finishPos = {x = 633, y = 731, z = 9},
                itemID = 8280,
                itemAID = AIDT.ladderDown,
            },
            [3] = {
                areaCorners = {upCorner = {x = 624, y = 725, z = 12}, downCorner = {x = 642, y = 741, z = 12}},
                ghoulPos = {
                    {x = 632, y = 739, z = 12},
                    {x = 633, y = 727, z = 12},
                    {x = 628, y = 733, z = 12},
                    {x = 628, y = 734, z = 12},
                    {x = 638, y = 733, z = 12},
                    {x = 638, y = 734, z = 12},
                },
                teleportToPos = {x = 639, y = 733, z = 11},
                restartPos = {x = 633, y = 733, z = 12},
                finishPos = {x = 640, y = 732, z = 12},
                itemID = 1386,
                itemAID = AIDT.finishGhoulRoomOnUse,
            }
        }
    }
}

local areaCorners = {ghoulAreaConf.poisonFieldArea.areaCorners}
for _, roomT in ipairs(ghoulAreaConf.ghoulRoomConf.ghoulRooms) do table.insert(areaCorners, roomT.areaCorners) end

local rootedCatacombsGhoulRoom = {
    name = "Ghoul room",
    startUpFunc = "ghoulRoom_startUp",
    area = {
        areaCorners = areaCorners,
        blockObjects = {708},
    },
    AIDItems = {
        [AIDT.leaveGhoulRoom] = {teleport = {x = 619, y = 733, z = 8}},
        [AIDT.finishGhoulRoomOnUse] = {funcSTR = "ghoulRoom_completeFloor"},
    },
    AIDItems_onLook = {
        [AIDT.leaveGhoulRoom] = {text = {msg = "takes you out of the ghoul room"}},
    },
    AIDTiles_stepIn = {
        [AIDT.ghoulGasField] = {funcSTR = "ghoul_gasField"},
        [AIDT.ghoul_bodyRemains] = {funcSTR = "ghoul_bodyRemains"},
        [AIDT.colorTile] = {funcSTR = "ghoulRoom_colorTile"},
        [AIDT.ladderDown] = {funcSTR = "ghoulRoom_completeFloor"},
        [AIDT.enterGhoulRoom3] = {funcSTR = "ghoulRoom_enterGhoulRoom3"},
    },
    AIDTiles_stepOut = {
        [AIDT.ghoul_bodyRemains] = {funcSTR = "ghoul_bodyRemains"},
    },
}
centralSystem_registerTable(rootedCatacombsGhoulRoom)
end

local function registerPoisonFieldArea()
    local poisonT = ghoulAreaConf.poisonFieldArea
    local poisonArea = createAreaOfSquares({poisonT.areaCorners})

    local function registerPoison(pos)
        local poisonField = findItem(poisonT.poisonFieldID, pos)
        if poisonField then
            poisonField:setActionId(AID.other.field_earth)
            poisonField:setText("minDam", poisonT.minDam)
            poisonField:setText("maxDam", poisonT.maxDam)
        end
    end
    
    for _, pos in pairs(poisonArea) do registerPoison(pos) end
end

function ghoulRoom_startUp()
    local confT = ghoulAreaConf.ghoulRoomConf

    registerPoisonFieldArea()
    
    for _, roomT in pairs(confT.ghoulRooms) do
        local area = createAreaOfSquares({roomT.areaCorners})
        local floorTiles = 0
        
        local function registerFloor(pos)
            local tile = findItem(confT.goodTileID, pos)
            if not tile or tile:getActionId() > 0 then return end
            floorTiles = floorTiles + 1
            return tile:setActionId(AIDT.colorTile)
        end
        
        for _, pos in pairs(area) do registerFloor(pos) end
        roomT.tilesLeft = floorTiles
        roomT.totalTiles = floorTiles
        roomT.ghoulIDT = {}
        roomT.floorPosZ = roomT.areaCorners.upCorner.z
        roomT.floorTileID = Tile(roomT.finishPos):getGround():getId()
    end
end

function ghoulRoom_resetFloor(player, floor)
    floor = floor or player:getPosition().z
    local roomT = getGhoulRoom(floor)
    if not roomT then return end
    local area = createAreaOfSquares({roomT.areaCorners})

    if player then
        for _, pos in pairs(area) do
            if findCreature("player", pos) then return end
        end
    end
    local confT = ghoulAreaConf.ghoulRoomConf
    local item = findItem(roomT.itemID, roomT.finishPos)

    for _, monsterID in pairs(roomT.ghoulIDT) do removeCreature(monsterID) end
    roomT.ghoulIDT = {}
    
    for _, pos in pairs(roomT.ghoulPos) do
        local ghoul = createMonster("ghoul", pos)
        if ghoul then table.insert(roomT.ghoulIDT, ghoul:getId()) end
    end

    for _, pos in pairs(area) do
        massTeleport(pos, roomT.restartPos, {"player"})
        doTransform(confT.badTileID, pos, confT.goodTileID, AIDT.colorTile)
    end
    
    roomT.tilesLeft = roomT.totalTiles
    
    if item then
        item:remove()
        if not findItem(roomT.floorTileID) then createItem(roomT.floorTileID, roomT.finishPos) end
    end
end

function ghoulRoom_colorTile(player, item)
    if not player:isPlayer() then return end
    local floor = player:getPosition().z
    local confT = ghoulAreaConf.ghoulRoomConf
    local badTileID = confT.badTileID

    if item:getId() == badTileID then return ghoulRoom_resetFloor(nil, floor) end
    local roomT = getGhoulRoom(floor)
    local tilesLeft = roomT.tilesLeft - 1

    item:transform(badTileID)
    if tilesLeft <= percentage(roomT.totalTiles, 100-confT.requiredTilePercent) then
        if findItem(roomT.itemID, roomT.finishPos) then return end
        return createItem(roomT.itemID, roomT.finishPos, 1, roomT.itemAID)
    end
    roomT.tilesLeft = tilesLeft
end

function ghoulRoom_enterGhoulRoom3(player, item)
    ghoulRoom_resetFloor(player, 12)
end

function ghoulRoom_completeFloor(player, item)
    if not player:isPlayer() then return end
    local floor = player:getPosition().z
    local roomT = getGhoulRoom(floor)
    local partyMembers = getPartyMembers(player, 9)

    if roomT.nextFloorID then
        local floorZ = ghoulAreaConf.ghoulRoomConf.ghoulRooms[roomT.nextFloorID].floorPosZ
        ghoulRoom_resetFloor(player, floorZ)
    end
    ghoulRoom_resetFloor(nil, floor)
    for guid, playerID in pairs(partyMembers) do teleport(playerID, roomT.teleportToPos) end
    ghoulBlessQuest_reset(player)
end

function getGhoulRoom(floor)
    for _, roomT in ipairs(ghoulAreaConf.ghoulRoomConf.ghoulRooms) do
        if roomT.floorPosZ == floor then return roomT end
    end
end
