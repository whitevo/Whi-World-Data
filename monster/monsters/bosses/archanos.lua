local AIDT = AID.areas.archanosRoom
local confT = {
    bossArea = {upCorner = {x = 454, y = 554, z = 6}, downCorner = {x = 468, y = 560, z = 6}},
}

local monster_archanos = {
    name = "Archanos boss room",
    area = {
        areaCorners = {
            {upCorner = {x = 445, y = 550, z = 5}, downCorner = {x = 472, y = 564, z = 5}},
            confT.bossArea,
        },
    },
    AIDItems = {
        [AIDT.redBook] = {funcSTR = "herbs_discoverHint"},
    },
    AIDTiles_stepIn = {
        [AIDT.bossFireField] = {funcSTR = "archanos_fireField_onStep"},
    },
    AIDTiles_stepOut = {
        [AIDT.bossFireField] = {funcSTR = "archanos_fireField_onStep"},
    },
    monsterSpells = {
        ["archanos"] = {
            "archanos ice aura",
            "archanos fire aura",
            "archanos electric shot",
            "archanos teleport",
            "archanos field bombs",
            "damage: cd=500, d=30-80",
            "damage: cd=2000, d=5-25, r=7, t=LD, fe=11",
        }
    },
    bossRoom = {
        upCorner = confT.bossArea.upCorner,
        downCorner = confT.bossArea.downCorner,
        roomAID = AIDT.lever,
        kickAID = AIDT.kickLever,
        leaveAID = AIDT.leave,
        signAID = AIDT.sign,
        highscoreAID = AIDT.highscores,
        quePos = {{x = 454, y = 556, z = 5}, {x = 453, y = 556, z = 5}},
        enterPos = {{x = 454, y = 556, z = 6}, {x = 454, y = 557, z = 6}},
        kickPos = {x = 445, y = 555, z = 5},
        bossPos = {x = 467, y = 556, z = 6},
        bossName = "archanos",
        clearObjects = {1500},
        respawnCost = 8,
        bountyStr = "archanosBounty",
        respawnSV = SV.ArchanosRespawn,
        killSV = SV.archanosKill,
        rewardExp = 30,
    },
    monsters = {
        ["archanos"] = {
            name = "Archanos",
            reputationPoints = 6,
            race = "human",
            spawnEvents = defaultBossSpawnEvents,
            task = {
                groupID = 5,
                requiredSV = {[SV.bandithunterTaskOnce] = 1, [SV.banditKnightTaskOnce] = 1, [SV.banditMageTaskOnce] = 1, [SV.banditDruidTaskOnce] = 1},
                answer = {"There is big shot in Bandit Mountains, 'Archanos'. Go deal with him and perhaps the bandit attacks will reduce."},
                killsRequired = 1,
                storageID = SV.archanosTask,
                storageID2 = SV.archanosTaskOnce,
                skillPoints = 2,
                location = "west Bandit mountain",
                reputation = 15,
            },
            bossRoomAID = AIDT.lever,
        },
    },
    monsterResistance = {
        ["archanos"] = {
            PHYSICAL = -10,
            ICE = 35,
            EARTH = -20,
            FIRE = 60,
            HOLY = 20,
            DEATH = -50,
            ENERGY = 50,
        },
    },
    monsterLoot = {
        ["archanos"] = {
            storage = SV.archanos,
            bounty = {[ITEMID.other.coin] = {amount = "archanosBounty"}},                                -- coin
            items = {
                [5958] = {chance = 8, itemAID = {AID.spells.shiver, AID.spells.rubydef, AID.spells.fakedeath, AID.spells.death}, partyBoost = "false"},    -- SpellScrolls
                [2558] = {chance = 55, itemAID = AID.other.tool, partyBoost = "false", itemText = "charges(8)"},   -- saw
                [8707] = {chance = 5, mage = 15, druid = 15, firstTime = 20, partyBoost = "false"}, -- thunder book
                [2542] = {chance = 5, knight = 15, firstTime = 20, partyBoost = "false"},           -- zvoid shield
                [ITEMID.other.coin] = {chance = {100,50,25}, count = {3,2,5}},                                   -- coin
                [9970] = {chance = {9,9,9,9,9}, count = {}},                                        -- Ice Gem
                [2146] = {chance = {9,9,9,9,9}, count = {}},                                        -- Energy gem
                [2147] = {chance = {9,9,9,9,9}, count = {}},                                        -- fire gem
                [2666] = {chance = 60, count = 2, itemAID = AID.other.food},                        -- meat
                [2674] = {chance = 30, count = 5, itemAID = AID.other.food},                        -- apple
                [2643] = {chance = 15},                                                             -- leather boots
            }
        },
    },
}
centralSystem_registerTable(monster_archanos)


local auraPosConfig = {
    startPosT = {startPoint = "caster"},
    endPosT = {endPoint = "caster", areaConfig = {area = areas["3x3_0"]}}
}
local chargeUpEffect =  {
    position = {
        startPosT = {startPoint = "endPos", endPoint = "endPos"},
        endPosT = {singlePosT = true, endPoint = "caster"},
    },
    effect = 5
}
customSpells["archanos ice aura"] = {
    cooldown = 4000,
    firstCastCD = 4000,
    targetConfig = {"caster"},
    position = auraPosConfig,
	damage = {
        delay = 200,
        minDam = 100,
        maxDam = 100, 
        damType = ICE,
        effect = 42,
        effectOnHit = 44,
    },
    flyingEffect = chargeUpEffect,
    magicEffect = {onTargets = true, effect = 38}
}

customSpells["archanos fire aura"] = {
    cooldown = 4000,
    targetConfig = {"caster"},
    position = auraPosConfig,
	damage = {
        delay = 200,
        minDam = 100,
        maxDam = 100, 
        damType = FIRE,
        effect = 37,
        effectOnHit = 16,
    },
    flyingEffect = chargeUpEffect,
    magicEffect = {onTargets = true, effect = 40}
}

local furthestTarget = {
    startPosT = {startPoint = "caster"},
    endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far"}
}

customSpells["archanos electric shot"] = {
    cooldown = 2000,
    targetConfig = {"enemy"},
    position = furthestTarget,
	damage = {
        minDam = 20,
        maxDam = 60,
        damType = ENERGY,
        effect = 12,
        effectOnHit = 10,
    },
    flyingEffect = {effect = 36},
}

customSpells["archanos teleport"] = {
    cooldown = 15000,
    changeTarget = true,
    targetConfig = {"enemy"},
    position = furthestTarget,
	teleport = {
        targetConfig = {"caster"},
        effectOnCast = 48,
        effectOnPos = 38,
    },
}

customSpells["archanos field bombs"] = {
    cooldown = 3500,
    targetConfig = {"enemy"},
    position = furthestTarget,
    
    changeEnvironment = {
        items = {1502, 1500},
        removeItems = {1502, 1500},
        itemDelay = 3000,
        itemAID = AID.areas.archanosRoom.bossFireField,
        
        damage = {
            hook = true,
            minDam = 300,
            maxDam = 500,
            damType = FIRE,
            effectOnHit = 10,
        },
    },
    flyingEffect = {effect = 38},
}

function archanos_fireField_onStep(creature, item)
    if not creature:isPlayer() then return end
    if item:getId() ~= 1500 then return end
    doDamage(creature, FIRE, math.random(250, 350), 16, O_monster_spells)
    item:remove()
end