function onThink(creature)
    local thinkScriptT = onThinkScripts[creature:getId()]
    
    if not thinkScriptT then return end
    
    for _, funcStr in pairs(thinkScriptT) do
        local func = _G[funcStr]
        if not func then return error("global function is missing: ["..funcStr.."]") end
        func(creature)
    end
end