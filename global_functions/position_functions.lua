function generatePositionTable(positions)
local matrixLayers = isMatrix(positions)
    
    if matrixLayers > 2 then return print("ERROR in generatePositionTable()") end
    if matrixLayers == 1 then return positions end
    if matrixLayers == 0 then return {positions} end
local newPositions = {}

    for _, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            table.insert(newPositions, pos)
        end
    end
    return newPositions
end

function removePositions(posT, objectT)
    if not posT then return end
    if type(objectT) ~= "table" then objectT = {objectT} end
local matrixLayers = isMatrix(posT)
    
    if matrixLayers > 2 then return print("ERROR in removePositions()") end
    if matrixLayers == 0 then return not hasObstacle(pos, objectT) and posT or {} end
local newPositions = {}

    if matrixLayers == 2 then
        for i, posT in pairs(posT) do
            table.insert(newPositions, {})
            
            for _, pos in pairs(posT) do
                if not hasObstacle(pos, objectT) then table.insert(newPositions[i], pos) end
            end
        end
    elseif matrixLayers == 1 then
        for _, pos in pairs(posT) do
            if not hasObstacle(pos, objectT) then table.insert(newPositions, pos) end
        end
    end
    return newPositions
end

function randomPos(posTable, count, dontExeed, layered)
    if not posTable then return print("posT is missing in randomPos()") end
    local matrixLayers = isMatrix(posTable)
    local positions = deepCopy(posTable)
    local count = count or 1
    local newPosT = {}
        
    if matrixLayers == 0 then return positions end
    if matrixLayers == 1 then return randomPosFromSinglePositionTable(positions, count, dontExeed) end
    if not layered then return randomPosFromSinglePositionTable(positions, count, dontExeed) end
    
    for i, posT in pairs(positions) do
        local counter = 0
        local availablePositions = positions[i]
        newPosT[i] = {}
        local tempPosT = newPosT[i]
        
        while counter < count do
            counter = counter + 1
            local tableCount = tableCount(availablePositions)
            
            if tableCount == 0 then
                if not dontExeed and counter - 1 ~= count then print("Could not create enough positions in randomPos()") end
                break
            end
            local posKey = math.random(1, tableCount)
            tempPosT[counter] = availablePositions[posKey]
            table.remove(availablePositions, posKey)
        end
    end
    
    return tableCount(newPosT) ~= 0 and newPosT
end

-- getAreaPos()
local function biggestMatrixLength(area) -- RETURNS area biggest row or column length
local length = 0

    for a=1, #area do
        for x=1, 20 do
            if  x > length and area[a][x] then length = x end
        end
    end
    return length
end

local function replaceStrWithValue(area, newValue)
local biggestLength = biggestMatrixLength(area)

    for i=1, #area do
        for j=1, biggestLength do
            if area[i] then
                if not area[i][j] then
                    area[i][j] = newValue
                elseif type(area[i][j]) == "string" then 
                    area[i][j] = newValue
                end
            end
        end
    end
    return area
end

local function reverseAreaTable(unsortedTable)
local sortedTable = {}
local matrixL = isMatrix(unsortedTable)
local amountOfTables = #unsortedTable
    
    if matrixL == 0 then return unsortedTable end

    for i, t in pairs(unsortedTable) do
        local valueCount = #t
        local tableKey = amountOfTables - (i-1)
        sortedTable[tableKey] = {}
        
        for j, v in pairs(t) do
            local valueKey = valueCount - (j-1)
            sortedTable[tableKey][valueKey] = v
        end
    end
    return sortedTable
end

