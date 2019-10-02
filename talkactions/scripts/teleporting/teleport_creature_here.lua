function onSay(player, words, param)
    if not player:isGod() then return true end

    if tonumber(param) then
        for x=1, #Game.getPlayers() do
            local target = Game.getPlayers()[x]
            if tostring(target:getName()) == tostring(param) then
                return target:teleportTo(player:getPosition(), true)
            end
        end
        return false
    end
local creature = Creature(param)
	if not creature then return false, player:sendTextMessage(GREEN, "A creature with that name could not be found.") end
local oldPosition = creature:getPosition()
local newPosition = player:getClosestFreePosition()

	if not newPosition then
		player:sendTextMessage(GREEN, "There is no free room near you")
	elseif creature:teleportTo(newPosition) then
		if not creature:isInGhostMode() then
			oldPosition:sendMagicEffect(CONST_ME_POFF)
			newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
    return false
end
