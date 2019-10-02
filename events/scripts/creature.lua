function Creature:onChangeOutfit(outfit)
    return true
end

function Creature:onAreaCombat(tile, isAggressive)
	return true
end

function Creature:onTargetCombat(target)
    if demonSkeletonTower(self, target) then return -1 end
    if self and royale_isInGame(self) then return true end
    if not PVP_allowed(self, target) then return -1 end
	return true
end

