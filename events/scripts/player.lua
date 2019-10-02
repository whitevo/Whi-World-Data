-- items what can't be moved and traded.
-- byAID = {} generated on startUp
temp_byID = {6109, 6110, 6111, 6112, 9960, 1748, 6022, 15576, 1738, 1739, 1740, 11257, 1770, 2602, 9662, 6023, ITEMID.other.extra_depot_chest, 9008, 2579, 2578, 1666, 1667, 1668, 1669, 12787, 12788, 12789, 12790, 20129}
byID = {}
for _, itemID in ipairs(byID) do byID[itemID] = true end
byItemAID = {[2088]={3000}, [1293]={1000}, [1987]={3000}}

function Player:onBrowseField(position) return turnToTokenBag(self, position) end

function Player:onLook(thing, position, distance)
    local player = self
    if player:getSV(SV.onLookTP) == 1 then return teleport(player, position) end
    if actionSystem_onLook(player, thing) then return end
    if testRoom_onLook(player, thing) then return end
    
    if rebirth_onLook(player) then return print("twaccy onLook") end

    if thing:isCreature() then
   --     if thing:isPlayer() then return player:createMW(MW.playerPanel, thing), player:say("*Checking out "..thing:getName().."*", ORANGE) end
        if imp_onLook(player, thing) then return end
        if npc_talk(player, thing) then return end
    end
    
    local description = "You see " .. thing:getDescription()
    description = customOnLook(player, thing, description) or description
    description = description..godOnLook(player, thing)
	player:sendTextMessage(GREEN, description)
end

function godOnLook(player, thing)
    if not player:isGod() then return "" end
    local description = ""

    if thing:isItem() then
        local itemType = thing:getType()
        local decayId = itemType:getDecayId()
        local itemAID = thing:getActionId()
        
        description = string.format("%s\nItemID: [ %d ]", description, thing:getId())
        if itemAID ~= 0 then description = string.format("%s, ActionID: [ %d ]", description, itemAID) end
        description = description .. "."
        if decayId ~= -1 then description = string.format("%s\nDecayTo: [ %d ]", description, decayId) end
        if thing:getAttribute(TEXT) ~= "" then description = description.."\nItemText: "..thing:getAttribute(TEXT) end
    elseif thing:isCreature() then
        local str = "%s\nHealth: [%d / %d]"
        if thing:getMaxMana() > 0 then str = string.format("%s, Mana: [%d / %d]", str, thing:getMana(), thing:getMaxMana()) end
        description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
    end
    
    local position = thing:getPosition()
    description = string.format(
        "%s\nPosition: {x = %d, y = %d, z = %d}",
        description, position.x, position.y, position.z
    )
    return description
end

