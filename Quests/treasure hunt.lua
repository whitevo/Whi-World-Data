local AIDT = AID.quests.treasureHunt

treasureHuntConf = {
    rewardExp = 28,
    defaultText = "Solve the riddle and use the described object. All objects are located in forest mystery area.",
    bookText = "A coatless sentinel clings to the blue everlasting.",
    letterText = "The ancient miner hides a secret.",
    statueText = "As yellow as the sun!",
    flowerText = "Home in the sky!",
    letterText2 = "Well done, you completed my riddles\nBy the time you read this I will be long gone\nI'm leaving this place with the boat I built myself\nThere is no need for me to stay here any longer and keep watch over forest",
    treeSeedT = {}, -- generated on startUp, reward from dead tree
    mineralT = {},  -- generated on startUp, reward from dwarf statue
}

local dwarfStatueHint = {
    question = "What do you think about this riddle?",
    doAction = "you say the riddle: `"..treasureHuntConf.letterText.."`",
    answer = "You mean dwarves?",
    allSV = {[SV.treasureHunt_trackerSV] = 1, [SV.treasureHunt_hint5] = -1},
    setSV = {[SV.treasureHunt_hint5] = 1}
}

quest_treasureHunt = {
    startUpFunc = "treasureHunt_startUp",
    
    questlog = {
        name = "Treasure Hunt Quest",
        questSV = SV.treasureHunt_questSV,
        trackerSV = SV.treasureHunt_trackerSV,
        log = {
            [0] = {treasureHuntConf.defaultText, "On the book there was written: "..treasureHuntConf.bookText},    
            [1] = {treasureHuntConf.defaultText, "On the letter you found under tree there was written: "..treasureHuntConf.letterText},
            [2] = {treasureHuntConf.defaultText, "On the dwarf statue plate there was written: "..treasureHuntConf.statueText},
            [3] = {treasureHuntConf.defaultText, "On the roof near the flower there was message carved: "..treasureHuntConf.flowerText},
        },
        hintLog = {
            [0] = {
                [SV.treasureHunt_hint1] = "Tonka knew that `blue everlasting` means ocean",
                [SV.treasureHunt_hint2] = "Niine guessed that perhaps coatless sentinel is flower without leaves",
                [SV.treasureHunt_hint3] = "Bum knows that its wagon without cover which is located in open field where sun can reach",
                [SV.treasureHunt_hint4] = "Dundee guessed that it could be flagless flag post",
            },
            [1] = {
                [SV.treasureHunt_hint5] = "Someone told you that you might be looking for dwarf",
            },
            [2] = {
                [SV.treasureHunt_hint6] = "Bum guessing for something hot like fire or lava",
                [SV.treasureHunt_hint7] = "Niine knows it means sunflower",
                [SV.treasureHunt_hint8] = "Tonka guesses for its gold coin",
            },
            [3] = {
                [SV.treasureHunt_hint9] = "Alice guesses its bird nest",
            },
        },
    },
    npcChat = {
        ["tonka"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = "I have heard this one before, the blue everlasting is ocean, don't know about the first part though",
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hint1] = -1},
                setSV = {[SV.treasureHunt_hint1] = 1},
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "a gold coin?",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hint8] = -1},
                setSV = {[SV.treasureHunt_hint8] = 1},
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "Hmm, I have heard stories of cloud monsters which live above the mountains, could that be it?",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hintFail6] = -1},
                setSV = {[SV.treasureHunt_hintFail6] = 1},
            },
        },
        ["niine"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = "hmm, maybe the coatless sentinel is some kind of flower without its leaves?",
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hint2] = -1},
                setSV = {[SV.treasureHunt_hint2] = 1},
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "Obvious! Sun flower!",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hint7] = -1},
                setSV = {[SV.treasureHunt_hint7] = 1},
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "I think if we die we travel to the stars. Its beatiful place, don't you think?",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hintFail7] = -1},
                setSV = {[SV.treasureHunt_hintFail7] = 1},
            },
        },
        ["alice"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = "What an interesting riddle ... I got stuff to do.",
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hintFail1] = -1},
                setSV = {[SV.treasureHunt_hintFail1] = 1},
                closeWindow = true,
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "Why do you bother me with riddles",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hintFail3] = -1},
                setSV = {[SV.treasureHunt_hintFail3] = 1},
                closeWindow = true,
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "Sigh.. I dont know.. bird nest maybe.",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hint9] = -1},
                setSV = {[SV.treasureHunt_hint9] = 1},
            },
        },
        ["bum"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = {"ooh I know, I know. The coatless sentinel is wagon without the cover.", "And blue everlasting means its under the sky not inside some cave or building"},
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hint3] = -1},
                setSV = {[SV.treasureHunt_hint3] = 1},
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "Something hot like fire ore lava?",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hint6] = -1},
                setSV = {[SV.treasureHunt_hint6] = 1},
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "That's a hard one. No clue about that.",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hintFail8] = -1},
                setSV = {[SV.treasureHunt_hintFail8] = 1},
            },
        },
        ["eather"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = "absolutely nothing",
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hintFail2] = -1},
                setSV = {[SV.treasureHunt_hintFail2] = 1},
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "I think I have better things to do",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hintFail4] = -1},
                setSV = {[SV.treasureHunt_hintFail4] = 1},
                closeWindow = true,
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "Well my little project is to fly leathr balloons with fire magic, but don't think that's the answer.",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hintFail9] = -1},
                setSV = {[SV.treasureHunt_hintFail9] = 1},
            },
        },
        ["dundee"] = {
            [1] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.bookText.."`",
                answer = "meh, who knows. Maybe a flagpost without flag?",
                allSV = {[SV.treasureHunt_trackerSV] = 0, [SV.treasureHunt_hint4] = -1},
                setSV = {[SV.treasureHunt_hint4] = 1},
            },
            [2] = dwarfStatueHint,
            [3] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.statueText.."`",
                answer = "I don't do good with riddles",
                allSV = {[SV.treasureHunt_trackerSV] = 2, [SV.treasureHunt_hintFail5] = -1},
                setSV = {[SV.treasureHunt_hintFail5] = 1},
            },
            [4] = {
                question = "What do you think about this riddle?",
                doAction = "you say the riddle: `"..treasureHuntConf.flowerText.."`",
                answer = "There is no home in the sky, what you talking about?",
                allSV = {[SV.treasureHunt_trackerSV] = 3, [SV.treasureHunt_hintFail10] = -1},
                setSV = {[SV.treasureHunt_hintFail10] = 1},
            },
        },
    },
    
    AIDItems = {
        [AIDT.book] = {funcStr = "treasureHunt_book"},
        [AIDT.dwarfStatue] = {funcStr = "treasureHunt_dwarfStatue"},
        [AIDT.deadTree] = {funcStr = "treasureHunt_deadTree"},
        [AIDT.openWindow] = {funcStr = "climbOn"},
        [AIDT.flower] = {funcStr = "treasureHunt_flower"},
        [AIDT.nest] = {funcStr = "treasureHunt_nest"},
        
    },
    AIDItems_onLook = {
        [AIDT.book] = {text = {msg = "An old dusty book"}},
        [AIDT.dwarfStatue] = {text = {msg = "Old statue of some kind of dwarf"}},
        [AIDT.openWindow] = {text = {msg = "I think I could fit trough the window"}},
    },
    itemRespawns = {
        {spawnTime = 20, pos = {x = 705, y = 541, z = 7}, itemID = 2386, itemAID = AID.other.tool, itemText = "charges(1) maxCharges(3)"},  -- woodcutting axe
    }
}
centralSystem_registerTable(quest_treasureHunt)

