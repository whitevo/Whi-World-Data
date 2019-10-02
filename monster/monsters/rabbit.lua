local monster_rabbit = {
    monsters = {
        ["rabbit"] = {
            name = "Rabbit",
            reputationPoints = 4,
            race = "beast",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 1,
                killsRequired = 5,
                storageID = SV.rabbitTask,
                storageID2 = SV.rabbitTaskOnce,
                skillPoints = 1,
                location = "north forest",
                reputation = 10,
            },
        },
    },
    monsterSpells = {
        ["rabbit"] = {
            "heal: cd=2000, p=5",
            "rabbit hop",
        },
    },
    monsterResistance = {
        ["rabbit"] = {
            ICE = 50,
            EARTH = 50,
            FIRE = 50,
            HOLY = -50,
            ENERGY = 50,
            DEATH = 50,
        },
    },
    monsterLoot = {
        ["rabbit"] = {
            storage = SV.rabbit,
            items = {
                [ITEMID.herbs.urreanel] = {chance = 25, itemAID = AID.herbs.urreanel},
                [ITEMID.food.carrot] = {chance = 85, itemAID = AID.other.food},
                [ITEMID.materials.rabbit_paw] = {chance = 25},
            }
        },
    },
}
centralSystem_registerTable(monster_rabbit)

customSpells["rabbit hop"] = {
    cooldown = 2000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget", posTFunc = "posTFunc_rabbitEscape"}
    },
    teleport = {effectOnCast = 10},
    say = {onTargets = true, msg = "*hop*", msgType = ORANGE},
}

rabbitEscapeArea = {
    {1,1,1},
    {n,2,n},
    {n,0,n},
}
rabbitEscapeArea2 = {
    {1,1,n},
    {1,2,n},
    {n,n,0},
}
rabbitEscapeArea3 = {
    {1,1,1,1,1},
    {n,2,2,2,n},
    {n,n,3,n,n},
    {n,n,0,n,n},
}
rabbitEscapeArea4 = {
    {1,1,1,1,1},
    {1,2,2,2,n},
    {1,2,3,n,n},
    {1,2,n,0,n},
}

function posTFunc_rabbitEscape(caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local function getDangerDirections()
        local directionT = {}
        
        for startPos, endPosT in pairs(pointPosT) do
            for _, endPos in ipairs(endPosT) do
                local direction = getDirection(startPos, endPos)
                
                if direction then directionT[direction] = (directionT[direction] or 0) + 1 end
            end
        end
        return directionT
    end
    
    local function getHighestDangerDirection(dangerDirectionT)
        local dangerDirection
        local dangerDirectionAmount = 0
        
        for direction, amount in pairs(dangerDirectionT) do
            if amount > dangerDirectionAmount then
                dangerDirection = direction
            elseif amount == dangerDirectionAmount and chanceSuccess(50) then
                dangerDirection = direction
            end
        end
        return dangerDirection
    end
    local dangerDirectionT = getDangerDirections()
    local highestDangerDirection = getHighestDangerDirection(dangerDirectionT)
    local safestDirection = reverseDir(highestDangerDirection)
    local startPos = caster:getPosition()
    local randomTimes = 0
    
    local function getEscapeArea()
        local escapeArea = {}
        
        if isInArray(compass1, safestDirection) then
            if chanceSuccess(40) then escapeArea = rabbitEscapeArea3 else escapeArea = rabbitEscapeArea end
        else
            if chanceSuccess(40) then escapeArea = rabbitEscapeArea4 else escapeArea = rabbitEscapeArea2 end
        end
        return getAreaPos(startPos, escapeArea, safestDirection)
    end
    
    local function getRabbitEscapePos()
        if randomTimes == 4 then return end
        local canJumpThere = true
        local escapeArea = getEscapeArea()
        local jumpLevel = 2
        
        if escapeArea[3] then jumpLevel = 3 end

        for _, pos in ipairs(escapeArea[jumpLevel]) do
            if hasObstacle(pos, "solid") and hasObstacle(pos, "blockThrow") then canJumpThere = false end
        end
        
        if canJumpThere then
            local function getJumpPos()
                local obstacles = {"noTile", "noGround", "solid"}
                
                for _, posT in ipairs(escapeArea) do
                    local breakLoop = false
                    
                    for _, pos in pairs(posT) do
                        for _, obstacle in ipairs(obstacles) do
                            if hasObstacle(pos, obstacle) then breakLoop = true break end
                        end

                        if breakLoop then break end
                        return getPath(startPos, pos, obstacles, true) and pos
                    end
                end
            end
            
            local jumpPos = getJumpPos()
            if jumpPos then return {{jumpPos}} end
        end
        
        randomTimes = randomTimes + 1
        safestDirection = compass3[math.random(1, #compass3)]
        return getRabbitEscapePos()
    end
    
    return getRabbitEscapePos()
end
