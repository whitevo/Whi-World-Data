local monsterArea = {upCorner = {x = 565, y = 721, z = 7}, downCorner = {x = 649, y = 796, z = 7}}

rootedCatacombsDesert = {
    area = {
        areaCorners = {
            {upCorner = {x = 565, y = 701, z = 7}, downCorner = {x = 653, y = 720, z = 7}},
            {upCorner = {x = 425, y = 631, z = 6}, downCorner = {x = 425, y = 631, z = 6}},
            {upCorner = {x = 623, y = 797, z = 7}, downCorner = {x = 649, y = 810, z = 7}},
            {upCorner = {x = 650, y = 721, z = 7}, downCorner = {x = 674, y = 810, z = 7}},
            monsterArea,
        },
    },
    monsterSpawns = {{
        name = "rooted catacombs desert",
        amount = 130,
        spawnTime = 10*60*1000,
        monsterT = {["skeleton"] = {}},
        areaCorners = {monsterArea},
    }},
}
centralSystem_registerTable(rootedCatacombsDesert)