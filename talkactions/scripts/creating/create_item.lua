function onSay(player, words, param)
    if not player:isGod() then return true end
    local split = param:split(",")
    local itemID = tonumber(split[1])

    if not itemID and split[1] then
        local itemName = split[1]:removeSpaces()
        local itemType = ItemType(itemName)
        if itemType then itemID = itemType:getId() end
    end
    if not itemID or itemID == 0 then return false, player:createMW(MW.openItemList) end
    local count = tonumber(split[2])
    local AID = tonumber(split[3])
    local fluidType = tonumber(split[4])
    local playerPos = player:getPosition()

	if not count then count = 1 end

    if count > 10 then
        if not ItemType(itemID):isStackable() then
            count = 10
        else
            if count > 1000 then count = 1000 end
            while count > 100 do
                count = count -100
                createItem(itemID, playerPos, 100, AID, fluidType)
            end
            createItem(itemID, playerPos, count, AID, fluidType)
            return
        end
    end
    createItem(itemID, playerPos, count, AID, fluidType)
end

environmentConf = {
    items = {
        {itemID = 5370, name = "NS post sign"},
        {itemID = 5371, name = "WE post sign"},
        {itemID = 1429, name = "NS wooden sign"},
        {itemID = 1430, name = "arrow N sign"},
        {itemID = 1431, name = "arrow W sign"},
        {itemID = 1432, name = "arrow S sign"},
        {itemID = 1433, name = "arrow E sign"},
        {itemID = 1434, name = "WE wooden sign"},
    },
}

local godCreatingItemsMW = {
    [MW.openItemList] = {
        name = "Create items",
        title = "choose equipment type",
        choices = "createItems_createEquipmentTypeChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Close",
        },
        say = "browsing trough all Whi World equipment items",
        func = "createItems_createEquipmentTypeMW",
    },
    [MW.quiverItems] = {
        name = "Create items",
        title = "quiver slot",
        choices = "createItems_createQuiverItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createQuiverItemMW",
    },
    [MW.headItems] = {
        name = "Create items",
        title = "head slot",
        choices = "createItems_createHeadItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createHeadItemMW",
    },
    [MW.shieldItems] = {
        name = "Create items",
        title = "shield slot",
        choices = "createItems_createShieldItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createShieldItemMW",
    },
    [MW.bodyItems] = {
        name = "Create items",
        title = "body slot",
        choices = "createItems_createBodyItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createBodyItemMW",
    },
    [MW.legsItems] = {
        name = "Create items",
        title = "legs slot",
        choices = "createItems_createLegsItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createLegsItemMW",
    },
    [MW.bootsItems] = {
        name = "Create items",
        title = "boots slot",
        choices = "createItems_createBootsItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createBootsItemMW",
    },
    [MW.arrowsItems] = {
        name = "Create items",
        title = "arrow slot",
        choices = "createItems_createArrowsItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createArrowsItemMW",
    },
    [MW.weaponItems] = {
        name = "Create items",
        title = "weapon slot",
        choices = "createItems_createWeaponItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createWeaponsItemMW",
    },
    [MW.bagItems] = {
        name = "Create items",
        title = "bag slot",
        choices = "createItems_createBagItemChoices",
        buttons = {
            [100] = "Choose",
            [101] = "Back",
        },
        func = "createItems_createBagItemMW",
    },
    [MW.god_createFood] = {
        name = "Create Food",
        title = "Choose food to make",
        choices = "god_createFoodMW_choices",
        buttons = {
            [100] = "Choose",
            [101] = "Close",
        },
        say = "creating food",
        func = "god_createFoodMW",
    },
    [MW.god_createEnvironment] = {
        name = "Create Environment",
        title = "Choose item to make",
        choices = "godCreate_MW_environment_choices",
        buttons = {
            [100] = "Choose",
            [101] = "Close",
        },
        say = "creating environmental items",
        func = "godCreate_MW_environment_handle",
    },
}

function createItems_createEquipmentTypeChoices(player)
    local choiceT = {}
    local loopID = 0

    loopID = 1
    choiceT[loopID] = "food"
    loopID = 2
    choiceT[loopID] = "environment"

	for slot, itemList in pairs(itemTable) do
        loopID = loopID+1
        if slot ~= "other" then choiceT[loopID] = slot end
	end
    return choiceT
