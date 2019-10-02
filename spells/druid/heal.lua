function healSpell(playerID, spellT)
local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("heal") end
local healAmount = spells_getFormulas(player, spellT)
    
    if healAmount < 1 then return player:sendTextMessage(GREEN, "The heal amount is less than 1") end
    spells_healing(player, player, healAmount, {13,2})
end