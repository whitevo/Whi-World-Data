--[[ gem table guide
    INT = {                         itemID for gem
        eleType = STR,              elemental type for the gem | "fire", "ice", "death", "energy", "earth", "physical"
        armorMax = INT or 1         maximum value for the upgrade for (helm, legs, boots, body)
        weaponMax = INT or 1        maximum value for the upgrade for weapons
        ME_effect = {INT} or {3}    what effects will pop up if item is upgraded
        shieldEffect = STR          effect what is written on shield.
                                    () everything inside will be considered as formula to be calculated
                                    "randomtype" will replace "type" with 1 random elemental gem you have on gear.
                                    randomtype1 includes looking the weapon
                                    randomtype2 includes looking the weapon and shield
                                    
                                    "type" will be replaced with the word (if type is "fire" in script then it will change this string type to fire)
                                    
                                    type_total_value = gems_getTotalCount(player, eleType, {SLOT_LEFT, SLOT_RIGHT})
                                    type_total_value1 = gems_getTotalCount(player, eleType, SLOT_RIGHT)
                                    type_total_value2 = gems_getTotalCount(player, eleType, SLOT_LEFT)
                                    type_total_value3 = gems_getTotalCount(player, eleType)
                                    type_total_count = gems_getTotalSlotCount(player, eleType, {SLOT_LEFT, SLOT_RIGHT})
                                    type_total_count1 = gems_getTotalSlotCount(player, eleType, SLOT_RIGHT)
                                    type_total_count2 = gems_getTotalSlotCount(player, eleType)
                                    type can be replaced with actual elemental type (ex: physical_total_value)
                                    default = the gem type
                                    
        failText = STR              if gem requires something to work in first place and player dont have it
        npcHint = {STR}             what npc smith will say about that gem
        --itemID = INT              table key
    }
]]

gems = {
    [2147] = {
        eleType = "fire",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {37, 40},
        shieldEffect = "Your type gem in weapon is increased by (type_total_value2/3*type_total_count2)%",
        failText = "You don't have gem in weapon",
        npcHint = {
            "Example how Fire Gem works on shield:",
            "If you have Energy Gem used on weapon then that gem effect will get better the more energy gems you have in other slots",
            "Third of energy gems is improves the gem effect % inside a weapon",
            "The bonus effet is multiplied by the amount of equipment slots use same type of gem",
            "If you have used energy gem in 3 different slots then third of the energy resistance from gems is tripled.",
            "Formula looks like that: weapon gem % + total same gem type/3 * amount of slots where same type gem is used",
            "Fire Gem on armor items give fire resistance. Can be stacked up to 3%",
            "Fire Gem on weapons increase fire spell damage. Can be stacked up to 10%",
        },
    },
    [9970] = {
        eleType = "ice",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {42, 48},
        shieldEffect = "(randomtype2_total_value3*2)% chance to summon randomtype2 elemental to fight on your side",
        npcHint = {
            "Example how Ice Gem works on shield:",
            "When you take any damage then you have chance to summon elemental",
            "The elemental type depends on what elemental gems you have applied to your gear.",
            "The chance depends on how much elemental gems times 2, you have for this elemental type.",
            "If you have death gem in 3 different slot (except weapon) and all of them give 3% resistance then you have 18% chance to summon death elemental every time you take a hit.",
            "Ice Gem on armor items give ice resistance. Can be stacked up to 3%",
            "Ice Gem on weapons increase ice spell damage. Can be stacked up to 10%",
        },
    },
    [2150] = {
        eleType = "death",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {50, 18},
        shieldEffect = "When you cast a spell you have (earth_total_value3*10)% Chance to deal ((fire_total_value3+ice_total_value3)*30) spectrum damage to (physical_total_value3/2) different random positions near you",
        npcHint = {
            "Example how Death Gem works on shield:",
            "Every time you cast a spell you have total earth gem % times 10 chance to proc this effect:",
            "Deal total of (fire gem + ice gem)% times 30 spectral damage to random positions around you",
            "the amount of positions depends on this result: total physical gem % / 2 ",
            "Death Gem on armor items give death resistance. Can be stacked up to 3%",
            "Death Gem on weapons increase death spell damage. Can be stacked up to 10%",
        },
    },
    [2146] = {
        eleType = "energy",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {12, 2},
        shieldEffect = "Increases your spectral damage by (fire_total_value3 + ice_total_value3 + energy_total_value3 + death_total_value3 + earth_total_value3 + physical_total_value3)%",
        failText = "You don't have 5 different elemental gems in rest of your items",
        npcHint = {
            "Example how Energy Gem works on shield:",
            "If you have 5 different elemental gems in your gear (except shield) your spectral hit will deal extra % damage of total gems",
            "Energy Gem on armor items give energy resistance. Can be stacked up to 3%",
            "Energy Gem on weapons increase energy spell damage. Can be stacked up to 10%",
        },
    },
    [2149] = {
        eleType = "earth",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {4, 21},
        shieldEffect = "Heal effects on you are increased by (earth_total_value3*2)%",
        npcHint = {
            "Example how Earth Gem works on shield:",
            "Every time you get healed the heal amount is increased.",
            "The Extra amount is % from original heal amount",
            "The percent is total earth resistance gems % times 2",
            "Earth Gem on armor items give earth resistance. Can be stacked up to 3%",
            "Earth Gem on weapons increase earth spell damage. Can be stacked up to 10%",
        },
    },
    [8305] = {
        eleType = "physical",
        armorMax = 3,
        weaponMax = 10,
        ME_effect = {39, 5},
        shieldEffect = "randomtype2 resistance gems in gear are buffed by (randomtype2_total_count2*20)%",
        npcHint = {
            "Example how Physical Gem works on shield:",
            "All your gem resitances are incrased by 20% for each same type gem used in any slot.",
            "Physical Gem on armor items give physical resistance. Can be stacked up to 3%",
            "Physical Gem on weapons increase physical spell damage. Can be stacked up to 10%",
        },
    }
}

local feature_gems = {
    startUpFunc = "gems_startUp",
    IDItems = {}
}

for gemID, t in pairs(gems) do
    feature_gems.IDItems[gemID] = {funcStr = "gems_onUse"}
end

centralSystem_registerTable(feature_gems)