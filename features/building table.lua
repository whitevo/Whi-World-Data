--[[ building_catalog configuration guide
    [itemID] = {
        req = {{
            itemID = INT,
            itemAID = INT,
            count = INT or 1,
            fluidType = INT,
        }},
        itemAID = INT,              created item new AID
        itemName = STR              or ItemType(itemID):getName()
        dialogItemID = INT          if building system should show different itemID picture
        exp = INT,
        allSV = {[SV] = v},
        bigSV = {[SV] = v},
        group = STR,                "windows", "doors", "walls", "floors", "plantTiles", "items", "plants"
        semigroup = STR,            walls are dived to themes, maybe later same thing with items
        extraText = STR,            extraText used for making item description for modal window | "smithing" or "crafting" extratext will add experience to these categories instead
        failID = INT,               when building fails what itemID comes out then
        failChance = INT or 10      chance to create failID instead of chosen item
        takeCharges = INT           how many charges it takes and needs from hammer
        shovelCharges = INT         how many charges it takes and needs from shovel
        --
        itemID = itemID
    }
]]
destroyableFloors = {405, 406}  -- floors what can be destroyed
building_catalog = {}           -- catalog is generated with below functions
-- list of open windows, open doors or broken walls | which doesnt allow build walls/windows or doors in that position + redundant same sprite different ID items
building_dontAllowWalls = {6281, 6282, 6443, 6442, 6446, 6447, 6251, 6254, 5109, 5100, 6465, 6464, 6457, 6456, 1233, 1236, 1084, 1085, 1086, 1087, 1088, 6448, 6449, 1254, 1251, 5302, 5283, 5280, 6473, 6472, 1110, 1109, 1108, 1107, 1106, 1105, 1103, 1070, 1069, 1068, 1067, 1066, 1065, 1063}

building_groups = { -- automatically filled onStartUp
    ["wall decorations"] = {},
    walls = {},
    windows = {},
    doors = {},
    floors = {},
    plants = {}, -- 103
    items = {},
}

local mud1 = {itemID = 2005, fluidType = 19}
local slime1 = {itemID = 2005, fluidType = 4}
local brick1 = {itemID = ITEMID.materials.brick}
local sand1 = {itemID = ITEMID.materials.sand}
local sand2 = {itemID = ITEMID.materials.sand, count = 2}
local sand3 = {itemID = ITEMID.materials.sand, count = 3}
local log1 = {itemID = ITEMID.materials.log}
local log2 = {itemID = ITEMID.materials.log, count = 2}
local log3 = {itemID = ITEMID.materials.log, count = 3}
local brown_c3 = {itemID = 5913, count = 3}
local nail4 = {itemID = 8309, count = 4}
local cactusMilk1 = {itemID = 2005, fluidType = 6}
local glass1 = {itemID = 13215}
local gold1 = {itemID = 13862}
local water4 = {itemID = 2005, fluidType = 1, count = 4}

local function loadToBuildingCatalog(itemT, customT)
    if customT.failID then itemT.failID = customT.failID end
    if customT.failChance then itemT.failChance = customT.failChance end
    if customT.req then itemT.req = customT.req end
    if customT.extraText then itemT.extraText = customT.extraText end
    if customT.group then itemT.group = customT.group end
    if customT.semigroup then itemT.semigroup = customT.semigroup end
    if customT.underItemID then itemT.underItemID = customT.underItemID end
    if customT.exp then itemT.exp = customT.exp end
    if customT.itemAID then itemT.itemAID = customT.itemAID end
    if customT.allSV then itemT.allSV = customT.allSV end
    if customT.bigSV then itemT.bigSV = customT.bigSV end
    building_catalog[customT.itemID] = itemT
end

local function getWallItemT(underItemID, functionName)
    if not underItemID then return print("ERROR - missing underItemID in "..functionName.."()") end
local wallItemT = building_catalog[underItemID]
    if not wallItemT then return print("ERROR - you need to have underItemID registerd before using "..functionName.."()") end
    return wallItemT
end

local function create_windowHole(customT)
local wallItemT = getWallItemT(customT.underItemID, "create_windowHole")
    if not wallItemT then return end
