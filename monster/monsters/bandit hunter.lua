local monster_banditHunter = {
    monsterSpells = {
        ["bandit hunter"] = {
            "heal: cd=9000, p=4",
            "damage: cd=1000, d=40-110",
            "damage: cd=3000, d=20-80, r=7, fe=3",
            "damage: cd=3000, d=80-160, r=4, fe=3, c=10",
            finalDamage = 2,
        },
    },
    monsters = {
        ["bandit hunter"] = {
            name = "Bandit Hunter",
            reputationPoints = 2,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.deerTaskOnce] = 1, [SV.wolfTaskOnce] = 1, [SV.boarTaskOnce] = 1, [SV.bearTaskOnce] = 1},
                answer = {"Peeter told me he needs some help with Bandits, you can go deal with them."},
                killsRequired = 9,
                storageID = SV.bandithunterTask,
                storageID2 = SV.bandithunterTaskOnce,
                skillPoints = 1,
                location = "west Bandit mountain",
                reputation = 11,
            },
        },
    },
    monsterResistance = {
        ["bandit hunter"] = {
            PHYSICAL = -60,
            ICE = -40,
            EARTH = -40,
            FIRE = -10,
            ENERGY = -20,
            DEATH = -40,
        },
    },
    monsterLoot = {
        ["bandit hunter"] = {
            storage = SV.b_hunter,
            items = {
                [ITEMID.other.spellScroll] = {chance = 2, itemAID = AID.spells.fakedeath, hunter = 2.5, firstTime = 3, partyBoost = "false"},
                [ITEMID.eq.bow] = {chance = 2, hunter = 5.5, firstTime = 4, partyBoost = "false"},
                [ITEMID.other.coin] = {chance = {35,15}, count = {1,3}},
                [ITEMID.herbs.iddunel] = {chance = 5, itemAID = 2067},
                [2674] = {chance = 12, count = 2, itemAID = AID.other.food},                            -- apple
                [2461] = {chance = 4},                                                                  -- leather helmet
                [2649] = {chance = 4},                                                                  -- leather legs
                [2467] = {chance = 4},                                                                  -- leather armor
                [2666] = {chance = 20, itemAID = AID.other.food},                                       -- meat
                [5912] = {chance = 25},                                                                 -- blue cloth
                [9970] = {chance = 18},                                                                 -- Ice Gem
            }
        },
    },
}
centralSystem_registerTable(monster_banditHunter)