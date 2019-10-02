function onHealthChange(creature, attacker, damage, damType, secD, secT, origin)
    local onHealthChangeScriptT = onHealthChangeScripts[creature:getId()]
    if not onHealthChangeScriptT then return damage, damType end

    for i, funcStr in ipairs(onHealthChangeScriptT) do
        local func = _G[funcStr]
        if not func then return error("global function is missing: ["..funcStr.."]") end
        local tempDam, tempType, tempOrigin = func(creature, attacker, damage, damType, origin)
        if tempDam then damage = tempDam end
        if tempType then damType = tempType end
        if tempOrigin then origin = tempOrigin end
    end
    return damage, damType
end

