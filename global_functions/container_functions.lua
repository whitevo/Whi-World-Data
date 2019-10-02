function Container.isContainer() return true end
function isContainerPos(pos) return pos.x == CONTAINER_POSITION end

function Container.getItemCount(bag, perItem)
    local items = bag:getItems()
    local totalCount = 0
    
    if perItem then return tableCount(items) end
    for _, item in ipairs(items) do totalCount = totalCount + item:getCount() end
    return totalCount
end

function getSocketAmount(itemID, amount)
    if stackCheck(itemID) then return math.ceil(amount / 100) end
    return amount
end

function Container.clearContainer(self)
    local mod = 0
    
    for x=0, self:getItemHoldingCount() do
        local item = self:getItem(x-mod)
    
        if item then
            mod = mod + 1
            item:remove()
        end
    end
end

function Container.getItems(container, itemID, itemAID)
    local items = {}

    for i = 0,  container:getSize() - 1 do
        local item = container:getItem(i)
        if not item then break end

        local itemID_passed = not tonumber(itemID) or item:getId() == itemID
        local itemAID_passed = not tonumber(itemAID) or item:getActionId() == itemAID
        if itemID_passed and itemAID_passed then table.insert(items, item) end
    end
    return items
end

function notEnoughCap(player, weight, pos)
    if not ownerIsPlayer(player, pos) then return end
    return player:getFreeCapacity() < weight and player:sendTextMessage(GREEN, "Not enough cap")
end

function targetContainer(player, toObject, toPos)
    if not toObject:isContainer() then return toObject end
    local targetItem = toObject:getItem(toPos.z)

    if not targetItem then return toObject end
    return targetItem:isContainer() and targetItem or targetItem:isSpecialBag() and targetItem or toObject
end

function getTopContainer(pos)
    local tile = Tile(pos)
    if not tile then return end

    local topThing = tile:getTopVisibleThing()
    if not topThing then return end
    if topThing:isContainer() then return topThing end

    local items = reverseTable((tile:getItems() or {}))
    for _, item in ipairs(items) do
        if item:isContainer() then return item end
    end
end