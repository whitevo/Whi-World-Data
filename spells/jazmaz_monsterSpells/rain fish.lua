monsterSpells["rain fish"] = {
    "rain fish rain",
    "heal: cd=6000 p=4",
    "damage: cd=2000 d=20-30 r=4 t=ICE fe=37",
}

customSpells["rain fish rain"] = {
    cooldown = 7000,
    firstCastCD = -3000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["11x11_0"]},
            checkPath = "solid",
            blockObjects = "solid",
            randomPos = 8,
        },
    },
    damage = {
        minDam = 50,
        maxDam = 50,
        damType = ICE,
        effect = {2,42},
        effectOnHit = 38,
        executeAmount = 12,
        repeatInterval = 3000,
    },
    heal = {
        minHeal = 100,
		healTarget = "monster",
        executeAmount = 12,
		repeatInterval = 3000,
    }
}