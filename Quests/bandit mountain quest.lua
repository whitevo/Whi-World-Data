local rewardExp = 40
local AIDT = AID.quests.banditMountain
local northRegion = banditMountainNorth.area.areaCorners

quest_banditMountain = {
    startUpFunc = "banditMountainQuest_registerTrees",
    
    area = {
        areaCorners = {
            [1] = northRegion[1],
            [2] = northRegion[2],
            [3] = northRegion[3],
            [4] = northRegion[4],
        },
        blockObjects = banditMountainNorth.area.blockObjects,
    },
    questlog = {
        name = "Bandit Mountain Quest",
        questSV = SV.banditQuest,
        trackerSV = SV.banditQuestTracker,
        log = {
            [0] = "Find a key by searching the trees on the mountain.",
            [1] = "Find a use for the key.",
            [2] = "Find a gem bag hidden in one of the mountain cracks in the Bandit mountain.",
        },
        hintLog = {
            [1] = {[SV.banditQuestHint1] = "Peeter told you that there is a locked chest somewhere in the west part of the mountain."}
        },
    },
    npcChat = {
        ["peeter"] = {
            [99] = {
                question = "Do you know anything about a key hidden under a tree here?",
                allSV = {[SV.banditQuestTracker] = 0},
                answer = {"You have to find a key under a tree, with all the countless trees on this mountain?", "Hahahaha", "Good luck with that!"},
            },
            [100] = {
                question = "I found the key, any idea what it might open?",
                allSV = {[SV.banditQuestTracker] = 1},
                setSV = {[SV.banditQuestHint1] = 1},
                answer = {"Wow! You have a lot of time on your hands, don't you?!",  "But yes, I know of a locked chest all the way in the west part of this mountain.", "Maybe it fits."},
            },
            [101] = {
                question = "There was a diary inside the chest, would you know anything about this?",
                allSV = {[SV.banditQuestTracker] = 2},
                answer = {"I wonder... could it be Liam's?"},
            },
            [102] = {
                question = "I'm looking for mountain cracks, care to help?",
                allSV = {[SV.banditQuestTracker] = 2},
                answer = {"Please, could you kindly go fuck yourself?", "You are never going to find it."},
            },
        },
        ["liam"] = {
            [89] = {
                question = "Do you know anything about this diary?",
                anySVF = {[SV.liamDiary] = 1},
                moreItems = {{itemID = 1971, count = 1}},
                setSV = {[SV.liamDiary] = 1},
                answer = {"How did you get to my secret stash?", "Could you please return my diary? There is information in there I don't want people to know."},
            },
            [90] = {
                action = "Hand over the diary.",
                doAction = "You parted with the diary.",
                anySV = {[SV.liamDiary] = 1},
                moreItems = {{itemID = 1971, count = 1}},
                removeItems = {{itemID = 1971, count = 1}},
                rewardItems = {{itemID = 2152, count = 1}},
                setSV = {[SV.liamDiary] = -1},
                answer = {"Thank you. Here's something for your trouble."},
            },
            
        }
    },
    mapEffects = {
        ["note"] = {pos = {x = 456, y = 620, z = 6}},
    },
    AIDItems = {
        [AIDT.note] = {
            allSV = {[SV.banditQuest] = -1},
            setSV = {[SV.banditQuest] = 0, [SV.banditQuestTracker] = 0, [SV.banditQuestKey] = -1, [SV.banditQuestHint1] = -1},
            text = {type = ORANGE, msg = {"Quest has been accepted."}},
            textF = {
                svText = {
                    [{SV.banditQuest, 0}] = {msg = "Bandit Mountain quest has already been taken, look your questlog"},
                    [{SV.banditQuest, 1}] = {msg = "Bandit Mountain quest has been completed"},
                },
            },
            funcSTR = "banditMountainQuest_start",
        },
        [AIDT.tree] = {
            allSV = {[SV.banditQuestTracker] = 0},
            funcSTR = "banditMountainQuest_searchKey",
        },
        [AIDT.chest] = {
            allSV = {[SV.banditQuestTracker] = 1},
            rewardItems = {
                {itemID = 1971, itemText = "I found a Gem Bag, but didn't want to take that item to Hehemi. I hid the bag inside mountain wall crack which I could later pick up after I leave this place."},
            },
            setSV = {[SV.banditQuestTracker] = 2, [SV.banditQuestKey] = 1},
        },
        [AIDT.correctMountainCrack] = {
            allSV = {[SV.banditQuestTracker] = 2},
            setSV = {[SV.banditQuestTracker] = -1, [SV.banditQuest] = 1},
            rewardItems = {{itemID = gemBagConf.itemID}},
            text = {text = {msg = "Searching mountain crack."}},
            exp = rewardExp,
            funcSTR = "questSystem_completeQuestEffect",
        },
        [AIDT.incorrectMountainCrack] = {
            allSV = {[SV.banditQuestTracker] = 2},
            text = {text = {msg = "Found nothing"}},
        },
    },
    AIDItems_onLook = {
        [AIDT.note] = {text = {msg = "You see a torn page from some kind of diary."}},
        [AIDT.correctMountainCrack] = {text = {msg = "Mountain crack"}},
        [AIDT.incorrectMountainCrack] = {text = {msg = "Mountain crack"}},
    },
    AIDItems_onMove = {
        [AIDT.key] = {transform = {itemID = 0}},
    },
    keys = {
        ["Bandits Quest key"] = {
            itemAID = AIDT.key,
            removeKey = true,
            keyID = SV.banditQuestKey,
            keyFrom = "Found under a tree what was located north of the Bandit Mountain.",
            keyWhere = "Used for the chest in Bandit Mountain",
        },
    }
}
centralSystem_registerTable(quest_banditMountain)

local treeT = {2700, 2701, 2702, 2703, 2704, 2705, 2706, 2707, 2708, 2720, 7024}
local treeID = 0
local questArea = quest_banditMountain.area

function banditMountainQuest_registerTrees()
    treeID = 0
    for _, pos in pairs(createAreaOfSquares(questArea.areaCorners)) do banditMountainQuest_registerTree(pos) end
end

function banditMountainQuest_registerTree(pos)
    if not Tile(pos) then return end
    for _, itemID in pairs(questArea.blockObjects) do
        if findItem(itemID, pos) then return end
    end
    
    for _, itemID in pairs(treeT) do
        local tree = findItem(itemID, pos)
        
        if tree then
            treeID = treeID + 1
            tree:setActionId(AIDT.tree)
            tree:setText("banditMountainQuest_treeID", treeID)
            return
        end
    end
end

function banditMountainQuest_start(player, item)
    item:setAttribute(TEXT, "I found a key that opens the bandit chest, I hid the key under a tree in the Bandit Mountains")
    setSV(player, SV.BMQuestKey, math.random(1, treeID))
    questSystem_startQuestEffect(player)
end

function banditMountainQuest_searchKey(player, item)
local playerTreeID = getSV(player, SV.BMQuestKey)
local treeID = getFromText("banditMountainQuest_treeID", item:getAttribute(TEXT))

    player:say("searching under tree..", ORANGE)
    if playerTreeID ~= treeID then return player:sendTextMessage(GREEN, ".. found nothing") end
    player:sendTextMessage(ORANGE, "You found a key!")
    if not player:rewardItems({{itemID = 2086, itemAID = AIDT.key}}) then return player:sendTextMessage(GREEN, "Not enough cap") end
    setSV(player, SV.banditQuestTracker, 1)
end