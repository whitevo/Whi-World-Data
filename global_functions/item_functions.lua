local function itemTextMOD(object, item, text)
    if text:match("randomStats") then
        local itemStatT = items_getStats(item)
        local newStatsStr = ""
        
        if itemStatT then
            for stat, value in pairs(itemStatT) do
                if itemsConf_itemStatT[stat] and type(value) == "number" then
                    local newValue = items_getDefaultRandomStatAmount(stat)
                    if newValue ~= 0 then newStatsStr = newStatsStr.." "..stat.."("..newValue..")" end
                end
            end
        end
        
        text = text:gsub("randomStats", newStatsStr)
    end
    
    if object and object:isPlayer() then
        if text:match("playerName") then text = text:gsub("playerName", object:getName()) end
        if text:match("accountID") then text = text:gsub("accountID", object:getAccountId()) end
    end
    return text
end

local function addAttributesToItem(object, item, itemAID, itemText)
    if not item then return end
    if itemAID then item:setActionId(itemAID) end
    if itemText then
        if object then itemText = itemTextMOD(object, item, itemText) end
        item:setAttribute(TEXT, itemText)
    end
end

function makeItem(object, itemID, pos, count, itemAID, fluidType, itemText)
    count = count or 1
    if not pos then
        if not object then return error("No object and pos for itemID:"..itemID) end
        
        if fluidType and ItemType(itemID):isFluidContainer() then
            local item = object:addItem(itemID, fluidType)
            addAttributesToItem(object, item, itemAID, itemText)
            return item
        end
        local item = object:addItem(itemID, count)
        addAttributesToItem(object, item, itemAID, itemText)
        return item
    end

    local item = Game.createItem(itemID, count, pos)
    addAttributesToItem(object, item, itemAID, itemText)
    return item
end

function createItem(itemID, pos, count, itemAID, fluidType, itemText, object)
    if type(itemID) == "table" then return createItem(itemID.itemID, itemID.itemPos, itemID.count, itemID.itemAID, itemID.fluidType, itemID.itemText, object) end
    if not pos then return makeItem(object, itemID, pos, count, itemAID, fluidType, itemText) end
    local count = count or 1
    local item

    if not fluidType or not ItemType(itemID):isFluidContainer() then
        item = makeItem(object, itemID, pos, count, itemAID, nil, itemText)
        if not item then return end

        if count > 1 and not item:isStackable() then
            item = {item}
            for x=2, count do item[x] = makeItem(object, itemID, pos, 1, itemAID, nil, itemText) end
        end
    else
        item = {}
        for x=1, count do item[x] = makeItem(object, itemID, pos, fluidType, itemAID, nil, itemText) end
    end
    return item
end

function doTransform(itemID, pos, toItemID, toAID)
    local tile = Tile(pos)
    if not tile then return end
    local item = tile:getItemById(itemID)

    if not item then
        local ground = tile:getGround()
        if not ground then return end
        if ground:getId() == itemID then item = ground end
    end
    
    if not item then return end
    local itemAID = item:getActionId()
        
    item:transform(toItemID)
    
    if toAID then
        if type(toAID) == "number" then
            if toAID < 100 then
                item:setActionId(nil)
            else
                item:setActionId(toAID)
            end
        else
            item:setActionId(itemAID)
        end
    elseif itemAID >= 100 then
        item:setActionId(nil)
    end
    return item
end

function getItemType(item)
    if not item:isItem() then return end
    if item:isArmor() then return "armor" end
    if item:isShield() then return "shield" end
    if item:isWeapon() or item:isBow() or item:isWand() then return "weapon" end
end

function itemTextToT(str)
local tempT = str:split(" ")
local textT = {}
    
    for _, keyValue in ipairs(tempT) do
        local value = keyValue:match("%b()")
        
        if value then 
            local key = keyValue:gsub("%("..value.."%)", "")
            
            value = removeBrackets(value)
            if value:match("%,") then
                local t = {}
                local split = value:split(",")
                
                for _, v in pairs(split) do
                    local vStr = tonumber(v) or v
                    table.insert(t, vStr)
                end
                value = t
            else
                value = tonumber(value) or value
            end
            
            textT[key] = value
        else
            print("ERROR - itemTextToT string = ["..str.."], keyValue = ["..keyValue.."]")
        end
    end
    return textT
end

