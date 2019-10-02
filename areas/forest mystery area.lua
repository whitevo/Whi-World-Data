local AIDT = AID.areas.forestMystery
forestMysteryArea = {
    area = {
        areaCorners = {
            [1] = {upCorner = {x = 681, y = 523, z = 7}, downCorner = {x = 722, y = 556, z = 7}},
            [2] = {upCorner = {x = 701, y = 557, z = 7}, downCorner = {x = 711, y = 561, z = 7}},
            [3] = {upCorner = {x = 683, y = 525, z = 6}, downCorner = {x = 723, y = 560, z = 6}},
            [4] = {upCorner = {x = 680, y = 526, z = 5}, downCorner = {x = 724, y = 559, z = 5}},
            [5] = {upCorner = {x = 689, y = 529, z = 4}, downCorner = {x = 706, y = 559, z = 4}},
        },
    },
    itemRespawns = {
        {pos = {x = 687, y = 562, z = 8}, itemID = 2005, fluidType = 0},                    -- bucket
        {pos = {x = 718, y = 532, z = 5}, itemID = 2456, rollStats = true},                 -- bow
        {pos = {x = 692, y = 556, z = 7}, itemID = 2006, fluidType = 0, spawnTime = 30},    -- vial
        {pos = {x = 700, y = 529, z = 7}, itemID = 2006, fluidType = 0, spawnTime = 30},    -- vial
        {pos = {x = 719, y = 532, z = 6}, itemID = 2389, spawnTime = 40, maxAmount = 3},    -- spear
        {pos = {x = 716, y = 531, z = 5}, itemID = 2376, container = 6109, rollStats = true},       -- sword
        {pos = {x = 719, y = 533, z = 6}, itemID = 2544, spawnTime = 15, maxAmount = 30, count = 3},-- arrows
        {pos = {x = 685, y = 528, z = 7}, itemID = 8299, container = 1718, spawnTime = 30, itemAID = AID.herbs.dagosil_powder},
        {pos = {x = 700, y = 531, z = 6}, itemID = 5905, container = 1716, maxAmount = 3},  -- magic dust
    },
    keys = {
        ["Treasure Hunt key"] = {
            itemAID = AID.quests.treasureHunt.key,
            keyID = SV.treasureHunt_key,
            keyFrom = "Found from bird nest in Mystery Forest trough Treasure Hunt Quest",
            keyWhere = "Opens doors in Mystery Forest area",
            removeKey = true,
        },
    },
    randomLoot = {
        [AIDT.randomLoot] = {
            CDmin = 40,
            CDmax = 60,
            items = {
                {itemID = 2544, chance = 200, count = 3},   -- arrows
                {itemID = 2389, chance = 50},               -- spear
                {itemID = 2674, chance = 300, count = 2, itemAID = AID.other.food}, -- apple
                {itemID = ITEMID.other.coin, chance = 150, count = 4},   -- gold coin
                {itemID = 2006, chance = 150, type = 0},    -- vial
                {itemID = 5887, chance = 50},               -- steel
            },
        },
    },
    AIDItems = {
        [AIDT.goldBox] = {
            allSV = {[SV.goldBox_mysterArea] = -1},
            setSV = {[SV.goldBox_mysterArea] = 1},
            rewardItems = {{itemID = ITEMID.other.coin, count = 80}, {itemID = 1997}},
            textF = {msg = "You have already emptied this box."},
        },
        [AIDT.ladderInBasement] = {teleport = {x = 700, y = 552, z = 7}},
        [AIDT.floor2Rail] = {teleport = {x = 700, y = 542, z = 7}},
        [AIDT.rail] = {funcSTR = "climbOn"},
        [AIDT.window] = {funcSTR = "secretRoom_window"},
        [AIDT.lockedDoor] = {
            bigSV = {[SV.treasureHunt_key] = 0},
            setSV = {[SV.treasureHunt_key] = 1},
            funcSTR = "automaticDoor",
            textF = {msg = "This door needs key and you don't have it."},
        },
    },
    AIDTiles_stepOut = {
        [AIDT.window] = {transform = {itemID = 6444}},
    },
    AIDTiles_stepIn = {
        [AIDT.stairsToBasement] = {teleport = {x = 689, y = 559, z = 8}},
        [AIDT.stairsDown] = {teleport = {x = 691, y = 548, z = 7}},
        [AIDT.staircaseTP] = {teleport = {x = 711, y = 539, z = 7}},
    },
}
centralSystem_registerTable(forestMysteryArea)

function secretRoom_window(player, item)
    if window_onLook(player, item, true) == "closed window" then return window_onUse(player, item) end
    climbOn(player, item)
end
