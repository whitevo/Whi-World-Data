
function Player.getCritChance(player)
    local critChance = 0

    return critChance
end

function Player.getCritDamagePercent(player)
    local critDamPercent = 100

    return critDamPercent
end

function Player.getCritDamage(player)
    local critDamPercent = player:getCritDamagePercent()

end

function damageSystem_monster_healthChange(monster, damage, damType, attacker)
    if damType == COMBAT_HEALING then return damage, damType end
    local originalDamage = damage > 0 and damage or -damage
    local damage = originalDamage
    
	if attacker and attacker:isPlayer() then
        local critChance = attacker:getCritChance()

        if critChance > 0 and critChance >= math.random(100) then 
            damage = damage + attacker:getCritDamage()
        end
        -- attack damage
	end
    
    if damType == PHYSICAL then
        local armor = monster:getArmor()
        if armor > 1 then damage = damage - math.random(math.floor(armor/2), armor) end
    end

    local resistance = monster:getRes(damType)
    damage = damage - monster:getDefence()
    damage = damage - percentage(originalDamage, resistance)
    -- mana leech
    -- hp leech
	return damage, damType
end

function Monster.getDefence(monster)

end

function Monster.getArmor(monster)

end

function Monster.getRes(monster, damType)

end