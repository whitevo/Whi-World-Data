--[[ npc config guide
    name = STR,                     name of the summoned npc
    npcPos = POS                    spawn position for npc at startUp and on reSpawn
    npcArea = {                     if npc steps out of this area he will walk back to npcPos or teleport there
        upCorner = POS,
        downCorner = POS,
    },

    npcChat = {}                    configT guide in data/npc/npcChat conf.lua
    npcShop = {}                    configT guide in data/npc/shopSystem conf.lua
]]

--[[ npc_conf guide
    npcChatT = {                    
        [npcName] = {               configT guide in data/npc/npcChat conf.lua
            [INT] = configT         INT = chatID (trough central system its automatic)
        }
    }                   
    npc_conf.allShopT = {           configT guide in data/npc/shopSystem conf.lua
        [INT] = configT             INT = shopID (trough central system its automatic)
    },

    allNpcNames = {STR}             list of all npc names | when npc is spawned to game its automatically added to this list

    npcButtons = {                  100 is ask | 101 is close
        [INT] = {                   buttonID | must be unique
            buttonText = STR        what is written on button
            level = INT             minimum player level required
            npcName = STR           only this npc has this button
            allSV = {[K] = V}       if storage values required
            func = STR              _G[STR](player, npcName)
        },
    }

    AUTOMATIC
    npcShops = {                    list of shopID's every npc has
        STR = {INT}                 STR = npcName | INT = shopID
    },
    npcIDT = {
        [INT] = {                   npcID
            state = enum,
            npcID = npcID,
            npcArea = creationT.npcArea,
            spawnPos = spawnPos,
            followTargetID = creatureID,
            chatTargetID = creatureID,
            chatDisabled = BOOL       
        }
    }
]]

npc_conf = {
    npcChatT = {},
    allShopT = {},
    allNpcNames = {"maya", "gameShop"},

    npcButtons = {
        [102] = {func = "shopSystem_openShop"},
        [104] = {
            buttonText = "herb info",
            npcName = "tonka",
            allSV = {[SV.tonkaHerbs] = 1},
            func = "tonkaHerbs_npcButton",
        },
        [105] = {
            buttonText = "minigame",
            npcName = "tonka",
            func = "tonka_minigameButton",
        },
        [106] = {
            buttonText = "challenges",
            level = 3,
            npcName = "dundee",
            func = "challengeEvent_button",
        },
        [107] = {
            buttonText = "provide",
            level = 4,
            npcName = "alice",
            func = "alice_repMW_create",
        },
        [108] = {
            buttonText = "tanning",
            level = 4,
            npcName = "eather",
            func = "eather_repMW_create",
        },
        [109] = {
            buttonText = "brewing",
            level = 3,
            npcName = "niine",
            func = "niine_repMW_create",
        },
        [110] = {
            buttonText = "ESCAPE",
            allSV = {[SV.tutorial_escapeButton] = 1},
            npcName = "tutorial npc",
            func = "tutorial_lootRoom_npcEscape",
        },
        [111] = {func = "equipmentTokens_npcButton"},
    },

    npcShops = {},
    npcIDT = {},
}

local npcSystem = {
    startUpFunc = "npcSystem_startUp",
    startUpPriority = 1,
}
centralSystem_registerTable(npcSystem)

dofile('data/npc/npcChat_conf.lua')
--dofile('data/npc/shopSystem_conf.lua')
dofile('data/npc/npcChat.lua')
dofile('data/npc/shopSystem.lua')
dofile('data/npc/npcRepSystem.lua')
dofile('data/npc/npcSystem.lua')
print("npcSystem loaded..")