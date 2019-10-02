local AIDT = AID.quests.rootedCatacombs

local monster_demonSkeleton = {
    bossRoom = {
        upCorner = rootedCatacombsConf.bossRoomUpCorner,
        downCorner = rootedCatacombsConf.bossRoomDownCorner,
        roomAID = AIDT.lever,
        signAID = AIDT.bossProtection,
        highscoreAID = AIDT.highscores,
        bossName = "demon skeleton",
        kickPos = rootedCatacombsConf.kickPos,
--        clearObjects = {11207, 9019},
        respawnCost = 20,
        bountyStr = "demonSkeletonBounty",
        respawnSV = SV.demonSkeletonRespawn,
        killSV = SV.demonSkeletonKill,
        rewardExp = rootedCatacombsConf.rewardExp,
        funcForAID = {
            [AIDT.lever] = "rootedCatacombsBosslever_onUse",
        },
    },
    monsterSpells = {
        ["demon skeleton"] = {
            "demon skeleton death aura",
            "demon skeleton fire aura",
            "demon skeleton bone throw",
            "demon skeleton bone throw target warning",
            "demon skeleton jail",
            "demon skeleton close attack",
            "demon skeleton steal heal",
            "demon skeleton summon skeletons",
        },
    },
    monsters = {
        ["demon skeleton"] = {
            name = "Demon Skeleton",
            reputationPoints = 10,
            race = "undead",
            spawnEvents = defaultBossSpawnEvents,
            bossRoomAID = AIDT.lever,
        },
    },
    monsterLoot = {
        ["demon skeleton"] = {
            storage = SV.demonSkeleton,
            bounty = {[ITEMID.other.coin] = {amount = "demonSkeletonBounty"}},
        },
    },
}
centralSystem_registerTable(monster_demonSkeleton)

local chargeUpEffect =  {
    position = {
        startPosT = {startPoint = "endPos", endPoint = "endPos"},
        endPosT = {singlePosT = true, endPoint = "caster"},
    },
    sequenceInterval = 4,
    effect = 11,
}

local function damageCondition(conditionKey)
    return {
        conditionT = {[conditionKey] = {paramT = {["dam"] = 5, ["interval"] = 1000}}},
        noMonsters = true,
        duration = 10000,
    }
end

customSpells["demon skeleton death aura"] = {
    cooldown = 4000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster", posTFunc = "demonSkeletonDeathAuraArea", blockObjects = {"solid"}}},
    flyingEffect = chargeUpEffect,
	damage = {
        delay = 400,
        interval = 150,
        minDam = 200,
        maxDam = 200, 
        damType = DEATH,
        effect = 18,
        effectOnHit = 18,
        conditions = damageCondition("death")
    },
}

customSpells["demon skeleton fire aura"] = {
    cooldown = 4000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster", posTFunc = "demonSkeletonFireAuraArea", blockObjects = {"solid"}}},
	damage = {
        delay = 400,
        interval = 150,
        minDam = 290,
        maxDam = 200, 
        damType = FIRE,
        effect = 16,
        effectOnHit = 30,
        conditions = damageCondition("fire")
    },
}

local function demonSkeleton_explosionPosT(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT, area)
    local targetList = caster:getEnemies(4)
    local casterPos = caster:getPosition()
    local closestTargetID, closestDistance = getClosestTargetID(casterPos, targetList)
    local distance = closestTargetID and closestDistance or 4
    local areaT = filterArea(area, area, distance)
    return getAreaPos(casterPos, areaT)
end

