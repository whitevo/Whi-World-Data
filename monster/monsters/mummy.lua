local monster_mummy = {
    registerEvent = {
        onDeath = {mummy = "mummyRoom_reSpawn"}
    },
    monsters = {
        ["mummy"] = {
            name = "Mummy",
            reputationPoints = 5,
            race = "undead",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 3,
                killsRequired = 10,
                storageID = SV.mummyTask,
                storageID2 = SV.mummyTaskOnce,
                skillPoints = 1,
                location = "In Rooted Catacombs",
                reputation = 15,
                answer = "I see you can deal with mummies, go put them back in their coffins!",
            }
        },
    },
    monsterSpells = {
        ["mummy"] = {
            "mummy bind",
            "mummy missles",
            "mummy strike",
            "mummy bomb",
            "mummy lifesteal",
            "damage: cd=1000, d=50-75",
        },
    },
    monsterResistance = {
        ["mummy"] = {
            PHYSICAL = 15,
            ICE = 30,
            FIRE = 50,
            ENERGY = 60,
            DEATH = 95,
            HOLY = -30,
            EARTH = 75,
        },
    },
    monsterLoot = {
        ["mummy"] = {
            storage = SV.mummy,
            items = {
                [11425] = {chance = 3, hunter = 3, firstTime = 5, partyBoost = "false"},    -- bloody shirt
                [9776]  = {chance = 3, druid = 3,  firstTime = 5, partyBoost = "false"},    -- goddess armor
                [20109] = {chance = 3, knight = 3, firstTime = 5, partyBoost = "false"},    -- leather vest
                [12431] = {chance = 3, mage = 3,   firstTime = 5, partyBoost = "false"},    -- kamikaze mantle
                [2477]  = {chance = 4, hunter = 2, firstTime = 2, partyBoost = "false"},    -- shimasu legs
                [7896]  = {chance = 4, druid = 2,  firstTime = 2, partyBoost = "false"},    -- frizen kilt
                [18405] = {chance = 4, knight = 2, firstTime = 2, partyBoost = "false"},    -- ghatitk legs
                [5918]  = {chance = 4, mage = 2,   firstTime = 2, partyBoost = "false"},    -- kamikaze short pants
                [ITEMID.other.coin]  = {chance = {45,30,20},    count = {2,5,8}},                        -- coin
                [2150]  = {chance = 10},                                                    -- death gem
                [2264]  = {chance = 20},                                                    -- defence stone
                [11208] = {chance = 35},                                                    -- mummy cloth
            }
        },
    },
}
centralSystem_registerTable(monster_mummy)

function mummyRoom_reSpawn(creature, corpse)
    local spawnTime = mummyRoom_conf.mummySpawnTime
    local roomT = mummyRoom_getRoomTByPos(creature:getPosition())
    if not roomT then return end
    addEvent(mummyRoom_spawn, spawnTime, roomT.roomAID)
end

customSpells["mummy bind"] = {
    cooldown = 8000,
    firstCastCD = -6000,
	targetConfig = {["cTarget"] = {range = 1}},
	position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
	say = {msg = "*wrap*"},
	magicEffect = {effect = 27},
	flyingEffect = {effect = 35},
    bind = {onTargets = true, msDuration = 2000}
}

local s = {0,7}
local missleArea = {
    {n,n,6,s,6,n,n},
    {n,5,1,n,1,5,n},
    {4,n,2,n,2,n,4},
    {n,3,n,n,n,3,n},
}

customSpells["mummy missles"] = {
    cooldown = 10000,
    firstCastCD = -4000,
    targetConfig = {"cTarget"},
    position = {
		startPosT = {startPoint = "caster"},
		endPosT = {endPoint = "cTarget", areaConfig = {area = missleArea, useStartPos = true}, blockObjects = "solid"},
	},
    damage = {
		interval = 150,
        minDam = 100,
        maxDam = 150,
        damType = DEATH,
		distanceEffect = 35,
        effect = 18,
        effectOnHit = 47,
        rootMsDuration = 3000,
        
        damage = {
            delay = 300,
            position = {
                startPosT = {startPoint = "caster"},
                endPosT = {endPoint = "cTarget", getPath = {obstacles = {"solid"}}},
            },
            sequenceInterval = 150,
            minDam = 100,
            maxDam = 150,
            damType = DEATH,
            distanceEffect = 35,
            effect = 18,
            effectOnHit = 47,
            rootMsDuration = 3000,
        }
    }
}

local strikeArea = {
    {1},
    {1},
    {0},
}
customSpells["mummy strike"] = {
    cooldown = 3000,
    targetConfig = {["enemy"] = {}},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = strikeArea}}},
    damage = {
        minDam = 90,
        maxDam = 145,
        damType = DEATH,
        effect = 18,
        effectOnHit = 4,
    },
}

local AIDT = AID.areas.mummyRoom
customSpells["mummy bomb"] = {
    cooldown = 15000,
    targetConfig = {["cTarget"] = {range = 5}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    flyingEffect = {effect = 10},
    magicEffect = {effect = {29,29,29}, effectInterval = 1000},
    damage = {
        delay = 500,
        minDam = 30,
        maxDam = 60,
        damType = DEATH,
        effect = 10,
        effectOnHit = 1,
        rootOnHook = true,
        rootMsDuration = 3000,
        
        changeEnvironment = {items = {10566}, itemAID = AIDT.mummy_bomb, removeTime = 3000},
        damage = {
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {endPoint = "endPos", areaConfig = {area = areas["3x3_1"]}, blockObjects = {10566, "solid"}, randomPos = 4},
            },
            delay = 3000,
            minDam = 80,
            maxDam = 130,
            damType = DEATH,
            effect = 4,
            effectOnHit = 18,
            rootOnHook = true,
            rootMsDuration = 3000,
            
            flyingEffect = {effect = 10},
            changeEnvironment = {oppoHook = true, items = {15487}, itemAID = AIDT.mummy_rootingBandage, removeTime = 15000},
        },
    },
}

function mummy_rootingBandage(creature, item)
    item:remove()
    if creature:isPlayer() then return root(creature, 3000) end
    if creature:getRealName() == "mummy" then heal(creature, 400, 17) end
end

customSpells["mummy lifesteal"] = {
    cooldown = 2000,
    targetConfig = {["cTarget"] = {range = 1}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    damage = {
        onTargets = true,
        minDam = 15,
        maxDam = 40,
        damType = DEATH,
        effect = 28,
        recastPerPos = true,
        
        heal = {
            targetConfig = {"caster"},
            onTargets = true,
            hook = true,
            effect = 14,
            minHeal = 5,
            maxHeal = 10,
            minScale = 20,
            maxScale = 40,
        },
    },
}