-- NB!! make sure herbs are loaded before this file.
--[[ Potion config guide
    [STR] = {                           potion name
        itemID = INT,                   The potion itemID
        itemAID = INT,                  the potion itemAID
        potionType = STR,               only 1 potionType can be acitvated at the same time. potions without type, effects cant be removed
        ingredients = {STR, STR}        powder names required to craft potion (NB! only 2 can be used atm)
        recipeSV = INT                  -1 == not learned | 2 == learned (aka in the recipe book)
        brewingExp = INT
        
        buff/nerf = {                   same configuration for nerf
            defaultValue = INT          base VALUE for the effect
            effect = STR,               VALUE == x or INT returned from funcStr  | _G[buff/nerf.funcStr](player, potionT, true)
            funcStr = STR,              function what activates when potion used | _G[buff/nerf.funcStr](player, potionT)
            secDuration =  INT or 10    potion effects duration
            effectSV = INT              storage value to keep track of buff/nerf
            endTimeSec = INT            storage value to track time when potion ends
        }
        -- automatic
        name = STR                      table key
        potionID = INT                  ingrediends powderID's put together
    }
]]
local AIDT = AID.potions

brewingConf = {
    professionT = {
        professionStr = "brewing",
        expSV = SV.brewingExp,
        levelSV = SV.brewingLevel,
        mwID = MW.cookBook,
    }
}

