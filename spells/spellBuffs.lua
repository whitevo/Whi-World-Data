--[[ spellBuffs guide
    spellBuff = {               registers table in spellBuffs which is used for spellBook calculations
        func = STR              functionName with params: Example: "green_powderDamage(player, amount, damType, onlyCheck)"
                                amount == number, usually formula calculation
        text = STR              when function RETURNS true or value what is > 0 then RETURNS the text
                                EXTRA is replaced with RETURN value from function
                                BONUS is replaced with secondary RETURN value
        replace = INT           overwrites the effect text to specific table position, effecT[INT]. Usually used to overwrite default spell information
        negative = false        if true then allows negative return values from function
    }
]]
spellBuffs = {
    -- talents
    ["green_powder"] = {
        func = "green_powderDamage(player, amount, damType, onlyCheck)",
        text = "Increases earth damage by EXTRA% (Green powder talent)",
    },
    ["mental_power"] = {
        func = "mental_power(player, nil, damType, origin, onlyCheck)",
        text = "Energy damage reduces target physical damage by EXTRA% for 10 sec (Mental power talent)",
    },
    ["hit_and_run"] = {
        func = "hit_and_runFunc(player, damType, onlyCheck)",
        text = "EXTRA% chance to increase player speed by 25 for 5 seconds (Hit and run talent)",
    },
    ["thunderstruck"] = {
        func = "thunderstruck(player, nil, damType, onlyCheck)",
        text = "Deals additona EXTRA energy damage (Thunderstruck talent)",
    },
    ["crushing_strength"] = {
        func = "crushing_strength(player, creature, damType, origin, onlyCheck)",
        text = "Applies debuff which will increases energy damage by EXTRA (Crushing strength talent)",
    },
    ["tactical_strike"] = {
        func = "tactical_strike(player, origin, onlyCheck)",
        text = "EXTRA% chance to increase armorup duration by 1 second (Tactica strike talent)",
    },
    ["liquid_fire"] = {
        func = "liquid_fire(player, nil, amount, damType, nil, onlyCheck)",
        text = "Deals additional EXTRA% fire damage every 2 seconds for 10 seconds (Liquid fire talent)",
    },
    ["demon_master"] = {
        func = "demon_master(player, value, onlyCheck)",
        text = "EXTRA% damage is taken by your Imp instead (Demon master talent)",
    },
    ["spell_power"] = {
        func = "spell_power(player)",
        text = "Spell is improved by EXTRA (Spell power talent)",
    },
    ["measuring_mind"] = {
        func = "measuring_mind(player, spellName)",
        text = "Mana cost is changed by EXTRA (Measuring mind talent)",
        negative = true,
    },
    ["measuring_soul"] = {
        func = "measuring_soul(player, spellName)",
        text = "Mana cost is changed by EXTRA (Measuring soul talent)",
        negative = true,
    },
    ["elemental_strike"] = {
        func = "elemental_strikeAmount(player, amount, damType, onlyCheck)",
        text = "converts EXTRA% physical damage to BONUS damage (Elemental strike talent)",
    },
    ["mediation"] = {
        func = "mediation(player, spellName, manaCost, onlyCheck)",
        text = "Mana cost is reduced by EXTRA (Mediation talent)",
    },
    ["wounding"] = {
        func = "wounding(player, nil, damType, onlyCheck)",
        text = "EXTRA% chance to slow by 25 for 5 seconds (Wounding talent)",
    },
    ["steel_jaws"] = {
        func = "steel_jaws(player, amount)",
        text = "EXTRA physical damage comes from Steel jaws talent",
    },
    ["sharpening_weapon"] = {
        func = "sharpening_weapon(player, amount)",
        text = "EXTRA physical damage comes from Sharpening weapon talent",
    },
    ["sharpening_projectile"] = {
        func = "sharpening_projectile(player, amount)",
        text = "EXTRA physical damage comes from Sharpening projectile talent",
    },
    ["elemental_powers"] = {
        func = "elemental_powers(player, amount, damType)",
        text = "Debuff damage is increased by EXTRA (Elemental powers talent)",
    },
    ["powerOfLove"] = {
        func = "power_of_love(player, amount, onlyCheck)",
        text = "You get EXTRA% more health when healing yourself (Power of love talent)",
    },
    -- items
    ["quiverBreakChance"] = {
        func = "quiverBreakChance(player, onlyCheck)",
        text = "Ammo break chance is reduced by EXTRA% (quiver)",
    },
    -- other
    ["spellCasterPotion"] = {
        func = "potions_spellCaster_heal(player, onlyCheck)",
        text = "Heal EXTRA hp each time your damage spell hits (Spell caster potion)",
    },
    ["hunterPotionBuff"] = {
        func = "potions_hunter_damage(player, target, damType, onlyCheck)",
        text = "Deals extra EXTRA earth damage for 5 seconds. Stacks 10 times (Hunter potion)",
    },
    ["hunterPotionNerf"] = {
        func = "potions_hunter_slow(player, target, damType, onlyCheck)",
        text = "Loose EXTRA speed for 10sec. Stacks 10 times (Hunter potion)",
    },
    ["knightPotionBuff"] = {
        func = "potions_knight_buff(player, potionT, onlyValue, removePotion, onlyCheck)",
        text = "You deal extra EXTRA fire damage on each hit (Knight potion)",
    },
    ["knightPotionNerf"] = {
        func = "potions_knight_nerf(player, potionT, onlyValue, removePotion, onlyCheck)",
        text = "You loose EXTRA armor on each hit for 8 seconds (Knight potion)",
    },
    ["criticalHeal"] = {
        func = "criticalHeal(player, amount, onlyCheck)",
        text = "EXTRA% chance to double the heal amount (critical heal attribute)",
    },
    ["impBuff"] = {
        func = "impBuff(player, amount)",
        text = "Your Imp increased your damage by EXTRA%",
    },
}