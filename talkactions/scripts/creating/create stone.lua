function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createStones)
end