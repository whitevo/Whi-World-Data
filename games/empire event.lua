--[[    empireConf guide
    canJoinEvent = false                can players join the event
    empireCharIDSV = INT,               storage value for player to link them with character

    map = {
        upCorner = POS,                 most up left corner of map
        downCorner = POS,               most down right corner of map
        startingLocations = {POS}       one of the positions where player is teleported when joining event first time
        chestRewards = {                
            [itemAID] = {               same config as randomLoot system in features > containers > random loot
                chestPositions = {POS}  list of positions where those chest will spawn on map
                chestID = INT or 1740   what will chest look like
            }
        }

        AUTOMATIC
        lastStartingLocationID = INT    position where last person started, so that players are kept apart from eachother when starting
        startingLocationAmount = INT    tableCount(startingLocations)
    },
    
    msgT = {
        notGod = STR,                   message when not god char tries to open config MW
        charKilled = STR,               message when player tries to enter event but character is dead
        regClosed = STR,                message when players tries to enter event but registration is closed
    }

    AUTOMATIC
    characters = {                      state of all players and player bots in the event
        ID = INT,                       character ID which links player to character
        name = STR                      player:getName()
        isDead = BOOL,                  has character had died
        creatureID = INT                player:getId() or monster:getId() | the one who is in control of character
        lastMana = INT,                 player:getMana()
        skillPoints = INT,              how many free skillpoints
        skillTree = {[SV] = INT},       skill points spent for empire event
        items = {{
            itemID = INT,
            itemAID = INT or 0,
            itemText = STR or "",
            fluidType = INT or 0,
            count = INT or 1,
            inBag = BOOL,               if the item should be created into your bag
        }},
    },
]]

-- if empireConf and tableCount(empireConf.characters) > 0 then return print("WARNING reloading empire event would delete event progress. use '!lua empireConf = {}'") end
local AIDT = AID.games.empire
local foodAID = AID.other.food

empireConf = {
    canJoinEvent = testServer(),
    empireCharIDSV = SV.empire_charID,

    map = {
        upCorner = {x = 931, y = 541, z = 7},
        downCorner = {x = 1724, y = 936, z = 7},
        startingLocations = {
            {x = 1216, y = 773, z = 7}
        },
        chestRewards = {
            [AIDT.chest_tier1] = {
                CDmin = 60*24*3,
                perPerson = true,
                itemAmount = 1,
                chestID = 1378,
                chestPositions = {
                    {x = 1637, y = 747, z = 4},
                    {x = 1656, y = 710, z = 3},
                    {x = 1655, y = 689, z = 2},
                    {x = 1641, y = 641, z = 7},
                    {x = 1593, y = 726, z = 7},
                    {x = 1648, y = 762, z = 7},
                    {x = 1581, y = 765, z = 7},
                    {x = 1680, y = 734, z = 7},
                    {x = 1631, y = 719, z = 6},
                    {x = 1593, y = 811, z = 7},
                    {x = 1244, y = 749, z = 7},
                    {x = 1266, y = 796, z = 7},
                    {x = 1252, y = 774, z = 7},
                    {x = 1266, y = 817, z = 10},
                    {x = 1246, y = 821, z = 10},
                    {x = 1092, y = 875, z = 7},
                    {x = 1069, y = 878, z = 7},
                    {x = 1015, y = 823, z = 7},
                    {x = 1080, y = 821, z = 9},
                    {x = 987, y = 593, z = 8},
                    {x = 993, y = 593, z = 8},
                    {x = 1153, y = 803, z = 6},
                    {x = 1175, y = 735, z = 5},
                    {x = 1153, y = 761, z = 5},
                    {x = 1154, y = 769, z = 4},
                    {x = 1138, y = 764, z = 6},
                    {x = 1131, y = 749, z = 6},
                    {x = 1033, y = 669, z = 3},
                    {x = 1033, y = 640, z = 4},
                    {x = 1006, y = 640, z = 3},
                    {x = 1123, y = 882, z = 8},
                    {x = 1116, y = 816, z = 6},
                    {x = 1283, y = 741, z = 9},
                    {x = 1328, y = 826, z = 6},
                    {x = 1344, y = 846, z = 7},
                    {x = 1379, y = 776, z = 7},
                    {x = 1487, y = 910, z = 4},
                    {x = 1458, y = 906, z = 7},
                    {x = 1490, y = 904, z = 6},
                    {x = 1434, y = 864, z = 6},
                    {x = 1453, y = 845, z = 7},
                    {x = 1466, y = 842, z = 3},
                    {x = 1467, y = 842, z = 3},
                    {x = 1476, y = 697, z = 6},
                    {x = 1479, y = 660, z = 6},
                    {x = 1545, y = 759, z = 9},
                    {x = 1565, y = 731, z = 10},
                },
                items = {
                    {itemID = 7457, rollStats = true},
                    {itemID = 7463, rollStats = true},
                    {itemID = 7464, rollStats = true},
                    {itemID = 7458, rollStats = true},
                    {itemID = 2183, rollStats = true},
                    {itemID = 2190, rollStats = true},
                    {itemID = 2456, rollStats = true},
                    {itemID = 2398, rollStats = true},
                    {itemID = 2380, rollStats = true},
                    {itemID = 8707, rollStats = true},
                    {itemID = 2542, rollStats = true},
                    {itemID = 12425,rollStats = true},
                }
            },
            [AIDT.chest_tier2] = {
                CDmin = 60*24*3,
                perPerson = true,
                itemAmount = 2,
                chestPositions = {
                    {x = 1707, y = 711, z = 7},
                    {x = 1657, y = 816, z = 9},
                    {x = 1683, y = 783, z = 7},
                    {x = 1599, y = 888, z = 7},
                    {x = 1565, y = 893, z = 7},
                    {x = 1415, y = 907, z = 9},
                    {x = 1468, y = 884, z = 9},
                    {x = 1419, y = 888, z = 10},
                    {x = 1427, y = 869, z = 10},
                    {x = 1580, y = 729, z = 9},
                    {x = 1575, y = 723, z = 10},
                    {x = 1551, y = 740, z = 10},
                    {x = 1575, y = 760, z = 9},
                    {x = 1556, y = 718, z = 9},
                    {x = 1563, y = 728, z = 8},
                    {x = 1493, y = 659, z = 5},
                    {x = 1489, y = 646, z = 5},
                    {x = 1537, y = 681, z = 5},
                    {x = 1503, y = 859, z = 9},
                    {x = 1535, y = 864, z = 8},
                    {x = 1502, y = 886, z = 9},
                    {x = 1470, y = 795, z = 10},
                    {x = 1541, y = 799, z = 10},
                    {x = 1528, y = 850, z = 7},
                    {x = 1481, y = 862, z = 7},
                    {x = 1354, y = 754, z = 9},
                    {x = 1441, y = 811, z = 9},
                    {x = 1406, y = 787, z = 8},
                    {x = 1360, y = 801, z = 7},
                    {x = 1294, y = 751, z = 12},
                    {x = 1331, y = 706, z = 11},
                    {x = 1278, y = 755, z = 8},
                    {x = 1217, y = 826, z = 7},
                    {x = 1139, y = 845, z = 3},
                    {x = 1143, y = 829, z = 7},
                    {x = 1122, y = 893, z = 8},
                    {x = 1107, y = 897, z = 8},
                    {x = 1085, y = 799, z = 4},
                    {x = 1043, y = 746, z = 9},
                    {x = 1070, y = 739, z = 9},
                    {x = 1095, y = 780, z = 12},
                    {x = 1082, y = 788, z = 4},
                    {x = 1159, y = 773, z = 10},
                    {x = 1227, y = 758, z = 10},
                    {x = 1238, y = 760, z = 10},
                    {x = 1206, y = 734, z = 11},
                    {x = 1196, y = 735, z = 11},
                    {x = 1154, y = 755, z = 12},
                    {x = 1115, y = 767, z = 12},
                    {x = 1204, y = 734, z = 13},
                    {x = 1204, y = 733, z = 13},
                    {x = 1148, y = 828, z = 11},
                    {x = 1141, y = 836, z = 9},
                    {x = 1084, y = 838, z = 9},
                    {x = 1090, y = 847, z = 9},
                    {x = 1101, y = 823, z = 9},
                    {x = 1100, y = 815, z = 8},
                    {x = 1077, y = 847, z = 8},
                    {x = 1061, y = 793, z = 8},
                    {x = 989, y = 610, z = 8},
                    {x = 993, y = 610, z = 8},
                    {x = 1178, y = 788, z = 8},
                    {x = 1191, y = 739, z = 5},
                    {x = 1453, y = 845, z = 7},
                    {x = 1139, y = 730, z = 4},
                    {x = 1150, y = 757, z = 4},
                    {x = 1135, y = 734, z = 8},
                    {x = 1130, y = 749, z = 8},
                    {x = 1117, y = 752, z = 8},
                    {x = 1147, y = 767, z = 8},
                    {x = 1126, y = 696, z = 3},
                    {x = 1045, y = 634, z = 6},
                    {x = 1033, y = 643, z = 6},
                    {x = 994, y = 624, z = 7},
                    {x = 1024, y = 635, z = 4},
                    {x = 1002, y = 544, z = 4},
                    {x = 1006, y = 558, z = 2},
                    {x = 972, y = 552, z = 3},
                    {x = 999, y = 587, z = 4},
                    {x = 1189, y = 850, z = 7},
                    {x = 1204, y = 857, z = 8},
                    {x = 1201, y = 819, z = 9},
                    {x = 1225, y = 824, z = 8},
                    {x = 1259, y = 831, z = 10},
                    {x = 1310, y = 801, z = 11},
                    {x = 1322, y = 763, z = 12},
                    {x = 1348, y = 738, z = 12},
                },
                items = {
                    {itemID = 2662, rollStats = true},
                    {itemID = 2663, rollStats = true},
                    {itemID = 3983, rollStats = true},
                    {itemID = 12434, rollStats = true},
                    {itemID = 11304, rollStats = true},
                    {itemID = 15409, rollStats = true},
                    {itemID = 16103, rollStats = true},
                    {itemID = 12429, rollStats = true},
                    {itemID = 15491, rollStats = true},
                    {itemID = 21692, rollStats = true},
                    {itemID = 18506, rollStats = true},
                    {itemID = 8909, rollStats = true},
                    {itemID = 2508, rollStats = true},
                    {itemID = 7730, rollStats = true},
                    {itemID = 2645, rollStats = true},
                    {itemID = 2522, rollStats = true},
                    {itemID = 18398, rollStats = true},
                    {itemID = 12442, rollStats = true},
                    {itemID = 9735, rollStats = true},
                    {itemID = 10570, rollStats = true},
                    {itemID = 11303, rollStats = true},
                    {itemID = 11117, rollStats = true},
                    {itemID = 23540, rollStats = true},
                    {itemID = 7893, rollStats = true},
                    {itemID = 18400, rollStats = true},
                    {itemID = 2507, rollStats = true},
                    {itemID = 2504, rollStats = true},
                    {itemID = 2495, rollStats = true},
                    {itemID = 15481, rollStats = true},
                    {itemID = 2537, rollStats = true},
                    {itemID = 18410, rollStats = true},
                    {itemID = 2520, rollStats = true},
                    {itemID = 3972, rollStats = true},
                    {itemID = 7903, rollStats = true},
                    {itemID = 2481, rollStats = true},
                    {itemID = 6433, rollStats = true},
                    {itemID = 18399, rollStats = true},
                    {itemID = 21725, rollStats = true},
                    {itemID = 18404, rollStats = true},
                    {itemID = 13559, rollStats = true},
                    {itemID = 6391, rollStats = true},
                    {itemID = 2532, rollStats = true},
                    {itemID = 8905, rollStats = true},
                    {itemID = 2521, rollStats = true},
                    {itemID = 11425, rollStats = true},
                    {itemID = 9776, rollStats = true},
                    {itemID = 20109, rollStats = true},
                    {itemID = 12431, rollStats = true},
                    {itemID = 2477, rollStats = true},
                    {itemID = 7896, rollStats = true},
                    {itemID = 18405, rollStats = true},
                    {itemID = 5918, rollStats = true},
                }
            },
            [AIDT.chest_tier3] = {
                CDmin = 60*24*3,
                perPerson = true,
                itemAmount = 1,
                chestID = 1746,
                chestPositions = {
                    {x = 1613, y = 772, z = 8},
                    {x = 1328, y = 681, z = 10},
                    {x = 1486, y = 698, z = 15},
                    {x = 1430, y = 935, z = 10},
                    {x = 1479, y = 673, z = 12},
                    {x = 1319, y = 776, z = 12},
                    {x = 1324, y = 834, z = 11},
                    {x = 1144, y = 809, z = 4},
                    {x = 1156, y = 797, z = 10},
                    {x = 1149, y = 797, z = 10},
                    {x = 1122, y = 798, z = 9},
                    {x = 990, y = 593, z = 8},
                    {x = 991, y = 608, z = 8},
                    {x = 1149, y = 769, z = 10},
                    {x = 1090, y = 688, z = 4},
                    {x = 1051, y = 670, z = 9},
                    {x = 1116, y = 667, z = 8},
                    {x = 935, y = 657, z = 7},
                    {x = 970, y = 679, z = 7},
                    {x = 957, y = 729, z = 13},
                    {x = 962, y = 730, z = 13},
                    {x = 944, y = 614, z = 4},
                    {x = 944, y = 616, z = 4},
                    {x = 944, y = 618, z = 4},
                },
                items = {
                    {itemID = 13760, rollStats = true},
                    {itemID = 15647, rollStats = true},
                    {itemID = 15400, rollStats = true},
                }
            },
        },
    },
    msgT = {
        notGod = "Only gods can configure empire event",
        charKilled = "Your can no longer join Empire Event, your character was killed while you were offline",
        charDead = "Your Empire Event character is dead",
        regClosed = "event registration is closed",
    },
}

