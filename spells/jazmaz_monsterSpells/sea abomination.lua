local AIDT = AID.jazmaz.monsters
monsterSpells["sea abomination"] = {
    "sea abomination protect",
    "sea abomination poison",
    "sea abomination bombs",
    "sea abomination summon",
    "sea abomination damage 2",
    "sea abomination damage",
    "sea abomination teleport",
    "sea abomination dispel",
    "heal: cd=6000 p=4",
    "damage: cd=2000 d=20-30 r=4 t=ICE fe=5",
}

customSpells["sea abomination protect"] = {
    cooldown = 10000,
    firstCastCD = 10000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["11x11_0"]},
            checkPath = "solid",
            blockObjects = "solid",
            randomPos = 6,
        },
    },
    changeEnvironment = {
        items = {12568},
        removeItems = {12586, 12590, 12572, 12586, 12574, 12573},
		itemAID = AIDT.seaAbomination_protectRune,
        removeTime = 60000,
        sequenceInterval = 400,
    },
    flyingEffect = {
        effect = 5,
        sequenceInterval = 250,
    },
    magicEffect = {
        effect = {13,2,13},
        effectInterval = 400,
        sequenceInterval = 250,
    },
}

function seaAbomination_protectRune_onUse(player, item)
    if not samePositions(player:getPosition(), item:getPosition()) then return dealDamage(0, player, HOLY, 50, 50, O_monster_spells) end
    doSendMagicEffect(item:getPosition(), {1, 14}, 200)
    return item:remove()
end

function seaAbomination_protectRune_stepOut(creature, item)
    if not creature:isPlayer() then return end
    dealDamage(0, creature, HOLY, 50, 50, O_monster_spells)
end

customSpells["sea abomination poison"] = {
    cooldown = 9000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            areaConfig = {area = areas["5x5_0"], randomPos = 3},
            checkPath = "solid",
            blockObjects = "solid",
        },
    },
    changeEnvironment = {
        items = {12590},
        removeItems = {12590, 12568},
		itemAID = AIDT.seaAbomination_poisonRune,
        removeTime = 40000,
        sequenceInterval = 250,
    },
    flyingEffect = {
        effect = 30,
        sequenceInterval = 250,
    },
    magicEffect = {
        effect = {15,9,15},
        effectInterval = 400,
        sequenceInterval = 250,
    },
}

function seaAbomination_poisonRune(creature, item)
    if not creature:isPlayer() then return end
    dealDamage(0, creature, EARTH, 50, 21, O_monster_spells)
end

customSpells["sea abomination bombs"] = {
    cooldown = 8000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            areaConfig = {area = areas["5x5_0"], randomPos = 4},
            checkPath = "solid",
            blockObjects = "solid",
        },
    },
    changeEnvironment = {
        items = {12572},
        removeItems = {12572, 12568},
		itemAID = AIDT.seaAbomination_bombRune,
        
        changeEnvironment = {
            delay = 5000,
            removeItems = {12572},
            recastPerPos = true,
            passRecastPos = true,
            
            damage = {
                position = {
                    startPosT = {startPoint = "endPos"},
                    endPosT = {
                        endPoint = "endPos",
                        areaConfig = {area = areas["outwards_explosion_3x3_1"]},
                    },
                },
                hook = true,
                interval = 150,
                minDam = 50,
                maxDam = 50,
                damType = FIRE,
                effect = 7,
                effectOnHit = 16,
            }
        }
    },
    flyingEffect = {effect = 5},
    magicEffect = {
        effect = {14,1,14},
        effectInterval = 400,
    },
}

customSpells["sea abomination summon"] = {
    cooldown = 16000,
    firstCastCD = -8000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas["11x11_0"]},
            checkPath = "solid",
            blockObjects = "solid",
            randomPos = 6,
        },
    },
    changeEnvironment = {
        items = {12586},
        removeItems = {12586, 12568},
		itemAID = AIDT.seaAbomination_summonRune,
        removeTime = 10000,
        sequenceInterval = 500,
        
        changeEnvironment = {
            delay = 8000,
            removeItems = {12586},
            recastPerPos = true,
            
            summon = {
                hook = true,
                summons = {["black slime"] = {monsterHP = 1000}},
                maxSummons = 18,
            }
        }
    },
    flyingEffect = {
        effect = 5,
        sequenceInterval = 250,
    },
    magicEffect = {
        effect = {13,2,13},
        effectInterval = 400,
        sequenceInterval = 250,
    },
}

local damageArea = {
    {n, n, 1, n, n},
    {n, n, n, n, n},
    {1, n, 0, n, 1},
    {n, n, n, n, n},
    {n, n, 1, n, n},
}

customSpells["sea abomination damage 2"] = {
    cooldown = 12000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = damageArea},
        },
    },
    changeEnvironment = {
        items = {12574},
		itemAID = AIDT.seaAbomination_damageRune,
		removeItems = {12574, 12573, 12568},
        removeTime = 37000,
        blockObjects = {"solid"},
        recastPerPos = true,
        
        damage = {
            hook = true,
            targetConfig = {"cTarget"},
            onTargets = true,
            minDam = 50,
            maxDam = 50,
            damType = FIRE,
            distanceEffect = 4,
            effect = 7,
            effectOnHit = 5,
        }
    },
    magicEffect = {
        effect = {14,1,14},
        effectInterval = 400,
    },
}

customSpells["sea abomination damage"] = {
    cooldown = 11000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = areas.star_1x1_0},
        },
    },
    changeEnvironment = {
        items = {12573},
		itemAID = AIDT.seaAbomination_damageRune,
		removeItems = {12573, 12574, 12568},
        removeTime = 49000,
        blockObjects = {"solid"},
        recastPerPos = true,
        
        damage = {
            hook = true,
            targetConfig = {"cTarget"},
            onTargets = true,
            minDam = 50,
            maxDam = 50,
            damType = FIRE,
            distanceEffect = 4,
            effect = 7,
            effectOnHit = 5,
        }
    },
    magicEffect = {
        effect = {14,1,14},
        effectInterval = 400,
    },
}

function seaAbomination_rune_onUse(player, item, itemEx)
local itemPos = item:getPosition()
local area = getAreaAround(itemPos)
    
    if tableCount(findFromPos(12568, area)) > 0 then return player:sendTextMessage(GREEN, "Cant remove this rune when protection rune is nearby") end
    doSendMagicEffect(itemPos, {1, 14}, 200)
    return item:remove()
end

customSpells["sea abomination teleport"] = {
    cooldown = 7000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "enemy"},
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_far",
            checkPath = "solid",
        },
    },
    teleport = {
        onTargets = true,
        effectOnCast = 26,
        effectOnPos = 23,
    },
}

customSpells["sea abomination dispel"] = {
    cooldown = 10000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    teleport = {
        position = {
            startPosT = {startPoint = "caster"},
            endPosT = {
                endPoint = "caster",
                areaConfig = {area = areas["5x5_0"]},
                checkPath = "solid",
                blockObjects = "solid",
                randomPos = 1,
            },
        },
        onTargets = true,
        effectOnCast = 26,
        effectOnPos = 23,
        unFocus = true,
    },
    customFeature = {func = "seaAbomination_dispel"},
}

function seaAbomination_dispel(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
    
    for condition, condT in pairs(conditions) do
        if condition == "SLOW" or condition == "DOT_FIRE" or condition == "DOT_EARTH" then
            for param, t in pairs(condT) do
                for ID, subID in pairs(t) do caster:removeCondition(_G[condition], subID) end
            end
        end
    end
end