function Player:onLookInBattleList(creature, distance)
    local player = self
    if creature:isPlayer() then return player:createMW(MW.playerPanel, creature), player:say("*Checking out "..creature:getName().."*", ORANGE) end
    if npc_talk(player, creature) then return end

	local description = "You see " .. creature:getDescription(distance)..godOnLook(player, creature)
	player:sendTextMessage(GREEN, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(GREEN, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function stackCollectables(player, item, pos, toPos)
    local bag = player:getBag()
    if not bag or bag:getEmptySlots() > 0 then return end
    if not item:isStackable() or getParent(item) then return end
    
    local itemID = item:getId()
    local itemAID = item:getActionId()
    local count = player:getItemCount(itemID, itemAID)
    
    if count < 1 then return end
    if itemAID >= 100 and player:getItemCount(itemID, 0) > 0 then return end -- can't have non AID items in bag if moveable item has one
    
    local itemCount = item:getCount()
    if ItemType(itemID):getWeight(itemCount) > player:getFreeCapacity() then return end

    local totalCount = count + itemCount
    player:removeItem(itemID, count, itemAID)
    player:giveItem(itemID, totalCount, itemAID)
    return item:remove()
end

--[[
    toCylinder can be: 
    tile > if item moved to map position
    player > if item moved to slot position
    container > if item moved inside container
]]

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder) -- cylinders work only for live server
    local player = self
    if not canBeMoved(player, item, fromCylinder, toCylinder) then return end
    
    local tile = Tile(toPosition)
    if tile then
        if tile:hasHole() then return false, player:sendTextMessage(GREEN, "Can't throw items in hole here") end
        if tile:hasStairsUp() then return false, player:sendTextMessage(GREEN, "Can't throw items up the stairs like that") end
    end
    ---
    building_moveHouseItem(fromPosition, toPosition, fromCylinder, toCylinder)
    if equipmentTokens_stack(player, item, toPosition) then return end
    if tutorial_wallRoom_upgradeDust(player, item, toPosition) then return end
    if tutorial_staffRoom_createStaff(player, item, toPosition) then return end
    if shadowRoom_placeVial(player, item, toPosition) then return end
    if boneFluteMission_onMoveItem(player, item, toPosition) then return end
    
    if ownerIsPlayer(player, toPosition) and item:hasCustomWeight() and item:getCustomWeight() > 0 then
        if ownerIsPlayer(player, fromPosition) then return end
        local customWeight = item:getCustomWeight()
        if notEnoughCap(player, customWeight, toPosition) then return end
        local originalWeight = item:getWeight()
        local weight = customWeight - originalWeight
        return player:changeWeight(-weight)
    end
    
    if actionSystem_onMoveFunctions(player, item, fromPosition, toPosition, fromCylinder, toCylinder) then return end -- central system should take over eveything!!
    if tutorial_dragRoom_moveStatue(player, fromPosition, toPosition) then return end
    if ghoulMove(player, item, toPosition) then return end
    if stackCollectables(player, item, fromPosition, toPosition) then return end
    if cyclopsSabotageQuest_moveTonkaBody(player, item, toPosition) then return true end
    
    local itemID = item:getId()
    if isInArray({2051,2053,2055}, itemID) then -- lit torches
        setBasinOnFire(toPosition)
        if setCampfireOnFire(toPosition) then return item:remove() end
        if burnTheHey(player, toPosition) then return item:remove() end
        if cyclopsAlcoholBarrels(player, toPosition) then return item:remove() end
        if cyclopsDungeonOilBarrel(item, toPosition) then return end
    end
    
    if shadowRoom_moveDoll(player, item, toPosition) then return end
    if itemID == 1293 and Tile(fromPosition) and Tile(fromPosition):getItemById(1386) then return true end
    removeItemOutOfBag(player, item, fromPosition, toPosition)
    if burnItemOnFire(player, item, toPosition, count) then return end
    return true
end

function canBeMoved(player, target, fromCylinder, toCylinder)
    if target:isItem() then
        local item = target
        local itemID = item:getId()
        local itemAID =  item:getActionId()
        
        for ID, AID in pairs(byItemAID) do 
            if itemID == ID and isInArray(AID, itemAID) then return end
        end

        if byID[itemID] then return end

        if byAID[itemAID] then
            if fromCylinder and fromCylinder:isTile() then
                item:clone():moveTo(item:getPosition())
                item:remove()
            end
            return
        end
        return true
    else
        print("ERROR in canBeMoved - missing additional targetType features")
    end
end

function moveContainer(player, item, _, fromPos, toPos, fromCylinder, toCylinder)
    if royaleConf and isInRange(fromPos, royaleConf.map.upCorner, royaleConf.map.downCorner, true) then return end
    if testServer() then return end
    if not item:isContainer() then return end
    if toPos.y == 3 and player:getSlotItem(3) then return not item:isSpecialBag() and item:isBag() and tokenBag_tryPickUp(player, item) end
    if toCylinder:isPlayer() then return item:isSpecialBag() and player:sendTextMessage(GREEN, "Can not equip special bag.") end

    if toCylinder:isContainer() and not item:isSpecialBag() then
        if toCylinder:getParent():isPlayer() then return tokenBag_tryPickUp(player, item) end
        if item:getItemHoldingCount() > 0 then return player:sendTextMessage(GREEN, item:getName().." must be empty to turn it into token bag") end
        if toCylinder:getEmptySlots() < 1 then return player:sendTextMessage(GREEN, "Not enough room to put bag there") end
        local tokenBag = createItem(9076, player:getPosition(), 1, nil, nil, item:getAttribute(TEXT))
        tokenBag:setText("tokenBag", item:getId())
        tokenBag:moveTo(toCylinder)
        return item:remove()
    end
    
    if item:getWeight()/100 > 250 and getDistanceBetween(player:getPosition(), toPos) > 1 then
        return player:sendTextMessage(GREEN, item:getName().." is too heavy to throw. You can drag heavy containers near yourself.")
    end
end

function Player:onMoveCreature(creature, fromPos, toPos)
    if creature:isNpc() and creature:getName():lower() == "tonka" then return end
    if creature:isNpc() and creature:getName():lower() == "annoying npc" then return end
    if creature:getId() == self:getId() then
        if fromPos.x > toPos.x then
            doTurn(self, "W")
        elseif fromPos.x < toPos.x then
            doTurn(self, "E")
        elseif fromPos.y > toPos.y then
            doTurn(self, "N")
        elseif fromPos.y < toPos.y then
            doTurn(self, "S")
        end
        return
    end
    return true
end

function Player.onTurn(player, direction)
    if player:getDirection() == direction and player:isGod() then teleport(player, player:frontPos()) end
    return true
end

function Player:onTradeRequest(target, item)
    if not canBeMoved(self, item) then return false, self:sendTextMessage(GREEN, "this item cant be traded.") end
    return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

function Player:onGainExperience(source, exp, rawExp)
    if type(source) == "userdata" then return 0 end
    return exp
end

function Player:onLoseExperience(exp)
	return exp
end

function Player:onGainSkillTries(skill, tries)
    if tries > 1000 then
        return 1000-tries
    elseif tries < 15 then
        return 0
    else
        return tries
    end
end

function weaponSkill(player, skill, tries)
    local skills = {SKILL_SWORD, SKILL_AXE, SKILL_CLUB}
    local itsWeaponSkill = false

    for i, enum in pairs(skills) do
        if enum == skill then
            itsWeaponSkill = true
            break
        end
    end
    
    if itsWeaponSkill then
        for _, enum in pairs(skills) do
            player:addSkillTries(enum, tries)
        end
    end
end
-- CUSTOM ON LOOK SYSTEM --
function customOnLook(player, item, realDesc)
    local foundItemDesc = false
    if not item:isItem() then return end
    if item:isEquipment() then return items_onLook(player, item) end
    if getSV(player, SV.lookDisabled) == 1 then return end
    foundItemDesc = checkKeys(item, foundItemDesc)
    foundItemDesc = tools_onLook(player, item, foundItemDesc, realDesc)
    foundItemDesc = food_onLook(item, foundItemDesc)
    foundItemDesc = checkSpellScroll(item, foundItemDesc)
    foundItemDesc = CT_look(player, item, foundItemDesc)
    foundItemDesc = normalDoors_onLook(item, foundItemDesc, realDesc)
    foundItemDesc = equipmentTokens_onLook(item, foundItemDesc)
    return foundItemDesc
end

function checkKeys(item, desc)
    if desc then return desc end
    if not item:isKey() then return end
    
    for keyName, t in pairs(keyRing) do
        if t.itemAID == item:getActionId() then return "This is: "..keyName end
    end
end