if "disabled" then return print("Empire Event is disabled") end

local mapConf = empireConf.map
local empire_centralT = {
    startUpFunc = "empire_startUp",
    startUpPriority = 2,

    modalWindows = {
        [MW.empire_config] = {
            name = 'empire config panel',
            title = 'configure event',
            choices = 'empire_config_choices',
            buttons = {[100] = 'choose', [101] = 'close'},
            say = '*opened empire event panel*',
            func = 'empire_config_handleMW'
        },
    },
    onLogout = {funcStr = "empire_testMap_logOut"}, -- empire_logOut
    AIDTiles_stepIn = {
        [AIDT.enterEvent] = {funcStr = "empire_enterEvent"},
        [AIDT.tpLadderDown] = {teleport = {x = 1517, y = 823, z = 8}},
        [AIDT.tpStairDown1] = {teleport = {x = 1112, y = 677, z = 8}},
        [AIDT.tpStairUp1] = {teleport = {x = 1112, y = 682, z = 7}},
        [AIDT.tpStairDown2] = {teleport = {x = 1113, y = 677, z = 8}},
        [AIDT.tpStairUp2] = {teleport = {x = 1113, y = 682, z = 7}},
        [AIDT.tpOut1] = {teleport = {x = 999, y = 683, z = 7}},
        [AIDT.tpStairDown3] = {teleport = {x = 1055, y = 782, z = 9}},
    },
    AIDItems = {
        [AIDT.tpLadderUp] = {teleport = {x = 1517, y = 811, z = 7}},
        [AIDT.tpLadderUp2] = {teleport = {x = 1148, y = 825, z = 9}},
        [AIDT.tpLadderUp3] = {teleport = {x = 1320, y = 813, z = 7}},
    },
    AIDItems_onLook = {
        [AIDT.enterEvent] = {text = {msg = "entrance to Empire Event"}},
        [AIDT.chest_tier1] = {text = {msg = "tier 1 reward chest"}},
        [AIDT.chest_tier2] = {text = {msg = "tier 2 reward chest"}},
        [AIDT.chest_tier3] = {text = {msg = "tier 3 reward chest"}},
    },
    IDItems_onLook = {
        [1436] = {funcStr = "mapmark_onLook"},
    },
    onMove = {{funcStr = "empire_onMove"}},
    randomLoot = empireConf.map.chestRewards,
    itemRespawns = {
        {pos = {x = 1091, y = 820, z = 7}, count = 1, itemID = ITEMID.tools.saw, itemText = "charges(15)", itemAID = AID.other.tool, spwanTime = 30},
        {pos = {x = 1050, y = 827, z = 7}, count = 1, itemID = ITEMID.tools.saw, itemText = "charges(15)", itemAID = AID.other.tool, spwanTime = 30},
        {pos = {x = 1064, y = 813, z = 7}, count = 1, itemID = ITEMID.tools.iron_hammer, itemText = "charges(15)", itemAID = AID.other.tool, spwanTime = 30},
        {pos = {x = 1084, y = 808, z = 7}, count = 1, itemID = ITEMID.food.apple, maxAmount = 4, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 944, y = 702, z = 8}, count = 1, itemID = ITEMID.food.apple, maxAmount = 4, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 950, y = 697, z = 8}, count = 1, itemID = ITEMID.food.carrot, maxAmount = 2, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1620, y = 726, z = 4}, count = 1, itemID = ITEMID.food.ham,maxAmount = 1, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 974, y = 662, z = 9}, count = 1, itemID = ITEMID.food.meat, maxAmount = 3, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1048, y = 669, z = 9}, count = 2, itemID = ITEMID.upgrades.earth_gem, maxAmount = 8, spwanTime = 90},
        {pos = {x = 1048, y = 670, z = 9}, count = 2, itemID = ITEMID.upgrades.ice_gem, maxAmount = 8, spwanTime = 90},
        {pos = {x = 1048, y = 671, z = 9}, count = 2, itemID = ITEMID.upgrades.fire_gem, maxAmount = 8, spwanTime = 90},
        {pos = {x = 1156, y = 791, z = 6}, count = 2, itemID = ITEMID.food.apple, maxAmount = 5, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1155, y = 791, z = 6}, count = 1, itemID = ITEMID.food.meat, maxAmount = 3, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1150, y = 791, z = 6}, count = 1, itemID = ITEMID.food.ham, maxAmount = 2, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1150, y = 792, z = 6}, count = 1, itemID = ITEMID.food.carrot, maxAmount = 3, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1151, y = 788, z = 7}, count = 1, itemID = ITEMID.food.vial, fluidType = 1, spwanTime = 90},
        {pos = {x = 1156, y = 771, z = 6}, count = 1, itemID = ITEMID.food.meat, maxAmount = 3, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1057, y = 841, z = 7}, count = 1, itemID = ITEMID.food.meat, maxAmount = 3, itemAID = foodAID, spwanTime = 90},
        {pos = {x = 1155, y = 771, z = 6}, count = 1, itemID = ITEMID.food.ham, maxAmount = 2, itemAID = foodAID, spwanTime = 90},

        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1053, y = 858, z = 3}, count = 2, maxAmount = 2, container = 1739},
        {itemID = 2677, pos = {x = 1045, y = 770, z = 4}, count = 4, maxAmount = 10, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.ham, pos = {x = 1045, y = 771, z = 4}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.carrot, pos = {x = 1046, y = 770, z = 4}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.meat, pos = {x = 1050, y = 777, z = 4}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.meat, pos = {x = 1051, y = 769, z = 4}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.eq.genso_fedo_legs, pos = {x = 1052, y = 769, z = 4}, count = 1, container = 1774},
        {itemID = ITEMID.food.ham, pos = {x = 1135, y = 845, z = 4}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1146, y = 812, z = 4}, count = 2, maxAmount = 4, container = 1770},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1620, y = 726, z = 4}, count = 1, container = 3832},
        {itemID = ITEMID.eq.zvoid_shield, pos = {x = 1058, y = 815, z = 5}, count = 1, container = 1738},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1058, y = 820, z = 5}, count = 3, container = 1739},
        {itemID = ITEMID.food.meat, pos = {x = 1058, y = 821, z = 5}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1059, y = 815, z = 5}, count = 3, maxAmount = 6, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.eq.intrinsic_legs, pos = {x = 1059, y = 817, z = 5}, count = 1, container = 1739},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1059, y = 818, z = 5}, count = 2, maxAmount = 4, container = 1739},
        {itemID = 7367, pos = {x = 1078, y = 788, z = 5}, count = 1, container = 6109},
        {itemID = 2677, pos = {x = 1082, y = 741, z = 5}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.chamak_legs, pos = {x = 1137, y = 844, z = 5}, count = 1, container = 1738},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1138, y = 845, z = 5}, count = 2, maxAmount = 3, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1150, y = 759, z = 5}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1154, y = 771, z = 5}, count = 1, maxAmount = 3, container = 1770},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1488, y = 852, z = 5}, count = 1, container = 3833},
        {itemID = ITEMID.upgrades.armor_stone_t2, pos = {x = 1489, y = 848, z = 5}, count = 3, maxAmount = 3, container = 1770},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1492, y = 841, z = 5}, count = 1, container = 3826},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1494, y = 863, z = 5}, count = 1, maxAmount = 4, container = 1774},
        {itemID = ITEMID.food.meat, pos = {x = 1501, y = 890, z = 5}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1749},
        {itemID = ITEMID.food.carrot, pos = {x = 1503, y = 849, z = 5}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.eq.demonic_legs, pos = {x = 1527, y = 802, z = 5}, count = 1, container = 6112},
        {itemID = 2376, pos = {x = 1527, y = 803, z = 5}, count = 1, container = 6110},
        {itemID = ITEMID.eq.bloody_shirt, pos = {x = 1528, y = 795, z = 5}, count = 1, container = 6111},
        {itemID = ITEMID.eq.kodayasu_shield, pos = {x = 1643, y = 696, z = 5}, count = 1, container = 1740},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1659, y = 726, z = 5}, count = 1, container = 3833},
        {itemID = ITEMID.eq.demonic_robe, pos = {x = 1662, y = 725, z = 5}, count = 1, container = 1987},
        {itemID = ITEMID.food.carrot, pos = {x = 1663, y = 727, z = 5}, count = 4, maxAmount = 8, itemAID = foodAID, container = 1999},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1042, y = 776, z = 6}, count = 1, maxAmount = 2, container = 1740},
        {itemID = ITEMID.food.meat, pos = {x = 1045, y = 806, z = 6}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.ham, pos = {x = 1045, y = 807, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1046, y = 806, z = 6}, count = 1, maxAmount = 2, container = 1770},
        {itemID = 1959, pos = {x = 1056, y = 815, z = 6}, count = 1, container = 1718},
        {itemID = 1966, pos = {x = 1056, y = 817, z = 6}, count = 1, container = 1718},
        {itemID = 1966, pos = {x = 1056, y = 819, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1056, y = 820, z = 6}, count = 1, container = 1725},
        {itemID = 1964, pos = {x = 1056, y = 821, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.arogja_hat, pos = {x = 1056, y = 823, z = 6}, count = 1, container = 1725},
        {itemID = 1964, pos = {x = 1057, y = 815, z = 6}, count = 1, container = 1719},
        {itemID = 1960, pos = {x = 1057, y = 817, z = 6}, count = 1, container = 1719},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1057, y = 819, z = 6}, count = 1, maxAmount = 3, container = 1720},
        {itemID = 1961, pos = {x = 1057, y = 821, z = 6}, count = 1, container = 1719},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1058, y = 815, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.leather_boots, pos = {x = 1058, y = 843, z = 6}, count = 1, container = 1726},
        {itemID = 1966, pos = {x = 1059, y = 815, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.traptrix_coat, pos = {x = 1060, y = 810, z = 6}, count = 1, container = 6112},
        {itemID = ITEMID.eq.precision_robe, pos = {x = 1060, y = 815, z = 6}, count = 1, container = 1724},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1060, y = 817, z = 6}, count = 2, maxAmount = 2, container = 1718},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1060, y = 821, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.leather_boots, pos = {x = 1060, y = 837, z = 6}, count = 1, container = 1716},
        {itemID = 1959, pos = {x = 1061, y = 815, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.upgrades.speed_stone, pos = {x = 1061, y = 817, z = 6}, count = 1, container = 1718},
        {itemID = 1963, pos = {x = 1061, y = 821, z = 6}, count = 1, container = 1718},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1063, y = 837, z = 6}, count = 1, container = 1716},
        {itemID = ITEMID.eq.chivit_boots, pos = {x = 1074, y = 796, z = 6}, count = 1, container = 6112},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1081, y = 741, z = 6}, count = 2, maxAmount = 8, container = 1738},
        {itemID = ITEMID.food.ham, pos = {x = 1083, y = 743, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1088, y = 740, z = 6}, count = 1, maxAmount = 2, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1088, y = 809, z = 6}, count = 3, maxAmount = 3, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.eq.blessed_turban, pos = {x = 1089, y = 811, z = 6}, count = 1, container = 1715},
        {itemID = 2677, pos = {x = 1090, y = 841, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.meat, pos = {x = 1091, y = 737, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1738},
        {itemID = 1958, pos = {x = 1091, y = 821, z = 6}, count = 1, container = 1721},
        {itemID = ITEMID.food.meat, pos = {x = 1091, y = 841, z = 6}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1750},
        {itemID = ITEMID.food.meat, pos = {x = 1091, y = 842, z = 6}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1091, y = 847, z = 6}, count = 1, container = 1715},
        {itemID = ITEMID.food.carrot, pos = {x = 1097, y = 822, z = 6}, count = 4, maxAmount = 6, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.apple, pos = {x = 1097, y = 824, z = 6}, count = 3, maxAmount = 7, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1098, y = 824, z = 6}, count = 1, maxAmount = 2, container = 1739},
        {itemID = 2677, pos = {x = 1157, y = 866, z = 6}, count = 4, maxAmount = 4, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.food.carrot, pos = {x = 1157, y = 874, z = 6}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1741},
        {itemID = 2677, pos = {x = 1280, y = 749, z = 6}, count = 2, maxAmount = 4, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1282, y = 755, z = 6}, count = 2, maxAmount = 3, container = 1738},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1449, y = 933, z = 6}, count = 2, maxAmount = 3, container = 1740},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1451, y = 833, z = 6}, count = 1, container = 1712},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1451, y = 834, z = 6}, count = 1, container = 1713},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1452, y = 831, z = 6}, count = 2, maxAmount = 3, container = 1738},
        {itemID = ITEMID.eq.hood_talent, pos = {x = 1453, y = 830, z = 6}, count = 1, container = 1724},
        {itemID = ITEMID.food.meat, pos = {x = 1453, y = 836, z = 6}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1469, y = 710, z = 6}, count = 3, container = 3106},
        {itemID = ITEMID.food.meat, pos = {x = 1498, y = 855, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1748},
        {itemID = ITEMID.food.meat, pos = {x = 1499, y = 853, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.eq.bianhuren_shield, pos = {x = 1502, y = 803, z = 6}, count = 1, container = 6112},
        {itemID = ITEMID.eq.bianhuren_shield, pos = {x = 1511, y = 796, z = 6}, count = 1, container = 6111},
        {itemID = ITEMID.eq.pinpua_hood, pos = {x = 1517, y = 796, z = 6}, count = 1, container = 6111},
        {itemID = 2376, pos = {x = 1527, y = 802, z = 6}, count = 1, container = 6110},
        {itemID = ITEMID.eq.mace, pos = {x = 1527, y = 803, z = 6}, count = 1, container = 6110},
        {itemID = ITEMID.eq.gribit_legs, pos = {x = 1529, y = 795, z = 6}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_backpack, pos = {x = 1535, y = 803, z = 6}, count = 1, container = 6111},
        {itemID = 2677, pos = {x = 1645, y = 697, z = 6}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1646, y = 695, z = 6}, count = 1, maxAmount = 2, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1670, y = 670, z = 6}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.apple, pos = {x = 1671, y = 670, z = 6}, count = 3, maxAmount = 3, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.meat, pos = {x = 1672, y = 670, z = 6}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.meat, pos = {x = 1673, y = 672, z = 6}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1673, y = 673, z = 6}, count = 3, maxAmount = 16, container = 1770},
        {itemID = ITEMID.eq.snaipa_helmet, pos = {x = 1673, y = 674, z = 6}, count = 1, container = 1770},
        {itemID = ITEMID.eq.gribit_legs, pos = {x = 1023, y = 843, z = 7}, count = 1, container = 1739},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1025, y = 843, z = 7}, count = 2, maxAmount = 3, container = 1770},
        {itemID = ITEMID.eq.traptrix_quiver, pos = {x = 1042, y = 834, z = 7}, count = 1, container = 1770},
        {itemID = 1959, pos = {x = 1050, y = 662, z = 7}, count = 1, container = 1718},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1050, y = 665, z = 7}, count = 1, maxAmount = 1, container = 1721},
        {itemID = 1959, pos = {x = 1050, y = 666, z = 7}, count = 1, container = 1722},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1050, y = 824, z = 7}, count = 1, container = 1716},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1051, y = 662, z = 7}, count = 1, container = 1719},
        {itemID = ITEMID.food.apple, pos = {x = 1052, y = 827, z = 7}, count = 3, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1054, y = 662, z = 7}, count = 2, maxAmount = 2, container = 1739},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1054, y = 666, z = 7}, count = 3, container = 1739},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1055, y = 662, z = 7}, count = 2, maxAmount = 2, container = 1739},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1055, y = 663, z = 7}, count = 2, maxAmount = 2, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1055, y = 666, z = 7}, count = 2, maxAmount = 6, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.kodayasu_shield, pos = {x = 1056, y = 843, z = 7}, count = 1, container = 1770},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1058, y = 827, z = 7}, count = 1, maxAmount = 5, container = 1738},
        {itemID = ITEMID.eq.snaipa_helmet, pos = {x = 1058, y = 828, z = 7}, count = 1, container = 1738},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1059, y = 827, z = 7}, count = 1, maxAmount = 1, container = 1738},
        {itemID = ITEMID.eq.nami_boots, pos = {x = 1060, y = 827, z = 7}, count = 1, container = 1738},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1070, y = 806, z = 7}, count = 2, maxAmount = 3, container = 1738},
        {itemID = ITEMID.eq.chokkan_shield, pos = {x = 1076, y = 817, z = 7}, count = 1, container = 1988},
        {itemID = ITEMID.food.meat, pos = {x = 1084, y = 795, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.ham, pos = {x = 1090, y = 742, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1090, y = 835, z = 7}, count = 2, maxAmount = 4, itemAID = foodAID, container = 1738},
        {itemID = 1961, pos = {x = 1090, y = 846, z = 7}, count = 1, container = 1718},
        {itemID = ITEMID.food.apple, pos = {x = 1091, y = 742, z = 7}, count = 3, maxAmount = 6, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1091, y = 835, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = 2677, pos = {x = 1092, y = 831, z = 7}, count = 3, maxAmount = 5, itemAID = foodAID, container = 1988},
        {itemID = ITEMID.upgrades.speed_stone, pos = {x = 1092, y = 835, z = 7}, count = 3, maxAmount = 8, container = 1739},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1096, y = 820, z = 7}, count = 1, container = 1721},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1096, y = 822, z = 7}, count = 1, container = 1721},
        {itemID = ITEMID.food.apple, pos = {x = 1106, y = 729, z = 7}, count = 4, maxAmount = 12, itemAID = foodAID, container = 2837},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1107, y = 725, z = 7}, count = 1, maxAmount = 1, container = 2836},
        {itemID = ITEMID.eq.kamikaze_mask, pos = {x = 1107, y = 729, z = 7}, count = 1, container = 2906},
        {itemID = ITEMID.food.ham, pos = {x = 1111, y = 729, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 2837},
        {itemID = 2677, pos = {x = 1112, y = 735, z = 7}, count = 4, maxAmount = 4, itemAID = foodAID, container = 2836},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1114, y = 733, z = 7}, count = 3, container = 2837},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1121, y = 884, z = 7}, count = 1, maxAmount = 2, container = 1738},
        {itemID = ITEMID.eq.traptrix_coat, pos = {x = 1153, y = 788, z = 7}, count = 1, container = 6112},
        {itemID = ITEMID.food.meat, pos = {x = 1153, y = 802, z = 7}, count = 2, maxAmount = 6, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.kakki_boots, pos = {x = 1153, y = 803, z = 7}, count = 1, container = 1739},
        {itemID = ITEMID.food.meat, pos = {x = 1153, y = 804, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = 2677, pos = {x = 1153, y = 869, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1154, y = 802, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = 2677, pos = {x = 1154, y = 872, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.apple, pos = {x = 1156, y = 867, z = 7}, count = 4, maxAmount = 11, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.food.carrot, pos = {x = 1156, y = 873, z = 7}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.stone_armor, pos = {x = 1156, y = 874, z = 7}, count = 1, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1157, y = 871, z = 7}, count = 4, maxAmount = 4, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.ham, pos = {x = 1157, y = 872, z = 7}, count = 2, maxAmount = 5, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.carrot, pos = {x = 1157, y = 876, z = 7}, count = 4, maxAmount = 6, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1164, y = 844, z = 7}, count = 4, maxAmount = 12, itemAID = foodAID, container = 3129},
        {itemID = ITEMID.food.ham, pos = {x = 1214, y = 763, z = 7}, count = 2, maxAmount = 5, itemAID = foodAID, container = 6072},
        {itemID = ITEMID.food.ham, pos = {x = 1232, y = 776, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1233, y = 777, z = 7}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1234, y = 776, z = 7}, count = 1, maxAmount = 3, container = 1740},
        {itemID = ITEMID.food.meat, pos = {x = 1235, y = 776, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.meat, pos = {x = 1279, y = 756, z = 7}, count = 2, maxAmount = 4, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1282, y = 751, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1289, y = 758, z = 7}, count = 2, maxAmount = 5, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.food.apple, pos = {x = 1292, y = 765, z = 7}, count = 3, maxAmount = 7, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1398, y = 745, z = 7}, count = 2, maxAmount = 4, container = 1739},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1398, y = 746, z = 7}, count = 2, container = 1770},
        {itemID = ITEMID.food.meat, pos = {x = 1399, y = 744, z = 7}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.eq.shimasu_legs, pos = {x = 1399, y = 745, z = 7}, count = 1, container = 1774},
        {itemID = 2677, pos = {x = 1400, y = 744, z = 7}, count = 3, maxAmount = 6, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.meat, pos = {x = 1421, y = 848, z = 7}, count = 2, maxAmount = 4, itemAID = foodAID, container = 1748},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1423, y = 845, z = 7}, count = 1, container = 1716},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1479, y = 924, z = 7}, count = 1, container = 1716},
        {itemID = ITEMID.food.apple, pos = {x = 1480, y = 928, z = 7}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.apple, pos = {x = 1482, y = 925, z = 7}, count = 3, maxAmount = 8, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.food.ham, pos = {x = 1483, y = 924, z = 7}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.apple, pos = {x = 1500, y = 869, z = 7}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1774},
        {itemID = 2677, pos = {x = 1500, y = 870, z = 7}, count = 4, maxAmount = 5, itemAID = foodAID, container = 1749},
        {itemID = ITEMID.food.apple, pos = {x = 1510, y = 871, z = 7}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1747},
        {itemID = ITEMID.upgrades.speed_stone, pos = {x = 1511, y = 871, z = 7}, count = 1, maxAmount = 20, container = 2830},
        {itemID = ITEMID.eq.leather_bag, pos = {x = 1516, y = 818, z = 7}, count = 1, container = 6111},
        {itemID = ITEMID.eq.snaipa_helmet, pos = {x = 1520, y = 800, z = 7}, count = 1, container = 6111},
        {itemID = ITEMID.eq.stone_legs, pos = {x = 1525, y = 814, z = 7}, count = 1, container = 6112},
        {itemID = ITEMID.eq.bow, pos = {x = 1533, y = 803, z = 7}, count = 1, container = 6109},
        {itemID = ITEMID.eq.bianhuren_shield, pos = {x = 1534, y = 809, z = 7}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1580, y = 858, z = 7}, count = 1, container = 1712},
        {itemID = ITEMID.eq.arogja_hat, pos = {x = 1580, y = 859, z = 7}, count = 1, container = 1713},
        {itemID = 1960, pos = {x = 1580, y = 861, z = 7}, count = 1, container = 1718},
        {itemID = 1963, pos = {x = 1653, y = 599, z = 7}, count = 1, container = 3830},
        {itemID = ITEMID.eq.leather_armor, pos = {x = 1655, y = 599, z = 7}, count = 1, container = 3832},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1657, y = 599, z = 7}, count = 1, container = 6110},
        {itemID = ITEMID.eq.demonic_shield, pos = {x = 1657, y = 601, z = 7}, count = 1, container = 6112},
        {itemID = 2677, pos = {x = 1661, y = 681, z = 7}, count = 4, maxAmount = 9, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1052, y = 667, z = 8}, count = 1, container = 6110},
        {itemID = ITEMID.eq.shimasu_legs, pos = {x = 1052, y = 668, z = 8}, count = 1, container = 6112},
        {itemID = ITEMID.food.meat, pos = {x = 1052, y = 810, z = 8}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.apple, pos = {x = 1052, y = 812, z = 8}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1747},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1053, y = 657, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.food.carrot, pos = {x = 1053, y = 810, z = 8}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1740},
        {itemID = 2677, pos = {x = 1053, y = 812, z = 8}, count = 3, maxAmount = 7, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1054, y = 657, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.food.apple, pos = {x = 1054, y = 812, z = 8}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1055, y = 800, z = 8}, count = 3, container = 1739},
        {itemID = ITEMID.eq.stone_armor, pos = {x = 1056, y = 775, z = 8}, count = 1, container = 1753},
        {itemID = 2677, pos = {x = 1056, y = 800, z = 8}, count = 4, maxAmount = 7, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.intrinsic_legs, pos = {x = 1060, y = 669, z = 8}, count = 1, container = 6112},
        {itemID = ITEMID.eq.amanita_hat, pos = {x = 1061, y = 657, z = 8}, count = 1, container = 1716},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1062, y = 669, z = 8}, count = 1, container = 1714},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1062, y = 767, z = 8}, count = 1, maxAmount = 3, container = 1740},
        {itemID = 2677, pos = {x = 1063, y = 767, z = 8}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.genso_fedo_legs, pos = {x = 1064, y = 655, z = 8}, count = 1, container = 6112},
        {itemID = ITEMID.food.apple, pos = {x = 1064, y = 747, z = 8}, count = 2, maxAmount = 5, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.ham, pos = {x = 1064, y = 767, z = 8}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1065, y = 747, z = 8}, count = 1, maxAmount = 3, container = 1770},
        {itemID = 2677, pos = {x = 1065, y = 758, z = 8}, count = 2, maxAmount = 5, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1066, y = 659, z = 8}, count = 1, container = 1716},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1066, y = 666, z = 8}, count = 1, container = 1716},
        {itemID = ITEMID.food.apple, pos = {x = 1066, y = 748, z = 8}, count = 4, maxAmount = 11, itemAID = foodAID, container = 1748},
        {itemID = ITEMID.food.meat, pos = {x = 1066, y = 775, z = 8}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.eq.pinpua_hood, pos = {x = 1067, y = 669, z = 8}, count = 1, container = 6111},
        {itemID = 2376, pos = {x = 1068, y = 654, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1068, y = 669, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1068, y = 775, z = 8}, count = 2, maxAmount = 3, container = 1751},
        {itemID = 7367, pos = {x = 1069, y = 654, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1069, y = 669, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.food.ham, pos = {x = 1069, y = 775, z = 8}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1070, y = 746, z = 8}, count = 2, maxAmount = 9, container = 1774},
        {itemID = ITEMID.food.apple, pos = {x = 1070, y = 762, z = 8}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1071, y = 746, z = 8}, count = 4, maxAmount = 11, itemAID = foodAID, container = 1774},
        {itemID = ITEMID.food.carrot, pos = {x = 1071, y = 774, z = 8}, count = 3, maxAmount = 5, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.apple, pos = {x = 1077, y = 759, z = 8}, count = 4, maxAmount = 12, itemAID = foodAID, container = 1739},
        {itemID = 2677, pos = {x = 1078, y = 759, z = 8}, count = 3, maxAmount = 8, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1078, y = 765, z = 8}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1084, y = 659, z = 8}, count = 1, container = 1716},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1084, y = 673, z = 8}, count = 1, container = 1717},
        {itemID = 2677, pos = {x = 1084, y = 807, z = 8}, count = 4, maxAmount = 4, itemAID = foodAID, container = 1740},
        {itemID = 2677, pos = {x = 1085, y = 726, z = 8}, count = 1, maxAmount = 1, itemAID = foodAID, container = 6022},
        {itemID = ITEMID.eq.demonic_legs, pos = {x = 1086, y = 659, z = 8}, count = 1, container = 6111},
        {itemID = 2376, pos = {x = 1087, y = 674, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1087, y = 797, z = 8}, count = 1, container = 1714},
        {itemID = ITEMID.eq.yashiteki_armor, pos = {x = 1088, y = 656, z = 8}, count = 1, container = 6111},
        {itemID = ITEMID.eq.chamak_legs, pos = {x = 1088, y = 674, z = 8}, count = 1, container = 6111},
        {itemID = ITEMID.eq.demonic_shield, pos = {x = 1088, y = 760, z = 8}, count = 1, container = 1748},
        {itemID = ITEMID.eq.hand_axe, pos = {x = 1089, y = 656, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.eq.leather_boots, pos = {x = 1089, y = 658, z = 8}, count = 1, container = 1717},
        {itemID = ITEMID.food.carrot, pos = {x = 1089, y = 756, z = 8}, count = 2, maxAmount = 6, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.food.carrot, pos = {x = 1090, y = 761, z = 8}, count = 2, maxAmount = 4, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.meat, pos = {x = 1091, y = 761, z = 8}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1094, y = 677, z = 8}, count = 1, container = 1714},
        {itemID = ITEMID.food.apple, pos = {x = 1094, y = 756, z = 8}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1095, y = 757, z = 8}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.carrot, pos = {x = 1126, y = 851, z = 8}, count = 4, maxAmount = 10, itemAID = foodAID, container = 2837},
        {itemID = ITEMID.food.apple, pos = {x = 1128, y = 847, z = 8}, count = 3, maxAmount = 5, itemAID = foodAID, container = 3059},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1128, y = 850, z = 8}, count = 3, maxAmount = 7, container = 2836},
        {itemID = ITEMID.eq.stone_shield, pos = {x = 1128, y = 851, z = 8}, count = 1, container = 3097},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1128, y = 856, z = 8}, count = 3, maxAmount = 4, container = 2836},
        {itemID = ITEMID.food.ham, pos = {x = 1129, y = 847, z = 8}, count = 1, maxAmount = 1, itemAID = foodAID, container = 2837},
        {itemID = ITEMID.eq.bianhuren_shield, pos = {x = 1129, y = 854, z = 8}, count = 1, container = 2837},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1130, y = 855, z = 8}, count = 1, maxAmount = 4, container = 2836},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1134, y = 851, z = 8}, count = 2, maxAmount = 3, container = 2836},
        {itemID = ITEMID.food.ham, pos = {x = 1190, y = 788, z = 8}, count = 2, maxAmount = 4, itemAID = foodAID, container = 5965},
        {itemID = ITEMID.food.ham, pos = {x = 1191, y = 792, z = 8}, count = 2, maxAmount = 6, itemAID = foodAID, container = 5965},
        {itemID = 2677, pos = {x = 1192, y = 790, z = 8}, count = 2, maxAmount = 6, itemAID = foodAID, container = 5965},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1197, y = 785, z = 8}, count = 2, maxAmount = 4, container = 5965},
        {itemID = ITEMID.food.meat, pos = {x = 1197, y = 790, z = 8}, count = 2, maxAmount = 5, itemAID = foodAID, container = 5965},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1206, y = 766, z = 8}, count = 2, maxAmount = 2, container = 1987},
        {itemID = ITEMID.eq.yashimaki_shield, pos = {x = 1210, y = 768, z = 8}, count = 1, container = 1987},
        {itemID = ITEMID.eq.supaky_shield, pos = {x = 1211, y = 718, z = 8}, count = 1, container = 6080},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1211, y = 764, z = 8}, count = 1, maxAmount = 3, container = 1987},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1396, y = 867, z = 8}, count = 1, container = 1417},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1400, y = 859, z = 8}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1400, y = 860, z = 8}, count = 2, maxAmount = 4, container = 1419},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1411, y = 866, z = 8}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1415, y = 852, z = 8}, count = 1, maxAmount = 2, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1416, y = 852, z = 8}, count = 6, maxAmount = 85, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1427, y = 857, z = 8}, count = 8, maxAmount = 57, container = 1417},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1431, y = 866, z = 8}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1450, y = 876, z = 8}, count = 1, container = 1419},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1451, y = 856, z = 8}, count = 1, maxAmount = 21, container = 1419},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1509, y = 932, z = 8}, count = 1, container = 6109},
        {itemID = ITEMID.eq.yashimaki_shield, pos = {x = 1513, y = 933, z = 8}, count = 1, container = 6112},
        {itemID = ITEMID.eq.mace, pos = {x = 1044, y = 669, z = 9}, count = 1, container = 6110},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1044, y = 670, z = 9}, count = 1, container = 6110},
        {itemID = ITEMID.eq.stone_legs, pos = {x = 1044, y = 671, z = 9}, count = 1, container = 6112},
        {itemID = 2376, pos = {x = 1051, y = 661, z = 9}, count = 1, container = 6109},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1054, y = 817, z = 9}, count = 1, maxAmount = 20, container = 6560},
        {itemID = ITEMID.food.apple, pos = {x = 1057, y = 789, z = 9}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = 1960, pos = {x = 1057, y = 791, z = 9}, count = 1, container = 1718},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1057, y = 792, z = 9}, count = 1, container = 1727},
        {itemID = 2677, pos = {x = 1062, y = 778, z = 9}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1741},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1119, y = 796, z = 9}, count = 3, maxAmount = 3, container = 1410},
        {itemID = ITEMID.food.ham, pos = {x = 1127, y = 807, z = 9}, count = 2, maxAmount = 5, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.other.coin, pos = {x = 1127, y = 818, z = 9}, count = 17, maxAmount = 54, container = 1415},
        {itemID = ITEMID.food.ham, pos = {x = 1132, y = 812, z = 9}, count = 2, maxAmount = 4, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.food.ham, pos = {x = 1132, y = 821, z = 9}, count = 1, maxAmount = 1, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.food.meat, pos = {x = 1134, y = 801, z = 9}, count = 1, maxAmount = 2, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.upgrades.armor_stone_t2, pos = {x = 1138, y = 796, z = 9}, count = 3, maxAmount = 3, container = 1415},
        {itemID = ITEMID.food.ham, pos = {x = 1141, y = 810, z = 9}, count = 1, maxAmount = 2, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.food.ham, pos = {x = 1141, y = 816, z = 9}, count = 1, maxAmount = 1, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.food.meat, pos = {x = 1143, y = 800, z = 9}, count = 1, maxAmount = 2, itemAID = foodAID, container = 5972},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1145, y = 809, z = 9}, count = 1, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1153, y = 805, z = 9}, count = 10, maxAmount = 79, container = 1415},
        {itemID = ITEMID.food.ham, pos = {x = 1213, y = 759, z = 9}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = 2677, pos = {x = 1219, y = 764, z = 9}, count = 4, maxAmount = 5, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.other.coin, pos = {x = 1299, y = 807, z = 9}, count = 9, maxAmount = 86, container = 1419},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1299, y = 808, z = 9}, count = 1, maxAmount = 1, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1300, y = 813, z = 9}, count = 2, maxAmount = 2, container = 1413},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1304, y = 813, z = 9}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1307, y = 834, z = 9}, count = 2, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1308, y = 812, z = 9}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1311, y = 812, z = 9}, count = 4, maxAmount = 17, container = 1419},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1313, y = 834, z = 9}, count = 1, container = 1419},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1316, y = 814, z = 9}, count = 2, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1318, y = 809, z = 9}, count = 2, maxAmount = 8, container = 1415},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1318, y = 814, z = 9}, count = 3, maxAmount = 11, container = 1419},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1319, y = 807, z = 9}, count = 2, maxAmount = 3, container = 1419},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1320, y = 813, z = 9}, count = 1, maxAmount = 2, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1321, y = 811, z = 9}, count = 9, maxAmount = 27, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1398, y = 875, z = 9}, count = 19, maxAmount = 82, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1416, y = 887, z = 9}, count = 4, maxAmount = 17, container = 1415},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1433, y = 854, z = 9}, count = 2, container = 1417},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1434, y = 854, z = 9}, count = 1, maxAmount = 3, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1435, y = 900, z = 9}, count = 20, maxAmount = 26, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1437, y = 876, z = 9}, count = 3, maxAmount = 27, container = 1417},
        {itemID = ITEMID.food.meat, pos = {x = 1437, y = 901, z = 9}, count = 1, maxAmount = 1, itemAID = foodAID, container = 3069},
        {itemID = ITEMID.other.coin, pos = {x = 1438, y = 886, z = 9}, count = 12, maxAmount = 84, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1454, y = 878, z = 9}, count = 15, maxAmount = 40, container = 1415},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1456, y = 889, z = 9}, count = 3, maxAmount = 5, container = 1419},
        {itemID = ITEMID.eq.ghatitk_legs, pos = {x = 1502, y = 918, z = 9}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_armor, pos = {x = 1503, y = 919, z = 9}, count = 1, container = 1716},
        {itemID = ITEMID.food.carrot, pos = {x = 1506, y = 737, z = 9}, count = 1, maxAmount = 2, itemAID = foodAID, container = 3013},
        {itemID = ITEMID.eq.kodayasu_shield, pos = {x = 1508, y = 930, z = 9}, count = 1, container = 6112},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1509, y = 930, z = 9}, count = 1, container = 1716},
        {itemID = ITEMID.other.coin, pos = {x = 1629, y = 605, z = 9}, count = 15, maxAmount = 29, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1635, y = 634, z = 9}, count = 13, maxAmount = 63, container = 1412},
        {itemID = ITEMID.other.coin, pos = {x = 1640, y = 631, z = 9}, count = 20, maxAmount = 71, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1652, y = 619, z = 9}, count = 1, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1653, y = 622, z = 9}, count = 1, maxAmount = 3, container = 1414},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1656, y = 628, z = 9}, count = 2, maxAmount = 2, container = 1414},
        {itemID = ITEMID.eq.intrinsic_legs, pos = {x = 1024, y = 660, z = 10}, count = 1, container = 6112},
        {itemID = ITEMID.eq.leather_backpack, pos = {x = 1024, y = 661, z = 10}, count = 1, container = 6112},
        {itemID = ITEMID.eq.leather_vest, pos = {x = 1025, y = 663, z = 10}, count = 1, container = 1717},
        {itemID = ITEMID.eq.blessed_turban, pos = {x = 1026, y = 657, z = 10}, count = 1, container = 1716},
        {itemID = ITEMID.eq.yashiteki_armor, pos = {x = 1026, y = 663, z = 10}, count = 1, container = 6111},
        {itemID = 2376, pos = {x = 1027, y = 663, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.leather_armor, pos = {x = 1028, y = 655, z = 10}, count = 1, container = 1717},
        {itemID = 2376, pos = {x = 1030, y = 667, z = 10}, count = 1, container = 6110},
        {itemID = 2376, pos = {x = 1030, y = 668, z = 10}, count = 1, container = 6110},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1031, y = 659, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.blessed_helmet, pos = {x = 1032, y = 654, z = 10}, count = 1, container = 6111},
        {itemID = ITEMID.eq.thunder_book, pos = {x = 1032, y = 659, z = 10}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_boots, pos = {x = 1033, y = 664, z = 10}, count = 1, container = 1717},
        {itemID = ITEMID.eq.bianhuren_shield, pos = {x = 1036, y = 663, z = 10}, count = 1, container = 6111},
        {itemID = ITEMID.food.carrot, pos = {x = 1039, y = 822, z = 10}, count = 2, maxAmount = 2, itemAID = foodAID, container = 6560},
        {itemID = ITEMID.food.apple, pos = {x = 1040, y = 821, z = 10}, count = 4, maxAmount = 6, itemAID = foodAID, container = 2915},
        {itemID = ITEMID.food.meat, pos = {x = 1040, y = 822, z = 10}, count = 2, maxAmount = 6, itemAID = foodAID, container = 2906},
        {itemID = 2677, pos = {x = 1042, y = 822, z = 10}, count = 4, maxAmount = 5, itemAID = foodAID, container = 2843},
        {itemID = ITEMID.eq.supaky_shield, pos = {x = 1042, y = 825, z = 10}, count = 1, container = 2915},
        {itemID = ITEMID.eq.speedzy_legs, pos = {x = 1043, y = 821, z = 10}, count = 1, container = 2836},
        {itemID = ITEMID.food.apple, pos = {x = 1044, y = 819, z = 10}, count = 4, maxAmount = 4, itemAID = foodAID, container = 2832},
        {itemID = 2677, pos = {x = 1044, y = 820, z = 10}, count = 4, maxAmount = 11, itemAID = foodAID, container = 2906},
        {itemID = ITEMID.food.ham, pos = {x = 1044, y = 822, z = 10}, count = 1, maxAmount = 1, itemAID = foodAID, container = 2840},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1045, y = 663, z = 10}, count = 1, container = 6110},
        {itemID = ITEMID.eq.mace, pos = {x = 1045, y = 664, z = 10}, count = 1, container = 6110},
        {itemID = ITEMID.food.apple, pos = {x = 1045, y = 667, z = 10}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1748},
        {itemID = ITEMID.food.apple, pos = {x = 1045, y = 818, z = 10}, count = 3, maxAmount = 3, itemAID = foodAID, container = 6560},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1045, y = 820, z = 10}, count = 1, maxAmount = 4, container = 2840},
        {itemID = ITEMID.eq.hand_axe, pos = {x = 1046, y = 656, z = 10}, count = 1, container = 6110},
        {itemID = ITEMID.eq.demonic_robe, pos = {x = 1046, y = 662, z = 10}, count = 1, container = 6112},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1046, y = 819, z = 10}, count = 2, maxAmount = 4, container = 2915},
        {itemID = ITEMID.food.ham, pos = {x = 1047, y = 818, z = 10}, count = 1, maxAmount = 3, itemAID = foodAID, container = 2836},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1048, y = 663, z = 10}, count = 1, maxAmount = 1, container = 1741},
        {itemID = ITEMID.eq.ghatitk_armor, pos = {x = 1049, y = 654, z = 10}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1049, y = 669, z = 10}, count = 1, container = 1714},
        {itemID = 7367, pos = {x = 1051, y = 656, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1052, y = 656, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.shikara_shield, pos = {x = 1053, y = 665, z = 10}, count = 1, container = 6112},
        {itemID = ITEMID.eq.leather_legs, pos = {x = 1055, y = 666, z = 10}, count = 1, container = 1714},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1057, y = 657, z = 10}, count = 1, container = 1716},
        {itemID = 2376, pos = {x = 1057, y = 662, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1058, y = 662, z = 10}, count = 1, container = 6109},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1059, y = 662, z = 10}, count = 1, container = 1716},
        {itemID = ITEMID.eq.pinpua_hood, pos = {x = 1061, y = 664, z = 10}, count = 1, container = 6111},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1087, y = 838, z = 10}, count = 2, maxAmount = 4, container = 1740},
        {itemID = ITEMID.food.ham, pos = {x = 1088, y = 792, z = 10}, count = 1, maxAmount = 1, itemAID = foodAID, container = 6080},
        {itemID = 2677, pos = {x = 1106, y = 797, z = 10}, count = 4, maxAmount = 5, itemAID = foodAID, container = 6560},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1135, y = 799, z = 10}, count = 2, maxAmount = 3, container = 2975},
        {itemID = ITEMID.food.carrot, pos = {x = 1148, y = 811, z = 10}, count = 4, maxAmount = 8, itemAID = foodAID, container = 2806},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1151, y = 809, z = 10}, count = 1, maxAmount = 4, container = 1738},
        {itemID = 2677, pos = {x = 1151, y = 815, z = 10}, count = 4, maxAmount = 6, itemAID = foodAID, container = 2806},
        {itemID = 2677, pos = {x = 1153, y = 810, z = 10}, count = 2, maxAmount = 5, itemAID = foodAID, container = 2806},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1202, y = 730, z = 10}, count = 2, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1299, y = 733, z = 10}, count = 1, maxAmount = 2, container = 1417},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1299, y = 807, z = 10}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1300, y = 807, z = 10}, count = 2, maxAmount = 56, container = 1419},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1300, y = 813, z = 10}, count = 1, container = 1412},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1301, y = 814, z = 10}, count = 2, maxAmount = 4, container = 1419},
        {itemID = ITEMID.food.apple, pos = {x = 1302, y = 743, z = 10}, count = 2, maxAmount = 3, itemAID = foodAID, container = 3028},
        {itemID = ITEMID.other.coin, pos = {x = 1302, y = 809, z = 10}, count = 19, maxAmount = 52, container = 1414},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1303, y = 743, z = 10}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1304, y = 812, z = 10}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1305, y = 723, z = 10}, count = 1, maxAmount = 5, container = 1417},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1305, y = 831, z = 10}, count = 1, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1305, y = 833, z = 10}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1307, y = 723, z = 10}, count = 2, maxAmount = 4, container = 1417},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1307, y = 832, z = 10}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1309, y = 723, z = 10}, count = 19, maxAmount = 75, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1313, y = 832, z = 10}, count = 18, maxAmount = 68, container = 1410},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1315, y = 832, z = 10}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1318, y = 809, z = 10}, count = 1, maxAmount = 3, container = 1413},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1319, y = 807, z = 10}, count = 2, container = 1415},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1319, y = 814, z = 10}, count = 1, maxAmount = 3, container = 1419},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1321, y = 811, z = 10}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1324, y = 679, z = 10}, count = 1, container = 1718},
        {itemID = 1950, pos = {x = 1325, y = 679, z = 10}, count = 1, container = 1719},
        {itemID = ITEMID.other.coin, pos = {x = 1329, y = 736, z = 10}, count = 18, maxAmount = 72, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1329, y = 742, z = 10}, count = 8, maxAmount = 65, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1336, y = 714, z = 10}, count = 13, maxAmount = 87, container = 1417},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1338, y = 722, z = 10}, count = 2, maxAmount = 4, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1340, y = 722, z = 10}, count = 1, maxAmount = 37, container = 1417},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1429, y = 868, z = 10}, count = 2, maxAmount = 5, container = 1415},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1432, y = 866, z = 10}, count = 2, maxAmount = 3, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1433, y = 866, z = 10}, count = 6, maxAmount = 14, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1436, y = 874, z = 10}, count = 1, maxAmount = 35, container = 1410},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1459, y = 905, z = 10}, count = 2, maxAmount = 4, container = 1419},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1459, y = 907, z = 10}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1464, y = 878, z = 10}, count = 19, maxAmount = 67, container = 1410},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1469, y = 891, z = 10}, count = 1, container = 1417},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1470, y = 891, z = 10}, count = 2, maxAmount = 3, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1480, y = 677, z = 10}, count = 3, maxAmount = 54, container = 1419},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1485, y = 718, z = 10}, count = 1, maxAmount = 1, container = 1417},
        {itemID = ITEMID.eq.bow, pos = {x = 1043, y = 656, z = 11}, count = 1, container = 6109},
        {itemID = ITEMID.eq.gribit_legs, pos = {x = 1044, y = 656, z = 11}, count = 1, container = 6111},
        {itemID = ITEMID.other.coin, pos = {x = 1289, y = 853, z = 11}, count = 3, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1290, y = 870, z = 11}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1293, y = 858, z = 11}, count = 1, maxAmount = 1, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1295, y = 852, z = 11}, count = 6, maxAmount = 15, container = 1419},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1295, y = 868, z = 11}, count = 1, maxAmount = 2, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1297, y = 852, z = 11}, count = 5, maxAmount = 52, container = 1414},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1297, y = 854, z = 11}, count = 1, maxAmount = 1, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1297, y = 856, z = 11}, count = 14, maxAmount = 94, container = 1419},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1298, y = 870, z = 11}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1299, y = 726, z = 11}, count = 1, maxAmount = 1, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1299, y = 807, z = 11}, count = 7, maxAmount = 49, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1299, y = 811, z = 11}, count = 18, maxAmount = 68, container = 1413},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1300, y = 814, z = 11}, count = 3, container = 1419},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1300, y = 868, z = 11}, count = 1, container = 1410},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1301, y = 807, z = 11}, count = 3, container = 1417},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1301, y = 818, z = 11}, count = 3, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1303, y = 814, z = 11}, count = 20, maxAmount = 83, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1303, y = 865, z = 11}, count = 12, maxAmount = 16, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1304, y = 808, z = 11}, count = 16, maxAmount = 75, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1305, y = 835, z = 11}, count = 13, maxAmount = 15, container = 1419},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1306, y = 812, z = 11}, count = 1, maxAmount = 3, container = 1414},
        {itemID = ITEMID.other.coin, pos = {x = 1306, y = 821, z = 11}, count = 3, maxAmount = 6, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1307, y = 816, z = 11}, count = 20, maxAmount = 38, container = 1412},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1307, y = 832, z = 11}, count = 2, maxAmount = 2, container = 1413},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1309, y = 799, z = 11}, count = 1, maxAmount = 4, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1309, y = 809, z = 11}, count = 9, maxAmount = 66, container = 1415},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1309, y = 811, z = 11}, count = 3, maxAmount = 5, container = 1410},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1310, y = 809, z = 11}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1310, y = 811, z = 11}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1310, y = 825, z = 11}, count = 1, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1310, y = 827, z = 11}, count = 13, maxAmount = 94, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1312, y = 736, z = 11}, count = 1, maxAmount = 4, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1313, y = 816, z = 11}, count = 3, maxAmount = 3, container = 1412},
        {itemID = ITEMID.upgrades.armor_stone_t2, pos = {x = 1313, y = 829, z = 11}, count = 1, maxAmount = 4, container = 1419},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1313, y = 832, z = 11}, count = 1, container = 1412},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1313, y = 868, z = 11}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1314, y = 812, z = 11}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1314, y = 835, z = 11}, count = 1, maxAmount = 1, container = 1419},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1314, y = 868, z = 11}, count = 1, maxAmount = 4, container = 1410},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1315, y = 736, z = 11}, count = 1, container = 1417},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1316, y = 808, z = 11}, count = 1, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1317, y = 799, z = 11}, count = 1, maxAmount = 4, container = 1410},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1317, y = 863, z = 11}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.eq.kaiju_wall_wand, pos = {x = 1318, y = 868, z = 11}, count = 1, container = 1419},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1319, y = 807, z = 11}, count = 2, maxAmount = 15, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1319, y = 818, z = 11}, count = 11, maxAmount = 18, container = 1415},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1319, y = 820, z = 11}, count = 3, maxAmount = 8, container = 1410},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1319, y = 825, z = 11}, count = 3, maxAmount = 10, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1319, y = 827, z = 11}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1320, y = 756, z = 11}, count = 2, maxAmount = 2, container = 1417},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1320, y = 840, z = 11}, count = 2, maxAmount = 4, container = 1410},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1321, y = 807, z = 11}, count = 1, container = 1414},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1321, y = 822, z = 11}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1321, y = 825, z = 11}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1321, y = 835, z = 11}, count = 9, maxAmount = 19, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1321, y = 848, z = 11}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1322, y = 822, z = 11}, count = 2, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1322, y = 826, z = 11}, count = 2, maxAmount = 2, container = 1419},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1322, y = 863, z = 11}, count = 1, maxAmount = 4, container = 1414},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1324, y = 840, z = 11}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1324, y = 851, z = 11}, count = 10, maxAmount = 21, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1326, y = 836, z = 11}, count = 7, maxAmount = 83, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1335, y = 708, z = 11}, count = 2, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1470, y = 703, z = 11}, count = 3, maxAmount = 5, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1479, y = 704, z = 11}, count = 1, maxAmount = 4, container = 1410},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1492, y = 694, z = 11}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1494, y = 689, z = 11}, count = 1, container = 1410},
        {itemID = ITEMID.food.apple, pos = {x = 1048, y = 859, z = 12}, count = 4, maxAmount = 5, itemAID = foodAID, container = 5965},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1135, y = 752, z = 12}, count = 1, maxAmount = 4, container = 1770},
        {itemID = ITEMID.upgrades.crit_stone, pos = {x = 1136, y = 752, z = 12}, count = 1, maxAmount = 4, container = 1770},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1137, y = 714, z = 12}, count = 2, maxAmount = 2, container = 1770},
        {itemID = 2677, pos = {x = 1137, y = 715, z = 12}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.carrot, pos = {x = 1139, y = 714, z = 12}, count = 2, maxAmount = 2, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.meat, pos = {x = 1139, y = 743, z = 12}, count = 2, maxAmount = 3, itemAID = foodAID, container = 1749},
        {itemID = 2677, pos = {x = 1139, y = 744, z = 12}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1749},
        {itemID = ITEMID.food.carrot, pos = {x = 1139, y = 749, z = 12}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1747},
        {itemID = ITEMID.food.carrot, pos = {x = 1157, y = 734, z = 12}, count = 4, maxAmount = 8, itemAID = foodAID, container = 1987},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1159, y = 743, z = 12}, count = 2, maxAmount = 2, container = 1987},
        {itemID = ITEMID.eq.snaipa_helmet, pos = {x = 1160, y = 735, z = 12}, count = 1, container = 1987},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1164, y = 746, z = 12}, count = 1, maxAmount = 1, container = 1770},
        {itemID = ITEMID.food.carrot, pos = {x = 1165, y = 743, z = 12}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1987},
        {itemID = ITEMID.food.apple, pos = {x = 1172, y = 736, z = 12}, count = 3, maxAmount = 6, itemAID = foodAID, container = 1987},
        {itemID = ITEMID.food.meat, pos = {x = 1174, y = 736, z = 12}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.apple, pos = {x = 1176, y = 740, z = 12}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1987},
        {itemID = ITEMID.eq.goddess_armor, pos = {x = 1176, y = 741, z = 12}, count = 1, container = 1770},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1291, y = 852, z = 12}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1291, y = 857, z = 12}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1291, y = 868, z = 12}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1292, y = 852, z = 12}, count = 5, maxAmount = 62, container = 1410},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1292, y = 868, z = 12}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1293, y = 852, z = 12}, count = 2, maxAmount = 3, container = 1412},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1293, y = 868, z = 12}, count = 1, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1299, y = 866, z = 12}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1300, y = 757, z = 12}, count = 3, maxAmount = 10, container = 1417},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1300, y = 866, z = 12}, count = 1, maxAmount = 4, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1301, y = 741, z = 12}, count = 2, maxAmount = 2, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1301, y = 744, z = 12}, count = 17, maxAmount = 99, container = 1419},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1301, y = 748, z = 12}, count = 2, maxAmount = 3, container = 1419},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1301, y = 751, z = 12}, count = 3, maxAmount = 7, container = 1419},
        {itemID = ITEMID.other.coin, pos = {x = 1304, y = 867, z = 12}, count = 12, maxAmount = 91, container = 1417},
        {itemID = ITEMID.eq.leather_bag, pos = {x = 1305, y = 749, z = 12}, count = 1, container = 1746},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1306, y = 785, z = 12}, count = 1, maxAmount = 3, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1308, y = 860, z = 12}, count = 4, maxAmount = 87, container = 1414},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1309, y = 860, z = 12}, count = 2, container = 1415},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1310, y = 860, z = 12}, count = 1, maxAmount = 1, container = 1410},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1310, y = 870, z = 12}, count = 3, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1311, y = 850, z = 12}, count = 2, maxAmount = 3, container = 1417},
        {itemID = ITEMID.other.coin, pos = {x = 1311, y = 860, z = 12}, count = 6, maxAmount = 100, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1311, y = 870, z = 12}, count = 1, maxAmount = 4, container = 1412},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1312, y = 848, z = 12}, count = 1, maxAmount = 5, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1313, y = 848, z = 12}, count = 14, maxAmount = 55, container = 1410},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1313, y = 874, z = 12}, count = 1, container = 1419},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1314, y = 785, z = 12}, count = 3, maxAmount = 4, container = 1417},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1316, y = 870, z = 12}, count = 1, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1317, y = 870, z = 12}, count = 8, maxAmount = 99, container = 1415},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1321, y = 864, z = 12}, count = 1, maxAmount = 1, container = 1417},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1322, y = 864, z = 12}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1324, y = 861, z = 12}, count = 3, maxAmount = 83, container = 1410},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1325, y = 861, z = 12}, count = 1, maxAmount = 6, container = 1419},
        {itemID = ITEMID.eq.immortal_kamikaze_wand, pos = {x = 1326, y = 865, z = 12}, count = 1, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1327, y = 863, z = 12}, count = 5, maxAmount = 30, container = 1412},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1327, y = 865, z = 12}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.eq.atsui_kori_wand, pos = {x = 1331, y = 839, z = 12}, count = 1, container = 1410},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1331, y = 844, z = 12}, count = 1, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1332, y = 774, z = 12}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1332, y = 839, z = 12}, count = 12, maxAmount = 77, container = 1410},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1332, y = 844, z = 12}, count = 1, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1334, y = 842, z = 12}, count = 3, container = 1413},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1336, y = 778, z = 12}, count = 1, maxAmount = 3, container = 1419},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1337, y = 725, z = 12}, count = 1, maxAmount = 1, container = 1410},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1339, y = 735, z = 12}, count = 2, maxAmount = 4, container = 1417},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1365, y = 759, z = 12}, count = 2, maxAmount = 4, container = 1419},
        {itemID = ITEMID.food.apple, pos = {x = 1366, y = 760, z = 12}, count = 4, maxAmount = 7, itemAID = foodAID, container = 1746},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1476, y = 678, z = 12}, count = 1, maxAmount = 1, container = 1417},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1477, y = 729, z = 12}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1484, y = 678, z = 12}, count = 3, container = 1417},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1484, y = 723, z = 12}, count = 2, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1485, y = 723, z = 12}, count = 1, maxAmount = 1, container = 1410},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1488, y = 758, z = 12}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1491, y = 756, z = 12}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1494, y = 721, z = 12}, count = 2, maxAmount = 6, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1494, y = 760, z = 12}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1497, y = 741, z = 12}, count = 18, maxAmount = 85, container = 1415},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1498, y = 729, z = 12}, count = 1, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.ice_gem, pos = {x = 1498, y = 731, z = 12}, count = 2, maxAmount = 4, container = 1415},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1498, y = 741, z = 12}, count = 1, container = 1412},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1499, y = 744, z = 12}, count = 2, maxAmount = 3, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1500, y = 744, z = 12}, count = 3, maxAmount = 54, container = 1410},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1503, y = 729, z = 12}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1503, y = 731, z = 12}, count = 5, maxAmount = 27, container = 1414},
        {itemID = ITEMID.eq.fur_shorts, pos = {x = 1506, y = 923, z = 12}, count = 1, container = 6111},
        {itemID = ITEMID.eq.leather_helmet, pos = {x = 1507, y = 923, z = 12}, count = 1, container = 1716},
        {itemID = ITEMID.eq.yashimaki_shield, pos = {x = 1508, y = 936, z = 12}, count = 1, container = 6111},
        {itemID = ITEMID.eq.ghatitk_armor, pos = {x = 1521, y = 936, z = 12}, count = 1, container = 6112},
        {itemID = 7367, pos = {x = 1522, y = 933, z = 12}, count = 1, container = 6110},
        {itemID = ITEMID.food.meat, pos = {x = 1151, y = 725, z = 13}, count = 2, maxAmount = 6, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.meat, pos = {x = 1160, y = 730, z = 13}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1739},
        {itemID = ITEMID.food.ham, pos = {x = 1160, y = 740, z = 13}, count = 1, maxAmount = 3, itemAID = foodAID, container = 1770},
        {itemID = ITEMID.food.meat, pos = {x = 1170, y = 732, z = 13}, count = 1, maxAmount = 1, itemAID = foodAID, container = 1770},
        {itemID = 2677, pos = {x = 1170, y = 733, z = 13}, count = 4, maxAmount = 11, itemAID = foodAID, container = 1739},
        {itemID = 2677, pos = {x = 1171, y = 732, z = 13}, count = 3, maxAmount = 9, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.carrot, pos = {x = 1171, y = 733, z = 13}, count = 4, maxAmount = 4, itemAID = foodAID, container = 1740},
        {itemID = ITEMID.food.apple, pos = {x = 1171, y = 735, z = 13}, count = 4, maxAmount = 6, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1172, y = 735, z = 13}, count = 2, container = 1751},
        {itemID = ITEMID.eq.leather_bag, pos = {x = 1173, y = 733, z = 13}, count = 1, container = 1770},
        {itemID = ITEMID.food.ham, pos = {x = 1173, y = 734, z = 13}, count = 1, maxAmount = 2, itemAID = foodAID, container = 1738},
        {itemID = ITEMID.food.carrot, pos = {x = 1173, y = 735, z = 13}, count = 3, maxAmount = 4, itemAID = foodAID, container = 1751},
        {itemID = ITEMID.other.coin, pos = {x = 1460, y = 722, z = 13}, count = 4, maxAmount = 65, container = 1413},
        {itemID = ITEMID.other.coin, pos = {x = 1468, y = 723, z = 13}, count = 17, maxAmount = 86, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1482, y = 736, z = 13}, count = 13, maxAmount = 93, container = 1415},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1482, y = 748, z = 13}, count = 3, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1483, y = 736, z = 13}, count = 10, maxAmount = 92, container = 1415},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1483, y = 746, z = 13}, count = 3, container = 1410},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1483, y = 748, z = 13}, count = 3, container = 1415},
        {itemID = ITEMID.upgrades.sight_stone, pos = {x = 1486, y = 726, z = 13}, count = 2, maxAmount = 9, container = 1415},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1486, y = 741, z = 13}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.speed_stone, pos = {x = 1487, y = 753, z = 13}, count = 3, maxAmount = 17, container = 1415},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1490, y = 741, z = 13}, count = 1, container = 1415},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1491, y = 719, z = 13}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1491, y = 724, z = 13}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.other.coin, pos = {x = 1491, y = 756, z = 13}, count = 19, maxAmount = 39, container = 1410},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1492, y = 719, z = 13}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1492, y = 733, z = 13}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1492, y = 756, z = 13}, count = 7, maxAmount = 39, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1493, y = 719, z = 13}, count = 2, maxAmount = 4, container = 1410},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1493, y = 735, z = 13}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1494, y = 746, z = 13}, count = 3, maxAmount = 12, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1495, y = 737, z = 13}, count = 1, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1495, y = 739, z = 13}, count = 3, container = 1412},
        {itemID = ITEMID.eq.yashinuken_wand, pos = {x = 1512, y = 737, z = 13}, count = 1, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1512, y = 745, z = 13}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.armor_stone_t1, pos = {x = 1513, y = 737, z = 13}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1519, y = 740, z = 13}, count = 1, maxAmount = 3, container = 1415},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1470, y = 739, z = 14}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1470, y = 741, z = 14}, count = 20, maxAmount = 42, container = 1415},
        {itemID = ITEMID.upgrades.armor_stone_t2, pos = {x = 1471, y = 735, z = 14}, count = 3, maxAmount = 4, container = 1414},
        {itemID = ITEMID.other.coin, pos = {x = 1472, y = 735, z = 14}, count = 14, maxAmount = 99, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1478, y = 739, z = 14}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1485, y = 739, z = 14}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1486, y = 729, z = 14}, count = 1, maxAmount = 3, container = 1412},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1486, y = 732, z = 14}, count = 2, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.defence_stone, pos = {x = 1489, y = 729, z = 14}, count = 3, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.energy_gem, pos = {x = 1489, y = 732, z = 14}, count = 2, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1490, y = 739, z = 14}, count = 1, maxAmount = 2, container = 1410},
        {itemID = ITEMID.upgrades.critBlock_stone, pos = {x = 1515, y = 732, z = 14}, count = 3, maxAmount = 21, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1479, y = 705, z = 15}, count = 1, maxAmount = 75, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1480, y = 710, z = 15}, count = 5, maxAmount = 10, container = 1414},
        {itemID = ITEMID.other.coin, pos = {x = 1483, y = 754, z = 15}, count = 13, maxAmount = 70, container = 1414},
        {itemID = ITEMID.upgrades.death_stone, pos = {x = 1484, y = 703, z = 15}, count = 3, container = 1415},
        {itemID = ITEMID.upgrades.fire_gem, pos = {x = 1484, y = 709, z = 15}, count = 1, maxAmount = 4, container = 1415},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1486, y = 751, z = 15}, count = 1, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1486, y = 755, z = 15}, count = 1, maxAmount = 1, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1487, y = 751, z = 15}, count = 9, maxAmount = 27, container = 1415},
        {itemID = ITEMID.other.coin, pos = {x = 1488, y = 751, z = 15}, count = 12, maxAmount = 26, container = 1412},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1489, y = 751, z = 15}, count = 3, container = 1410},
        {itemID = ITEMID.upgrades.earth_gem, pos = {x = 1489, y = 756, z = 15}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1492, y = 703, z = 15}, count = 3, container = 1415},
        {itemID = ITEMID.upgrades.physical_gem, pos = {x = 1492, y = 709, z = 15}, count = 2, maxAmount = 3, container = 1410},
        {itemID = ITEMID.upgrades.energy_stone, pos = {x = 1495, y = 705, z = 15}, count = 1, maxAmount = 2, container = 1415},
        {itemID = ITEMID.upgrades.skill_stone, pos = {x = 1495, y = 710, z = 15}, count = 2, container = 1410},
        {itemID = ITEMID.upgrades.death_gem, pos = {x = 1496, y = 705, z = 15}, count = 2, maxAmount = 4, container = 1410},
    },
    monsterSpawns = {
        ["south jungle"] = {
            amount = 100,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 20}, ["deer"] = {amount = 20}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 3}},
            areaCorners = {{upCorner = {x = 1556, y = 741, z = 7}, downCorner = {x = 1688, y = 888, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1573, y = 854, z = 7}, downCorner = {x = 1585, y = 869, z = 7}}},
        },
        ["west jungle"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 8}, ["deer"] = {amount = 8}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 1}},
            areaCorners = {{upCorner = {x = 1560, y = 678, z = 7}, downCorner = {x = 1609, y = 738, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1560, y = 678, z = 7}, downCorner = {x = 1580, y = 700, z = 7}}},
        },
        ["north jungle"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 8}, ["deer"] = {amount = 8}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 1}},
            areaCorners = {{upCorner = {x = 1613, y = 616, z = 7}, downCorner = {x = 1685, y = 682, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1642, y = 670, z = 7}, downCorner = {x = 1685, y = 682, z = 7}}},
        },
        ["north desert from jungle"] = {
            amount = 15,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["skeleton warrior"] = {amount = 2}},
            areaCorners = {{upCorner = {x = 1597, y = 590, z = 7}, downCorner = {x = 1675, y = 620, z = 7}}},
        },
        ["north west desert from jungle"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["skeleton warrior"] = {amount = 5}, ["ghoul"] = {amount = 5}},
            areaCorners = {{upCorner = {x = 1521, y = 626, z = 7}, downCorner = {x = 1602, y = 727, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1559, y = 681, z = 7}, downCorner = {x = 1602, y = 727, z = 7}}},
        },
        ["north desert from bandit mountain"] = {
            amount = 20,
            spawnTime = MS_DAY*2,
            monsterT = {["mummy"] = {amount = 10}, ["skeleton warrior"] = {}, ["ghoul"] = {}},
            areaCorners = {{upCorner = {x = 1461, y = 616, z = 7}, downCorner = {x = 1518, y = 662, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1459, y = 645, z = 7}, downCorner = {x = 1503, y = 662, z = 7}}},
        },
        ["desert bandit mountain"] = {
            amount = 35,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {{upCorner = {x = 1454, y = 650, z = 6}, downCorner = {x = 1528, y = 732, z = 6}}},
        },
        ["west desert from jungle"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["skeleton warrior"] = {amount = 4}, ["ghoul"] = {amount = 4}},
            areaCorners = {{upCorner = {x = 1465, y = 730, z = 7}, downCorner = {x = 1564, y = 786, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1535, y = 760, z = 7}, downCorner = {x = 1564, y = 786, z = 7}}},
        },
        ["desert"] = {
            amount = 200,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton warrior"] = {amount = 50}, ["ghoul"] = {}, ["skeleton"] = {}},
            areaCorners = {{upCorner = {x = 1279, y = 705, z = 7}, downCorner = {x = 1484, y = 872, z = 7}}},
            ignoreAreas = {
                {upCorner = {x = 1399, y = 829, z = 7}, downCorner = {x = 1484, y = 872, z = 7}}, -- town area
                {upCorner = {x = 1310, y = 819, z = 7}, downCorner = {x = 1356, y = 858, z = 7}}, -- bandit camp
                {upCorner = {x = 1267, y = 741, z = 7}, downCorner = {x = 1314, y = 775, z = 7}}, -- bandit camp
                {upCorner = {x = 1390, y = 724, z = 7}, downCorner = {x = 1443, y = 756, z = 7}}, -- bandit camp
            },
        },
        ["desert bandit camp 1"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {{upCorner = {x = 1209, y = 746, z = 7}, downCorner = {x = 1269, y = 794, z = 7}}},
        },
        ["desert bandit camp 2"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {{upCorner = {x = 1270, y = 738, z = 7}, downCorner = {x = 1311, y = 774, z = 7}}},
        },
        ["desert bandit camp 3"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {{upCorner = {x = 1393, y = 724, z = 7}, downCorner = {x = 1437, y = 753, z = 7}}},
        },
        ["desert bandit camp 4"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {{upCorner = {x = 1309, y = 821, z = 7}, downCorner = {x = 1358, y = 855, z = 7}}},
        },
        ["forest bandit camp 1"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1137, y = 753, z = 7}, downCorner = {x = 1161, y = 775, z = 7}},
                {upCorner = {x = 1137, y = 753, z = 6}, downCorner = {x = 1161, y = 775, z = 6}},
                {upCorner = {x = 1137, y = 753, z = 5}, downCorner = {x = 1161, y = 775, z = 5}},
                {upCorner = {x = 1169, y = 783, z = 7}, downCorner = {x = 1183, y = 792, z = 7}},
                {upCorner = {x = 1167, y = 728, z = 7}, downCorner = {x = 1205, y = 751, z = 7}},
                {upCorner = {x = 1167, y = 728, z = 6}, downCorner = {x = 1205, y = 751, z = 6}},
                {upCorner = {x = 1190, y = 717, z = 8}, downCorner = {x = 1216, y = 755, z = 8}},
            },
            ignoreAreas = {{upCorner = {x = 1199, y = 748, z = 8}, downCorner = {x = 1205, y = 754, z = 8}}},
        },
        ["forest bandit camp 2"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1101, y = 720, z = 7}, downCorner = {x = 1144, y = 743, z = 7}},
                {upCorner = {x = 1101, y = 720, z = 6}, downCorner = {x = 1144, y = 743, z = 6}},
                {upCorner = {x = 1075, y = 689, z = 6}, downCorner = {x = 1118, y = 721, z = 6}},
                {upCorner = {x = 1063, y = 677, z = 7}, downCorner = {x = 1098, y = 714, z = 7}},
            },
        },
        ["new forest"] = {
            amount = 20,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 4}, ["deer"] = {amount = 4}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 1}},
            areaCorners = {{upCorner = {x = 1035, y = 648, z = 7}, downCorner = {x = 1059, y = 700, z = 7}}},
        },
        ["forest bandit camp 3"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1072, y = 731, z = 7}, downCorner = {x = 1101, y = 754, z = 7}},
                {upCorner = {x = 1072, y = 731, z = 6}, downCorner = {x = 1101, y = 754, z = 6}},
                {upCorner = {x = 1072, y = 731, z = 5}, downCorner = {x = 1101, y = 754, z = 5}},
            },
        },
        ["north forest"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 10}, ["deer"] = {amount = 10}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 2}},
            areaCorners = {{upCorner = {x = 1089, y = 748, z = 7}, downCorner = {x = 1202, y = 801, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1122, y = 785, z = 7}, downCorner = {x = 1202, y = 801, z = 7}}},
        },
        ["south east forest"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 10}, ["deer"] = {amount = 10}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 4}},
            areaCorners = {{upCorner = {x = 1148, y = 791, z = 7}, downCorner = {x = 1221, y = 849, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1148, y = 791, z = 7}, downCorner = {x = 1162, y = 819, z = 7}}},
        },
        ["south west forest"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["wolf"] = {amount = 10}, ["deer"] = {amount = 10}, ["boar"] = {}, ["bear"] = {}, ["white deer"] = {amount = 3}},
            areaCorners = {{upCorner = {x = 1080, y = 824, z = 7}, downCorner = {x = 1138, y = 880, z = 7}}},
            ignoreAreas = {{upCorner = {x = 1080, y = 824, z = 7}, downCorner = {x = 1094, y = 835, z = 7}}},
        },
        ["forest town cave"] = {
            amount = 10,
            spawnTime = MS_DAY*2,
            monsterT = {["mummy"] = {}, ["skeleton warrior"] = {}},
            areaCorners = {
                {upCorner = {x = 1025, y = 860, z = 10}, downCorner = {x = 1055, y = 877, z = 10}},
                {upCorner = {x = 1048, y = 852, z = 9}, downCorner = {x = 1064, y = 862, z = 9}},
            },
        },
        ["cave bandits in forest"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1065, y = 795, z = 8}, downCorner = {x = 1106, y = 853, z = 8}},
                {upCorner = {x = 1050, y = 787, z = 9}, downCorner = {x = 1114, y = 849, z = 9}},
                {upCorner = {x = 1062, y = 742, z = 8}, downCorner = {x = 1098, y = 774, z = 8}},
                {upCorner = {x = 1066, y = 708, z = 8}, downCorner = {x = 1090, y = 736, z = 8}},
                {upCorner = {x = 1120, y = 713, z = 8}, downCorner = {x = 1148, y = 769, z = 8}},
            },
            ignoreAreas = {
                {upCorner = {x = 1074, y = 795, z = 8}, downCorner = {x = 1106, y = 799, z = 8}},
                {upCorner = {x = 1047, y = 815, z = 9}, downCorner = {x = 1075, y = 834, z = 9}},
                {upCorner = {x = 1050, y = 787, z = 9}, downCorner = {x = 1060, y = 793, z = 9}},
                
            }
        },
        ["cave bandits base in forest"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1126, y = 733, z = 10}, downCorner = {x = 1147, y = 747, z = 10}},
                {upCorner = {x = 1128, y = 711, z = 12}, downCorner = {x = 1178, y = 752, z = 12}},
                {upCorner = {x = 1141, y = 726, z = 13}, downCorner = {x = 1166, y = 740, z = 13}},
            },
            ignoreAreas = {{upCorner = {x = 1144, y = 744, z = 12}, downCorner = {x = 1160, y = 757, z = 12}}}
        },
        ["cave undeads in forest"] = {
            amount = 80,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1072, y = 832, z = 10}, downCorner = {x = 1087, y = 847, z = 10}},
                {upCorner = {x = 1033, y = 819, z = 11}, downCorner = {x = 1094, y = 895, z = 11}},
                {upCorner = {x = 1036, y = 860, z = 12}, downCorner = {x = 1050, y = 887, z = 12}},
                {upCorner = {x = 1071, y = 842, z = 13}, downCorner = {x = 1128, y = 900, z = 13}},
                {upCorner = {x = 1097, y = 727, z = 10}, downCorner = {x = 1130, y = 786, z = 10}},
                {upCorner = {x = 1110, y = 737, z = 11}, downCorner = {x = 1169, y = 782, z = 11}},
                {upCorner = {x = 1041, y = 738, z = 9}, downCorner = {x = 1115, y = 787, z = 9}},
                {upCorner = {x = 1089, y = 766, z = 8}, downCorner = {x = 1110, y = 787, z = 8}},
                {upCorner = {x = 1102, y = 789, z = 8}, downCorner = {x = 1135, y = 806, z = 8}},
                {upCorner = {x = 1126, y = 800, z = 9}, downCorner = {x = 1151, y = 825, z = 9}},
                
            },
            ignoreAreas = {
                {upCorner = {x = 1125, y = 732, z = 10}, downCorner = {x = 1133, y = 747, z = 10}},
                {upCorner = {x = 1099, y = 777, z = 9}, downCorner = {x = 1107, y = 787, z = 9}},
                {upCorner = {x = 1039, y = 765, z = 9}, downCorner = {x = 1071, y = 788, z = 9}},
                
            },
        },
        ["cave bandits in forest 2"] = {
            amount = 30,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1158, y = 758, z = 8}, downCorner = {x = 1212, y = 790, z = 8}},
                {upCorner = {x = 1158, y = 747, z = 9}, downCorner = {x = 1178, y = 791, z = 9}},
            }
        },
        ["small undead cave in forest"] = {
            amount = 10,
            spawnTime = MS_DAY*2,
            monsterT = {["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {{upCorner = {x = 1100, y = 879, z = 8}, downCorner = {x = 1123, y = 896, z = 8}}},
        },
        ["forest cyclops cave 1"] = {
            amount = 8,
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            areaCorners = {
                {upCorner = {x = 1172, y = 794, z = 10}, downCorner = {x = 1202, y = 831, z = 10}},
                {upCorner = {x = 1169, y = 798, z = 11}, downCorner = {x = 1211, y = 819, z = 11}},
                {upCorner = {x = 1172, y = 796, z = 9}, downCorner = {x = 1187, y = 815, z = 9}},
            },
        },
        ["forest cyclops cave 2"] = {
            amount = 8,
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            areaCorners = {
                {upCorner = {x = 1159, y = 835, z = 8}, downCorner = {x = 1204, y = 857, z = 8}},
                {upCorner = {x = 1214, y = 855, z = 9}, downCorner = {x = 1214, y = 855, z = 9}},
                {upCorner = {x = 1207, y = 841, z = 10}, downCorner = {x = 1217, y = 852, z = 10}},
            },
        },
        ["forest cyclops cave 3"] = {
            amount = 10,
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            areaCorners = {
                {upCorner = {x = 1192, y = 719, z = 11}, downCorner = {x = 1209, y = 737, z = 11}},
                {upCorner = {x = 1165, y = 718, z = 10}, downCorner = {x = 1236, y = 777, z = 10}},
            },
        },
        ["forest cyclops mountain"] = {
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            spawnPoints = {{x = 1156, y = 843, z = 6}, {x = 1159, y = 834, z = 6}},
        },
        ["archanos"] = {
            spawnTime = MS_DAY*2,
            monsterT = {["archanos"] = {}},
            spawnPoints = {{x = 1059, y = 824, z = 8}, {x = 1480, y = 682, z = 12}, {x = 1488, y = 709, z = 15}},
        },
        ["borthonos"] = {
            spawnTime = MS_DAY*2,
            monsterT = {["borthonos"] = {}},
            spawnPoints = {{x = 1235, y = 811, z = 9}, {x = 1083, y = 666, z = 8}},
        },
        ["big daddy"] = {
            spawnTime = MS_DAY*2,
            monsterT = {["big daddy"] = {}},
            spawnPoints = {{x = 1431, y = 918, z = 10}},
        },
        ["mummy"] = {
            spawnTime = MS_DAY*2,
            monsterT = {["mummy"] = {}},
            spawnPoints = {{x = 1071, y = 830, z = 9}, {x = 1070, y = 832, z = 8}},
        },
        ["undead fortress"] = {
            amount = 70,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1025, y = 648, z = 10}, downCorner = {x = 1060, y = 673, z = 10}},
                {upCorner = {x = 1045, y = 652, z = 9}, downCorner = {x = 1062, y = 682, z = 9}},
                {upCorner = {x = 1053, y = 653, z = 8}, downCorner = {x = 1072, y = 670, z = 8}},
            },
        },
        ["undead tomb in desert"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1301, y = 686, z = 10}, downCorner = {x = 1342, y = 744, z = 10}},
                {upCorner = {x = 1299, y = 693, z = 11}, downCorner = {x = 1333, y = 759, z = 11}},
                {upCorner = {x = 1288, y = 727, z = 12}, downCorner = {x = 1361, y = 785, z = 12}},
            },
        },
        ["undead tomb in desert 2"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1292, y = 841, z = 12}, downCorner = {x = 1332, y = 871, z = 12}},
                {upCorner = {x = 1326, y = 868, z = 11}, downCorner = {x = 1326, y = 868, z = 11}},
            },
        },
        ["undead tomb in desert 3"] = {
            amount = 40,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1397, y = 851, z = 8}, downCorner = {x = 1454, y = 892, z = 8}},
                {upCorner = {x = 1398, y = 851, z = 9}, downCorner = {x = 1465, y = 911, z = 9}},
                {upCorner = {x = 1416, y = 867, z = 10}, downCorner = {x = 1475, y = 908, z = 10}},
            },
        },
        ["undead tomb in desert 4"] = {
            amount = 15,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1470, y = 715, z = 9}, downCorner = {x = 1509, y = 744, z = 9}},
                {upCorner = {x = 1470, y = 688, z = 11}, downCorner = {x = 1493, y = 710, z = 11}},
            },
        },
        ["undead fortress in desert"] = {
            amount = 60,
            spawnTime = MS_DAY*2,
            monsterT = {["skeleton"] = {}, ["ghoul"] = {}, ["skeleton warrior"] = {}, ["mummy"] = {}},
            areaCorners = {
                {upCorner = {x = 1471, y = 766, z = 8}, downCorner = {x = 1509, y = 804, z = 8}},
                {upCorner = {x = 1470, y = 780, z = 10}, downCorner = {x = 1541, y = 815, z = 10}},
                {upCorner = {x = 1482, y = 759, z = 11}, downCorner = {x = 1508, y = 817, z = 11}},
                {upCorner = {x = 1481, y = 721, z = 13}, downCorner = {x = 1496, y = 759, z = 13}},
                {upCorner = {x = 1468, y = 723, z = 14}, downCorner = {x = 1514, y = 752, z = 14}},
            },
        },
        ["cyclops cave in desert 1"] = {
            amount = 8,
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            areaCorners = {{upCorner = {x = 1499, y = 829, z = 9}, downCorner = {x = 1576, y = 905, z = 9}}},
        },
        ["cyclops cave in desert 2"] = {
            amount = 15,
            spawnTime = MS_DAY*2,
            monsterT = {["cyclops"] = {}},
            areaCorners = {
                {upCorner = {x = 1541, y = 729, z = 8}, downCorner = {x = 1563, y = 745, z = 8}},
                {upCorner = {x = 1536, y = 718, z = 9}, downCorner = {x = 1579, y = 760, z = 9}},
                {upCorner = {x = 1532, y = 700, z = 10}, downCorner = {x = 1577, y = 741, z = 10}},
            },
        },
        ["big daddy room"] = {
            amount = 6,
            spawnTime = MS_DAY*2,
            monsterT = {["big daddy"] = {amount = 2}, ["cyclops"] = {}},
            areaCorners = {{upCorner = {x = 1517, y = 845, z = 10}, downCorner = {x = 1560, y = 877, z = 10}}},
        },
        ["cave bandits in desert"] = {
            amount = 50,
            spawnTime = MS_DAY*2,
            monsterT = {["bandit hunter"] = {}, ["bandit mage"] = {}, ["bandit knight"] = {}, ["bandit druid"] = {},
                ["bandit sorcerer"] = {}, ["bandit rogue"] = {}, ["bandit shaman"] = {}},
            areaCorners = {
                {upCorner = {x = 1393, y = 751, z = 8}, downCorner = {x = 1439, y = 790, z = 8}},
                {upCorner = {x = 1353, y = 749, z = 9}, downCorner = {x = 1388, y = 776, z = 9}},
                {upCorner = {x = 1428, y = 784, z = 9}, downCorner = {x = 1453, y = 812, z = 9}},
            }
        },

    }
}
centralSystem_registerTable(empire_centralT)

