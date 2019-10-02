--[[ mummyRoom_conf guide
    sttatueID = {INT}           the items what check if puzzle is solved onUse
    bridgeDuration = INT        ms duration how long brides stay up when puzzle is solved | 5 sec before magic effects will warn of destruction
    mummySpawnTime = INT        how long it takes for mummy to spawn back after it is killed
    bridgeID = INT              itemID of the bridges what are going to be created when puzzle solved
    upCorner = POS              marks the most up left corner of all puzzle rooms
    downCorner = POS            marks the most down right corner of all puzzle rooms
    kickPos = POS               position outside of the puzzle room where player can be kicked (usually on relog)
    
    bridges = {
        [INT] = {               onUse actionID to check puzzle attached to certain room
            kickPos = POS       position where creatures kicked if bridge crumbles and player on it
            leverPos = POS      changes wall-lamp lever color ON or OFF | onUse that lever creeates bridge define in levers*
            
            -- AUTOMATIC
            builtTime = INT     os.time() when bridge was first created
            posT = {}           all the bridge positions
            itemID = bridgeID
        }
    }
    rooms = {
        [INT] = {               onUse actionID to check puzzle attached to certain room
            upCorner = POS
            downCorner = POS
            
            -- AUTOMATIC
            mummyPosT = {},     holds the positions where mummies spawn
            mummies = {},       holds the monster ID's
            players = {}        holds the player ID's
            roomAID = INT       the key of table
        }
    }
    levers = {
        [INT] = INT,            first INT is the bridge leverAID | second INT is statue actionID / roomAID
    }
]]
local AIDT = AID.areas.mummyRoom

if not mummyRoom_conf then
mummyRoom_conf = {
    statueID = {12042, 12043},
    bridgeDuration = 30*1000,
    mummySpawnTime = 4*60*1000,
    bridgeID = 9199,
    upCorner = {x = 606, y = 767, z = 8},   
    downCorner = {x = 631, y = 793, z = 8},
    kickPos = {x = 613, y = 765, z = 8},
    
    bridges = {
        [AIDT.lineTile_mummyRoom1] = {kickPos = {x = 619, y = 776, z = 8}, leverPos = {x = 622, y = 774, z = 8}},
        [AIDT.lineTile_mummyRoom2] = {kickPos = {x = 636, y = 776, z = 8}},
        [AIDT.lineTile_mummyRoom3] = {kickPos = {x = 628, y = 788, z = 8}, leverPos = {x = 633, y = 784, z = 8}},
    },
    rooms = {
        [AIDT.lineTile_mummyRoom1] = {upCorner = {x = 607, y = 770, z = 8}, downCorner = {x = 622, y = 781, z = 8}},
        [AIDT.lineTile_mummyRoom2] = {upCorner = {x = 623, y = 770, z = 8}, downCorner = {x = 640, y = 785, z = 8}},
        [AIDT.lineTile_mummyRoom3] = {upCorner = {x = 621, y = 785, z = 8}, downCorner = {x = 640, y = 797, z = 8}},
    },
    levers = {
        [AIDT.bridgeLever_room1] = AIDT.lineTile_mummyRoom1,
        [AIDT.bridgeLever_room3] = AIDT.lineTile_mummyRoom2,
    }
}

