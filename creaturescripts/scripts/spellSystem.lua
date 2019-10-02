function onHealthChange(creature, attacker, damage, damType, secD, secT, origin)
    return spellSystem_onHealthChange(creature, damage, damType, attacker)
end

function onManaChange(creature, attacker, damage, damType, secD, secT, origin)
    return spellSystem_onManaChange(creature, damage, damType, attacker)
end

function onLogin(player) return true, spellSystem_onLogin(player) end
	