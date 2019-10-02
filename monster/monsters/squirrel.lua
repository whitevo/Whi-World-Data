local monster_squirrel = {
    monsters = {
        ["squirrel"] = {
            name = "Squirrel",
            reputationPoints = 0,
            race = "beast",
            spawnEvents = defaultMonsterSpawnEventsSmall,
        },
    },
    monsterResistance = {
        ["squirrel"] = {
            PHYSICAL = -100,
        },
    },
}
centralSystem_registerTable(monster_squirrel)