function getDirection(position1, position2)
    if not position1 or not position2 then return end
    local xPos1 = position1.x
    local yPos1 = position1.y
    local xPos2 = position2.x
    local yPos2 = position2.y

    if xPos1 > xPos2 then
        if yPos1 > yPos2 then return "NW" end
        if yPos1 == yPos2 then return "W" end
        return "SW"
    elseif xPos1 == xPos2 then
        if yPos1 > yPos2 then return "N" end
        if yPos1 == yPos2 then return end
        return "S"
    elseif xPos1 < xPos2 then
        if yPos1 > yPos2 then return "NE" end
        if yPos1 == yPos2 then return "E" end
        return "SE"
    end
end

function getDirectionStrFromCreature(cid)
    local creature = Creature(cid)
    if not creature or not creature:getDirection() then return end
    if creature:getDirection() == 0 then return "N" end
    if creature:getDirection() == 1 then return "E" end
    if creature:getDirection() == 2 then return "S" end
    if creature:getDirection() == 3 then return "W" end
end

function Creature:leftDir() return turnDirectionLeft(getDirectionStrFromCreature(self)) end
function Creature:rightDir() return turnDirectionRight(getDirectionStrFromCreature(self)) end

function turnDirectionRight(dir)
    if dir == "N" then return "E" end
    if dir == "E" then return "S" end
    if dir == "S" then return "W" end
    if dir == "W" then return "N" end
    if dir == "NE" then return "E" end
    if dir == "SE" then return "S" end
    if dir == "SW" then return "W" end
    if dir == "NW" then return "N" end
end

function turnDirectionLeft(dir)
    if dir == "N" then return "W" end
    if dir == "E" then return "N" end
    if dir == "S" then return "E" end
    if dir == "W" then return "S" end
    if dir == "NE" then return "N" end
    if dir == "SE" then return "E" end
    if dir == "SW" then return "S" end
    if dir == "NW" then return "W" end
end

function getDirectionPos(position, direction, distance)
    if not position then return end
    direction = dirToStr(direction)
    distance = distance or 1
    if direction == "W" then return {x=position.x-distance, y=position.y, z=position.z} end
    if direction == "E" then return {x=position.x+distance, y=position.y, z=position.z} end
    if direction == "N" then return {x=position.x, y=position.y-distance, z=position.z} end
    if direction == "S" then return {x=position.x, y=position.y+distance, z=position.z} end
    if direction == "NW" then return {x=position.x-distance, y=position.y-distance, z=position.z} end
    if direction == "NE" then return {x=position.x+distance, y=position.y-distance, z=position.z} end
    if direction == "SW" then return {x=position.x-distance, y=position.y+distance, z=position.z} end
    if direction == "SE" then return {x=position.x+distance, y=position.y+distance, z=position.z} end
    print("ERROR - getDirectionPos | direction: "..tostring(direction))
end

function reverseDir(direction)
    if direction == "W" then return "E" end
    if direction == "E" then return "W" end
    if direction == "N" then return "S" end
    if direction == "S" then return "N" end
    if direction == "NW" then return "SE" end
    if direction == "NE" then return "SW" end
    if direction == "SW" then return "NE" end
    if direction == "SE" then return "NW" end
    return "N"
end

function dirToNumber(direction)
    if type(direction) == "number" then return direction end

    for i, dir in ipairs(compass1) do
        if dir == direction then return i == 4 and 0 or i end
    end

    for i, dir in ipairs(compass3) do
        if dir == direction then return compass3[i-1] end
    end
    return 0, print("dirToNumber() has wrong dir input: ["..direction.."]")
end

function dirToStr(direction)
    if type(direction) == "string" then return direction end
    if direction == 0 then return "N" end
    if direction == 1 then return "E" end
    if direction == 2 then return "S" end
    if direction == 3 then return "W" end
    return 0, print("dirToStr() has wrong dir input: ["..direction.."]")
end

function isDiagonal(pos, endPos) return isInArray(compass2, getDirection(pos, endPos)) end

function doTurn(cid, dir)
local creature = Creature(cid)
    
    if not creature then return end
    if type(dir) == "string" then dir = dirToNumber(dir) end
    creature:setDirection(dir)
end