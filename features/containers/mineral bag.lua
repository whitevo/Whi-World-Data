if not mineralBagConf then
mineralBagConf = {
    itemID = 11244,
    defaultSize = 20,
}

local feature_mineralBag = {
    IDItems_onMove = {
        [mineralBagConf.itemID] = {funcStr = "mineralBag_onMove"},
    },
    onMove = {
        {funcStr = "mineralBag_moveItem"},
    },
}

centralSystem_registerTable(feature_mineralBag)
end

function mineralBag_onMove(player, item)
    if item:getItemHoldingCount() > 0 then return player:sendTextMessage(GREEN, "can't move mineral bag with minerals inside it") end
end

function mineralBag_moveItem(player, item, _, fromPos, toPos, fromObject, toObject)
    if testServer() then return end
    if not toObject or not fromObject then return print("ERROR mineralBag_moveItem") end
    local itemID = item:getId()
    local itemCount = item:getCount()
        
    if not toObject:isMineralBag() then toObject = targetContainer(player, toObject, toPos) end
    
    if toObject:isMineralBag() then
        if fromObject:isMineralBag() then return player:sendTextMessage(GREEN, "Can't move minerals from mineral bag to another mineral bag") end
        if not item:isMineral() and itemID ~= ITEMID.materials.brick then return player:sendTextMessage(GREEN, "You can only put minerals and building bricks into mineral bag") end
        local size = mineralBag_getSize(player, toObject)
        local bagCount = toObject:getItemCount()
        local totalCount = bagCount + itemCount
        local moveAbleCount = itemCount
        
        if totalCount > size then
            moveAbleCount = size - bagCount
            player:sendTextMessage(GREEN, "Your mineral bag can hold maximum "..size.." minerals")
            if moveAbleCount < 1 then return true end
        end
        
        local addedWeight = moveAbleCount * item:getBaseWeight()
        item:remove(moveAbleCount)
        player:changeWeight(addedWeight)
        local newOres = toObject:addItem(itemID, moveAbleCount)

		if not newOres then
            player:sendTextMessage(BLUE, "Sorry something bugged.. report has been sent")
            createItem(itemID, player:getPosition(), moveAbleCount)
			print("ERROR - toObject:addItem(itemID, moveAbleCount)")
			Vprint(toObject:getName(), "to object name")
			Vprint(toObject:getEmptySlots(), "object getEmptySlots")
			Vprint(moveAbleCount, "moveAbleCount")
			Vprint(itemID, "itemID")
		else
			newOres:setCustomWeight(0)
		end
        return true
    end

    if fromObject:isMineralBag() then
        if hasObstacle(toPos, "solid") then return player:sendTextMessage(GREEN, "Can't throw there") end
        local parent = getParent(fromObject)
        if parent and parent:getId() == player:getId() then player:changeWeight(-itemWeight) end
        item:remove()
        if Tile(toPos) then return createItem(itemID, toPos, itemCount) end
		if not toObject:addItem(itemID, itemCount) then createItem(itemID, player:getPosition(), itemCount) end
        return true
    end
end

function mineralBag_getSize(player, bag) return bag:getText("size") or mineralBagConf.defaultSize end
function Item.isMineralBag(item) return mineralBagConf.itemID == item:getId() end
function Tile.isMineralBag() return false end
function Creature.isMineralBag() return false end