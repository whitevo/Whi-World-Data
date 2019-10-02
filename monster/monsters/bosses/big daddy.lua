local AIDT = AID.areas.bigDaddyRoom
local confT = {
    bossArea = {upCorner = {x = 793, y = 569, z = 9}, downCorner = {x = 800, y = 578, z = 9}},
}

local monster_bigDaddy = {
    name = "Big Daddy boss room",
    area = {
        areaCorners = {
            {upCorner = {x = 786, y = 567, z = 8}, downCorner = {x = 803, y = 581, z = 8}},
            confT.bossArea,
        },
    },
    AIDItems = {
        [AIDT.bigDaddyNote] = {funcSTR = "herbs_discoverHint"},
    },
    AIDItems_onLook = {
        [AIDT.bigDaddyNote] = {text = {msg = "You see picture of burning flower and some text under it"}},
    },
    bossRoom = {
        upCorner = confT.bossArea.upCorner,
        downCorner = confT.bossArea.downCorner,
        roomAID = AIDT.lever,
        kickAID = AIDT.kickLever,
        leaveAID = AIDT.leave,
        signAID = AIDT.sign,
        highscoreAID = AIDT.highscores,
        quePos = {{x = 795, y = 571, z = 8}, {x = 794, y = 571, z = 8}},
        enterPos = {{x = 796, y = 570, z = 9}, {x = 797, y = 570, z = 9}},
        kickPos = {x = 796, y = 580, z = 8},
        bossPos = {x = 796, y = 576, z = 9},
        bossName = "big daddy",
        clearObjects = {3666, 3667, 3668},
        respawnCost = 8,
        bountyStr = "big_daddyBounty",
        respawnSV = SV.BigDaddyRespawn,
        killSV = SV.bigDaddyKill,
        rewardExp = 30,
    },
    monsterSpells = {
        ["big daddy"] = {
            "big daddy smash",
            "big daddy tremor",
            "big daddy tremor2",
            "big daddy groundspikes",
            "big daddy wall",
            "big daddy defense stance",
            "big daddy attack stance",
            "heal: cd=8000, d=300-500",
        },
    },
    monsters = {
        ["big daddy"] = {
            name = "Big Daddy",
            reputationPoints = 6,
            race = "human",
            bossRoomAID = AIDT.lever,
            spawnEvents = defaultBossSpawnEvents,
            task = {
                groupID = 5,
                requiredSV = {[SV.cyclopsTaskOnce] = 1},
                answer = {"Want a challenge? Go kill a Big Daddy."},
                killsRequired = 1,
                storageID = SV.bigDaddyTask,
                storageID2 = SV.bigDaddyTaskOnce,
                skillPoints = 2,
                location = "east Cyclops dungeon",
                reputation = 15,
            },
        },
    },
    monsterResistance = {
        ["big daddy"] = {
            PHYSICAL = 15,
            ICE = 30,
            EARTH = 50,
            FIRE = 60,
            ENERGY = 30,
            HOLY = 50,
            DEATH = 20,
        },
    },
    monsterLoot = {
        ["big daddy"] = {
            storage = SV.big_daddy,
            bounty = {[ITEMID.other.coin] = {amount = "big_daddyBounty"}},
            items = {
                [12434] = {chance = 5, druid = 15, firstTime = 20, partyBoost = "false", unique = true},   -- hood of natural talent
                [2663] = {chance = 5, knight = 15, firstTime = 20, partyBoost = "false"},   -- zvoid turban
                [2662] = {chance = 5, mage = 15, firstTime = 20, partyBoost = "false"},     -- arogja hat
                [5958] = {chance = 8, itemAID = {AID.spells.volley, AID.spells.opaldef, AID.spells.buff}},-- SpellScroll: volley
                [ITEMID.other.coin] = {chance = {100,50,25}, count = {3,2,5}},                           -- coin
                [11242] = {chance = 10, partyBoost = "false"},                              -- expedition bag
                [11241] = {chance = 7, partyBoost = "false"},                               -- expedition backpack
                [2267] = {chance = {10,10,10,10}, count = {}},                              -- armor stone T1
                [5880] = {chance = {90,50}, count = {1,2}},                                 -- copper ore
                [2553] = {chance = 55, itemAID = AID.other.tool, itemText = "charges(5)"},      -- pickaxe
                [2666] = {chance = 30, count = 3, itemAID = AID.other.food},                -- meat
                [1294] = {chance = 30, count = 2},                                          -- small stone
                [2263] = {chance = 5, mage = 6},                                            -- death stone
                [2271] = {chance = 5, mage = 6},                                            -- energy stone
                [2674] = {chance = 30, itemAID = AID.other.food},                           -- ham
                [2265] = {chance = 30},                                                     -- armor stone T2
                [7464] = {chance = 10},                                                     -- fur shorts
            }
        },
    },
}
centralSystem_registerTable(monster_bigDaddy)

local fallingStones = {3666, 3667, 3668}

