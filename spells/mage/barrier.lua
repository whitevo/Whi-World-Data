function barrierSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("barrier") end
    
    local barrier = spells_getFormulas(player, spellT)
    
    setSV(player, SV.barrierSpell, barrier)
    player:sendTextMessage(ORANGE, "barrier can absorb "..barrier.." damage")
    doSendMagicEffect(player:getPosition(), {38,15})
    barrier_registerHighestValue(player, barrier)
end