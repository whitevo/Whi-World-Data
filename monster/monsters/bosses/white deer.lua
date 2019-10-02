local AIDT = AID.areas.forgottenVillage
local monster_whiteDeer = {
    bossRoom = {
        highscoreAID = AIDT.whiteDeerHighscores,
        bossName = "white deer",
        killSV = SV.whiteDeerKill,
        rewardExp = 30,
    },
    monsters = {
        ["white deer"] = {
            name = "White Deer",
            reputationPoints = 6,
            race = "beast",
            bossRoomAID = AIDT.whiteDeerHighscores,
            spawnEvents = defaultBossSpawnEvents,
            task = {
                groupID = 5,
                answer = {"there are mystical creatures in Forest, prove your hunting skills to me, go kill White Deer."},
                killsRequired = 1,
                storageID = SV.whiteDeerTask,
                storageID2 = SV.whiteDeerTaskOnce,
                skillPoints = 2,
                location = "deep in north forest",
                reputation = 15,
            },
        },
    },
    monsterSpells = {
        ["white deer"] = {
            "white deer damage",
            "white deer charge",
            "white deer summon all",
            "white deer summon",
            "white deer heal",
            finalDamage = 10,
        },
    },
    monsterResistance = {
        ["white deer"] = {
            PHYSICAL = -10,
            ICE = 45,
            EARTH = -20,
            FIRE = -5,
            ENERGY = 15,
            DEATH = -5,
        },
    },
    monsterLoot = {
        ["white deer"] = {
            storage = SV.white_deer,
            items = {
                [ITEMID.eq.fur_boots] = {chance = 30, firstTime = 20, partyBoost = "false"},
                [ITEMID.herbs.urreanel] = {chance = {25,25,25}, count = {2,2,2}, itemAID = AID.herbs.urreanel},
                [ITEMID.food.meat] = {chance = {35,35}, count = {3,3}, itemAID = AID.other.food},
                [ITEMID.food.ham] = {chance = 80, itemAID = AID.other.food},
                [ITEMID.materials.big_antlers] = {chance = 10},
            }
        },
    },
}
centralSystem_registerTable(monster_whiteDeer)

customSpells["white deer heal"] = {
    cooldown = 13000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
	heal = {onTargets = true, effect = 13, percentAmount = 5, race = {["beast"] = 330}},
}

customSpells["white deer damage"] = {
    cooldown = 2000,
    targetConfig = {["enemy"] = {range = 1}},
    position = {startPosT = {startPoint = "caster"}},
    damage = {
        onTargets = true,
        damType = PHYSICAL,
        minDam = 45,
        maxDam = 110,
        minScale = 15,
        maxScale = 30,
        effectOnHit = 1,
        race = {["beast"] = 40}
    },
}

customSpells["white deer summon all"] = {
    cooldown = 3*60*1000,
    firstCastCD = -2*60*1000 - 30*1000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    say = {onTargets = true, msg = "*Sneeeeeeeeeeeeeeeegg*", msgType = ORANGE},
    summon = {
        onTargets = true,
        summons = {["deer"] = {amount = 4, monsterHP = 500}},
		maxSummons = 4,
    },
}

customSpells["white deer summon"] = {
    cooldown = 18000,
    firstCastCD = 14000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        onTargets = true,
        summons = {["deer"] = {monsterHP = 500}},
		maxSummons = 4,
    },
    say = {onTargets = true, msg = "*Sneegg*", msgType = ORANGE},
}

customSpells["white deer charge"] = {
    cooldown = 5000,
    targetConfig = {["cTarget"] = {obstacles = {"solid", "creature"}}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget", getPath = {stopOnPath = {"enemy"}, obstacles = {"solid"}}},
    },
    say = {targetConfig = {"caster"}, onTargets = true, msg = "*Wush*", msgType = ORANGE},
    teleport = {targetConfig = {"caster"}, teleportInterval = 200},
	damage = {
        sequenceInterval = 200,
        minDam = 250,
        maxDam = 350,
        damType = PHYSICAL,
        effectOnMiss = 3,
        effectOnHit = 1,
        stunOnHook = true,
        stunDuration = 2500,
        stunL = 2,
    },
}