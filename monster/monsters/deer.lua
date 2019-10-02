local monster_deer = {
    monsterSpells = {
        ["deer"] = {
            "heal: cd=5000, p=5",
            "damage: cd=1500, d=10-40",
            finalDamage = 2,
        },
    },
    monsters = {
        ["deer"] = {
            name = "Deer",
            reputationPoints = 1,
            race = "beast",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 1,
                killsRequired = 10,
                storageID = SV.deerTask,
                storageID2 = SV.deerTaskOnce,
                skillPoints = 1,
                location = "north forest",
                reputation = 10,
            }
        },
    },
    monsterResistance = {
        ["deer"] = {
            PHYSICAL = -40,
            ICE = 30,
            EARTH = -30,
            FIRE = -30,
            ENERGY = -20,
            DEATH = -30,
        },
    },
    monsterLoot = {
        ["deer"] = {
            storage = SV.deer,
            items = {
                [ITEMID.herbs.urreanel] = {chance = 7, itemAID = AID.herbs.urreanel},
                [ITEMID.food.meat] = {chance = 20, itemAID = AID.other.food},
                [ITEMID.materials.antlers] = {chance = 80},
                [ITEMID.materials.animal_leather] = {chance = 100},
            }
        },
    },
}
centralSystem_registerTable(monster_deer)