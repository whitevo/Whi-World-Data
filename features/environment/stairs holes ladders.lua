stairs = {
    W = {1388, 1398, 3679, 6909, 7925, 8372},
    E = {1390, 1400, 3681, 3688, 5258, 5260, 6911, 8374},
    N = {1392, 1402, 3683, 6913, 8376, 22590},
    S = {1385, 1394, 1396, 1404, 3685, 3687, 5259, 6915, 8378},
    NN = {7924},
}
holes = {369, 410, 411, 427, 428, 459, 469, 470, 383, 4837, 5731, 8210, 8279, 8281, 8284, 8286, 22595}
ladders = {1386, 3678, 5543}
sewers = {430}

function walkDown(player, _, _, fromPos, toPos)
    if not player:isPlayer() then return end
    
    local function getStairDirection(pos)
        local tile = Tile(pos)
        if not tile then return end
        
        for direction, stairT in pairs(stairs) do
            for _, itemID in pairs(stairT) do
                local findPos = pos
                local distance = 1

                if direction == "NN" then
                    direction = "N"
                    distance = 2
                    findPos = {x=pos.x, y=pos.y-1, z=pos.z}
                end
                if findItem(itemID, findPos) then return direction, distance end
            end
        end
    end

    local function getNewPos(pos)
        if not pos then return end
        local downPos = {x=pos.x, y=pos.y, z=pos.z+1}
        local direction, distance = getStairDirection(downPos)
        if not direction then return downPos end
        
        local dirPos = getDirectionPos(downPos, direction, distance)
        return not hasObstacle(dirPos, {"solid", "noGround"}) and dirPos or downPos
    end
    
    local newPos = getNewPos(toPos)
    if not hasObstacle(newPos, 1506) and hasObstacle(newPos, {"solid", "noGround"}) then return player:sendTextMessage(GREEN, "cant jump there") and player:teleportTo(fromPos, true) end
    player:teleportTo(newPos, true)
end

function ladderUp(player, item)
    local itemPos = item:getPosition()
    local upperPos = {x=itemPos.x, y=itemPos.y, z=itemPos.z-1}
    
    local function climb(pos)
        if hasObstacle(pos, "solid") then return end
        local tile = Tile(pos)
        local ground = tile:getGround()
        if not ground or ground:getId() == 459 or tile:hasHole() then return end
        player:teleportTo(pos, true)
        doTurn(player, reverseDir(direction))
        return true
    end

    for _, dir in pairs(compass1) do
        local toPos = getDirectionPos(upperPos, dir)
        if climb(toPos) then return end
    end
    
    for _, dir in pairs(compass2) do
        local toPos = getDirectionPos(upperPos, dir)
        if climb(toPos) then return end
    end
    player:sendTextMessage(GREEN, "There is no room above")
end

function getGotoPos(pos)
    local tile = Tile(pos)
    if not tile then return end

    for specialPos, jumpPos in pairs(climbConf.routingPos) do
        if samePositions(pos, specialPos) then return jumpPos end
    end

    if tile:hasHole() then return hole_getGotoPos(pos) end
    if tile:hasLadder() then return ladder_getGotoPos(pos) end
    if tile:hasStairsUp() then return stairsUp_getGotoPos(pos) end
    if tile:hasSewer() then return sewer_getGotoPos(pos) end
end

function Tile.hasHole(tile)
    for _, itemID in pairs(holes) do
        if tile:getItemById(itemID) then return true end
    end
end

function Tile.hasLadder(tile)
    for _, itemID in pairs(ladders) do
        if tile:getItemById(itemID) then return true end
    end
end

function Tile.hasStairsUp(tile)
    for dir, stairT in pairs(stairs) do
        for _, itemID in ipairs(stairT) do
            if tile:getItemById(itemID) then return true end
        end
    end
end

function Tile.hasSewer(tile)
    for _, itemID in pairs(sewers) do
        if tile:getItemById(itemID) then return true end
    end
end

local function checkDirections(pos)
    local function check(pos) return not hasObstacle(pos, "solid") end

    for _, dir in pairs(compass1) do
        local toPos = getDirectionPos(pos, dir)
        if check(toPos) then return toPos end
    end
    
    for _, dir in pairs(compass2) do
        local toPos = getDirectionPos(pos, dir)
        if check(toPos) then return toPos end
    end
end

function hole_getGotoPos(pos)
    local downPos = {x=pos.x, y=pos.y, z=pos.z+1}
    return checkDirections(downPos)
end

function ladder_getGotoPos(pos)
    local upperPos = {x=pos.x, y=pos.y, z=pos.z-1}
    return checkDirections(upperPos)
end

function stairsUp_getGotoPos(pos)
    local upperPos = {x=pos.x, y=pos.y, z=pos.z-1}
    return checkDirections(upperPos)
end

function sewer_getGotoPos(pos)
    local downPos = {x=pos.x, y=pos.y, z=pos.z+1}
    return checkDirections(downPos)
end