function empire_startUp()
    mapConf.startingLocationAmount = tableCount(mapConf.startingLocations)
    mapConf.lastStartingLocationID = mapConf.startingLocationAmount
    empireConf.characters = {}

    for itemAID, rewardT in pairs(mapConf.chestRewards) do
        local itemID = rewardT.itemID or 1740
        for _, pos in ipairs(rewardT.chestPositions) do createItem(itemID, pos, 1, itemAID) end
    end
end

function empire_configMW(player)
--    if not player:isGod() then return player:sendTextMessage(GREEN, empireConf.msgT.notGod) end
    player:createMW(MW.empire_config)
end

function empire_config_handleMW(player, mwID, buttonID, choiceID, save)
    if buttonID == 101 then return end

    if choiceID == 1 then
        if not player:isGod() then player:sendTextMessage(GREEN, "You are not allowed to activate Empire Event") end -- temp
        empireConf.canJoinEvent = not empireConf.canJoinEvent and true or false
        return empire_configMW(player)
    end
    if choiceID == 2 then return empire_testMap(player) end --temp
    if choiceID == 3 then return empire_testMap_logOut(player) end --temp
end

function empire_config_choices(player)
    local choiceT = {}
    choiceT[1] = empireConf.canJoinEvent and "registration is open" or "registration is closed"
    choiceT[2] = player:getSV(SV.empireTester) ~= 1 and "explore empire map" or nil
    choiceT[3] = player:getSV(SV.empireTester) == 1 and "leave empire map" or nil
    return choiceT