lineTile_conf = { -- onUse action guide and tileGroup for shuffel
    [AIDT.lineTile_SE]  = {itemID = 983,    toItemID = 979,  toItemAID = AIDT.lineTile_SW,   directions = "SE",  tileGroup = 1},
    [AIDT.lineTile_SW]  = {itemID = 979,    toItemID = 1007, toItemAID = AIDT.lineTile_NW,   directions = "SW",  tileGroup = 1},
    [AIDT.lineTile_NW]  = {itemID = 1007,   toItemID = 997,  toItemAID = AIDT.lineTile_NE,   directions = "NW",  tileGroup = 1},
    [AIDT.lineTile_NE]  = {itemID = 997,    toItemID = 983,  toItemAID = AIDT.lineTile_SE,   directions = "NE",  tileGroup = 1},
    [AIDT.lineTile_NSE] = {itemID = 992,    toItemID = 998,  toItemAID = AIDT.lineTile_SEW,  directions = "NSE", tileGroup = 2},
    [AIDT.lineTile_SEW] = {itemID = 998,    toItemID = 990,  toItemAID = AIDT.lineTile_NSW,  directions = "SEW", tileGroup = 2},
    [AIDT.lineTile_NSW] = {itemID = 990,    toItemID = 984,  toItemAID = AIDT.lineTile_NEW,  directions = "NSW", tileGroup = 2},
    [AIDT.lineTile_NEW] = {itemID = 984,    toItemID = 992,  toItemAID = AIDT.lineTile_NSE,  directions = "NEW", tileGroup = 2},
    [AIDT.lineTile_EW]  = {itemID = 976,    toItemID = 996,  toItemAID = AIDT.lineTile_NS,   directions = "EW",  tileGroup = 3},
    [AIDT.lineTile_NS]  = {itemID = 996,    toItemID = 976,  toItemAID = AIDT.lineTile_EW,   directions = "NS",  tileGroup = 3},
    [AIDT.lineTile_NSEW]= {itemID = 977,    directions = "NSEW"},
}

for itemAID, t in pairs(lineTile_conf) do t.itemAID = itemAID end
lineTile_groups = {} -- generated on startUp, improves shuffeling lineTiles in room.

rootedCatacombsMummyRoom = {
    name = "Mummy room",
    startUpFunc = "mummyRoom_startUp",
    area = {
        areaCorners = {
            {upCorner = mummyRoom_conf.upCorner, downCorner = mummyRoom_conf.downCorner},
        },
        setActionID = {
            [983] = AIDT.lineTile_SE,
            [979] = AIDT.lineTile_SW,
            [997] = AIDT.lineTile_NE,
            [1007] = AIDT.lineTile_NW,
            [992] = AIDT.lineTile_NSE,
            [990] = AIDT.lineTile_NSW,
            [984] = AIDT.lineTile_NEW,
            [998] = AIDT.lineTile_SEW,
            [976] = AIDT.lineTile_EW,
            [996] = AIDT.lineTile_NS,
            [977] = AIDT.lineTile_NSEW,
            [1590] = AIDT.rail,
        },
    },
    AIDItems = {
        [AIDT.lineTile_SE] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_SW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NE] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NSE] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NSW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NEW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_SEW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_NS] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_EW] = {funcSTR = "lineTile_onUse"},
        [AIDT.lineTile_mummyRoom1] = {funcSTR = "lineTile_checkLines"},
        [AIDT.lineTile_mummyRoom2] = {funcSTR = "lineTile_checkLines"},
        [AIDT.lineTile_mummyRoom3] = {funcSTR = "lineTile_checkLines"},
        [AIDT.boneWall] = {
            hasItemsF = {itemID = 21250},
            rewardItems = {itemID = 21250, itemAID = AIDT.boneWall_note, itemName = "old note"},
        },
        [AIDT.rail] = {funcSTR = "mummyRoom_enter"},
        [AIDT.bridgeLever_room1] = {funcSTR = "mummyRoom_bridgeLever"},
        [AIDT.bridgeLever_room3] = {funcSTR = "mummyRoom_bridgeLever"},
    },
    AIDItems_onLook = {
        [AIDT.lineTile_mummyRoom1] = {text = {msg = "Fountain seems to have a handle"}},
        [AIDT.boneWall] = {
            hasItemsF = {itemID = 21250},
            text = {msg = "There seems to be a note stuck in the bones"},
            textF = {msg = "Nothing there anymore"},
        },
        [AIDT.boneWall_note] = {
            setSV = {[SV.mummyBless_hintFromNote] = 1},
            text = {msg = "I leave this note for random passenger: Connect floorboards so that electric current can pass from 1 well to another"}
        },
        [AIDT.lineTile_SE] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_SW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NE] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NSE] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NSW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NEW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_SEW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NS] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_EW] = {text = {msg = "Metal line is crossing this loose floor tile"}},
        [AIDT.lineTile_NSEW] = {text = {msg = "Metal line is crossing this floor tile"}},
        [AIDT.mummy_bomb] = {text = {msg = "pulsating bandage roll"}},
        [AIDT.mummy_rootingBandage] = {text = {msg = "moving bandage pieces"}},
        [AIDT.bridgeLever_room1] = {text = {msg = "Electrical device"}},
        [AIDT.bridgeLever_room3] = {text = {msg = "Electrical device"}},
    },
    AIDTiles_stepIn = {
        [AIDT.mummyBlockTile] = {funcSTR = "mummyRoom_mummyBlockTile"},
        [AIDT.mummy_rootingBandage] = {funcSTR = "mummy_rootingBandage"},
    },
    AIDItems_onMove = {
        [AIDT.boneWall_note] = {funcStr = "discardItem"},
    },
    mapEffects = {
        ["boneWall"] = {pos = {x = 611, y = 769, z = 8}}
    },
}
centralSystem_registerTable(rootedCatacombsMummyRoom)
end

