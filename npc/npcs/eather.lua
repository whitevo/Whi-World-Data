npcConf_eather = {
    name = "eather",
    npcPos = {x = 570, y = 667, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    npcShop = {
        [1] = {
            npcName = "eather",
            allSV = {[SV.BM_Quest_abducted] = 1},
            items = {itemID = herbBagConf.itemID, cost = 25, oneAtTheTime = true},
        },
        [2] = {
            npcName = "eather",
            allSV = {[SV.banditQuest] = 1},
            items = {itemID = gemBagConf.itemID, cost = 25, oneAtTheTime = true},
        },
        [3] = {
            npcName = "eather",
            items = {
                {itemID = lootBagConf.itemID, sell = 25, cost = 25, itemAID = lootBagConf.itemAID, oneAtTheTime = true},
                {itemID = 11200, sell = 1, maxStock = 20},
                {itemID = 11235, sell = 1, maxStock = 10},
                {itemID = 11224, sell = 1, maxStock = 10},
                {itemID = 5896,  sell = 6, maxStock = 4, genStockSecTime = 2*60},
                {itemID = 5897,  sell = 6, maxStock = 4, genStockSecTime = 2*60},
                {itemID = 13159, sell = 10, maxStock = 3, genStockSecTime = 2*60},
            },
        },
        [4] = {
            npcName = "eather",
            allSV = {[SV.cyclopsStashQuest] = 1},
            items = {itemID = mineralBagConf.itemID, cost = 25, oneAtTheTime = true},
        },
    },
    npcChat = {
        ["eather"] = {
            [47] = {
                question = "Who are you?",
                allSV = {[SV.tanner1] = -1},
                setSV = {[SV.tanner1] = 1},
                answer = "My name is Eather, I'm the tanner.",
            },
            [48] = {
                question = "What do you do?",
                allSV = {[SV.tanner1] = 1, [SV.tanner2] = -1},
                setSV = {[SV.tanner2] = 1},
                answer = "I craft equipment from fur and leather.",
            },
            [49] = {
                question = "Do you need any help?",
                allSV = {[SV.tanner2] = 1, [SV.wolfMission] = -1},
                setSV = {[SV.wolfMission] = 0, [SV.boarMission] = 0, [SV.bearMission] = 0},
                answer = {
                    "Always! There is never enough tanning material.",
                    "Gather materials for me and maybe I'll craft something for you.",
                },
            },
            [50] = {
                question = "What is this place?",
                allSV = {[SV.tanner2] = 1, [SV.tanner4] = -1},
                setSV = {[SV.tanner4] = 1},
                answer = {
                    "My home town. It looks a bit sad now, I know, but it's still glorious in my eyes.",
                    "Now we call it the Forgotten Village."
                },
            },
            [51] = {
                question = "What happened here?",
                allSV = {[SV.tanner4] = 1, [SV.tanner5] = -1},
                setSV = {[SV.tanner5] = 1},
                answer = "It is a depressing story. Are you sure you want to hear it?",
            },
            [52] = {
                question = "Yes, I want to hear your story.",
                allSV = {[SV.tanner5] = 1, [SV.tanner6] = -1},
                setSV = {[SV.tanner6] = 1},
                answer = {
                    "This used to be a rich and happy town.",
                    "But even in such great and prosperous times, evil lies await.",
                    "One of the Elite's daughter got sick and died.",
                    "Her father couldn't bare losing her so he started studying necromancy in hopes of getting her back.",
                    "We town people didn't look kindly on that, but no one could be bothered to interfere, at least as long as he wasn't harming anybody.",
                    "Later we found out that at some point he had sacrificed his workers and some soldiers for his rituals.",
                    "We raised our voice along with the other Elites, but we were too late.",
                    "He had no humanity left, having performed who knows how many spells and rituals, he wouldn't refrain from using black magic against anyone who opposed him.",
                    "We lived in fear for a time, but fear was all it was, until The Day came.",
                    "Thousands of undead were raised from the ground and marched against the capital. We were no match against something we could not kill.",
                    "Most of us escaped to the southern cities, some went north to the mountains. Just recently, a few of us came back here to start rebuilding the town.",
                },
            },
            [53] = {
                question = "What is the name of this 'Elite'?",
                allSV = {[SV.tanner6] = 1, [SV.tanner7] = -1},
                setSV = {[SV.tanner7] = 1},
                answer = "Dide Freu'el.",
            },
        }
    },
    modalWindows = {
        [MW.tannerRep] = {
            name = "eather_repMW_name",
            title = "Choose bulk of materials to give Eather",
            choices = "eather_repMW_createChoices",
            buttons = {
                [100] = "choose",
                [101] = "close",
                [102] = "rep shop",
            },
            func = "eather_repMW",
        },
        [MW.tannerShop] = {
            name = "eather_shopMW_name",
            title = "Choose item what you want to be crafted",
            choices = "eather_shopMW_createChoices",
            buttons = {
                [100] = "price",
                [101] = "close",
                [102] = "info",
                [103] = "craft",
            },
            func = "eather_shopMW",
        },
    },
}
centralSystem_registerTable(npcConf_eather)

local repItems = {
    [11200] = { -- animal leather
        repSV = SV.animal_leather,
        bulk = 10,
        maxRep = 6,
    },
    [11235] = { -- wolf fur
        repSV = SV.wolf_fur,
        bulk = 5,
        maxRep = 6,
    },
    [11224] = { -- thick fur
        repSV = SV.thick_fur,
        bulk = 8,
        maxRep = 6,
    },
    [5896] = {  -- bear paw
        repSV = SV.bear_paw,
        bulk = 1,
        maxRep = 4,
        reduce = 0.5,
    },
    [5897] = {  -- wolf paw
        repSV = SV.wolf_paw,
        bulk = 1,
        maxRep = 4,
        reduce = 0.5,
    },
    [13159] = { -- rabbit foot
        repSV = SV.rabbit_foot,
        bulk = 1,
        maxRep = 4,
        reduce = 0.5,
    },
}
--[[ tanner rep shop guide
[INT] = {               item ID of item
    repL = INT          what has to be player RepL to cost and show this item
    armor = INT         extra INT amount of armor stat on item
    speed = INT         extra INT amount of speed stat on item
    energyRes = INT     extra INT amount of energy resistance % on item
    fireRes = INT       extra INT amount of energy resistance % on item
    iceRes = INT        extra INT amount of energy resistance % on item
    earthRes = INT      extra INT amount of energy resistance % on item
    deathRes = INT      extra INT amount of energy resistance % on item
    physicalRes = INT   extra INT amount of energy resistance % on item
                        ALL DEFAULT VALUES ABOVE ARE = 0
    
    cost = {
        [itemID] = INT  itemID = the item id what is required and INT = count
    }
}
]]
-- 11200 - animal leather
-- 11235 - wolf fur
-- 11224 - thick fur
-- 5896 - bear paw
-- 5897 - wolf paw
-- 13159 - rabbit foot

eather_shopConf = {
    [2643] = { -- leather boots
        armor = 1,
        speed = 6,
        energyRes = 1,
        cost = {
            {itemID = 11200, count = 10},
            {itemID = 13159, count = 3},
        },
    },
    [2461] = { -- leather helmet
        armor = 2,
        speed = 2,
        energyRes = 2,
        cost = {
            {itemID = 11200, count = 14},
            {itemID = 5897},
        },
    },
    [2649] = { -- leather legs
        armor = 3,
        speed = 4,
        energyRes = 4,
        cost = {
            {itemID = 11200, count = 16},
            {itemID = 5897, count = 2},
        },
    },
    [2467] = { -- leather armor
        armor = 4,
        speed = 2,
        energyRes = 4,
        cost = {
            {itemID = 11200, count = 20},
            {itemID = 5897, count = 2},
        },
    },
    
    [7458] = { -- fur cap
        repL = 1,
        armor = 2,
        iceRes = 2,
        fireRes = -2,
        cost = {
            {itemID = 11200, count = 6},
            {itemID = 11235, count = 6},
            {itemID = 5897},
        },
    },
    [7464] = { -- fur shorts
        repL = 1,
        armor = 3,
        iceRes = 3,
        fireRes = -3,
        cost = {
            {itemID = 11200, count = 8},
            {itemID = 11224, count = 8},
            {itemID = 5896, count = 2},
        },
    },
    [7463] = { -- fur coat
        repL = 1,
        armor = 4,
        iceRes = 4,
        fireRes = -4,
        cost = {
            {itemID = 11200, count = 20},
            {itemID = 11224, count = 10},
            {itemID = 5896, count = 2},
        },
    },
}

local maxRepL = 0
for k, v in pairs(eather_shopConf) do
    if not v.repL then v.repL = 0 end
    if not v.cost then v.cost = {} end
    if v.repL > maxRepL then maxRepL = v.repL end
end
eather_shopConf.maxRepLevel = maxRepL

-- rep functions
function eather_repMW_name(player) return "Eather Repution ["..player:getRep("eather").." / 100]" end
function eather_repMW_create(player) return player:createMW(MW.tannerRep) end

function eather_repMW_createChoices(player)
local choiceT = {}
local choiceID = 0
    
    local function addChoice(itemID, repT)
        local reputation = calculateItemRep(player, repT)
        local itemName = ItemType(itemID):getName()
        
        choiceID = choiceID + 1
        if reputation > 0 then choiceT[choiceID] = itemName.." gives "..reputation.." reputation" return end
        choiceT[choiceID + 100] = "Eather does not need any more "..itemName
    end
    
    for itemID, repT in pairs(repItems) do addChoice(itemID, repT) end
    return choiceT
end

function eather_repMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return player:createMW(MW.tannerShop) end
    if choiceID > 100 then return eather_repMW_create(player) end
local loopID = 0
    
    for itemID, t in pairs(repItems) do
        loopID = loopID + 1
        if choiceID == loopID then
            if player:removeItem(itemID, t.bulk) then
                local reputation = calculateItemRep(player, t)
                
                addSV(player, t.repSV, 1)
                addRep(player, reputation, "eather")
            else
                player:sendTextMessage(GREEN, "You don't have "..t.bulk.." "..ItemType(itemID):getName().." in your bag")
            end
            return eather_repMW_create(player)
        end
    end
end

-- shop functions
function eather_shopMW_name(player) return "Eather Repution ["..player:getRepL("eather").." / "..eather_shopConf.maxRepLevel.."]" end

local function canAddChoice(playerRepL, ID, t)
    if type(ID) == "number" and playerRepL >= t.repL then return true end
end

function eather_shopMW_createChoices(player)
local playerRepLevel = player:getRepL("eather")
local choiceT = {}
local choiceID = 0

    for itemID, shopT in pairs(eather_shopConf) do
        if canAddChoice(playerRepLevel, itemID, shopT) then
            choiceID = choiceID + 1
            choiceT[choiceID] = ItemType(itemID):getName()
        end
    end
    return choiceT
end

function eather_shopMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local loopID = 0
local playerRepLevel = player:getRepL("eather")
    
    local function itemCost(player, costT)
        if not playerHasItemList(player, costT) then return end
        return removeItemList(player, costT)
    end
    
    for itemID, shopT in pairs(eather_shopConf) do
        if canAddChoice(playerRepLevel, itemID, shopT) then
            loopID = loopID + 1
            if choiceID == loopID then
                if buttonID == 102 then eather_shopMW_itemInfo(player, shopT, itemID) end
                if buttonID == 100 then eather_shopMW_itemRequirements(player, shopT.cost, itemID) end
                if buttonID == 103 then
                    if player:removeItemList(shopT.cost) then
                        local item = player:giveItem(itemID)
                        local bonusStatT = getBonusItemStats(shopT)
                        local itemText = ""
                        
                        for stat, v in pairs(bonusStatT) do
                            if type(v) == "number" and v ~= 0 then itemText = itemText.." "..stat.."("..v..")" end
                        end
                        
                        if itemText then item:setAttribute(TEXT, itemText) end
                    else
                        player:sendTextMessage(BLUE, "You are missing few items")
                    end
                end
                return player:createMW(mwID)
            end
        end
    end
end

function eather_shopMW_itemRequirements(player, itemList, itemID)
local text = ""

    for _, itemT in pairs(itemList) do
        local count = itemT.count or 1
        text = text..count.." "..ItemType(itemT.itemID):getName().."\n"
    end
    player:sendTextMessage(BLUE, ItemType(itemID):getName().." requirements:")
    player:sendTextMessage(ORANGE, text)
end

function getBonusItemStats(t)
local bonusStats = statTable.new()
    
    for stat, v in pairs(bonusStats) do
        if t[stat] and t[stat] ~= 0 then bonusStats[stat] = t[stat] end
    end
    return bonusStats
end

function eather_shopMW_itemInfo(player, shopT, itemID)
local itemStatT = items_getStats(itemID)
local statText = items_parseStatT(itemStatT)

    player:sendTextMessage(ORANGE, statText)
end