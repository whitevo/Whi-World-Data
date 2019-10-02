--[[ craftingConf guide
    defaults = {                    table where any key can have default value
        count = INT
        exp = INT
    },
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    }
    
    craftingGroups = {STR}          list of craftable goods groups
    quickCraft = {                  list of materials itemID's which which invoke crafting if hammer used on them
        [itemID] = STR              STR == key for craftingMaterials
    }
    
    craftingMaterials = {           uses defaults table
        [STR] = {                   craftName
            reqT = {{
                itemID = INT,
                itemAID = INT,
                count = INT or 1,
                fluidType = INT,
            }},
            exp = INT,
            group = STR,            craftingGroups
            allSV = {[SV] = v},
            bigSV = {[SV] = v},
            itemID = INT,
            itemAID = INT,
            itemText = STR,         "randomStats" rolls random stats to item
            fluidType = INT,
            takeCharges = INT,      how many charges takes from tool | 0 == doesn't take charges but tool is needed
            count = INT,
            needAnvil = false,
            inHouse = false,        ony can be built in house
            
            --
            ID = INT                choiceID for modal windows
            craftName = STR         key of the table
        }
    },
    
    -- automatic
    levelUpMessages = {             generated based of craftingMaterials bigSV[SV.craftingLevel]
        [INT] = {STR},              INT = level which was achieved. STR = messages they will receive
    }
]]

craftingConf = {
    defaults = {
        count = 1,
        exp = 1,
    },
    professionT = {
        professionStr = "crafting",
        expSV = SV.craftingExp,
        levelSV = SV.craftingLevel,
        mwID = MW.crafting,
    },
    
    craftingGroups = {"other", "equipment", "materials"},
    quickCraft = {
        [11214] = "spear",
        [13533] = "hunting spear",
        [ITEMID.materials.brick] = "building sand",
        [8309] = "arrows",
    },
    craftingMaterials = {
        ["spellscroll paper"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 1},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 4842,
            count = 1,
            group = "materials",
            exp = 1,
        },
        ["bow"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 5913, count = 1},
            },
            bigSV = {[SV.craftingLevel] = 2},
            itemID = 2456,
            count = 1,
            group = "equipment",
            exp = 10,
            itemText = "randomStats",
        },
        ["arrows"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 8309, count = 1},
            },
            itemID = 2544,
            count = 5,
            group = "equipment",
            exp = 5,
        },
        ["spear"] = {
            reqT = {itemID = 11214, count = 4},
            itemID = 2389,
            group = "equipment",
            exp = 10,
        },
        ["hunting spear"] = {
            reqT = {itemID = 13533, count = 1},
            itemID = 3965,
            group = "equipment",
            bigSV = {[SV.craftingLevel] = 1},
            exp = 30,
        },
        ["steel pickaxe"] = {
            reqT = {
                {itemID = 5887, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 8309, count = 1},
            },
            itemID = 2553,
            itemAID = AID.other.tool,
            itemText = "charges(1)",
            group = "other",
            exp = 20,
            takeCharges = 1,
        },
        ["iron shovel"] = {
            reqT = {
                {itemID = 5888, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 8309, count = 1},
            },
            itemID = 5710,
            itemAID = AID.other.tool,
            itemText = "charges(1)",
            group = "other",
            exp = 10,
            takeCharges = 1,
        },
        ["iron hammer"] = {
            reqT = {
                {itemID = 5888, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 8309, count = 1},
            },
            itemID = 2422,
            itemAID = AID.other.tool,
            itemText = "charges(1)",
            group = "other",
            exp = 10,
            takeCharges = 1,
        },
        ["steel saw"] = {
            reqT = {
                {itemID = 5887, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
                {itemID = 8309, count = 1},
            },
            itemID = 2558,
            itemAID = AID.other.tool,
            itemText = "charges(1)",
            group = "other",
            exp = 20,
            takeCharges = 1,
        },
        ["wooden chair"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 1},
            },
            itemID = 1652,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["round table"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 1},
            },
            itemID = 1616,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["small table"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 1},
            },
            itemID = 1619,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["big table"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 4},
                {itemID = 8309, count = 2},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1614,
            inHouse = true,
            exp = 25,
            takeCharges = 1,
        },
        ["drawers"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 4},
                {itemID = 8309, count = 2},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1716,
            itemAID = AID.other.canNotMove,
            inHouse = true,
            exp = 25,
            takeCharges = 1,
        },
        ["dresser"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 4},
                {itemID = 8309, count = 2},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1724,
            itemAID = AID.other.canNotMove,
            inHouse = true,
            exp = 25,
            takeCharges = 1,
        },
        ["chest"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 4},
                {itemID = 8309, count = 2},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1740,
            itemAID = AID.other.canNotMove,
            inHouse = true,
            exp = 25,
            takeCharges = 1,
        },
        ["trunk"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 5},
                {itemID = 8309, count = 2},
                {itemID = 5880, count = 1},
            },
            bigSV = {[SV.craftingLevel] = 2},
            itemID = 1750,
            itemAID = AID.other.canNotMove,
            inHouse = true,
            exp = 25,
            takeCharges = 2,
        },
        ["red chair"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 1},
                {itemID = 5911, count = 4},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1666,
            inHouse = true,
            exp = 30,
            takeCharges = 1,
        },
        ["green chair"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 1},
                {itemID = 5910, count = 4},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1670,
            inHouse = true,
            exp = 30,
            takeCharges = 1,
        },
        ["red pillow"] = {
            reqT = {itemID = 5911, count = 2}, 
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1680,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["orange pillow"] = {
            reqT = {
                {itemID = 5911, count = 1},
                {itemID = 5914, count = 1},
            },
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1682,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["green pillow"] = {
            reqT = {itemID = 5910, count = 2},
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1679,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["blue pillow"] = {
            reqT = {itemID = 5912, count = 2},
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1681,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["white pillow"] = {
            reqT = {itemID = 5909, count = 2},
            bigSV = {[SV.craftingLevel] = 1},
            itemID = 1684,
            inHouse = true,
            exp = 10,
            takeCharges = 1,
        },
        ["mirror"] = {
            reqT = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 3},
                {itemID = 13215, count = 8},
            },
            bigSV = {[SV.craftingLevel] = 3},
            itemID = 1736,
            itemAID = AID.other.mirror,
            inHouse = true,
            exp = 100,
            takeCharges = 4,
        },
        ["building sand"] = {
            reqT = {itemID = ITEMID.materials.brick, count = 1},
            itemID = ITEMID.materials.sand,
            itemAID = AID.other.buildingSand,
            exp = 4,
            group = "materials",
            takeCharges = 1,
        },
    },
}

