local monster_banditMage = {
    monsterSpells = {
        ["bandit mage"] ={
            "heal: cd=8000, p=4",
            "bandit mage magic wall",
            "damage: cd=1500, d=20-35, r=2, t=ENERGY",
            finalDamage = 3,
        },
    },
    monsters = {
        ["bandit mage"] = {
            name = "Bandit Mage",
            reputationPoints = 2,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.deerTaskOnce] = 1, [SV.wolfTaskOnce] = 1, [SV.boarTaskOnce] = 1, [SV.bearTaskOnce] = 1},
                answer = {"Peeter told me he needs some help with Bandits, you can go deal with them."},
                killsRequired = 9,
                storageID = SV.banditMageTask,
                storageID2 = SV.banditMageTaskOnce,
                skillPoints = 1,
                location = "west Bandit mountain",
                reputation = 11,
            },
        },
    },
    monsterResistance = {
        ["bandit mage"] = {
            PHYSICAL = -30,
            ICE = -20,
            FIRE = 10,
            ENERGY = 20,
            DEATH = -40,
            EARTH = -40,
        },
    },
    monsterLoot = {
        ["bandit mage"] = {
            storage = SV.b_mage,
            items = {
                [ITEMID.other.spellScroll] = {chance = 2, itemAID = AID.spells.death, mage = 2.5, firstTime = 3, partyBoost = "false"},   -- SpellScroll: death
                [2190] = {chance = 2, mage = 5.5, firstTime = 4, partyBoost = "false"},     -- Kaiju Wall wand
                [ITEMID.other.coin] = {chance = {35,15}, count = {1,3}},                                 -- coin
                [ITEMID.herbs.iddunel] = {chance = 5, itemAID = 2067},                                          -- herb: iddunel
                [2674] = {chance = 12, count = 2, itemAID = AID.other.food},                -- apple
                [2461] = {chance = 4},                                                      -- leather helmet
                [2649] = {chance = 4},                                                      -- leather legs
                [2467] = {chance = 4},                                                      -- leather armor
                [2666] = {chance = 20, itemAID = AID.other.food},                           -- meat
                [5913] = {chance = 25},                                                     -- brown cloth
                [2146] = {chance = 18},                                                     -- Energy Gem
            }
        },
    },
}
centralSystem_registerTable(monster_banditMage)

customSpells["bandit mage magic wall"] = {
    cooldown = 4500,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {
                area = {
                    {n, 1, 1, 1, n},
                    {1, 1, n, 1, 1},
                    {n, n, 0, n, n},
                },
                relativeArea = {
                    {1, 1, 1, 1},
                    {1, n, n, n},
                    {1, n, 0, n},
                    {1, n, n, n},
                },
            }
        }
    },
    flyingEffect = {effect = 30},
    builder = {
        onTargets = true,
        startPoint = "caster",
        removeTime = 10000,
        N = {
            {n,     3996,   4001,   3997,   n   },
            {4001,  3999,   n,      3998,   4001},
            {n,     n,      0,      n,      n   },
        },
        S = {
            {n,     n,      0,      n,      n   },
            {4001,  3997,   n,      3996,   4001},
            {n,     3998,   4001,   3999,   n   },
        },
        W = {
            {n,     4000,   n},
            {3996,  3999,   n},
            {4000,  n,      0},
            {3998,  3997,   n},
            {n,     4000,   n},
        },
        E = {
            {n,     4000,   n   },
            {n,     3998,   3997},
            {0,     n,      4000},
            {n,     3996,   3999},
            {n,     4000,   n   },
        },
        NW = {
            {3996,  4001,   4001,   4001},
            {4000,  n,      n,      n   },
            {4000,  n,      0,      n   },
            {4000,  n,      n,      n   },
        },
        NE = {
            {4001,  4001,   4001,   3997},
            {n,     n,      n,      4000},
            {n,     0,      n,      4000},
            {n,     n,      n,      4000},
        },
        SE = {
            {n,     n,      n,      4000},
            {n,     0,      n,      4000},
            {n,     n,      n,      4000},
            {4001,  4001,   4001,   3999},
        },
        SW = {
            {4000,  n,      n,      n   },
            {4000,  n,      0,      n   },
            {4000,  n,      n,      n   },
            {3998,  4001,   4001,   4001},
        }
    }, 
}