function Item.setText(item, key, newText)
local fullText = item:getAttribute(TEXT)
local temp = fullText:match(key.."%(.-%)")
local finalText = ""
local remove = false

    if not newText then
        remove = true
        newText = ""
    end
    
    if type(newText) == "table" then
        local text = ""
        
        for _, value in pairs(newText) do
            text = text..value..","
        end
        newText = text
    end
    
    if temp then
        if remove then
            finalText = fullText:gsub(key.."%b()", newText)
        else
            newText = temp:gsub("%b()", "("..newText..")")
            finalText = fullText:gsub(key.."%b()", newText)
        end
    elseif remove then
        finalText = fullText
    else
        finalText = fullText.." "..key.."("..newText..")"
    end
    return item:setAttribute(TEXT, finalText)
end


function getFromText(string, text)
    local temp = text:match(string.."%(.-%)") 
    if not temp then return end
    
    temp = temp:match("%b()")
    temp = removeBrackets(temp)
    if tonumber(temp) then return tonumber(temp) end
    
    if temp:match("%,") then
        local t = {}
        local split = temp:split(",")
        
        for _, vSTR in pairs(split) do
            local n = tonumber(vSTR)
            
            if n then
                table.insert(t, n)
            else
                table.insert(t, vSTR)
            end
        end
        return t
    end
    return temp and temp ~= "" and temp
end

function Item.getText(item, key) return getFromText(key, item:getAttribute(TEXT)) end

local levers = {[1945]=1946, [9825]=9826, [9827]=9828}
function changeLever(item) -- or position
    if type(item) == "table" then
        local position = item
        
        for leverID1, leverID2 in pairs(levers) do
            item = Tile(position):getItemById(leverID1)
            if item then break end
            item = Tile(position):getItemById(leverID2)
            if item then break end
        end
    end
    
    if not item then return end
local itemID = item:getId()

    for leverID1, leverID2 in pairs(levers) do
        if leverID1 == itemID then
            return item:transform(leverID2)
        elseif leverID2 == itemID then
            return item:transform(leverID1)
        end
    end
end

function removeItemFromPos(itemID, position, count, itemAID)
    local tile = Tile(position)
    if not tile then return end
    local items = findItems(itemID, position, itemAID)

    for _, item in ipairs(items) do
        if not count then return item:remove(1) end

        if tostring(count) == "all" then
            item:remove()
        else
            local itemCount = item:getCount()
            if itemCount >= count then return item:remove(count) end
            count = count - itemCount
            item:remove()
        end
    end
end

function Item.getBaseWeight(item) return item:getWeight() / item:getCount() end

function getSlotStr(object) -- userdata, INT
local itemID = object

    if type(object) == "userdata" then itemID = object:getId() end
    
    if itemID < 20 then
        if itemID == SLOT_FEET then return "boots" end
        if itemID == SLOT_LEGS then return "legs" end
        if itemID == SLOT_ARMOR then return "body" end
        if itemID == SLOT_HEAD then return "head" end
        if itemID == SLOT_RIGHT then return "shield" end
        if itemID == SLOT_LEFT then return "weapon" end
        if itemID == SLOT_BACKPACK then return "bag" end
        if itemID == SLOT_AMMO then return "arrows" end
    else
        for slot, t in pairs(itemTable) do
            if t[itemID] then return slot, t[itemID] end
        end
    end
    return "UNKNOWN_SLOT"
end

function getSlotEnum(object)
    if type(object) ~= "string" then object = getSlotStr(object) end
    if object == "boots" then return SLOT_FEET end
    if object == "legs" then return SLOT_LEGS end
    if object == "body" then return SLOT_ARMOR end
    if object == "head" then return SLOT_HEAD end
    if object == "shield" then return SLOT_RIGHT end
    if object == "quiver" then return SLOT_RIGHT end
    if object == "weapon" then return SLOT_LEFT end
    if object == "bag" then return SLOT_BACKPACK end
    if object == "arrows" then return SLOT_AMMO end
    print("ERROR - unknown slot type: ["..object.."]")
end

local sendError = false
function getParent(item)
    if not item then return end
    
    addEvent(function() return sendError and Uprint(sendError) end, 1000)
    sendError = item
    local parent = item:getParent()
    sendError = false

    if not parent then return end
    if parent:isTile() then return end
    return parent:isPlayer() and parent or getParent(parent)
end

function Item.getTilePos(item)
    local itemPos = item:getPosition()
    if Tile(itemPos) then return itemPos end

    local parent = item:getParent()
    if not parent then return print("ERROR - Item.getTilePos() - itemID["..item:getId().."] missing parent") end

    local parentPos = parent:getPosition()
    if Tile(parentPos) then return parentPos end
    print("ERROR - Item.getTilePos() - itemID["..item:getId().."] parentID["..parent:getId()"]")
