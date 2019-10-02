-- buffs damage: config in bufferMonsters() function
monsterSpells["sea hero"] = {
    "sea hero wave",
    "sea hero summon",
    "sea hero root",
    "sea hero whirlwind",
    "sea hero heal tower",
    "sea king full hp",
    "square_5x5_1 effects 15",
    "sea guard no spell field",
    "heal: cd=5000 p=6",
    "damage: cd=2000 d=20-30",
}

local waveArea = {
    {n, n, n, 5, 5, 5, 5, 5, n, n, n},
    {n, n, n, n, 4, 4, 4, n, n, n, n},
    {n, n, n, n, 3, 3, 3, n, n, n, n},
    {5, n, n, n, n, 2, n, n, n, n, 5},
    {5, 4, 3, n, n, 1, n, n, 3, 4, 5},
    {5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5},
    {5, 4, 3, n, n, n, n, n, 3, 4, 5},
    {5, n, n, n, n, n, n, n, n, n, 5},
}

customSpells["sea hero wave"] = {
    cooldown = 22000,
    firstCastCD = -15000,
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

customSpells["sea hero summon"] = {
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
			["sea counselor"] = {amount = 1},
			["sea brawler"] = {amount = 1},
		},
        summonAmount = 2,
		maxSummons = 4,
    },
	flyingEffect = {effect = 37},
    magicEffect = {effect = 26},
}

customSpells["sea hero root"] = {
    cooldown = 9000,
    targetConfig = {
        ["enemy"] = {obstacles = {"blockThrow"}},
    },
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_far",
            checkPath = "blockThrow",
        }
    },
    root = {msDuration = 2000},
}

customSpells["sea hero whirlwind"] = {
    cooldown = 15000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    customFeature = {
        func = "seaHero_whirlWind",
        duration = 4000,
        damageInterval = 150,
        damType = PHYSICAL,
        damage = 150,
        distanceEffect = 24,
        effect = {10, 4},
    }
}
function seaHero_whirlWind(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local times = math.floor(featureT.duration / featureT.damageInterval)
local loopTimes = 0
local casterPos = caster:getPosition()
local area = getAreaAround(casterPos)
local directionN = 1
local directionT = {"S", "E", "N", "W"}

    local function deeeps(pos, direction)
        if not Creature(cid) then return end
        dealDamagePos(cid, pos, featureT.damType, featureT.damage, 1, O_monster_Spells, featureT.effect)
        doSendDistanceEffect(casterPos, pos, featureT.distanceEffect)
        doTurn(cid, direction)
    end
    
    root(cid, featureT.duration)
    while times > loopTimes do
        for i, pos in ipairs(area) do
            local directionIndex = (directionN + loopTimes) % 4
            addEvent(deeeps, loopTimes * featureT.damageInterval, pos, directionT[directionIndex])
            loopTimes = loopTimes + 1
            if loopTimes > times then return end
        end
    end
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

customSpells["sea hero heal tower"] = {
    cooldown = 7000,
    firstCastCD = 13000,
    targetConfig = {"friend"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    customFeature = {
        func = "seaHero_healTower",
        healAmount = 500,
        increaseMaxHP = 300, -- if hp was full
        flyingEffect = 27,
        effect = {2, 18},
        effectInterval = 250,
        healTargetName = "sea king tower",
    }
}

function seaHero_healTower(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local casterPos = caster:getPosition()

    for cid, posT in pairs(targetList) do
        local creature = Creature(cid)
        if creature and creature:getRealName() == featureT.healTargetName then
            local creaturePos = creature:getPosition()
            
            doSendMagicEffect(creaturePos, featureT.effect, featureT.effectInterval)
            doSendDistanceEffect(casterPos, creaturePos, featureT.flyingEffect)
            if not heal(creature, featureT.healAmount) then creature:setMaxHealth(creature:getMaxHealth() + featureT.increaseMaxHP) end
        end
    end
end

customSpells["sea guard no spell field"] = {
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
        items = {2281},
        itemAID = AID.jazmaz.monsters.seaHero_field,
        removeTime = 30000,
    },
    magicEffect = {
        effect = {14,14,14,14,14,14,14,14,14,14,14},
        effectInterval = 3000,
    },
}