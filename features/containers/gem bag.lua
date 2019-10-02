if not gemBagConf then
gemBagConf = {
    itemID = 18394,
}

local feature_gemBag = {
    IDItems_onMove = {
        [gemBagConf.itemID] = {funcStr = "gemBag_onMove"},
    },
    IDItems = {
        [gemBagConf.itemID] = {funcStr = "gemBag_onUse"},
    },
    IDItems_onLook = {
        [gemBagConf.itemID] = {funcStr = "gemBag_onLook"},
    },
    IDTiles_stepIn = {
        [2147] = {funcSTR = "gemBag_autoLoot"},
        [9970] = {funcSTR = "gemBag_autoLoot"},
        [2150] = {funcSTR = "gemBag_autoLoot"},
        [2146] = {funcSTR = "gemBag_autoLoot"},
        [2149] = {funcSTR = "gemBag_autoLoot"},
        [8305] = {funcSTR = "gemBag_autoLoot"},
    },
    onMove = {
        {funcStr = "gemBag_moveGemToBag"},
    },
    modalWindows = {
        [MW.gemBag] = {
            name = "Gem Bag",
            title = "Choose gem to take out of gem bag",
            choices = "gemBagMW_choices",
            buttons = {
                [100] = "take",
                [101] = "Close",
                [102] = "list",
            },
            say = "*Checking gem bag*",
            func = "gemBagMW",
            save = "gemBagMW_save",
        },
    },
}

centralSystem_registerTable(feature_gemBag)
end

function gemBag_onUse(player, item) return gemBag_open(player, item) end
function gemBag_onMove(player, item) return item:isGemBag() and not player:isOwner(item) end

function gemBag_onLook(player, item)
local desc = "Gem Bag\nWeight: 25\n"

    if getSV(player, SV.extraInfo) == -1 then
        desc = desc.."To autoloot gems, step on the gem\n"
        desc = desc.."USE the bag to take gems out\n"
    end
    return player:sendTextMessage(GREEN, desc)
end

function gemBag_open(player, item)
    if not player:isOwner(item) then return true end
    if tableCount(gemBag_getGemList(item)) == 0 then return player:sendTextMessage(GREEN, "Gem bag is empty") end
    return player:createMW(MW.gemBag, item)
end

function gemBag_moveGemToBag(player, item, _, fromPos, toPos, fromObject, toObject)
    if not item:isGem() then return end
    if testServer() then return end
    if not toObject or not fromObject then return print("ERROR gemBag_moveGemToBag") end
    if not toObject:isGemBag() then toObject = targetContainer(player, toObject, toPos) end
    if not toObject:isGemBag() then return end
    gemBag_addGem(player, item, toObject)
    return true
end

function gemBag_addGem(player, item, bag)
    local itemID = item:getId()
    local amount = bag:getText(itemID) or 0
    local count = item:getCount()

    bag:setText(itemID, amount + count)
    doSendMagicEffect(player:getPosition(), 29)
    player:sendTextMessage(ORANGE, plural(item:getName(), count).." added to "..bag:getName())
    return item:remove()
end

function gemBagMW_choices(player, item)
    local choiceT = {}
    local loopID = 0

    for gemID, amount in pairs(gemBag_getGemList(item)) do
        loopID = loopID+1
        choiceT[loopID] =  ItemType(gemID):getName().." -- "..amount
    end
    return choiceT
end

function gemBagMW_save(player, item) return {choiceT = gemBagMW_choices(player, item), item = item} end

function gemBagMW(player, mwID, buttonID, choiceID, saveT)
    if buttonID == 101 then return end
    if buttonID == 102 then
        player:sendTextMessage(BLUE, " --->  gem bag  <---")
        for _, msg in ipairs(saveT.choiceT) do player:sendTextMessage(ORANGE, msg) end
        return true
    end
local chosenStr = saveT.choiceT[choiceID]
local totalAmount = tonumber(chosenStr:match("%d+"))
local gemName = chosenStr:match("%a+")
local gemT = gems_getGemT(gemName)
local count = totalAmount < 6 and 1 or 5

    saveT.item:setText(gemT.itemID, totalAmount - count)
    player:giveItem(gemT.itemID, count)
    return gemBag_open(player, saveT.item)
end

function gemBag_autoLoot(player, item)
    if not player:isPlayer() then return end
    local gemBag = player:getItemById(gemBagConf.itemID, true)
        
    return gemBag and gemBag_addGem(player, item, gemBag)
end

function autoLoot_gems(player, item)
    if not item:isContainer(true) then return end
    if not player:getItemById(gemBagConf.itemID, true) then return end
local slotIndex = 0

    for x=0, item:getSize() do
        local item = item:getItem(x-slotIndex)
        if not item then break end
        
        if item:isGem() and gemBag_autoLoot(player, item) then slotIndex = slotIndex + 1 end
    end
end

-- get functions
function gemBag_getGemList(item)
local text = item:getAttribute(TEXT)
local tempList = {}
local list = {}

    for w in text:gmatch(".-%(.-%)") do table.insert(tempList, w) end
    
    for _, str in pairs(tempList) do
        local key = str:gsub("%(.-%)", "")
        key = tonumber(key)
        if key then
            local amount = getFromText(key, str)
            if amount > 0 then list[key] = amount end
        end
    end
    return list
end
    
function Item.isGemBag(item) return gemBagConf.itemID == item:getId() end
function Creature.isGemBag() return false end
function Tile.isGemBag() return false end