if not equipmentTokens then
equipmentTokens = {
    ["weapon"] = {
        itemList = allWeapons,
        itemID = 13829,
        itemAID = AID.other.token_weaponSlot,
        failList = {2184, 2376, 2389, 7367}
    },
    ["head"] = {
        itemList = allHeads,
        itemID = 9820,
        itemAID = AID.other.token_headSlot,
        failList = {2461, 7458}
    },
    ["body"] = {
        itemList = allBodies,
        itemID = 9808,
        itemAID = AID.other.token_bodySlot,
        failList = {7463, 2467}
    },
    ["legs"] = {
        itemList = allLegs,
        itemID = 9811,
        itemAID = AID.other.token_legsSlot,
        failList = {7464, 2649}
    },
    ["boots"] = {
        itemList = allBoots,
        itemID = 9817,
        itemAID = AID.other.token_bootsSlot,
    },
    ["shield"] = {
        itemList = allShields,
        itemID = 9814,
        itemAID = AID.other.token_shieldSlot,
    },
    ["quiver"] = {
        itemList = allQuivers,
        itemID = 9814,
        itemAID = AID.other.token_shieldSlot,
        slot = "shield",
    }
}

local equipmentTokensConf = {
    startUpFunc = "equipmentTokens_startUp",
    modalWindows = {
        [MW.equipmentTokens] = {
            name = "Improve item stats with tokens",
            title = "Choose item to improve [yourTokens/requiredTokens]",
            choices = "equipmentTokens_createMWChoices",
            buttons = {
                [100] = "Improve",
                [101] = "close",
            },
            func = "equipmentTokens_upgradeItem",
        },
    }
    --[[
    npcChat = {
        ["bum"] = {
            [1] = {
                question = "Do you know anything about the purple fire in Rooted Catacombs?",
                allSV = {[SV.enchantingAltarHint] = 0},
                setSV = {[SV.enchantingAltarHint] = 1},
                answer = {
                    "You mean the magic altar fire?",
                    "Well yeah, you can throw items what are created with strong magic into the fire.",
                    "if item has excess magic power you might get some magic dust from it",
                    "When I was learning enchanting, I used to throw spell scrolls I didnt need, back to the purple fire.",
                },
            },
        }
    }
    ]]
}

centralSystem_registerTable(equipmentTokensConf)
end

function equipmentTokens_startUp()
    for slot, tokenT in pairs(equipmentTokens) do
        if not tokenT.failList then tokenT.failList = {} end
        if not tokenT.slot then tokenT.slot = slot end
    end
end

function getTokenCount(token)
    if not token then return 0 end
    local itemText = token:getAttribute(TEXT)
    local tokenCount = getFromText("count", itemText) or 1    
    return tokenCount
end

function equipmentTokens_onLook(item, desc)
    if desc then return desc end
    local itemAID = item:getActionId()
    if itemAID < 4000 then return end
    
    for slot, tokenT in pairs(equipmentTokens) do
        if itemAID == tokenT.itemAID then
            local tokenCount = getTokenCount(item)
            local itemInfo = " \nYou can use "..tokenT.slot.." tokens on any "..tokenT.slot.." equipment to upgrade the item stats. "
            local upgradeInfo = "\nTo upgrade item, take tokens and item to Bum. "
            local stackInfo = "\nTo stack tokens, drop token on another token. "
            
            return plural(tokenT.slot.." token", tokenCount)..itemInfo..upgradeInfo..stackInfo
        end
    end
end

