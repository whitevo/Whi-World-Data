monsterSpells["yellow slime"] = {
    "yellow slime slow",
    "damage: cd=1500 d=10-30 t=EARTH",
}

customSpells["yellow slime slow"] = {
    cooldown = 5000,
    changeTarget = true,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {
            startPoint = "caster",
        },
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = areas.star_1x1_1},
        }
    },
    changeEnvironment = {
        items = {11638},
        itemAID = AID.jazmaz.monsters.yellowSlime_slow,
        removeTime = 10000,
    },
    magicEffect = {
        effect = {14,14,14,14,14,14,14,14, 14, 14},
        effectInterval = 1000,
        waveInterval = 200,
    },
    conditions = {
        conditionT = {
			["monsterSlow"] = {
				paramT = {["speed"] = -40},
				duration = 4000,
				maxStack = 5,
			},
		},
        noMonsters = true,
        repeatAmount = 10,
        interval = 1000,
    }
}