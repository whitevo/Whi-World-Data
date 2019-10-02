function strikeSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("strike") end
    
    local damage = spells_getFormulas(player, spellT)
    local range = spells_getRange(player, spellT)
    local target = player:getTarget()
        
    if not target then return dealStrikeDamage(player, damage, range) end
    
    local targetPos = target:getPosition()
    
    if getDistanceBetween(player:getPosition(), targetPos) > range then return dealStrikeDamage(player, damage, range) end
    strikeSpell_bonusEffects(player, targetPos, target)
    warriorHelmet(player, targetPos, damage)
    dealDamage(player, target, PHYSICAL, damage, 4, O_player_spells)
end

function dealStrikeDamage(player, damage, range)
    for x=1, range do
        local frontPos = player:frontPos(x)
        dealDamagePos(player, frontPos, PHYSICAL, damage, 10, O_player_spells, 4)
        strikeSpell_bonusEffects(player, frontPos)
        warriorHelmet(player, frontPos, damage)
    end
end

function strikeSpell_bonusEffects(player, pos, target)
    if not target then
        target = findCreature("creature", pos)
        if not target then return end
        if not PVP_allowed(player, target) then return end
    end
    potions_spellCaster_heal(player)
end