function demonSkeletonDeathAuraArea(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local area = {
        {n, n, 4, 4, 4, 4, 4, n, n},
        {n, n, n, 3, 3, 3, n, n, n},
        {4, n, n, 2, 2, 2, n, n, 4},
        {4, 3, 2, n, 1, n, 2, 3, 4},
        {4, 3, 2, 1, 0, 1, 2, 3, 4},
        {4, 3, 2, n, 1, n, 2, 3, 4},
        {4, n, n, 2, 2, 2, n, n, 4},
        {n, n, n, 3, 3, 3, n, n, n},
        {n, n, 4, 4, 4, 4, 4, n, n},
    }
    return demonSkeleton_explosionPosT(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT, area)
end

function demonSkeletonFireAuraArea(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local area = {
        {4, 3, n, n, n, 3, 4},
        {3, 2, n, n, n, 2, 3},
        {n, n, 1, n, 1, n, n},
        {n, n, n, 0, n, n, n},
        {n, n, 1, n, 1, n, n},
        {3, 2, n, n, n, 2, 3},
        {4, 3, n, n, n, 3, 4},
    }
    return demonSkeleton_explosionPosT(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT, area)
end

customSpells["demon skeleton bone throw"] = {
    cooldown = 4000,
    targetConfig = {["enemy"] = {obstacles = {"blockThrow"}}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far", getPath = {stopOnPath = {"enemy"}}}
    },
    damage = {
        minDam = 300,
        maxDam = 500,
        damType = PHYSICAL,
        effectOnHit = 1,
        effect = 35,
        distanceEffect = 12,
        distanceEffectLastPos = true,
    },
}

customSpells["demon skeleton bone throw target warning"] = {
    cooldown = 4000,
    firstCastCD = -500,
    targetConfig = {["enemy"] = {obstacles = {"blockThrow"}}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far"}},
    say = {msgFunc = "boneThrowMsg", msgType = ORANGE},
    spellLockCD = {targetConfig = {"caster"}, onTargets = true, [2000] = {"demon skeleton close attack"}},
}

function boneThrowMsg(casterID)
    local caster = Creature(casterID)
    if not caster then return end
    local targetList = caster:getEnemies(10)
    local targetID = getFurthestTargetID(caster:getPosition(), targetList)
    local targetName = Creature(targetID):getName()
    return  "I'm watching you "..targetName.."!!"
end

customSpells["demon skeleton jail"] = {
    cooldown = 120000,
    targetConfig = {["enemy"] = {requiredID = 1}, requiredT = {[1] = 2}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", pointPosFunc = "pointPosFunc_far"}
    },
    customFeature = {func = "demonSkeletonJail"},
}

local boneWallT = {}
function demonSkeletonJail(casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local targetPos = endPosT[1][1]
    local creature = findCreature("creature", targetPos)
    if not creature then return end

    local area = {
        {n, 4, 3, 3, 3, 4, n},
        {4, 3, 2, 2, 2, 3, 4},
        {3, 2, 1, 1, 1, 2, 3},
        {3, 2, 1, 0, 1, 2, 3},
        {3, 2, 1, 1, 1, 2, 3},
        {4, 3, 2, 2, 2, 3, 4},
        {n, 4, 3, 3, 3, 4, n},
    }
    local explosionPosT = getAreaPos(targetPos, area)

    for i, posT in pairs(explosionPosT) do
        for _, pos in pairs(posT) do
            addEvent(doSendMagicEffect, (i-1)*150, pos, 18)
        end
    end
    
    local northWall = findCreature("monster", getDirectionPos(targetPos, "N"))
    if northWall and northWall:getName() == "bone wall" then return dealDamage(0, creature, DEATH, 700, 5, O_environment) end
    
    local southWall = findCreature("monster", getDirectionPos(targetPos, "S"))
    if southWall and southWall:getName() == "bone wall" then return dealDamage(0, creature, DEATH, 700, 5, O_environment) end
    
    local areaAround = getAreaAround(targetPos)
    local looktypes = {6413, 6396, 6396, 6395, 6399, 6396, 6395, 6395} -- in circle sequence
    
    for i, pos in ipairs(areaAround) do
        if not hasObstacle(pos, "solid") then
            local boneWall = createMonster("bone wall", pos)
            boneWall:setOutfit({lookTypeEx = looktypes[i]})
            registerEvent(boneWall, "onHealthChange", "boneWallHealth")
            table.insert(boneWallT, boneWall:getId())
        end
    end
    
    addEvent(boneWallDamage, 5000, targetPos)
end

function boneWallHealth(creature, attacker, damage, damType, origin)
    if damType == LD then return damage end
    if damType ~= PHYSICAL then return 0 end
    damage = -damage
    if damage > 0 then return 0 end
    
    for _, wallID in pairs(boneWallT) do
        if not attacker then attacker = 0 end
        dealDamage(attacker, wallID, LD, damage, 4, O_environment)
    end
    return 0
end

function boneWallDamage(pos)
    local creature = findCreature("creature", pos)    
    if not creature then return end

    addEvent(boneWallDamage, 3000, pos)
    dealDamagePos(0, pos, DEATH, 30, 5, O_environment, 13)
    
    for _, direction in ipairs(compass1) do
        local startPos = getDirectionPos(pos, direction, 2)
        doSendDistanceEffect(startPos, pos, 11)
    end
end

customSpells["demon skeleton close attack"] = {
    cooldown = 1000,
    targetConfig = {["enemy"] = {range = 1}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "caster", areaConfig = {area = areas["3x3_0"]}}
    },
    damage = {
        minDam = 70,
        maxDam = 120,
        damType = PHYSICAL,
        effectOnHit = 1,
        effectOnMiss = 10,
    },
}

customSpells["demon skeleton steal heal"] = {
    cooldown = 4000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy", checkPath = "solid", blockObjects = "solid"},
    },
    changeEnvironment = {
        items = {12568},
        removeItems = {12568},
		itemAID = AID.quests.rootedCatacombs.demonSkeleton_healStealRune,
        removeTime = 12000,
        sequenceInterval = 400,
    },
    flyingEffect = {effect = 5, sequenceInterval = 250},
    magicEffect = {effect = {13,2,13}, effectInterval = 400, sequenceInterval = 250},
}

function demonSkeleton_healStealRune(player, amount)
    if not player:isPlayer() then return end
    if amount < 1 then return end
    local boss = Creature("demon skeleton")
    if not boss then return end

    local playerPos = player:getPosition()
    if not findItem(nil, playerPos, AID.quests.rootedCatacombs.demonSkeleton_healStealRune) then return end
    
    doSendDistanceEffect(playerPos, boss:getPosition(), 5)
    return heal(boss, amount)
end

customSpells["demon skeleton summon skeletons"] = {
    cooldown = 60000,
    firstCastCD = -20000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["11x11_0"]},
            checkPath = "solid",
            blockObjects = "solid",
            randomPos = 3,
        },
    },
    summon = {
        delay = 3000,
        summons = {
            ["skeleton"] = {amount = 2, monsterHP = 2000},
            ["skeleton warrior"] = {amount = 1, monsterHP = 3000},
        },
        maxSummons = 6,
        summonAmount = 3,
    },
    flyingEffect = {effect = 5, sequenceInterval = 250},
    magicEffect = {effect = {13,2,13,13,2,13}, effectInterval = 400, sequenceInterval = 250},
}