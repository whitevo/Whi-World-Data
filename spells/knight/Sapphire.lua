--execute function knightSpellDefs(player, primaryDamage, primaryType) in damageSystem.lua
function sapphdefSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("sapphdef") end
    
    local resistance = spells_getFormulas(player, spellT)

    doSendMagicEffect(player:getPosition(), 44)
    if not supaky(player, resistance) then
        setSV(player, SV.sapphdefSpell + 20000, os.time()+5)
        setSV(player, SV.sapphdefSpell, resistance)
    end
end