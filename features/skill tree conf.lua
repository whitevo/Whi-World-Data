local magicConditionT = {ID = SUB.ATTRIBUTES.skills.magicSkill, name = "magicSkill", attribute = "mL"}
local weaponConditionT = {ID = SUB.ATTRIBUTES.skills.weaponSkill, name = "weaponSkill", attribute = "wL"}
local distanceConditionT = {ID = SUB.ATTRIBUTES.skills.distanceSkill, name = "distanceSkill", attribute = "dL"}
local shieldingConditionT = {ID = SUB.ATTRIBUTES.skills.shieldingSkill, name = "shieldingSkill", attribute = "sL"}

-- each tier requires 10 points.
skillTreeTable = {
    [{mwID = MW.skillTree_magic, name = "Magic Powers", sv = SV.magicSkillpoints, conditionT = magicConditionT}] = {
        [1] = {
            ["furbish wand"] = {
                maxStack = 10,
                storage = SV.furbish_wand,
                value = 10,
                description = {"Spectrum damage is increased by (value*x)"},
            },
            ["mental power"] = {
                maxStack = 10,
                value = 2,
                storage = SV.mental_power,
                description = {
                    "Energy damage reduces target physical damage by (value*x)%.",
                    "debuff lasts 10 seconds on target.",
                }
            },
            ["liquid fire"] = {
                maxStack = 10,
                value = 4,
                storage = SV.liquid_fire,
                description = {
                    "Fire damage deals (value*x)% extra fire damage after every 2 seconds.",
                    "debuff lasts 10 seconds."
                }
            },
            ["green powder"] = {
                maxStack = 10,
                value = 10,
                storage = SV.green_powder,
                description = {"Earth damage deals (value*x)% more damage"}
            }
        },
        [2] = {
            ["thunderstruck"] = {
                maxStack = 10,
                value = 1,
                storage = SV.thunderstruck,
                description = {
                    "Physical damage deals extra energy damage based on formula:",
                    "weapon min dam + mL*6 + wL*10 / (11 - value*x) [result shows how much it divides from damage]",
                }
            },
            ["measuring mind"] = {
                maxStack = 10,
                value = 0.5,
                storage = SV.measuring_mind,
                description = {
                    "Ice type spells cost (value*x) less mana.",
                    "Fire type spells cost (value*x) more mana.",
                }
            },
            ["measuring soul"] = {
                maxStack = 10,
                value = 0.5,
                storage = SV.measuring_soul,
                description = {
                    "Death type spells cost (value*x) less mana.",
                    "Energy type spells cost (value*x) more mana.",
                }
            },
            ["spell power"] = {
                maxStack = 10,
                value = 0.3,
                storage = SV.spell_power,
                description = {"Increase spell radius by (value*x)"}
            },
        },
        [3] = {
            ["juicy magic"] = {
                maxStack = 10,
                value = 25,
                storage = SV.juicy_magic,
                description = {"Increase mana pool by (value*x)"}
            },
            ["wisdom"] = {
                maxStack = 8,
                value = 1,
                storage = SV.wisdom,
                description = { -- hardcoded in function wisdom()
                    "stack 1 removes 1 shielding skill level",
                    "stack 2 removes 1 weapon skill level",
                    "stack 3 removes 1 distance skill level",
                    "stack 4 gives 1 magic level",
                    "stack 5 removes 1 shielding skill level",
                    "stack 6 removes 1 weapon skill level",
                    "stack 7 removes 1 distance skill level",
                    "stack 8 gives 1 magic level",
                },
            },
            ["demon master"] = {
                maxStack = 10,
                value = 1,
                storage = SV.demon_master,
                description = {"(value*x)% damage you take is taken by your Imp instead"}
            },
            ["elemental powers"] = {
                maxStack = 10,
                value = 2,
                storage = SV.elemental_powers,
                description = {"non-spell elemental damage is increased by (value*x)%"},
            }
        }
    },

    [{mwID = MW.skillTree_weapon, name = "Weapon Powers", sv = SV.weaponSkillpoints, conditionT = weaponConditionT}] = {
        [1] = {
            ["sharpening weapon"] = {
                maxStack = 10,
                value = 2,
                storage = SV.sharpening_weapon,
                description = {"Swords/maces/axes deal (value*x)% damage more per hit"}
            },
            ["crushing strength"] = {
                maxStack = 10,
                value = 2,
                storage = SV.crushing_strength,
                description = {
                    "Physical weapon damage applies debuff on target:",
                    "Energy damage taken deals extra energy damage.",
                    "extra damage formula: (value*x*mL)",
                    "Debuff lasts 5 seconds on target.",
                    "Debuff re-apply cooldown 5 seconds.",
                }
            },
            ["tactical strike"] = {
                maxStack = 10,
                value = 4,
                storage = SV.tactical_strike,
                description = {"Your weapon hits have (value*x)% chance to increase armorUp duration by 1 sec."}
            },
        },
        [2] = {
            ["accuracy"] = {
                maxStack = 10,
                value = 2,
                storage = SV.accuracy,
                description = {"Gain (value*x)% critical chance."}
            },
            ["hit and run"] = {
                maxStack = 10,
                value = 3,
                storage = SV.hit_and_run,
                description = {
                    "Physical damage has (value*x)% chance to increase player speed by 25.",
                    "Buff lasts 5 seconds."
                }
            },
            ["weapon scabbard"] = {
                maxStack = 1,
                value = 40,
                storage = SV.weapon_scabbard,
                description = {"Increases player cap by (value*x)"}
            },
        },
        [3] = {
            ["elemental strike"] = {
                maxStack = 10,
                value = 2,
                storage = SV.elemental_strike,
                description = {"(value*x)% of physical damage is converted into elemental damage depending on which elemental resistance you have the most"}
            },
            ["lucky strike"] = {
                maxStack = 10,
                value = 10,
                storage = SV.lucky_strike,
                description = {"When critically hit, your next weapon hit maximum damage is increased by (value*x)%"}
            },
            ["undercut"] = {
                maxStack = 10,
                value = 10,
                storage = SV.undercut,
                description = {"When critically blocked, your next weapon hit minimum damage is increased by (value*x)%"}
            },
            
        }
    },
    [{mwID = MW.skillTree_distance, name = "Distance Powers", sv = SV.distanceSkillpoints, conditionT = distanceConditionT}] = {
        [1] = {
            ["power throw"] = {
                maxStack = 10,
                value = 10,
                storage = SV.power_throw,
                description = {"your spears have (value*x)% chance to deal damage to all characters in the way."}
            },
            ["sharpening projectile"] = {
                maxStack = 10,
                value = 4,
                storage = SV.sharpening_projectile,
                description = {"increases projectile damage by (value*x)%"}
            },
        },
        [2] = {
            ["steel jaws"] = {
                maxStack = 10,
                value = 6,
                storage = SV.steel_jaws,
                description = {"traps deal (value*x)% more damage"}
            },
            ["wounding"] = {
                maxStack = 10,
                value = 10,
                storage = SV.wounding,
                description = {"physical damage has (value*x)% chance to slow target speed by 30 for 5 seconds"}
            },
        },
        [3] = {
            ["archery"] = {
                maxStack = 10,
                value = 3,
                storage = SV.archery,
                description = {"(value*x)% chance to shoot 2 arrows at once"}
            },
            ["sharp shooter"] = {
                maxStack = 10,
                value = 3,
                storage = SV.sharp_shooter,
                description = {"increases critical hit chance by (value*x)%."}
            },
        }
    },
    
    [{mwID = MW.skillTree_shielding, name = "Shielding Powers", sv = SV.shieldingSkillpoints, conditionT = shieldingConditionT}] = {
        [1] = {
            ["bladed shield"] = {
                maxStack = 10,
                value = 1,
                storage = SV.bladed_shield,
                description = {"Increases equipped shield defense stat by (value*x)"}
            },
            ["bladed armor"] = {
                maxStack = 10,
                value = 2,
                storage = SV.bladed_armor,
                description = {"Increases player armor by (value*x)."}
            },
        },
        [2] = {
            ["power of love"] = {
                maxStack = 10,
                value = 2,
                storage = SV.power_of_love,
                description = {"Heal effects on you give (value*x)% more HP."}
            },
            ["mediation"] = {
                maxStack = 10,
                value = 2,
                storage = SV.mediation,
                description = {"Reduces !barrier, !armorup and !heal spell cost by (value*x)%."}
            },
        },
        [3] = {
            ["skilled"] = {
                maxStack = 8,
                value = 1,
                storage = SV.skilled,
                description = { -- hardcoded in function skilled()
                    "stack 1 removes 1 magic level",
                    "stack 2 removes 1 weapon skill level",
                    "stack 3 removes 1 distance skill level",
                    "stack 4 gives 1 shielding skill level",
                    "stack 5 removes 1 magic level",
                    "stack 6 removes 1 weapon skill level",
                    "stack 7 removes 1 distance skill level",
                    "stack 8 gives 1 shielding skill level",
                },
            },
            ["momentum"] = {
                maxStack = 8,
                value = 2,
                storage = SV.momentum,
                description = {"Gain (value*x)% critical chance."},
            },
        }
    }
}

