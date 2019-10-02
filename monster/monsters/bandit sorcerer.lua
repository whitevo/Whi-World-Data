local monster_banditSorcerer = {
    monsterSpells = {
        ["bandit sorcerer"] = {
            "bandit sorcerer poison debuff",
            "bandit sorcerer fireball",
            "bandit sorcerer slow debuff",
            "heal: cd=15000, p=5",
            "damage: cd=3000, d=20-30, r=7, t=FIRE, fe=11",
            finalDamage = 10,
        },
    },
    monsters = {
        ["bandit sorcerer"] = {
            name = "Bandit Sorcerer",
            reputationPoints = 5,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.bandithunterTaskOnce] = 1, [SV.banditMageTaskOnce] = 1, [SV.banditKnightTaskOnce] = 1, [SV.banditDruidTaskOnce] = 1},
                killsRequired = 12,
                storageID = SV.banditSorcererTask,
                storageID2 = SV.banditSorcererTaskOnce,
                skillPoints = 1,
                location = "Hehemi town",
                reputation = 12,
            },
        },
    },
    monsterResistance = {
        ["bandit sorcerer"] = {
            PHYSICAL = -25,
            DEATH = 20,
            EARTH = -30,
        },
    },
    monsterLoot = {
        ["bandit sorcerer"] = {
            storage = SV.b_sorcerer,
            items = {
                [5958] = {chance = 2, itemAID = AID.spells.dispel, mage = 2.5, firstTime = 3, partyBoost = "false"},   -- SpellScroll: dispel
                [16103] = {chance = 2, mage = 5.5, firstTime = 4, partyBoost = "false"},            -- shikara nankan
                [12429] = {chance = 2, mage = 5.5, firstTime = 4, partyBoost = "false", unique = true},            -- precision robe
                [ITEMID.other.coin] = {chance = {40,20,10}, count = {1,3,2}},                                    -- coin
                [13881] = {chance = 7, itemAID = AID.herbs.mobberel},                                   -- herb: mobberel
                [2674] = {chance = 15, count = 3, itemAID = AID.other.food},                        -- apple
                [2422] = {chance = 12, itemAID = AID.other.tool, itemText = "charges(2)"},              -- iron hammer
                [2263] = {chance = 4, mage = 6},                                                    -- death stone
                [2271] = {chance = 4, mage = 6},                                                    -- energy stone
                [5914] = {chance = 25},                                                             -- yellow cloth
                [2147] = {chance = 22},                                                             -- fire Gem
                [2666] = {chance = 20, itemAID = AID.other.food},                                   -- meat
            }
        },
    },
}
centralSystem_registerTable(monster_banditSorcerer)

customSpells["bandit sorcerer poison debuff"] = {
    cooldown = 20000,
    firstCastCD = -17000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy"},
    },
    flyingEffect = {effect = 40},
    customFeature = {func = "banditSorcerer_poisonDebuff"},
}

function banditSorcerer_poisonDebuff(casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do onHitDebuff_registerDamage(targetID, PHYSICAL, EARTH, 25, 12, 17, O_monster_procs, "banditPoison") end
end

customSpells["bandit sorcerer fireball"] = {
    cooldown = 9000,
    targetConfig = {"cTarget"},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    damage = {
        delay = 2000,
        minDam = 225,
        maxDam = 300,
        minScale = 25,
        maxScale = 44,
        damType = FIRE,
        effectOnHit = 6,
        effectOnMiss = 5,
        
        damage = {
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {endPoint = "endPos", areaConfig = {area = areas["diagonal_1x1_0"]}}
            },
            minDam = 150,
            maxDam = 220,
            minScale = 20,
            maxScale = 25,
            damType = FIRE,
            effectOnHit = 6,
            effectOnMiss = 5,
            flyingEffect = {effect = 4},
        },
        flyingEffect = {effect = 4},
    },
    magicEffect = {effect = {8,8}, effectInterval = 500}
}

customSpells["bandit sorcerer slow debuff"] = {
    cooldown = 20000,
    firstCastCD = -15000,
    targetConfig = {"cTarget"},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    flyingEffect = {effect = 30},
    conditions = {onTargets = true, conditionT = {["monsterSlow"] = {paramT = {["speed"] = -30}, duration = 10000}}},
}