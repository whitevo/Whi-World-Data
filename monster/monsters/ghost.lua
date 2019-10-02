local monster_ghost = {
    monsters = {
        ["ghost"] = {
            name = "Ghost",
            reputationPoints = 5,
            race = "undead",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 3,
                requiredSV = {[SV.ghoulTaskOnce] = 1},
                killsRequired = 10,
                storageID = SV.ghostTask,
                storageID2 = SV.ghostTaskOnce,
                skillPoints = 1,
                location = "In Rooted Catacombs",
                reputation = 15,
            },
        },
    },
    monsterSpells = {
        ["ghost"] = {
            "ghost wave",
            "ghost wind",
            "ghostMode",
            finalDamage = 8,
        },
    },
    monsterResistance = {
        ["ghost"] = {
            PHYSICAL = 70,
            ICE = 50,
            FIRE = 25,
            ENERGY = 35,
            DEATH = 80,
            HOLY = -80,
            EARTH = 50,
        },
    },
    monsterLoot = {
        ["ghost"] = {
            storage = SV.ghost,
            items = {
                [15481] = {chance = 2, hunter = 4, firstTime = 3, partyBoost = "false"},    -- traptrix quiver
                [18410] = {chance = 2, knight = 4, firstTime = 3, partyBoost = "false"},    -- ghatitk shield
                [3972] = {chance = 2, hunter = 4, firstTime = 3, partyBoost = "false"},     -- snaipa helmet
                [2481] = {chance = 2, knight = 4, firstTime = 3, partyBoost = "false"},     -- warrior helmet
                [2537] = {chance = 2, druid = 4, firstTime = 3, partyBoost = "false"},      -- yashimaki
                [7903] = {chance = 2, druid = 4, firstTime = 3, partyBoost = "false"},      -- pinpua hood
                [2520] = {chance = 2, mage = 4, firstTime = 3, partyBoost = "false"},       -- demonic shield
                [6433] = {chance = 2, mage = 4, firstTime = 3, partyBoost = "false"},       -- kamikaze mask
                [5905] = {chance = 25},                                                     -- ghost powder
                [2150] = {chance = 10},                                                     -- death gem
                [2290] = {chance = 20},                                                     -- speed stone
            }
        },
    },
}
centralSystem_registerTable(monster_ghost)

local wave = {{1}, {1}, {1}, {1}, {0}}
local diagonalWave = {
    {1, n, n, n, n},
    {n, 1, n, n, n},
    {n, n, 1, n, n},
    {n, n, n, 1, n},
    {n, n, n, n, 0},
}
    
customSpells["ghost wave"] = {
    cooldown = 12000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget", areaConfig = {useStartPos = true, area = wave, relativeArea = diagonalWave}},
    },
    damage = {
        minDam = 40,
        maxDam = 80,
        damType = DEATH,
        effect = 18,
        effectOnHit = 4,
    },
}

local windArea = {
    {1, 1, 1, 1, 1},
    {1, n, n, n, 1},
    {1, n, 0, n, 1},
    {1, n, n, n, 1},
    {1, 1, 1, 1, 1},
}
customSpells["ghost wind"] = {
    cooldown = 4000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "caster", areaConfig = {area = windArea}, blockObjects = {"solid"}, randomPos = 8}
    },
    flyingEffect = {effect = 37},
    damage = {
        minDam = 55,
        maxDam = 100,
        damType = ICE,
        effect = 43,
        effectOnHit = 38,
    },
}

customSpells["ghostMode"] = {
    cooldown = 10000,
    firstCastCD = -9000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    conditions = {onTargets = true, conditionT = {["invisible"] = {duration = -1}}},
}

