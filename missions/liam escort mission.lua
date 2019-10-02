local AIDT = AID.missions.campfire
local rewardExp = 30

mission_liamEscort = {
    questlog = {
        name = "Liam Escort Mission",
        questSV = SV.liamMission,
        trackerSV = SV.liamTracker,
        category = "mission",
        log = {
            [0] = "Escort Liam out of Hehemi.",
        },
    },
    npcChat = {
        ["liam"] = {
            [91] = {
                question = "I will help you to get out from this place.",
                allSV = {[SV.liamMission] = -1, [SV.liam2] = 1},
                setSV = {[SV.liamMission] = 0, [SV.liamTracker] = 0},
                funcSTR = "liamEscort_startMission",
                answer = "Ok cool, get me to the stairs I can get out from there my own.",
                closeWindow = true,
            },
            [92] = {
                action = "CANCEL MISSION",
                doAction = "You canceled Liam Escort Mission.",
                anySV = {[SV.liamMission] = 0},
                setSV = {[SV.liamMission] = -1, [SV.liamTracker] = -1},
                funcSTR = "liamEscort_reset",
                answer = "aww sad, well perhaps another time.",
            },
        },
        ["peeter"] = {
            [111] = {
                question = "Did Liam found you?",
                allSV = {[SV.liamMission] = 1, [SV.talkToPeeterMission] = -1},
                setSV = {[SV.talkToPeeterMission] = 1},
                answer = {
                    "Yes he did.",
                    "Amazing that you found the passage way to Hehem and on top of that found my little brother and helped him.",
                    "I appreciate it, ty",
                },
            },
        }
    },
    AIDTiles_stepIn = {
        [AID.other.liamPushTile] = {funcSTR = "liam_blockTileStepIn"},
    },
    registerEvent = {
        onDeath = {liam = "liamEscord_liamDeath"}
    }
}
centralSystem_registerTable(mission_liamEscort)

function liam_blockTileStepIn(creature, tile, _, fromPos)
    local npcT = getNpcT(creature)
    if not npcT then return end
    if npcT.followTargetID then return end
    return teleport(creature, fromPos)
end

function liamEscort_reset(player, npc) return resetNpcLiam(npc) end

function liamEscort_startMission(player, npc)
    local npcT = getNpcT(npc)
    npcT.followTargetID = player:getId()
    registerEvent(npc, "onThink", "liamEscort_npcAI")
end

--[[    moveT guide
    npcFloor = INT      npcPos.z == INT
    playerFloor = INT   playerPos.z == INT
    yPos_big = INT      playerPos.y > INT
    yPos_small = INT    playerPos.y < INT
    xPos_big = INT      playerPos.x > INT
    xPos_small = INT    playerPos.x < INT
    targetPos = POS     position where npc is trying to get to
    takeHealth = INT
    msg = STR
    newPos = POS
]]
local moveT = {
    [1] = {
        npcFloor = 9,
        yPos_big = 599,
        targetPos = {x = 443, y = 600, z = 9},
        takeHealth = 50,
        msg = "*ouch*",
        newPos = {x = 443, y = 600, z = 10},
    },
    [2] = {
        npcFloor = 10,
        playerFloor = 9,
        yPos_small = 577,
        targetPos = {x = 443, y = 574, z = 10},
        msg = "*uh*",
        newPos = {x = 444, y = 573, z = 9},
    },
    [3] = {
        npcFloor = 10,
        playerFloor = 11,
        xPos_small = 443,
        targetPos = {x = 442, y = 588, z = 10},
        takeHealth = 400,
        msg = "*aaargh*",
        newPos = {x = 440, y = 587, z = 12},
    },
    [4] = {
        npcFloor = 10,
        playerFloor = 12,
        targetPos = {x = 442, y = 588, z = 10},
        takeHealth = 500,
        msg = "*aaargh*",
        newPos = {x = 440, y = 587, z = 12},
    },
    [5] = {
        npcFloor = 9,
        targetPos = {x = 451, y = 575, z = 9},
        takeHealth = 50,
        msg = "*ouch*",
        newPos = {x = 451, y = 576, z = 10},
    },
    [6] = {
        npcFloor = 10,
        xPos_big = 443,
        targetPos = {x = 447, y = 571, z = 10},
        newPos = {x = 447, y = 571, z = 11},
    },
    [7] = {
        npcFloor = 11,
        playerFloor = 12,
        yPos_small = 607,
        targetPos = {x = 461, y = 595, z = 11},
        takeHealth = 50,
        msg = "*ouch*",
        newPos = {x = 460, y = 595, z = 12},
    },
    [8] = {
        npcFloor = 12,
        playerFloor = 11,
        targetPos = {x = 460, y = 601, z = 12},
        msg = "*mh*",
        newPos = {x = 460, y = 601, z = 11},
    },
    [9] = {
        npcFloor = 11,
        playerFloor = 12,
        yPos_big = 607,
        targetPos = {x = 453, y = 610, z = 11},
        takeHealth = 50,
        msg = "*ouch*",
        newPos = {x = 452, y = 610, z = 12},
    },
}

