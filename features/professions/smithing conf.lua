--[[ smithingConf guide
    defaults = {                    table where any key can have default value
        count = INT,
        exp = INT,
    },
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    }
    
    quickCraft = {                  list of materials itemID's which which invoke crafting if hammer used on them | removes only 1 material at once
        [itemID] = STR              STR == key for craftingMaterials
    },
    craftingGroups = {STR}          list of craftable goods groups
    
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
    levelUpMessages = {             generated based of craftingMaterials bigSV[SV.smithingLevel]
        [INT] = {STR},              INT = level which was achieved. STR = messages they will receive
    }
]]

smithingConf = {
    defaults = {
        count = 1,
        exp = 1,
    },
    professionT = {
        professionStr = "smithing",
        expSV = SV.smithingExp,
        levelSV = SV.smithingLevel,
        mwID = MW.smithing,
    },
    
    quickCraft = {
        [5887] = "steel nails",
        [5880] = "copper nails",
        [5888] = "iron nails",
    },
    craftingGroups = {"other", "equipment", "materials"},
    craftingMaterials = {
        ["steel nails"] = {
            reqT = {itemID = 5887, count = 1},
            itemID = 8309,
            takeCharges = 1,
            count = 4,
            needAnvil = true,
            group = "materials",
            exp = 8,
        },
        ["copper nails"] = {
            reqT = {itemID = 5880, count = 1},
            itemID = 8309,
            takeCharges = 1,
            needAnvil = true,
            group = "materials",
            exp = 2,
        },
        ["iron nails"] = {
            reqT = {itemID = 5888, count = 1},
            itemID = 8309,
            takeCharges = 1,
            count = 2,
            needAnvil = true,
            group = "materials",
            exp = 4,
        },
        ["iron sword"] = {
            reqT = {
                {itemID = 5888, count = 2},
                {itemID = 5880, count = 1},
            },
            itemID = 2376,
            itemText = "randomStats",
            group = "equipment",
            exp = 25,
            takeCharges = 3,
            needAnvil = true,
        },
        ["iron mace"] = {
            reqT = {
                {itemID = 5888, count = 3},
                {itemID = 5880, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
            },
            bigSV = {[SV.smithingLevel] = 1},
            itemID = 2398,
            itemText = "randomStats",
            group = "equipment",
            exp = 40,
            takeCharges = 3,
            needAnvil = true,
        },
        ["iron axe"] = {
            reqT = {
                {itemID = 5888, count = 3},
                {itemID = 5880, count = 1},
                {itemID = ITEMID.materials.log, count = 1},
            },
            bigSV = {[SV.smithingLevel] = 1},
            itemID = 2380,
            itemText = "randomStats",
            group = "equipment",
            exp = 40,
            takeCharges = 3,
            needAnvil = true,
        },
        ["warrior boots"] = {
            reqT = {
                {itemID = 5887, count = 7},
                {itemID = 5888, count = 4},
                {itemID = 5880, count = 2},
                {itemID = 13862, count = 1},
            },
            allSV = {[SV.recipe_warriorBoots] = 1},
            itemID = 2645,
            itemText = "randomStats",
            group = "equipment",
            exp = 120,
            takeCharges = 5,
            needAnvil = true,
        },
        ["blessed iron helmet"] = {
            reqT = {
                {itemID = 5887, count = 4},
                {itemID = 5888, count = 7},
                {itemID = 5880, count = 2},
                {itemID = 13862, count = 2},
            },
            allSV = {[SV.blessedIronHelmetMission] = 1},
            itemID = 9735,
            itemText = "randomStats",
            group = "equipment",
            exp = 180,
            takeCharges = 5,
            needAnvil = true,
        },
        ["anvil"] = {
            reqT = {
                {itemID = 5887, count = 12},
                {itemID = 5888, count = 7},
                {itemID = 5880, count = 4},
            },
            itemID = 2555,
            exp = 200,
            bigSV = {[SV.smithingLevel] = 3},
            takeCharges = 5,
            inHouse = true,
        },
        ["depot"] = {
            reqT = {
                {itemID = 5887, count = 20},
                {itemID = 5888, count = 10},
                {itemID = 5880, count = 10},
                {itemID = 13862, count = 5},
                {itemID = 13215, count = 6},
            },
            itemID = 2591,
            exp = 400,
            bigSV = {[SV.smithingLevel] = 3},
            takeCharges = 10,
            inHouse = true,
        },
        
    },
}

feature_smithing = {
    startUpFunc = "smithing_startUp",
    modalWindows = {
        [MW.smithing] = {
            name = "smithing profession",
            title = "smithingMW_title2",
            choices = {
                [1] = "smith equipment",
                [2] = "smith materials",
                [3] = "smith other items",
            },
            buttons = "smithingMW_buttons",
            save = "smithingMW_save",
            func = "smithingMW",
            say = "*checking smithing profession*",
        },
        [MW.smithing_other] = {
            name = "smithing other items",
            title = "smithingMW_title",
            choices = "smithing_otherMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            save = "smithingMW_save",
            func = "smithing_craftMW",
        },
        [MW.smithing_equipment] = {
            name = "smithing equipment items",
            title = "smithingMW_title",
            choices = "smithing_equipmentMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            save = "smithingMW_save",
            func = "smithing_craftMW",
        },
        [MW.smithing_materials] = {
            name = "smithing materials",
            title = "smithingMW_title",
            choices = "smithing_materialsMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "craft",
            },
            save = "smithingMW_save",
            func = "smithing_craftMW",
        },
        
    },
}

centralSystem_registerTable(feature_smithing)

function smithing_startUp()
local loopID = 0
local levelUpMessages = {}

    addProfession(smithingConf.professionT)
    
    for n, craftT in pairs(smithingConf.craftingMaterials) do
        if craftT.reqT and craftT.reqT.itemID then craftT.reqT = {craftT.reqT} end
        if craftT.reqT then
            for _, itemT in ipairs(craftT.reqT) do
                if not itemT.count then itemT.count = smithingConf.defaults.count end
            end
        end
        if not craftT.exp then craftT.exp = smithingConf.defaults.exp end
        if not craftT.group and not craftT.inHouse then print("ERROR - missing group in smithingConf.craftingMaterials["..n.."]") end
        if craftT.group and not isInArray(smithingConf.craftingGroups, craftT.group) then print("ERROR - bad group name ["..craftT.group.."] in smithingConf.craftingMaterials["..n.."]") end
        if not craftT.itemID then print("ERROR - missing itemID in smithingConf.craftingMaterials["..n.."]") end
        if not craftT.count then craftT.count = smithingConf.defaults.count end
        
        if craftT.bigSV then
            local smithingLevel = craftT.bigSV[SV.smithingLevel]
            
            if not levelUpMessages[smithingLevel] then levelUpMessages[smithingLevel] = {} end
            local extraText = ""
            if craftT.needAnvil then extraText = " on the anvil" end
            if craftT.inHouse then extraText = " in the house" end
            table.insert(levelUpMessages[smithingLevel], "smithing level up: You can now craft "..n..extraText)
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
                extraText = "smithing",
                failChance = 0,
                takeCharges = craftT.takeCharges,
            }
        end
        
        loopID = loopID + 1
        craftT.ID = loopID
        craftT.craftName = n
    end
    smithingConf.levelUpMessages = levelUpMessages
end