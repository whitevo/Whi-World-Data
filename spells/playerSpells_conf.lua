-- function paramaters: player, amount, spellName, damType, manaCost, onlyCheck
--[[ Spell Config Guide
["spellName"] = {
    spellSV = INT,                  1 == spell learned | spellSV + 20000 is SV for os.time() when spell was casted
    func = STR,                     Function name for the spell creation
    level = INT or 1                Minimum level to be able to cast the spell 
    actionID = INT                  spell scroll AID
    mL = INT or 0                   Minimum magic level to be able to cast the spell
    spellType = STR,                Type of spell: used in as spellBook information
    word = STR,                     Words to cast the spell
    effectT = {STR},                Description of the effect of the spell in spellBook
    buffT = {{                  
        func = STR                  functionName with (parameters) | example: "criticalHeal(player, amount)" | onlyCheck RETURNS EXTRA, BONUS
        text = STR                  adds more information about spell bonuses inside effectT
        replace = INT,              effectT[INT] = text
        negative = false            if true then allows negative return values
    }},
    manaCost = INT/STR or 0         Amount of mana that the spell costs (INT for amount of mana, STRING for % of mana) 
    cooldown = INT or 1             How many seconds player has to wait before he can cast the spell again
    range = INT                     spell range
    improvement = INT               spell is upgradeable.
    magicDust = INT or 1            how much magic dust spell is worth
    
    shareCD = {INT},                Storage values of all the spells it shares cooldown with (it adds to cooldown)
    vocation = {STR} or "all"       lower case name of the vocation who can use spell
    channelDuration = INT           INT = caster cant move for channelDuration milliseconds
    
    formula = {                     function spells_getFormulas()
        [INT] = {                   returnValues position | return returnValues[1], returnValues[2], returnValues[3], returnValues[4]
            name = STR              formula name
            min = (STR),            
            max = (STR),            
            extraText = STR         string what appears behind formula calculation
            damage = false          if true then calculator adds additional damage modifiers
            extras = {
                [INT] = {           sequence in which order functions are excuted (important if damage is added with function)
                    func = STR      functionName with (parameters) | example: "criticalHeal(player, amount)" | onlyCheck = false
                    text = STR      adds more information about spell bonuses inside effectT
                    replace = INT   effectT[INT] = text
                    negative = false    if true then allows negative return values
                },
            },
        },
    },
                                    L = player level
                                    mL = magic level
                                    sL = shielding level
                                    dL = distance level
                                    wL = weapon level
                                    (EXAMPLES: "random formula: (L*10 + mL*10 + 50 / sL*2*dL)")
    
    
    slot = {                            
        [INT] = {                   INT = what is the number of slot it checks
            items = {INT, STR},     INT = itemID | STR = tableName what holds itemID's
            count = INT or 1        how much items has to be in that slot
            failText = STR,         text what appears if condition is not met | DEFAULT = "you are missing item"
            remove = false,         Is the item going to be removed?
        },
    },
    -- automatic
    spellName = STR                 it loads the spellNames to table too on startUp.
    spellID = INT
    shareCDStr = STR                list of spellnames with what spell shares cooldown with
}
]]
local AIDT = AID.spells

local function knightSpellT(spellName, damTypeStr)
local spellT = {
    func = spellName.."Spell",
    spellSV = SV[spellName],
    actionID = AIDT[spellName],
    level = 3,
    spellType = damTypeStr,
    word = "!"..spellName,
    magicDust = 3,
    effectT = {"Gives buff that lasts 5 seconds", "Increases "..damTypeStr.." resistance against first "..damTypeStr.." hit", "Heals 2 times the amount resisted"},
    buffT = {"supaky", "goddessArmor", "powerOfLove", "yashimaki", "ghatitkArmor", "ghatitkShield", "speedzyLegs", "criticalHeal"},
    manaCost = 5,
    cooldown = 5,
    formula = {
        [1] = {name = damTypeStr.." resistance", min = "(50 + mL*3 + sL - L - wL*2)", extraText = "%", extras = {"zvoidShield"}},
        [2] = {name = "heal cap", min = "(30 +  mL*4 + sL*8 - L - wL*5)"}, 
    },
    vocation = "knight",
}   
    return spellT
end

healSpells = {"heal", "mend"}
fireSpells = {}     -- {_, spellName}
iceSpells = {}      -- {_, spellName}
deathSpells = {}    -- {_, spellName}
energySpells = {}   -- {_, spellName}
-- spellScroll = 5958

