monsterSpells["jellyfish"] = {
    "jellyfish heal",
    "heal: cd=500 d=30-60"
}

customSpells["jellyfish heal"] = {
    changeTarget = true,
    targetConfig = {["friend"] = {range = 5}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "friend",
            range = 5,
        },
    },
    heal = {
        onTargets = true,
		effect = 13,
        minHeal = 20,
        maxHeal = 40,
	},
    flyingEffect = {effect = 18},
}