function onSay(player, words, param) return showOnline(player) end

function showOnline(player)
local players = Game.getPlayers()
local playerCount = Game.getPlayerCount()
local i = 0
local msg = ""

	player:sendTextMessage(BLUE, playerCount .. " players online.")
    
	for k, tmpPlayer in pairs(players) do
		if player:isGod() or not tmpPlayer:isInGhostMode() then
			if i > 0 then
				msg = msg .. ", "
			end
			msg = msg .. tmpPlayer:getName() .. " [" .. tmpPlayer:getLevel() .. "]"
			i = i + 1
		end

		if i == 10 then
			if k == playerCount then
				msg = msg .. "."
			else
				msg = msg .. ","
			end
			player:sendTextMessage(BLUE, msg)
			msg = ""
			i = 0
		end
	end

	if i > 0 then
		msg = msg .. "."
		player:sendTextMessage(BLUE, msg)
	end
end