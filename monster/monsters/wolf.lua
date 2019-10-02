local monster_wolf = {
    monsterSpells = {
        ["wolf"] = {
            "heal: cd=5000, p=5",
            "damage: cd=200, d=5-35",
        },
    },
    monsters = {
        ["wolf"] = {
            name = "Wolf",
            reputationPoints = 1,
            race = "beast",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 1,
                killsRequired = 10,
                storageID = SV.wolfTask,
                storageID2 = SV.wolfTaskOnce,
                skillPoints = 1,
                location = "north forest",
                reputation = 10,
            },
        },
    },
    monsterResistance = {
        ["wolf"] = {
            PHYSICAL = -40,
            ICE = 40,
            EARTH = -20,
            FIRE = -30,
            ENERGY = -15,
            DEATH = -30,
        },
    },
    monsterLoot = {
        ["wolf"] = {
            storage = SV.wolf,
            items = {
                [ITEMID.herbs.urreanel] = {chance = 7, itemAID = AID.herbs.urreanel},
                [ITEMID.food.meat] = {chance = 20, itemAID = AID.other.food},
                [ITEMID.materials.wolf_paw] = {chance = 8},
                [ITEMID.materials.wolf_fur] = {chance = 80},
                [ITEMID.materials.animal_leather] = {chance = 100},
            }
        },
    },
}
centralSystem_registerTable(monster_wolf)