function treasureHunt_startUp()
    local loopID = 0
    for seedAID, growT in pairs(farmingConf.growT) do
        if growT.isTree then
            loopID = loopID + 1
            treasureHuntConf.treeSeedT[loopID] = seedAID
        end
    end

    loopID = 0
    for oreID, oreT in pairs(miningConf.ores) do
        loopID = loopID + 1
        treasureHuntConf.mineralT[loopID] = oreID
    end
end

function treasureHunt_book(player, item)
    local questStage = player:getSV(SV.treasureHunt_questSV)
    item:setAttribute(TEXT, treasureHuntConf.bookText)
    if questStage == -1 then return treasureHunt_startQuest(player, item) end
    if questStage == 0 then return false, player:sendTextMessage(ORANGE, "You already have accepted "..quest_treasureHunt.questlog.name) end
    if questStage == 1 then return player:sendTextMessage(GREEN, "You already have completed "..quest_treasureHunt.questlog.name) end
end

function treasureHunt_startQuest(player, item)
    player:setSV(SV.treasureHunt_questSV, 0)
    player:setSV(SV.treasureHunt_trackerSV, 0)
    player:sendTextMessage(GREEN, "Quest has been accepted")
    player:sendTextMessage(BLUE, "You have found "..quest_treasureHunt.questlog.name)
    player:sendTextMessage(ORANGE, "On this ireland you need to find the objects described in riddles.")
    player:sendTextMessage(ORANGE, "These objects don't exist beyond the south mountain so no need to travel far.")
    questSystem_startQuestEffect(player)
end

function treasureHunt_deadTree(player)
    if getSV(player, SV.treasureHunt_trackerSV) ~= 0 then return end
local itemT = {
    {itemID = farmingConf.seedID, itemAID = treasureHuntConf.treeSeedT, itemName = "a tree seed"},
    {itemID = 2598, itemText = treasureHuntConf.letterText, itemName = "a letter"},
}
    player:rewardItems(itemT, true)
    player:setSV(SV.treasureHunt_trackerSV, 1)
end

function treasureHunt_dwarfStatue(player)
    if getSV(player, SV.treasureHunt_trackerSV) == 2 then return player:sendTextMessage(ORANGE, "On the statue plate there is freshly written: "..treasureHuntConf.statueText) end
    if getSV(player, SV.treasureHunt_trackerSV) ~= 1 then return end
    player:rewardItems({itemID = treasureHuntConf.mineralT, count = math.random(1, 3)}, true)
    player:sendTextMessage(ORANGE, "On the statue plate there is freshly written: "..treasureHuntConf.statueText)
    player:setSV(SV.treasureHunt_trackerSV, 2)
end

function treasureHunt_flower(player, item)
    if getSV(player, SV.treasureHunt_trackerSV) ~= 2 then return end
    player:sendTextMessage(ORANGE, "Next to the flower there is a carved message: "..treasureHuntConf.flowerText)
    player:setSV(SV.treasureHunt_trackerSV, 3)
end

function treasureHunt_nest(player, item)
    if getSV(player, SV.treasureHunt_trackerSV) ~= 3 then return end
    local itemT = {
        {itemID = 8978, itemAID = AIDT.key},
        {itemID = 2598, itemText = treasureHuntConf.letterText2, itemName = "a letter"},
    }
    questSystem_completeQuestEffect(player:getPosition())
    player:sendTextMessage(GREEN, quest_treasureHunt.questlog.name.." completed")
    player:addExpPercent(treasureHuntConf.rewardExp)
    player:rewardItems(itemT, true)
    player:setSV(SV.treasureHunt_trackerSV, -1)
    player:setSV(SV.treasureHunt_questSV, 1)
end