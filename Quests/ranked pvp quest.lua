local AIDT = AID.quests.rankedPVP

rankedPVPQuestConf = {
    rewardExp = 50,
}

local quest_rankedPVP = {
        --[[
    questlog = {
        name = "fighting arena",
        questSV = SV.rankedPVP_questSV,
        trackerSV = SV.rankedPVP_trackerSV,
        log = {
            [0] = {
                "Gain 4 different blessing to enter the boss room.",
                "You get 1 blessing from each room in the Rooted catacombs.",
            },
            [1] = {"Enter boss room and kill Demon Skeleton"}
        },
        hintLog = {
            [0] = {[SV.skeletonWarrior_questSV] = "You have obtained the Skeleton Warrior blessing"},
            [0] = {[SV.ghostBless_questSV] = "You have obtained the Ghost blessing"},
            [0] = {[SV.ghoulBless_questSV] = "You have obtained the Ghoul blessing"},
            [0] = {[SV.mummyBless_questSV] = "You have obtained the Mummy blessing"},
        },
    },
    mapEffects = {
      --  ["startTile"] = {pos = {x = 623, y = 753, z = 8}},
    },
    AIDItems_onLook = {
       -- [AIDT.note] = {text = {msg = ""}},
    },
        ]]
    AIDTiles_stepIn = {
        [AIDT.enterRoom] = {teleport = {x = 652, y = 775, z = 8}},
        [AIDT.leaveRoom] = {teleport = {x = 622, y = 755, z = 8}},
    },
}

centralSystem_registerTable(quest_rankedPVP)