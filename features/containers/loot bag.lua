if not lootBagConf then
lootBagConf = {
    itemID = 21475,
    itemAID = AID.other.lootbag,
}

local feature_lootBag = {
    AIDItems_onLook = {
        [lootBagConf.itemAID] = {funcSTR = "lootbag_onLook"}
    },
    AIDItems_onMove = {
        [lootBagConf.itemAID] = {funcSTR = "lootbag_onMove"}
    },
    onMove = {
        {funcStr = "lootbag_moveItem"},
    },
}
centralSystem_registerTable(feature_lootBag)
end

function lootbag_onMove(player, item, toPosition) return item:getItemHoldingCount() > 0 and player:sendTextMessage(GREEN, "can't move lootbag with equipment items") end

function lootbag_moveItem(player, item, _, fromPos, toPos, fromObject, toObject)
    if testServer() then return end
    if not toObject or not fromObject then return print("ERROR lootbag_moveItem") end
    local itemWeight = item:getWeight()
        
    if not toObject:isLootbag() then toObject = targetContainer(player, toObject, toPos) end
    
    if toObject:isLootbag() then
        if fromObject:isLootbag() then return player:sendTextMessage(GREEN, "Can't move items from 1 loot bag to another loot bag") end
        if item:isContainer() then return player:sendTextMessage(GREEN, "You can't put containers in loot bag") end
        if item:isProjectile() then return player:sendTextMessage(GREEN, "You can't put projectiles in loot bag") end
        if not item:isEquipment() then return player:sendTextMessage(GREEN, "You can only put equipment items into loot bag") end
        
        local size = lootbag_getSize(player, toObject)
        if toObject:getItemHoldingCount() >= size then return player:sendTextMessage(GREEN, "Your lootbag max size is currently "..size) end
        player:changeWeight(itemWeight)
        item:moveTo(toObject)
        item:setCustomWeight(0)
        return true
    end

    if fromObject:isLootbag() then
        if hasObstacle(toPos, "solid") then return player:sendTextMessage(GREEN, "Can't throw there") end
        local parent = getParent(fromObject)
        if parent and parent:getId() == player:getId() then player:changeWeight(-itemWeight) end
        item:moveTo(toObject)
        item:setCustomWeight(itemWeight)
        return true
    end
end

function lootbag_onLook(player, item)
local itemID = item:getId()
    if itemID ~= lootBagConf.itemID then return end
local weight = math.floor(ItemType(itemID):getWeight()/100)
local size = lootbag_getSize(player, item)
local desc = "Loot Bag\nWeight: "..weight.."\n"

    if size == 1 then desc = desc.."You can put only 1 equipment item inside the loot bag" end
    if size > 1 then desc = desc.."Can hold up to "..size.." equipment items" end
    if getSV(player, SV.extraInfo) == -1 then desc = desc.."\nItems inside lootbag weight 0" end
    return player:sendTextMessage(GREEN, desc)
end

function lootbag_extraSize_fromDesertBorder(player) return getSV(player, SV.lootbagFromWagon) == 1 and 1 or 0 end
function lootbag_extraSize_fromTutorialRoomSecret(player) return getSV(player, SV.lootBagFromTutorialMonument) == 1 and 1 or 0 end

-- get functions
function lootbag_getSize(player, lootbag)
local size = lootbag:getText("size") or 1

    size = size + lootbag_extraSize_fromDesertBorder(player)
    size = size + lootbag_extraSize_fromTutorialRoomSecret(player)
    return size
end

function getLootBagByPos(player, toPos)
    if toPos.x ~= CONTAINER_POSITION then return end
local toBag = player:getContainerById(toPos.y - 64)
    
    if not toBag then return end
    if toBag:getId() == lootBagConf.itemID then return toBag end
    toBag = toBag:getItem(toPos.z)
    if toBag and toBag:getId() == lootBagConf.itemID then return toBag end
end

function Item.isLootbag(item) return lootBagConf.itemID == item:getId() end
function Creature.isLootbag() return false end
function Tile.isLootbag() return false end