local function correctT(playerPos, npcPos, t)
    if t.npcFloor and npcPos.z ~= t.npcFloor then return end
    if t.playerFloor and playerPos.z ~= t.playerFloor then return end
    if t.yPos_big and playerPos.y <= t.yPos_big then return end
    if t.yPos_small and playerPos.y >= t.yPos_small then return end
    if t.xPos_big and playerPos.x <= t.xPos_big then return end
    if t.xPos_small and playerPos.x >= t.xPos_small then return end
    return true
end

local function moveNpc(player, npc)
local npcPos = npc:getPosition()
local playerPos = player:getPosition()
    
    for ID, t in ipairs(moveT) do
        if correctT(playerPos, npcPos, t) then
            if getPath(npcPos, t.targetPos, false, true) then
                teleport(npc, t.newPos)
                if t.msg then npc:say(t.msg, ORANGE) end
                if t.takeHealth then
                    npc:addHealth(-t.takeHealth)
                    doSendMagicEffect(npcPos, 1)
                end
            end
            return
        end
    end
end

function liamEscort_npcAI(npc)
    local npcT = getNpcT(npc)
    local player = Player( npcT.followTargetID)
    if not player then return resetNpcLiam(npc) end
    if npc:getHealth() == 1 then return liamEscord_liamDeath(npc) end
    if liamEscort_complete(player, npc) then return end

    local npcPos = npc:getPosition()
    npc:addHealth(-1)
    doSendMagicEffect(npcPos, 1)
    if player:getPosition().z == npcPos.z then return end
    moveNpc(player, npc)
end

function resetNpcLiam(npc)
    createNpc({name = "liam", npcPos = getNpcT(npc).spawnPos})
    return npc:remove()
end

function liamEscord_liamDeath(npc)
local npcT = getNpcT(npc)
local target = Player(npcT.followTargetID)
    
    if target then
        local partyMembers = getPartyMembers(target)
        
        for guid, cid in pairs(partyMembers) do
            if getSV(cid, SV.liamMission) == 0 then removeSV(cid, {SV.liamMission, SV.liamTracker}) end
        end
    end
    return resetNpcLiam(npc)
end

function liamEscort_complete(player, npc)
local npcPos = npc:getPosition()
    if npcPos.z ~= 12 or npcPos.y < 631 then return end
local partyMembers = getPartyMembers(player)
    
    for guid, pid in pairs(partyMembers) do
        local member = Player(pid)
        
        if getSV(member, SV.liamMission) ~= 1 then
            setSV(member, SV.liamMission, 1)
            setSV(member, SV.liamTracker, -1)
            member:addExpPercent(rewardExp)
        end
    end
    creatureSay(npc, "Thank you!, I'm going to see Peeter now.")
    return resetNpcLiam(npc)
end