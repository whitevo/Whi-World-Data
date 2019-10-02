local features = {"damage", "changeEnvironment", "teleport", "event", "spellLock", "spellLockCD", "say", "flyingEffect", "magicEffect", "magicEffect2", "builder", "resistance", "conditions",
    "summon", "heal", "customFeature", "stun", "bind", "root"}

function SPS_castSpell(cid, spellName)
    local caster = Creature(cid)
    local spellT = customSpells[spellName]
    if not caster or not spellT then return end

    local targetList = SPS_getTargetList(caster, spellT)
    local startPosT = SPS_getStartPosT(caster, spellT, targetList)
    local endPosT = SPS_getEndPosT(caster, spellT, targetList, startPosT)
    return SPS_createSpell(cid, spellT, targetList, endPosT, startPosT)
end

local function hookPassed(featureT, hook)
    if featureT.hook and not hook then return end
    if featureT.oppoHook and hook then return end
    return true
end

function SPS_castSpell2(cid, spellT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT, hook)
    local caster = Creature(cid)
    if not caster then return end
    
    for _, key in ipairs(features) do
        local featureT = spellT[key]
        
        if featureT then
            if hookPassed(featureT, hook) then
                local newTargetList = targetList
                local newStartPosT = startPosT
                local newEndPosT = endPosT
                
                if featureT.targetConfig then
                    previousTargetList = targetList
                    newTargetList = SPS_getTargetList(caster, featureT)
                end
                
                if featureT.position then
                    previousStartPosT = startPosT
                    previousEndPosT = endPosT
                    newStartPosT = SPS_getStartPosT(caster, featureT, newTargetList, previousTargetList, previousEndPosT, previousStartPosT)
                    newEndPosT = SPS_getEndPosT(caster, featureT, newTargetList, newStartPosT, previousTargetList, previousEndPosT, previousStartPosT)
                end
                
                local delay = featureT.delay or 0
                if featureT.onTargets then
                    local func = _G["spellCreatingSystem_onTarget_"..key]
                    if func then addEvent(func, delay, cid, featureT, newTargetList, newEndPosT, newStartPosT, previousTargetList, previousEndPosT, previousStartPosT) end
                else
                    local func = _G["spellCreatingSystem_position_"..key]
                    if func then addEvent(func, delay, cid, featureT, newTargetList, newEndPosT, newStartPosT, previousTargetList, previousEndPosT, previousStartPosT) end
                end
            end
        end
    end
end

