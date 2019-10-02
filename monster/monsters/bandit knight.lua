local monster_banditKnight = {
    monsterSpells = {
        ["bandit knight"] = {
            "heal: cd=10000, p=4",
            "damage: cd=1000, d=30-90",
            "damage: cd=3000, d=100-200, c=10",
            finalDamage = 3,
        },
    },
    monsters = {
        ["bandit knight"] = {
            name = "Bandit Knight",
            reputationPoints = 2,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.deerTaskOnce] = 1, [SV.wolfTaskOnce] = 1, [SV.boarTaskOnce] = 1, [SV.bearTaskOnce] = 1},
                answer = {"Peeter told me he needs some help with Bandits, you can go deal with them."},
                killsRequired = 9,
                storageID = SV.banditKnightTask,
                storageID2 = SV.banditKnightTaskOnce,
                skillPoints = 1,
                location = "west Bandit mountain",
                reputation = 11,
            },
        },
    },
    monsterResistance = {
        ["bandit knight"] = {
            PHYSICAL = 20,
            ICE = -30,
            EARTH = -30,
            FIRE = -15,
            ENERGY = -20,
            DEATH = -40,
        },
    },
    monsterLoot = {
        ["bandit knight"] = {
            storage = SV.b_knight,
            items = {
                [ITEMID.other.spellScroll] = {chance = 2, itemAID = AID.spells.rubydef, knight = 2.5, firstTime = 3, partyBoost = "false"}, -- SpellScroll: rubydef
                [2380] = {chance = 2, knight = 5.5, firstTime = 4, partyBoost = "false"},               -- hand axe
                [2398] = {chance = 2, knight = 5.5, firstTime = 4, partyBoost = "false"},               -- mace
                [ITEMID.other.coin] = {chance = {35,15}, count = {1,3}},                                             -- coin
                [2674] = {chance = 12, count = 2, itemAID = AID.other.food},                            -- apple
                [ITEMID.herbs.iddunel] = {chance = 5, itemAID = 2067},                                                      -- herb: iddunel
                [2461] = {chance = 4},                                                                  -- leather helmet
                [2649] = {chance = 4},                                                                  -- leather legs
                [2467] = {chance = 4},                                                                  -- leather armor
                [2666] = {chance = 20, itemAID = AID.other.food},                                       -- meat
                [5909] = {chance = 25},                                                                 -- white cloth
                [2149] = {chance = 18},                                                                 -- Earth Gem
            }
        },
    },
}
centralSystem_registerTable(monster_banditKnight)