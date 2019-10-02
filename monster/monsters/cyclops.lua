local monster_cyclops = {
    monsterSpells = {
        ["cyclops"] = {
            "cyclops pick stone",
            "cyclops throw stone",
            "cyclops leap",
            "cyclops stun",
            "heal: cd=7000, p=5%",
            "damage: cd=2000, d=35-70, r=2",
            finalDamage = 5,
        },
    },
    monsters = {
        ["cyclops"] = {
            name = "Cyclops",
            reputationPoints = 3,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                killsRequired = 8,
                storageID = SV.cyclopsTask,
                storageID2 = SV.cyclopsTaskOnce,
                skillPoints = 1,
                location = "east Cyclops mountain",
                reputation = 12,
            },
        },
    },
    monsterResistance = {
        ["cyclops"] = {
            PHYSICAL = -30,
            ICE = -20,
            FIRE = 20,
            ENERGY = -20,
            DEATH = -40,
            EARTH = -80,
        },
    },
    monsterLoot = {
        ["cyclops"] = {
            storage = SV.cyclops,
            items = {
                [5958] = {chance = 1, hunter = 3, itemAID = {AID.spells.volley, AID.spells.opaldef, AID.spells.buff}, firstTime = 3},
                [15409] = {chance = 3, knight = 5.5, firstTime = 4, partyBoost = "false"},  -- intrinsic legs
                [11304] = {chance = 3, mage = 5.5, firstTime = 4, partyBoost = "false"},    -- genso fedo
                [3983] = {chance = 3, druid = 5.5, firstTime = 4, partyBoost = "false"},    -- speedzy legs
                [2553] = {chance = 20, itemAID = AID.other.tool, itemText = "charges(2)"},  -- pickaxe
                [2666] = {chance = {24,12}, itemAID = AID.other.food, count = {1,2}},       -- meat
                [2671] = {chance = 15, itemAID = AID.other.food},                           -- ham
                [ITEMID.other.coin] = {chance = {15,15,15}, count = {}},
                [2800] = {chance = 22, itemAID = 2071},                                     -- Herb: ozeogon
                [2263] = {chance = 4, mage = 4},                                            -- death stone
                [2271] = {chance = 4, mage = 4},                                            -- energy stone
                [1294] = {chance = 40},                                                     -- small stone
                [2267] = {chance = 25},                                                     -- armor stone T1
                [2265] = {chance = 5},                                                      -- armor stone T2
                [5880] = {chance = 50},                                                     -- copper ore
                [2050] = {chance = 20},                                                     -- torch
                [7464] = {chance = 8},                                                      -- fur shorts
            }
        },
    }
}
centralSystem_registerTable(monster_cyclops)

customSpells["cyclops stun"] = {
    cooldown = 7000,
    targetConfig = {["enemy"] = {range = 1}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "caster", areaConfig = {area = areas["3x3_0"]}}
    },
    damage = {
        minDam = 30,
        maxDam = 80,
        minScale = 15,
        maxScale = 20,
        damType = PHYSICAL,
        effectOnHit = 1,
        effectOnMiss = 10,
        stunOnHook = true,
        stunDuration = 5000,
        stunL = 1,
        flyingEffect = {effect = 11},
    },
    say = {targetConfig = {"caster"}, onTargets = true, msg = "*stomp*", msgType = ORANGE},
    magicEffect = {targetConfig = {"caster"}, onTargets = true, effect = 4},
}

customSpells["cyclops leap"] = {
    cooldown = 10*1000,
    changeTarget = true,
    targetConfig = {enemy = {range = 5, getPath = true, obstacles = "blockThrow"}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far"}
    },
    magicEffect = {effect = {8,8,8,8,6}, effectInterval = 500},
    damage = {
        delay = 2500,
        minDam = 100,
        maxDam = 150,
        minScale = 100,
        maxScale = 150,
        damType = PHYSICAL,
        effectOnHit = 10,
        effectOnMiss = 35,
        
        say = {msg = "leap"},
        teleport = {targetConfig = {"caster"}, effectOnCast = 39},
        magicEffect = {
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {endPoint = "endPos", areaConfig = {area = areas["5x5_1 circle"]}}
            },
            effect = 3,
            waveInterval = 150,
        }
    },
}

