local rewardExp = 60
local AIDT = AID.quests.cyclopsStash
local questSV = SV.cyclopsStashQuest
local trackerSV = SV.cyclopsStashQuestTracker

quest_cyclopsStash = {
    questlog = {
        name = "Cyclops Stash Quest",
        questSV = questSV,
        trackerSV = trackerSV,
        log = {
            [0] = {"Find a use for the cyclops key.", "Talk to the NPCs, maybe someone knows something."},
            [1] = {"Find out how to get to the big iron chest in the cyclops dungeon."},
        },
        hintLog = {
            [0] = {
                [SV.cyclopsStashQuestHint] = {"Bum told you to use water on all the big fire mushrooms in the dungeon and the fire wall will disappear."},
            },
            [1] = {
                [SV.cyclopsStashQuestHint2] = {"Tonka saw something sparkling from the top of the cyclops mountain."},
            }
        },
    },
    mapEffects = {
        ["key"] = {pos = {x = 640, y = 554, z = 7}},
    },
    keys = {
        ["Cyclops Stash Quest key"] = {
            itemAID = AIDT.key,
            keyID = SV.cyclopsQuestKey,
            keyFrom = "Found near the Cyclops mountain.",
            keyWhere = "Used to unlock the chest inside the cyclops dungeon.",
        },
    },
    npcChat = {
        ["tonka"] = {
            [133] = {
                question = "Do you know what this key is for?",
                allSV = {[trackerSV] = 0},
                answer = {"Woah, you found the cyclops key! :o" ,"It could unlock some great treasures!", "I haven't really explored the cyclops dungeon, but Bum has."},
            },
            [134] = {
                question = "There is a huge iron chest in the cyclops mountain, do you know anything about it?",
                allSV = {[trackerSV] = 1, [SV.cyclopsStashQuestHint2] = -1},
                setSV = {[SV.cyclopsStashQuestHint2] = 1},
                answer = "Chests usually require keys to unlock them, I may have seen something last time I was checking what the cyclopes were up to on top of the mountain.",
            },
        },
        ["bum"] = {
            [79] = {
                question = "Do you know what this key is for?",
                allSV = {[trackerSV] = 0},
                anySVF = {[SV.cyclopsStashQuestHint] = 1},
                setSV = {[SV.cyclopsStashQuestHint] = 0},
                answer = {"No way! You found the cyclops key!!", "Bring me 5 pieces of copper ore and I will tell you what I know."},
            },
            [80] = {
                question = "I have the copper ore you asked for, now tell me what you know!",
                allSV = {[SV.cyclopsStashQuestHint] = 0, [trackerSV] = 0},
                moreItems = {{itemID = 5880, count = 5}},
                removeItems = {{itemID = 5880, count = 5}},
                setSV = {[SV.cyclopsStashQuestHint] = 1},
                answer = {"You need to use water on the fire mushrooms in the cyclops dungeon and the fire wall will disappear."},
            },
        },
    },
    AIDItems = {
        [AIDT.key] = {funcSTR = "cyclopsStash_key"},
        [AIDT.chest] = {
            allSV = {[trackerSV] = 0},
            setSV = {[questSV] = 1, [trackerSV] = -1, [SV.cyclopsQuestKey] = 1},
            rewardItems = {
                {itemID = mineralBagConf.itemID},
                {itemID = 2265, count = 3},
                {itemID = 2553, itemAID = AID.other.tool, itemText = "charges(10)"},
            },
            textF = {
                svText = {
                    [{questSV, 1}] = {msg = {"You already looted this chest."}},
                    [{SV.cyclopsQuestKey, -1}] = {msg = {"You don't have the key for this chest."}},
                    [{SV.cyclopsQuestKey, 0}] = {msg = {"You don't have the key for this chest."}},
                }
            },
            exp = rewardExp,
            funcSTR = "questSystem_completeQuestEffect",
        },
        [AIDT.ladder] = {teleport = {x = 637, y = 558, z = 7}},
    },
    AIDItems_onLook = {
        [AIDT.fireShroom] = {text = {msg = "A large fire mushroom."}},
        [AIDT.extinguishedFireShroom] = {text = {msg = "An extinguished fire mushroom."}},
        [AIDT.chest] = {
            allSV = {[questSV] = -1},
            setSV = {[questSV] = 0, [trackerSV] = 1, [SV.cyclopsQuestKey] = -1},
            textF = {msg = {"A big iron chest."}},
            text = {type = ORANGE, msg = {"Cyclops Sabotage Quest started.", "Find a way to reach the chest."}},
            funcSTR = "questSystem_startQuestEffect",
        },
    },
    AIDTiles_stepIn = {
        [AIDT.closeWallTile] = {funcSTR = "cyclopsStash_wall"},
    }
}
centralSystem_registerTable(quest_cyclopsStash)

local wetShroom = 0
local fireWallPos = {x = 771, y = 570, z = 8}

function cyclopsStashQuestShroom(pos, itemFluid)
    if not itemFluid or itemFluid ~= 1 then return end
    if not doTransform(10811, pos, 4167, AIDT.extinguishedFireShroom) then return end
    addEvent(doTransform, 1000*60*40, 4167, pos, 10811, AIDT.fireShroom)
    doSendMagicEffect(pos, {3, 12})
    addEvent(function() wetShroom = wetShroom - 1 end, 1000*60*40)
    wetShroom = wetShroom + 1
    if wetShroom ~= 3 then return true end
    removeItemFromPos(6290, fireWallPos)
    return true
end

function cyclopsStash_wall(player, item)
    if wetShroom >= 3 then return end
    if not findItem(6290, fireWallPos) then createItem(6290, fireWallPos) end
end

function cyclopsStash_key(player, item)
    if getSV(player, questSV) == -1 then
        setSV(player, {questSV, trackerSV, SV.cyclopsQuestKey}, 0)
        player:sendTextMessage(ORANGE, "Cyclops Sabotage started.")
        player:sendTextMessage(ORANGE, "Find a use for the key.")
        questSystem_startQuestEffect(player)
    elseif getSV(player, trackerSV) == 1 then
        player:sendTextMessage(GREEN, "You found the key, go back to Tonka and see if she knows how to get to the iron chest.")
        setSV(player, trackerSV, 0)
    else
        player:sendTextMessage(GREEN, "You already have this key.")
    end
end