end

function createItems_createEquipmentTypeMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    if choiceID == 1 then return player:createMW(MW.god_createFood) end
    if choiceID == 2 then return player:createMW(MW.god_createEnvironment) end
    local choiceT = createItems_createEquipmentTypeChoices(player)
    local chosenType = choiceT[choiceID]

    return player:createMW(MW[chosenType.."Items"])
end

local function createChoiceT(itemsT)
    local choiceT = {}
    local loopID = 0
    
    for itemID, itemT in pairs(itemsT) do
        loopID = loopID+1
		choiceT[loopID] = itemT.name or ItemType(itemID):getName()
	end
    return choiceT
end

local function getItemID(player, itemsT, choiceID)
    local loopID = 0

    for itemID, itemT in pairs(itemsT) do
        loopID = loopID + 1
        if choiceID == loopID then return itemID end
	end
end

local function makeItem(player, itemsT, choiceID, buttonID)
    if buttonID == 101 then return player:createMW(MW.openItemList) end
    if choiceID == 255 then return end
    local itemID = getItemID(player, itemsT, choiceID)
    local itemT = items_getStats(itemID)
    
    if not itemT then
        itemT = itemsT[itemID]
        return createItem(itemT.itemID, player:getPosition(), 1, itemT.itemAID, itemT.fluidType, itemT.itemText)
    end
    
    local count = itemT.breakchance and 50 or 1
    local item = player:addItem(itemID, count)
    if itemT.itemAID then item:setActionId(itemT.itemAID) end
end

function createItems_createQuiverItemChoices(player) return createChoiceT(itemTable.quiver) end
function createItems_createHeadItemChoices(player) return createChoiceT(itemTable.head) end
function createItems_createShieldItemChoices(player) return createChoiceT(itemTable.shield) end
function createItems_createBodyItemChoices(player) return createChoiceT(itemTable.body) end
function createItems_createLegsItemChoices(player) return createChoiceT(itemTable.legs) end
function createItems_createBootsItemChoices(player) return createChoiceT(itemTable.boots) end
function createItems_createArrowsItemChoices(player) return createChoiceT(itemTable.arrows) end
function createItems_createWeaponItemChoices(player) return createChoiceT(itemTable.weapon) end
function createItems_createBagItemChoices(player) return createChoiceT(itemTable.bag) end
function godCreate_MW_environment_choices(player) return createChoiceT(environmentConf.items) end
function createItems_createQuiverItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.quiver, choiceID, buttonID) end
function createItems_createHeadItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.head, choiceID, buttonID) end
function createItems_createShieldItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.shield, choiceID, buttonID) end
function createItems_createBodyItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.body, choiceID, buttonID) end
function createItems_createLegsItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.legs, choiceID, buttonID) end
function createItems_createBootsItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.boots, choiceID, buttonID) end
function createItems_createArrowsItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.arrows, choiceID, buttonID) end
function createItems_createWeaponsItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.weapon, choiceID, buttonID) end
function createItems_createBagItemMW(player, mwID, buttonID, choiceID) return makeItem(player, itemTable.bag, choiceID, buttonID) end
function godCreate_MW_environment_handle(player, mwID, buttonID, choiceID) return makeItem(player, environmentConf.items, choiceID, buttonID) end

central_register_intoGlobalT(godCreatingItemsMW, modalWindows)

function god_createFoodMW_choices(player)
    local choiceT = {}
    local loopID = 0

	for itemIDorName, foodT in pairs(foodConf.food) do
        local itemName = itemIDorName
        loopID = loopID+1
        if tonumber(itemName) then itemName = ItemType(itemIDorName):getName() end
		choiceT[loopID] = itemName
	end
    return choiceT
end

function god_createFoodMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    local loopID = 0

    for itemIDorName, foodT in pairs(foodConf.food) do
        loopID = loopID+1
        if loopID == choiceID then
            local itemID = itemIDorName
            local count = 20
            local foodAID = AID.other.food
            
            if foodT.fluidType then foodAID = nil end
            if not ItemType(itemID):isStackable() then count = 1 end
            player:giveItem(foodT.itemID, count, foodAID, foodT.fluidType)
            player:getPosition():sendMagicEffect(15)
            return player:createMW(mwID)
        end
	end
end