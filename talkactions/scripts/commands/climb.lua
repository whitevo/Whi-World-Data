climbConf = {
    lockedPosT_climbUp = {
        {x = 441, y = 588, z = 12},
    },
    lockedPosT_climbDown = {
        {x = 521, y = 735, z = 10},
        {x = 521, y = 737, z = 10},
    },
    routingPos = {
        [{x = 750, y = 598, z = 7}] = {x = 751, y = 600, z = 6},
        [{x = 745, y = 668, z = 8}] = {x = 671, y = 630, z = 7},
        [{x = 442, y = 588, z = 10}] = {x = 441, y = 587, z = 11},
        [{x = 751, y = 600, z = 6}] = {x = 750, y = 598, z = 7},
        [{x = 750, y = 600, z = 6}] = {x = 749, y = 598, z = 7},
        [{x = 521, y = 738, z = 8}] = {x = 525, y = 737, z = 9},
        [{x = 553, y = 738, z = 8}] = {x = 525, y = 737, z = 9},
        [{x = 704, y = 556, z = 6}] = {x = 705, y = 557, z = 7},
    }
}

function onSay(player, words, param)
    local climb = param:match("up") or param:match("down")
    if not climb then return false, player:sendTextMessage(ORANGE, "If you wanted to climb you need to write: !climb up or !climb down. Because game has no idea which way you trying to go.") end
    local playerPos = player:getPosition()

    playerPos:sendMagicEffect(10)
    for specialPos, jumpPos in pairs(climbConf.routingPos) do
        if samePositions(playerPos, specialPos) then return false, teleport(player, jumpPos, false, player:getDirection()) end
    end
    
    local function posIsLocked(lockedPositions)
        for _, pos in ipairs(lockedPositions) do
            if samePositions(playerPos, pos) then return true end
        end
    end

    if climb == "up" then
        if posIsLocked(climbConf.lockedPosT_climbUp) then return end
        local upperTile = Tile({x=playerPos.x, y=playerPos.y, z=playerPos.z-1})
        if not upperTile then return climbUp(player) end

        local ground = upperTile:getGround()
        if ground and ground:getId() == 459 or upperTile:hasHole() then return climbUp(player) end
        player:sendTextMessage(GREEN, "There is no hole above you")
    elseif climb == "down" then
        if posIsLocked(climbConf.lockedPosT_climbDown) then return end
        local tile = Tile(player:frontPos())
        if not tile or tile:getItemById(459) or tile:hasHole() then return climbDown(player) end
        player:sendTextMessage(GREEN, "there is no edge in front of you to climb down to")
    end
end

function climbUp(playerID)
    local player = Player(playerID)
    if not player then return end
    local playerPos = player:getPosition()
    local direction = getDirectionStrFromCreature(player)

    local function climb(pos)
        if hasObstacle(pos, "solid") then return end
        local tile = Tile(pos)
        local ground = tile:getGround()
        if not ground or ground:getId() == 459 or tile:hasHole() then return end
        player:teleportTo(pos, true)
        playerPos:sendMagicEffect(10)
        doTurn(player, reverseDir(direction))
        return true
    end

    local upperPos = {x=playerPos.x, y=playerPos.y, z=playerPos.z-1}
    local toPos = getDirectionPos(upperPos, direction)
    if climb(toPos) then return end

    for _, dir in pairs(compass1) do
        if dir ~= direction then
            local toPos = getDirectionPos(upperPos, dir)
            if climb(toPos) then return end
        end
    end
    
    local tile = Tile(upperPos)
    if not tile then return end
    
    local ground = tile:getGround()
    if not ground then return end
    if ground:getId() ~= 459 and not tile:hasHole() then return end
    
    for _, dir in pairs(compass2) do
        if dir ~= direction then
            local toPos = getDirectionPos(upperPos, dir)
            if climb(toPos) then return end
        end
    end
    player:sendTextMessage(GREEN, "There is no platform to climb on")
end

function climbDown(playerID)
    local player = Player(playerID)
    if not player then return end
    local frontPosition = player:frontPos()
    local tileDownAheadPos = {x=frontPosition.x, y=frontPosition.y, z=frontPosition.z+1}
    local tileDownAhead = Tile(tileDownAheadPos)
    local climbDown = false

    if not tileDownAhead then return end
    
    if hasObstacle(tileDownAheadPos, "solid") then
        local items = tileDownAhead:getItems() or {}
        for _, item in ipairs(items) do
            if item:getActionId() == AID.other.climbDownAllowed then
                climbDown = true
                break
            end
        end
    elseif tileDownAhead then
        climbDown = true
    end
    
    if not climbDown then return player:sendTextMessage(GREEN, "can't climb there") end
    
    local playerPos = player:getPosition()
    local teleportPos = {x=playerPos.x, y=playerPos.y, z=playerPos.z+1}
    if hasObstacle(teleportPos, {"solid", "noGround"}) then teleportPos = tileDownAheadPos end
    player:teleportTo(teleportPos, true)
end