function mummyRoom_startUp()
local bridgeID = mummyRoom_conf.bridgeID
    
    for itemAID, t in pairs(lineTile_conf) do
        local groupID = t.tileGroup
        
        if groupID then
            if not lineTile_groups[groupID] then
                lineTile_groups[groupID] = {[t.itemID] = itemAID}
            else
                lineTile_groups[groupID][t.itemID] = itemAID
            end
        end
    end
    
    if type(mummyRoom_conf.statueID) ~= "table" then mummyRoom_conf.statueID = {mummyRoom_conf.statueID} end
    
    local function register_lineTileStatue(pos, roomAID)
        for _, itemID in ipairs(mummyRoom_conf.statueID) do
            local item = findItem(itemID, pos)
            if item then return item:setActionId(roomAID) end
        end
    end
    
    local function register_bridge(pos, roomAID)
        local bridgeT = mummyRoom_conf.bridges[roomAID]
        if not bridgeT then return end
        local item = findItem(bridgeID, pos)
        if not item then return end
        
        if not bridgeT.posT then bridgeT.posT = {} end
        bridgeT.itemID = bridgeID
        table.insert(bridgeT.posT, pos)
        item:transform(708)
    end
    
    local function register_mummyPos(pos)
        if findItem(7560, pos) or findItem(7561, pos) then return true end
    end
    
    for roomAID, roomT in pairs(mummyRoom_conf.rooms) do
        local room = createSquare(roomT.upCorner, roomT.downCorner)
        roomT.mummyPosT = {}
        
        for _, pos in ipairs(room) do
            register_lineTileStatue(pos, roomAID)
            register_bridge(pos, roomAID)
            if register_mummyPos(pos) then table.insert(roomT.mummyPosT, pos) end
        end
        
        roomT.players = {}
        roomT.roomAID = roomAID
        lineTile_shuffle(roomAID)
        if roomAID ~= AIDT.lineTile_mummyRoom1 then mummyRoom_spawn(roomAID, true) end
    end
end

function lineTile_onUse(player, item)
    local itemAID = item:getActionId()
    local lineTileT = lineTile_conf[itemAID]
    if not lineTileT.toItemID then return end
    doTransform(item:getId(), item:getPosition(), lineTileT.toItemID, lineTileT.toItemAID)
end

local function lineTile_checkLine(startPos)
    local checkedPosT = {}
    local checkedPosIndex = 0
    local nodeT = {[startPos] = "NSEW"}
    local checkpassed = false
        
    local function finishFound(pos)
        for _, itemID in ipairs(mummyRoom_conf.statueID) do
            if findItem(itemID, pos) then checkpassed = true break end
        end
        return checkpassed
    end
    
    local function alreadyUsedPos(pos)
        for _, usedPos in ipairs(checkedPosT) do
            if samePositions(usedPos, pos) then return true end
        end
    end
    
    local function getDirectionStr(pos, fromDirection)
        if alreadyUsedPos(pos) then return end
        if finishFound(pos) then return end
        local tile, confT = getLineTile(pos)
        if not tile then return end
        
        local tileDirections = confT.directions
        local directionT = stringToLetterT(tileDirections)
        
        fromDirection = reverseDir(fromDirection)
        for _, direction in ipairs(directionT) do
            if direction == fromDirection then return tileDirections:gsub(fromDirection, "") end
        end
    end
    
    local function removeNode(pos)
        for nodePos, directionStr in pairs(nodeT) do
            if samePositions(nodePos, pos) then nodeT[nodePos] = nil return end
        end
    end
    
    local function getNodeT(startPos, directionsStr)
        local directionT = stringToLetterT(directionsStr)
        
        removeNode(startPos)
        checkedPosIndex = checkedPosIndex + 1
        checkedPosT[checkedPosIndex] = startPos
        
        for _, direction in ipairs(directionT) do
            local nextPos = getDirectionPos(startPos, direction)
            local newDirectionStr = getDirectionStr(nextPos, direction)
            if newDirectionStr then nodeT[nextPos] = newDirectionStr end
        end
    end
    
    while not checkpassed do
        if tableCount(nodeT) == 0 then break end
        for pos, directionsStr in pairs(nodeT) do getNodeT(pos, directionsStr) break end
    end
    return checkpassed
