function trapSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end

    placeHunterTrap(player, player:getPosition())
    traptrixCoat(player)
end

function placeHunterTrap(player, pos)
    if hasObstacle(pos, "solid") then return end
    createItem(2579, pos, 1, AID.other.hunterTrap, nil, player:getId())
    addEvent(removeItemFromPos, 25000, 2579, pos)
end

function hunterTrap(target, item)
    local player = Player(tonumber(item:getAttribute(TEXT)))
    local itemPos = item:getPosition()
    
    item:remove()
    if not player then return itemPos:sendMagicEffect(3) end
    if pickUpTrap(player, target) then return end

    local spellT = spells_getSpellT("trap")
    local damage, slow, cooldown = spells_getFormulas(player, spellT)
    local playerID = player:getId()
    local targetID = target:getId()
    local origin = playerID == targetID and O_environment or O_player_proc
    local damType = getEleTypeEnum(spellT.spellType)

    if playerID == targetID then playerID = 0 end
    traptrixQuiver(player)
    dealDamage(playerID, targetID, damType, damage, 1, origin)
    if slow > 0 then bindCondition(targetID, "hunterTrap", 5000, {speed = -slow}) end
end

function pickUpTrap(player, target)
    if target ~= player or getSV(player, SV.traptrixCoat) == 1 then return end
    setSV(player, SV.trap + 20000, 0)
    return player:say("*clunk*", ORANGE)
end

function trapSpellCooldown(player, spellName, cooldown)
    if spellName ~= "trap" then return 0 end
    local spellT = spells_getSpellT("trap")
    local damage, slow, cd = spells_getFormulas(player, spellT)
    
    return cd < 1 and 0 or -cd
end