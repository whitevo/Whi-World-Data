function onUse(player, item, fromPos, itemEx, toPos, isHotkey) -- Do I still need it here now?
    local t = AIDItems[item:getActionId()]
    if not t then return end
    local itemEx = checkForItemEx(itemEx, toPos)
    return executeActionSystem(player, item, t, itemEx, fromPos, toPos)
end

--[[
function Player:onUse(item, fromPos, target, toPos) -- fromObject, toObject are missing (future task)
    local t = AIDItems[item:getActionId()] or IDItems[item:getId()]
	if not t then return self:sendTextMessage(GREEN, "test failed! :c") end
	executeActionSystem(self, item, t, target, fromPos, toPos)--, fromObject, toObject)
end

]]