function ghostRoom_ghostSay(creature)
    if not chanceSuccess(33) then return end
    if creature:getCondition(INVISIBLE, 1) then return end
    local texts = {"*woo*", "*Waa*", "*uuw*", "*euw*"}
    local randomMsg = texts[math.random(#texts)]
    creature:say(randomMsg, ORANGE)
end

local function canTeleportTarget(monster, target)
    if not target or not target:isPlayer() then return end
    if getSV(target, SV.ghostTP) == 1 then return end
    local targetPos = target:getPosition()
    local monsterPos = monster:getPosition()
    if getDistanceBetween(targetPos, monsterPos) > 2 then return end

    local monsterDir = reverseDir(getDirectionStrFromCreature(monster))
    local newPos = getDirectionPos(monsterPos, monsterDir, 3)
    local tile = Tile(newPos)
    if not tile then return end
    if tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then return end
    return newPos
end

local secondarySpellCDs = {}
function ghostRoom_ghostAI(monster)
    if monster:getRealName() ~= "ghost" then return end
    ghostRoom_ghostSay(monster)
    local monsterID = monster:getId()
    local monsterPos = monster:getPosition()
    local tempEnemies = monster:getTargetList()
    local enemies = {}
    local secondSpellTargets = {}

    for _, cid in pairs(tempEnemies) do
        if not ghostTargets(monster, cid) then table.insert(enemies, cid) end
        if not monster:getCondition(INVISIBLE, 1) then table.insert(secondSpellTargets, cid) end
    end
    
    if tableCount(enemies) == 0 and tableCount(secondSpellTargets) > 0 then
        if not secondarySpellCDs[monsterID] then secondarySpellCDs[monsterID] = 5 end
        
        if secondarySpellCDs[monsterID] <= 0 then
            for _, cid in pairs(secondSpellTargets) do
                local target = Creature(cid)
                
                if target then
                    local targetPos = target:getPosition()
                    
                    if not findItem(9737, targetPos, AID.areas.ghostRoom.ghostOrb) then
                        doSendDistanceEffect(monsterPos, targetPos, 13)
                        addEvent(dealDamagePos, 2000, monsterID, targetPos, ICE, math.random(70,140), 31, O_monster_spells, 43, {38,31}) 
                        createItem(9737, targetPos, 1, AID.areas.ghostRoom.ghostOrb)
                        addEvent(removeItemFromPos, 2000, 9737, targetPos)
                        secondarySpellCDs[monsterID] = 5
                    end
                end
            end
        end
        secondarySpellCDs[monsterID] = secondarySpellCDs[monsterID] - 1
        return
    end
    
    for _, targetID in pairs(enemies) do
        local target = Creature(targetID)
        local newPos = canTeleportTarget(monster, target)
        
        if newPos then
            local targetPos = target:getPosition()
            local startArea = getAreaPos(targetPos, areas["3x3_0"])
            local endArea = getAreaPos(newPos, ghostConfT.ghostTP)
            
            for _, posT in pairs(startArea) do
                for _, pos in pairs(posT) do
                    doSendDistanceEffect(targetPos, pos, 5)
                end
            end
            
            for i, posT in pairs(endArea) do
                for _, pos in pairs(posT) do
                    if i == 1 or i == 2 then
                        addEvent(doSendDistanceEffect, i*200, newPos, pos, 36)
                    end
                end
            end
            
            targetPos:sendMagicEffect(11)
            addEvent(doSendMagicEffect, 500, newPos, 11)
            addEvent(ghostTP, 200, targetID, newPos)
            setSV(target, SV.ghostTP, 1)
            addEvent(removeSV, 4000, targetID, SV.ghostTP)
            return true
        end
    end
end

function ghostTP(pid, pos)
    if getSV(pid, SV.playerIsDead) == 1 then return end
    teleport(pid, pos)
end

function ghostTargets(monster, targetID)
    local target = Creature(targetID)
    if not target then return end
    if monster:getRealName() ~= "ghost" then return end    
    if not monster:getCondition(INVISIBLE, 1) then return true end
    local targetPos = target:getPosition()

    for _, posCorners in pairs(ghostConfT.safeZoneT) do
        if isInRange(targetPos, posCorners.upCorner, posCorners.downCorner) then return true end
    end
end