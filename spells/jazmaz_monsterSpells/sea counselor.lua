-- buffs damage: config in bufferMonsters() function
monsterSpells["sea counselor"] = {
    "square_7x7_1 effects 15",
    "sea counselor remove magic level",
    "heal: cd=5000 d=50-100",
    "damage: cd=2000 d=20-30 t=ICE r=4",
}

customSpells["sea counselor remove magic level"] = {
    cooldown = 10000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget"}
    },
    spellLock = {
        targetConfig = {"caster"},
        onTargets = true,
        lockSpells = "sea counselor remove magic level"
    },
    conditions = {
        onTargets = true,
		conditionT = {
			["seaCounselorMagic"] = {
				paramT = {mL = -10},
				duration = 60*1000,
				maxStack = 3,
			}
		},
	},
}

customSpells["square_7x7_1 effects 15"] = {
    cooldown = 4000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["square_7x7_1"]},
        }
    },
    magicEffect = {effect = 15, waveInterval = 200},
}