monsterSpells["sea guard"] = {
    "sea guard no attack field",
    "heal: cd=5000 d=50-100",
    "damage: cd=2000 d=20-30",
    "damage: cd=3000 d=100 t=ENERGY c=20 e=38",
}

customSpells["sea guard no attack field"] = {
    cooldown = 10000,
    firstCastCD = -5000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget"}
    },
    changeEnvironment = {
        items = {2262},
        itemAID = AID.jazmaz.monsters.seaGuard_field,
        removeTime = 20000,
    },
    magicEffect = {
        effect = {14,14,14,14,14},
        effectInterval = 2000,
    },
}