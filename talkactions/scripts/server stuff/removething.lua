function onSay(player, words, param)
    if not player:isGod() then return true end
local cid = player:getId()
local position = player:frontPos()
local tile = Tile(position)
	if not tile then return false, player:sendTextMessage(GREEN, "Object not found.") end
local thing = tile:getTopVisibleThing(player)
	if not thing then return false, player:sendTextMessage(GREEN, "Thing not found.") end

	if thing:isCreature() then
		thing:remove()
	elseif thing:isItem() then
        local amount = tonumber(param) or 1
        
		for x=1, amount do
            local thing = tile:getTopVisibleThing(player)
            if not thing then return false, player:sendTextMessage(GREEN, "Thing not found.") end
            if thing:getId() == tile:getGround():getId() then return false, player:sendTextMessage(GREEN, "You may not remove a ground tile.") end
            thing:remove()
        end
	end
    return false, doSendMagicEffect(position, 15)
end
