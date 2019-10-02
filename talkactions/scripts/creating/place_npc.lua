function onSay(player, words, param)
    if not player:isGod() then return end
local position = player:getPosition()
local npc = createNpc({name = param, npcPos = position})

	if npc then
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendTextMessage(GREEN, "There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
