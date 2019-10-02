function heatSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("heat") end
    local damage = spells_getFormulas(player, spellT)
    local range = spells_getRange(player, spellT)
    local damType = getEleTypeEnum(spellT.spellType)
    local playerPos = player:getPosition()
    local target = player:getTarget()
    local effectOnHit = 6
    local frontPos = player:frontPos()
    
    local function maybeSpellDam(newPos, damage)
        atsuiKori(player, nil, newPos, damage, damType)
        dealDamagePos(player, newPos, damType, damage, effectOnHit, O_player_spells, 16)
        fireSpecialFunctions(player, newPos)
    end
    
    if not target then return maybeSpellDam(frontPos, damage) end
    local targetPos = target:getPosition()
    
    if getDistanceBetween(playerPos, targetPos) > range then return maybeSpellDam(frontPos, damage) end
    
    if not namiBoots_equipped(player) then
        atsuiKori(player, target, nil, damage, damType)
        potions_spellCaster_heal(player)
        dealDamage(player, target, damType, damage, effectOnHit, O_player_spells)
    else
        local posT = getPath(playerPos, targetPos)
        if not posT then return maybeSpellDam(frontPos, damage) end
        for i, pos in ipairs(posT) do
            if i ~= 1 then maybeSpellDam(pos, damage) end
        end
    end
    playerPos:sendDistanceEffect(targetPos, 4)
end

function fireSpecialFunctions(player, pos)
    local playerID = player:getId()
    doTransform(1422, pos, 1423, true)
    heatSpellOnBarrel(pos)
    burnTheHey(playerID, pos)
    cyclopsAlcoholBarrels(playerID, pos)
end