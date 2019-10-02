--execute function knightSpellDefs(player, primaryDamage, primaryType) in damageSystem.lua
function opaldefSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("opaldef") end
    
    local resistance = spells_getFormulas(player, spellT)

    doSendMagicEffect(player:getPosition(), 27)
    if not supaky(player, resistance) then
        setSV(player, SV.opalDefSpell + 20000, os.time()+5)
        setSV(player, SV.opalDefSpell, resistance)
    end
end