end

function stackCheck(itemID)
    if itemID == 777 then return end
    local item = Game.createItem(itemID, 2, {x = 627, y = 642, z = 8})
    local realcount = item:getCount()

    item:remove()
    return realcount > 1
end

function Item.isTile() return false end
function Item.isNpc() return false end
function Item.isPlayer() return false end
function Item.isCreature() return false end
function Item.isMonster() return false end
function Item.isContainer(item, ignoreSpecialBags) return ItemType(item:getId()):isContainer() or item:isSpecialBag() and not ignoreSpecialBags end
function Item.isSpecialBag(item) return itemIsSpecialBag(item:getId()) end
function itemIsSpecialBag(itemID)
    local specialBags = {lootBagConf.itemID, ITEMID.containers.gem_pouch, gemBagConf.itemID, herbBagConf.itemID, mineralBagConf.itemID, seedBagConf.itemID}
    return matchTableValue(specialBags, itemID)
end

function Item.isBag(item)
    local itemID = item:getId()

    for bagID, itemT in pairs(itemTable.bag) do
        if itemID == bagID then return true end
    end
end

function Item.isFluidContainer(item) return ItemType(item:getId()):isFluidContainer() end
function Item.isStackable(item) return stackCheck(item:getId()) end
function Item.isWeapon(item) local t = items_getStats(item) return t and t.range and t.range == 1 end
function Item.isRangeWeapon(item) local t = items_getStats(item) return t and t.range and t.range > 1 and not t.isWand end
function Item.isSpear(item) return item:isRangeWeapon() and item:isProjectile() end
function Item.isProjectile(item) return items_getStats(item) and items_getStats(item).breakchance end
function isProjectile(itemID)
    if type(itemID) == "userdata" then
        local item = itemID
        if not item:isItem() then return end
        itemID = item:getId()
    end
    return items_getStats(itemID) and items_getStats(itemID).breakchance
end
function Item.isShield(item) return item:getType():getWeaponType()  == 4 end
function Item.isBow(item) return item:getType():getWeaponType() == 5 and not item:getType():isStackable() end
function Item.isWand(item) local t = items_getStats(item) return t and t.isWand end
function Item.isArmor(item) return item:isBoots() or item:isLegs() or item:isBody() or item:isHead() end
function Item.isBoots(item) return getSlotStr(item) == "boots" end
function Item.isLegs(item) return getSlotStr(item) == "legs" end
function Item.isBody(item) return getSlotStr(item) == "body" end
function Item.isHead(item) return getSlotStr(item) == "head" end
allKeys = {2086, 2088, 2089, 2091, 2092}
function Item.isKey(item) return isInArray(allKeys, item:getId()) end

function ItemType.isStackable(item) return stackCheck(item:getId()) end

function getSlotAmount(itemID)
    if not ItemType(itemID):isContainer() then return end
    local item = Game.createItem(itemID, 1, {x = 627, y = 642, z = 8})
    local size = item:getSlotAmount()
    item:remove()
    return size > 0 and size
end

function Item.getSlotAmount(item) return item:isContainer() and item:getEmptySlots() + item:getItemHoldingCount() end

function isWeaponRack(ID) return ID == 6110 or ID == 6109 end
function isArmorRack(ID) return ID == 6112 or ID == 6111 end

function isWardrobe(ID)
    for itemID = 1710, 1717 do
        if itemID == ID then return true end
    end
    for itemID = 1724, 1727 do
        if itemID == ID then return true end
    end
    for itemID = 3822, 3825 do
        if itemID == ID then return true end
    end
    for itemID = 3832, 3835 do
        if itemID == ID then return true end
    end
end

function isCoffin(ID)
    for itemID = 1410, 1419 do
        if itemID == ID then return true end
    end
end

function isShelf(ID)
    for itemID = 1718, 1723 do
        if itemID == ID then return true end
    end
    for itemID = 3826, 3831 do
        if itemID == ID then return true end
    end
end

function Item.getType(item)	return ItemType(item:getId()) end

function Item.setActionId(item, AID)
    if AID and AID >= 100 then item:setAttribute(ACTIONID, AID) end
    if not AID or AID < 100 then
        if item:getActionId() >= 100 then item:setAttribute(ACTIONID, 0) end
    end
    return item
end

tracker = {}
function getItemFromTracker(itemID, AID)
local itemT = tracker[itemID]

    if not itemT then return end
    local function correctItem(item, AID)
        if not item then return end
        if not AID then return item end
        if item:getActionId() == AID then return item end
    end
