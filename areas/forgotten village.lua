local AIDT = AID.areas.forgottenVillage

forgottenVillageArea = {
    startUpFunc = "clear_greenFlags",
    area = {
        areaCorners = {
            {upCorner = {x = 545, y = 701, z = 7}, downCorner = {x = 564, y = 720, z = 7}},
            {upCorner = {x = 501, y = 641, z = 7}, downCorner = {x = 626, y = 700, z = 7}},
            {upCorner = {x = 562, y = 656, z = 8}, downCorner = {x = 567, y = 662, z = 8}}, -- depot
        },
    },
    AIDItems_onLook = {
        [AIDT.smith_hammer] = {text = {msg = "This is Smith hammer, you can't take it with you.\nYou can use it to remove gems from your equipment."}},
    },
    AIDItems = {
        [AIDT.smith_hammer] = {funcStr = "tools_useTool"},
        [AIDT.wagon] = {funcSTR = "herbs_discoverHint"},
        [AIDT.greenBook] = {funcSTR = "herbs_discoverHint"},
        [AIDT.checkPoint] = {
            text = {msg = "Forgotten Village is now your Home"},
            setSV = {[SV.checkPoint] = 5, [SV.tutorial] = 1, [SV.tutorialTracker] = -1, [SV.npcLookDisabled] = -1, [SV.lookDisabled] = -1},
            ME = {pos = "playerPos", effects = 20},
        },
    },
    itemRespawns = {
        {pos = {x = 580, y = 658, z = 7}, itemID = 2674, maxAmount = 2, itemAID = AIDT.apples}, -- apples
        {pos = {x = 569, y = 656, z = 7}, itemID = 2005, spawnTime = 20, fluidType = 0},        -- bucket
        {pos = {x = 583, y = 660, z = 7}, itemID = 2005, spawnTime = 20, fluidType = 0},        -- bucket
        {pos = {x = 576, y = 671, z = 7}, itemID = 2005, spawnTime = 20, fluidType = 0},        -- bucket
        {pos = {x = 562, y = 656, z = 8}, itemID = ITEMID.other.coin, maxAmount = 20, count = 2},            -- coins
        {pos = {x = 569, y = 667, z = 7}, itemID = 2684, container = 2992, chance = 30, itemAID = AID.other.food},  -- carrot
    },
    monsterSpawns = {{
        name = "training poles",
        spawnTime = 10*60*1000,
        monsterT = {
            ["training pole"] = {},
        },
        spawnPoints = {
            {x = 563, y = 655, z = 7},
            {x = 563, y = 656, z = 7},
            {x = 563, y = 657, z = 7},
        },
    }},
}
centralSystem_registerTable(forgottenVillageArea)

function clear_greenFlags()
local positions = createAreaOfSquares(forgottenVillageArea.area.areaCorners)
    
    removeFromPositions(positions, {1437})
end