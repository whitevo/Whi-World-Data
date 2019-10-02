--execute function knightSpellDefs(player, primaryDamage, primaryType) in damageSystem.lua
function onyxdefSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("onyxdef") end
    local resistance = spells_getFormulas(player, spellT)

    doSendMagicEffect(player:getPosition(), {28, 18})
    
    if not supaky(player, resistance) then
        setSV(player, SV.onyxdefSpell + 20000, os.time()+5)
        setSV(player, SV.onyxdefSpell, resistance)
    end
end

