local AIDT = AID.areas.borthonosRoom
local confT = {bossArea = {upCorner = {x = 436, y = 571, z = 13}, downCorner = {x = 448, y = 580, z = 13}}}

local monster_borthonos = {
    startUpFunc = "bothonos_startUp",
    name = "Borthonos boss room",
    area = {
        areaCorners = {
            {upCorner = {x = 435, y = 571, z = 12}, downCorner = {x = 449, y = 583, z = 12}},
            confT.bossArea,
        },
    },
    AIDItems = {[AIDT.scroll] = {funcSTR = "herbs_discoverHint"}},
    AIDItems_onLook = {[AIDT.scroll] = {text = {msg = "Unknown scribbles seem to be written on this scroll. Nothing special."}}},
    itemRespawns = {
        {pos = {x = 446, y = 571, z = 13}, itemID = 2422, container = 3823, itemAID = AID.other.tool, itemText = "charges(5)", chance = 25},    -- hammer
        {pos = {x = 447, y = 577, z = 13}, itemID = 2006, spawnTime = 20, fluidType = 0},                   -- vial
        {pos = {x = 445, y = 580, z = 13}, itemID = 12287, spawnTime = 20},                                 -- bowl
    },
    bossRoom = {
        roomAID = AIDT.lever,
        kickAID = AIDT.kickLever,
        leaveAID = AIDT.leave,
        signAID = AIDT.sign,
        highscoreAID = AIDT.highscores,
        upCorner = confT.bossArea.upCorner,
        downCorner = confT.bossArea.downCorner,
        enterPos = {{x = 441, y = 580, z = 13}, {x = 442, y = 580, z = 13}},
        quePos = {{x = 439, y = 574, z = 12}, {x = 438, y = 574, z = 12}},
        kickPos = {x = 441, y = 583, z = 12},
        bossPos = {x = 441, y = 572, z = 13},
        bossName = "borthonos",
        clearObjects = {1500},
        respawnCost = 10,
        bountyStr = "borthonosBounty",
        respawnSV = SV.BorthonosRespawn,
        killSV = SV.borthonosKill,
        rewardExp = 30,
    },
    monsterSpells = {
        ["borthonos"] = {
            "borthonos field bombs",
            "borthonos poison aura",
            "borthonos fire aura",
            "borthonos machine",
            "damage: cd=500, d=50-110",
            "damage: cd=2000, d=10-35, r=7, t=LD, fe=11",
        },
        ["borthonos machine"] = {"machine shot"},
    },
    monsters = {
        ["borthonos"] = {
            name = "Borthonos",
            reputationPoints = 7,
            race = "human",
            bossRoomAID = AIDT.lever,
            spawnEvents = defaultBossSpawnEvents,
            task = {
                groupID = 5,
                requiredSV = {[SV.banditSorcererTaskOnce] = 1, [SV.banditRogueTaskOnce] = 1, [SV.banditShamanTaskOnce] = 1},
                killsRequired = 1,
                storageID = SV.borthonosTask,
                storageID2 = SV.borthonosTaskOnce,
                skillPoints = 2,
                location = "Hehemi town",
                reputation = 12,
            },
        },
    },
    monsterResistance = {
        ["borthonos"] = {
            PHYSICAL = -50,
            ICE = 15,
            FIRE = 40,
            ENERGY = -20,
            DEATH = -40,
            EARTH = -20,
        },
    },
    monsterLoot = {
        ["borthonos"] = {
            storage = SV.borthonos,
            bounty = {[ITEMID.other.coin] = {amount = "borthonosBounty"}},
            items = {
                [15400] = {chance = 5, druid = 15, firstTime = 20, partyBoost = "false"},   -- yashinuken
                [13760] = {chance = 5, mage = 15, firstTime = 20, partyBoost = "false"},    -- immortal kamikaze
                [15647] = {chance = 5, knight = 15, firstTime = 20, partyBoost = "false"},  -- purifying mallet
                [5958] = {chance = 8, itemAID = {AID.spells.dispel, AID.spells.mend, AID.spells.sapphdef, AID.spells.throwaxe}},
                [ITEMID.other.coin] = {chance = {100,50,25}, count = {6,4,10}},                          -- coin
                [2147] = {chance = {12,12,12,12,12}, count = {}},                           -- fire gem
                [18406] = {chance = 20, partyBoost = "false"},                              -- The Nami boots
                [2666] = {chance = 50, count = 3, itemAID = AID.other.food},                -- meat
                [2674] = {chance = 25, count = 7, itemAID = AID.other.food},                -- apple
                [2263] = {chance = 5, mage = 10},                                           -- death stone
                [2271] = {chance = 5, mage = 10},                                           -- energy stone
                [2266] = {chance = 80},                                                     -- critical block stone
            }
        }
    },
}
centralSystem_registerTable(monster_borthonos)

function bothonos_startUp()
    -- empty brah :D
end

function borthonosMachine_usedOn(player, item, itemEx)
    if not itemEx:isMonster() then return end
    if itemEx:getName():lower() ~= "borthonos machine" then return end
    createItem(2256, itemEx:getPosition()):decay()
    tools_addCharges(player, itemEx, -1)
    itemEx:remove()
end

customSpells["borthonos machine"] = {
    cooldown = 7000,
    firstCastCD = 25000,
    targetConfig = {"enemy"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        summons = {"borthonos machine"},
		maxSummons = 4,
        say = {hook = true, msg = "*crashbrkzbuh*"},
    },
}

customSpells["machine shot"] = {
    cooldown = 2000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", randomPos = 1},
    },
	damage = {
        delay = 700,
        minDam = 35,
        maxDam = 100,
        damType = ENERGY,
        effect = 12,
        effectOnHit = 10,
        distanceEffect = 36,
    },
}

local auraPosConfig = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "caster", areaConfig = {area = areas["5x5_0 circle"]}}}
local chargeUpEffect =  {effect = 5, position = {startPosT = {startPoint = "endPos"}, endPosT = {endPoint = "caster"}}}

customSpells["borthonos fire aura"] = {
    cooldown = 5000,
    firstCastCD = 5000,
    targetConfig = {"caster"},
    position = auraPosConfig,
	damage = {
        delay = 200,
        interval = 150,
        minDam = 120,
        maxDam = 170, 
        damType = FIRE,
        effect = 37,
        effectOnHit = 16,
    },
    flyingEffect = chargeUpEffect,
    magicEffect = {onTargets = true, effect = 40}
}

customSpells["borthonos poison aura"] = {
    cooldown = 5000,
    targetConfig = {"caster"},
    position = auraPosConfig,
	damage = {
        delay = 200,
        interval = 150,
        minDam = 100,
        maxDam = 100, 
        damType = EARTH,
        effect = 9,
        effectOnHit = 21,
    },
    flyingEffect = chargeUpEffect,
    magicEffect = {onTargets = true, effect = 21},
}

customSpells["borthonos field bombs"] = {
    cooldown = 12000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_far",
            areaConfig = {area = areas["star_1x1_1"]},
            blockObjects = "solid",
        }
    },
    flyingEffect = {effect = 38},
    changeEnvironment = {
        items = {1502, 1500},
        removeItems = {1502, 1500},
        itemDelay = 2500,
        itemAID = AID.areas.archanosRoom.bossFireField,
        
        damage = {
            hook = true,
            minDam = 400,
            maxDam = 600,
            damType = FIRE,
            effectOnHit = 10,
        },
    },
}