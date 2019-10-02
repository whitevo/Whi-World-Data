monsterSpells["water dragon"] = {
    "water dragon transform",
    "water dragon eruption",
    "water dragon bubble",
    "water dragon wave",
    "water dragon summon",
    "heal: cd=6000 p=4",
    "damage: cd=2000 d=20-30 r=4 t=ICE fe=5",
    "damage: cd=3000 d=60 r=3 t=ICE fe=5 c=10",
}

customSpells["water dragon transform"] = {
    cooldown = 10000,
    firstCastCD = -5000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_far",
        }
    },
    customFeature = {
		func = "waterDragonTransform",
        outfitType = 286,
        duration = 6000,
	},
}

function waterDragonTransform(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local targetID = findCreatureID("player", endPosT[1][1])
    if not targetID then return end
local target = Creature(targetID)
local outfit = target:getOutfit()

    if outfit.lookType == featureT.outfitType then return end
    addEvent(doSetOutfit, featureT.duration, targetID, target:getOutfit())
    playerPreviousOutfit[targetID] = target:getOutfit()
    outfit.lookType = featureT.outfitType
    doSetOutfit(targetID, outfit)
    registerEvent(targetID, "onThink", "waterDragonTransform_damage")
    addEvent(unregisterEvent, featureT.duration, targetID, "onThink", "waterDragonTransform_damage")
end

function waterDragonTransform_damage(creature)
local friendList = creature:getFriends(3)

    for _, playerID in pairs(friendList) do dealDamage(0, playerID, ICE, 100, 11, O_monster_spells, 3, 29) end
end

local eruptionArea = {
    { n,  n, 1,  n,  n},
    { n,  2, 3,  2,  n},
    { 1,  3, {0,4},  3,  1},
    { n,  2, 3,  2,  n},
    { n,  n, 1,  n,  n},
}

customSpells["water dragon eruption"] = {
    cooldown = 5000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            areaConfig = {area = eruptionArea},
        }
    },
    damage = {
        position = {
            startPosT = {startPoint = "caster"},
            endPosT = {endPoint = "enemy"}
        },
        delay = 750,
        minDam = 50,
        maxDam = 100, 
        damType = ICE,
        effect = 43,
    },
    magicEffect = {
        effect = {2,12},
        effectInterval = 250,
		waveInterval = 250,
    },
}

local bubbleOutsideArea = {
    {n,  n,  n,  n,  8,  7,  6,  6,  6,  6,  6,  6,  7,  8,  n,  n,  n,  n},
    {n,  n,  n,  8,  7,  6,  5,  5,  5,  5,  5,  5,  6,  7,  8,  n,  n,  n},
    {n,  n,  8,  7,  6,  5,  4,  4,  4,  4,  4,  4,  5,  6,  7,  8,  n,  n},
    {n,  8,  7,  6,  5,  4,  3,  3,  3,  3,  3,  3,  4,  5,  6,  7,  8,  n},
    {8,  7,  6,  5,  4,  3,  2,  2,  2,  2,  2,  2,  3,  4,  5,  6,  7,  8},
    {7,  6,  5,  4,  3,  2,  1,  1,  1,  1,  1,  1,  2,  3,  4,  5,  6,  7},
    {6,  5,  4,  3,  2,  1,  1,  n,  n,  n,  1,  1,  2,  3,  3,  4,  5,  6},
    {6,  5,  4,  3,  2,  1,  n,  n,  n,  n,  n,  1,  2,  3,  3,  4,  5,  6},
    {6,  5,  4,  3,  2,  1,  n,  n,  0,  n,  n,  1,  2,  3,  3,  4,  5,  6},
    {6,  5,  4,  3,  2,  1,  n,  n,  n,  n,  n,  1,  2,  3,  3,  4,  5,  6},
    {6,  5,  4,  3,  2,  1,  1,  n,  n,  n,  1,  1,  2,  3,  3,  4,  5,  6},
    {7,  6,  5,  4,  3,  2,  1,  1,  1,  1,  1,  1,  2,  3,  4,  5,  6,  7},
    {8,  7,  6,  5,  4,  3,  2,  2,  2,  2,  2,  2,  3,  4,  5,  6,  7,  8},
    {n,  8,  7,  6,  5,  4,  3,  3,  3,  3,  3,  3,  4,  5,  6,  7,  8,  n},
    {n,  n,  8,  7,  6,  5,  4,  4,  4,  4,  4,  4,  5,  6,  7,  8,  n,  n},
    {n,  n,  n,  8,  7,  6,  5,  5,  5,  5,  5,  5,  6,  7,  8,  n,  n,  n},
    {n,  n,  n,  n,  8,  7,  6,  6,  6,  6,  6,  6,  7,  8,  n,  n,  n,  n},
}

customSpells["water dragon bubble"] = {
    cooldown = 25000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = bubbleOutsideArea},
        }
    },
    damage = {
        delay = 3000,
        interval = 200,
        minDam = 50,
        maxDam = 100, 
        damType = ICE,
        effect = 31,
        effectOnHit = 38,
        executeAmount = 4,
        repeatInterval = 1000,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*zing*",
        msgType = ORANGE,
    },
    root = {
        targetConfig = {"caster"},
        onTargets = true,
        msDuration = 7000,
    },
    magicEffect = {
        effect = {2,2,2},
        effectInterval = 800,
		waveInterval = 150,
    },
}

customSpells["water dragon summon"] = {
    cooldown = 25000,
    firstCastCD = -15000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        onTargets = true,
        summons = {
			["big water element"] = {amount = 2},
		},
		maxSummons = 3,
    },
    say = {
        onTargets = true,
        msg = "*wush*",
        msgType = ORANGE,
    },
}

local smallWave = {
    {6,  6,  6,  6,  6,  6,  6},
    {5,  5,  5,  5,  5,  5,  5},
    {n,  4,  4,  4,  4,  4,  n},
    {n,  3,  3,  3,  3,  3,  n},
    {n,  2,  2,  2,  2,  2,  n},
    {n,  n,  1,  1,  1,  n,  n},
    {n,  n,  1,  0,  1,  n,  n},
}
local waveEnds = {
    {1,  1,  1,  1,  1,  1,  1},
    {n,  n,  n,  n,  n,  n,  n},
    {n,  n,  n,  n,  n,  n,  n},
    {n,  n,  n,  n,  n,  n,  n},
    {n,  n,  n,  n,  n,  n,  n},
    {n,  n,  n,  n,  n,  n,  n},
    {n,  n,  n,  0,  n,  n,  n},
}

customSpells["water dragon wave"] = {
    cooldown = 5000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = smallWave},
        }
    },
    damage = {
        delay = 400,
        interval = 200,
        minDam = 50,
        maxDam = 100, 
        damType = ICE,
        effect = {2,26},
        effectOnHit = 38,
        executeAmount = 2,
        repeatInterval = 1000,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*hiss*",
        msgType = ORANGE,
    },
    root = {
        targetConfig = {"caster"},
        onTargets = true,
    },
	flyingEffect = {
        position = {
            startPosT = {startPoint = "caster"},
            endPosT = {
                endPoint = "caster",
                areaConfig = {area = smallWave},
            }
        },
        effect = 29
    },
}