customSpells["big daddy smash"] = {
    cooldown = 4000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {
                area = {
                    {3,  3,  n,  n,  n,  3,  3},
                    {n,  2,  2,  2,  2,  2,  n},
                    {n,  n,  1,  1,  1,  n,  n},
                    {n,  n,  n,  0,  n,  n,  n},
                },
            },
        }
    },
	damage = {
        delay = 850,
        interval = 200,
        minDam = 100,
        maxDam = 160, 
        damType = PHYSICAL,
        effect = 27,
        effectOnHit = 1,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*raizes hammer*",
        msgType = ORANGE,
    },
}

customSpells["big daddy tremor"] = {
    cooldown = 8000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["7x9_0"]},
            blockObjects = {"solid"},
            randomPos = 3,
        }
    },
	damage = {
        delay = 2500,
        minDam = 300,
        maxDam = 400, 
        damType = PHYSICAL,
        effectOnHit = 45,
        effectOnMiss = 39,
        
        changeEnvironment = {
            blockObjects = {"enemy", "caster", "friend"},
            items = fallingStones,
            randomised = true,
        },
    },
    magicEffect = {effect = {4,4,4}, effectInterval = 500},
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*shakes booty*",
        msgType = ORANGE,
    },
}
customSpells["big daddy tremor2"] = {
    cooldown = 8000,
    targetConfig = {"cTarget"},
    position = {startPosT = {startPoint = "cTarget"}},
	damage = {
        delay = 2500,
        minDam = 300,
        maxDam = 400, 
        damType = PHYSICAL,
        effectOnHit = 45,
        effectOnMiss = 39,
        
        changeEnvironment = {
            blockObjects = {"enemy", "caster", "friend"},
            items = fallingStones,
            randomised = true,
        },
    },
    magicEffect = {effect = {4,4,4}, effectInterval = 500},
}

customSpells["big daddy groundspikes"] = {
    cooldown = 2500,
    locked = true,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["11x11_0"]},
            blockObjects = "solid",
            randomPos = 10,
        }
    },
	damage = {
        delay = 2500,
        sequenceInterval = 300,
        minDam = 200,
        maxDam = 330,
        damType = PHYSICAL,
        effectOnHit = 1,
    },
    changeEnvironment = {
        delay = 2500,
        items = {17582, 17576, 17588},
        randomised = true,
        removeTime = 3000,
        sequenceInterval = 300,
    },
    magicEffect = {
        effect = {10,10,10},
        effectInterval = 400,
        sequenceInterval = 300,
    }
}

customSpells["big daddy wall"] = {
    targetConfig = {"enemy"},
    cooldown = 2000,
    locked = true,
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {
                area = {
                    {1, 1, 1},
                    {1, 0, 1},
                    {1, 1, 1},
                },
            },
        }
    },
    spellLock = {targetConfig = {"caster"}, onTargets = true, lockSpells = {"big daddy wall"}},
	damage = {
        delay = 2500,
        minDam = 400,
        maxDam = 600,
        damType = PHYSICAL,
        effectOnHit = 1,
        effect = 3,
        
        changeEnvironment = {
            blockObjects = "player",
            removeItems = fallingStones,
        },
        builder = {
            targetConfig = {"caster"},
            onTargets = true,
            removeTime = 6000,
            N = {
                {13143, 12847,  12847},
                {12846, 0,      12846},
            },
            S = {
                {12846, 0,      12846},
                {12846, 12847,  12886},
            },
            W = {
                {13143, 12847},
                {12846, 0},
                {12846, 12847},
            },
            E = {
                {12847, 12847},
                {0,     12846},
                {12847, 12886},
            },
        },
        magicEffect = {
            position = {
                startPosT = {startPoint = "caster"},
                endPosT = {endPoint = "caster", areaConfig = {area = areas["6x6_0 circle"]}}
            },
            effect = {3,4},
            effectInterval = 150,
            waveInterval = 250,
        }
    },
    magicEffect = {effect = {14,14,14,10}, effectInterval = 500},
}

customSpells["big daddy attack stance"] = {
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    spellLock = {
        onTargets = true,
        lockSpells = {
            "big daddy attack stance",
            "big daddy groundspikes",
            "big daddy wall",
        },
        unlockSpells = {
            "big daddy defense stance",
            "big daddy tremor",
            "big daddy tremor2",
            "big daddy smash",
        },
    },
    spellLockCD = {onTargets = true, [19000] = {"big daddy defense stance"}},
    say = {onTargets = true, msg = "AAARGH!!!"}
}

customSpells["big daddy defense stance"] = {
    locked = true,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    resistance = {
        onTargets = true,
        [PHYSICAL] = -35,
        [ICE] = -40,
        [EARTH] = -10,
        [FIRE] = -30,
        [ENERGY] = -40,
        [HOLY] = -20,
        [DEATH] = -20,
        duration = 10000,
    },
    spellLock = {
        onTargets = true,
        lockSpells = {
            "big daddy defense stance",
            "big daddy tremor",
            "big daddy tremor2",
            "big daddy smash",
        },
        unlockSpells = {
            "big daddy attack stance",
            "big daddy groundspikes",
            "big daddy wall",
        },
    },
    conditions = {onTargets = true, conditionT = {["monsterSlow"] = {paramT = {["speed"] = -500}, duration = 9000}}},
    spellLockCD = {onTargets = true, [9000] = {"big daddy attack stance"}},
    say = {onTargets = true, msg = "DEF UP!!"}
}