local currentPos = itemT.currentPos
local tile = Tile(currentPos)
local item = tile:getItemById(itemID)
    
    if correctItem(item, AID) then return item end
    tile = Tile(itemT.lastPos)
    item = tile:getItemById(itemID)
    return correctItem(item, AID)
end

function tracking(item, pos)
local itemT = tracker[item:getId()]

    if not itemT then return end
    itemT.lastPos = item:getPosition()
    itemT.currentPos = pos
end

function checkForItemEx(itemEx, toPos)
    if not itemEx or type(itemEx) ~= "userdata" then
        local tile = Tile(toPos)
        if not tile then return end
        itemEx = tile:getTopVisibleThing()
    end
    return itemEx
end

local firePlaces = {1423, 1492}
local function findFirePlace(pos)
    for _, firePlaceID in pairs(firePlaces) do
        if findItem(firePlaceID, pos) then return true end
    end
end

local function putTorchOnFire(item, firePos)
    if not item:getId() == 2050 then return end
    createItem(2051, firePos)
    doSendMagicEffect(firePos, 37)
    return item:remove()
end

function burnItemOnFire(player, item, firePos, count)
    local tile = Tile(firePos)
    if not tile then return end
    if not findFirePlace(firePos) then return end
    if putTorchOnFire(item, firePos) then return true end
    local burnableItems = {2467, 7457, 7458, 7463, 7464, 11235, 11224, 11200, ITEMID.containers.gem_pouch, 7343, 7342, 9076, 5896, 5897, 13159, 5958, 3983, 2663, 12434, 8707, 2461, 2643, 2649,
    2456, 10006, 5909, 5911, 5912, 5913, 11241, 11242, 18406, 12429, 5914, 5910, ITEMID.materials.log, gemBagConf.itemID, herbBagConf.itemID,
    }
    if not isInArray(burnableItems, item:getId()) then return end
    firePos:sendMagicEffect(39)
    firePos:sendMagicEffect(37)
    return true, item:remove(count)
end

--[[
itemList = {{
    itemID = INT or {}  itemID == item:getId() | if itemID is table then choose 1 id randomly from table.
    count = INT or 1    amount of items rewarded
    itemAID = INT       if used item has action ID
    fluidType = INT     if used then sets item type
    itemText = STR      
    itemName = STR      
}},
]]
function itemList_merge(itemList, itemList2)
    if itemList.itemID or itemList.itemAID then itemList = {itemList} end
    if itemList2.itemID or itemList2.itemAID then itemList2 = {itemList2} end
local newItemList = {}
local loopID = 0

    local function updateItemList(itemT, newCount)
        local count = newCount or itemT.count
        loopID = loopID + 1
        newItemList[loopID] = {itemID = itemT.itemID, itemAID = itemT.itemAID, fluidType = itemT.fluidType, count = count, itemText = itemT.itemText}
    end

    local function mergeItemT(itemT)
        if not type(itemT.itemID) ~= "table" then return updateItemList(itemT) end
        
        for _, itemT2 in pairs(itemList2) do
            if compare(itemT.itemID, itemT2.itemID) and compare(itemT.itemAID, itemT2.itemAID) then
                local count = itemT.count or 1
                local count2 = itemT2.count or 1
                local newCount = count + count2
                
                if newCount > 0 then updateItemList(itemT, newCount) end
            else
                updateItemList(itemT)
            end
        end
    end

    for _, itemT in pairs(itemList) do mergeItemT(itemT) end
    return newItemList
end

function itemList_getItemT(itemList, itemID)
    if itemList.itemID or itemList.itemAID then itemList = {itemList} end
    
    for _, itemT in pairs(itemList) do
        if itemT.itemID == itemID then return itemT end
    end
end

function discardItem(player, item, itemEx, fromPos, toPos, fromObject, toObject)
    if not toObject then return end
    if toObject:isPlayer() then return end
    if toObject:isContainer() and player:getBag() then
        if toObject:getUniqueId() == player:getBag():getUniqueId() then return end
    end
    return item:remove()
end

function Item.getItemT()
    return {
        itemPos = item:getPosition(),
        itemID = item:getID(),
        itemAID = item:getActionID(),
        itemText = item:getAttribute(TEXT),
        count = item:getCount(),
    }
end

function Item.tempRemove(amount, msTime)
    local itemT = item:getItemT()
    item:remove()
    addEvent(createItem, (msTime or 0), itemT)
end
