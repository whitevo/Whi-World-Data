--[[ randomLoot config guide
    [INT] = {
        firstTimeMSG = STR          Message what appears on item when the item is used first time (because it cant be opened at first)
        CDmin = INT or 60           Minimum cooldown when item will get new item (in minutes)
        CDmax = INT or CDmin        Maximum cooldown when item will get new item (in minutes)
        perPerson = false           if true then items are individual per player
        multibleAllowed = false     if true then container goes trough all items and can have all the rewards.
        itemAmount = INT            rewards itemAmount of items from list

        items = {{
            itemID = INT            item:getId()
                                    + if itemID is table then choose 1 id randomly from table.
            chance = INT or 100     1-1000, 1 = 0,1%
            count = INT or 1
            itemAID = INT 
            fluidType = INT
            itemText = STR
            rollStats = BOOL        item will have random stats
        }}

        AUTOAMTIC
        lastID = INT                if perPerson used
    }
]]

-- 3656 is debris item I use on object when it cant be turned into container.
-- ITS NOT AUTOMATIC so need to put debris with correct AID in map editor!
randomLootT = randomLootT or {}
local chestIDT = {}  --  [playerID] = {[chestID] = nextAllowedTime}

function randomLoot(player, item)
    local itemAID = item:getActionId()
    local lootT = randomLootT[itemAID]
    if not lootT then return print("missing LootTable for itemAID: "..itemAID) end
    if not randomLoot_createNewItems(player, item, lootT) then return end
    
    item = randomLoot_turnItemIntoContainer(item, lootT)
    if not item then return true end

    if lootT.items.itemID then lootT.items = {lootT.items} end
    randomLoot_setCD(player, item, lootT)
    item:clearContainer()
    
    if lootT.itemAmount then
        for x=1, lootT.itemAmount do
            local itemT = randomValueFromTable(lootT.items)
            randomLoot_addReward(player, item, itemT, lootT.perPerson)
        end
    else
        for _, t in ipairs(lootT.items) do
            local chance = t.chance or 100
            local roll = math.random(1, 1000)
            
            if chance >= roll then
                randomLoot_addReward(player, item, t, lootT.perPerson)
                if not lootT.multibleAllowed then break end
            end
        end
    end
    return lootT.perPerson
end

function randomLoot_createNewItems(player, item, lootT)
    if not lootT.perPerson then return (tonumber(item:getAttribute(TEXT)) or 0) < os.time() end
    local idT = chestIDT[player:getId()]
    if not idT then return true end

    local chestID = item:getText("chestID")
    if not chestID or not idT[chestID] then return true end
    return idT[chestID] < os.time()
end

function randomLoot_setCD(player, item, lootT)
    local CDmin = lootT.CDmin or 60
    local CDmax = lootT.CDmax or CDmin
    local currentCD = math.random(CDmin, CDmax)
    local nextAllowedTime = os.time()+currentCD*60

    if not lootT.perPerson then return item:setAttribute(TEXT, nextAllowedTime) end
    
    local chestID = item:getText("chestID")
    if not chestID then
        local newID = (lootT.lastID or 0) + 1
        item:setText("chestID", newID)
        lootT.lastID = newID
        chestID = newID
    end

    local playerID = player:getId()
    if not chestIDT[playerID] then chestIDT[playerID] = {} end
    chestIDT[playerID][chestID] = nextAllowedTime
end

function randomLoot_addReward(player, item, t, perPerson)
    local tempCount = t.count or 1
    local count = math.random(1, tempCount)
    local itemID = randomLoot_getItemID(t)
    local itemAID = t.itemAID
    local fluidType = t.fluidType or 1
    local itemText = t.itemText

    if perPerson then
        if t.rollStats then itemText = itemText and itemText.." randomStats" or "randomStats"  end
        return player:rewardItems({itemID = itemID, itemAID = itemAID, fluidType = fluidType, itemText = itemText, count = count}, true)
    end

    if ItemType(itemID):isStackable() then
        local newItem = item:addItem(itemID, count)
        if not newItem then return print("can not put ["..ItemType(itemID):getName().."] inside a container IN randomLoot_addReward() error1") end
        
        newItem:setActionId(itemAID)
        if itemText then newItem:setAttribute(TEXT, itemText) end
        if t.rollStats then items_randomiseStats(newItem) end
    else
        if count > 4 then
            count = 4
            print("TOO BIG COUNT FOR RANDOM LOOT IN randomLoot_addReward()")
        end
        
        for x=1, count do
            local newItem = item:addItem(itemID, fluidType)
            if not newItem then return print("can not put ["..ItemType(itemID):getName().."] inside a container IN randomLoot_addReward() error2") end
            
            newItem:setActionId(itemAID)
            if itemText then newItem:setAttribute(TEXT, itemText) end
            if t.rollStats then items_randomiseStats(newItem) end
        end
    end
end

function randomLoot_turnItemIntoContainer(item, lootT)
    if item:isContainer() then return item end
    local newItem = Game.createContainer(item:getId(), 4, item:getPosition())
    
    if not newItem then return print(item:getId().." cant turn it into container.") end
    if lootT then text(lootT.firstTimeMSG, item:getPosition()) end
    newItem:setActionId(item:getActionId())
    item:remove()
end

function randomLoot_getItemID(t)
    local itemID = t.itemID
    return type(itemID) == "table" and randomValueFromTable(itemID) or itemID
end

function central_register_randomLoot(randomLoot)
    if not randomLoot then return end
    for AID, lootT in pairs(randomLoot) do
        randomLootT[AID] = lootT
        central_register_actionEvent({[AID] = {funcSTR = "randomLoot"}}, "AIDItems")
    end
end