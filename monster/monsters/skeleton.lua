local monster_skeleton = {
    registerEvent = {
        onDeath = {skeleton = "skeleton_explosion"}
    },
    monsters = {
        ["skeleton"] = {
            name = "Skeleton",
            reputationPoints = 4,
            race = "undead",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 3,
                killsRequired = 10,
                storageID = SV.skeletonTask,
                storageID2 = SV.skeletonTaskOnce,
                skillPoints = 1,
                location = "South from Forgotten Village",
                reputation = 10,
            }
        },
    },
    monsterSpells = {
        ["skeleton"] = {
            "skeleton pick bone",
            "skeleton throw bone",
            "skeleton heal",
            "skeleton speed",
            "skeleton damage",
            "skeleton damage buff",
            finalDamage = 8,
        },
    },
    monsterResistance = {
        ["skeleton"] = {
            PHYSICAL = 20,
            ICE = 50,
            FIRE = 75,
            ENERGY = 50,
            DEATH = 90,
            HOLY = -50,
            EARTH = 80,
        },
    },
    monsterLoot = {
        ["skeleton"] = {
            storage = SV.skeleton,
            items = {
                [5958] = {chance = 4, druid = 3,  itemAID = {AID.spells.innervate, AID.spells.onyxdef, AID.spells.taunt, AID.spells.imp}, firstTime = 3},
                [18398] = {chance = 2, hunter = 4, firstTime = 6, partyBoost = "false"},        -- blessed hood
                [9735] = {chance = 2,  knight = 4, firstTime = 6, partyBoost = "false"},        -- blessed iron helmet
                [12442] = {chance = 2, druid = 4,  firstTime = 6, partyBoost = "false"},        -- blessed turban
                [10570] = {chance = 2, mage = 4,   firstTime = 6, partyBoost = "false"},        -- amanita hat
                [ITEMID.other.coin] = {chance = {45,30}, count = {2,5}},                                     -- coin
                [5925] = {chance = 25},                                                         -- skeleton bone
                [2150] = {chance = 5},                                                          -- death gem
            }
        },
    },
}
centralSystem_registerTable(monster_skeleton)

