monsterSpells["alice"] = {
    "alice heat",
}
monsterSpells["niine"] = {
    "niine death",
}
monsterSpells["bum"] = {
    "bum throwaxe",
}
monsterSpells["dundee"] = {
    "dundee spear",
}
monsterSpells["eather"] = {
    "eather attack",
}
monsterSpells["peeter"] = {
    "dundee spear",
}
monsterSpells["tonka"] = {
    "tonka stone",
}

customSpells["alice heat"] = {
    cooldown = 3000,
    targetConfig = {["friend"] = {range = 4, obstacles = "solid", amount = 1, npcFollow = true}},
    position = {startPosT = {startPoint = "caster"}},

	damage = {
        onTargets = true,
        minDam = 225,
        maxDam = 300,
        damType = FIRE,
        effectOnHit = 16,
		origin = O_player_spells,
        distanceEffect = 4,
    },
	say = {
		msg = "!heat",
		msgType = ORANGE,
    }
}

local deathArea = {
    {n, 5, n},
    {4, 3, 4},
    {5, 2, 5},
    {n, 1, n},
    {n, 0, n},
}
customSpells["niine death"] = {
    cooldown = 4000,
    targetConfig = {["friend"] = {range = 4, obstacles = "solid", npcFollow = true}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = deathArea},
            blockObjects = "solid",
        }
    },
	damage = {
        interval = 200,
        minDam = 200,
        maxDam = 360, 
        damType = DEATH,
		origin = O_player_spells,
        effect = 18,
        effectOnHit = 4,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "!death",
        msgType = ORANGE,
    },
}

customSpells["bum throwaxe"] = {
    cooldown = 4000,
    targetConfig = {["friend"] = {range = 4, obstacles = "solid", amount = 1, npcFollow = true}},
    position = {startPosT = {startPoint = "caster"}},

	damage = {
        onTargets = true,
        minDam = 300,
        maxDam = 350,
        damType = PHYSICAL,
        effectOnHit = {1,4},
		origin = O_player_spells,
        distanceEffect = 26,
    },
	say = {
		msg = "!throwaxe",
		msgType = ORANGE,
    }
}

customSpells["dundee spear"] = {
    cooldown = 2000,
    targetConfig = {["friend"] = {range = 4, obstacles = "solid", amount = 1, npcFollow = true}},
    position = {startPosT = {startPoint = "caster"}},

	damage = {
        onTargets = true,
        minDam = 100,
        maxDam = 150,
        damType = PHYSICAL,
        effectOnHit = 1,
		origin = O_player_spells,
        distanceEffect = 18,
    },
}

customSpells["eather attack"] = {
    cooldown = 1000,
    targetConfig = {["friend"] = {range = 4, amount = 1, npcFollow = true}},
    position = {startPosT = {startPoint = "caster"}},

	damage = {
        targetConfig = {["friend"] = {range = 1, amount = 1}},
        onTargets = true,
        minDam = 40,
        maxDam = 50,
        damType = EARTH,
        effectOnHit = 17,
		origin = O_player_spells,
        executeAmount = 4,
    },
}

customSpells["tonka stone"] = {
    cooldown = 2000,
    targetConfig = {["friend"] = {range = 5, obstacles = "solid", amount = 1, npcFollow = true}},
    position = {startPosT = {startPoint = "caster"}},

	damage = {
        onTargets = true,
        minDam = 200,
        maxDam = 300,
        damType = PHYSICAL,
        effectOnHit = 10,
		origin = O_player_spells,
        distanceEffect = 10,
    },
}