end

function lineTile_checkLines(player, item)
    local itemPos = item:getPosition()
    player:sendTextMessage(GREEN, "You felt small electric shock")
    if not lineTile_checkLine(itemPos) then return doSendMagicEffect(itemPos, 13) end

    doSendMagicEffect(itemPos, 14)
    doSendMagicEffect(itemPos, 31)
    mummyRoom_createBridge(item:getActionId(), itemPos)
    mummyBlessQuest_puzzleSolved(player)
end

function mummyRoom_bridgeLever(player, item)
    local itemID = item:getId()
    if itemID == 9841 or itemID == 9839 then return end
    mummyRoom_createBridge(mummyRoom_conf.levers[item:getActionId()])
end

function lineTile_randomItemChangeByGroup(tile, group)
    if not tile or not group then return end
    local groupT = lineTile_groups[group]
    local itemID = randomKeyFromTable(groupT)
    local itemAID = groupT[itemID]

    doTransform(tile:getId(), tile:getPosition(), itemID, itemAID) 
end

function lineTile_shuffle(itemAID)
    local roomT = mummyRoom_conf.rooms[itemAID]
    if not roomT then return print("ERROR - room configurrations are missing in lineTile_shuffle()") end
    local roomPosT = createSquare(roomT.upCorner, roomT.downCorner)

    for _, pos in ipairs(roomPosT) do
        local tile, confT = getLineTile(pos)
        if confT then lineTile_randomItemChangeByGroup(tile, confT.tileGroup) end
    end
end

local function destroyMummyRoomBridgeByPos(itemID, pos, itemAID)
    local bridgeT = mummyRoom_conf.bridges[itemAID]
    doTransform(itemID, pos, 708) 
    massTeleport(pos, bridgeT.kickPos, "creature")
    doTransform(9841, bridgeT.leverPos, 9840, true)
    doTransform(9839, bridgeT.leverPos, 9838, true)
end

function mummyRoom_createBridge(itemAID, itemPos)
    local bridgeT = mummyRoom_conf.bridges[itemAID]
    if not bridgeT then return print("ERROR - bridge configurrations are missing in mummyRoom_createBridge()") end
    
    local bridgeDuration = mummyRoom_conf.bridgeDuration
    local currentTime = os.time()
    local lastTimeBuilt = bridgeT.builtTime or 0
    local allowedBuilidingTime = lastTimeBuilt + bridgeDuration/1000
    
    if allowedBuilidingTime > currentTime then return end
    local bridgePosT = bridgeT.posT
    local itemID = bridgeT.itemID

    bridgeT.builtTime = currentTime
    lineTile_shuffle(itemAID)
    doTransform(9840, bridgeT.leverPos, 9841, true)
    doTransform(9838, bridgeT.leverPos, 9839, true)
    if itemPos then text("bridge is up and will last "..getTimeText(bridgeDuration/1000), itemPos) end
    
    for _, pos in ipairs(bridgePosT) do
        createItem(itemID, pos, 1, AIDT.mummyBlockTile)
        doSendMagicEffect(pos, 3)
        addEvent(doSendMagicEffect, bridgeDuration - 5000, pos, {4,14,14,14,10}, 1000)
        addEvent(destroyMummyRoomBridgeByPos, bridgeDuration, itemID, pos, itemAID)
    end
end