potions = {
    ["speed potion"] = { -- special case makes potion straight away
        itemID = 12422,
        itemAID = AIDT.speed,
        potionType = "Support Potion",
        ingredients = {"golden spearmint herb"},
        recipeSV = SV.speedPotionRecipe,
        brewingExp = 20,
        
        buff = {
            defaultValue = 50,
            effect = "Your speed will be increased by VALUE",
            funcStr = "potions_speedPotion_buff",
            secDuration = 20*60,
            effectSV = SV.speedPotion_buff,
            endTimeSec = SV.speedPotion_buffTime,
        },
        nerf = {
            defaultValue = 30,
            effect = "You loose VALUE armor",
            funcStr = "potions_speedPotion_nerf",
            secDuration = 20*60,
            effectSV = SV.speedPotion_nerf,
            endTimeSec = SV.speedPotion_nerfTime,
        },
    },
    ["spellcaster potion"] = {
        itemID = 13735,
        itemAID = AIDT.spellcaster,
        potionType = "Support Potion",
        ingredients = {"shadily gloomy shroom", "urreanel"},
        recipeSV = SV.spellcasterPotionRecipe,
        brewingExp = 55,
        buff = {
            defaultValue = 3,
            effect = "every time your damage spell hits, heal yourself by VALUE hp",
            funcStr = "potions_spellcaster_buff",
            secDuration = 10*60,
            effectSV = SV.spellcasterPotion_buff,
            endTimeSec = SV.spellcasterPotion_buffTime,
        },
        nerf = {
            defaultValue = 10,
            effect = "your spells cost VALUE% more mana (rounded upwards)",
            funcStr = "potions_spellcaster_nerf",
            secDuration = 10*60,
            effectSV = SV.spellcasterPotion_nerf,
            endTimeSec = SV.spellcasterPotion_nerfTime,
        },
    },
    ["silence potion"] = {
        itemID = 21403,
        itemAID = AIDT.silence,
        potionType = "Support Potion",
        ingredients = {"xuppeofron", "eaplebrond"},
        recipeSV = SV.silencePotionRecipe,
        brewingExp = 55,
        buff = {
            defaultValue = 20,
            effect = "VALUE% chance to silence target for 1 second on weapon hit (except wands)",
            funcStr = "potions_silence_buff",
            secDuration = 10*60,
            effectSV = SV.silencePotion_buff,
            endTimeSec = SV.silencePotion_buffTime,
        },
        nerf = {
            defaultValue = 50,
            effect = "all elemental resistances are lowered by VALUE%",
            funcStr = "potions_silence_nerf",
            secDuration = 10*60,
            effectSV = SV.silencePotion_nerf,
            endTimeSec = SV.silencePotion_nerfTime,
        },
    },
    ["flash potion"] = {
        itemID = 12544,
        itemAID = AIDT.flash,
        potionType = "Support Potion",
        ingredients = {"flysh", "iddunel"},
        recipeSV = SV.flashPotionRecipe,
        brewingExp = 55,
        buff = {
            defaultValue = 0,
            effect = "your attack speed is increased by VALUE% (energy res + energy res * (0.1 * brewing level))",
            funcStr = "potions_flash_buff",
            secDuration = 10*60,
            effectSV = SV.flashPotion_buff,
            endTimeSec = SV.flashPotion_buffTime,
        },
        nerf = {
            defaultValue = 100,
            effect = "reduces weapon maximum damage by VALUE% while attacking but not less than its minium damage",
            funcStr = "potions_flash_nerf",
            secDuration = 10*60,
            effectSV = SV.flashPotion_nerf,
            endTimeSec = SV.flashPotion_nerfTime,
        },
    },
    ["druid potion"] = {
        itemID = 12468,
        itemAID = AIDT.druid,
        potionType = "vocation potion",
        ingredients = {"stranth", "eaplebrond"},
        recipeSV = SV.druidPotionRecipe,
        brewingExp = 20,
        buff = {
            defaultValue = 10,
            effect = "Your spells cost VALUE% less mana(rounded upwards).",
            funcStr = "potions_druid_buff",
            secDuration = 30*60,
            effectSV = SV.druidPotion_buff,
            endTimeSec = SV.druidPotion_buffTime,
        },
        nerf = {
            defaultValue = 10,
            effect = "VALUE% of spell cost is taken from health instead(rounded upwards).",
            funcStr = "potions_druid_nerf",
            secDuration = 30*60,
            effectSV = SV.druidPotion_nerf,
            endTimeSec = SV.druidPotion_nerfTime,
        },
    },
    ["hunter potion"] = {
        itemID = 7477,
        itemAID = AIDT.hunter,
        potionType = "vocation potion",
        ingredients = {"oawildory", "dagosil"},
        recipeSV = SV.hunterPotionRecipe,
        brewingExp = 20,
        buff = {
            defaultValue = 10,
            effect = "Each physical hit will apply poison for 5sec and it deals VALUE earth damage per sec. Stacks 10 times for hitting.",
            funcStr = "potions_hunter_buff",
            secDuration = 30*60,
            effectSV = SV.hunterPotion_buff,
            endTimeSec = SV.hunterPotion_buffTime,
        },
        nerf = {
            defaultValue = 10,
            effect = "Each time you make physical damage, you loose VALUE speed for 10sec. Stacks 10 times.",
            funcStr = "potions_hunter_nerf",
            secDuration = 30*60,
            effectSV = SV.hunterPotion_nerf,
            endTimeSec = SV.hunterPotion_nerfTime,
        },
    },
    ["mage potion"] = {
        itemID = 7495,
        itemAID = AIDT.mage,
        potionType = "vocation potion",
        ingredients = {"eaddow", "urreanel"},
        recipeSV = SV.magePotionRecipe,
        brewingExp = 20,
        buff = {
            defaultValue = 50,
            effect = "Gain aura around you. Deals (VALUE + mL*6 + L*8) energy damage per second (distance 1 tile).",
            funcStr = "potions_mage_buff",
            secDuration = 30*60,
            effectSV = SV.magePotion_buff,
            endTimeSec = SV.magePotion_buffTime,
        },
        nerf = {
            defaultValue = 10,
            effect = "loose VALUE% of your total mana pool.",
            funcStr = "potions_mage_nerf",
            secDuration = 20*60,
            effectSV = SV.magePotion_nerf,
            endTimeSec = SV.magePotion_nerfTime,
        },
    },
    ["knight potion"] = {
        itemID = 20135,
        itemAID = AIDT.knight,
        potionType = "vocation potion",
        ingredients = {"jesh mint", "iddunel"},
        recipeSV = SV.knightPotionRecipe,
        brewingExp = 20,
        buff = {
            defaultValue = 50,
            effect = "Physical weapon damage deals VALUE fire damage on each hit.",
            funcStr = "potions_knight_buff",
            secDuration = 30*60,
            effectSV = SV.knightPotion_buff,
            endTimeSec = SV.knightPotion_buffTime,
        },
        nerf = {
            defaultValue = 3,
            effect = "You loose VALUE armor on each weapon hit for 8 seconds. Stacks Infinitely.",
            funcStr = "potions_knight_nerf",
            secDuration = 30*60,
            effectSV = SV.knightPotion_nerf,
            endTimeSec = SV.knightPotion_nerfTime,
        },
    },
    ["antidote potion"] = {
        itemID = 7477,
        itemAID = AIDT.antidote,
        ingredients = {"eaplebrond", "mobberel"},
        recipeSV = SV.antidotePotionRecipe,
        brewingExp = 25,
        buff = {
            effect = "Removes all poison effects instantly.",
            funcStr = "potions_antidote_buff",
        },
        nerf = {
            defaultValue = 30,
            effect = "your elemental resistances are reduced by VALUE%",
            funcStr = "potions_antidote_nerf",
            secDuration = 20,
            effectSV = SV.antidotePotion_nerf,
            endTimeSec = SV.antidotePotion_nerfTime,
        },
    },
}

local feature_brewing = {
    startUpFunc = "brewing_startUp",
    IDItems_onLook = {
        [10031] = {funcStr = "potions_onLook"},
    }
}

centralSystem_registerTable(feature_brewing)