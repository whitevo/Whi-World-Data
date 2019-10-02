if not herbBagConf then
herbBagConf = {
    itemID = 13506,
}

local feature_herbBag = {
    IDItems_onMove = {
        [herbBagConf.itemID] = {funcStr = "herbBag_onMove"},
    },
    IDItems = {
        [herbBagConf.itemID] = {funcStr = "herbBag_onUse"},
    },
    IDItems_onLook = {
        [herbBagConf.itemID] = {funcStr = "herbBag_onLook"},
    },
    IDTiles_stepIn = {
        [8298] = {funcSTR = "herbBag_autoLoot"},
        [8299] = {funcSTR = "herbBag_autoLoot"},
        [8301] = {funcSTR = "herbBag_autoLoot"},
        [8302] = {funcSTR = "herbBag_autoLoot"},
    },
    onMove = {
        {funcStr = "herbBag_moveHerbToBag"},
    },
    modalWindows = {
        [MW.herbBag] = {
            name = "Herb Bag",
            title = "Choose powder to take out of herb bag",
            choices = "herbBagMW_choices",
            buttons = {
                [100] = "take",
                [101] = "Close",
                [102] = "list",
            },
            say = "*Checking herb bag*",
            func = "herbBagMW",
            save = "herbBagMW_save",
        },
    },
}

centralSystem_registerTable(feature_herbBag)
end

function herbBag_onUse(player, item) return herbBag_open(player, item) end
function herbBag_onMove(player, item) return item:isHerbBag() and not player:isOwner(item) end

function herbBag_onLook(player, item)
    local desc = "Herb Bag\nWeight: 25\n"

    if getSV(player, SV.extraInfo) == -1 then
        desc = desc.."To autoloot herbs, step on the herbs\n"
        desc = desc.."Herbs turned into powder are automatically added to herb bag\n"
        desc = desc.."USE the bag to take herbs out\n"
    end
    return player:sendTextMessage(GREEN, desc)
end

function herbBag_open(player, item)
    if not player:isOwner(item) then return true end
    if tableCount(herbBag_getHerbList(item)) == 0 then return player:sendTextMessage(GREEN, "Herb bag is empty") end
    return player:createMW(MW.herbBag, item)
end

function herbBag_moveHerbToBag(player, item, _, fromPos, toPos, fromObject, toObject)
    if not item:isHerb() then return end
    if testServer() then return end
    if not toObject or not fromObject then return print("ERROR herbBag_moveItem") end
    if not toObject:isHerbBag() then toObject = targetContainer(player, toObject, toPos) end
    if not toObject:isHerbBag() then return end
    herbBag_addHerb(player, item, toObject)
    return true
end

function herbBag_addHerb(player, item, bag)
    local herbT = herbs_getHerbT(item)
    local amount = bag:getText(herbT.name) or 0
    local count = item:getCount()

    bag:setText(herbT.name, amount + count)
    doSendMagicEffect(player:getPosition(), 31)
    player:sendTextMessage(ORANGE, plural(herbT.name, count).." added to "..bag:getName())
    return item:remove()
end

function herbBagMW_choices(player, item)
    local choiceT = {}
    local loopID = 0

    for herbName, amount in pairs(herbBag_getHerbList(item)) do
        loopID = loopID+1
        choiceT[loopID] =  herbName.." -- "..amount
    end
    return choiceT
end

function herbBagMW_save(player, item) return {choiceT = herbBagMW_choices(player, item), item = item} end

function herbBagMW(player, mwID, buttonID, choiceID, saveT)
    if buttonID == 101 then return end
    if buttonID == 102 then
        player:sendTextMessage(BLUE, " --->  herb bag  <---")
        for _, msg in ipairs(saveT.choiceT) do player:sendTextMessage(ORANGE, msg) end
        return true
    end
    local chosenStr = saveT.choiceT[choiceID]
    local totalAmount = tonumber(chosenStr:match("%d+"))
    local herbName = chosenStr:match("%a+ ?%a+ ?%a+ ?%a+")
    local herbT = herbs_getHerbT(herbName)
    local count = totalAmount < 6 and 1 or 5 
    
    if not herbT then return print("ERROR - missing herbT in herbBagMW() "..herbName) end
    saveT.item:setText(herbName, totalAmount - count)
    herbs_createHerbPowder(player, herbT, count, true)
    return herbBag_open(player, saveT.item)
end

function herbBag_autoLoot(player, item, dontAutoLoot)
    if dontAutoLoot and type(dontAutoLoot) == "boolean" then return end
    if not player:isPlayer() then return end
    if not item:isHerb() then return end
    
    local herbBag = player:getItemById(herbBagConf.itemID, true)
    if not herbBag then return end
    return herbBag_addHerb(player, item, herbBag)
end

-- get functions
function herbBag_getHerbList(item)
    local text = item:getAttribute(TEXT)
    local tempList = {}
    local list = {}

    for w in text:gmatch(".-%(.-%)") do table.insert(tempList, w) end
    
    for _, str in pairs(tempList) do
        local key = str:gsub("%(.-%)", "")
        
        key = key:gsub(" ", "", 1)
        
        if key ~= "accountID" then
            local amount = getFromText(key, str)
            if tonumber(amount) and amount > 0 then list[key] = amount end
        end
    end
    return list
end

function Item.isHerbBag(item) return herbBagConf.itemID == item:getId() end
function Creature.isHerbBag() return false end
function Tile.isHerbBag() return false end