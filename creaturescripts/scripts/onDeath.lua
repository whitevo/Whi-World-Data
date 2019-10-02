function onDeath(creature, corpse)
    local deathScriptT = onDeathScripts[creature:getId()]
    if not deathScriptT then return end
    
    for _, funcStr in pairs(deathScriptT) do
        local func = _G[funcStr]
        if not func then return error("global function is missing: ["..funcStr.."]") end
        func(creature, corpse)
    end
end