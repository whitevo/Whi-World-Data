function onSay(player, words, param)
    if not player:isGod() then return true end
    return player:createMW(MW.createSpell)
end
