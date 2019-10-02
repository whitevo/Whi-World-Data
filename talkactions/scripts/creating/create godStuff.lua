function onSay(player, words, param)
    if not player:isGod() then return end
    local bag = player:getBag()
    if bag then bag:remove() end
    local newBag = player:addItem(1988, 1)
    
    newBag:addItem(12410, 1):setActionId(AID.other.ghostOrb)
    newBag:addItem(2294, 1):setActionId(AID.other.tpRune)
    newBag:addItem(2277, 1):setActionId(AID.other.aoeRune)
    newBag:addItem(2278, 1):setActionId(AID.other.luaRune)
    newBag:addItem(2311, 1):setActionId(AID.other.copyRune)
    newBag:addItem(2160, 1) -- crystal coin
end