end

function empire_onMove(player, item)
    return isInRange(player:getPosition(), mapConf.upCorner, mapConf.downCorner, true) and item:isContainer()
end

function mapmark_onLook(player, item)
    local flagID = item:getText("ID")
    if not flagID then return end
    return player:sendTextMessage(GREEN, mapMarkT[flagID].desc)
end

function empire_enterEvent(player, item, itemEx, fromPos, toPos, fromObject, toObject)
    if not player:isPlayer() then return end
    local empireID = empire_getCharacterID(player)

    if empireID > 0 then
        local character = empire_getCharacter(empireID)
        if not character then return player:sendTextMessage(GREEN, empireConf.msgT.charKilled) end
        return empire_replacePlayerWithChar(player, character)
    end

    if empireConf.canJoinEvent then return empire_registerEvent(player) end
    teleport(player, fromPos)
    player:sendTextMessage(GREEN, empireConf.msgT.regClosed)
end

function empire_logOut(player)
    local character = empire_getCharacter(player)
    if not character then return true end
    if character.creatureID ~= player:getId() then return true end
    empire_replaceMonsterWithChar(player, character)
end

function empire_replaceMonsterWithChar(player, characterT)
    local monster = createMonster("player", player:getPosition())
    local maxHP = player:getMaxHealth()
    local addHP = maxHP - player:getHealth()

    teleport(player, player:homePos())
    bindCondition(monster, "legsHaste", -1, {speed = 1})
    monster:setMaxHealth(maxHP)
    monster:addHealth(-addHP)
    monster:setOutfit(player:getOutfit())
    characterT.items = player:saveItems("empire")
    characterT.lastMana = player:getMana()
    characterT.creatureID = monster:getId()
    player:loadItems("whi world")
