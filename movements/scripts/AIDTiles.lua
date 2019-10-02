function onStepIn(player, item, toPos, fromPos)
local itemAID = item:getActionId()
local t = AIDTiles_stepIn[itemAID]
    
    if t then return executeActionSystem(player, item, t, fromPos, fromPos, toPos) end
    print(itemAID.." is not registered IN AIDTiles_stepIn")
end

function onStepOut(player, item, toPos, fromPos)
local itemAID = item:getActionId()
local t = AIDTiles_stepOut[itemAID]

    if t then return executeActionSystem(player, item, t, fromPos, fromPos, toPos) end
    print(itemAID.." is not registered IN AIDTiles_stepOut")
end