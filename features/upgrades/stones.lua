function stones_startUp()
    local function missingError(missingKey, errorMsg) print("ERROR - missing value in "..errorMsg..missingKey) end

    for itemID, stoneT in pairs(stones_conf.stones) do
        local errorMsg = "stones_conf.stones["..itemID.."]."
        if not stoneT.itemTextKey then missingError("itemTextKey", errorMsg) end
        if not stoneT.upgradedItem and not stoneT.upgradedItem_func then missingError("upgradedItem", errorMsg) end
        if not stoneT.stoneL then stoneT.stoneL = 1 end
        if not stoneT.maxValue then stoneT.maxValue = 1 end
        if stoneT.slots and type(stoneT.slots) ~= "table" then stoneT.slots = {stoneT.slots} end
        stoneT.itemID = itemID
    end
end

function stones_onUse(player, stone, item)
    if not item:isItem() then return player:sendTextMessage(GREEN, "Upgrade stones can be used only on equipment items") end
    local stoneT = stones_getStoneT(stone)
    if not stoneT then return print("ERROR in stones_onUse - no stoneT for itemID: "..stone:getId()) end
    if not stones_tryUpgrade(player, item, stoneT) then return end

    local addValue = math.random(1, stoneT.stoneL)
    local newValue = stoneT.replace and addValue or addValue + (item:getText(stoneT.itemTextKey) or 0)
    if newValue > stoneT.maxValue then newValue = stoneT.maxValue end
    item:setText(stoneT.itemTextKey, newValue)

    if stoneT.func then _G[stoneT.func](player, item) end
    player:say("**upgraded item**", ORANGE)
    doSendMagicEffect(getParentPos(item), stoneT.effects, 80)
    return stone:remove(1)
end

function stones_tryUpgrade(player, item, stoneT)
    if not stones_isCorrectSlot(item, stoneT.slots) then
        return player:sendTextMessage(GREEN, "This stone can only be used on these slot items: "..tableToStr(stoneT.slots)) and false
    end
    local value = item:getText(stoneT.itemTextKey)
    if not value then return true end
    if not stoneT.replace and value >= stoneT.maxValue then return stoneT.maxValueBig and player:sendTextMessage(GREEN, stoneT.maxValueBig) and false end
    return true
end

local function modText(text, stoneT, value)
    text = text:gsub("STONE_NAME", stoneT.name)
    text = text:gsub("VALUE", value)
    return text
end

function stones_item_onLook(player, item)
    local stoneList = stones_getStones(item)
    local desc = ""

    for stoneID, value in pairs(stoneList) do
        local stoneT = stones_getStoneT(stoneID)

        if stoneT.upgradedItem_func then
            desc = desc.._G[stoneT.upgradedItem_func](player, item, stoneT)
        elseif not stoneT.rootStoneID then
            desc = desc.."\n"..modText(stoneT.upgradedItem, stoneT, value)
        end
    end
    return desc
end

function stones_removeStoneByID(player, item, stoneID, amount)
    local stoneT = stones_getStoneT(stoneID)
    local currentValue = item:getText(stoneT.itemTextKey)
    if not currentValue then return end
    local lossValue = amount or math.random(1, stoneT.stoneL)
    local newValue = currentValue - lossValue
    local itemName = item:getName()

    if newValue < 1 then return player:sendTextMessage(ORANGE, itemName.." "..stoneT.name.." got destroyed") and item:setText(textKey) end
    player:sendTextMessage(ORANGE, itemName.." lost "..plural(stoneT.name, lossValue))
    item:setText(textKey, newValue)
end

function stones_createChoices(player)
    local choiceT = {}
    local loopID = 0

	for herbAID, stoneT in pairs(stones_conf.stones) do
        loopID = loopID + 1
		choiceT[loopID] = stoneT.name
	end
    return choiceT
end

function createStonesMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    local choiceT = stones_createChoices(player)
    local stoneName = choiceT[choiceID]
    local stoneT = stones_getStoneT(stoneName)
    
    player:addItem(stoneT.itemID, 5)
    player:getPosition():sendMagicEffect(15)
    return player:createMW(mwID)
end

-- get functions
function stones_getStoneT(object)
    if not object then return end

    if type(object) == "userdata" then
        if not object:isItem() then return print("ERROR in stones_getStoneT - object is not item!? "), Uprint(object) end
        return stones_getStoneT(object:getId())
    elseif type(object) == "number" then
        return stones_conf.stones[object]
    elseif type(object) == "string" then
        for stoneID, stoneT in pairs(stones_conf.stones) do
            if object == stoneT.name then return stoneT end
        end
    end
end

function stones_getStones(item)
    local stoneList = {}
    
    for stoneID, stoneT in pairs(stones_conf.stones) do
        local value = item:getText(stoneT.itemTextKey)
        if value then stoneList[stoneID] = value end
    end
    return stoneList
end

function stones_isCorrectSlot(item, slotT)
    if not slotT then return true end
    local itemSlot = getSlotStr(item)
    
    for _, slot in pairs(slotT) do
        if slot == "wand" and item:isWand() then return true end
        if slot == itemSlot then return true end
    end
end

-- stoneUgrade descriptions
function stones_skillStoneDesc(player, item, stoneT)
    local value = item:getText(stoneT.itemTextKey)
    local skill = item:getText("skillStoneSkill")
    local result = items_getStatInfo(skill, {[skill] = value}, nil, nil, true)

    if not result or result == "" then return "" end
    return "\n["..stoneT.name.."] "..result
end

-- special functions
function stoneUpgrade_skillStone(player, item)
    local skills = {"mL","sL","dL","wL"}
    local skill = skills[math.random(1, tableCount(skills))]
    item:setText("skillStoneSkill", skill)
    equipBag(player, item)
end

function speedStone(player)
    local item = player:getSlotItem(SLOT_FEET)
    if not item then return end
    local stoneT = stones_getStoneT("speed stone") -- in future replace with documented ItemID 
    local value = item:getText(stoneT.itemTextKey)

    if not value then return removeCondition(player, "speedStone") end
    return bindCondition(player, "speedStone", -1, {speed = value})
end

function critStone(player)
    local item = player:getSlotItem(SLOT_LEGS)
    if not item then return 0 end
    local stoneT = stones_getStoneT("crit stone")-- in future replace with documented ItemID 
    return item:getText(stoneT.itemTextKey) or 0
end

function sightStone(player, manaCost)
    local item = player:getSlotItem(SLOT_HEAD)
    if not item then return 0 end
    local stoneT = stones_getStoneT("sight stone")
    local value = item:getText(stoneT.itemTextKey)

    if not value then return 0 end
    if not chanceSuccess(value) then return 0 end
    
    local playerPos = player:getPosition()
    local positions = getAreaAround(playerPos)
    for _, pos in pairs(positions) do doSendDistanceEffect(playerPos, pos, 38) end
    playerPos:sendMagicEffect(43)
    return -manaCost
end

function defenceStone(player)
    local item = player:getSlotItem(SLOT_ARMOR)
    if not item then return 0 end
    local stoneT = stones_getStoneT("defence stone")
    return item:getText(stoneT.itemTextKey) or 0
end

function criticalBlockStone(player)
    local item = player:getSlotItem(SLOT_RIGHT)
    if not item then return 0 end
    local stoneT = stones_getStoneT("critical block stone")
    return item:getText(stoneT.itemTextKey) or 0
end

function armorStone(item)
    local stoneT = stones_getStoneT("armor stone")
    return item:getText(stoneT.itemTextKey) or 0
end