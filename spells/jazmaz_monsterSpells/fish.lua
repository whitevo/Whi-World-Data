monsterSpells["fish"] = {
    "fish attack",
    "heal: cd=4000 d=30-60",
}

customSpells["fish attack"] = {
    targetConfig = {["cTarget"] = {range = 1}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            range = 1,
        },
    },
    damage = {
        onTargets = true,
        minDam = 10,
        maxDam = 20,
        damType = PHYSICAL,
		race = {
			["sea creature"] = 20
		},
        effect = 1,
    }
}