function SPS_createSpell(cid, spellT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)

    if not caster then return end
    SPS_castSpell2(cid, spellT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    if not spellT.changeTarget then return true end
    caster:searchTarget(TARGETSEARCH_NEAREST) -- only double VV works
    caster:searchTarget(TARGETSEARCH_NEAREST) -- only double ^^ works
    return true
end

function SPS_createDataT(targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
return {
    targetList = targetList,
    endPosT = endPosT,
    startPosT = startPosT,
    previousTargetList = previousTargetList,
    previousEndPosT = previousEndPosT,
    previousStartPosT = previousStartPosT}
end

function SPS_recastPerPos(cid, featureT, dataT, hook)
    if not featureT.recastPerPos then return end
    SPS_castSpell2(cid, featureT, dataT.targetList, dataT.endPosT, dataT.startPosT, dataT.previousTargetList, dataT.previousEndPosT, dataT.previousStartPosT, hook)
end
-----
function SPS_getTargetList(caster, spellT)
    local casterPos = caster:getPosition()
    local posTConfig = spellT.posTConfig    -- missing functions for posTConfig
    local targetList = {} -- [cid/itemID] = posT

    local function pathCheck(targetPos, t)
        if not t.getPath then return true end
        if getPath(casterPos, targetPos, t.obstacles, true) then return true end
    end
    
    local function stringObject(object, t)
        local requiredID = t.requiredID
        local range = t.range or 10
        
        if object == "enemy" then
            local enemies = caster:getEnemies()
            local tempTargetList = sortCreatureListByDistance(casterPos, enemies, range)
            
            for _, cid in pairs(tempTargetList) do
                local targetPos = Creature(cid):getPosition()
                if pathCheck(targetPos, t) then targetList[cid] = {targetPos} end
            end
        elseif object == "caster" then
            targetList[caster:getId()] = {casterPos}
        elseif object == "cTarget" then
            local target = caster:getTarget()
            if not target then return end
            local targetPos = target:getPosition()
            
            if getDistanceBetween(casterPos, targetPos) > range then return end
            if pathCheck(targetPos, t) then targetList[target:getId()] = {targetPos} end
        elseif object == "friend" then
            local friends = caster:getFriends(range)
            local targetAmount = 0

            for _, cid in pairs(friends) do
                local target = Creature(cid)
                local targetPos = target:getPosition()

                if pathCheck(targetPos, t) then
                    if t.amount then
                        if targetAmount == t.amount then break end
                        targetAmount = targetAmount + 1
                    end
                    targetList[target:getId()] = {targetPos}
                end
            end
            
            if t.npcFollow then
                local npcT = getNpcT(caster)
                if npcT then
                    local targetID = randomKeyFromTable(targetList)
                    if targetID then npcT.followTargetID = targetID end
                end
            end
        end
    end
    
    local function numberObject(object, t)
        local range = t.range
        local area = getAreaAround(casterPos, range)
        
        table.insert(area, casterPos)
        for _, pos in pairs(area) do
            if findItem(object, pos, true) then
                if pathCheck(pos, t) then
                    if not targetList[object] then
                        targetList[object] = {pos}
                    else
                        table.insert(targetList[object], pos)
                    end
                end
            end
        end
    end
    
    local function handleObject(object, t)
        if type(object) == "string" then
            stringObject(object, t)
        elseif type(object) == "number" then
            numberObject(object, t)
        elseif type(object) == "table" then
            for _, object in pairs(object) do
                handleObject(object, t)
            end
        end
    end
    
    for object, t in pairs(spellT.targetConfig) do
        if t.requiredID then handleObject(object, t) end
    end
    return targetList
end

local function getPointPosT(caster, posPoints, posConfT, targetList, previousEndPosT, previousStartPosT)
    if not posPoints then return end
local startPointPosT = {}
local finish = false
local only1Pos = posConfT.singlePosPoint
    
    local function addPos(pos)
        if finish then return end
        table.insert(startPointPosT, pos)
        if only1Pos then finish = true end
    end
    
    local function object_caster() return addPos(caster:getPosition()) end
    
    local function object_endPos()
        for _, posT in pairs(previousEndPosT) do
            for _, pos in pairs(posT) do addPos(pos) end
        end
    end
    
    local function object_startPos()
        for _, posT in pairs(previousStartPosT) do
            for _, pos in pairs(posT) do addPos(pos) end
        end
    end
    
    local function object_enemies()
        for cid, posT in pairs(targetList) do
            if cid > 50000 then addPos(posT[1]) end -- only has 1 position inside posT anyway
        end
    end
    
    local function object_friends()
        if not caster:isMonster() then return end
        for _, cid in pairs(caster:getFriends(posConfT.range)) do addPos(Creature(cid):getPosition()) end
    end
    
    local function object_cTarget()
        local target = caster:getTarget()
        if target then return addPos(target:getPosition()) end
    end
    
    local function object_itemID()
        for cid, posT in pairs(targetList) do
            if cid < 50000 then
                for _, pos in pairs(posT) do addPos(pos) end
            end
        end
    end
    
    local function object_handle(object)
        if finish then return end
        if type(object) == "number" then return object_itemID(object) end
        if object == "caster"       then return object_caster(object) end
        if object == "enemy"        then return object_enemies(object) end
        if object == "friend"       then return object_friends(object) end
        if object == "cTarget"      then return object_cTarget(object) end
        if object == "endPos"       then return object_endPos(object) end
        if object == "startPos"     then return object_startPos(object) end
        error(object.." is missing in getStartPointPosT()")
    end
    
    for _, object in ipairs(posPoints) do object_handle(object) end
    return startPointPosT
end

local function SPS_createArea(caster, posConfT, pointPosT)
local confT = posConfT.areaConfig
    if not confT then return end
local startPosT = {} -- [i] = {[j] = pos}
local areaT = confT.area
local relativeAreaT = confT.relativeArea
    
    local function getArea(startPos, direction)
        if isInArray(compass1, direction) then return getAreaPos(startPos, areaT, direction) end
        if relativeAreaT then return getAreaPos(startPos, relativeAreaT, direction) end
        local letterT = stringToLetterT(direction)
        local newDirection = randomValueFromTable(letterT)
        
        return getAreaPos(startPos, areaT, newDirection)
    end
    
    for startPos, endPosT in pairs(pointPosT) do
        for _, endPos in pairs(endPosT) do
            local direction = getDirection(startPos, endPos)
            local area
            
            if not direction then direction = getDirectionStrFromCreature(caster) end
            if confT.useStartPos then area = getArea(startPos, direction) else area = getArea(endPos, direction) end
            
            if not confT.randomPos then
                for i, posT in pairs(area) do
                    if not startPosT[i] then startPosT[i] = {} end
                    local loopID = tableCount(startPosT[i])
                    
                    for _, pos in pairs(posT) do
                        loopID = loopID + 1
                        startPosT[i][loopID] = pos
                    end
                end
            else
                if not startPosT[1] then startPosT[1] = {} end
                local randomPosT = randomPos(area, confT.randomPos, true)
                local loopID = tableCount(startPosT[1])
                
                if randomPosT then
                    for _, pos in pairs(randomPosT) do
                        loopID = loopID + 1
                        startPosT[1][loopID] = pos
                    end
                end
            end
        end
    end
    return startPosT
end

local function checkPassed(caster, targetList, pos, object)
local tile = Tile(pos)

    if not tile then return end
    if not object then return true end
    
    if type(object) == "number" then 
        local tileItems = tile:getItems() or {}
        
        for _, item in pairs(tileItems) do
            if item:getId() == object then return end
        end
    elseif object == "solid" then
        if tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then return end
    elseif object == "caster" then
        if not caster then return true end
        local casterID = caster:getId()
        for _, c in pairs(tile:getCreatures()) do
            if c:getId() == casterID then return end
        end
    elseif object == "enemy" then
        if not tile:getCreatures() then return true end
        for _, c in pairs(tile:getCreatures()) do
            for cid, posT in pairs(targetList) do
                if c:getId() == cid then return end
            end
        end
    elseif object == "friend" then
        if not caster then return true end
        if not tile:getCreatures() then return true end
        for _, c in pairs(tile:getCreatures()) do
            for _, cid in pairs(caster:getFriends()) do
                if c:getId() == cid then return end
            end
        end
    end
    return true
end

local function SPS_createPath(caster, posConfT, targetList, pointPosT) 
local confT = posConfT.getPath
    if not confT then return end
local startPosT = {}
local loopID = 0

    for startPos, endPosT in pairs(pointPosT) do
        for _, endPos in pairs(endPosT) do
            local path = getPath(startPos, endPos, confT.obstacles)
            
            if path then
                loopID = loopID + 1
                startPosT[loopID] = {}
                
                for i, pos in ipairs(path) do startPosT[loopID][i] = pos end
            end
        end
    end
    
    if confT.stopOnPath then
        local newStartPosT = {}
        
        for i, posT in ipairs(startPosT) do
            local loopID = 0
            local breakOuterLoop = false
            newStartPosT[i] = {}
            
            for _, pos in ipairs(posT) do
                if breakOuterLoop then break end
                
                for _, object in ipairs(confT.stopOnPath) do
                    loopID = loopID + 1
                    newStartPosT[i][loopID] = pos
                    
                    if not checkPassed(caster, targetList, pos, object) then
                        breakOuterLoop = true break
                    end
                end
            end
        end
        startPosT = newStartPosT
    end
    return startPosT
end

local function createPointPosT(posConfT, startPointPosT, endPointPosT)
local pointPosT = {}

    if posConfT.pointPosFunc then return _G[posConfT.pointPosFunc](posConfT, startPointPosT, endPointPosT) end
    
    if posConfT.endPoint and posConfT.endPoint[1] and posConfT.endPoint[1] == "endPos" then
        for _, startPos in pairs(startPointPosT) do
            pointPosT[startPos] = {startPos}
            if posConfT.singlePosT then break end
        end
    else
        for _, startPos in pairs(startPointPosT) do
            pointPosT[startPos] = endPointPosT
            if posConfT.singlePosT then break end
        end
    end
    return pointPosT
end

local function clearPositions(caster, targetList, startPosT, blockObjects, previousEndPosT)
local newStartPosT = {}

    for i, posT in pairs(startPosT) do
        newStartPosT[i] = {}
        local tempPostT = newStartPosT[i]
        local key = 1
        
        for _, pos in pairs(posT) do
            local blockedPos = false
            
            if blockObjects then
                for _, object in pairs(blockObjects) do
                    if object == "previousEndPos" then
                        if comparePositionT(previousEndPosT, pos) then
                            blockedPos = true
                            break
                        end
                    elseif not checkPassed(caster, targetList, pos, object) then
                        blockedPos = true
                        break
                    end
                end
            else
                if not Tile(pos) then blockedPos = true end
            end
            
            if not blockedPos then
                tempPostT[key] = pos
                key = key + 1
            end
        end
        if tableCount(tempPostT) == 0 then newStartPosT[i] = nil end
    end
    return newStartPosT
end

local function onlyItemPos(startPosT, itemTable)
local newStartPosT = {}
    
    for i, posT in pairs(startPosT) do
        newStartPosT[i] = {}
        local tempPostT = newStartPosT[i]
        local key = 1
        
        for _, pos in pairs(posT) do
            for _, itemID in pairs(itemTable) do
                if findItem(itemID, pos) then
                    tempPostT[key] = pos
                    key = key + 1
                    break
                end
            end
        end
        if tableCount(tempPostT) == 0 then newStartPosT[i] = nil end
    end
    return newStartPosT
end

local function createStartPosT(caster, posConfT, targetList, endPointPosT, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
local posT = SPS_createArea(caster, posConfT, pointPosT) -- { i = { j = pos } }
    
    if not posT then posT = SPS_createPath(caster, posConfT, targetList, pointPosT) end
    if not posT and posConfT.posTFunc then posT = _G[posConfT.posTFunc](caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT) end
    if not posT then
        local newPosT = {}
        local loopID = 0
        local range = posConfT.range
        
        for startPos, endPosT in pairs(pointPosT) do
            loopID = loopID + 1
            
            if range < 10 then
                for _, pos in pairs(endPosT) do
                    if getDistanceBetween(startPos, pos) <= range then
                        if not newPosT[loopID] then newPosT[loopID] = {} end
                        table.insert(newPosT[loopID], pos)
                    end
                end
            else
                newPosT[loopID] = endPosT
            end
        end
        posT = newPosT
    end
    if not posT then return end
    
    posT = clearPositions(caster, targetList, posT, posConfT.blockObjects, previousEndPosT, posConfT)
    if posConfT.onlyItemPos then posT = onlyItemPos(posT, posConfT.onlyItemPos) end
    if posConfT.randomPos then
        local function getRandomPosT()
            if posConfT.randomPerLayer then
                return randomPos(posT, posConfT.randomPos, nil, posConfT.randomPerLayer)
            else
                local randomPosT = randomPos(posT, posConfT.randomPos, true)
                if not randomPosT then return end
                return {randomPosT}
            end
        end
        
        posT = getRandomPosT()
        if not posT or not posT[1] or not posT[1][1] or not posT[1][1].x then return {} end
    end
    return posT
end

function SPS_getStartPosT(caster, spellT, targetList, previousTargetList, previousEndPosT, previousStartPosT)
local posConfT = spellT.position.startPosT
local startPointPosT = getPointPosT(caster, posConfT.startPoint, posConfT, targetList, previousEndPosT, previousStartPosT)
local endPointPosT = getPointPosT(caster, posConfT.endPoint, posConfT, targetList, previousEndPosT, previousStartPosT)
    if not endPointPosT then endPointPosT = startPointPosT end
local pointPosT = createPointPosT(posConfT, startPointPosT, endPointPosT)
local startPosT = createStartPosT(caster, posConfT, targetList, endPointPosT, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)

    if not startPosT then return error("missing startPosT in createStartPosT()") end
    return startPosT
end

function SPS_getEndPosT(caster, spellT, targetList, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local posConfT = spellT.position.endPosT
    if not posConfT then return startPosT end
local startPointPosT = generatePositionTable(startPosT)
local endPointPosT = getPointPosT(caster, posConfT.endPoint, posConfT, targetList, previousEndPosT, previousStartPosT)
    if not endPointPosT then endPointPosT = startPointPosT end
local pointPosT = createPointPosT(posConfT, startPointPosT, endPointPosT)
local endPosT = createStartPosT(caster, posConfT, targetList, endPointPosT, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)

    if not endPosT then return error("missing endPosT in SPS_getEndPosT()") end
    return endPosT
end

-- feature changeEnvironment
local function SPS_createItem(itemID, pos, featureT)
    createItem(itemID, pos, 1, featureT.itemAID)
    if featureT.removeTime then addEvent(removeItemFromPos, featureT.removeTime, itemID, pos) end
end

local function SPS_changeEnvironment(cid, pos, featureT, dataT)
local tile = Tile(pos)
    if not tile then return end
    if tile:getItemById(459) then return end
    if tile:getItemById(428) then return end
local itemList = featureT.items
    
    if not itemList then return end
    
    if featureT.randomised then
        local randomItemID = randomValueFromTable(itemList)
        return SPS_createItem(randomItemID, pos, featureT)
    end
    
local itemDelay = featureT.itemDelay or 0
    for i, itemID in ipairs(itemList) do
        local delay = itemDelay*(i-1)
        addEvent(SPS_createItem, delay, itemID, pos, featureT)
    end
end

local function SPS_removeItemList(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local itemList = featureT.removeItems
    if not itemList then
        if not featureT.recastPerPos then SPS_castSpell2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
        return
    end
local itemRemoved = false
local customFuncOnRemove = featureT.customFuncOnRemove
local spawnTime = featureT.spawnTime
    
    for i, posT in pairs(endPosT) do
        for _, pos in ipairs(posT) do
            local currentItemRemoved = false
            
            for _, itemID in ipairs(itemList) do
                if removeItemFromPos(itemID, pos) then
                    itemRemoved = true
                    currentItemRemoved = true
                    
if customFuncOnRemove then _G[customFuncOnRemove](cid, itemID, pos, currentItemRemoved, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
            
                    if spawnTime then
                        local randomItemID = randomValueFromTable(itemList)
                        addEvent(createItem, spawnTime, randomItemID, pos)
                    end
                    break
                end
            end
            
            SPS_ccOnHook(featureT, pos, currentItemRemoved)
            if featureT.recastPerPos then
                if featureT.passRecastPos then endPosT = {{pos}} end
                SPS_castSpell2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT, currentItemRemoved)
            end
        end
    end
    
    if not featureT.recastPerPos then SPS_castSpell2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT, itemRemoved) end
end

function spellCreatingSystem_position_changeEnvironment(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
local environmentPosT = clearPositions(caster, targetList, endPosT, featureT.blockObjects)
local customFunc = featureT.customFunc
local sequence = 0
    
    SPS_removeItemList(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    
    for i, posT in pairs(environmentPosT) do
        for _, pos in ipairs(posT) do
            local delay = featureT.sequenceInterval*sequence + i*featureT.interval
            
            addEvent(SPS_changeEnvironment, delay, cid, pos, featureT)
            sequence = sequence + 1
        end
    end
    if customFunc then _G[customFunc](cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
end

function spellCreatingSystem_onTarget_changeEnvironment(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)

    SPS_removeItemList(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    
    for object, posT in pairs(targetList) do
        if object > 50000 then
            local creature = Creature(object)
            
            if creature then
                local creaturePos = creature:getPosition()
                
                if featureT.blockObjects then
                    for _, object in pairs(featureT.blockObjects) do
                        if checkPassed(caster, targetList, creaturePos, object) then SPS_changeEnvironment(cid, creaturePos, featureT) end
                    end
                else
                    SPS_changeEnvironment(cid, creaturePos, featureT)
                end
            end
        else
            local environmentPosT = clearPositions(caster, targetList, {posT}, featureT.blockObjects)
            
            for _, posT in pairs(environmentPosT) do
                for i, pos in ipairs(posT) do
                    SPS_changeEnvironment(cid, pos, featureT)
                end
            end
        end
    end
end

function SPS_ccOnHook(featureT, pos, onHookPassed)
    SPS_stunOnHook(featureT, pos, onHookPassed)
    SPS_bindOnHook(featureT, pos, onHookPassed)
    SPS_rootOnHook(featureT, pos, onHookPassed)
end

function SPS_stunOnHook(featureT, pos, onHookPassed)
    if not featureT.stunDuration then return end
    if featureT.stunOnHook and not onHookPassed then return end
    stunPos(pos, featureT.stunDuration, featureT.stunL)
end

function SPS_bindOnHook(featureT, pos, onHookPassed)
    if not featureT.bindMsDuration then return end
    if featureT.bindOnHook and not onHookPassed then return end
    bindPos(pos, featureT.bindMsDuration)
end

function SPS_rootOnHook(featureT, pos, onHookPassed)
    if not featureT.rootMsDuration then return end
    if featureT.rootOnHook and not onHookPassed then return end
    rootPos(pos, featureT.rootMsDuration)
end

-- feature damage
local function SPS_damage(cid, pos, featureT, dataT)
    local caster = Creature(cid)
    local minDam = featureT.minDam or 0
    local maxDam = featureT.maxDam or minDam
    local tempCid = featureT.cid or cid
    local origin = featureT.origin
    local target

    if type(pos) == "number" then
        target = Creature(pos)
        if not target then return end
        if target:getId() == cid then return end
        pos = target:getPosition()
    end
    
    if caster then
        if featureT.formulaFunc then minDam, maxDam = _G[featureT.formulaFunc](caster, target, pos) end
        sabotageQuestDamage(cid, pos) -- when cyclops deals damage when player is on certain spot then something will happen
        
        local minScale = featureT.minScale or 0
        local maxScale = featureT.maxScale or minScale
        
        if minScale > 0 or maxScale > 0 then
            local scale = getScale(cid)
            if scale then
                minDam = minDam + scale * minScale
                maxDam = maxDam + scale * maxScale
            end
        end
        
        if featureT.race then
            for race, amount in pairs(featureT.race) do
                local friends = caster:getFriends(6)
                
                for _, cid in pairs(friends) do
                    local monsterRace = getRace(cid)
                    if monsterRace and race == monsterRace then 
                        minDam = minDam + amount
                        maxDam = maxDam + amount
                    end
                end
            end
        end
    end
    
    local function damError(dam)
        if dam then return end
        if caster then print(caster:getName().." does broken damage") else print("unknown caster does broken damage") end
    end

    damError(minDam)
    damError(maxDam)

    local damage = math.random(minDam, maxDam)
    if damage < 0 then damage = 0 end
    local foundTarget = dealDamagePos(tempCid, pos, featureT.damType, damage, featureT.effectOnHit, origin, featureT.effect, featureT.effectOnMiss)
    
    if featureT.distanceEffect then
        if featureT.distanceEffectLastPos then
            for _, posT in pairs(dataT.endPosT) do
                if samePositions(posT[tableCount(posT)], pos) then
                    for _, posT in pairs(dataT.startPosT) do
                        for _, startPos in pairs(posT) do
                            doSendDistanceEffect(startPos, pos, featureT.distanceEffect)
                        end
                    end
                end
            end
        else
            for _, posT in pairs(dataT.startPosT) do
                for _, startPos in pairs(posT) do
                    doSendDistanceEffect(startPos, pos, featureT.distanceEffect)
                end
            end
        end
    end

    if foundTarget and foundTarget:isPlayer() then
        if damage > 0 then
            damage = damage + playerResistance(foundTarget, caster, damage, featureT.damType)
            damage = damage - playerArmor(foundTarget, featureT.damType)
            damage = damage - foundTarget:getDefence()

            if damage > 0 then
                damage = damage - foundTarget:getBarrier()

                if damage > 0 then
                    SPS_ccOnHook(featureT, pos, foundTarget)
                end
            end
        end
    end
    SPS_recastPerPos(cid, featureT, dataT, foundTarget)
end

local function SPS_executeDamage(cid, pos, featureT, dataT)
    local delay = 0

    for x=1, featureT.executeAmount do
        addEvent(SPS_damage, delay, cid, pos, featureT, dataT)
        delay = delay + featureT.repeatInterval
    end
end

function spellCreatingSystem_position_damage(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local dataT = SPS_createDataT(targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local interval = featureT.interval or 0
    local highestDelay = 0
    local sequence = 0

    for i, posT in pairs(endPosT) do
        local delay = interval*i
        if delay > highestDelay then highestDelay = delay end
        
        for _, pos in ipairs(posT) do
            addEvent(SPS_executeDamage, delay + featureT.sequenceInterval * sequence, cid, pos, featureT, dataT)
            sequence = sequence + 1
        end
    end
    
    if not featureT.recastPerPos then
        local totalDelay = 1 + highestDelay + featureT.sequenceInterval * sequence
        addEvent(SPS_castSpell2, totalDelay, cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    end
end

function spellCreatingSystem_onTarget_damage(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local dataT = SPS_createDataT(targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)

    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do SPS_executeDamage(cid, pos, featureT, dataT) end
        else
            SPS_executeDamage(cid, targetID, featureT, dataT)
        end
    end
    if not featureT.recastPerPos then addEvent(SPS_castSpell2, 1, cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
end

-- feature say
function spellCreatingSystem_onTarget_say(casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_say(casterID, featureT, targetList, {posT})
        else
            local creature = Creature(targetID)
            
            if creature then
                local cid = creature:getId()
                
                if featureT.msgFunc then
                    local msg = _G[featureT.msgFunc](cid)
                    creatureSay(cid, msg, featureT.msgType)
                else
                    for delay, msg in pairs(featureT.msg) do addEvent(creatureSay, delay-1000, cid, msg, featureT.msgType) end
                end
            end
        end
    end
end

function spellCreatingSystem_position_say(casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    if featureT.onlyOnce then
        if featureT.msgFunc then
            local msg = _G[featureT.msgFunc](casterID)
            creatureSay(casterID, msg, featureT.msgType)
        else
            for delay, msg in pairs(featureT.msg) do addEvent(text, delay-1000, msg, pos) end
        end
        return
    end
    
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            if featureT.msgFunc then
                local msg = _G[featureT.msgFunc](casterID)
                creatureSay(casterID, msg, featureT.msgType)
            else
                for delay, msg in pairs(featureT.msg) do addEvent(text, delay-1000, msg, pos) end
            end
        end
    end
end

-- feature spellLock
local function SPS_spellLock(monster, featureT)
    local lockSpells = featureT.lockSpells
    local unlockSpells = featureT.unlockSpells

    for _, spellName in pairs(lockSpells) do
        local spellCastT = AI_getSpellCastT(monster, spellName)
        spellCastT.spellLock = true
    end
    
    for _, spellName in pairs(unlockSpells) do
        local spellCastT = AI_getSpellCastT(monster, spellName)
        spellCastT.spellLock = false
    end
end

function spellCreatingSystem_position_spellLock(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            local monster = Tile(pos):getBottomCreature()
            if monster and monster:isMonster() then SPS_spellLock(monster, featureT) end
        end
    end
end

function spellCreatingSystem_onTarget_spellLock(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_spellLock(cid, featureT, targetList, {posT})
        else
            local monster = Monster(targetID)
            if monster then SPS_spellLock(monster, featureT) end
        end
    end
end

-- feature spellLockCD
local function SPS_spellLockCD(monster, featureT)
    for CD, spellNameT in pairs(featureT) do
        if tonumber(CD) then            
            for _, spellName in pairs(spellNameT) do
                local spellCastT = AI_getSpellCastT(monster, spellName)
                spellCastT.cooldown = 0
                spellCastT.firstCastCD = CD
            end
        end
    end
end

function spellCreatingSystem_onTarget_spellLockCD(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_spellLockCD(cid, featureT, targetList, {posT})
        else
            local monster = Monster(targetID)
            if monster then SPS_spellLockCD(monster, featureT) end
        end
    end
end

function spellCreatingSystem_position_spellLock(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            local monster = Tile(pos):getBottomCreature()
            if monster and monster:isMonster() then SPS_spellLockCD(monster, featureT) end
        end
    end
end

-- feature event
local function SPS_event(creature, featureT)
    local function reg(event)
        for _, eventName in ipairs(featureT.register[event]) do
            registerEvent(creature, event, eventName)
            if featureT.duration then addEvent(unregisterEvent, featureT.duration*1000, creature:getId(), event, eventName) end
        end
    end

    local function unReg(event)
        for _, eventName in ipairs(featureT.unregister[event]) do unregisterEvent(creature, event, eventName) end
    end

    local events = {"onThink", "onHealthChange", "onDeath"}
    for _, event in ipairs(events) do
        reg(event)
        unReg(event)
    end
end

function spellCreatingSystem_position_event(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            local monster = Tile(pos):getBottomCreature()
            if monster and monster:isMonster() then SPS_event(monster, featureT) end
        end
    end
end

function spellCreatingSystem_onTarget_event(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_event(cid, featureT, targetList, {posT})
        else
            local creature = Creature(targetID)
            if creature then SPS_event(creature, featureT) end
        end
    end
end

-- feature resistance
local function SPS_resistance(creature, featureT)
    local cid = creature:getId()
    if not temporarResByCid[cid] then temporarResByCid[cid] = {} end
    local resT = temporarResByCid[cid]
    
    for damType, amount in pairs(featureT) do
        if type(damType) == "number" then
            local previousRes = resT[damType] or 0
            resT[damType] = previousRes + amount
        end
    end
    
    if featureT.duration then addEvent(SPS_removeResistance, featureT.duration, cid, featureT) end
end

function SPS_removeResistance(cid, featureT)
    local resT = temporarResByCid[cid]
    if not resT then return end
    local creature = Creature(cid)
    if not creature then temporarResByCid[cid] = nil return end
    
    for damType, amount in pairs(featureT) do
        if type(damType) == "number" then
            local previousRes = resT[damType] or 0
            resT[damType] = previousRes - amount
        end
    end
end

function spellCreatingSystem_position_resistance(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            local creature = Tile(pos):getBottomCreature()
            if creature then SPS_resistance(creature, featureT) end
        end
    end
end

function spellCreatingSystem_onTarget_resistance(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_resistance(cid, featureT, targetList, {posT})
        else
            local creature = Creature(targetID)
            if creature then SPS_resistance(creature, featureT) end
        end
    end
end

function clean_tempResistances()
    local tablesDeleted = 0

    for cid, resT in pairs(temporarResByCid) do
        if not Creature(cid) then
            tablesDeleted = tablesDeleted + 1
            temporarResByCid[cid] = nil
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from temporarResByCid") end
    return tablesDeleted
end

-- feature teleport
local function SPS_teleportEffects(startPos, endPos, featureT)
    if featureT.effectOnCast then doSendMagicEffect(startPos, featureT.effectOnCast, featureT.effectInterval) end
    if featureT.effectOnPos then doSendMagicEffect(endPos, featureT.effectOnPos, featureT.effectInterval) end
end

local function nextPos(i, j, endPosT)
    if endPosT[i][j+1] then return endPosT[i][j+1] end
    if endPosT[i+1] then return endPosT[i+1][1] end
end

local function SPS_teleporItem(itemID, startPos, endPos, featureT)
    local item = findItem(itemID, startPos)    
        
    if not item then return end
    item:moveTo(endPos)
    SPS_teleportEffects(startPos, endPos, featureT)
end

local function SPS_startTeleportingItem(itemID, pos, featureT, endPosT)
    local item = findItem(itemID, pos)    
    if not item then return end
    local teleportInterval = featureT.walkSpeed
    local delay = 0

    for i, posT in pairs(endPosT) do
        for j, pos in pairs(posT) do
            SPS_teleporItem(itemID, item:getPosition(), pos, featureT)
            if not teleportInterval then return end
            
            local nextPos = nextPos(i, j, endPosT)
            if not nextPos then return end
            delay = delay + teleportInterval
            addEvent(SPS_teleporItem, delay, itemID, pos, nextPos, featureT)
        end
    end
end

local function SPS_teleporCreature(cid, endPos, featureT)
    local creature = Creature(cid)

    if not creature then return end
    if featureT.unFocus then unFocus(cid) end
    teleport(creature, endPos, true)
    SPS_teleportEffects(creature:getPosition(), endPos, featureT)
end

local function SPS_speedBuffDuration(teleportInterval, endPosT)
    local speedBuffDuration = 0
        
    if not teleportInterval then return speedBuffDuration end
    for i, posT in pairs(endPosT) do
        for j, pos in pairs(posT) do speedBuffDuration = speedBuffDuration + teleportInterval end
    end
    return speedBuffDuration
end

local function SPS_startTeleportingCreature(cid, featureT, endPosT)
    local creature = Creature(cid)
    if not creature then return end
    local teleportInterval = featureT.teleportInterval or 0
    local tempSpeed = featureT.walkSpeed or 0
    local delay = 0
    local speedBuffDuration = SPS_speedBuffDuration(teleportInterval, endPosT)
    local moveOnlyOnce = false

    if speedBuffDuration > 0 then
        if tableCount(endPosT) == 1 and tableCount(endPosT[1]) == 1 then moveOnlyOnce = true end
        
        if tempSpeed > 0 and creature:getSpeed() < tempSpeed then
            tempSpeed = tempSpeed - creature:getSpeed()
            bindCondition(creature, "tempSpeed", speedBuffDuration, {speed = tempSpeed})
        end
    else
        moveOnlyOnce = true
    end
    
    for i, posT in ipairs(endPosT) do
        for j, pos in ipairs(posT) do
            if moveOnlyOnce then return SPS_teleporCreature(cid, pos, featureT) end
            local nextPos = nextPos(i, j, endPosT)
            if not nextPos then return end
            delay = delay + teleportInterval
            addEvent(SPS_teleporCreature, delay, cid, nextPos, featureT)
        end
    end
end

function spellCreatingSystem_position_teleport(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do SPS_startTeleportingItem(targetID, pos, featureT, endPosT) end
        else
            SPS_startTeleportingCreature(targetID, featureT, endPosT)
        end
    end
end

function spellCreatingSystem_onTarget_teleport(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    return spellCreatingSystem_position_teleport(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
end

-- feature magicEffect
function spellCreatingSystem_position_magicEffect(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local sequence = 0

    for i, posT in pairs(endPosT) do
        for j, pos in pairs(posT) do
            addEvent(doSendMagicEffect, featureT.waveInterval*(i-1) + featureT.sequenceInterval*sequence, pos, featureT.effect, featureT.effectInterval)
            sequence = sequence + 1
        end
    end
end

function spellCreatingSystem_onTarget_magicEffect(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                local item = findItem(targetID, pos)
                if item then doSendMagicEffect(pos, featureT.effect, featureT.effectInterval) end
            end
        else
            local creature = Creature(targetID)
            if creature then doSendMagicEffect(creature:getPosition(), featureT.effect, featureT.effectInterval) end
        end
    end
end

function spellCreatingSystem_position_magicEffect2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    return spellCreatingSystem_position_magicEffect(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
end

function spellCreatingSystem_onTarget_magicEffect2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    return spellCreatingSystem_onTarget_magicEffect2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
end

-- feature flyingEffect
function spellCreatingSystem_position_flyingEffect(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local sequenceInterval = featureT.sequenceInterval
    local interval = 0

    for _, startingPosT in pairs(startPosT) do
        for _, startPos in pairs(startingPosT) do
            for _, posT in pairs(endPosT) do
                for _, endPos in pairs(posT) do
                    addEvent(doSendDistanceEffect, sequenceInterval*interval, startPos, endPos, featureT.effect)
                    interval = interval + 1
                end
            end
        end
    end
end

function spellCreatingSystem_onTarget_flyingEffect(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local sequenceInterval = featureT.sequenceInterval
    local interval = 0

    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                local item = findItem(targetID, pos)
                if item then
                    for _, posT in pairs(endPosT) do
                        for _, endPos in pairs(posT) do
                            addEvent(doSendDistanceEffect, sequenceInterval*interval, pos, endPos, featureT.effect)
                            interval = interval + 1
                        end
                    end
                end
            end
        else
            local creature = Creature(targetID)
            if creature then
                local startPos = creature:getPosition()
                
                for _, posT in pairs(endPosT) do
                    for _, endPos in pairs(posT) do
                        addEvent(doSendDistanceEffect, sequenceInterval*interval, startPos, endPos, featureT.effect)
                        interval = interval + 1
                    end
                end
            end
        end
    end
end

-- feature stun
function spellCreatingSystem_position_stun(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, endPos in pairs(posT) do
            stunPos(endPos, featureT.msDuration, featureT.stunL)
        end
    end
end

function spellCreatingSystem_onTarget_stun(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                if findItem(targetID, pos) then stunPos(pos, featureT.msDuration, featureT.stunL) end
            end
        else
            local creature = Creature(targetID)
            if creature then stun(creature, featureT.msDuration, featureT.stunL) end
        end
    end
end

-- feature bind
function spellCreatingSystem_position_bind(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, endPos in pairs(posT) do
            bindPos(endPos, featureT.msDuration)
        end
    end
end

function spellCreatingSystem_onTarget_bind(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                if findItem(targetID, pos) then bindPos(pos, featureT.msDuration) end
            end
        else
            local creature = Creature(targetID)
            if creature then bind(creature, featureT.msDuration) end
        end
    end
end

-- feature root
function spellCreatingSystem_position_root(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, posT in pairs(endPosT) do
        for _, endPos in pairs(posT) do
            rootPos(endPos, featureT.msDuration)
        end
    end
end

function spellCreatingSystem_onTarget_root(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                if findItem(targetID, pos) then rootPos(pos, featureT.msDuration) end
            end
        else
            local creature = Creature(targetID)
            if creature then root(creature, featureT.msDuration) end
        end
    end
end

-- feature builder
local function SPS_builder(startPos, direction, featureT)
    if not featureT[direction] then
        local letterT = stringToLetterT(direction)
        local areaFound = false
        
        for _, dir in pairs(letterT) do
            if builder[dir] then
                direction = dir
                areaFound = true
                break
            end
        end
        
        if not areaFound then return end
    end
    local itemAreaT = featureT[direction]
    local areaT = {}
    local index = 0
    local itemsByIndex = {}

    for i, itemIndexT in ipairs(itemAreaT) do
        areaT[i] = {}
        
        for j, itemID in pairs(itemIndexT) do
            if itemID > 0 then
                index = index + 1
                itemsByIndex[index] = itemID
                areaT[i][j] = index
            else
                areaT[i][j] = 0
            end
        end
    end
local area = getAreaPos(startPos, areaT)
local loopID = 0

    for _, posT in ipairs(area) do
        for _, pos in ipairs(posT) do
            loopID = loopID + 1
            local itemID = itemsByIndex[loopID]
            if itemID > 0 then SPS_createItem(itemID, pos, featureT) end
        end
    end
end

function spellCreatingSystem_position_builder(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for _, startingPosT in pairs(startPosT) do
        for _, startPos in pairs(startingPosT) do
            for _, posT in pairs(endPosT) do
                for _, endPos in pairs(posT) do
                    local direction = getDirection(startPos, endPos)
                    SPS_builder(startPos, direction, featureT)
                end
            end
        end
    end
end

function spellCreatingSystem_onTarget_builder(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                local item = findItem(targetID, pos)
                if item then
                    for _, posT in pairs(endPosT) do
                        for _, endPos in pairs(posT) do
                            local direction = getDirection(pos, endPos)
                            SPS_builder(pos, direction, featureT)
                        end
                    end
                end
            end
        else
            local creature = Creature(targetID)
            if creature then
                local newStartPos = featureT.startPoint
                local direction = getDirectionStrFromCreature(creature)
                
                if newStartPos then
                    if newStartPos == "caster" then
                        local caster = Creature(cid)
                        if caster then direction = getDirection(caster:getPosition(), creature:getPosition()) end
                    end
                end
                
                SPS_builder(creature:getPosition(), direction, featureT)
            end
        end
    end
end

-- feature conditions
conditionsStacks = {}
local function getCreatureStack(creature, conditionKey, duration)
    local cid = creature:getId()
    if not conditionsStacks[cid] then conditionsStacks[cid] = {} end
    local creatureStackT = conditionsStacks[cid]
    if not creatureStackT[conditionKey] then creatureStackT[conditionKey] = {stack = 0, endTime = 0} end
    local currentStackT = creatureStackT[conditionKey]
    local newStack = currentStackT.stack + 1

    if currentStackT.endTime < os.time() then newStack = 1 end
    currentStackT.endTime = os.time() + math.ceil(duration/1000)
    currentStackT.stack = newStack
    return newStack
end

local function createParamT(creature, t, conditionKey)
    local maxStack = t.maxStack

    if maxStack == 1 then return t.paramT end
    local paramT = {}
    local creatureStack = getCreatureStack(creature, conditionKey, t.duration)
    local stackAmount = creatureStack

    if creatureStack > maxStack then stackAmount = maxStack end
    for param, value in pairs(t.paramT) do paramT[param] = value * stackAmount end
    return paramT
end

local function SPS_conditions(cid, featureT)
    local creature = Creature(cid)
    local conditionT = featureT.conditionT

    if not creature then return end
    if creature:isMonster() and featureT.noMonsters then return end
    
    for conditionKey, t in pairs(conditionT) do
        local paramT = createParamT(creature, t, conditionKey)
        bindCondition(creature, conditionKey, t.duration, paramT)
    end
end

local function SPS_conditionsToEndPosT(endPosT, featureT)
    for _, posT in pairs(endPosT) do
        for _, pos in pairs(posT) do
            local creature = Tile(pos):getBottomCreature()
            if creature then SPS_conditions(creature, featureT) end
        end
    end
end

function spellCreatingSystem_position_conditions(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for x=1, featureT.repeatAmount do addEvent(SPS_conditionsToEndPosT, featureT.interval * (x-1), endPosT, featureT) end
end

function spellCreatingSystem_onTarget_conditions(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            spellCreatingSystem_position_conditions(cid, featureT, targetList, {posT})
        else
            for x=1, featureT.repeatAmount do addEvent(SPS_conditions, featureT.interval * (x-1), targetID, featureT) end
        end
    end
end

function clean_conditionsStacks()
    local tablesDeleted = 0

    for cid, stackT in pairs(conditionsStacks) do
        if not Creature(cid) then
            tablesDeleted = tablesDeleted + 1
            conditionsStacks[cid] = nil
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from conditionsStacks") end
    return tablesDeleted
end

-- feature summon
local function SPS_summon(cid, featureT, pos)
    local caster = Creature(cid)
    if not caster then return end
    local currentSummonAmount = tableCount(caster:getSummons())
    local maxSummons = featureT.maxSummons
    local summoned = false

    if currentSummonAmount >= maxSummons then return end
    
    for monsterName, t in pairs(featureT.summons) do
        for x=1, t.amount do
            if currentSummonAmount >= maxSummons then return end
            currentSummonAmount = currentSummonAmount + 1
            local summon = createMonster(monsterName, pos)
            summoned = true
            summon:setMaster(caster)
            if t.monsterHP then summon:setMaxHealth(t.monsterHP) end
        end
    end
    return summoned
end

local function getSummonAmount(featureT)
    if featureT.summonAmount then return featureT.summonAmount end
    local totalAmount = 0
        
    for monsterName, t in pairs(featureT.summons) do totalAmount = totalAmount + t.amount end
    return totalAmount
end

function spellCreatingSystem_position_summon(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local caster = Creature(cid)
    if not caster then return end
    local currentSummonAmount = tableCount(caster:getSummons())
    local maxSummons = featureT.maxSummons
    if currentSummonAmount >= maxSummons then return end
    local summonAmount = getSummonAmount(featureT)
    local posT = randomPos(endPosT, summonAmount)
    local sequence = 0
    local summoned = false
    
    for monsterName, t in pairs(featureT.summons) do
        for x=1, t.amount do
            if currentSummonAmount >= maxSummons then return end
            sequence = sequence + 1
            currentSummonAmount = currentSummonAmount + 1
            local summon = createMonster(monsterName, posT[sequence])
            summoned = true
            summon:setMaster(caster)
            if t.monsterHP then summon:setMaxHealth(t.monsterHP) end
        end
    end
    SPS_castSpell2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT, summoned)
end

function spellCreatingSystem_onTarget_summon(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local summoned = false

    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do
                if findItem(targetID, pos) and SPS_summon(cid, featureT, pos) then summoned = true end
            end
        else
            local creature = Creature(targetID)
            if creature and SPS_summon(cid, featureT, creature:getPosition()) then summoned = true end
        end
    end
    
    SPS_castSpell2(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT, summoned)
end

-- feature heal
function SPS_heal(cid, pos, featureT, dataT)
    local caster = Creature(cid)
    if not caster then return end
    local targetID = pos
    local healTarget = false

    if type(pos) == "number" then
        local target = Creature(pos)
        if not target then return end
        pos = target:getPosition()
        doSendMagicEffect(pos, featureT.effect)
        healTarget = true
    else
        local tile = Tile(pos)
        doSendMagicEffect(pos, featureT.effect)
        if not tile then return end
        local target = tile:getBottomCreature()
        if not target then return end
        targetID = target:getId()
        
        for cid, posT in pairs(dataT.targetList) do
            if targetID == cid then healTarget = true break end
        end
    end
    
    
    if not healTarget then return SPS_recastPerPos(cid, featureT, dataT) end
    if featureT.healTarget then
        if featureT.healTarget == "player" and not Creature(targetID):isPlayer() then return SPS_recastPerPos(cid, featureT, dataT) end
        if featureT.healTarget == "monster" and not Creature(targetID):isMonster() then return SPS_recastPerPos(cid, featureT, dataT) end
    end
    local minHeal = featureT.minHeal or percentage(caster:getMaxHealth(), featureT.percentAmount)
    local maxHeal = featureT.maxHeal or minHeal
    local healed = false
    local minScale = featureT.minScale
    local maxScale = featureT.maxScale

    if minScale > 0 or maxScale > 0 then
        local scale = getScale(cid)
        if scale then
            minHeal = minHeal + scale * minScale
            maxHeal = maxHeal + scale * maxScale
        end
    end
    local healAmount = math.random(minHeal, maxHeal)
    local maxHPMultiplier = featureT.maxHPMultiplier

    if featureT.race then
        for race, amount in pairs(featureT.race) do
            local friends = caster:getFriends(6)
            
            for _, cid in pairs(friends) do
                local monsterRace = getRace(cid)
                if monsterRace and race == monsterRace then healAmount = healAmount + amount end
            end
        end
    end

    if healAmount < 0 then return SPS_recastPerPos(cid, featureT, dataT) end
    
    if maxHPMultiplier then
        local target = Creature(targetID)
        local targetHP = target:getHealth()
        local targetMaxHP = target:getMaxHealth()
        local maxHPLimit = featureT.maxHPLimit
        
        if targetMaxHP < maxHPLimit and targetHP + healAmount > targetMaxHP then
            local baseAmount = targetHP + healAmount - targetMaxHP
            local newAmount = 0
            
            if maxHPMultiplier < 0  then
                newAmount = targetMaxHP + math.floor(baseAmount/-maxHPMultiplier)
            else
                newAmount = targetMaxHP + math.floor(baseAmount*maxHPMultiplier)
            end
            
            if newAmount > maxHPLimit then newAmount = maxHPLimit end
            target:setMaxHealth(newAmount)
            healAmount = newAmount
        end
    end
    
    healed = heal(targetID, healAmount)
    SPS_ccOnHook(featureT, pos, healed)
    SPS_recastPerPos(cid, featureT, dataT, healed)
end

local function SPS_prepHeal(cid, pos, featureT, dataT)
    local delay = 0

    for x=1, featureT.executeAmount do
        addEvent(SPS_heal, delay, cid, pos, featureT, dataT)
        delay = delay + featureT.repeatInterval
    end
end

function spellCreatingSystem_position_heal(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local dataT = SPS_createDataT(targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local interval = featureT.interval or 0
    local highestDelay = 0

    for i, posT in pairs(endPosT) do
        local delay = interval*i
        if delay > highestDelay then highestDelay = delay end
        
        for _, pos in ipairs(posT) do addEvent(SPS_prepHeal, delay, cid, pos, featureT, dataT) end
    end
    
    if not featureT.recastPerPos then addEvent(SPS_castSpell2, highestDelay+1, cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
end

function spellCreatingSystem_onTarget_heal(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    local dataT = SPS_createDataT(targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)

    for targetID, posT in pairs(targetList) do
        if targetID < 50000 then
            for _, pos in pairs(posT) do SPS_prepHeal(cid, pos, featureT, dataT) end
        else
            SPS_prepHeal(cid, targetID, featureT, dataT)
        end
    end
    if not featureT.recastPerPos then addEvent(SPS_castSpell2, 1, cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT) end
end

-- feature customFeature
function spellCreatingSystem_position_customFeature(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    return _G[featureT.func](cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
end

function spellCreatingSystem_onTarget_customFeature(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    return spellCreatingSystem_position_customFeature(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
end

-- other spellCreating related functions
local function pointPosFunc_checkPath(posConfT, startPos, endPos)
    if not posConfT.checkPath then return true end
    local path = getPath(startPos, endPos)

    if not path then return end

    for _, pos in ipairs(path) do
        for _, obstacle in ipairs(posConfT.checkPath) do
            if hasObstacle(pos, obstacle) then return end
        end
    end
    return true
end

function pointPosFunc_far(posConfT, startPointPosT, endPointPosT)
    local pointPosT = {}
        
    for _, startPos in pairs(startPointPosT) do
        local selectedPos
        local range = -1
        
        for _, endPos in pairs(endPointPosT) do
            if pointPosFunc_checkPath(posConfT, startPos, endPos) then
                local currentDistance = getDistanceBetween(startPos, endPos)
                
                if currentDistance > range then
                    range = currentDistance
                    selectedPos = endPos
                end
            end
        end
        pointPosT[startPos] = {selectedPos}
    end
    return pointPosT
end

function pointPosFunc_near(posConfT, startPointPosT, endPointPosT)
    local pointPosT = {}
        
    for _, startPos in pairs(startPointPosT) do
        local selectedPos
        local range = 15
        
        for _, endPos in pairs(endPointPosT) do
            if pointPosFunc_checkPath(posConfT, startPos, endPos) then
                local currentDistance = getDistanceBetween(startPos, endPos)
                
                if currentDistance < range then
                    range = currentDistance
                    selectedPos = endPos
                end
            end
        end
        pointPosT[startPos] = {selectedPos}
    end
    return pointPosT
end

function cyclopsDagosil(cid, itemID, pos, currentItemRemoved)
    if not currentItemRemoved then return end
    local delay = 2*61*1000     -- time it with cyclops pick stone
        
    if not Tile(pos):getItemById(4155) and chanceSuccess(20) then
        addEvent(createItem, delay, 4155, pos, 1, AID.herbs.dagosil)
    else
        local function replaceDagosil(pos)
            if removeItemFromPos(4155, pos) then createItem(4155, pos, 1, AID.herbs.dagosil) end
        end
        
        addEvent(replaceDagosil, delay, pos)
    end
end