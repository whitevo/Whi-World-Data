--[[ monsters config table
    [monsterName] = STR             STR = another monsterTable key(aka another monster name) | used for inherting same config table
    
    [STR] = {                       monster name in lower letters
        name = STR                  monster official name
        reputationPoints = INT or 0 How many points will it give for the tasker reputation
        HPScale = bool or nil       if true then monster HP increases for each player around it
        race = STR                  race of monster
        spawnEvents = {             what craturescripts activated when its spawned and automatic registration is not disabled
            onThink = {STR}         STR = function name
            onDeath = {STR}
            onHealthChange = {STR}
        },
        
        task = {                    create task for the monster
            groupID = INT           categorizes tasks, used for task resets.
            killsRequired = INT     how many monster have to be killed to complete the task
            storageID = INT         storage value for the kill counts
            storageID2 = INT        storage value what keeps track has the task been done before
            skillPoints = INT       how many skillpoints task rewards first time
            location = STR          Where player can find the monster
            answer = {STR}          what will npc say if task is taken.
            msg = {STR}             what will npc say if task is completed.
            requiredSV = {[SV]=INT} What storageValues gotta be to start this task (special for npc table generator)
        }
        boss = {                    turns the creature into boss
            respawn = INT           storage value for the question, does player have boss protection?
            storage = INT           storage value for the question, has player killed that boss before?
            rewardExp = INT         how much 1 time exp player will get for killing boss
            bossRoomAID = INT       connects boss to bossRoom, bossSign, bossRoom leaving crystal trough same action ID
            highscoreBoardAID = INT connect boss to highscore board with same action id board has
            highscoreMWID = INT     each boss has its own modal window ID
            setSV = {[SV]=V}        when boss killed first time, storage value is set.
            funcSTR = STR           when boss killed first time custom function acticates
        },
        killActions = {{
            allSV = {[SV] = INT}    
            setSV = {[SV] = INT}    
            funcSTR = STR
            rewardExp = INT
        }}
    }
]]
allMonsterRacesT = {"beast", "undead", "human", "element", "sea creature", "object"} -- list of races

--[[ creatureScripts config guide
    [INT] = {       creatureID
        STR         function name
    }
]]
onDeathScripts = {}
onHealthChangeScripts = {}
onThinkScripts = {}

spawnEvents = { -- [monsterName] = {eventNames}
    onThink = {
        ["green slime"] = "greenSlimeAI",
    },
    onDeath = {
        ["big water element"] = "bigWaterElement_onDeath",
    },
    onHealthChange = {},
}

defaultMonsterSpawnEvents = {
    onThink = {"AI_onThink", "scalingSystem_onThink"},
    onDeath = {"monster_onDeath"},
    onHealthChange = {"damageSystem_onHealthChange"},
}

defaultMonsterSpawnEventsSmall = {
    onThink = {"AI_onThink"},
    onHealthChange = {"damageSystem_onHealthChange"},
}

defaultBossSpawnEvents = {
    onThink = {"AI_onThink"},
    onDeath = {"monster_onDeath", "bossRoom_onDeath"},
    onHealthChange = {"damageSystem_onHealthChange"},
}

monsters = {
    ["water element"]       = {name = "water element",      race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    ["fire elemental"]      = {name = "fire elemental",     race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    ["death elemental"]     = {name = "death elemental",    race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    ["ice elemental"]       = {name = "ice elemental",      race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    ["earth elemental"]     = {name = "earth elemental",    race = "element", spawnEvents = defaultMonsterSpawnEventsSmall}, 
    ["energy elemental"]    = {name = "energy elemental",   race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    -- monsters are registed with centralT, usually they are located inside monsters folder
}

impResistance = {} -- maybe should be in imp spell file?
elementalResistances = {}
temporarResByCid = {}

customSpells = {}
monsterSpells = {
    ["earth elemental"] = {"damage: cd=3000, d=20-50, r=3, t=EARTH, fe=10"},
    ["fire elemental"] = {"damage: cd=3000, d=20-50, r=3, t=FIRE, fe=4"},
    ["death elemental"] = {"damage: cd=3000, d=20-50, r=3, t=DEATH, fe=11"},
    ["ice elemental"] = {"damage: cd=3000, d=20-50, r=3, t=ICE, fe=37"},
    ["energy elemental"] = {"damage: cd=3000, d=20-50, r=3, t=ENERGY, fe=36"},
}

print("monsters loaded..")