local AIDT = AID.quests.ghoulBless
local confT = {
    exp = 25,    
    areaCorners = {upCorner = {x = 622, y = 723, z = 10}, downCorner = {x = 642, y = 739, z = 10}},
    puzzleIDT = {1467, 1468, 1470, 1471},
    ladderTileID = 419,
    ladderDownID = 428,
    ladderDownAID = AIDT.ladderDown,
    ladderPos = {x = 638, y = 728, z = 10},
    startTileID = 9146,
    timeUpTileID = 407,
    startPos = {x = 632, y = 731, z = 10},
    interval = 2000,                            -- in milliseconds
    ghoulPos = {x = 627, y = 731, z = 10},
 -- tilePathT = {[_] = POS}                     positions in sequence to follow a path
 -- puzzleSolution = {[POS] = itemID}           in what position correct itemID must be
 -- ghoulPosT = {POS}                           positions where all ghouls will be summoned
}

quest_ghoulBless = {
    startUpFunc = "ghoulBlessQuest_startUp",
    
    area = {
        areaCorners = {confT.areaCorners},
        setActionID = {
            [1467] = AIDT.puzzleStatue,
            [1468] = AIDT.puzzleStatue,
            [1470] = AIDT.puzzleStatue,
            [1471] = AIDT.puzzleStatue,
        },
        blockObjects = {708},
    },
    questlog = {
        name = "Ghoul Bless Quest",
        questSV = SV.ghoulBless_questSV,
        trackerSV = SV.ghoulBless_trackerSV,
        log = {
            [0] = "Figure out how to get to the lower floors in the ghoul room.",
            [1] = "Solve the puzzle in the third ghoul room to advance further.",
            [2] = "Touch the gate keeper statue in the ghoul room to get a blessing.",
        },
        hintLog = {
            [1] = {
                [SV.ghoulBless_hint] = "The tanner told you to make the snake statues face the direction the liquid is flowing.",
            },
        },
    },
    npcChat = {
        ["eather"] = {
            [54] = {
                question = "Do you know how to advance further in the catacombs' ghoul room?",
                allSV = {[SV.ghoulBless_trackerSV] = 0},
                answer = {
                    "If you're talking about the burial chambers, then yes, I might know something about it.",
                    "I used to take pieces of leather with me to mark my way through the chambers.",
                    "I realise now that leather may not have been the way to go, but hey, I'm a tanner first!",
                    "The point was to know which tiles I had already stepped on, it seems that the goal is to step on every tile without stepping on the same one twice.",
                },
            },
            [55] = {
                question = "I got into one of the burial chambers, but I didn't know how to proceed any further.",
                allSV = {[SV.ghoulBless_trackerSV] = 1},
                setSV = {[SV.ghoulBless_hint] = 1},
                answer = {
                    "You mean the room with the snake statues?",
                    "Yes, that one can be a bit tricky.",
                    "You need to rotate the snakes into the correct position.",
                    "The snakes have to be facing the same way as the black liquid flows.",
                },
            },
        },
    },
    mapEffects = {
        ["rails"] = {posT = {{x = 623, y = 732, z = 8}, {x = 623, y = 733, z = 8}, {x = 623, y = 734, z = 8}}},
        ["gatekeeper statue"] = {pos = {x = 630, y = 731, z = 11}},
    },
    AIDItems_onLook = {
        [AIDT.blessStatue] = {text = {msg = "Gatekeeper statue - Ghoul bless"}},
    },
    AIDItems = {
        [AIDT.rail] = {funcSTR = "ghoulBlessQuest_rail"},
        [AIDT.blessStatue] = {funcSTR = "ghoulBlessQuest_bless"},
        [AIDT.puzzleStatue] = {funcSTR = "ghoulBlessQuest_turnStatue"},
    },
    AIDTiles_stepIn = {
        [AIDT.ladderDown] = {
            teleport = {x = 631, y = 733, z = 11},
            setSV = {[SV.ghoulBless_trackerSV] = 2},
        },
        [AIDT.trackerTile] = {
            allSV = {[SV.ghoulBless_trackerSV] = 0},
            setSV = {[SV.ghoulBless_trackerSV] = 1},
        },
    },
}
centralSystem_registerTable(quest_ghoulBless)

