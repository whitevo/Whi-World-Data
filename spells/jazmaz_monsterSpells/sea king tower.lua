monsterSpells["sea king tower"] = {
    "sea king tower explosion",
}


customSpells["sea king tower explosion"] = {
    cooldown = 6000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = areas.star_1x1_1},
            blockObjects = "solid",
        }
    },
    damage = {
        delay = 300,
        interval = 200,
        minDam = 20,
        maxDam = 50, 
        damType = FIRE,
        effect = {7,37},
        effectOnHit = 16,
    },
    flyingEffect = {
        position = {
            startPosT = {startPoint = "caster"},
            endPosT = {endPoint = "cTarget"},
        },
        delay = 300,
        effect = 4,
    },
}