end

function empire_replacePlayerWithChar(player, characterT)
    if characterT.isDead then return player:sendTextMessage(GREEN, empireConf.msgT.charDead) end
    local creature = Creature(characterT.creatureID)
    if not creature then return empire_error(player, "creature did not exist in empire_replacePlayerWithChar()") end

    player:saveItems("whi world")
    player:loadItems(characterT.items)
    characterT.creatureID = player:getId()

    local charPos = creature:getPosition()
    local addHP = creature:getHealth() - player:getHealth()
    local addMP = characterT.lastMana - player:getMana()

    creature:remove()
    teleport(player, charPos)
    player:addHealth(-addHP)
    player:addMana(-addMP)
end

function empire_registerEvent(player)
    local nextID = tableCount(empireConf.characters) + 1

    player:setSV(empireConf.empireCharIDSV, nextID)
    teleport(player, empire_getNextStartPos())

    empireConf.characters[nextID] = {
        ID = nextID,
        name = player:getName(),
        isDead = false,
        creatureID = player:getId(),
        lastMana = player:getMana(),
        skillPoints = 0,
        skillTree = {},
        items = {},
    }
    player:saveItems("whi world")
    player:loadItems({})
end

function empire_error(player, errorMsg)
    player:sendTextMessage(BLUE, "I'm sorry event is bugged for you. Error has been successfully sent to server owner")
    print("ERROR - "..errorMsg)
