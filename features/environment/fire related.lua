local heyT = {5485, 5486, 5487, 5488, 5489, 5490, 5491, 5492, 5493, 5494, 5495, 5500, 5501, 5502, 5503, 5555, 5556, 3848, 3849, 3851, 3850}

local function catchFire(creatureID, pos)
    local positions = getAreaAround(pos)
    for _, newPos in pairs(positions) do addEvent(burnTheHey, 1000*math.random(2,5), creatureID, newPos) end
end

local function getHey(pos)
    local tile = Tile(pos)
    if not tile then return end
    
    for _, heyID in pairs(heyT) do
        local hey = tile:getItemById(heyID)
        if hey then return hey end
    end
end

function burnTheHey(creatureID, pos)
    local hey = getHey(pos)
    if not hey then return end
    local creature = Creature(creatureID)
    local heyAID = hey:getActionId()
    creatureID = creature and creature:getId() or creatureID
    
    cyclopsSabotageQuest_sabotageDeers(creatureID, heyAID)
    doSendMagicEffect(pos, 16)
    createItem(1492, pos, 1, AID.other.field_fire, nil, "minDam(220) maxDam(340)")
    addEvent(catchFire, 200, creatureID, pos)
    addEvent(createItem, 5*60*1000, heyID, pos, 1, heyAID)
    decay(pos, fireFieldDecayT, true)
    return hey:remove()
end

function setBasinOnFire(pos)
    if not doTransform(1481, pos, 1484, true) then return end
    doSendMagicEffect(pos, 37)
    addEvent(doTransform, 1000*60*40, 1484, pos, 1481)
end

function setCampfireOnFire(pos)
    return doTransform(1422, pos, 1423, true) and doSendMagicEffect(pos, 37)
end

