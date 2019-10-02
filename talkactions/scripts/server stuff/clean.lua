function onSay(player, words, param)
    if not player:isGod() then return true end
    local itemCount = cleanMap()
	if itemCount > 0 then player:sendTextMessage(RED, "Cleaned "..plural("item", itemCount).." from the map.") end
end