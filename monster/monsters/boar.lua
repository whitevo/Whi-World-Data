local monster_boar = {
    monsterSpells = {
        ["boar"] = {
            "heal: cd=5000, p=5",
            "boar speed",
            "damage: cd=3000, d=50-75",
            finalDamage = 3,
        },
    },
    monsters = {
        ["boar"] = {
            name = "Boar",
            reputationPoints = 1,
            race = "beast",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 1, 
                killsRequired = 10,
                storageID = SV.boarTask,
                storageID2 = SV.boarTaskOnce,
                skillPoints = 1,
                location = "north forest",
                reputation = 10,
            },
        },
    },
    monsterResistance = {
        ["boar"] = {
            PHYSICAL = -35,
            ICE = 30,
            EARTH = -30,
            FIRE = -30,
            ENERGY = -10,
            DEATH = -25,
        },
    },
    monsterLoot = {
        ["boar"] = {
            storage = SV.boar,
            items = {
                [ITEMID.herbs.urreanel] = {chance = 7, itemAID = AID.herbs.urreanel},
                [ITEMID.food.meat] = {chance = 25, itemAID = AID.other.food},
                [ITEMID.materials.thick_fur] = {chance = 70},
                [ITEMID.materials.animal_leather] = {chance = 100},
            }
        },
    },
}
centralSystem_registerTable(monster_boar)

customSpells["boar speed"] = {
    cooldown = 10000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    magicEffect = {effect = 14},
    say = {onTargets = true, msg = "*gruuunt*", msgType = ORANGE},
    conditions = {onTargets = true, conditionT = {["monsterHaste"] = {paramT = {speed = 450}, duration = 3000}}},
}