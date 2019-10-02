local earlyForestArea1 = {upCorner = {x = 626, y = 566, z = 7}, downCorner = {x = 668, y = 612, z = 7}}
local earlyForestArea2 = {upCorner = {x = 641, y = 614, z = 7}, downCorner = {x = 668, y = 632, z = 7}}
local earlyForestArea3 = {upCorner = {x = 637, y = 548, z = 7}, downCorner = {x = 668, y = 565, z = 7}}
local midForestArea = {upCorner = {x = 669, y = 582, z = 7}, downCorner = {x = 691, y = 632, z = 7}}
local deepForestArea1 = {upCorner = {x = 646, y = 533, z = 7}, downCorner = {x = 674, y = 546, z = 7}}
local deepForestArea2 = {upCorner = {x = 669, y = 547, z = 7}, downCorner = {x = 674, y = 569, z = 7}}
local deepForestArea3 = {upCorner = {x = 675, y = 557, z = 7}, downCorner = {x = 696, y = 581, z = 7}}

eastForest = {
    area = {
        areaCorners = {
            [1] = earlyForestArea1,
            [2] = earlyForestArea2,
            [3] = earlyForestArea3,
            [4] = midForestArea,
            [5] = deepForestArea1,
            [6] = deepForestArea2,
            [7] = deepForestArea3,
        },
    },
    AIDItems = {
        [AID.areas.eastForest.tornBook] = {funcSTR = "herbs_discoverHint"},
    },
    AIDItems_onLook = {
        [AID.areas.eastForest.tornBook] = {text = {msg = "This book has seen better days, it looks quite rough now."}}
    },
    AIDTiles_stepIn = {
        [AID.areas.eastForest.holeToInsects] = {teleport = {x = 745, y = 668, z = 8}},
    },
    itemRespawns = {
        {pos = {x = 749, y = 673, z = 8}, itemID = 2266, container = 6023, chance = 50},    -- critblock stone
        {pos = {x = 741, y = 676, z = 8}, itemID = 2266, container = 6023, chance = 50},    -- critblock stone
    },
    monsterSpawns = {
        {
            name = "east early forest",
            amount = 25,
            spawnTime = 60*4*1000,
            monsterT = {
                ["boar"] = {},
                ["wolf"] = {amount = 3},
                ["deer"] = {},
                ["bear"] = {amount = 8},
                ["rabbit"] = {amount = 3},
            },
            areaCorners = {
                [1] = earlyForestArea1,
                [2] = earlyForestArea2,
                [3] = earlyForestArea3,
            },
        },
        {
            name = "east mid forest",
            amount = 30,
            spawnTime = 60*4*1000,
            monsterT = {
                ["boar"] = {},
                ["deer"] = {},
                ["bear"] = {},
                ["rabbit"] = {amount = 2},
                ["white deer"] = {amount = 1, spawnLockDuration = 10*60},
            },
            areaCorners = {midForestArea},
        },
        {
            name = "east deep forest",
            amount = 16,
            spawnTime = 60*3*1000,
            monsterT = {
                ["boar"] = {},
                ["bear"] = {},
            },
            areaCorners = {
                [1] = deepForestArea1,
                [2] = deepForestArea2,
                [3] = deepForestArea3,
            },
        },
    }
}
centralSystem_registerTable(eastForest)