end

-- get functions
function empire_getCharacterID(player) return player:getSV(empireConf.empireCharIDSV) end

function empire_getCharacter(object, canBeDead)
    if type(object) == "number" then
        if object < 1 then return end

        for charID, characterT in ipairs(empireConf.characters) do
            if charID == object then
                local deadCheck = canBeDead or not characterT.isDead
                return deadCheck and characterT
            end
        end
    elseif type(object) == "userdata" then
        if object:isPlayer() then return empire_getCharacter(empire_getCharacterID(object)) end
    end
end

function empire_getNextStartPos()
    local nextPosID = mapConf.lastStartingLocationID + 1
    if nextPosID > mapConf.startingLocationAmount then nextPosID = 1 end
    mapConf.lastStartingLocationID = nextPosID
    return mapConf.startingLocations[nextPosID]
end

-- generation and test functions

function empire_testMap(player)
    if not player:isGod() then return player:sendTextMessage(GREEN, "Only GOD can enter Empire map right now") end
    if player:getSV(SV.tutorial) ~= 1 then return player:sendTextMessage(GREEN, "You need to complete tutorial first") end
    teleport(player, empire_getNextStartPos())
    bindCondition(player, "speedPotion", -1, {speed = 2000})
    player:rewardItems({itemID = 2294, itemAID = 4138}, true)
    player:setSV(SV.empireTester, 1)

    player:sendTextMessage(ORANGE, "Mark down below locations with command: !map DESCRIPTION_FOR_LOCATION")
    player:sendTextMessage(BLUE, "1. Locations what end up with dead ends. (I will put something there then)")
    player:sendTextMessage(BLUE, "2. When you find chests on map what should have something inside it, but doesnt or has something odd in it")
    player:sendTextMessage(BLUE, "3. When you find equipment items or consumeable items, which are not inside containers")
    player:sendTextMessage(BLUE, "4. When you you find room or location what can't be accessed")
    player:sendTextMessage(BLUE, "You can leave the test map by logging out")
    player:sendTextMessage(BLUE, "Plz explore desert, left green area has been explored quite troughly already")
