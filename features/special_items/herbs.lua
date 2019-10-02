function herbs_usePowder(player, item, itemEx, toPos)
    if not itemEx or itemEx:isCreature() then return end
    if brewing_createUnfinishedPotion(player, item, itemEx) then return end
    if brewing_mixPowders(player, item, itemEx) then return end
    if cooking_spiceFood(player, item, itemEx, toPos) then return end
end

function failToCutHerb(player, herb, herbT)
    removeHerb(player, herb, herbT)
    return player:sendTextMessage(GREEN, herbT.failedToPickUpMsg)
end

function herbs_pickUp(player, item)
local itemAID = item:getActionId()
local herbT = herbs[itemAID]

    if not compareSV(player, herbT.allSV, "==") then return end
    if not herbT.respawnSeconds then
        herbs_createHerbPowder(player, herbT, item:getCount())
        return farming_herbRemove(item, herbT)
    end
local lastUsed = item:getText("lastUsed") or 0

    if lastUsed + herbT.respawnSeconds > os.time() then return player:sendTextMessage(GREEN, "Did not find "..herbT.name) end
    if herbT.toolEleType then return failToCutHerb(player, item, herbT) end
    herbs_createHerbPowder(player, herbT)
    return removeHerb(player, item, herbT)
end

function herbs_createHerbPowder(player, herbT, count, dontAutoLoot)
local powder = player:giveItem(herbT.powderColor, count, herbT.powderAID)
    
    herbBag_autoLoot(player, powder, dontAutoLoot)
    return true
end

function removeHerb(player, herb, herbT)
local herbPos = herb:getPosition()
local herbID = herb:getId()

    doSendMagicEffect(herbPos, herbT.effectsOnHerbRemove)
    
    if herbT.growBack then
        if building_getHouseID(herbPos) then
            if not chanceSuccess(farmingConf.herbRespawnChance) then
                doTransform(herbID, herbPos, 10913)
                building_saveHouseTile(herbPos)
                building_registerFloor(Tile(herbPos):getGround():getId(), 0, herbPos)
                return true
            end
        end
        herb:setText("lastUsed", os.time())
    else
        herb:remove()
        if building_getHouseID(herbPos) then
            if not chanceSuccess(farmingConf.herbRespawnChance) then
                building_saveHouseTile(herbPos)
                building_registerFloor(Tile(herbPos):getGround():getId(), 0, herbPos)
                return true
            end
        end
        addEvent(createItem, herbT.respawnSeconds*1000, herbID, herbPos, 1, herbT.herbAID)
    end
    return true
end

function cutHerb(player, herbKnife, herb)
    if not herb or herb:isCreature() then return end
local herbAID = herb:getActionId()
local herbT = herbs[herbAID]
    
    if not herbT then return end
    if not compareSV(player, herbT.allSV, "==") then return true end
local herbName = herbT.name
local requiredEnchant = herbT.toolEleType

    if not requiredEnchant then return player:sendTextMessage(GREEN, herbName.." does not require tool to pick it up") end
local lastUsed = getFromText("lastUsed", herb:getAttribute(TEXT)) or 0
local currentTime = os.time()

    if lastUsed + herbT.respawnSeconds > currentTime then return player:sendTextMessage(GREEN, "Did not find "..herbName) end
local itemText = herbKnife:getAttribute(TEXT)
local charges = getFromText("charges", itemText) or 0
   
    if charges <= 0 then return failToCutHerb(player, herb, herbT) end
    herbKnife:setText("charges", charges-1)
local enchantType = getFromText("enchant", itemText) or ""
    
    if enchantType ~= herbT.toolEleType then return failToCutHerb(player, herb, herbT) end
    herbs_createHerbPowder(player, herbT)
    return removeHerb(player, herb, herbT)
end

function herbs_onLook(player, item)
    if not item:isHerb() then return end
local itemAID = item:getActionId()
local herbT = herbs_getHerbT(itemAID)

    if not compareSV(player, herbT.allSV, "==") then return player:sendTextMessage(GREEN, item:getDescription()) end
local count = item:getCount()
local countSTR = "["..count.."] "
local desc = "Powder: "
local weight = item:getWeight()

    if itemAID == herbT.herbAID then desc = "Herb: " end
    if count == 1 then countSTR = "" end
    desc = desc..countSTR..herbT.name
    
    if getSV(player, SV.extraInfo) == -1 then
        if herbT.learnedSV == 2 then desc = desc.."\n"..herbT.tonkaHerbs end
        desc = desc.."\n"..herbT.location
    end

    if weight and weight > 0 then desc = desc.."\nWeight: "..(weight / 100).." cap" end
    return player:sendTextMessage(GREEN, desc)
end

function herbs_discoverHint(player, item)
    local herbT = herbs_getHerbT(item)
    if not herbT then return end
    if getSV(player, herbT.learnedSV) ~= 0 then return end
    setSV(player, herbT.learnedSV, 1)
    return player:sendTextMessage(GREEN, "you found out: "..herbT.herbHint)
end