local function reconstructAreaTable(area, direction)
if direction == "S" or direction == "SE" then return reverseAreaTable(area) end    
local newArea = {}

    for j=1, #area[1] do newArea[j] = {} end
    
    if direction == "W" or direction == "SW" then
        area = reverseAreaTable(area)
        
        for i=1, #area do
            for j=1, #area[i] do
                newArea[j][#area-(i-1)] = area[i][j]
            end
        end
    elseif direction == "E" or direction == "NE" then
        for i=1, #area do
            for j=1, #area[i] do
                newArea[j][#area-(i-1)] = area[i][j]
            end
        end
    end
    return newArea
end

local function lookForIndex(area)
    for i=1, #area do
        for j=1, #area[i] do
            if type(area[i][j]) == "table" then
                for x=1, #area[i][j] do
                    if area[i][j][x] == 0 then 
                        return i, j
                    end
                end
            elseif area[i][j] == 0 then
                return i, j
            end
        end
    end
    
    for i=1, #area do
        for j=1, #area[i] do
            if type(area[i][j]) == "table" then
                for x=1, #area[i][j] do
                    if area[i][j][x] == 1 then 
                        return i, j
                    end
                end
            elseif area[i][j] == 1 then
                return i, j
            end
        end
    end
    Uprint(area, "ERROR in lookForIndex")
end

local function createAreaMatrix(area)
local biggestNumber = 0
local matrix = {}
    
    local function updateValue(v)
        if v > biggestNumber then biggestNumber = v end
    end

    for _, t in ipairs(area) do
        for _, v in ipairs(t) do
            if type(v) == "table" then
                for _, v in ipairs(v) do updateValue(v) end
            else
                updateValue(v)
            end
        end
    end

    for x=1, biggestNumber do
        table.insert(matrix, {})
    end
    return matrix
end

function getAreaPos(startPos, area, direction)
    if not area then return end
    if not startPos.x then return end
    if not direction then direction = "N" end
    direction = dirToStr(direction)
    area = replaceStrWithValue(area, -1)
    if direction ~= "N" and direction ~= "NW" then area = reconstructAreaTable(area, direction) end
local positions = createAreaMatrix(area)
local index_I, index_J = lookForIndex(area)

    for i=1, #area do
        for j=1, #area[i] do
            local xPos = j-index_J
            local yPos = i-index_I
            local newPos = {x=startPos.x+xPos, y=startPos.y+yPos, z=startPos.z}
            
            if type(area[i][j]) == "table" then
                for x=1, #area[i][j] do
                    if area[i][j][x] > 0 then
                        local areaValue = area[i][j][x]
                        table.insert(positions[areaValue], newPos)
                    end
                end
            elseif area[i][j] > 0 then
                local areaValue = area[i][j]
                table.insert(positions[areaValue], newPos)
            end
        end
    end
    return positions
end
-- end of getAreaPos

function getTilePath(startPos, tileID)
local map = {startPos}
local lockedPos = {}
local finished = false

    repeat
        local foundTile = false
        for _, direction in pairs(compass1) do
            local newPos = getDirectionPos(startPos, direction)
            local item = findItem(tileID, newPos)
            
            if item and not samePositions(lockedPos, newPos) then
                foundTile = true
                lockedPos = startPos
                startPos = newPos
                table.insert(map, newPos)
                break
            end
        end
        if not foundTile then finished = true end
    until finished
    return map
end

function frontPos(pos, dir, yards)
    yards = yards or 1
    if dir == "N" then return {x=pos.x, y=pos.y-yards, z=pos.z} end
    if dir == "E" then return {x=pos.x+yards, y=pos.y, z=pos.z} end
    if dir == "S" then return {x=pos.x, y=pos.y+yards, z=pos.z} end
    if dir == "W" then return {x=pos.x-yards, y=pos.y, z=pos.z} end
end

function getAreaAround(pos, distance, cutCornerDistance)
distance = distance or 1
cutCornerDistance = cutCornerDistance or 0
local tempPosX = pos.x
local tempPosY = pos.y
local tempPosZ = pos.z
local positions = {}

    if cutCornerDistance > distance then cutCornerDistance = distance end

    if distance == 1 then
        if cutCornerDistance == 0 then table.insert(positions, {x=tempPosX - distance, y=tempPosY - distance, z=tempPosZ}) end
        table.insert(positions, {x=tempPosX - (distance-1), y=tempPosY - distance, z=tempPosZ})
        if cutCornerDistance == 0 then table.insert(positions, {x=tempPosX + distance, y=tempPosY - distance, z=tempPosZ}) end
        table.insert(positions, {x=tempPosX + distance, y=tempPosY - (distance-1),z=tempPosZ})
        if cutCornerDistance == 0 then table.insert(positions, {x=tempPosX + distance, y=tempPosY + distance, z=tempPosZ}) end
        table.insert(positions, {x=tempPosX + (distance-1), y=tempPosY + distance, z=tempPosZ})
        if cutCornerDistance == 0 then table.insert(positions, {x=tempPosX - distance, y=tempPosY + distance, z=tempPosZ}) end
        table.insert(positions, {x=tempPosX - distance, y=tempPosY + (distance-1),z=tempPosZ})
    else
        local area = {}
        local sequence = 0
        local middleKeySequence = 0
        local diameter = distance*2 + 1
        local middleKey = math.floor((diameter*diameter)/2) + 1
        
        local function addAreaIndex(x, y)
            middleKeySequence = middleKeySequence + 1
            if middleKeySequence == middleKey then area[x][y] = 0 return end
            
            if cutCornerDistance > 0 then
                local biggestMax = diameter - cutCornerDistance
                
                if x <= cutCornerDistance then
                    if y <= cutCornerDistance then
                        if x + y <= cutCornerDistance + 1 then return end
                    elseif y > biggestMax then
                        if y - x >= biggestMax then return end
                    end
                elseif x >= biggestMax then
                    if y <= cutCornerDistance then
                        if x - y >= biggestMax then return end
                    elseif y > biggestMax then
                        if y + x > diameter*2 - cutCornerDistance then return end
                    end
                end
            end
            sequence = sequence + 1
            area[x][y] = sequence
        end
        
        for x=1, diameter do
            area[x] = {}
            for y=1, diameter do addAreaIndex(x, y) end
        end
        
        local postions = getAreaPos(pos, area)
        return generatePositionTable(postions)
    end
    return positions
end

function getClosestFreePosition(startPos, distance)
local posT = getAreaAround(startPos, distance)

    for _, pos in pairs(posT) do
        if not hasObstacle(pos, {"solid", "creature"}) then return pos end
    end
end

function createSquare(startPos, endPos)
    if not startPos then return error("ERROR in createSquare() - missing startPos parameter") end
    if not endPos then return error("ERROR in createSquare() - missing endPos parameter") end
    if not startPos.x then return print("You might be missing x,y,z values from the startPosT IN createSquare()") end
    if not endPos.x then return print("You might be missing x,y,z values from the endPosT IN createSquare()") end
    local function getStartAndEnd(pos1, pos2) 
        if pos1 > pos2 then return pos2, pos1 else return pos1, pos2 end
    end
    local positions = {}
    local xStart, xEnd = getStartAndEnd(startPos.x, endPos.x)
    local yStart, yEnd = getStartAndEnd(startPos.y, endPos.y)
    local zPos = startPos.z
    local index = 0
    
    for i = xStart, xEnd do
        for j = yStart, yEnd do
            index = index + 1
            positions[index] = {x = i, y = j, z = zPos}
        end
    end
    return positions
end

function createAreaOfSquares(squares)
    local tempAllPositions = {}
    local allPositions = {}
    if not squares then return end
    
    for _, t in pairs(squares) do
        if t.allZPos then
            for z=1, 15 do
                local upCorner = {x=t.upCorner.x, y=t.upCorner.y, z=z}
                local downCorner = {x=t.downCorner.x, y=t.downCorner.y, z=z}
                local square = createSquare(upCorner, downCorner)
                for _, pos in pairs(square) do addIndexPos(tempAllPositions, pos) end
            end
        else
            local square = createSquare(t.upCorner, t.downCorner)
            removeItemFromPos(1435, t.upCorner) -- temp until RME is updated
            removeItemFromPos(1435, t.downCorner) -- temp until RME is updated
            if tableCount(squares) == 1 then return square end
            for _, pos in pairs(square) do addIndexPos(tempAllPositions, pos) end
        end
    end
    
    for _, posT in pairs(tempAllPositions) do
        for _, pos in pairs(posT) do table.insert(allPositions, pos) end
    end
    return allPositions
end

function filterArea(filterArea, area, improvement)
    local newArea = {}

    for rowID, columnT in pairs(area) do
        if not newArea[rowID] then newArea[rowID] = {} end
        local rowT = newArea[rowID]
        
        for columnID, v in pairs(columnT) do
            if improvement >= filterArea[rowID][columnID] then
                if not rowT[columnID] then rowT[columnID] = {} end
                rowT[columnID] = v
            end
        end
    end
    return newArea
end

local function areaFrontPosIsBlocked(startPos, blockDir, object)
local frontPos = frontPos(startPos, blockDir)

    return object == "solid" and hasObstacle(frontPos, object) and frontPos
end

local function getBlockedPositionT(startPos, direction, d)
    for offset=1, 6 do
        local linearDirectionPos = getDirectionPos(startPos, direction, d-offset)
        local leftSideDirection = turnDirectionLeft(direction)
        local rightSideDirection = turnDirectionRight(direction)
        
        if samePositions(pos, getDirectionPos(linearDirectionPos, leftSideDirection, offset)) then
            local blockPosArea = {
                {n,n,n,6,6,6},
                {n,n,5,5,5,n},
                {n,n,4,4,n,n},
                {n,3,3,n,n,n},
                {n,2,2,n,n,n},
                {1,1,n,n,n,n},
                {0,n,n,n,n,n},
            }
            return getAreaPos(pos, blockPosArea, leftSideDirection)
        elseif samePositions(pos, getDirectionPos(linearDirectionPos, rightSideDirection, offset)) then
            local blockPosArea = {
                {6,6,6,n,n,n},
                {n,5,5,5,n,n},
                {n,n,4,4,n,n},
                {n,n,n,3,3,n},
                {n,n,n,2,2,n},
                {n,n,n,n,1,1},
                {n,n,n,n,n,0},
            }
            return getAreaPos(pos, blockPosArea, rightSideDirection)
        end
    end
end

function blockArea(startPos, area, object, blockDir)
    local newArea = {}
    local blockedPositions = {}
    
    if areaFrontPosIsBlocked(startPos, blockDir, object) then return {} end
    
    local function addPos(pos)
        local alreadyBlocked = false
        
        comparePositionT(blockedPositions, pos)
        if not alreadyBlocked then
            table.insert(blockedPositions, pos)
        end
    end
    
    for _, posT in pairs(area) do
        for _, pos in pairs(posT) do
            if object == "solid" and hasObstacle(pos, "solid") then
                local d = getDistanceBetween(startPos, pos)
                local direction = getDirection(startPos, pos)
                
                addPos(pos)
                
                if isInArray(compass1, direction) then
                    local loopID = 1
                    local rightPos = getDirectionPos(pos, turnDirectionRight(direction))
                    local leftPos = getDirectionPos(pos, turnDirectionLeft(direction))
                    
                    local function linearPosBlock(pos)
                        for dist=1, 8-d do
                            local newBlockedPosition = getDirectionPos(pos, direction, dist)
                            
                            loopID = loopID+1
                            addPos(newBlockedPosition)
                            
                            if loopID > 2 and loopID%2 == 0 then
                                local rowDist = loopID/2 - 1
                                local rightDir = turnDirectionRight(direction)
                                local leftDir = turnDirectionLeft(direction)
                                local rightRowPos = getDirectionPos(newBlockedPosition, rightDir, rowDist)
                                local leftRowPos = getDirectionPos(newBlockedPosition, leftDir, rowDist)
                                
                                addPos(rightRowPos)
                                addPos(leftRowPos)
                                
                                for dist=1, 8-loopID do
                                    local nextRightRowPos = getDirectionPos(rightRowPos, direction, dist)
                                    local nextLeftRowPos = getDirectionPos(leftRowPos, direction, dist)
                                    
                                    addPos(nextRightRowPos)
                                    addPos(nextLeftRowPos)
                                end
                            end
                        end
                    end
                    
                    linearPosBlock(pos)
                    if hasObstacle(rightPos, "solid") then linearPosBlock(rightPos) end
                    if hasObstacle(leftPos, "solid") then linearPosBlock(leftPos) end
                elseif samePositions(pos, getDirectionPos(startPos, direction, d)) then
                    for dist=1, 8-d do
                        local newBlockedPosition = getDirectionPos(pos, direction, dist)
                        
                        addPos(newBlockedPosition)
                    end
                else
                    local newBlockedPositionT = getBlockedPositionT(startPos, direction, d)
                        
                    if newBlockedPositionT then
                        for i, posT in pairs(newBlockedPositionT) do
                            for _, pos in pairs(posT) do
                                if 7 - offset >= i then addPos(pos) end
                            end
                        end
                    end
                end
            end
        end
    end
    
    for i, posT in pairs(area) do
        for j, pos in pairs(posT) do
            if not comparePositionT(blockedPositions, pos) then
                if not newArea[i] then newArea[i] = {} end
                newArea[i][j] = pos
            end
        end
    end
    return newArea
end

-- returns table where positions behind object are turned into rootPosition instead. rootPos is usually object position.
-- if returns only Position then ALL the positions are rooted to this position.
function limitArea(startPos, area, object, blockDir)
    local blockedPositions = {}
    local frontPos = areaFrontPosIsBlocked(startPos, blockDir, object)

    if frontPos then return frontPos end
    
    local function alreadyUsed(pos)
        for _, t in pairs(blockedPositions) do
            if samePositions(t.rootPos, pos) then
                return true
            elseif t.blockedPosT then
                for _, bPos in pairs(t.blockedPosT) do
                    if samePositions(bPos, pos) then
                        return true
                    end
                end
            end
        end
    end
    
    local function setKeyPos(pos)
        if alreadyUsed(pos) then return end
        local keyID = tableCount(blockedPositions) + 1
        blockedPositions[keyID] = {rootPos = pos, blockedPosT = {}}
        return keyID
    end
    
    local function addToKeyPos(keyID, pos)
        if alreadyUsed(pos) then return end
        table.insert(blockedPositions[keyID].blockedPosT, pos)
    end
    
    for _, posT in pairs(area) do
        for _, pos in pairs(posT) do
            if hasObstacle(pos, object) then
                local keyID = setKeyPos(pos)
                
                if keyID then
                    local d = getDistanceBetween(startPos, pos)
                    local direction = getDirection(startPos, pos)

                    if isInArray(compass1, direction) then
                        if d == 1 then return pos end
                        local loopID = 1
                        local rightPos = getDirectionPos(pos, turnDirectionRight(direction))
                        local leftPos = getDirectionPos(pos, turnDirectionLeft(direction))
                        
                        local function linearPosBlock(pos)
                            for dist=1, 8-d do
                                local newBlockedPosition = getDirectionPos(pos, direction, dist)
                                
                                loopID = loopID+1
                                addToKeyPos(keyID, newBlockedPosition)
                                
                                if loopID > 2 and loopID%2 == 0 then
                                    local rowDist = loopID/2 - 1
                                    local rightDir = turnDirectionRight(direction)
                                    local leftDir = turnDirectionLeft(direction)
                                    local rightRowPos = getDirectionPos(newBlockedPosition, rightDir, rowDist)
                                    local leftRowPos = getDirectionPos(newBlockedPosition, leftDir, rowDist)
                                    
                                    addToKeyPos(keyID, rightRowPos)
                                    addToKeyPos(keyID, leftRowPos)
                                    
                                    for dist=1, 8-loopID do
                                        local nextRightRowPos = getDirectionPos(rightRowPos, direction, dist)
                                        local nextLeftRowPos = getDirectionPos(leftRowPos, direction, dist)
                                        
                                        addToKeyPos(keyID, nextRightRowPos)
                                        addToKeyPos(keyID, nextLeftRowPos)
                                    end
                                end
                            end
                        end
                        
                        linearPosBlock(pos)
                        if hasObstacle(rightPos, "solid") then linearPosBlock(rightPos) end
                        if hasObstacle(leftPos, "solid") then linearPosBlock(leftPos) end
                    elseif samePositions(pos, getDirectionPos(startPos, direction, d)) then
                        for dist=1, 8-d do
                            local newBlockedPosition = getDirectionPos(pos, direction, dist)
                            
                            addToKeyPos(keyID, newBlockedPosition)
                        end
                    else
                        local newBlockedPositionT = getBlockedPositionT(startPos, direction, d)

                        if newBlockedPositionT then
                            for i, posT in pairs(newBlockedPositionT) do
                                for _, pos in pairs(posT) do
                                    if 7 - offset >= i then addToKeyPos(keyID, pos) end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return blockedPositions
end

local function getAvailablePosT(posT, count)
    local maxCount = #posT
    local newPosT = deepCopy(posT)

    if count <= maxCount then return posT end

    while count > maxCount do
        count = count - maxCount
        for _, pos in ipairs(posT) do table.insert(newPosT, pos) end
    end
    return newPosT
end

function randomPosFromSinglePositionTable(posTable, count, dontExeed) -- extenstion for randomPos()
    local newPositions = {}
    local tempPositions = generatePositionTable(posTable)
    if dontExeed and count >= #tempPositions then return tempPositions end
    local availablePositions = getAvailablePosT(tempPositions, count)
    local counter = 0
    local tempCount = count
    
    while counter < count do
        counter = counter + 1
        if tableCount(availablePositions) == 0 then availablePositions = getAvailablePosT(tempPositions, count) end
        local posIndex = randomKeyFromTable(availablePositions)
        table.insert(newPositions, availablePositions[posIndex])
        availablePositions[posIndex] = nil
    end
    
    if tableCount(newPositions) == 0 then return print("ERROR - no newPositions IN randomPos()") end
    return newPositions
end

function getCenterPos(startPos, endPos)
    local xPos = startPos.x
    local yPos = startPos.y
    local xDistance = xPos - endPos.x
    local yDistance = yPos - endPos.y
    local xHalfWay =  math.ceil(xDistance/2)
    local yHalfWay =  math.ceil(yDistance/2)

    return {x = xPos - xHalfWay, y = yPos - yHalfWay, z = startPos.z}
end

function getPosCorners(pos, distance)
    distance = distance or 1
    local xPos, yPos, zPos = pos.x, pos.y, pos.z
    local upCorner = {x = xPos - distance, y = yPos - distance, z = zPos}
    local downCorner = {x = xPos + distance, y = yPos + distance, z = zPos}

    return upCorner, downCorner
end

function getParentPos(object, noPlayer)
    if not object then return end
    local pos = object:getPosition()

    if Tile(pos) then return pos end
    
    if object:isContainer() then
        local parent = object:getParent()
        if parent:isContainer() then parent = parent:getParent() end
        object = parent
    end
    
    if object:isTile() then return object:getPosition() end
    if object:isPlayer() then return not noPlayer and object:getPosition() end
end

function getDistanceBetween(fromPos, toPos, ignoreFloors)
    if not fromPos.x or not toPos.x then return 100 end
    local xDif = math.abs(fromPos.x - toPos.x)
    local yDif = math.abs(fromPos.y - toPos.y)
    local posDif = math.max(xDif, yDif)
    
    if ignoreFloors then return posDif end
    return fromPos.z ~= toPos.z and posDif + 100 or posDif
end

-- objects: "creature", "monster", "player", "npc", itemID, creatureID, creature
function findFromPos(object, positions)
    local matrixLayers = isMatrix(positions)
    local isItem = type(object) == "number" and ItemType(object):getId() > 0
    local objectTable = {}

    local function addCreatureID(pos)
        local creatureID = findCreatureID(object, pos)
        if creatureID then table.insert(objectTable, creatureID) end
    end

    local function addItem(pos)
        local itemsT = findItems(object, pos)
        for _, item in pairs(itemsT) do table.insert(objectTable, item) end
    end

    local function chooseFunc(pos)
        return isItem and addItem(pos) or not isItem and addCreatureID(pos)
    end
    
    if matrixLayers == 0 then
        chooseFunc(positions)
    elseif matrixLayers == 1 then
        for _, pos in pairs(positions) do
            chooseFunc(pos)
        end
    elseif matrixLayers == 2 then
        for _, posT in pairs(positions) do
            for _, pos in pairs(posT) do
               chooseFunc(pos)
            end
        end
    elseif matrixLayers == 3 then
        for _, posT in pairs(positions) do
            for _, pos2 in pairs(posT) do
                for _, pos in pairs(posT2) do
                    chooseFunc(pos)
                end
            end
        end
    end
    
    return objectTable
end

function findItem(itemID, pos, itemAID)
    local tile = Tile(pos)
    if not tile then return end

    if itemID then
        local item = tile:getItemById(itemID)
        if not item then return end
        if not itemAID then return item end
        if item:getActionId() == itemAID then return item end
        return
    end
    
    if not itemAID then return end
    local itemTable = tile:getItems() or {}

    for _, item in pairs(itemTable) do
        local foundItemAID = item:getActionId()
        if itemAID == foundItemAID then return item end
    end
end

function findItems(itemID, pos, itemAID)
    local tile = Tile(pos)
    if not itemID and not itemAID then return error("ERROR in findItems() - missing both itemID and itemAID") end
    if not tile then return {} end
    local itemTable = tile:getItems() or {}
    local itemList = {}
    local indexID = 0

    local function addItem(item)
        indexID = indexID + 1
        itemList[indexID] = item
    end

    for _, item in pairs(itemTable) do
        local itemID_passed = not itemID or item:getId() == itemID
        local itemAID_passed = not itemAID or item:getActionId() == itemAID
        
        if itemID_passed and itemAID_passed then addItem(item) end
    end
    return itemList
end

function findCreature(object, pos) return Creature(findCreatureID(object, pos)) end

function findCreatureID(object, pos)
    if not Tile(pos) then return end
    local foundCreature = Tile(pos):getBottomCreature()
    
    if not foundCreature then return end
    
    if type(object) == "number" then
        local creature = Creature(object)
        if not creature then return end
        if creature:isPlayer() then return not creature:isGod() and targetIsCorrect(foundCreature, "player") and foundCreature:getId() end
        if creature:isMonster() then return targetIsCorrect(foundCreature, "monster") and foundCreature:getId() end
        if creature:isNpc() then return targetIsCorrect(foundCreature, "npc") and foundCreature:getId() end
    elseif type(object) == "string" then
        return targetIsCorrect(foundCreature, object) and foundCreature:getId()
    end
end

function findByName(positions, name)
local matrixLayers = isMatrix(posT)
local name = name:lower()

    if matrixLayers > 2 then return print("ERROR - too many layers in findByName") end

    local function checkPos(pos)
        local tile = Tile(pos)
        if not tile then return end
        local creatures = tile:getCreatures() or {}
        
        for _, creature in pairs(creatures) do
            if creature:getName():lower() == name then return creature end
        end
    end

    if matrixLayers == 0 then
        return checkPos(positions)
    elseif matrixLayers == 1 then
        for _, pos in pairs(positions) do
            local creature = checkPos(pos)
            if creature then return creature end
        end
    elseif matrixLayers == 2 then
        for _, posT in pairs(positions) do
            for _, pos in pairs(posT) do
                local creature = checkPos(pos)
                if creature then return creature end
            end
        end
    end
    -- make itemFinding next here
end

--[[    functions what used for getPath()
compass1 = {"E","S","W","N"}
compass2 = {"NW","NE","SW","SE"}
compass3 = {"N","NE","E","SE","S","SW","W","NW"}

    isMatrix(t)                                     -- RETURNS the dimensional layer(length)
    samePositions(startPos, endPos)                 -- RETURNS true if same positions
    getDistanceBetween(fromPos, toPos, ignoreFloors)-- RETURNS INT | distance between positions, z diffrence adds +100
    getPosCorners(pos, distance or 1)               -- RETURNS upCorner, downCorner (distance is radius from pos)
    getCenterPos(startPos, endPos)                  -- RETURNS position
    createSquare(upCorner, downCorner)              -- RETURNS {_, pos}
    comparePositionT(t, pos)                        -- RETURNS true if pos is also in the table
    tableCount(t)                                   -- RETURNS amount of keys in table or 0
    reverseTable(t)                                 -- RETURNS {_, v}   | only reverses ipairs tables
    getDirectionPos(position, direction, distance)  -- RETURNS POS | towards compass direction
    isDiagonal(fromPos, toPos)                      -- RETURNS isInArray(compass2, getDirection(pos, endPos))
    getDirection(startPos, endPos)                  -- RETURNS direction string from startPos to endPos
    hasObstacle(pos, obstacle)                      -- RETURNS true if positions has this obstacle
    createObstaclePosT(area, obstacleTable, startPos, endPos)   -- RETURNS blockedPosT = {{[pos.x] = pos},} or nil
]]
function getPath(startPos, endPos, obstacleTable, onlyCheck, radius)
    if not startPos or not endPos then return end
    local matrixLayers = isMatrix(endPos)
    if matrixLayers > 1 then return end
    if matrixLayers == 1 then endPos = endPos[#endPos] end
    if startPos.z ~= endPos.z then return end
    if samePositions(startPos, endPos) then return end
    local centerPos = getCenterPos(startPos, endPos)
    radius = radius or getDistanceBetween(centerPos, endPos) + 1
    local upCorner, downCorner = getPosCorners(centerPos, radius)
    local area = createSquare(upCorner, downCorner)
    local obstaclePosT = createObstaclePosT(area, obstacleTable, startPos, endPos)

    return createPath(startPos, endPos, area, obstaclePosT, onlyCheck)
end

local function createMap(startPos, endPos, area, blockedPosT)
    if not area then area = createSquare(startPos, endPos) end
    local map = {}
    local startPosID
    local endPosFound = false

    local function isBlocked(pos)
        if blockedPosT[pos.x] and comparePositionT(blockedPosT[pos.x], pos) then return true end
    end
    
    for posID, pos in pairs(area) do
        if blockedPosT and tableCount(blockedPosT) > 0 and isBlocked(pos) then
            table.insert(map, {blocked = true})
        else
            local distanceFromEnd = getDistanceBetween(pos, endPos)*2
            
            if not startPosID and samePositions(pos, startPos) then startPosID = posID end
            table.insert(map, {ID = posID, pos = pos, heuristic = distanceFromEnd})
        end
    end
    
    return map, startPosID
end

local function path(finishID, map)
    local path = {}
    local ID = finishID

    while ID do
        local tileData = map[ID]
        
        if not tileData then break end
        table.insert(path, tileData.pos)
        ID = tileData.parent
    end
    return reverseTable(path)
end

function createPath(startPos, endPos, area, blockedPosT, onlyCheck)
    local map, startPosID = createMap(startPos, endPos, area, blockedPosT)
    local openList = {[startPosID] = map[startPosID]}
    local usedID = {}

    local function getTileData()
        local tileData
        local lowestHeurstics = 1000
            
        for ID, tiledata in pairs(openList) do
            if not tiledata.blocked and tiledata.heuristic < lowestHeurstics then
                tileData = tiledata
                lowestHeurstics = tiledata.heuristic
            end
        end
        if lowestHeurstics <= 1 then return false, tileData.ID end
        return tileData
    end
    
    local function getNextTileData(pos)
        for ID, tileData in pairs(map) do
            if not isInArray(usedID, ID) and not tileData.blocked and samePositions(tileData.pos, pos) then
                return tileData
            end
        end
    end

    while tableCount(openList) > 0 do
        local tileData, finishID = getTileData()
        
        if not tileData then
            if onlyCheck then return true end
            return path(finishID, map)
        end
        local pos = tileData.pos
        local ID = tileData.ID
        
        table.insert(usedID, ID)
        openList[ID] = nil
        
        for _, direction in pairs(compass3) do
            local nearPos = getDirectionPos(pos, direction)
            local nextTileData = getNextTileData(nearPos)
            
            if nextTileData then
                local nextID = nextTileData.ID
                
                if not openList[nextID] then
                    nextTileData.parent = ID
                    if isDiagonal(pos, nearPos) then nextTileData.heuristic = nextTileData.heuristic + 1 end
                    openList[nextID] = nextTileData
                end
            end
        end
    end
end

function createObstaclePosT(area, obstacleTable, startPos, endPos)
    if not obstacleTable then return {} end
    if type(obstacleTable)  ~=  "table" then obstacleTable = {obstacleTable} end
    local obstaclePosT = {}

    for _, pos in pairs(area) do
        for _, obstacle in pairs(obstacleTable) do
            if hasObstacle(pos, obstacle) and not samePositions(startPos, pos) and not samePositions(endPos, pos) then addIndexPos(obstaclePosT, pos) end
        end
    end
    return obstaclePosT
end

function pathIsOpen(monsterPos, targetPos, obstacles)
local path = getPath(monsterPos, targetPos)

    if not path then return end
    if type(obstacles) ~= "table" then obstacles = {obstacles} end
    
    for _, pos in ipairs(path) do
        for _, obstacle in ipairs(obstacles) do
            if hasObstacle(pos, obstacle) then return false end
        end
    end
    return true
end

function addIndexPos(t, pos)
    local xTable = t[pos.x]
    
    if not xTable then
        t[pos.x] = {pos}
    elseif not comparePositionT(xTable, pos) then
        table.insert(xTable, pos)
    end
end

function testPositions(posT, effect)
    local effect = effect or 20
    local matrixLayers = isMatrix(posT)
    
    if matrixLayers > 2 then return print("ERROR - too big matrix in testPositions()") end
    if matrixLayers == 0 then return doSendMagicEffect(posT, effect) end
    
    if matrixLayers == 1 then
        for _, pos in pairs(posT) do doSendMagicEffect(pos, effect) end
    else
        for _, posT2 in pairs(posT) do
            for _, pos in pairs(posT2) do doSendMagicEffect(pos, effect) end
        end
    end
end

function testPosObstacles(pos)
    local tile = Tile(pos)
    if not tile then return Uprint({"noTile = true"}, "testPosObstacles") end
    Uprint({
        noTile = "false",
        noGround = tostring(hasObstacle(pos, "noGround")),
        solid = tostring(hasObstacle(pos, "solid")),
        blockThrow = tostring(hasObstacle(pos, "blockThrow")),
        creature = tostring(hasObstacle(pos, "creature")),
        player = tostring(hasObstacle(pos, "player")),
        monster = tostring(hasObstacle(pos, "monster")),
        CONST_PROP_BLOCKSOLID = tostring(tile:hasProperty(CONST_PROP_BLOCKSOLID)),
        CONST_PROP_HASHEIGHT = tostring(tile:hasProperty(CONST_PROP_HASHEIGHT)),
        CONST_PROP_BLOCKPROJECTILE = tostring(tile:hasProperty(CONST_PROP_BLOCKPROJECTILE)),
        CONST_PROP_BLOCKPATH = tostring(tile:hasProperty(CONST_PROP_BLOCKPATH)),
        CONST_PROP_ISVERTICAL = tostring(tile:hasProperty(CONST_PROP_ISVERTICAL)),
        CONST_PROP_ISHORIZONTAL = tostring(tile:hasProperty(CONST_PROP_ISHORIZONTAL)),
        CONST_PROP_MOVEABLE = tostring(tile:hasProperty(CONST_PROP_MOVEABLE)),
        CONST_PROP_IMMOVABLEBLOCKSOLID = tostring(tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID)),
        CONST_PROP_IMMOVABLEBLOCKPATH = tostring(tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH)),
        CONST_PROP_IMMOVABLENOFIELDBLOCKPATH = tostring(tile:hasProperty(CONST_PROP_IMMOVABLENOFIELDBLOCKPATH)),
        CONST_PROP_NOFIELDBLOCKPATH = tostring(tile:hasProperty(CONST_PROP_NOFIELDBLOCKPATH)),
        CONST_PROP_SUPPORTHANGABLE = tostring(tile:hasProperty(CONST_PROP_SUPPORTHANGABLE)),
    }, "testPosObstacles")
end

local function checkForObstacles(pos, obstacle)
    local tile = Tile(pos)
    local itemID = tonumber(obstacle)

    if itemID then return itemID > 50000 and tableCount(findFromPos(itemID, pos)) > 0 or findItem(itemID, pos) end
    if not tile then 
        if obstacle == "hasTile" then return false end
        return obstacle ~= "noTile"
    end
    if obstacle == "hasTile" then return true end
    if obstacle == "noTile" then return false end
    if obstacle == "noGround" then return not tile:getGround() end
    if obstacle == "solid" then return tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKPATH) or tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) end
    if obstacle == "blockThrow" then return tile:hasProperty(CONST_PROP_BLOCKPROJECTILE) end
    if obstacle == "creature" then return tile:getBottomCreature() end
    if obstacle == "player" or obstacle == "monster" then return tableCount(findFromPos(obstacle, pos)) > 0 end
    Vprint(obstacle, "This obstacle does not exist in hasObstacle()")
