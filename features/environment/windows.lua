windows = { -- [closed window] = open window
    [6444] = 6446, [6445] = 6447, 
}

function window_onUse(player, item)
   if not item then return end 
    local itemID = item:getId()
    local itemPos = item:getPosition()
        
    if Tile(itemPos):getBottomCreature() then return player:sendTextMessage(GREEN, "There is creature in the way") end
    
    for closedWindowID, openWindowID in pairs(windows) do
        if closedWindowID == itemID then return item:transform(openWindowID) end
        if openWindowID == itemID then return item:transform(closedWindowID) end
    end
end

function window_onLook(player, item, getState)
    local itemID = item:getId()
    local closedDoor = windows[itemID]

    if closedDoor then return getState and "closed window" or player:sendTextMessage(GREEN, "You see a closed window") end
    if matchTableValue(windows, itemID) then return getState and "open window" or player:sendTextMessage(GREEN, "You see an open window") end
    
    local itemName = item:getName()
    return getState and itemName or player:sendTextMessage(GREEN, "You see "..itemName)
end