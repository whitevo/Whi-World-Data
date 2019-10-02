function registerEvent(creatureID, event, eventName)
    local creature = Creature(creatureID)
    if not creature then return end
    
    local events = {"onThink", "onDeath", "onHealthChange"}
    if not isInArray(events, event) then return print("ERROR - unknown event["..tostring(event).."] in registerEvent()") end
    local scripT = {[creature:getId()] = eventName}

    creature:registerEvent(event)
    if event == "onThink" then return registerEvent_onThink(scripT) end
    if event == "onDeath" then return registerEvent_onDeath(scripT) end
    if event == "onHealthChange" then return registerEvent_onHealthChange(scripT) end
end

function unregisterEvent(creatureID, event, eventName)
    local creature = Creature(creatureID)
    if not creature then return end

    local events = {"onThink", "onDeath", "onHealthChange"}
    if not isInArray(events, event) then return print("ERROR - unknown event["..tostring(event).."] in registerEvent()") end
    creatureID = creature:getId()
    local scripT
    
    if event == "onThink" then scripT = onThinkScripts[creatureID] end
    if event == "onDeath" then scripT = onDeathScripts[creatureID] end
    if event == "onHealthChange" then scripT = onHealthChangeScripts[creatureID] end
    
    if tableCount(scripT) == 0 then return creature:unregisterEvent(event) end
    for i, eventName2 in pairs(scripT) do
        if eventName2 == eventName then return table.remove(scripT, i) end
    end
end

local function registerScriptT(configTable, updateT)
    if not updateT then return end
    if type(updateT) ~= "table" then updateT = {updateT} end
    
    for creatureID, funcT in pairs(updateT) do
        local scripts = configTable[creatureID]
        
        if type(funcT) ~= "table" then funcT = {funcT} end
        
        if scripts then
            for _, funcStr in pairs(funcT) do
                if not isInArray(scripts, funcStr) then table.insert(scripts, funcStr) end
            end
        else
            configTable[creatureID] = funcT
        end
    end
end

function registerEvent_onThink(scripT)
    for creatureID, _ in pairs(scripT) do Creature(creatureID):registerEvent("onThink") end
    return registerScriptT(onThinkScripts, scripT)
end

function registerEvent_onDeath(scripT)
    for creatureID, _ in pairs(scripT) do Creature(creatureID):registerEvent("onDeath") end
    return registerScriptT(onDeathScripts, scripT)
end

function registerEvent_onHealthChange(scripT)
    for creatureID, _ in pairs(scripT) do Creature(creatureID):registerEvent("onHealthChange") end
    return registerScriptT(onHealthChangeScripts, scripT)
end

function eventRemove(cid, name)
    local creature = Creature(cid)
    return creature and creature:unregisterEvent(name)
end

function targetIsCorrect(creature, object, ignoreDead, ignoreGod)
    if object == "creature" then return true end
    if object == "player" then
        if not creature:isPlayer() then return end
        local ignoreDead = ignoreDead or ignoreDead == nil
        local ignoreGod = ignoreGod or ignoreGod == nil
        local notDead = ignoreDead or getSV(creature, SV.playerIsDead) ~= 1
        local notGod = ignoreGod or not creature:isGod()
        return notDead and notGod
    end
    if object == "monster" then return creature:isMonster() end
    if object == "npc" then return creature:isNpc() end
end

function massTeleport(fromPos, toPos, objectT)
    local tile = Tile(fromPos)
    if not tile then return end
    if type(objectT) == "string" then objectT = {objectT} end

    for _, object in pairs(objectT) do
        if type(object) == "string" then
            local creatures = tile:getCreatures() or {}
            
            for _, creature in pairs(creatures) do
                if targetIsCorrect(creature, object, false) then teleport(creature, toPos) end
            end
        elseif type(object) == "number" then
            local items = findItems(object, fromPos) or {}
            for _, item in pairs(items) do item:moveTo(toPos) end
        else
            print("massTeleport(), unknown type: "..type(object))
        end
    end
end

function climbOn(creature, item) return teleport(creature, item:getPosition(), true) end

function teleport(creatureID, pos, walk, dir)
    local creature = Creature(creatureID)
    if not creature then return end
    local creaturePos = creature:getPosition()

    removeStun(creaturePos)
    removeRoot(creaturePos)
    removeBind(creaturePos)
    if dir then addEvent(doTurn, 100, creature:getId(), dir) end
    return creature:teleportTo(pos, walk)
end

