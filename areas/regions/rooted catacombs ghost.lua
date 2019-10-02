ghostConfT = {
    room1 = {upCorner = {x = 576, y = 711, z = 8}, downCorner = {x = 609, y = 744, z = 8}},
    buttonUpID = 416,
    buttonDownID = 417,
    revealStatueID = 21515,
    safeZoneStatueID = 21514,
    safeZoneTorchID = 12011,
    revealArea = {
        {n, n, n, n, 1, n, n, n, n},
        {n, n, n, 1, 1, 1, n, n, n},
        {n, n, 1, 1, 1, 1, 1, n, n},
        {n, 1, 1, 1, 1, 1, 1, 1, n},
        {1, 1, 1, 1, 0, 1, 1, 1, 1},
        {n, 1, 1, 1, 1, 1, 1, 1, n},
        {n, n, 1, 1, 1, 1, 1, n, n},
        {n, n, n, 1, 1, 1, n, n, n},
        {n, n, n, n, 1, n, n, n, n},
    },
    ghostTP = {
        {2,     1, 2},
        {1, {0,3}, 1},
        {2,     1, 2},
    },
--  automatic
--  safeZoneT = {{upCorner = POS, downCorner = POS}} -- generated on start up position taken by safeZoneStaueID
}

local AIDT = AID.areas.ghostRoom

rootedCatacombsGhostRoom = {
    name = "Ghost room",
    startUpFunc = "ghostRoom_startUp",
    area = {
        areaCorners = {ghostConfT.room1},
        setActionID = {
            [ghostConfT.buttonUpID] = AIDT.revealButton,
            [ghostConfT.safeZoneStatueID] = AIDT.repellPillar,
            [ghostConfT.safeZoneTorchID] = AIDT.repellPillar,
        },
    },
    mapEffects = {
        ["pillar"] = {
            posT = {
                {x = 594, y = 740, z = 8},
                {x = 594, y = 736, z = 8},
                {x = 594, y = 732, z = 8},
                {x = 590, y = 732, z = 8},
                {x = 590, y = 736, z = 8},
                {x = 590, y = 740, z = 8},
                {x = 590, y = 743, z = 8},
                {x = 594, y = 743, z = 8},
            },
        }
    },
    npcChat = {
        ["niine"] = {
            [68] = {
                question = "Can you look my hands too I got zapped by some strange pillar in Rooted Catacombs?",
                allSV = {[SV.repellPillarHint] = 0},
                setSV = {[SV.repellPillarHint] = 1},
                answer = {"Sure", "Hmm, you alright.", "I think I know about these pillars", "They were suppose to hold off bad energy."},
            },
        },
    },
    AIDItems = {
        [AIDT.repellPillar] = {
            allSV = {[SV.repellPillarHint] = -1},
            text = {msg = "you got zapped by touching the pillar."},
            health = -5,
            setSV = {[SV.repellPillarHint] = 0},
            textF = {msg = "You don't want to get zapped again"},
        },
    },
    AIDItems_onLook = {
        [AIDT.repellPillar] = {
            allSV = {[SV.repellPillarHint] = 1},
            textF = {msg = "This pillar emits strange light"},
            text = {msg = "For short distance around this pillar, ghosts will ignore you."}
        },
        [AIDT.ghostOrb] = {text = {msg = "tornado is inside the cold orb"}},
    },
    AIDTiles_stepIn = {
        [AIDT.revealButton] = {funcSTR = "ghostRoom_revealTile"},
    },
    AIDTiles_stepOut = {
        [AIDT.revealButton] = {
            transform = {itemID = 416, itemAID = true}
        },
    },
    monsterSpawns = {{
        name = "first ghost room",
        amount = 25,
        spawnTime = 60*6*1000,
        monsterT = {
            ["ghost"] = {},
        },
        areaCorners = {ghostConfT.room1},
    }},
}
centralSystem_registerTable(rootedCatacombsGhostRoom)

function ghostRoom_startUp()
    local area = createAreaOfSquares({ghostConfT.room1})
    local safeZoneT = {}
        
    local function addSafeZone(pos)
        local upCorner, downCorner = getPosCorners(pos, 2)
        table.insert(safeZoneT, {upCorner = upCorner, downCorner = downCorner})
    end
    
    local function registerObject(pos)
        if findItem(ghostConfT.safeZoneStatueID, pos) then return addSafeZone(pos) end
    end
    
    for _, pos in pairs(area) do registerObject(pos) end
    ghostConfT.safeZoneT = safeZoneT
end

local function getStatuePos(position)
    for _, direction in pairs(compass1) do
        local newPos = getDirectionPos(position, direction)
        
        if findItem(ghostConfT.revealStatueID, newPos) then return newPos end
    end
end

function ghostRoom_revealTile(creature, item, _, fromPos)
    local position = item:getPosition()

    if creature:isMonster() then
        if samePositions(fromPos, position) then return end
        local direction = getDirection(fromPos, position)
        local newPos = getDirectionPos(position, direction, 1)
        teleport(creature, newPos)
    elseif creature:isPlayer() then
        local statuePos = getStatuePos(position)
        if not statuePos then return error("missing statue pos") end
        local area = getAreaPos(statuePos, ghostConfT.revealArea)
        doSendMagicEffect(position, {1,5})
        creature:addHealth(-30)
        doTransform(item:getId(), position, ghostConfT.buttonDownID, true)
        
        for _, posT in pairs(area) do
            for _, pos in pairs(posT) do
                doSendMagicEffect(pos, 13)
                ghostRoom_revealGhost(pos)
            end
        end
    end
end

function ghostRoom_revealGhost(pos)
    local ghost = findByName(pos, "ghost")
    if not ghost then return end
    doSendMagicEffect(pos, 2)
    removeCondition(ghost, "invisible")
end