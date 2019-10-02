function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, broadcast(param)
end