function equipmentTokens_createToken(player, hammer, itemEx)
    if not itemEx:isItem() then return end
    local itemExID = itemEx:getId()
    local toPos = getParentPos(itemEx)
    local tile = Tile(toPos)
    if not tile then return player:sendTextMessage(GREEN, "Cant use hammer like that") end
    
    local slotStr = getSlotStr(itemExID)
    local itemExName = itemEx:getName()
    
    for slot, tokenT in pairs(equipmentTokens) do
        if slotStr == slot then
            if not isInArray(tokenT.itemList, itemExID) then return end
            if isInArray(tokenT.failList, itemExID) then return player:sendTextMessage(GREEN, "Can't turn "..itemExName.." into "..slotStr.." token") end
            if not findItem(2555, toPos) then return player:sendTextMessage(GREEN, "You need better surface to turn "..itemExName.." into "..slotStr.." token") end
            tools_addCharges(player, hammer, -1)
            createItem(tokenT.itemID, toPos, 1, tokenT.itemAID)
            doSendMagicEffect(toPos, {10, 30, 4})
            return itemEx:remove()
        end
    end
end

local function getTokenAID(item)
    local itemAID = item:getActionId()
    if itemAID < 4000 then return end

    for _, tokenT in pairs(equipmentTokens) do
        if itemAID == tokenT.itemAID then return itemAID end
    end
end

function equipmentTokens_stack(player, item, toPos)
    local itemID = item:getId()
    local tokenAID = getTokenAID(item)
    if not tokenAID then return end
    
    local anotherToken = findItem(itemID, toPos)
    if not anotherToken then return end
    
    local itemCount = getTokenCount(item)
    local itemExCount = getTokenCount(anotherToken)

    anotherToken:setText("count", itemCount + itemExCount)
    doSendMagicEffect(toPos, {10, 30, 4})
    return item:remove()
end

local function getTokenAmountT(player)
    local tokenAmount = {}
    
    for slot, tokenT in pairs(equipmentTokens) do
        local token = player:getItem(tokenT.itemID, tokenT.itemAID)
        local count = getTokenCount(token)
        tokenAmount[slot] = count
    end
    return tokenAmount
end

function equipmentTokens_createMWChoices(player)
    local choiceT = {}
    local loopID = 0
    local bag = player:getBag()
    local tokenAmount = getTokenAmountT(player)

    local function addItemToList(item, equipped)
        if not item then return end
        local itemID = item:getId()
        local slotStr = getSlotStr(itemID)
        local itemT = equipmentTokens[slotStr]
        
        if not itemT then return end
        if not isInArray(itemT.itemList, itemID) then return end
        local itemName = item:getName()
        local equipedStr = equipped and "(equipped)" or ""
        local upgradeInfo = item:hasMaxStats() and " (max)" or " - ["..tokenAmount[itemT.slot].."/"..equipmentTokens_getRequiredTokens(itemID).."]"
        loopID = loopID + 1
		choiceT[loopID] = itemName..equipedStr..upgradeInfo
    end
    
    for x=0, 13 do
        local item = player:getSlotItem(x)
        addItemToList(item, true)
    end
    
    for x=0, bag:getSize() do
        local item = bag:getItem(x)
        if not item then break end
        addItemToList(item)
    end
    return choiceT
end