function ghoulBlessQuest_startUp()
local area = createAreaOfSquares({confT.areaCorners})
local puzzleSolution = {}
local ghoulPosT = {}

    local function registerPuzzle(pos)
        for _, itemID in pairs(confT.puzzleIDT) do
            local statue = findItem(itemID, pos)
            if statue then
                puzzleSolution[pos] = itemID
                return true
            end
        end
    end
    
    local function registerGhoulPos(pos)
        if findItem(13721, pos) or findItem(13719, pos) then return table.insert(ghoulPosT, pos) end
    end
    
    local function registerObject(pos)
        if registerPuzzle(pos) then return end
        if registerGhoulPos(pos) then return end
    end
    
    for _, pos in pairs(area) do registerObject(pos) end
    confT.puzzleSolution = puzzleSolution
    confT.ghoulPosT = ghoulPosT
    confT.tilePathT = getTilePath(confT.startPos, confT.startTileID)
end

function ghoulBlessQuest_rail(player, item)
local questSV = SV.ghoulBless_questSV
local questStatus = getSV(player, questSV)
local trackerSV = SV.ghoulBless_trackerSV

    climbOn(player, item)
    ghoulRoom_resetFloor(player)
    
    if questStatus == 0 or questStatus == 1 then return end
    setSV(player, trackerSV, 0)
    setSV(player, questSV, 0)
    player:sendTextMessage(ORANGE, "You started "..quest_ghoulBless.questlog.name..", solve ancient puzzles to advance further in this room.")
    questSystem_startQuestEffect(player)
end

function ghoulBlessQuest_bless(player, item)
local questSV = SV.ghoulBless_questSV

    if getSV(player, questSV) == 1 then return player:sendTextMessage(GREEN, "You already have Ghoul bless") end
    setSV(player, questSV, 1)
    removeSV(player, SV.ghoulBless_trackerSV)
    player:sendTextMessage(BLUE, "You now have Ghoul bless")
    player:addExpPercent(confT.exp)
    questSystem_completeQuestEffect(player)
end

local timerRunning = false
function ghoulBlessQuest_failed()
    for _, pos in pairs(confT.ghoulPosT) do createMonster("ghoul", pos) end
    timerRunning = false
end

function ghoulBlessQuest_reset(player)
    if player:getPosition().z ~= 10 then return end
local area = createAreaOfSquares({confT.areaCorners})
    
    if timerRunning then
        for _, pos in pairs(area) do
            if findCreature("player", pos) then return end
        end
    end
local timeUpTileID = confT.timeUpTileID
local interval = confT.interval
local path = confT.tilePathT
local addEventCount = tableCount(path)
    
    stopAddEvent("ghoulRoom", nil, true)
    for i, pos in ipairs(path) do registerAddEvent("ghoulRoom", i,  i * interval, {createItem, timeUpTileID, pos}) end
    registerAddEvent("ghoulRoom", addEventCount + 1,  (addEventCount + 1) * interval, {ghoulBlessQuest_failed})
    for i, pos in ipairs(path) do createItem(confT.startTileID, pos) end
    for i, pos in pairs(area) do massRemove(pos, "monster") end
    doTransform(confT.ladderDownID, confT.ladderPos, confT.ladderTileID, confT.ladderDownAID)
    createMonster("ghoul", confT.ghoulPos)
    timerRunning = true
    ghoulBlessQuest_shufflePuzzle()
end

function ghoulBlessQuest_shufflePuzzle()
    for pos, originalItemID in pairs(confT.puzzleSolution) do
        local newItemID = confT.puzzleIDT[math.random(1, 4)]
        
        for _, itemID in pairs(confT.puzzleIDT) do
            local statue = findItem(itemID, pos)
            
            if statue then
                statue:transform(newItemID)
                break
            end
        end
    end
end

local function getStatueID(item)
local itemID = item:getId()
local ID = 0

    for i, itemID2 in pairs(confT.puzzleIDT) do
        if itemID == itemID2 then
            ID = i + 1
            break
        end
    end
    if ID == 5 then ID = 1 end
    return confT.puzzleIDT[ID]
end

function ghoulBlessQuest_turnStatue(player, item)
local texts = {"*grff*", "*scree*", "*qwee*", "*rrg*"}
local pos = item:getPosition()
local newItemID = getStatueID(item)

    item:transform(newItemID)
    text(texts[math.random(1, #texts)], pos)
    ghoulBlessQuest_complete()
end

function ghoulBlessQuest_complete(player, item)
    for pos, itemID in pairs(confT.puzzleSolution) do
        if not findItem(itemID, pos) then return end
    end
    timerRunning = false
    stopAddEvent("ghoulRoom", nil, true)
    doTransform(confT.ladderTileID, confT.ladderPos, confT.ladderDownID, confT.ladderDownAID)
end