end

function empire_testMap_logOut(player)
    if player:getSV(SV.empireTester) ~= 1 then return true end
    teleport(player, player:homePos())
    removeCondition(player, "speedPotion")
    player:removeItem(2294)
    player:removeSV(SV.empireTester)
end

local flagID = 0
mapMarkT = {}
function empire_createMapMark(player, desc)
    local pos = player:getPosition()
    flagID = flagID + 1
    createItem(1436, pos, 1, nil, nil, "ID("..flagID..")")
    mapMarkT[flagID] = {pos = pos, desc = desc}
end

function createMapMarkFile()
    local toFile = io.open("data/mapmarks.lua", "a")
    if not toFile then return print("toFile not found") end
    local text = ""

    for flagID, flagT in ipairs(mapMarkT) do
        text = text.."{x = "..flagT.pos.x..", y = "..flagT.pos.y..", z = "..flagT.pos.z.."}"
        text = text.." - "..flagT.desc.."\n"
    end
    toFile:write(text)
    toFile:close()
    print("wrote mapmarks.lua file")
end

allPositions = allPositions or {}
function empire_createPosMap() -- RETURNS {zPos = {POS}}
    local mainUp = mapConf.upCorner
    local mainDown = mapConf.downCorner
    
    for z=1, 15 do
        local upCorner = {x=mainUp.x, y=mainUp.y, z=z}
        local downCorner = {x=mainDown.x, y=mainDown.y, z=z}
        local square = createSquare(upCorner, downCorner)
        local cleanSquare = removePositions(square, {"noGround", "blockThrow", 4608, 4665, 4619, 4666, 4617, 4609, 4610, 4611, 4612, 4613,
                4614, 4615, 4616, 4618, 4664})
        allPositions[z] = cleanSquare
    end
    Tprint("allPositions table filled")
