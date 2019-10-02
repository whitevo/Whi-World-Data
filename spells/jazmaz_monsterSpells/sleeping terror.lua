monsterSpells["sleeping terror"] = {
    "sleeping terror ragemode",
    "sleeping terror water wave",
    "sleeping terror big water wave",
    "sleeping terror water bomb",
    "sleeping terror heal pool",
    "sleeping terror towers",
    "heal: cd=15000, p=5",
    "damage: cd=3000, d=50-50, r=2, t=ICE, fe=11",
}

customSpells["sleeping terror ragemode"] = {
    cooldown = 10000,
    changeTarget = true,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    customFeature = {func = "sleepingTerror_changeOutfit"}
}

function sleepingTerror_changeOutfit(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local maxHP = caster:getMaxHealth()
local hp = caster:getHealth()
    if maxHP/2 < hp then return end
local outfit = caster:getOutfit()
    
    if outfit.lookType == 593 then return end
local positions = getAreaAround(caster:getPosition())
local casterID = caster:getId()

    featureT = {
        lockSpells = {"sleeping terror ragemode", "sleeping terror water wave"},
        unlockSpells = {"sleeping terror big water wave", "sleeping terror heal pool"},
    }
    spellCreatingSystem_onTarget_spellLock(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    outfit.lookType = 593
    caster:setOutfit(outfit)
    caster:say("ROOOOAR", ORANGE)
    for _, pos in ipairs(positions) do dealDamagePos(casterID, pos, ICE, math.random(100, 200), 12, O_monster_spells, {38,31}) end
end

local smallWave = {
    {6,  6,  6,  6,  6,  6,  6},
    {5,  5,  5,  5,  5,  5,  5},
    {n,  4,  4,  4,  4,  4,  n},
    {n,  3,  3,  3,  3,  3,  n},
    {n,  2,  2,  2,  2,  2,  n},
    {n,  n,  1,  1,  1,  n,  n},
    {n,  n,  n,  0,  n,  n,  n},
}
local bigWave = {
    {7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7},
    {6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6},
    {n, 5, 5, 5, 5, 5, 5, 5, 5, 5, n},
    {n, 4, 4, 4, 4, 4, 4, 4, 4, 4, n},
    {n, n, 3, 3, 3, 3, 3, 3, 3, n, n},
    {n, n, n, 2, 2, 2, 2, 2, n, n, n},
    {n, n, n, 2, 1, 0, 1, 2, n, n, n},
    {n, n, n, n, 1, 1, 1, n, n, n, n},
}

customSpells["sleeping terror water wave"] = {
    cooldown = 10000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = smallWave},
        }
    },
    damage = {
        delay = 850,
        interval = 200,
        minDam = 50,
        maxDam = 100, 
        damType = ICE,
        effect = {2,11},
        effectOnHit = 38,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*shiii*",
        msgType = ORANGE,
    },
}
customSpells["sleeping terror big water wave"] = {
    cooldown = 8000,
    locked = true,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = bigWave},
        }
    },
    damage = {
        delay = 850,
        interval = 200,
        minDam = 50,
        maxDam = 100, 
        damType = ICE,
        effect = {2,11},
        effectOnHit = 38,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*shiii*",
        msgType = ORANGE,
    },
}

local bombArea = {
    {n,  n,  n,  3,  n,  n,  n},
    {n,  n,  3,  2,  3,  n,  n},
    {n,  3,  2,  1,  2,  3,  n},
    {3,  2,  1,  0,  1,  2,  3},
    {n,  3,  2,  1,  2,  3,  n},
    {n,  n,  3,  2,  3,  n,  n},
    {n,  n,  n,  3,  n,  n,  n},
    
}
customSpells["sleeping terror water bomb"] = {
    cooldown = 8000,
    targetConfig = {
        ["enemy"] = {range = 6, obstacles = "solid"},
    },
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "enemy"},
    },
    damage = {
        delay = 300,
        minDam = 40,
        maxDam = 80,
        damType = ICE,
        effect = 2,
        effectOnHit = 11,
        
        changeEnvironment = {
            items = {12661},
            itemAID = AID.jazmaz.monsters.sleepingTerror_bomb,
            removeTime = 3000,
        },
        damage = {
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {
                    endPoint = "endPos",
                    areaConfig = {area = bombArea},
                },
            },
            delay = 3000,
            interval = 200,
            minDam = 50,
            maxDam = 100,
            damType = ICE,
            effect = {10,12},
            effectOnHit = 11,
            distanceEffect = 5,
        },
    },
    flyingEffect = {effect = 5},
    magicEffect = {
        effect = {31,31,31},
        effectInterval = 1000,
    },
}

