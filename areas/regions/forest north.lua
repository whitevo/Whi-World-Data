local earlyForestArea = {upCorner = {x = 491, y = 584, z = 7}, downCorner = {x = 625, y = 613, z = 7}}
local midForestArea = {upCorner = {x = 505, y = 560, z = 7}, downCorner = {x = 625, y = 583, z = 7}}

northForest = {
    area = {
        areaCorners = {
            [1] = earlyForestArea,
            [2] = midForestArea,
        },
    },
    monsterSpawns = {
        {
            name = "north early forest",
            amount = 45,
            spawnTime = 60*4*1000,
            monsterT = {
                ["wolf"] = {},
                ["boar"] = {amount = 7},
                ["deer"] = {},
                ["bear"] = {amount = 3},
                ["rabbit"] = {amount = 5},
            },
            areaCorners = {earlyForestArea}
        },
        {
            name = "north mid forest",
            amount = 32,
            spawnTime = 60*4*1000,
            monsterT = {
                ["wolf"] = {amount = 5},
                ["boar"] = {},
                ["deer"] = {},
                ["bear"] = {},
                ["rabbit"] = {amount = 4},
            },
            areaCorners = {midForestArea}
        },
    }
}
centralSystem_registerTable(northForest)