local feature_skillTree = {
    startUpFunc = "skillTree_startUp",
    
    modalWindows = {
        [MW.skillTree] = {
            name = "Skill Tree",
            title = "skillTree_skillPointsLeftString", 
            choices = {
                [1] = "skillTree_magicChoice",
                [2] = "skillTree_weaponChoice",
                [3] = "skillTree_distanceChoice",
                [4] = "skillTree_shieldingChoice",
            },
            buttons = {[100] = "Choose",[101] = "Close", [102] = "Reset"},
            say = "checking skill tree",
            func = "skillTreeMW",
        },
        [MW.skillTree_magic] = {
            name = "Magic Powers",
            title = "skillTree_skillPointsLeftString",
            choices = "skillTree_branch_createChoices",
            buttons = "skillTree_createButtons",
            func = "skillTree_branchMW",
        },
        [MW.skillTree_weapon] = {
            name = "Weapon Powers",
            title = "skillTree_skillPointsLeftString",
            choices = "skillTree_branch_createChoices",
            buttons = "skillTree_createButtons",
            func = "skillTree_branchMW",
        },
        [MW.skillTree_distance] = {
            name = "Distance Powers",
            title = "skillTree_skillPointsLeftString",
            choices = "skillTree_branch_createChoices",
            buttons = "skillTree_createButtons",
            func = "skillTree_branchMW",
        },
        [MW.skillTree_shielding] = {
            name = "Shielding Powers",
            title = "skillTree_skillPointsLeftString",
            choices = "skillTree_branch_createChoices",
            buttons = "skillTree_createButtons",
            func = "skillTree_branchMW",
        },
        [MW.skillTree_talents] = {
            name = "skillTree_branch_MWName",
            title = "skillTree_skillPointsLeftString",
            choices = "skillTree_talents_createChoices",
            buttons = {[100] = "add", [101] = "back", [102] = "description", [103] = "remove 1"},
            func = "skillTree_talentMW",
        },
    }
}
centralSystem_registerTable(feature_skillTree)