feature_crafting = {
    startUpFunc = "crafting_startUp",
    AIDItems = {
        [AID.other.buildingSand] = {funcSTR = "buildingSand_onUse"},
        [AID.other.mirror] = {funcSTR = "mirror_onUse"},
    },
    AIDItems_onLook = {
        [AID.other.buildingSand] = {funcSTR = "buildingSand_onLook"},
    },
    modalWindows = {
        [MW.crafting] = {
            name = "crafting profession",
            title = "craftingMW_title",
            choices = {
                [1] = "craft equipment",
                [2] = "craft materials",
                [3] = "craft other items",
            },
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "craftingMW",
            say = "*checking crafting profession*",
        },
        [MW.crafting_other] = {
            name = "crafting other items",
            title = "craftingMW_title",
            choices = "crafting_otherMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            func = "crafting_craftMW",
        },
        [MW.crafting_equipment] = {
            name = "crafting equipment items",
            title = "craftingMW_title",
            choices = "crafting_equipmentMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            func = "crafting_craftMW",
        },
        [MW.crafting_materials] = {
            name = "crafting materials",
            title = "craftingMW_title",
            choices = "crafting_materialsMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            func = "crafting_craftMW",
        },
        
    },
}

centralSystem_registerTable(feature_crafting)

function crafting_startUp()
local loopID = 0
local levelUpMessages = {}

    addProfession(craftingConf.professionT)
    
    for n, craftT in pairs(craftingConf.craftingMaterials) do
        if craftT.reqT and craftT.reqT.itemID then craftT.reqT = {craftT.reqT} end
        if craftT.reqT then
            for _, itemT in ipairs(craftT.reqT) do
                if not itemT.count then itemT.count = craftingConf.defaults.count end
            end
        end
        if not craftT.exp then craftT.exp = craftingConf.defaults.exp end
        if not craftT.group and not craftT.inHouse then print("ERROR - missing group in craftingConf.craftingMaterials["..n.."]") end
        if craftT.group and not isInArray(craftingConf.craftingGroups, craftT.group) then print("ERROR - bad group name ["..craftT.group.."] in craftingConf.craftingMaterials["..n.."]") end
        if not craftT.itemID then print("ERROR - missing itemID in craftingConf.craftingMaterials["..n.."]") end
        if not craftT.count then craftT.count = craftingConf.defaults.count end
        
        if craftT.bigSV and craftT.bigSV[SV.craftingLevel] then
            local craftingLevel = craftT.bigSV[SV.craftingLevel]
            
            if not levelUpMessages[craftingLevel] then levelUpMessages[craftingLevel] = {} end
            local extraText = ""
            if craftT.needAnvil then extraText = " on the anvil" end
            if craftT.inHouse then extraText = " in the house" end
            table.insert(levelUpMessages[craftingLevel], "crafting level up: You can now craft "..n..extraText)
        end
        
        if craftT.inHouse then
            table.insert(building_groups.items, craftT.itemID)
            building_catalog[craftT.itemID] = {
                req = craftT.reqT,
                exp = craftT.exp,
                allSV = craftT.allSV,
                bigSV = craftT.bigSV,
                itemID = craftT.itemID,
                itemAID = craftT.itemAID,
                group = "items",
                extraText = "crafting",
                failChance = 0,
                takeCharges = craftT.takeCharges,
            }
        end
        
        loopID = loopID + 1
        craftT.ID = loopID
        craftT.craftName = n
    end
    craftingConf.levelUpMessages = levelUpMessages
end