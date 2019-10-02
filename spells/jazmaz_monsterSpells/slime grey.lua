monsterSpells["grey slime"] = {
    "grey slime heal",
    "damage: cd=2000, d=10-30, r=4, t=ICE, fe=29",
}

customSpells["grey slime heal"] = {
    cooldown = 4000,
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
    flyingEffect = {effect = 37},
}