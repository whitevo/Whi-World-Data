local monster_trainingPole = {
    monsters = {
        ["training pole"] = {
            name = "Training Pole",
            race = "object",
            spawnEvents = defaultMonsterSpawnEventsSmall,
        },
    },
    monsterSpells = {
        ["training pole"] = {"heal: cd=30000, p=20"},
    },
}
centralSystem_registerTable(monster_trainingPole)