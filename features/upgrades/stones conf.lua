--[[
    [itemID] = {
        name = STR                  stone name
        maxValue = INT or 1         highest value for stone
        maxValueBig = STR           message player gets when item already has max stats
        stoneL = INT or 1           up to how many values can stone give
        replace = false,            replaces previous same stone buff
        upgradedItem = STR          adds stone buff to item look
                                    "STONE_NAME" = uses the stoneT.name
                                    "VALUE" = uses the value from item
        upgradedItem_func = STR     funcStr which adds stone buff to item look
        itemTextKey = STR           key for itemText
        func = func()               custom function
        slots = {STR}               which item slots can be upgraded with that stone
        effects = {INT}             magic effects when item is upgraded
        rootStoneID = INT           doesnt trigger stones_item_onLook
                                    theoretically should uses same stoneT attributes except overwritten.
        --itemID = itemID
    }
]]

stones_conf = {

    stones = {
        [2286] = {
            name = "skill stone",
            maxValue = 2,
            stoneL = 2,
            replace = true,
            itemTextKey = "skillStoneValue",
            func = "stoneUpgrade_skillStone",
            upgradedItem_func = "stones_skillStoneDesc",
            slots = "bag",
            effects = {13,2,5},
        },
        [2266] = {
            name = "critical block stone",
            maxValue = 25,
            stoneL = 5,
            maxValueBig = "You have maxed out critical block chance with stone",
            slots = "shield",
            upgradedItem = "[STONE_NAME] +VALUE% critical block value",
            itemTextKey = "criticalBlockStoneValue",
            effects = {13, 2, 5},
        },
        [2267] = {
            name = "armor stone",
            maxValue = 3,
            maxValueBig = "These stones aren't powerful enough to upgrade more, try tier 2 armor stones",
            slots = {"legs", "body", "boots", "head"},
            upgradedItem = "[STONE_NAME] armor increased by VALUE",
            itemTextKey = "armorStoneValue",
            effects = {13, 2, 5},
        },
        [2265] = {"[GEM_NAME] reduces spell cooldowns by (ITEM_WEIGHT/100*VALUE) seconds",
            name = "armor stone 2",
            maxValue = 4,
            maxValueBig = "Your item armor is maxed out with stones",
            slots = {"legs", "body", "boots", "head"},
            upgradedItem = "[STONE_NAME] armor increased by VALUE",
            itemTextKey = "armorStoneValue",
            effects = {13, 2, 5},
            rootStoneID = 2267,
        },
        [2290] = {
            name = "speed stone",
            maxValue = 20,
            stoneL = 3,
            maxValueBig = "You have maxed out movement speed on these boots.",
            slots = "boots",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] movement speed improved by VALUE",
            itemTextKey = "speedStoneValue",
            func = "speedStone",
        },
        [2297] = {
            name = "crit stone",
            maxValue = 10,
            stoneL = 2,
            maxValueBig = "You have maxed out crit change on legs.",
            slots = "legs",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] your critical chances are improved by VALUE",
            itemTextKey = "critStoneValue",
        },
        [2264] = {
            name = "defence stone",
            maxValue = 5,
            maxValueBig = "You have maxed out defence on body equipment.",
            slots = "body",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] defence increase by VALUE",
            itemTextKey = "defStoneValue",
        },
        [2312] = {
            name = "sight stone",
            maxValue = 10,
            stoneL = 2,
            maxValueBig = "You have maxed out the chance to proc this unique effect.",
            slots = "head",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] You have VALUE% chance to cast your spell with 0 mana.",
            itemTextKey = "sightStoneValue",
        },
        [2271] = {
            name = "energy stone",
            maxValue = 3,
            maxValueBig = "You have maxed out energy spell radius on this wand.",
            slots = "wand",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] energy type spell radius is improved by VALUE",
            itemTextKey = "energyStoneValue",
        },
        [2263] = {
            name = "death stone",
            maxValue = 3,
            maxValueBig = "You have maxed out death radius on this wand.",
            slots = "wand",
            effects = {13, 2, 5},
            upgradedItem = "[STONE_NAME] death type spell radius is improved by VALUE",
            itemTextKey = "deathStoneValue",
        },
    }
}

local feature_stones = {
    startUpFunc = "stones_startUp",
    
    modalWindows = {
        [MW.god_createStones] = {
            name = "Create stone upgrades",
            title = "Choose stone to make",
            choices = "stones_createChoices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "creating upgrade stones",
            func = "createStonesMW",
        },
    },
    IDItems = {},
    IDItems_onLook = {
        [2297] = {text = {msg = "You see a crit stone \nIt weights 10.00oz \nadds crit chance to legs"}},
    },
}

for stoneID, t in pairs(stones_conf.stones) do
    feature_stones.IDItems[stoneID] = {funcStr = "stones_onUse"}
end

centralSystem_registerTable(feature_stones)