function equipmentTokens_upgradeItem(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    local loopID = 0
    
    local function getItem()
        local function checkItem(item)
            if not item then return end
            local itemID = item:getId()
            local slotStr = getSlotStr(itemID)
            local tokenT = equipmentTokens[slotStr]
            
            if not tokenT then return end
            if not isInArray(tokenT.itemList, itemID) then return end
            loopID = loopID + 1
            
            if loopID == choiceID then return tokenT end
        end
        
        for x=0, 13 do
            local item = player:getSlotItem(x)
            local tokenT = checkItem(item)
            if tokenT then return item, tokenT end
        end
        
        local bag = player:getBag()
        for x=0, bag:getSize() do
            local item = bag:getItem(x)
            if not item then break end
            local tokenT = checkItem(item)
            if tokenT then return item, tokenT end
        end
    end
    
    local item, tokenT = getItem()
    if not item then return end
    
    local requiredTokens = equipmentTokens_getRequiredTokens(item)
    local token = player:getItem(tokenT.itemID, tokenT.itemAID)
    local tokenCount = getTokenCount(token)
        
    if tokenCount < requiredTokens then return player:sendTextMessage(GREEN, "Not enough tokens to upgrade "..item:getName()) end
    if not itemSystem_improveRandomStat(player, item) then return player:createMW(mwID) end
    local newTokenCount = tokenCount - requiredTokens
    
    if newTokenCount > 0 then token:setText("count", newTokenCount) else token:remove() end
    player:createMW(mwID)
end

function itemSystem_improveRandomStat(player, item)
    if not item:isEquipment() then return end
    local defaultStatT = items_getStats(item)
    local possibleStatT = {}
    local itemText = item:getAttribute(TEXT)

    for stat, value in pairs(defaultStatT) do
        local statT = itemsConf_itemStatT[stat]
        
        if statT and statT.randomStat then
            local valueBefore = getFromText(stat, itemText) or 0
            if valueBefore ~= statT.randomStat then table.insert(possibleStatT, stat) end
        end
    end
    
    if defaultStatT.setDSV then
        for sv, modT in pairs(defaultStatT.setDSV) do
            local itemValue = items_getItemSV(item, sv, modT)
            if itemValue ~= modT.max then table.insert(possibleStatT, sv) end
        end
    end
    
    if tableCount(possibleStatT) == 0 then return false, player:sendTextMessage(GREEN, item:getName().." stats are already maxed out") end
    local randomStat = randomValueFromTable(possibleStatT)
    
    if type(randomStat) == "number" then return itemSystem_improveItemSV(player, item, randomStat) end
    return itemSystem_improveStat(player, item, randomStat)
end

function itemSystem_reduceStat(player, item, stat)
    local statT = itemsConf_itemStatT[stat]
    local extraStatValue = item:getText(stat) or 0
    local itemName = item:getName()
    local lossAmount = math.random(1, statT.randomStat)
    local amount = newExtraStatValue - lossAmount

    item:setBonusStat(stat, amount)
    player:sendTextMessage(GREEN, itemName.." "..statT.fullName.." has been decreased by "..lossAmount)
end

function itemSystem_improveItemSV(player, item, sv)
    local itemT = items_getStats(item)
    local modT = itemT.setDSV[sv]
    local itemValue = items_getItemSV(item, sv, modT)
    local itemName = item:getName()

    if itemValue >= modT.max then return false, player:sendTextMessage(GREEN, itemName.." "..modT.name.." is already maxed out") end
    local improveAmount = 0
    local newExtraStatValue = 0
    local afterValueStr = modT.afterValueStr or "%"

    if modT.min < modT.max then
        newExtraStatValue = math.random(itemValue+1, modT.max)
        improveAmount = newExtraStatValue - itemValue
    else
        newExtraStatValue = math.random(modT.max, itemValue-1)
        improveAmount = itemValue - newExtraStatValue
    end
    
    item:setText("SV"..sv, newExtraStatValue)
    if player:isEquipped(item:getId()) then player:setSV(sv, newExtraStatValue) end
    player:sendTextMessage(GREEN, itemName.." "..modT.name.." has been improved by "..improveAmount..afterValueStr)
    return player:sendTextMessage(ORANGE, itemName.." "..modT.name.." has been improved by "..improveAmount..afterValueStr)
end

function itemSystem_improveStat(player, item, stat)
    local statT = itemsConf_itemStatT[stat]
    local maxMod = statT.randomStat
    local extraStatValue = item:getText(stat) or 0
    local itemName = item:getName()
    if extraStatValue >= maxMod then return false, player:sendTextMessage(GREEN, itemName.." "..statT.fullName.." is already maxed out") end

    local newExtraStatValue = math.random(extraStatValue+1, maxMod)
    local increaseAmount = newExtraStatValue - extraStatValue
    item:setBonusStat(stat, newExtraStatValue)
    player:sendTextMessage(GREEN, itemName.." "..statT.fullName.." has been increased by "..increaseAmount)
    return player:sendTextMessage(ORANGE, itemName.." "..statT.fullName.." has been increased by "..increaseAmount)
end

function equipmentTokens_npcButton(player) return player:createMW(MW.equipmentTokens) end
function equipmentTokens_getRequiredTokens(itemID) return items_getStats(itemID).requiredTokens end