local function mummyRoom_mummyEntrance(roomT)
    local mummyPos1 = roomT.mummyPosT[1]
    local mummyPos2 = roomT.mummyPosT[2]
    local area = {
        {1},
        {2},
        {3},
        {4},
    }
    
    local function mummyEntrance(pos, msg)
        local area = getAreaPos(pos, area)
        
        for i, posT in ipairs(area) do
            for _, pos in ipairs(posT) do
                local cid = 0
                
                if i == 2 then
                    local mummy = createMonster("mummy", pos)
                    cid = mummy:getId()
                    text(msg, pos)
                    doSendMagicEffect(pos, 27)
                end
                addEvent(dealDamagePos, i*150, cid, pos, PHYSICAL, 200, 1, O_environment_player, {3,4})
            end
        end
    end
    
    text("knock knock", mummyPos1)
    addEvent(text, 3000, "who is there?", mummyPos2)
    addEvent(mummyEntrance, 6000, mummyPos1, "It's mia, Mummia!!")
    addEvent(mummyEntrance, 8000, mummyPos2, "Mia Mummia too!!")
end

function mummyRoom_mummyBlockTile(creature, item, _, fromPos) return creature:isMonster() and creature:teleportTo(fromPos) end

local mummyEntranceActivated = false
function mummyRoom_enter(player, item)
    local roomT = mummyRoom_getRoomT(AIDT.lineTile_mummyRoom1)
    local pid = player:getId()

    climbOn(player, item)
    mummyBlessQuest_start(player)
    if not roomT then return end
    table.insert(roomT.players, pid)
    if mummyEntranceActivated then return end
    
    for _, playerID in pairs(roomT.players) do
        local player = Player(playerID)
        
        if player and pid ~= playerID then
            if isInRange(player:getPosition(), roomT.upCorner, roomT.downCorner) then return end
        end
    end
    local roomPosT = createSquare(roomT.upCorner, roomT.downCorner)
        
    mummyEntranceActivated = true
    addEvent(function() mummyEntranceActivated = false end, 6000)
    addEvent(mummyRoom_mummyEntrance, 6000, roomT)
    for _, pos in ipairs(roomPosT) do massRemove(pos, "monster") end
end

function mummyRoom_spawn(AID, summonAll)
    local roomT = mummyRoom_getRoomT(AID)
    
    if not summonAll then
        local spawnPos = randomPos(roomT.mummyPosT, 1)[1]
        
        text("*knock*", spawnPos)
        addEvent(text, 1000, "*knock*", spawnPos)
        addEvent(text, 2000, "*knock*", spawnPos)
        return addEvent(createMonster, 3000, "mummy", spawnPos)
    end
    for _, pos in ipairs(roomT.mummyPosT) do createMonster("mummy", pos) end
end


function mummyRoom_clean(pid)
    local roomT = mummyRoom_getRoomT(AIDT.lineTile_mummyRoom1)
    local playerT = roomT.players

    if pid then
        for i, playerID in ipairs(playerT) do
            if pid == playerID then playerT[i] = nil return end
        end
    else
        local newPlayerT = {}
        local loopID = 0
        
        for _, playerID in ipairs(playerT) do
            if Player(playerID) then
                loopID = loopID + 1
                newPlayerT[loopID] = playerID
            end
        end
    end
end

function mummyRoom_tpOut(player)
    if isInRange(player:getPosition(), mummyRoom_conf.upCorner, mummyRoom_conf.downCorner) then return teleport(player, mummyRoom_conf.kickPos) end
end

-- get functions
function mummyRoom_getRoomT(AID)
    local roomT = mummyRoom_conf.rooms[AID]
    if roomT then return roomT end
    print("ERROR - missing roomT for AID["..AID.."] in mummyRoom_getRoomT()")
end

function getLineTile(pos)
    for itemAID, confT in pairs(lineTile_conf) do
        local tile = findItem(confT.itemID, pos)
        if tile then return tile, confT end
    end
end

function mummyRoom_getRoomTByPos(pos)
    for roomAID, roomT in pairs(mummyRoom_conf.rooms) do
        if isInRange(pos, roomT.upCorner, roomT.downCorner) then return roomT end
    end
end