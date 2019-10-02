function shiverSpell(playerID, spellT)
local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("shiver") end
local damage = spells_getFormulas(player, spellT)
local range = spells_getRange(player, spellT)
local damType = getEleTypeEnum(spellT.spellType)
local playerPos = player:getPosition()
local target = player:getTarget()
local effect = getEffectByType(damType)
local frontPos = player:frontPos()

    local function maybeSpellDam(newPos, damage)
        atsuiKori(player, nil, newPos, damage, damType)
        dealDamagePos(player, newPos, damType, damage, effect, O_player_spells, effect)
        iceSpecialFunctions(player, newPos)
    end
    
    if not target then return maybeSpellDam(frontPos, damage) end
local targetPos = target:getPosition()
    
    if getDistanceBetween(playerPos, targetPos) > range then return maybeSpellDam(frontPos, damage) end
    
    if not namiBoots_equipped(player) then
        atsuiKori(player, target, nil, damage, damType)
        potions_spellCaster_heal(player)
        dealDamage(cid, target, damType, damage, effect, O_player_spells)
    else
        local posT = getPath(playerPos, targetPos)
        if not posT then return maybeSpellDam(frontPos, damage) end
        for i, pos in ipairs(posT) do
            if not i ~= 1 then maybeSpellDam(pos, damage) end
        end
    end
    playerPos:sendDistanceEffect(targetPos, 29)
end

function iceSpecialFunctions(player, pos)
    putOutCampfire(player, findItem(1423, pos))
    cyclopsStashQuestShroom(pos, 1)
end