local feature_autoEquip = {
    IDItems = {
        [2456] = {funcStr = "autoEquip_onUse"},
        [7367] = {funcStr = "autoEquip_onUse"},
        [2389] = {funcStr = "autoEquip_onUse"},
    }
}
centralSystem_registerTable(feature_autoEquip)

function autoEquip_onUse(player, item)
    local bag = player:getBag()
    if not bag then player:sendTextMessage(GREEN, "You need bag to auto-equip weapons") end
    if bag:getEmptySlots(false) == 0 then player:sendTextMessage(GREEN, "You need at least 1 empty slot in your bag to auto-equip weapons") end

    local weapon = player:getSlotItem(SLOT_LEFT)
    if not weapon then return end

    local weaponID = weapon:getId()
    local itemID = item:getId()
    if weaponID == itemID then return end

    local weight = ItemType(itemID):getWeight()
    local freeCap = player:getFreeCapacity()
    local weaponWeight = ItemType(weaponID):getWeight()
    if weight > freeCap + weaponWeight then return player:sendTextMessage(GREEN, "weapon too heavy!") end

    local count = item:getCount()
    local weaponCount = weapon:getCount()

    if weight*count > freeCap and weaponWeight > 0 then
        weapon:moveTo(player:getPosition())
        freeCap = player:getFreeCapacity()
        if weight*count > freeCap then count = math.floor(freeCap/weight) end
    else
        weapon:moveTo(bag)
    end

    item:remove()
    player:giveItem(itemID, count)
end