end

function hasObstacle(pos, obstacleT)
    if type(obstacleT) ~= "table" then obstacleT = {obstacleT} end

    for _, obstacle in pairs(obstacleT) do
        if checkForObstacles(pos, obstacle) then return true end
    end
    return false
end

function comparePositionT(t, newPos)
    if not t then return end
    local matrixLayers = isMatrix(t)

    if matrixLayers > 2 then return print("ERROR - too many layers in comparePositionT()") end
    
    if matrixLayers == 2 then
        for _, posT in pairs(t) do
            for _, pos in pairs(posT) do
                if samePositions(pos, newPos) then return true end
            end
        end
    else
        for _, pos in pairs(t) do
            if samePositions(pos, newPos) then return true end
        end
    end
end

function samePositions(startPos, endPos)
    if not startPos or not endPos then return end
    if not startPos.x or not endPos.x or not startPos.y or not endPos.y then return end
    if startPos.x == endPos.x and startPos.y == endPos.y and startPos.z == endPos.z then return true end
end

function isInRange(pos, fromPos, toPos, allFloors)
    if allFloors then return pos.x >= fromPos.x and pos.y >= fromPos.y and pos.x <= toPos.x and pos.y <= toPos.y end
    return pos.x >= fromPos.x and pos.y >= fromPos.y and pos.z >= fromPos.z and pos.x <= toPos.x and pos.y <= toPos.y and pos.z <= toPos.z
end

function isInArea(player, area)
    local playerPos = player:getPosition()

    if area.areaCorners then
        for _, t in pairs(area.areaCorners) do
            if isInRange(playerPos, t.upCorner, t.downCorner) then return true end
        end
    end
end

function removeFromPositions(posT, objectT)
    if not posT then return print("missing posT in removeFromPosition()") end
    if not objectT then return print("missing objectT in removeFromPosition()") end
    for i, pos in pairs(posT) do massRemove(pos, objectT) end
end

function massRemove(pos, objectT)
    local tile = Tile(pos)
    local didRemove = false

    if not tile then return end
    if type(objectT) ~= "table" then objectT = {objectT} end
    
    for _, object in pairs(objectT) do
        local objectType = type(object)

        if objectType == "string" or objectType == "number" and object > 100000 then
            local creatureT = findFromPos(object, pos)

            for _, creatureID in pairs(creatureT) do
                removeCreature(creatureID)
                didRemove = true
            end
        elseif objectType == "number" then
            local itemT = findFromPos(object, pos)

            for _, item in pairs(itemT) do
                item:remove()
                didRemove = true
            end
        else
            print("massRemove(), unknown type: "..objectType)
        end
    end
    return didRemove
end