end

function empire_itemRewards_createContainerItems()
    local toFile = io.open("data/empire_itemRewardsConf.lua", "a")
    if not toFile then return print("toFile not found") end
    local leatherItems = {2461, 2467, 2649, 2643, 20109}
    local clothItems = {2662, 12434, 2663, 12429, 10570, 12442, 18398, 7896, 7730}
    local weapons_tier1 = {2376, 2398, 2380, 7367, 2183, 2190, 2456}
    local weapons_tier2 = {15647, 13760, 15400}
    local wands = {2183, 2190, 13760, 15400}
    local books = {1950, 1955, 1958, 1959, 1960, 1961, 1962, 1963, 1964, 1965, 1966}
    local count, maxAmount, fluidType, itemAID

    local function randomGem()
        count = math.random(2)
        maxAmount = math.random(count, 4)
        return randomKeyFromTable(gems)
    end

    local function randomStone()
        local stoneT = randomValueFromTable(stones_conf.stones)
        count = math.random(3)
        maxAmount = stoneT.maxValue > count and math.random(count, stoneT.maxValue)
        return stoneT.itemID
    end

    local function getRandomFood()
        local function getFoodID()
            local foodID = randomKeyFromTable(foodConf.food)
            return tonumber(foodID) and foodID ~= 2006 and foodID or getFoodID()
        end
        local foodID = getFoodID()
        local foodT = food_getFoodT(foodID)

        count = foodT.duration < 30 and math.random(4) or math.random(2)
        maxAmount = math.random(count, count*3)
        itemAID = "foodAID"
        return foodID
    end

    local function getRandomCoffinItem()
        if chanceSuccess(35) then return randomGem() end
        if chanceSuccess(35) then return randomStone() end
        if chanceSuccess(25) then return randomValueFromTable(wands) end
        count = math.random(20)
        maxAmount = math.random(count, 100)
        return ITEMID.other.coin
    end

    local function getRandomShelfItem()
        if chanceSuccess(70) then return randomValueFromTable(books) end
        if chanceSuccess(50) then return randomGem() end
        return randomKeyFromTable(stones_conf.stones)
    end

    local function getRandomWardrobeItem()
        if chanceSuccess(80) then return randomValueFromTable(leatherItems) end
        return randomValueFromTable(clothItems)
    end

    local function getRandomWeapon()
        if chanceSuccess(95) then return randomValueFromTable(weapons_tier1) end
        return randomValueFromTable(weapons_tier2)
    end

    local function getRandomArmor()
        local armorID = randomValueFromTable(ITEMID.eq)
        if isInArray(allWeapons, armorID) then return getRandomArmor() end
        if isInArray(clothItems, armorID) then return getRandomArmor() end
        if isInArray(leatherItems, armorID) then return getRandomArmor() end
        return armorID
    end

    local function parseID(itemID)
        local newID = itemID
        
        for category, t in pairs(ITEMID) do
            for key, v in pairs(t) do
                if v == tonumber(itemID) then
                    newID = "ITEMID."..category.."."..key
                    break
                end
            end
        end
        return ", itemID = "..newID
    end

    local function getRandomID(ID)
        if isWeaponRack(ID) then return getRandomWeapon() end
        if isArmorRack(ID) then return getRandomArmor() end
        if isWardrobe(ID) then return getRandomWardrobeItem() end
        if isCoffin(ID) then return getRandomCoffinItem() end
        if isShelf(ID) then return getRandomShelfItem() end
        if chanceSuccess(10) then return getRandomArmor() end
        if chanceSuccess(15) then return randomGem() end
        if chanceSuccess(15) then return randomStone() end
        return getRandomFood()
    end

    local function getItemID(ID)
        local itemID = getRandomID(ID)
        return parseID(itemID)
    end

    local function getPos(pos) return "pos = {x = "..pos.x..", y = "..pos.y..", z = "..pos.z.."}" end
    local function getCount() return count and ", count = "..count or "" end
    local function getMaxAmount() return maxAmount and ", maxAmount = "..maxAmount or "" end
    local function getFluidType() return fluidType and ", fluidType = "..fluidType or "" end
    local function getItemAID() return itemAID and ", itemAID = "..itemAID or "" end

    local text = ""
    local function updateText(pos)
        local item = getTopContainer(pos)
        if not item then return end
        local ID = item:getId()
        count, maxAmount, fluidType, itemAID = 1, nil, nil, nil
        local itemID = getItemID(ID)
        text = text.."{"..getPos(pos)..getCount()..itemID..getMaxAmount()..getFluidType()..getItemAID()..", container = "..ID.."},\n"
    end

    for zPos, posT in pairs(allPositions) do
        Vprint(zPos, "zPos")
        for _, pos in pairs(posT) do updateText(pos) end
    end

    toFile:write(text)
    toFile:close()
    Tprint("wrote empire_itemRewardsConf.lua file")
end