--execute function knightSpellDefs(player, primaryDamage, primaryType) in damageSystem.lua

function rubydefSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("rubydef") end
    
    local resistance = spells_getFormulas(player, spellT)

    doSendMagicEffect(player:getPosition(), 37)
    if not supaky(player, resistance) then
        setSV(player, SV.rubyDefSpell + 20000, os.time()+5)
        setSV(player, SV.rubyDefSpell, resistance)
    end
end