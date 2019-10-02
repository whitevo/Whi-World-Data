monsterSpells["water element"] = {
    "water element damage",
    "heal: cd=6000 p=4",
}

customSpells["water element damage"] = {
    cooldown = 3000,
    targetConfig = {["enemy"] = {range = 3}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_near",
        }
    },
    damage = {
        damType = ICE,
        minDam = 20,
        effectOnHit = 38,
        effectOnMiss = 12,
        distanceEffect = 37,
        race = {["element"] = 20},
    },
}