spellBuffToAll = {"blessedHood_cast", "blessedTurban_cast", "blessedTurban_damage", "blessedIronHelmet_cast", "impBuff", "zvoidBoots", "arcaneBoots"}

spells = {
    -- tutorial spells are in mage folder
    ["electric shock"] = {
        func = "tutorial_spell1",
        spellSV = SV.tutorialSpell1,
        spellType = "energy",
        word = "!shock",
        effectT = {"Charges pillars diagonally from you."},
        cooldown = 10,
        vocation = "none",
    },
    ["holy strike"] = {
        func = "tutorial_spell2",
        spellSV = SV.tutorialSpell2,
        spellType = "holy",
        word = "!godhammer",
        effectT = {"Charges pillar front of you."},
        cooldown = 10,
        vocation = "none",
    },
    ["deadly longshot"] = {
        func = "tutorial_spell3",
        spellSV = SV.tutorialSpell3,
        spellType = "death",
        word = "!longshot",
        effectT = {"Charges pillar 4 tiles away in 1 direction."},
        cooldown = 10,
        vocation = "none",
    },

--________________--
----HUNTER SPELLS---
--================--
    ["taunt"] = {
        func = "tauntSpell",
        spellSV = SV.taunt,
        actionID = AIDT.taunt,
        spellType = "physical",
        level = 4,
        word = "!taunt",
        magicDust = 3,
        effectT = {
            "forces target to focus you.",
            "If monster, it can not change target for some time.",
        },
        buffT = {"chamakLegs", "namiBootsBuff_taunt"},
        manaCost = 5,
        cooldown = 15,
        vocation = "hunter",
        formula = {
            [1] = {
                name = "duration",
                min = "(3 + sL*2 - L*0.5)",
                extraText = " seconds"
            },
        },
    },
    ["volley"] = {
        func = "volleySpell",
        spellSV = SV.volley,
        actionID = AIDT.volley,
        spellType = "physical",
        word = "!volley",
        magicDust = 4,
        level = 3,
        effectT = {
            "requires 10 arrows",
            "Shoots 10 arrows at once",
            "projectile break chance increased by 10%",
        },
        buffT = {
            "hit_and_run", "crushing_strength", "elemental_strike", "wounding", "thunderstruck", "snaipaHelmetBreak", "quiverBreakChance", "hunterPotionBuff", "hunterPotionNerf",
            "knightPotionBuff", "knightPotionNerf", "namiBootsBuff_volley",
        },
        manaCost = 40,
        cooldown = 7,
        vocation = "hunter",
        formula = {
            [1] = {
                name = "damage",
                func = "getWeaponBaseDamage",
                damage = true,
                extras = {"fireQuiverDamage", "snaipaHelmet", "sharpening_projectile"},
            }
        },
        slot = {
            [SLOT_AMMO] = {
                items = {2544, 2545 ,2546, 7364, 7365},
                count = 10,
                failText = "Not enough arrows in ammo slot",
            },
            [SLOT_LEFT] = {
                items = {2456},
                failText = "Equip Bow first.",
            },
        },
    },
    ["fakedeath"] = {
        func = "fakedeathSpell",
        spellSV = SV.fakedeath,
        actionID = AIDT.fakedeath,
        spellType = "physical",
        word = "!fakedeath",
        magicDust = 5,
        effectT = {
            "Monsters will untarget you.",
            "Reduces all non damage over time damage taken to 0.",
        },
        buffT = {"bloodyShirt"},
        manaCost = 30,
        cooldown = 20,
        formula = {
            [1] = {
                name = "duration",
                min = "(5 + sL*3 - L*0.5 - dL)",
                extraText = " seconds"
            },
        },
        vocation = "hunter",
    },
    ["trap"] = {
        func = "trapSpell",
        spellSV = SV.trap,
        actionID = AIDT.trap,
        spellType = "physical",
        word = "!trap",
        magicDust = 1,
        effectT = {
            "places down trap that last 25 seconds.",
            "target who steps on it takes damage and is slowed for 5sec.",
            "Stepping on your own trap refreshes cooldown.",
        },
        buffT = {"traptrixCoat", "wounding", "hit_and_run", "thunderstruck", "traptrixQuiver", "hunterPotionBuff", "hunterPotionNerf", "elemental_strike"},
        manaCost = 25,
        cooldown = 8,
        formula = {
            [1] = {
                name = "damage",
                min = "(150 + L*15 + sL*30 - mL*5 - wL*5 - dL*6)",
                damage = true,
                extras = {"steel_jaws"},
            },
            [2] = {
                name = "slow amount",
                min = "(50 + mL*4 + sL*2 - wL*6 - L*2 - dL*3)",
            },
            [3] = {
                name = "reduce cooldown",
                min = "(dL*0.5)",
                dontShow = true,
            },
        },
        vocation = "hunter",
    },
    ["poison"] = {
        func = "poisonSpell",
        spellSV = SV.poison,
        actionID = AIDT.poison,
        spellType = "earth",
        word = "!poison",
        magicDust = 2,
        effectT = {
            "Poisons weapon, which debuff targets every hit.",
            "Debuffed targets take earth damage for each poison stack (max 20)",
            "for each stack the poison deals less damage",
        },
        buffT = {"green_powder"},
        manaCost = 40,
        cooldown = 10,
        formula = {
            [1] = {
                name = "earth damage",
                min = "(10 + L + mL*3 + dL*2 - sL*2 - wL)",
                extraText = " (initial stack damage)",
                damage = true,
                extras = {
                    {func = "hunterPoison_earlyDamage(player)", text = "Bonus EXTRA damage added for weak magic users"},
                    "elemental_powers",
                }
            },
            [2] = {
                name = "buff duration",
                min = "(60 + L + mL*2 + dL - sL*2 - wL)",
                extraText = " seconds"
            },
            [3] = {
                name = "debuff duration",
                min = "(5 + L + mL - sL*2 - wL*2)",
                extraText = " seconds"
            },
        },
        vocation = "hunter",
    },
--________________--
----KNIGHT SPELLS---
--================--
    ["armorup"] = {
        func = "armorUpSpell",
        spellSV = SV.armorup,
        actionID = AIDT.armorup,
        spellType = "physical",
        word = "!armorup",
        magicDust = 1,
        effectT = {"gives temporary armor and movement speed on breakdown"},
        buffT = {"mediation", "stoneShield", "stoneArmor", "stoneLegs"},
        manaCost = 25,
        cooldown = 12,
        formula = {
            [1] = {
                name = "extra armor",
                min = "(50 + sL*5 - L*2 - mL*2 - wL*3 - dL)",
                extras = {{func = "armorup_noobProtection(player)", text = "You get extra EXTRA more armor for early game"}}
            },
            [2] = {
                name = "duration",
                min = "(7 + mL*0.5 + sL*0.5 - wL*0.5 - L*0.2)",
                extraText = " seconds",
            },
        },
        vocation = "knight",
    },
    ["strike"] = {
        func = "strikeSpell",
        spellSV = SV.strike,
        actionID = AIDT.strike,
        level = 2,
        spellType = "physical",
        word = "!strike",
        effectT = {"Deals damage front of you", "If target is nearby then deals damage to target"},
        buffT = {"spell_power", "hit_and_run", "spellCasterPotion", "warriorHelmet", "wounding", "thunderstruck", "hunterPotionBuff", "hunterPotionNerf", "elemental_strike"},
        magicDust = 2,
        manaCost = 6,
        cooldown = 3,
        range = 1,
        formula = {
            [1] = {
                name = "physical damage",
                damage = true,
                min = "(75 + L*10 + wL*25 + mL*5 - sL*10)",
                max = "(85 + L*20 + wL*30 + mL*10 - sL*10)",
            },
        },
        vocation = "knight",
    },
    ["throwaxe"] = {
        func = "throwaxeSpell",
        spellSV = SV.throwaxe,
        actionID = AIDT.throwaxe,
        level = 4,
        spellType = "physical",
        word = "!throwaxe",
        magicDust = 5,
        effectT = {
            "deals damage to target and slows for 5 sec",
            "This spell is also considered as weapon damage.",
        },
        buffT = {
            "hit_and_run", "spellCasterPotion", "crushing_strength", "tactical_strike", "wounding", "leatherVest", "thunderstruck", "hunterPotionBuff", "hunterPotionNerf",
            "knightPotionBuff", "knightPotionNerf", "elemental_strike",
        },
        manaCost = 7,
        cooldown = 3,
        formula = {
            [1] = {
                name = "physical damage",
                damage = true,
                min = "(200 + dL*15 - L*5 - mL*3 - sL*4)",
                max = "(250 + dL*22 - L*5 - mL*4 - sL*6)",
                extras = {"sharpening_weapon"},
            },
            [2] = {
                name = "slow",
                min = "(20 + L*mL*2 + sL - L*2 - L*wL)"
            },
        },
        vocation = "knight",
    },
    ["rubydef"] = knightSpellT("rubydef", "fire"),
    ["onyxdef"] = knightSpellT("onyxdef", "death"),
    ["opaldef"] = knightSpellT("opaldef", "physical"),
    ["sapphdef"] = knightSpellT("sapphdef", "ice"),
--________________--
----DRUID SPELLS----
--================--
    ["innervate"] = {
        func = "innervateSpell",
        spellSV = SV.innervate,
        actionID = AIDT.innervate,
        level = 4,
        spellType = "earth",
        word = "!innervate",
        magicDust = 5,
        effectT = {
            "passive: healing spells have % chance to critically heal",
            "while spell is under cooldown, passive doesn't work",
            "Regenerates back 50% of max mana over 60 seconds.",
        },
        buffT = {"phadraRobe"},
        manaCost = 100,
        cooldown = 240,
        formula = {
            [1] = {
                name = "critical heal chance",
                min = "(1 + L*0.5 + mL*2 - sL - wL*2 - dL*2)",
                extraText = "%",
            },
        },
        vocation = "druid",
    },
    ["heal"] = {
        func = "healSpell",
        spellSV = SV.heal,
        actionID = AIDT.heal,
        level = 1,
        magicDust = 1,
        spellType = "holy",
        word = "!heal",
        effectT = {"heals caster"},
        buffT = {"powerOfLove", "yashimaki", "goddessArmor", "speedzyLegs", "criticalHeal"},
        manaCost = 30,
        cooldown = 4,
        formula = {
            [1] = {
                name = "heal amount",
                min = "(50 + L*4 + mL + sL*4 - wL*5)",
                max = "(60 + L*7 + mL*3 + sL*8 - wL*5)",
            },
        },
        shareCD = SV.mend,
        vocation = "druid",
    },
    ["mend"] = {
        func = "mendSpell",
        spellSV = SV.mend,
        actionID = AIDT.mend,
        level = 4,
        magicDust = 6,
        spellType = "holy",
        word = "!mend",
        effectT = {"Heals monsters, npcs and players."},
        buffT = {"powerOfLove", "yashimaki", "goddessArmor", "speedzyLegs", "criticalHeal"},
        improvement = 2,
        manaCost = 10,
        cooldown = 2,
        formula = {
            [1] = {
                name = "heal amount",
                min = "(L*4 + mL*2 + sL*5 - wL*7)",
                max = "(L*5 + mL*3 + sL*6 - wL*8)",
            },
        },
        shareCD = SV.heal,
        vocation = "druid",
    },
    ["heat"] = {
        func = "heatSpell",
        spellSV = SV.heat,
        actionID = AIDT.heat,
        level = 2,
        magicDust = 2,
        spellType = "fire",
        word = "!heat",
        effectT = {"Deals Fire damage"},
        buffT = {"atsuiKori", "spellCasterPotion", "liquid_fire", "measuring_mind", "spell_power", "namiBootsBuff_heat"},
        manaCost = 12,
        cooldown = 3,
        range = 4,
        formula = {
            [1] = {
                name = "fire damage",
                damage = true,
                min = "(100 + L*5 + mL*12 - wL*sL)",
                max = "(100 + L*7 + mL*17 - wL*sL)",
                extras = {"thunderBook"},
            },
        },
        shareCD = SV.shiver,
        vocation = "druid",
    },
    ["shiver"] = {
        func = "shiverSpell",
        spellSV = SV.shiver,
        actionID = AIDT.shiver,
        level = 3,
        magicDust = 3,
        spellType = "ice",
        word = "!shiver",
        effectT = {"Deals Ice damage"},
        buffT = {"atsuiKori", "spellCasterPotion", "frizenKilt", "measuring_mind", "spell_power", "namiBootsBuff_shiver"},
        manaCost = 12,
        cooldown = 3,
        range = 4,
        formula = {
            [1] = {
                name = "ice damage",
                damage = true,
                min = "(100 + L*5 + mL*12 - wL*sL)",
                max = "(100 + L*7 + mL*17 - wL*sL)",
                extras = {"thunderBook"},
            },
        },
        shareCD = SV.heat,
        vocation = "druid",
    },
    ["buff"] = {
        func = "buffSpell",
        spellSV = SV.buff,
        actionID = AIDT.buff,
        level = 3,
        magicDust = 4,
        spellType = "earth",
        word = "!buff",
        effectT = {"caster gets overall damage reduction buff for 1 hour"},
        buffT = {"gribitShield", "gribitLegs"},
        manaCost = "100%",
        cooldown = 1,
        formula = {
            [1] = {
                name = "buff amount",
                min = "(L*0.2 + mL*0.1 + sL*0.6 - wL*0.4)",
                extraText = "%",
                extras = {"bianhurenShield"},
            },
            [2] = {
                name = "buff duration",
                min = "(60*60)",
                extraText = " seconds",
            }
        },
        vocation = "druid",
    },
--________________--
-----MAGE SPELLS----
--================--
    ["imp"] = {
        func = "impSpell",
        spellSV = SV.imp,
        actionID = AIDT.imp,
        level = 4,
        magicDust = 4,
        spellType = "death",
        word = "!imp",
        effectT = {"Summons Imp", "Imp increases your spell damage by 10%"},
        buffT = {"demon_master", "demonicShield", "demonicRobe", "demonicLegs"},
        manaCost = 100,
        cooldown = 60,
        vocation = "mage",
    },
    ["spark"] = {
        func = "sparkSpell",
        spellSV = SV.spark,
        actionID = AIDT.spark,
        level = 1,
        magicDust = 1,
        spellType = "energy",
        word = "!spark",
        effectT = {
            "Deals energy damage.",
            "Damage is increased by 10% the further it reaches",
        },
        buffT = {"spell_power", "measuring_soul", "spellCasterPotion", "mental_power"},
        manaCost = 10,
        cooldown = 3,
        formula = {
            [1] = {
                name = "energy damage",
                damage = true,
                min = "(75 + L*5 + mL*17 - wL*34 - sL*6)",
                max = "(75 + L*10 + mL*25 - wL*45 - sL*9)",
                extras = {{func = "spark_minDamage(amount)", text = "Early game damage increased by EXTRA"}, "thunderBook"},
            },
        },
        improvement = 1,
        shareCD = SV.death,
        vocation = "mage",
    },
    ["death"] = {
        func = "deathSpell",
        spellSV = SV.death,
        actionID = AIDT.death,
        level = 3,
        magicDust = 3,
        spellType = "death",
        word = "!death",
        effectT = {
            "Deals death damage.",
            "Damage is increased by 10% the further it reaches",
        },
        buffT = {"spell_power", "measuring_soul", "spellCasterPotion", "amanitaHat"},
        manaCost = 10,
        cooldown = 3,
        formula = {
            [1] = {
                name = "death damage",
                damage = true,
                min = "(75 + L*5 + mL*17 - wL*7 - sL*4)",
                max = "(75 + L*10 + mL*25 - wL*11 - sL*6)",
                extras = {"thunderBook", "kamikazeMantle"},
            },
        },
        improvement = 1,
        shareCD = SV.spark,
        vocation = "mage",
    },
    ["barrier"] = {
        func = "barrierSpell",
        spellSV = SV.barrier,
        actionID = AIDT.barrier,
        level = 2,
        magicDust = 2,
        spellType = "energy",
        word = "!barrier",
        effectT = {"Absorbs Damage until barrier is over."},
        buffT = {"arogjaHat", "mediation", "kamikazePants"},
        manaCost = 80,
        cooldown = 20,
        formula = {
            [1] = {
                name = "barrier",
                min = "(200 + L*5 + mL*2 + sL*15 - wL*5)",
                extras = {"kaijuWall"},
            },
        },
        vocation = "mage",
    },
    ["dispel"] = {
        func = "dispelSpell",
        spellSV = SV.dispel,
        actionID = AIDT.dispel,
        level = 4,
        magicDust = 5,
        spellType = "energy",
        word = "!dispel",
        effectT = {
            "if target is enemy, it removes buffs.",
            "if target is friendly, it removes debuffs.",
        },
        manaCost = 30,
        cooldown = 2,
        formula = {
            [1] = {
                name = "dispel chance",
                min = "(100 + mL*3 + sL*10 - wL*6 - L*5)",
                extraText = "%"
            },
        },
        vocation = "mage",
    },
}
