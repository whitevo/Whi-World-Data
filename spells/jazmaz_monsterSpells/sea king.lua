-- buffs damage: config in bufferMonsters() function
monsterSpells["sea king"] = {
    "sea king wave",
    "sea king summon",
    "sea king lightning strike",
    "sea king tower1",
    "sea king tower2",
    "sea king tower3",
    "sea king full hp",
    "square_5x5_1 effects 15",
    "sea king no attack field",
    "heal: cd=5000 p=6",
    "damage: cd=2000 d=20-30",
}

local waveArea = {
    {5, 5, n, n, n, n, n, n, n, 5, 5},
    {n, 4, 4, n, n, n, n, n, 4, 4, n},
    {n, n, 3, 3, n, n, n, 3, 3, n, n},
    {n, n, n, 2, 2, n, 2, 2, n, n, n},
    {n, n, n, n, 1, n, 1, n, n, n, n},
    {n, n, n, n, n, 0, n, n, n, n, n},
    {n, n, n, n, 1, n, 1, n, n, n, n},
}

customSpells["sea king wave"] = {
    cooldown = 22000,
    firstCastCD = -10000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = waveArea},
        }
    },
    damage = {
        interval = 200,
        minDam = 40,
        maxDam = 100, 
        damType = ICE,
        effect = {31, 38},
        effectOnHit = 44,
    },
}

customSpells["sea king summon"] = {
    cooldown = 22000,
    firstCastCD = -13000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas.areaAround},
            randomPos = 2,
        }
    },
    summon = {
        summons = {
			["sea guard"] = {amount = 1},
		},
		maxSummons = 5,
    },
	flyingEffect = {effect = 37},
    magicEffect = {effect = 26},
}

customSpells["sea king lightning strike"] = {
    cooldown = 5000,
    targetConfig = {["cTarget"] = {range = 2}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {range = 2, endPoint = "cTarget"},
    },
    damage = {
        onTargets = true,
        minDam = 30,
        maxDam = 30,
        damType = ENERGY,
		distanceEffect = 36,
        effect = 31,
        
        damage = {
            targetConfig = {"enemy"},
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {
                    endPoint = "enemy",
                    range = 3,
                    blockObjects = "previousEndPos",
                },
            },
            minDam = 30,
            maxDam = 30,
            damType = ENERGY,
            distanceEffect = 36,
            effect = 31,
            recastPerPos = true,
            
            damage = {
                hook = true,
                position = {
                    startPosT = {startPoint = "endPos"},
                    endPosT = {
                        range = 3,
                        endPoint = "enemy",
                        blockObjects = "previousEndPos",
                    },
                },
                minDam = 30,
                maxDam = 30,
                damType = ENERGY,
                distanceEffect = 36,
                effect = 31,
            }
        }
    }
}

local buildTower = {
    {n, n,     1, n, n},
    {n, n,     2, n, n},
    {1, 2, {0,3}, 2, 1},
    {n, n,     2, n, n},
    {n, n,     1, n, n},
}

local tower1 = {
    {1},
    {n},
    {n},
    {n},
    {0},
}
local tower2 = {
    {0,n,n},
    {n,n,n},
    {n,n,1},
}
local tower3 = {
    {1,n,n,n},
    {n,n,n,n},
    {n,n,n,0},
}
local summonConf = {
    delay = 1000,
    summons = {
        ["sea king tower"] = {amount = 1}
    },
    maxSummons = 5,
    
    flyingEffect = {
        hook = true,
        effect = 12
    },
    magicEffect = {
        hook = true,
        position = {
            startPosT = {startPoint = "endPos"},
            endPosT = {
                endPoint = "endPos",
                areaConfig = {area = buildTower},
                blockObjects = "solid",
            }
        },
        effect = {10, 27},
        effectInterval = 150,
        waveInterval = 300,
    }
}

customSpells["sea king tower1"] = {
    cooldown = 30000,
    firstCastCD = -15000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = tower1, useStartPos = true},
            blockObjects = "solid",
        }
    },
    summon = summonConf,
}

customSpells["sea king tower2"] = {
    cooldown = 30000,
    firstCastCD = -15000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = tower2, useStartPos = true},
            blockObjects = "solid",
        }
    },
    summon = summonConf,
}

customSpells["sea king tower3"] = {
    cooldown = 30000,
    firstCastCD = -15000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = tower3, useStartPos = true},
            blockObjects = "solid",
        }
    },
    summon = summonConf,
}

customSpells["sea king full hp"] = {
    cooldown = 5000,
    changeTarget = true,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    customFeature = {func = "seaKing_fullHP"}
}

function seaKing_fullHP(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local maxHP = caster:getMaxHealth()
local hp = caster:getHealth()
    if maxHP/5 < hp then return end
local casterID = caster:getId()
    
    local function healBoss(casterID)
        local caster = Creature(cid)
        if not caster then return end
        local casterPos = caster:getPosition()
        local area = getAreaPos(casterPos, areas.inwards_explosion_3x3)
        
        addEvent(heal, 2000, casterID, maxHP)
        
        for i, posT in ipairs(area) do
            for _, pos in pairs(posT) do
                addEvent(doSendMagicEffect, i*400, pos, {13, 22}, 250)
            end
        end
    end
    featureT = {
        lockSpells = {"sea king full hp"},
        unlockSpells = {},
    }
    spellCreatingSystem_onTarget_spellLock(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    caster:say("AAARGH got to heal myself!!", ORANGE)
    addEvent(creatureSay, 5000, casterID, "Just a little more!!", YELLOW)
    addEvent(creatureSay, 8000, casterID, "YAAAS the power is here!!", ORANGE)
    root(casterID, 10000)
    addEvent(healBoss, 8000, casterID)    
end
    
local fieldArea1 = {
    {n,1,n},
    {1,1,1},
    {n,0,n},
}
local fieldArea2 = {
    {n,1,n},
    {1,1,1},
    {n,1,0},
}

customSpells["sea king no attack field"] = {
    cooldown = 15000,
    firstCastCD = -10000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {
                area = fieldArea1,
				relativeArea = fieldArea2,
				useStartPos	= true,
            }
        }
    },
    changeEnvironment = {
        items = {2262},
        itemAID = AID.jazmaz.monsters.seaGuard_field,
        removeTime = 30000,
    },
    magicEffect = {
        effect = {14,14,14,14,14,14,14,14,14,14,14},
        effectInterval = 3000,
    },
}

customSpells["square_5x5_1 effects 15"] = {
    cooldown = 4000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["square_5x5_1"]},
        }
    },
    magicEffect = {effect = 15, waveInterval = 200},
}