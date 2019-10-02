local rewardExp = 80
local AIDT = AID.quests.hehemi

quest_hehemi = {
    questlog = {
        name = "Hehemi Quest",
        questSV = SV.hehemiQuest,
        trackerSV = SV.hehemiQuestTracker,
        log = {
            [0] = "Find the key on the other side of the spiral roof.",
            [1] = "Try opening the big chest on the Hehemi roof.",
        },
    },
    keys = {
        ["Hehemi quest key"] = {
            itemAID = AIDT.key,
            keyID = SV.hehemiQuestKey,
            keyFrom = "Found on the Hehemi spiral roof, the top level of Hehemi.",
            keyWhere = "Used to unlock the chest on Hehemi roof.",
        },
    },
    npcShop = {
        npcName = "eather",
        allSV = {[SV.hehemiQuest] = 1},
        items = {{itemID = seedBagConf.itemID, cost = 25}},
    },
    AIDItems = {
        [AIDT.key] = {
            allSV = {[SV.hehemiQuestTracker] = 0},
            setSV = {[SV.hehemiQuestTracker] = 1},
            funcSTR = "keys_onUse",
            textF = {msg = {"You don't need this key."}},
        },
        [AIDT.ladder] = {
            allSV = {[SV.hehemiQuest] = -1},
            setSV = {[SV.hehemiQuest] = 0, [SV.hehemiQuestTracker] = 0, [SV.hehemiQuestKey] = -1},
            text = {type = ORANGE, msg = {"Hehemi Quest started", "Pick up the purple key."}},
            funcSTR = "questSystem_startQuestEffect",
            teleport = {x = 465, y = 617, z = 8},
            teleportF = {x = 465, y = 617, z = 8},
        },
        [AIDT.chest] = {
            allSV = {[SV.hehemiQuestTracker] = 1},
            setSV = {[SV.hehemiQuestKey] = 1, [SV.hehemiQuestTracker] = -1, [SV.hehemiQuest] = 1},
            rewardItems = {{itemID = 2265, count = 5}, {itemID = seedBagConf.itemID}},
            exp = rewardExp,
            funcSTR = "questSystem_completeQuestEffect",
            text = {msg = "You can now carry 1 extra item with lootbag"},
            textF = {
                svText = {
                    [{SV.hehemiQuest, -1}] = {msg = "The chest is locked."},
                    [{SV.hehemiQuest, 0}] = {msg = "The chest is locked."},
                    [{SV.hehemiQuest, 1}] = {msg = "There's nothing inside."},
                }
            },
        },
    },
    AIDTiles_stepIn = {
        [AIDT.manaDrain] = {
            ME = {pos = "itemPos", effects = 53},
            mana = -100,
        },
    },
    AIDItems_onLook = {
       -- [AIDT.hehemi] = {text = {msg = "Bandit Town - Hehemi"}},
    },
    monsterSpawns = {
        [1] = {
            name = "hehemi quest shamans",
            spawnTime = 10*60*1000,
            monsterT = {["bandit shaman"] = {}},
            spawnPoints = {
                {x = 463, y = 614, z = 8},
                {x = 445, y = 614, z = 8},
                {x = 429, y = 614, z = 8},
                {x = 428, y = 597, z = 8},
                {x = 437, y = 589, z = 8},
                {x = 455, y = 589, z = 8},
                {x = 460, y = 601, z = 8},
                {x = 444, y = 607, z = 8},
                {x = 435, y = 599, z = 8},
                {x = 451, y = 596, z = 8},
            },
        },
        [2] = {
            name = "hehemi quest sorcerers",
            spawnTime = 10*60*1000,
            monsterT = {["bandit sorcerer"] = {}},
            spawnPoints = {
                {x = 461, y = 614, z = 8},
                {x = 453, y = 614, z = 8},
                {x = 444, y = 614, z = 8},
                {x = 435, y = 614, z = 8},
                {x = 428, y = 614, z = 8},
                {x = 428, y = 606, z = 8},
                {x = 428, y = 596, z = 8},
                {x = 430, y = 589, z = 8},
                {x = 438, y = 589, z = 8},
                {x = 447, y = 589, z = 8},
                {x = 456, y = 589, z = 8},
                {x = 460, y = 594, z = 8},
                {x = 460, y = 602, z = 8},
                {x = 454, y = 607, z = 8},
                {x = 443, y = 607, z = 8},
                {x = 435, y = 606, z = 8},
                {x = 435, y = 598, z = 8},
                {x = 442, y = 596, z = 8},
                {x = 450, y = 596, z = 8},
                {x = 452, y = 600, z = 8},
            }
        },
        [3] = {
            name = "hehemi quest rogues",
            spawnTime = 10*60*1000,
            monsterT = {["bandit rogue"] = {}},
            spawnPoints = {
                {x = 462, y = 614, z = 8},
                {x = 428, y = 605, z = 8},
                {x = 446, y = 589, z = 8},
            },
        },
        [4] = {
            name = "hehemi quest mages",
            spawnTime = 10*60*1000,
            monsterT = {["bandit mage"] = {}},
            spawnPoints = {
                {x = 428, y = 604, z = 8},
                {x = 460, y = 600, z = 8},
                {x = 435, y = 602, z = 8},
                {x = 443, y = 596, z = 8},
            },
        },
    },
}
centralSystem_registerTable(quest_hehemi)