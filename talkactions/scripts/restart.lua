function onSay(player, words, param)
if not player:isGod() then return true end
    return false, global_startUp()
end