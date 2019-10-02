function onStepIn(player, item, toPos, fromPos)
    local itemID = item:getId()
    local t = IDTiles_stepIn[itemID]

    if t then return executeActionSystem(player, item, t, fromPos, fromPos, toPos) end
    print(itemID.." is not registered IN IDTiles_stepIn")
end

function onStepOut(player, item, toPos, fromPos)
    local itemID = item:getId()
    local t = IDTiles_stepOut[itemID]

    if t then return executeActionSystem(player, item, t, fromPos, fromPos, toPos) end
    print(itemID.." is not registered IN IDTiles_stepOut")
end