function onSay(player, words, param)
    if not player:isGod() then return true end
	local playerPos = player:getPosition()
	local creature = createMonster(param, playerPos)

    if creature then
		creature:setMaster(player)
		playerPos:sendMagicEffect(14)
	else
		player:sendTextMessage(GREEN, "this monster name doesnt exist ["..param.."]")
		playerPos:sendMagicEffect(3)
	end
end
