function onSay(player, words, param)
    if not player:isGod() then return true end
    
	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendTextMessage(BLUE, "Server is now closed.")
	end
    return false
end
