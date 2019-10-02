local monster_banditDruid = {
    monsterSpells = {
        ["bandit druid"] = {
            "bandit druid summon",
            "bandit druid heal",
            "damage: cd=2000, d=5-20, r=4, t=FIRE, fe=4",
            finalDamage = 2,
        },
    },
    monsters = {
        ["bandit druid"] = {
            name = "Bandit Druid",
            reputationPoints = 2,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.deerTaskOnce] = 1, [SV.wolfTaskOnce] = 1, [SV.boarTaskOnce] = 1, [SV.bearTaskOnce] = 1},
                answer = {"Peeter told me he needs some help with Bandits, you can go deal with them."},
                killsRequired = 9,
                storageID = SV.banditDruidTask,
                storageID2 = SV.banditDruidTaskOnce,
                skillPoints = 1,
                location = "west Bandit mountain",
                reputation = 11,
            },
        },
    },
    monsterResistance = {
        ["bandit druid"] = {
            PHYSICAL = -35,
            ICE = -30,
            EARTH = -30,
            FIRE = 10,
            ENERGY = -25,
            DEATH = -50,
        },
    },
    monsterLoot = {
        ["bandit druid"] = {
            storage = SV.b_druid,
            items = {
                [ITEMID.other.spellScroll] = {chance = 2, itemAID = AID.spells.shiver, druid = 2.5, firstTime = 3, partyBoost = "false"},  -- SpellScroll: shiver
                [2183] = {chance = 2, druid = 5.5, firstTime = 4, partyBoost = "false"},                -- atsui kori wand
                [ITEMID.other.coin] = {chance = {35,15}, count = {1,3}},                                             -- coin
                [2674] = {chance = 12, count = 2, itemAID = AID.other.food},                            -- apple
                [ITEMID.herbs.iddunel] = {chance = 5, itemAID = 2067},                                                      -- herb: iddunel
                [2461] = {chance = 4},                                                                  -- leather helmet
                [2649] = {chance = 4},                                                                  -- leather legs
                [2467] = {chance = 4},                                                                  -- leather armor
                [2666] = {chance = 20, itemAID = AID.other.food},                                       -- meat
                [5911] = {chance = 25},                                                                 -- red cloth
                [2147] = {chance = 18},                                                                 -- fire Gem
            }
        },
    },
}
centralSystem_registerTable(monster_banditDruid)

customSpells["bandit druid heal"] = {
    cooldown = 9000,
    targetConfig = {
        [{"caster","friend"}] = {},
    },
    position = {startPosT = {startPoint = "caster"}},
	heal = {onTargets = true, effect = 15, minHeal = 350}
}

customSpells["bandit druid summon"] = {
    cooldown = 12000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        summons = {["squirrel"] = {amount = 3}},
        maxSummons = 3,
        
        say = {
            hook = true,
            onTargets = true,
            msg = {"My minions, go annoy!", "huehue"},
            msgType = ORANGE,
        },
        
    }
}
