local tokenBagID = ITEMID.containers.token_bag
local feature_tokenBag = {
    AIDItems = {
        [AID.other.token_bag] = {funcStr = "tokenBag_onUse"}
    },
    AIDItems_onLook = {
        [AID.other.token_bag] = {funcStr = "tokenBag_onLook"}
    }
}
centralSystem_registerTable(feature_tokenBag)

function tokenBag_onUse(player, item)
    local itemID = tokenBag_getId(item)
    if not itemID then return print(player:getName().." has broken tokenBag") end
    if player:getSlotItem(3) then return reverseTokenBag(player, item, player:getPosition()) end
    return reverseTokenBag(player, item)
end

function tokenBag_tryPickUp(player, item)
    if not item:isBag() then return end
    if not player:hasBagRoom() then return player:sendTextMessage(GREEN, "Not enough room in your bag") end
    if not checkWeight(player, {itemID = tokenBagID}) then
        return player:sendTextMessage(GREEN, "can not put normal containers into other containers. Change bag into token bag by dropping it on the ground and choosing browse field.")
    end
    if item:getItemHoldingCount() > 0 then return player:sendTextMessage(GREEN, item:getName().." must be empty to turn it into token bag") end

    local tokenBag = player:giveItem(tokenBagID, 1, nil, nil, item:getAttribute(TEXT))
    tokenBag:setText("tokenBag", item:getId())
    return item:remove()
end

function tokenBag_onLook(player, item)
    if desc then return desc end
    if item:getId() ~= tokenBagID then return end
    local bagID = item:getText("tokenBag")
    local bag = ItemType(bagID)
    local itemT = item:getStats()
    local slotAmount = itemT and itemT.room or 9

    player:sendTextMessage(GREEN, "This is token bag.\nIf you use this item you will get:\n"..bag:getName().." that has "..slotAmount.." slots and weights "..math.floor(bag:getWeight()/100).." cap.\nToken bag weights 50 cap.")
end

function turnToTokenBag(player, position)
    local items = Tile(position):getItems()

    for i, item in pairs(items) do
        local itemID = item:getId()
        
        if isInArray(allNormalBags, itemID) then
            if item:getItemHoldingCount() > 0 then return false, player:sendTextMessage(GREEN, "this bag must be empty to turn it into token bag") end
            local tokenBag = createItem(tokenBagID, position)
            local itemText = item:getAttribute(TEXT)
            
            tokenBag:setAttribute(TEXT, itemText)
            tokenBag:setText("tokenBag", itemID)
            tokenBag:setActionId(AID.other.token_bag)
            return false, item:remove()
        end
    end
    
    local tokenBag = findItem(tokenBagID, position)
    if tokenBag then reverseTokenBag(player, tokenBag, tokenBag:getPosition()) end
end

function reverseTokenBag(player, item, bagPos)
    local itemID = tokenBag_getId(item)
    if not itemID then return print("broken tokenBag") end
    local bag = tokenBag_createBag(player, itemID, bagPos)
    local itemText = item:getAttribute(TEXT)

    bag:setAttribute(TEXT, itemText)
    return item:remove()
end

function tokenBag_createBag(player, itemID, pos) return pos and createItem(itemID, pos) or player:giveItem(itemID, 1) end
function tokenBag_getId(item) return item:getText("tokenBag") end