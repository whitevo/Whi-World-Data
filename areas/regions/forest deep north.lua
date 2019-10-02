--local AIDT = AID.areas.northDeepForest
local deepForestArea = {
    [1] = {
        upCorner = {x = 517, y = 533, z = 7},
        downCorner = {x = 622, y = 559, z = 7}
    },
    [2] = {
        upCorner = {x = 622, y = 533, z = 7},
        downCorner = {x = 630, y = 542, z = 7},
    },
}

northDeepForest = {
    area = {
        areaCorners = deepForestArea
    },
    monsterSpawns = {{
        name = "north deep forest",
        amount = 40,
        spawnTime = 60*4*1000,
        monsterT = {
            ["boar"] = {},
            ["deer"] = {amount = 10},
            ["bear"] = {},
            ["rabbit"] = {amount = 5},
        },
        areaCorners = deepForestArea,
    }},
}
centralSystem_registerTable(northDeepForest)