--[[ gems2Conf guide
    extraText = STR                     extra information given when player has extraText activated
    
    buffStrings = {
        [STR] = {                       buff name | maxHP, maxMP, lootBonus, allRes, cooldownReduction
            upgradedItem = STR,         when item is looked what has the gem
            gemLook = STR,              when gem is looked
                                        "GEM_NAME" = uses the gem name
                                        "VALUE" = uses the value from gemT
                                        "ITEM_WEIGHT" = item cap
        }
    },

    gems = {
        [INT] = {                       itemID for gem
            name = STR                  name of the gem
            eleType = STR,              elemental type for the gem | "fire", "ice", "death", "energy", "earth", "physical" | improves shield gem effects
            maxHP = INT                 adds maxHP
            maxMP = INT                 adds maxMP
            lootBonus = INT             % amount of loot drop chance increase
            allRes = INT                increases item base resistances
            cooldownReduction = INT     cooldown reduction amount per 100 cap of an item
            upgradeEffect = INT or 3    effect what happens when item is upgraded with this gem

            AUTOMATIC
            gemID = INT                 same with table key
        }
    }
]]
-- these gems can be crafted in enchanting conf
gems2Conf = {
    extraText = "you can upgrade item with this gem, by throwing it on equipment item",

    buffStrings = {
        maxHP = {
            upgradedItem = "[GEM_NAME] adds VALUE maximum health",
            gemLook = "GEM_NAME\nIncreases equipment item maximum health by VALUE",
        },
        maxMP = {
            upgradedItem = "[GEM_NAME] adds VALUE maximum mana",
            gemLook = "GEM_NAME\nIncreases equipment item maximum mana by VALUE",
        },
        lootBonus = {
            upgradedItem = "[GEM_NAME] increases loot drop chance by VALUE%",
            gemLook = "GEM_NAME\nIncreases equipment item loot drop chance by VALUE%",
        },
        allRes = {
            upgradedItem = "[GEM_NAME] added VALUE% to item physical and elemental resistances",
            gemLook = "GEM_NAME\nAdds VALUE% to equipment item base physical and elemental resistances",
        },
        cooldownReduction = {
            upgradedItem = "[GEM_NAME] reduces spell cooldowns by (ITEM_WEIGHT/100*VALUE) seconds",
            gemLook = "GEM_NAME\nReduces spell cooldowns by item_weight/100*VALUE seconds",
        },
    },
    
    gems = {
        [2156] = {
            name = "health gem",
            eleType = "fire",
            maxHP = 200,
        },
        [2158] = {
            name = "mana gem",
            eleType = "energy",
            maxMP = 100,
        },
        [2153] = {
            name = "resistance gem",
            eleType = "death",
            allRes = 4,
        },
        [2155] = {
            name = "cooldown gem",
            eleType = "earth",
            cooldownReduction = 0.5,
        },
        [2154] = {
            name = "loot gem",
            eleType = "ice",
            lootBonus = 20,
        },
    }
}

local feature_gems2 = {
    startUpFunc = "gems2_startUp",
    lootSystem_bonusChance = "lootSystem_getLootGemChance",
    IDItems_onLook = {},
    IDItems_onMove = {},
}

for gemID, t in pairs(gems2Conf.gems) do
    feature_gems2.IDItems_onLook[gemID] = {funcSTR = "gems2_gem_onLook"}
    feature_gems2.IDItems_onMove[gemID] = {funcSTR = "gems2_onMove"}
end

centralSystem_registerTable(feature_gems2)