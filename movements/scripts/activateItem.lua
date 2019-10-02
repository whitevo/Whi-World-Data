local ignoreItems = {2050, 2051, 2282, 7434, 2272}

function onEquip(player, item, slot)
    local playerID = player:getId()
    if not antiSpam(playerID, slot) then return true end
    local itemID = item:getId()
    local itemT = item:getStats()

    if not itemT and not isInArray(ignoreItems, itemID) then print("ERROR - unknown item equipped: "..item:getName()) end
    if not itemT and not item:isContainer() then return true, print("item onEquip ERROR: "..item:getName()) end
    if not canEquip(player, item) then return end
    
    local setT = item:getSetItemT()
    local function equipDelay(playerID) return Player(playerID) and items_equipItem(player, itemT, setT) end
    addEvent(equipDelay, 500, playerID)
    items_setDSV(player, item, itemT.setDSV)
    equipBag(player, item)
    speedStone(player)
    return true
end

function onDeEquip(player, item, slot)
    local playerID = player:getId()
    if not antiSpam(playerID, slot+100) then return true end
    if slot == SLOT_RIGHT and zvoidTurban(playerID, item, slot) then return end
    local itemT = item:getStats()
    
    if not itemT and not item:isContainer() then return true, print("item onDeEquip ERROR: "..item:getName()) end
    local setT = item:getSetItemT()
    items_deEquipItem(player, itemT, setT)
    items_removeDSV(player, item, itemT.setDSV)
    unEquipBag(player, item)
    speedStone(player)
    return true
end

function canEquip(player, item)
    if item:getId() == 2456 and getSV(player, SV.chokkan) == 1 then return true end
    if not checkBowPassed(player, item) then return end
    local itemT = item:getStats()
    if not itemT then return true end
    local blockSlots = itemT.blockSlots

    if not blockSlots then return true end
    if type(blockSlots) ~= "table" then blockSlots = {blockSlots} end
    
    for _, slotStr in ipairs(blockSlots) do
        local slot = getSlotEnum(slotStr)
        local slotItem = player:getSlotItem(slot)
        if slotItem and getSlotStr(slotItem) == slotStr then return false, player:sendTextMessage(GREEN, itemT.blockMsg) end
    end
    return true
end

function checkBowPassed(player, item)
    local weapon = player:getSlotItem(SLOT_LEFT)
    if not weapon then return true end
    if weapon:getId() ~= 2456 then return true end
    if getSlotStr(item) == "shield" then return false, player:sendTextMessage(GREEN, "Can not equip shield while bow in hand") end
    return true
end

function unEquipBag(player, item)
    if not item:isContainer() then return end
    removeCondition(player, "bagUpgrade")
    removeSV(player, SV.furBagBonus)
end

function equipBag(player, item)
    if not item:isContainer() then return end
    local itemID = item:getId()
    local skill = item:getText("skillStoneSkill")

    if itemID == 7343 or itemID == 7342 then setSV(player, SV.furBagBonus, 1) end -- fur bag, fur backpack
    if not skill then return end
    local amount = item:getText("skillStoneValue") or 0

    bindCondition(player, "bagUpgrade", -1, {[skill] = amount})
end