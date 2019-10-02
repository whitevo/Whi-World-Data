function armorUpSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("armorup") end

    local armor, duration = spells_getFormulas(player, spellT)
    
    player:sendTextMessage(ORANGE, "Armorup gives "..math.max(armor,0).." armor")
    if armor < 1 then return end

    playerID = player:getId()
    doSendMagicEffect(player:getPosition(), 40)
    player:setSV(SV.armorUpSpell, armor)
    stopAddEvent(playerID, "armorup")
    registerAddEvent(playerID, "armorup", duration*1000, {armorup_down, playerID})
end

function armorup_noobProtection(player) return player:getLevel() < 3 and 50 or 0 end
    
function armorup_down(playerID)
    local player = Player(playerID)
    if not player then return end

    player:sendTextMessage(ORANGE,"armor down")
    removeSV(player, SV.armorUpSpell)
    player:say("armor down", ORANGE)
    bindCondition(player, "armorUp", 2500, {speed = 100})
    stoneShield_breakDown(player)
end