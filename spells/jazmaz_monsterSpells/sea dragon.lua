monsterSpells["sea dragon"] = {
    "sea dragon poison fields",
    "sea dragon explode poison fields",
    "sea dragon wave",
    "sea dragon lazer",
    "sea dragon heal items",
    "sea dragon copy",
    "heal: cd=3000 p=5",
    "damage: cd=2000 d=25-35 t=ICE",
}

local AIDT = AID.jazmaz.monsters

local positionConfig_2randomPos = {
    startPosT = {startPoint = "caster"},
    endPosT = {
        endPoint = "caster",
        areaConfig = {area = areas["5x5_0"]},
        blockObjects = {"solid"},
        randomPos = 2,
    }
}

customSpells["sea dragon poison fields"] = {
    cooldown = 11000,
    firstCastCD = -7000,
    targetConfig = {"caster"},
    position = positionConfig_2randomPos,
    changeEnvironment = {
        removeItems = 1496,
        items = 1496,
		itemAID = AIDT.seaDragon_poisonField,
        removeTime = 30000,
    },
    flyingEffect = {effect = 20},
}

function seaDragon_poisonField_stepIn(creature, item)
    if not creature:isPlayer() then return end
    dealDamage(0, creature, EARTH, 75, 21, O_environment)
end

customSpells["sea dragon explode poison fields"] = {
    cooldown = 12000,
    firstCastCD = -7000,
    targetConfig = {"caster"},
    position = positionConfig_2randomPos,
    changeEnvironment = {
        removeItems = 1496,
        items = 1496,
		itemAID = AIDT.seaDragon_poisonField,
        removeTime = 36000,
		customFunc = "seaDragon_registerPoisonField",
    },
    flyingEffect = {effect = 20},
}

local poisonFieldPosT = {}  -- [creatureID] = {POS,}
function seaDragon_registerPoisonField(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local creatureID = caster:getId()
    if not poisonFieldPosT[creatureID] then poisonFieldPosT[creatureID] = {} end
local fieldPosT = poisonFieldPosT[creatureID]
    
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do table.insert(fieldPosT, pos) end
    end
    
    registerEvent(caster, "onThink", "seaDragon_poisonFieldExplosion")
end

local function poisonFieldDamage(pos)
    local area = getAreaPos(pos, areas["5x5_0 circle"])
    
    for i, posT in pairs(area) do
        for _, pos in pairs(posT) do
            addEvent(dealDamagePos, (i-1)*350, creatureID, pos, EARTH, 50, 9, O_monster_spells, 17) 
        end
    end
end

local fieldCooldowns = {}   -- [creatureID] = cooldown
function seaDragon_poisonFieldExplosion(creature)
local creatureID = creature:getId()
    if not fieldCooldowns[creatureID] then fieldCooldowns[creatureID] = 0 return end
local cooldown = fieldCooldowns[creatureID]
    if cooldown < 8 then fieldCooldowns[creatureID] = cooldown + 1 return end
local poisonPosT = poisonFieldPosT[creatureID]

    fieldCooldowns[creatureID] = 0
    if tableCount(poisonPosT) == 0 then return unregisterEvent(creature, "onThink", "seaDragon_poisonFieldExplosion") end

    for i, pos in pairs(poisonPosT) do 
        if findItem(1496, pos, AIDT.seaDragon_poisonField) then
            poisonFieldDamage(pos)
        else
            poisonPosT[i] = nil
        end
    end
end

customSpells["sea dragon copy"] = {
    cooldown = 30000,
    targetConfig = {"caster"},
    lockedForSummon = true,
    position = positionConfig_2randomPos,
    summon = {
        summons = {
			["sea dragon"] = {amount = 2, monsterHP = 2500},
		},
		maxSummons = 2,
    },
    say = {
        msg = "*GROAAR*",
        msgType = ORANGE,
    },
}

local healItemArea = {
    {1,1,n,1,1},
    {1,n,n,n,1},
    {n,n,0,n,n},
    {1,n,n,n,1},
    {1,1,n,1,1},
}
customSpells["sea dragon heal items"] = {
    cooldown = 8000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = healItemArea},
            blockObjects = {2349, "solid"},
            randomPos = 2,
        }
    },
    changeEnvironment = {
        items = {2349},
		itemAID = AIDT.seaDragon_healItem,
        removeTime = 32000,
    },
}

function seaDragon_healItem(creature, item)
    if not creature:isMonster() then return end
local area = getAreaPos(creature:getPosition(), areas.outwards_explosion_3x3_1)
local healPercent = 20
local healAmount = percentage(creature:getMaxHealth(), healPercent)
    
    for i, posT in pairs(area) do
        for _, pos in pairs(posT) do
            addEvent(doSendMagicEffect, (i-1)*200, pos, {2, 40, 29}, 250)
        end
    end
    creature:addHealth(healAmount)
    item:remove()
end

customSpells["sea dragon lazer"] = {
    cooldown = 10000,
    firstCastCD = 5000,
    targetConfig = {["enemy"] = {range = 7}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            posTFunc = "seaDragon_lazerPositions",
        }
    },
    damage = {
        delay = 1000,
        sequenceInterval = 100,
        minDam = 50,
        maxDam = 100,
        damType = FIRE,
        distanceEffect = 16,
        effect = {30, 37},
        effectOnHit = 5,
    },
    say = {
        targetConfig = {"caster"},
        onTargets = true,
        msg = "*Roar!*",
        msgType = ORANGE,
    },
}

function seaDragon_lazerPositions(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
local positions = {}
local posIndex = 0
local casterPos = caster:getPosition()
local startPos = casterPos

    local function addPos(pos)
        posIndex = posIndex + 1
        positions[posIndex] = pos
    end
    
    local function addCirclePositions()
        local areaAround = getAreaAround(casterPos)
        for _, pos in ipairs(areaAround) do addPos(pos) end
        startPos = casterPos
    end
    
    for targetID, posT in pairs(targetList) do
        for _, pos in pairs(posT) do
            local path = getPath(startPos, pos)
            
            if path then
                for _, pos in ipairs(path) do addPos(pos) end
                startPos = pos
            elseif not samePositions(startPos, casterPos) then
                local path = getPath(casterPos, pos)
                local backTrack = getPath(startPos, casterPos)
                
                if path and backTrack then
                    for _, pos in ipairs(backTrack) do addPos(pos) end
                    for _, pos in ipairs(path) do addPos(pos) end
                    startPos = pos
                else
                    addCirclePositions()
                end
            else
                addCirclePositions()
            end
        end
    end
    return {positions}
end


local waveArea = {
    { n, n,23,24, 4, 5, 6, n, n},
    { n,22,23,23, 3, 4, 5, 7, n},
    {20,21,22,22, 2, 3, 4, 6, 8},
    {19,20,21,20, 1, 3, 4, 5, 7},
    {19,19,18,16, 0, 5, 6, 7, 9},
    {18,17,15,13,10, 8, 7, 9,10},
    {16,15,13,12,12,10, 9,10,11},
    { n,15,14,13,12,11,10,11, n},
    { n, n,15,14,13,12,11, n, n},
}

customSpells["sea dragon wave"] = {
    cooldown = 20000,
    firstCastCD = -10000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = waveArea},
        }
    },
    changeEnvironment = {
        targetConfig = {"caster"},
        onTargets = true,
        items = {2016},
		itemAID = AIDT.seaDragon_holdTile,
        removeTime = 24*200,
    },
    damage = {
        interval = 200,
        minDam = 40,
        maxDam = 100, 
        damType = ICE,
        effect = {31,42},
        effectOnHit = 44,
    },
}