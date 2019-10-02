function tauntSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("taunt") end
    
    local target = player:getTarget()
    if not target then return player:sendTextMessage(GREEN, "Taunt failed, you have no target") end
    
    local duration = spells_getFormulas(player, spellT)
    if duration < 1 then return player:sendTextMessage(GREEN, "Taunt failed, taunt duration is 0 seconds") end
    
    local playerPos = player:getPosition()
    local targetPos = target:getPosition()

    doSendMagicEffect(playerPos, {2,20})
    doSendDistanceEffect(playerPos, targetPos, 9)
    if not namiBoots_equipped(player) then return tauntSpell_taunt(player, target, duration) end
    
    local path = getPath(playerPos, targetPos)
    for i, pos in ipairs(path) do
        if i ~= 1 then
            local target = findCreature("monster", pos)
            if target then tauntSpell_taunt(player, target, duration) end
        end
    end
end

function tauntSpell_taunt(player, target, duration)
    local targetID = target:getId()
    
    doSendMagicEffect(target:getPosition(), {2,20})
    tauntedCreatures[targetID] = player:getId()
    addEvent(function() tauntedCreatures[targetID] = nil end, duration*1000)
    target:setTarget(player)
end