function tile460_teleportBack(creature, item, _, fromPos, toPos)
    local itemAID = item:getActionId()
    if itemAID < 100 then return end
    if itemAID > 2000 and creature:isPlayer() then creature:sendTextMessage(GREEN, "[USE] tile to build. [LOOK] tile to see, what you need.") end
    teleportBack(creature, item, toPos, fromPos)
end

function teleportBack(creature, item, _, fromPos) return teleport(creature, fromPos) end
function doSetOutfit(creatureID, outfit) return Creature(creatureID) and Creature(creatureID):setOutfit(outfit) end
function removeCreature(creatureID) return Creature(creatureID) and Creature(creatureID):remove() end

function walkTo(creatureID, targetPos, obstacles, interval, dontStepFinalPos)
local creature = Creature(creatureID)
    if not creature then return end
local startPos = creature:getPosition()
local walkPath = getPath(startPos, targetPos, obstacles)
local totalAmountOfPositions = tableCount(walkPath)
    if totalAmountOfPositions == 0 then return end
local creatureID = creature:getId()

    for i, pos in ipairs(walkPath) do
        if not samePositions(startPos, pos) then
            if not dontStepFinalPos or i ~= totalAmountOfPositions then
                addEvent(teleport, (i-1)*interval, creatureID, pos, true)
            end
        end
    end
    
    if dontStepFinalPos then totalAmountOfPositions = totalAmountOfPositions - 1 end
    return totalAmountOfPositions * interval
end

function creatureSay(creatureID, text, msgType)
local creature = Creature(creatureID)
local msgType = msgType or YELLOW

    return creature and creature:say(text, msgType)
end

function Creature.getClosestFreePosition(creature, distance)
local startPos = creature:getPosition()

    return creature:isGod() and startPos or getClosestFreePosition(startPos, distance)
end

function getFurthestTargetID(endPos, targetList)
local furthestDistance = 0
local furthestTargetID

    for _, targetID in pairs(targetList) do
        local target = Creature(targetID)
        
        if target then
            local distance = getDistanceBetween(target:getPosition(), endPos)
            
            if distance > furthestDistance then
                furthestDistance = distance
                furthestTargetID = target:getId()
            end
        end
    end
    return furthestTargetID, furthestDistance
end

function getClosestTargetID(endPos, targetList)
local closestDistance = 10
local closestTargetID

    for _, targetID in pairs(targetList) do
        local target = Creature(targetID)
        
        if target then
            local distance = getDistanceBetween(target:getPosition(), endPos)
            
            if distance < closestDistance then
                closestDistance = distance
                closestTargetID = target:getId()
            end
        end
    end
    return closestTargetID, closestDistance
end

function Creature.getRealName(creature)
    if creature:isMonster() then
        local monsterT = getMonsterT(creature)
        if monsterT then return monsterT.name:lower() end
    end
    return creature:getName():lower()
end

function Creature.isDead(creature)
    if creature:isPlayer() then
        if getSV(creature, SV.playerIsDead) == 1 then return true end
        if getSV(creature, SV.fakedeathOutfit) == 1 then return true end
    end
end

function Creature.isGod(creature) 
    if not creature:isPlayer() then return end
    return creature:getSV(SV.isGod) == 1 or creature:getGroup():getAccess()
end

function Creature.isMage(creature) return creature:isPlayer() and creature:getVocation():getName() == "mage" end
function Creature.isDruid(creature) return creature:isPlayer() and creature:getVocation():getName() == "druid" end
function Creature.isHunter(creature) return creature:isPlayer() and creature:getVocation():getName() == "hunter" end
function Creature.isKnight(creature) return creature:isPlayer() and creature:getVocation():getName() == "knight" end
function Creature.isSpecialBag() return false end
function Creature.isContainer()	return false end
function Creature.isItem() return false end
function Creature.isMonster() return false end
function Creature.isNpc(creature) return getNpcT(creature) end
function Creature.isPlayer() return false end
function Creature.isTile() return false end
function Creature.isStunned(creature) return findItem(11320, creature:getPosition(), AID.other.stun) end
function Creature.isRooted(creature) return findItem(11320, creature:getPosition(), AID.other.root) end
function Creature.isBinded(creature) return findItem(11320, creature:getPosition(), AID.other.bind) end
function Creature.isWeakened(creature) return findItem(nil, creature:getPosition(), AID.jazmaz.monsters.seaGuard_field) end

function getTempResByCid(creature, damType) -- undocumented
    local resT = temporarResByCid[creature:getId()]
    return resT and resT[damType] or 0
end