local feature_depot = {
    AIDItems = {
        [AID.other.extra_depot_chest] = {funcStr = "depot_extraChest_onUse"},
    },
    IDItems = {
        [2591] = {funcStr = "depot_onUse"},
    }
}

centralSystem_registerTable(feature_depot)

function depot_onUse(player)
    local depot = player:getDepot()
    
    if not depot then return end
    if depot:getItemCountById(ITEMID.other.extra_depot_chest) > 0 then return end
    
    for x=0, 2 do
        local chest = depot:addItem(ITEMID.other.extra_depot_chest, 1)
        chest:setText("requiredGold", 50*(3-x))
        for i=1, 39 do chest:addItem(2110, 1) end
        chest:addItem(ITEMID.other.coin, 1)
        chest:setActionId(AID.other.extra_depot_chest)
    end
end

function depot_extraChest_onUse(player, item)
    local requiredGold = item:getText("requiredGold")
    if not requiredGold or requiredGold < 1 then return end

    local goldAmount = item:getItemCountById(ITEMID.other.coin) - 1
    if goldAmount < 1 then return player:sendTextMessage(ORANGE, "You need to throw in "..requiredGold.." gold coins more to open this chest") end

    if goldAmount >= requiredGold then
        item:remove()

        local newDepot = player:getDepot():addItem(ITEMID.other.extra_depot_chest, 1)
        local goldLeft = goldAmount - requiredGold
        if goldLeft > 0 then newDepot:addItem(ITEMID.other.coin, goldLeft) end
        newDepot:setActionId(AID.other.extra_depot_chest)
        return player:sendTextMessage(ORANGE, "New treasure chest unlocked")
    end

    local gold = item:getItem(0)
    local newReqAmount = requiredGold - goldAmount
    item:setText("requiredGold", newReqAmount)
    gold:remove(goldAmount)
    return player:sendTextMessage(ORANGE, "You need to throw in "..newReqAmount.." gold coins more to open this chest")
end