function autoLoot_herb(player, item)
    if not item:isContainer(true) then return end
    local slotIndex = 0
    
    for x=0, item:getSize() do
        local item = item:getItem(x-slotIndex)
        if not item then break end
        if herbBag_autoLoot(player, item) then slotIndex = slotIndex + 1 end
    end
end

function tonkaHerbs_notification(player)
    local powderList = tonkaHerbs_getPowders(player)
    local ok = false

    for _, powderAID in ipairs(powderList) do
        local herbT = herbs_getHerbT(powderAID)
        if getSV(player, herbT.learnedSV) == -1 then ok = true break end
    end
    if ok then player:sendTextMessage(BLUE, "Tonka: I smell new herb powders on you, could you show them to me?") end
end

function tonkaHerbs_createChoices(player)
    local choiceT = {}
    local powders = tonkaHerbs_getPowders(player)
    
    for herbAID, herbT in pairs(herbs) do
        local herbStage = getSV(player, herbT.learnedSV)
        local herbName = herbT.name
        
        if herbStage == -2 then
            choiceT[herbT.tonkaID] =  "What do you know about "..herbName.."?"
        elseif herbStage == -1 and isInArray(powders, herbT.powderAID) then
            choiceT[herbT.tonkaID] =  "What do you know about "..herbName.."?"
        elseif herbStage == 0 then
            choiceT[herbT.tonkaID] =  "What I had to do again to find out about "..herbName.."?"
        elseif herbStage == 1 then
            choiceT[herbT.tonkaID + 120] = "I know the information about "..herbName.."!"
        end
    end
    return choiceT
end

function tonkaHerbs_createHerbList(player)
    local t = {}

    for herbAID, herbT in pairs(herbs) do
        if getSV(player, herbT.learnedSV) == 2 then
            t[herbT.tonkaID] = "What do you know about "..herbT.name.."?"
        end
    end
    return t
end

function tonkaHerbs_herbButton(player)
    for herbAID, herbT in pairs(herbs) do
        if getSV(player, herbT.learnedSV) == 2 then return "Herbs" end
    end
end

function tonkaHerbsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return player:createMW(MW.npc_tonkaHerbList) end
    if choiceID == 255 then return end
    
    for herbAID, herbT in pairs(herbs) do
        if choiceID == herbT.tonkaID then
            if herbT.instaAnswer then
                player:sendTextMessage(BLUE, herbT.instaAnswer)
                setSV(player, herbT.learnedSV, 2)
            else
                player:sendTextMessage(BLUE, herbT.hintInfo)
                setSV(player, herbT.learnedSV, 0)
            end
            return player:createMW(mwID)
        elseif choiceID == herbT.tonkaID + 120 then
            player:sendTextMessage(BLUE, "Tonka: "..herbT.tonkaAnswer)
            setSV(player, herbT.learnedSV, 2)
            return player:createMW(mwID)
        end
    end
end

function tonkaHerbListMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.npc_tonkaHerbs) end
    
    for herbAID, herbT in pairs(herbs) do
        if choiceID == herbT.tonkaID then
            player:sendTextMessage(ORANGE, "asking about: "..herbT.name)
            player:sendTextMessage(BLUE, "Tonka: "..herbT.tonkaHerbs)
            return player:createMW(mwID)
        end
    end
end

function tonkaHerbs_npcButton(player, npcName) return player:createMW(MW.npc_tonkaHerbs) end

-- get functions
function herbs_getHerbT(object)
    local itemAID = object
    
    if not itemAID then return end
    
    if type(object) == "string" then
        for herbAID, herbT in pairs(herbs) do
            local herbNameL = herbT.name:lower()
            if herbNameL:match(object:lower()) then return herbT end
        end
        return
    end
    
    if type(object) == "userdata" then itemAID = object:getActionId() end
    
    for herbAID, herbT in pairs(herbs) do
        if herbAID == itemAID or herbT.powderAID == itemAID or herbT.hintItemAID == itemAID or herbT.seedAID == itemAID then return herbT end
    end
end

function tonkaHerbs_getPowders(player)
    local powders = {}
    local bp = player:getBag()

    if not bp then return powders end
    local herbBag = player:getItemById(herbBagConf.itemID, true)
    
    for x=0, bp:getSize()-1 do
        local item = bp:getItem(x)
        if not item then break end
        if item:isHerb() and not isInArray(powders, item:getActionId()) then table.insert(powders, item:getActionId()) end
    end
    
    if herbBag then
        local herbList = herbBag_getHerbList(herbBag)
        
        for herbName, count in pairs(herbList) do
            local herbT = herbs_getHerbT(herbName)
            if not herbT then Vprint(herbName, "herbName") end
            if herbT and not isInArray(powders, herbT.powderAID) then table.insert(powders, herbT.powderAID) end
        end
    end
    return powders
end

function Item.isHerb(item)
    local itemAID = item:getActionId()

    for herbAID, herbT in pairs(herbs) do
        if itemAID == herbAID then return true end
        if itemAID == herbT.powderAID then return true end
    end
end

function Creature.isHerb() return false end
function Tile.isHerb() return false end