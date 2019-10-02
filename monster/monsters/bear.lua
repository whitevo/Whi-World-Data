local monster_bear = {
    monsterSpells = {
        ["bear"] = {
            "heal: cd=9000, p=5",
            "damage: cd=1500, d=20-140",
            finalDamage = 4,
        },
    },
    monsters = {
        ["bear"] = {
            name = "Bear",
            reputationPoints = 2,
            race = "beast",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 1,
                killsRequired = 10,
                storageID = SV.bearTask,
                storageID2 = SV.bearTaskOnce,
                skillPoints = 1,
                location = "north forest",
                reputation = 10,
            },
        },
    },
    monsterResistance = {
        ["bear"] = {
            PHYSICAL = -10,
            ICE = 50,
            EARTH = -20,
            FIRE = -35,
            ENERGY = -15,
            DEATH = -20,
        },
    },
    monsterLoot = {
        ["bear"] = {
            storage = SV.bear,
            items = {
                [ITEMID.eq.fur_boots] = {chance = 1, partyBoost = "false"},
                [ITEMID.herbs.urreanel] = {chance = 7, itemAID = AID.herbs.urreanel},
                [ITEMID.materials.thick_fur] = {chance = 70, count = 2},
                [ITEMID.food.meat] = {chance = 30, count = 2, itemAID = AID.other.food},
                [ITEMID.food.ham] = {chance = 30, itemAID = AID.other.food},
                [ITEMID.materials.animal_leather] = {chance = 100},
                [ITEMID.materials.bear_paw] = {chance = 7},
            }
        },
    },
}
centralSystem_registerTable(monster_bear)