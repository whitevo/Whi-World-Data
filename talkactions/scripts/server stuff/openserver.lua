function onSay(player, words, param)
    if not player:isGod() then return true end
	Game.setGameState(GAME_STATE_NORMAL)
    return false, player:sendTextMessage(BLUE, "Server is now open.")
end