function skeleton_explosion(creature)
    local bones = {
        2230,   -- throw bone
        2231,   -- healing bone
        21407,  -- speed bone
        21408,  -- damage bone
    }
    local explosionTime = 1000
    local explosionMinDam = 300
    local explosionMaxDam = 500
    local itemTravelTime = 200
    local itemRemoveTime = 3*60*1000 -- 3 mins
    local boneAmount = 10
    local boneMinDam = 80
    local boneMaxDam = 180
    local creaturePos = creature:getPosition()
    local tempArea = getAreaPos(creaturePos, areas["6x6_0 circle"])
    local area = removePositions(tempArea, "solid")
    local bonePositions = randomPos(area, boneAmount)
    local nearPositions = getAreaAround(creaturePos)

    for x=0, math.floor(explosionTime/350) do addEvent(doSendMagicEffect, x*300, creaturePos, 3) end
    for _, pos in pairs(nearPositions) do addEvent(dealDamagePos, explosionTime, 0, pos, PHYSICAL, math.random(explosionMinDam, explosionMaxDam), 10, O_monster_procs_player, 4, 3) end
    
    for _, pos in pairs(bonePositions) do
        local delay = math.random(0, 1) * 150
        local boneID = bones[math.random(#bones)]
        
        addEvent(doSendDistanceEffect, explosionTime + delay, creaturePos, pos, 37)
        addEvent(createItem, itemTravelTime + explosionTime + delay, boneID, pos)
        addEvent(removeItemFromPos, itemTravelTime + explosionTime + delay + itemRemoveTime, boneID, pos)
        addEvent(dealDamagePos, itemTravelTime + explosionTime + delay, 0, pos, PHYSICAL, math.random(boneMinDam, boneMaxDam), 4, O_monster_procs_player)
    end
end

customSpells["skeleton pick bone"] = {
    cooldown = 4000,
    targetConfig = {[2230] = {range = 1}, "enemy"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_1"]}, onlyItemPos = {2230}, randomPos = 1}},
    changeEnvironment = {
        removeItems = {2230},
        say = {msg = "*grab*", hook = true},
        magicEffect = {effect = 39},
        spellLock = {
            targetConfig = {"caster"},
            onTargets = true,
            hook = true,
            lockSpells = "skeleton pick bone",
            unlockSpells = "skeleton throw bone",
        },
    }
}

customSpells["skeleton throw bone"] = {
    cooldown = 1000,
    locked = true,
    targetConfig = {["cTarget"] = {obstacles = {"blockThrow"}}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    spellLock = {targetConfig = {"caster"}, onTargets = true, lockSpells = "skeleton throw bone", unlockSpells = "skeleton pick bone"},
    changeEnvironment = {onTargets = true, items = {2230}, removeTime = 30000},
    damage = {
        onTargets = true,
        minDam = 70,
        maxDam = 120,
        damType = PHYSICAL,
        effectOnHit = 4,
        distanceEffect = 10,
    }
}

customSpells["skeleton heal"] = {
    cooldown = 4000,
    targetConfig = {[2231] = {range = 1}, "caster"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_1"]}, onlyItemPos = {2231}, randomPos = 1}},
    changeEnvironment = {
        removeItems = {2231},
        say = {msg = "*grab*", hook = true},
        magicEffect = {effect = 39},
        heal = {
            targetConfig = {"caster"},
            onTargets = true,
            hook = true,
            effect = 15,
            minHeal = 500,
            maxHPMultiplier = -2,
            maxHPLimit = 6000,
        },
    }
}

customSpells["skeleton speed"] = {
    cooldown = 3000,
    targetConfig = {[21407] = {range = 1}, "caster"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_1"]}, onlyItemPos = {21407}, randomPos = 1}},
    changeEnvironment = {
        removeItems = {21407},
        say = {msg = "*grab*", hook = true},
        magicEffect = {effect = 39},
        conditions = {
            targetConfig = {"caster"},
            onTargets = true,
            hook = true,
            conditionT = {["monsterHaste"] = {paramT = {speed = 20}, duration = 30000, maxStack = 10}},
        }
    }
}

customSpells["skeleton damage"] = {
    cooldown = 2500,
    targetConfig = {["cTarget"] = {range = 1}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    damage = {onTargets = true, formulaFunc = "skeletonDamage", damType = PHYSICAL, effectOnHit = 1},
}

customSpells["skeleton damage buff"] = {
    cooldown = 3000,
    targetConfig = {[21408] = {range = 1}, "caster"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_1"]}, onlyItemPos = {21408}, randomPos = 1}},
    changeEnvironment = {
        removeItems = {21408},
        say = {msg = "*grab*", hook = true},
        magicEffect = {effect = 39},
        customFeature = {hook = true, func = "customFeature_skeletonDamageBuff"}
    }
}
    
local skeletonDamT = {} -- [cid] = {minDam = INT, maxDam = INT}
function customFeature_skeletonDamageBuff(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local damT = skeletonDamT[cid]
    local minDam = 100
    local maxDam = 150
    
    if not damT then
        skeletonDamT[cid] = {minDam = minDam, maxDam = maxDam}
        damT = skeletonDamT[cid]
    end

    local currentMinDam = damT.minDam
    local currentMaxDam = damT.maxDam
    local newMinDam = currentMinDam + 10
    local newMaxDam = currentMaxDam + 20

    if newMinDam > minDam*2 then newMinDam = minDam*2 end
    if newMaxDam > maxDam*2 then newMaxDam = maxDam*2 end
    damT.minDam = newMinDam
    damT.maxDam = newMaxDam
end

function skeletonDamage(caster, target, targetPos)
    local cid = caster:getId()
    local damT = skeletonDamT[cid]
    if damT then return damT.minDam, damT.maxDam end
    
    local minDam = 100
    local maxDam = 150
    skeletonDamT[cid] = {minDam = minDam, maxDam = maxDam}
    return minDam, maxDam
end