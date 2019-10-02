--[[ effects guide
    [STR] = {                       key to recognize effect
        pos = POS                   postition where the effect happens
        posT = {POS}                table of positions where effects happen
        me = ENUM or 14             which effect is used
        varibale = BOOL             if true then doesn't do effect
    }
]]

mapEffects = {}

function global_mapEffects(secPassed)
    if secPassed%3 ~= 0 then return end

    for _, t in pairs(mapEffects) do
        local ME = t.me or 14
        
        if not t.variable then
            if t.pos then
                doSendMagicEffect(t.pos, ME)
            elseif t.posT then
                for _, pos in pairs(t.posT) do doSendMagicEffect(pos, ME) end
            end
        end
    end
end

local loopID = 0
function central_register_mapEffects(mapEffectT)
    if not mapEffectT then return end
    loopID = loopID+1 -- temp solution
    for effectName, effecT in pairs(mapEffectT) do mapEffects[loopID.." - "..effectName] = effecT end
    if check_central_register_mapEffects then print("central_register_mapEffects") end
end
print("mapAnimationEffects loaded..")