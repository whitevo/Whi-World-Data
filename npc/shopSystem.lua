function npcShop_startUp()
    local configKeys = {"bigSV", "bigSVF", "allSV", "npcName", "items", "anySVF", "anySV"}
    local itemConfigKeys = {"oneAtTheTime", "itemID", "itemAID", "fluidType", "itemText", "cost", "sell", "maxStock", "baseStock", "genStockSecTime", "genStockAmount"}

    local function missingError(missingKey, errorMsg, t)
        print("ERROR - missing value in npcShop_startUp() -  "..errorMsg..missingKey)
        Uprint(t, "error table")
    end
    local function unknownError(key, errorMsg, t)
        print("ERROR - unknown key ["..key.."] in npcShop_startUp() - "..errorMsg)
        Uprint(t, "error table")
    end
    
    local function checkItemList(itemList)
        if not itemList then return end
        if itemList.itemID then return {itemList} end
        return itemList
    end
    
    for shopID, shopT in pairs(npc_conf.allShopT) do
        local errorMsg = "npc_conf.allShopT["..shopID.."]"
        
        if not shopT.npcName then return missingError("npcName", errorMsg, shopT) end
        if type(shopT.npcName) == "string" then shopT.npcName = {shopT.npcName} end

        for _, npcName in ipairs(shopT.npcName) do
            if not isInArray(npc_conf.allNpcNames, npcName) then print("ERROR - npc ["..npcName.."] does not exist in game or not registered correctly "..errorMsg) end
            if not npc_conf.npcShops[npcName] then npc_conf.npcShops[npcName] = {} end
            table.insert(npc_conf.npcShops[npcName], shopID)
        end

        for key, v in pairs(shopT) do
            if not isInArray(configKeys, key) then unknownError(key, errorMsg, shopT) end
        end
        shopT.items = checkItemList(shopT.items)
        for _, itemT in ipairs(shopT.items) do
            for key, v in pairs(itemT) do
                if not isInArray(itemConfigKeys, key) then unknownError(key, errorMsg, shopT) end
            end
            if not itemT.cost and not itemT.sell then missingError("cost/sell", errorMsg, shopT) end
            if itemT.baseStock or itemT.maxStock then
                if not itemT.baseStock then itemT.baseStock = 0 end
                if not itemT.genStockSecTime then itemT.genStockSecTime = 10 end
                if not itemT.genStockAmount then itemT.genStockAmount = 1 end
            end
        end
    end
end

