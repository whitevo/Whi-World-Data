function gems2_startUp()
    for gemID, gemT in pairs(gems2Conf.gems) do
        if not gemT.upgradeEffect then gemT.upgradeEffect = 3 end
        gemT.gemID = gemID
    end
end

function gems2_onMove(player, item, itemEx, fromPos, toPos, fromObject, toObject)
    if testServer() then
        player:sendTextMessage(BLUE, "you can only upgrade equipped items")
        toObject = player
    end
    
    if not toObject then return end

    if toObject:isPlayer() then
        local itemEx = player:getSlotItem(toPos.y)
        if not itemEx then return true end
        gems2_tryUpgrade(player, item, itemEx)
        return true
    end

    if toObject:isTile() then
        local itemEx = checkForItemEx(itemEx, toPos)
        if not getItemType(itemEx) then return end
        gems2_tryUpgrade(player, item, itemEx)
        return true
    end
end

function gems2_tryUpgrade(player, gem, item)
    local gemT = gems2_getGemT(gem)
    if not gemT then return print("ERROR in gems2_tryUpgrade - gem is not part of gemT gems2Conf["..itemID.."]") end

    if item:isProjectile() then return player:sendTextMessage(GREEN, "Can't upgrade projectiles.") end
    if item:getCount() > 1 then return player:sendTextMessage(GREEN, "Can't upgrade stacked items.") end
    if not getItemType(item) then return player:sendTextMessage(GREEN, "This item can't be upgraded") end
    
    local itemGemT = gems2_getGemT(item)
    if itemGemT then return player:sendTextMessage(GREEN, "This item is already upgraded with "..itemGemT.name) end
    return gems2_upgrade(player, gem, item, gemT)
end

function gems2_upgrade(player, gem, item, gemT)
    if not gemT then gemT = gems2_getGemT(gem) end
    item:setText("gems2", gemT.gemID)
    player:say("**upgraded item**", ORANGE)
    doSendMagicEffect(getParentPos(item), gemT.upgradeEffect)
    if gemT.maxHP or gemT.maxMP then gems2_updateConditions(player) end
    return gem:remove(1)
end

local function modText(text, gemName, value, itemWeight)
    text = text:gsub("GEM_NAME", gemName)
    text = text:gsub("VALUE", value)
    if itemWeight then text = text:gsub("ITEM_WEIGHT", itemWeight/100) end
    for formula in text:gmatch("%b()") do text = text:gsub("%b()", calculate(false, formula, 2)) end
    return text
end

function gems2_gem_onLook(player, item)
    if not item:isGem() then return end
    local text = gems2_getLookText(item, "gemLook")
    return player:sendTextMessage(GREEN, text)
end

function gems2_item_onLook(player, item)
    local gemT = gems2_getGemT(item)
    if not gemT then return "" end
    local text = gems2_getLookText(item, "upgradedItem", item:getCustomWeight())
    return text
end

function gems2_removeGem(item, player)
    local gemT = gems2_getGemT(item)
    if not gemT then return end
    
    if player then
        player:say("** removed gem **", ORANGE)
        player:giveItem(gemT.gemID, 1)
    end
    return item:setText("gems2")
end

function gems2_updateConditions(player)
    local maxHP = gems2_getTotalStatValue(player, "maxHP")
    local maxMP = gems2_getTotalStatValue(player, "maxMP")
    
    if maxHP > 0 or maxMP > 0 then return bindCondition(player, "gems2", -1, {maxMP = maxMP, maxHP = maxHP}) end
    removeCondition(player, "gems2") 
end
-- get functions
-- Item.isGem(item)

function gems2_getGemT(object)
    if not object then return end

    if type(object) == "userdata" then
        if not object:isItem() then return end
        local gemID = object:getText("gems2") or object:getId()
        return gems2_getGemT(tonumber(gemID))
    elseif type(object) == "number" then
        return gems2Conf.gems[object]
    elseif type(object) == "string" then
        for gemID, gemT in pairs(gems2Conf.gems) do
            if object == gemT.name then return gemT end
        end
    end
end

function gems2_getLookText(object, lookType, itemWeight)
    local gemT = gems2_getGemT(object)
    local text = ""

    local function addText(buffName, value)
        local buffT = gems2Conf.buffStrings[buffName]
        if not buffT then return end
        local moddedText = modText(buffT[lookType], gemT.name, value, itemWeight)
        if itemWeight then text = text.."\n" end
        text = text..moddedText
    end
    
    for key, v in pairs(gemT) do addText(key, v) end
    return text
end

function gems2_getGems(player, ignoreSlots)
    local gemList = {}
    
    local function getGemID(slot)
        local item = player:getSlotItem(slot)
        if not item then return end
        local gemID = item:getText("gems2")
        if not gemID then return end
        gemList[slot] = gemID
    end
    local allSlots = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET, SLOT_LEFT, SLOT_RIGHT}
    local searchSlots = removeFromTable(allSlots, ignoreSlots)

    for _, slot in pairs(searchSlots) do getGemID(slot) end
    return gemList
end

function gems2_getTotalStatValue(player, stat)
    local gemList = gems2_getGems(player)
    local totalValue = 0

    for slotPos, gemID in pairs(gemList) do
        local gemT = gems2_getGemT(gemID)
        totalValue = totalValue + (gemT[stat] or 0)
    end
    return totalValue
end

function lootSystem_getLootGemChance(player, baseChance)
    return percentage(baseChance, gems2_getLootGemChance(player))
end

function gems2_getLootGemChance(player)
    return gems2_getTotalStatValue(player, "lootBonus")
end

function gems2_getCooldownGemAmount(player)
    local gemList = gems2_getGems(player)
    local cooldown = 0.000

    for slotPos, gemID in pairs(gemList) do
        local gemT = gems2_getGemT(gemID)
        local cdMod = gemT.cooldownReduction
        
        if cdMod then
            local item = player:getSlotItem(slotPos)
            local cap = item:getCustomWeight()/100
            local cdReduction = cap*cdMod/100
            
            cooldown = cooldown + cdReduction
        end
    end
    return -cooldown
end

function gems2_getResistanceGemPercent(item)
    local gemT = gems2_getGemT(item)
    return gemT and gemT.allRes or 0
end