customSpells["cyclops pick stone"] = {
    cooldown = 5000,
    targetConfig = {
        [{1357, 3607, 3609, 3615, 3616, 3666, 3667, 3668}] = {range = 1, requiredID = 1},
        ["enemy"] = {requiredID = 2},
    },
    position = {
        startPosT = {
            startPoint = "caster",
            areaConfig = {area = areas["3x3_0"]},
            onlyItemPos = {3666, 3667, 3668, 1357, 3609, 3616, 3615, 3607},
            randomPos = 1,
        }
    },
    changeEnvironment = {
        removeItems = {3666, 3667, 3668, 1357, 3609, 3616, 3615, 3607},
        spawnTime = 2*60*1000, -- time it with dagosil
        customFuncOnRemove = "cyclopsDagosil",
        say = {msg = "*grab*", hook = true},
        spellLock = {targetConfig = {"caster"}, onTargets = true, hook = true, lockSpells = "cyclops pick stone", unlockSpells = "cyclops throw stone"},
        spellLockCD = {targetConfig = {"caster"}, onTargets = true, hook = true, [4] = "cyclops throw stone"},
        event = {targetConfig = {"caster"}, onTargets = true, hook = true, register = {onDeath = "cyclops_corpseStone"}},
        magicEffect = {effect = 39}
    }
}

customSpells["cyclops throw stone"] = {
    cooldown = 4000,
    locked = true,
    targetConfig = {["enemy"] = {obstacles = {"blockThrow"}}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far"}
    },
    damage = {
        onTargets = true,
        formulaFunc = "cyclopsDamage",
        damType = PHYSICAL,
        effectOnHit = 1,
        effect = 35,
        distanceEffect = 12,
    },
    changeEnvironment = {
        position = {startPosT = {startPoint = "endPos", areaConfig = {area = areas["3x3_0"]}, randomPos = 3}},
        items = {3649, 3650, 3651},
        itemAID = AID.other.cyclopsDebris,
        randomised = true,
        removeTime = 60000,
        magicEffect = {effect = 35}
    },
    spellLock = {targetConfig = {"caster"}, onTargets = true, lockSpells = "cyclops throw stone", unlockSpells = "cyclops pick stone"},
    spellLockCD = {targetConfig = {"caster"}, onTargets = true, [4000] = "cyclops pick stone"},
    event = {targetConfig = {"caster"}, onTargets = true, unregister = {onDeath = "cyclops_corpseStone"}},
}

function cyclopsDamage(caster, target, targetPos)
    local distance = getDistanceBetween(caster:getPosition(), targetPos)
    local mainDam = 90
    local shortDistanceDamage = mainDam-distance*35
    if shortDistanceDamage < 0 then shortDistanceDamage = -shortDistanceDamage end
    local longDistanceDamage = -shortDistanceDamage+distance*50
    local minDam = mainDam + shortDistanceDamage + longDistanceDamage - (4-distance)*20
    local maxDam = minDam + distance*30
    if distance ~= 2 then return minDam, maxDam end

    local reduceAmount = 50
    return minDam-reduceAmount, maxDam-reduceAmount
end


function cyclops_corpseStone(creature)
    local pos = creature:getPosition()
    createItem(1293, pos, 1, AID.other.cyclopsStone)
    addEvent(removeItemFromPos, 2*60*1000, 1293, pos)
end

function cyclops_destroyCorpseStone(player, tool, stone)
    if not stone:isItem() then return end
    if stone:getActionId() ~= AID.other.cyclopsStone then return end
    tools_addCharges(player, tool, -1)
    doSendMagicEffect(stone:getPosition(), {27,3})
    stone:remove()
end