local stockList = {} -- [npcName] = {[itemID] = {amount = INT, lastUpdate = os.time()}

function shopSystem_openShop(player, npcName)
    local shopList = shopSystem_getShopList(player, npcName)
    return player:createMW(MW.shop, npcName, shopList)
end

function shopSystem_saveNpcName(player, npcName) return npcName end

function shopSystem_createChoices(player, npcName, shopList)
    local choiceT = {}
    local loopID = 0
    
    shopSystem_updateStocks(npcName, shopList)
    
    for _, itemT in ipairs(shopList) do
        local itemID = itemT.itemID
        local itemName = ItemType(itemID):getName()
        local price = itemT.cost or "---"
        local sellValue = itemT.sell or "---"
        local stock = shopSystem_getStock(npcName, itemID)
        
        if stock == -1 then stock = "unlimited" end
        if itemT.maxStock and itemT.maxStock == stock then stock = stock.."(max)" end
        loopID = loopID + 1
        choiceT[loopID] = itemName..":    "..price.."    |    "..sellValue.."    |    "..stock
    end
    return choiceT
end

function shopSystem_shopMW(player, mwID, buttonID, choiceID, npcName)
    if buttonID == 100 then return shopSystem_buyItems(player, npcName, choiceID) end
    if buttonID == 101 then return shopSystem_sellItems(player, npcName, choiceID) end
    if buttonID == 102 then return end
    if buttonID == 103 then return shopSystem_inspectItem(player, npcName, choiceID) end
end

function shopSystem_buyItems(player, npcName, choiceID)
    local itemT = shopSystem_getItemT(player, npcName, choiceID)
    local stock = shopSystem_getStock(npcName, itemT.itemID)
    local errorMsg = false
    local itemType = ItemType(itemT.itemID)
    local itemName = itemType:getName()
    
    if not itemT.cost then
        errorMsg = npcName.." doesn't sell "..itemName
    elseif stock == 0 then
        errorMsg = npcName.." has no more "..itemName.."s left"
    elseif player:getMoney() < itemT.cost then
        errorMsg = "You don't have enough money to buy "..itemName
    elseif player:getEmptySlots() == 0 then
        errorMsg = "You don't have enough room to buy "..itemName
    elseif player:getFreeCapacity() < itemType:getWeight(1) then
        errorMsg = "You don't have enough cap to buy "..itemName
    elseif itemT.oneAtTheTime then
        return shopSystem_buyMW(player, MW.shop_buy, 100, 1, {npcName = npcName, itemT = itemT})
    end
    
    if not errorMsg then return player:createMW(MW.shop_buy, npcName, itemT) end
    player:sendTextMessage(BLUE, errorMsg)
    return shopSystem_openShop(player, npcName)
end

function shopSystem_sellItems(player, npcName, choiceID)
    if quickCloseTrade(player) then return end
    local itemT = shopSystem_getItemT(player, npcName, choiceID)
    if not itemT then
        print("ERROR in shopSystem_sellItems()")
        Vprint(choiceID, "choiceID")
        Vprint(npcName, "npcName")
        return player:sendTextMessage(BLUE, "sorry, this item is bugged, report has been made")
    end
    local stock = shopSystem_getStock(npcName, itemT.itemID)
    local errorMsg = false
    local itemName = ItemType(itemT.itemID):getName()
    local maxStock = itemT.maxStock or stock + 1
    
    if not itemT.sell then
        errorMsg = npcName.." doesn't buy "..itemName
    elseif stock >= maxStock then
        errorMsg = npcName.." currently doesn't want to buy "..itemName
    elseif player:getEmptySlots() == 0 then
        errorMsg = "You need at least 1 free slot to sell "..itemName
    elseif player:getItemCount(itemT.itemID, itemT.itemAID, itemT.fluidType) == 0 then
        errorMsg = "You dont have any "..itemName.. " for sell"
    elseif itemT.oneAtTheTime then
        return shopSystem_sellMW(player, MW.shop_sell, 100, 1, {npcName = npcName, itemT = itemT})
    end
    
    if not errorMsg then return player:createMW(MW.shop_sell, npcName, itemT) end
    player:sendTextMessage(BLUE, errorMsg)
    return shopSystem_openShop(player, npcName)
end

function shopSystem_inspectItem(player, npcName, choiceID)
    local itemT = shopSystem_getItemT(player, npcName, choiceID)
    local itemStatT = items_getStats(itemT.itemID)
    local desc = ""

    if itemStatT then 
        desc = items_parseStatT(itemStatT)
    else
        local itemType = ItemType(itemT.itemID)
        desc = itemType:getName().." - weight: "..math.ceil(itemType:getWeight()/100).." cap"
    end
    player:sendTextMessage(BLUE, desc)
    return shopSystem_openShop(player, npcName)
end

function shopSystem_buy_name(player, npcName, itemT) return "buying: "..ItemType(itemT.itemID):getName().." for "..itemT.cost.." coins each" end
function shopSystem_sell_name(player, npcName, itemT) return "selling: "..ItemType(itemT.itemID):getName().." for "..itemT.sell.." coins each" end
function shopSystem_buy_save(player, npcName, itemT) return {itemT = itemT, npcName = npcName} end
function shopSystem_sell_save(player, npcName, itemT) return {itemT = itemT, npcName = npcName} end

local function itemAmountByChoice(choiceID)
    if choiceID == 1 then return 1 end
    if choiceID == 2 then return 3 end
    if choiceID == 3 then return 5 end
    if choiceID == 4 then return 10 end
    if choiceID == 5 then return 20 end
    if choiceID == 6 then return 40 end
end

function shopSystem_buyMW(player, mwID, buttonID, choiceID, saveT)
    local npcName = saveT.npcName
    if buttonID == 101 then return shopSystem_openShop(player, npcName) end
    
    local itemT = saveT.itemT
    local itemID = itemT.itemID
    local buyAmount = itemAmountByChoice(choiceID)
    local stock = shopSystem_getStock(npcName, itemID)
    if buyAmount > stock and stock ~= -1 then buyAmount = stock end
    local errorMsg = false
    local goBack = false
    local itemType = ItemType(itemID)
    local itemName = itemType:getName()
    local socketAmount = getSocketAmount(itemID, buyAmount)
    local emptySlots = player:getEmptySlots()
    local totalCost = itemT.cost * buyAmount

    if stock == 0 then
        errorMsg = npcName.." already sold out the remaining "..itemName
        goBack = true
    elseif player:getMoney() < totalCost then
        errorMsg = "You don't have "..totalCost.." gold to buy "..buyAmount.." "..itemName
    elseif player:getEmptySlots() < socketAmount then
        errorMsg = "You don't have enough room to buy "..itemName..". Free "..socketAmount-emptySlots.." more slots in the bag"
    elseif player:getFreeCapacity() < itemType:getWeight(buyAmount) then
        errorMsg = "You don't have enough cap to buy "..buyAmount.." "..itemName
    end
    
    if errorMsg then
        player:sendTextMessage(BLUE, errorMsg)
    else
        local newStockAmount = stock - buyAmount
        if stock == -1 then newStockAmount = -1 end
        local item = player:giveItem(itemID, buyAmount, itemT.itemAID, itemT.fluidType, itemT.itemText)
        local itemName = itemT.itemName or item:getName()
        local buyStr = "You bought "..plural(itemName, buyAmount)

        player:removeMoney(totalCost)
        player:sendTextMessage(BLUE, buyStr)
        player:sendTextMessage(GREEN, buyStr)
        shopSystem_setStock(npcName, itemID, newStockAmount)
        if itemT.oneAtTheTime or newStockAmount == 0 then goBack = true end
    end
    if goBack then return shopSystem_openShop(player, npcName) end
    return player:createMW(MW.shop_buy, npcName, itemT)
end

function shopSystem_sellMW(player, mwID, buttonID, choiceID, saveT)
    local npcName = saveT.npcName
    if buttonID == 101 then return shopSystem_openShop(player, npcName) end

    local itemT = saveT.itemT
    local itemID = itemT.itemID
    local sellAmount = itemAmountByChoice(choiceID)
    local itemCount = player:getItemCount(itemID, itemT.itemAID, itemT.fluidType, true)
    if itemCount < sellAmount or buttonID == 102 then sellAmount = itemCount end
    
    local stock = shopSystem_getStock(npcName, itemID)
    local newStockAmount = stock + sellAmount
    local maxStock = itemT.maxStock or sellAmount
    if stock == -1 then newStockAmount = -1 end
    
    if newStockAmount >= maxStock then
        sellAmount = maxStock-stock
        newStockAmount = maxStock

        if sellAmount < 1 then
            player:sendTextMessage(BLUE, npcName.." currently does not want more of these items")
            return shopSystem_openShop(player, npcName)
        end
    end

    local itemName = itemT.itemName or ItemType(itemID):getName()
    local sellStr = "You sold "..plural(itemName, sellAmount)
    
    player:addMoney(sellAmount * itemT.sell)
    player:removeItem(itemID, sellAmount, itemT.itemAID, itemT.fluidType, true)
    player:sendTextMessage(BLUE, sellStr)
    player:sendTextMessage(GREEN, sellStr)
    shopSystem_setStock(npcName, itemID, newStockAmount)
    shopSystem_openShop(player, npcName)
end

function shopSystem_updateStocks(npcName, shopList)
    if not stockList[npcName] then stockList[npcName] = {} end
    local allStocks = stockList[npcName]
    local time = os.time()
    
    local function updateStockAmount(currentStocks, itemT, passedTime)
        local baseAmount = itemT.baseStock
        if currentStocks == baseAmount then return currentStocks end
        local changeAmount = math.floor(passedTime / itemT.genStockSecTime)
        changeAmount = itemT.genStockAmount * changeAmount
        
        if currentStocks > baseAmount then 
            local newAmount = currentStocks - changeAmount
            if newAmount < baseAmount then return baseAmount end
            return newAmount
        end
        if currentStocks < baseAmount then
            local newAmount = currentStocks + changeAmount
            if newAmount > baseAmount then return baseAmount end
            return newAmount
        end
    end
    
    for _, itemT in ipairs(shopList) do
        local itemID = itemT.itemID
        local baseAmount = itemT.baseStock or -1
        
        if baseAmount then
            local stockT = allStocks[itemID]
            
            if not stockT then
                allStocks[itemID] = {amount = baseAmount, lastUpdate = time}
            else
                local currentStocks = shopSystem_getStock(npcName, itemID)
                local lastUpdateTime = stockT.lastUpdate or time
                
                if currentStocks ~= -1 and time > lastUpdateTime + itemT.genStockSecTime then
                    local passedTime = time - lastUpdateTime
                    local timeLeftTillNextUpdate = passedTime % itemT.genStockSecTime
                    
                    stockT.lastUpdate = time - timeLeftTillNextUpdate
                    stockT.amount = updateStockAmount(currentStocks, itemT, passedTime)
                end
            end
        end
    end
end

function shopSystem_setStock(npcName, itemID, newAmount)
    if not stockList[npcName] then stockList[npcName] = {} end
    local allStocks = stockList[npcName]
    local stockT = allStocks[itemID]

    if stockT then stockT.amount = newAmount return end
    allStocks[itemID] = {amount = newAmount}
end

local closeTradeT = {}
function quickCloseTrade(player)
    local playerID = player:getId()
    
    if  closeTradeT[playerID] then return true end
    if not closeTradeT[playerID] then closeTradeT[playerID] = true end
    addEvent(function() closeTradeT[playerID] = nil end, 1000)
end

-- get functions
function shopSystem_getShopList(player, npcName)
    local shopList = npc_conf.npcShops[npcName] or {}
    local itemList = {}
    local loopID = 0
        
    local function addToItemList(shopT)
        if not compareSV(player, shopT.allSV, "==") then return end
        if shopT.anySV and not anySV_findMatch(player, shopT.anySV) then return end
        if shopT.anySVF and anySV_findMatch(player, shopT.anySVF) then return end
        if not compareSV(player, shopT.bigSV, ">=") then return end
        if not compareSV(player, shopT.bigSVF, "<") then return end

        for _, itemT in ipairs(shopT.items) do
            loopID = loopID + 1
            itemList[loopID] = itemT
        end
    end
    
    for _, shopID in ipairs(shopList) do addToItemList(npc_conf.allShopT[shopID]) end
    return itemList
end

function shopSystem_getStock(npcName, itemID)
    local allStocks = stockList[npcName]
    if not allStocks then return -1 end
    if not allStocks[itemID] then return -1 end
    return allStocks[itemID].amount or 0
end

function shopSystem_getItemT(player, npcName, choiceID)
    local shopList = shopSystem_getShopList(player, npcName)
    return shopList[choiceID]
end

function central_register_npcShop(npcShop)
    if not npcShop then return end
    if type(npcShop[1]) ~= "table" then npcShop = {npcShop} end
    
    for _, shopT in pairs(npcShop) do
        local nextShopID = #npc_conf.allShopT + 1
        npc_conf.allShopT[nextShopID] = shopT
    end
    if check_central_register_npcShop then print("central_register_npcShop") end
end