if not seedBagConf then
seedBagConf = {
    itemID = 18393,
}

local feature_seedBag = {
    IDItems_onMove = {
        [seedBagConf.itemID] = {funcStr = "seedBag_onMove"},
    },
    IDItems = {
        [seedBagConf.itemID] = {funcStr = "seedBag_onUse"},
    },
    IDItems_onLook = {
        [seedBagConf.itemID] = {funcStr = "seedBag_onLook"},
    },
    onMove = {
        {funcStr = "seedBag_moveSeedToBag"},
    },
    modalWindows = {
        [MW.seedBag] = {
            name = "Seed Bag",
            title = "Choose seed to take out of seed bag",
            choices = "seedBagMW_choices",
            buttons = {
                [100] = "take",
                [101] = "Close",
                [102] = "list",
            },
            say = "*Checking seed bag*",
            func = "seedBagMW",
            save = "seedBagMW_save",
        },
    },
}

centralSystem_registerTable(feature_seedBag)
end

function seedBag_onUse(player, item) return seedBag_open(player, item) end
function seedBag_onMove(player, item) return item:isSeedBag() and not player:isOwner(item) end

function seedBag_onLook(player, item)
local desc = "seed Bag\nWeight: 25\n"

    if getSV(player, SV.extraInfo) == -1 then desc = desc.."USE the bag to take seeds out\n" end
    return player:sendTextMessage(GREEN, desc)
end

function seedBag_open(player, item)
    if not player:isOwner(item) then return true end
    if tableCount(seedBag_getSeedList(item)) == 0 then return player:sendTextMessage(GREEN, "Seed bag is empty") end
    return player:createMW(MW.seedBag, item)
end

function seedBag_moveSeedToBag(player, item, _, fromPos, toPos, fromObject, toObject)
    if not item:isSeed() then return end
    if testServer() then return end
    if not toObject or not fromObject then return print("ERROR seedBag_moveSeedToBag") end
    if not toObject:isSeedBag() then toObject = targetContainer(player, toObject, toPos) end
    if not toObject:isSeedBag() then return end
    seedBag_addSeed(player, item, toObject)
    return true
end    

function seedBag_addSeed(player, item, bag)
local seedAID = item:getActionId()
local amount = bag:getText(seedAID) or 0
local count = item:getCount()
    
    bag:setText(seedAID, amount + count)
    doSendMagicEffect(player:getPosition(), 30)
    
    player:sendTextMessage(ORANGE, plural(farming_getSeedName(seedAID), count).." added to "..bag:getName())
    return item:remove()
end

function seedBagMW_choices(player, item)
local choiceT = {}
local loopID = 0

    for seedAID, amount in pairs(seedBag_getSeedList(item)) do
        local seedT = farming_getGrowT(seedAID)
        loopID = loopID + 1
        choiceT[loopID] =  seedT.name.." seed -- "..amount
    end
    return choiceT
end

function seedBagMW_save(player, item) return {choiceT = seedBagMW_choices(player, item), item = item} end

function seedBagMW(player, mwID, buttonID, choiceID, saveT)
    if buttonID == 101 then return end
    if buttonID == 102 then
        player:sendTextMessage(BLUE, " ---> Seed bag  <---")
        for _, msg in ipairs(saveT.choiceT) do player:sendTextMessage(ORANGE, msg) end
        return true
    end
local chosenStr = saveT.choiceT[choiceID]
local chosenSeedName = chosenStr:match("%a+")
local chosenSeedAID
local totalAmount

    for seedAID, amount in pairs(seedBag_getSeedList(saveT.item)) do
        local seedT = farming_getGrowT(seedAID)
        if seedT.name:match(chosenSeedName) then
            chosenSeedAID = seedAID
            totalAmount = amount
            break
        end
    end
local count = totalAmount < 6 and 1 or 5 
    
    saveT.item:setText(chosenSeedAID, totalAmount - count)
    player:giveItem(farmingConf.seedID, count, chosenSeedAID)
    return seedBag_open(player, saveT.item)
end

function seedBag_autoLoot(player, item)
    if not player:isPlayer() then return end
local seedBag = player:getItemById(seedBagConf.itemID, true)
    
    return seedBag and seedBag_addSeed(player, item, seedBag)
end

function autoLoot_seeds(player, item)
    if not item:isContainer(true) then return end
    if not player:getItemById(seedBagConf.itemID, true) then return end
local slotIndex = 0
    
    for x=0, item:getSize() do
        local item = item:getItem(x-slotIndex)
        if not item then break end
        
        if item:isSeed() and seedBag_autoLoot(player, item) then slotIndex = slotIndex + 1 end
    end
end

-- get functions
function seedBag_getSeedList(item)
local text = item:getAttribute(TEXT)
local tempList = {}
local list = {}

    for w in text:gmatch(".-%(.-%)") do table.insert(tempList, w) end
    
    for _, str in pairs(tempList) do
        local key = str:gsub("%(.-%)", "")
        
        key = key:gsub(" ", "", 1)
        
        if tonumber(key) then
            local amount = getFromText(key, str)
            if tonumber(amount) and amount > 0 then list[tonumber(key)] = tonumber(amount) end
        end
    end
    return list
end

function Item.isSeedBag(item) return seedBagConf.itemID == item:getId() end
function Item.isSeed(item) return farming_getGrowT(item:getActionId()) and true end
function Creature.isSeedBag() return false end
function Creature.isSeed() return false end
function Tile.isSeedBag() return false end
function Tile.isSeed() return false end