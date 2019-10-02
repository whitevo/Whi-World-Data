function onSay(player, words, param)
    if not player:isGod() then return true end
local position = player:getPosition()
local isGhost = not player:isInGhostMode()
	
	player:setGhostMode(isGhost)
	if isGhost then
		player:sendTextMessage(GREEN, "You are now invisible.")
		position:sendMagicEffect(CONST_ME_YALAHARIGHOST)
	else
		player:sendTextMessage(GREEN, "You are visible again.")
		position.x = position.x + 1
		position:sendMagicEffect(CONST_ME_SMOKE)
	end
    return false
end