local wallExp = wallItemT.exp or 1
local newExp = math.floor(wallExp/2)
local itemT = {
    req = log1,
    exp = newExp,
    group = "windows",
    extraText = "hole in wall",
    underItemID = customT.underItemID,
    failID = wallItemT.failID,
    allSV = wallItemT.allSV,
    bigSV = wallItemT.bigSV,
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_window(customT)
local wallItemT = getWallItemT(customT.underItemID, "create_window")
    if not wallItemT then return end
local wallExp = wallItemT.exp or 1
local newExp = math.floor(wallExp/2)
local itemT = {
    req = log2,
    exp = newExp,
    group = "windows",
    extraText = "closeable window",
    underItemID = customT.underItemID,
    failID = wallItemT.failID,
    allSV = wallItemT.allSV,
    bigSV = wallItemT.bigSV,
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_door(customT)
local wallItemT = getWallItemT(customT.underItemID, "create_door")
    if not wallItemT then return end
local wallExp = wallItemT.exp or 1
local newExp = math.floor(wallExp/2)
local itemT = {
    req = log3,
    exp = newExp,
    group = "doors",
    underItemID = customT.underItemID,
    failID = wallItemT.failID,
    allSV = wallItemT.allSV,
    bigSV = wallItemT.bigSV,
    itemAID = AID.building.door,
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_decoration(customT)
local wallItemT = getWallItemT(customT.underItemID, "create_decoration")
    if not wallItemT then return end
local wallExp = wallItemT.exp or 0
local itemT = {
    req = {glass1, gold1},
    exp = wallExp * 2,
    group = "wall decorations",
    underItemID = customT.underItemID,
    failID = wallItemT.failID,
    allSV = wallItemT.allSV,
    bigSV = wallItemT.bigSV,
}
    loadToBuildingCatalog(itemT, customT)
end


local function create_brickWall(customT)
local itemT = {
    req = {brick1, sand1},
    exp = 16,
    group = "walls",
    semigroup = "brick wall",
    failID = 6282,
    bigSV = {[SV.building_level] = 2},
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_bigStoneWall(customT)
local itemT = {
    req = {brick1, sand1},
    exp = 4,
    group = "walls",
    semigroup = "big stone wall",
    failID = ITEMID.materials.brick,
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_sandStoneWall(customT)
local itemT = {
    req = {brick1, sand3},
    exp = 8,
    group = "walls",
    semigroup = "sand stone wall",
    failID = ITEMID.materials.brick,
    bigSV = {[SV.building_level] = 1},
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_sandBrickWall(customT)
local itemT = {
    req = {brick1, sand2},
    exp = 16,
    group = "walls",
    semigroup = "sand brick wall",
    failID = 1087,
    bigSV = {[SV.building_level] = 3},
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_plankWall(customT)
local itemT = {
    req = {log2, nail4},
    exp = 4,
    group = "walls",
    semigroup = "wooden wall",
    failID = 5302,
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_whiteWall(customT)
local itemT = {
    req = {brick1, sand1, cactusMilk1},
    exp = 32,
    group = "walls",
    semigroup = "white wall",
    failID = ITEMID.materials.brick,
    bigSV = {[SV.building_level] = 4},
}
    loadToBuildingCatalog(itemT, customT)
end

local function create_Floor(customT)
local itemT = {
    req = {brick1, sand1, cactusMilk1},
    exp = 10,
    group = "floors",
    failChance = 0,
}
    loadToBuildingCatalog(itemT, customT)
end

create_Floor({itemID = 11146, req = mud1})
create_Floor({itemID = 405, req = log1})
create_Floor({itemID = 406, req = {brick1, cactusMilk1}, exp = 25})
create_Floor({itemID = 4695, req = slime1})

create_whiteWall({itemID = 1111, extraText = "|"})
create_whiteWall({itemID = 1112, extraText = "_"})
create_whiteWall({itemID = 1113, extraText = "."})
create_whiteWall({itemID = 1115, extraText = "_|"})
create_whiteWall({itemID = 1122, extraText = "v"})      -- archway
create_whiteWall({itemID = 1123, extraText = "^"})      -- archway
create_whiteWall({itemID = 1124, extraText = "|>"})     -- archway
create_whiteWall({itemID = 1125, extraText = "<|"})     -- archway
create_whiteWall({itemID = 1158, extraText = "_"})      -- archway
create_whiteWall({itemID = 1162, extraText = "_"})      -- archway
create_whiteWall({itemID = 1159, extraText = "|"})      -- archway
create_whiteWall({itemID = 1163, extraText = "|"})      -- archway
create_whiteWall({itemID = 9336, extraText = "_|"})     -- archway
create_whiteWall({itemID = 9335, extraText = "_|"})     -- archway
create_whiteWall({itemID = 1591, extraText = "|"})      -- rail
create_whiteWall({itemID = 1590, extraText = "_"})      -- rail
create_whiteWall({itemID = 1592, extraText = "."})      -- rail
create_whiteWall({itemID = 1593, extraText = "_|"})     -- rail
create_decoration({itemID = 1182, underItemID = 1111})
create_decoration({itemID = 1183, underItemID = 1111})
create_decoration({itemID = 1186, underItemID = 1111})
create_decoration({itemID = 1187, underItemID = 1111})
create_decoration({itemID = 1137, underItemID = 1111})
create_decoration({itemID = 1141, underItemID = 1111})
create_decoration({itemID = 1145, underItemID = 1111})
create_decoration({itemID = 1147, underItemID = 1111})
create_decoration({itemID = 1149, underItemID = 1111})
create_decoration({itemID = 1151, underItemID = 1111})
create_decoration({itemID = 1153, underItemID = 1111})
create_decoration({itemID = 1177, underItemID = 1111})
create_decoration({itemID = 1179, underItemID = 1111})
create_decoration({itemID = 1180, underItemID = 1112})
create_decoration({itemID = 1181, underItemID = 1112})
create_decoration({itemID = 1184, underItemID = 1112})
create_decoration({itemID = 1185, underItemID = 1112})
create_decoration({itemID = 1136, underItemID = 1112})
create_decoration({itemID = 1140, underItemID = 1112})
create_decoration({itemID = 1144, underItemID = 1112})
create_decoration({itemID = 1146, underItemID = 1112})
create_decoration({itemID = 1148, underItemID = 1112})
create_decoration({itemID = 1150, underItemID = 1112})
create_decoration({itemID = 1152, underItemID = 1112})
create_decoration({itemID = 1157, underItemID = 1111, req = {brick1, water4}})
create_decoration({itemID = 1156, underItemID = 1112, req = {brick1, water4}})
create_windowHole({itemID = 1272, underItemID = 1111, req = {log1, cactusMilk1}})    -- window hole ``shape: |
create_windowHole({itemID = 1271, underItemID = 1112, req = {log1, cactusMilk1}})    -- window hole ``shape: _
create_window({itemID = 5304, underItemID = 1111, req = {log1, glass1}})             -- window ``shape: |
create_window({itemID = 5303, underItemID = 1112, req = {log1, glass1}})             -- window ``shape: _
create_door({itemID = 1249, underItemID = 1111})                                    -- door ``shape: |
create_door({itemID = 1252, underItemID = 1112})                                    -- door ``shape: _

create_plankWall({itemID = 5261, extraText = "|"})
create_plankWall({itemID = 5262, extraText = "_"})
create_plankWall({itemID = 5263, extraText = "."})
create_plankWall({itemID = 5265, extraText = "_|"})
create_windowHole({itemID = 5277, underItemID = 5261})      -- window hole ``shape: |
create_windowHole({itemID = 5276, underItemID = 5262})      -- window hole ``shape: _
create_window({itemID = 6471, underItemID = 5261})          -- window ``shape: |
create_window({itemID = 6470, underItemID = 5262})          -- window ``shape: _
create_door({itemID = 5282, underItemID = 5261})            -- door ``shape: |
create_door({itemID = 5279, underItemID = 5262})            -- door ``shape: _

create_brickWall({itemID = 1025, extraText = "|"})
create_brickWall({itemID = 1026, failID = 6281, extraText = "_"})
create_brickWall({itemID = 1027, extraText = "."})
create_brickWall({itemID = 1029, failID = 6281, extraText = "_|"})
create_brickWall({itemID = 1205, extraText = "v"})                  -- archway
create_brickWall({itemID = 1206, extraText = "^"})                  -- archway
create_brickWall({itemID = 1207, failID = 6281, extraText = "|>"})  -- archway
create_brickWall({itemID = 1208, failID = 6281, extraText = "<|"})  -- archway
create_windowHole({itemID = 1266, underItemID = 1025})              -- window hole ``shape: |
create_windowHole({itemID = 1265, underItemID = 1026})              -- window hole ``shape: _
create_window({itemID = 6441, underItemID = 1025})                  -- window ``shape: |
create_window({itemID = 6440, underItemID = 1026})                  -- window ``shape: _
create_door({itemID = 5108, underItemID = 1025})                    -- door ``shape: |
create_door({itemID = 5099, underItemID = 1026})                    -- door ``shape: _

create_bigStoneWall({itemID = 1049, extraText = "|"})
create_bigStoneWall({itemID = 1050, extraText = "_"})
create_bigStoneWall({itemID = 1051, extraText = "."})
create_bigStoneWall({itemID = 1053, extraText = "_|"})
create_bigStoneWall({itemID = 1526, extraText = "|"})       -- rail
create_bigStoneWall({itemID = 1524, extraText = "_"})       -- rail
create_bigStoneWall({itemID = 1528, extraText = "."})       -- rail
create_bigStoneWall({itemID = 1530, extraText = "_|"})      -- rail
create_windowHole({itemID = 1268, underItemID = 1049})      -- window hole ``shape: |
create_windowHole({itemID = 1267, underItemID = 1050})      -- window hole ``shape: _
create_window({itemID = 6445, underItemID = 1049})          -- window ``shape: |
create_window({itemID = 6444, underItemID = 1050})          -- window ``shape: _
create_door({itemID = 6250, underItemID = 1049})            -- door ``shape: |
create_door({itemID = 6253, underItemID = 1050})            -- door ``shape: _

create_sandStoneWall({itemID = 1100, extraText = "|"})
create_sandStoneWall({itemID = 1101, extraText = "_"})
create_sandStoneWall({itemID = 1102, extraText = "."})
create_sandStoneWall({itemID = 1104, extraText = "_|"})
create_sandStoneWall({itemID = 1564, extraText = "|"})      -- rail
create_sandStoneWall({itemID = 1562, extraText = "_"})      -- rail
create_sandStoneWall({itemID = 1566, extraText = "."})      -- rail
create_sandStoneWall({itemID = 1568, extraText = "_|"})     -- rail
create_windowHole({itemID = 1276, underItemID = 1100})      -- window hole ``shape: |
create_windowHole({itemID = 1275, underItemID = 1101})      -- window hole ``shape: _
create_window({itemID = 6463, underItemID = 1100})          -- window ``shape: |
create_window({itemID = 6462, underItemID = 1101})          -- window ``shape: _

create_sandBrickWall({itemID = 1060, extraText = "|"})
create_sandBrickWall({itemID = 1061, failID = 1084, extraText = "_"})
create_sandBrickWall({itemID = 1062, extraText = "."})
create_sandBrickWall({itemID = 1064, failID = 1086, extraText = "_|"})
create_sandBrickWall({itemID = 1572, failID = 1088, extraText = "|"})   -- rail
create_sandBrickWall({itemID = 1570, failID = 1085, extraText = "|"})   -- rail
create_sandBrickWall({itemID = 1574, failID = 1088, extraText = "|"})   -- rail
create_sandBrickWall({itemID = 1576, failID = 1086, extraText = "|"})   -- rail
create_window({itemID = 6455, underItemID = 1060, req = brown_c3})      -- window ``shape: |
create_window({itemID = 6454, underItemID = 1061, req = brown_c3})      -- window ``shape: _
create_door({itemID = 1231, underItemID = 1060})                        -- door ``shape: |
create_door({itemID = 1234, underItemID = 1061})                        -- door ``shape: _