local poolArea = {
    {n, n, 5, 4, 5, n, n},
    {n, 5, 3, 2, 3, 5, n},
    {n, 4, 2, 1, 2, 4, n},
    {n, 5, 3, 2, 3, 5, n},
    {n, n, 5, 4, 5, n, n},
}

customSpells["sleeping terror heal pool"] = {
    cooldown = 15000,
    locked = true,
    targetConfig = {
        ["caster"] = {obstacles = {"solid"}},
    },
    position = {
        startPosT = {
            startPoint = "caster",
            areaConfig = {area = poolArea},
            blockObjects = "solid",
        },
    },
    changeEnvironment = {
        items = {8302},
        itemAID = AID.jazmaz.monsters.sleepingTerror_heal,
        interval = 200,
        removeTime = 8000,
    },
    magicEffect = {
        effect = {13,13,13,13,13,13,13,13},
        effectInterval = 1000,
        waveInterval = 200,
    },
    heal = {
		effect = 2,
        minHeal = 50,
        maxHeal = 100,
        healTarget = "monster",
        executeAmount = 8,
        repeatInterval = 1000,
    }
}

local towerPositions = {
    {1, n, n, n, n, n, 1},
    {n, n, n, n, n, n, n},
    {n, n, n, n, n, n, n},
    {n, n, n, 0, n, n, n},
    {n, n, n, n, n, n, n},
    {n, n, n, n, n, n, n},
    {1, n, n, n, n, n, 1},
}
local buildTower = {
    {n, n,     1, n, n},
    {n, n,     2, n, n},
    {1, 2, {0,3}, 2, 1},
    {n, n,     2, n, n},
    {n, n,     1, n, n},
}
local towerDamageArea = {
    {n, n, n, 4, n, n, n},
    {n, n, 4, 3, 4, n, n},
    {n, 4, 3, 2, 3, 4, n},
    {4, 3, 2, 1, 2, 3, 4},
    {n, 4, 3, 2, 3, 4, n},
    {n, n, 4, 3, 4, n, n},
    {n, n, n, 4, n, n, n},
}
customSpells["sleeping terror towers"] = {
    cooldown = 30000,
    firstCastCD = -25000,
    changeTarget = true,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = towerPositions},
            blockObjects = "solid",
        }
    },
    flyingEffect = {effect = 13},
    changeEnvironment = {
        delay = 1000,
        items = {21580},
        itemAID = AID.jazmaz.monsters.sleepingTerror_tower,
        removeTime = 25000,
    },
    magicEffect = {
        position = {
            startPosT = {startPoint = "endPos"},
            endPosT = {
                endPoint = "endPos",
                areaConfig = {area = buildTower},
                blockObjects = "solid",
            }
        },
        effect = {2, 26},
        effectInterval = 150,
		waveInterval = 300,
    },
    damage = {
        position = {
            startPosT = {
                startPoint = "endPos",
            },
            endPosT = {
                endPoint = "endPos",
                areaConfig = {area = towerDamageArea},
                blockObjects = "solid",
            },
        },
        delay = 3000,
        interval = 250,
        minDam = 50,
        maxDam = 100,
        damType = ICE,
        effect = 11,
        effectOnHit = 12,
        executeAmount = 5,
        repeatInterval = 5000,
    }
}