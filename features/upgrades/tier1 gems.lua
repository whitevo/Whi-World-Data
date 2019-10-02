function gems_startUp()
    for itemID, t in pairs(gems) do
        if not t.armorMax then gems.armorMax = 1 end
        if not t.weaponMax then gems.weaponMax = 1 end
        if t.ME_effect and type(t.ME_effect) ~= "table" then gems.ME_effect = {t.ME_effect} end
        if not t.ME_effect then gems.ME_effect = {3} end
        t.itemID = itemID
    end
end

function gems_onUse(player, item, itemEx)
    if not itemEx or Creature(itemEx) then return end
    local itemID = item:getId()
    local gemT = gems[itemID]

    if not gemT then return print("gem is not part of gemT gems["..itemID.."]") end
    if itemEx:isProjectile() then return player:sendTextMessage(GREEN, "Can't upgrade projectiles.") end
    if itemEx:getCount() > 1 then return player:sendTextMessage(GREEN, "Can't upgrade stacked items.") end
    if upgradeHerbKnife(player, item, itemEx, gemT) then return true end
    if not gems_tryUpgrade(player, item, itemEx) then return end
    return gems_upgrade(player, item, itemEx, gemT)
end

function gems_upgrade(player, gem, item, gemT)
    local upgradeCount = gems_getCount(item)
    local maxStack = gemT[getItemType(item).."Max"] or 1
    local count = gem:getCount()
    local finalAmount = count + upgradeCount
    
    if finalAmount > maxStack then
        count = count - (finalAmount - maxStack)
        finalAmount = maxStack
    end
    
    local upgradeType = gems_getUpgradeType(item)
    local itemName = item:getName()
    if upgradeCount == 0 then
        player:sendTextMessage(ORANGE, itemName.." has new attribute: "..gemT.eleType.." "..upgradeType)
    else
        player:sendTextMessage(ORANGE, itemName.." has new "..gemT.eleType.." "..upgradeType.." value: "..finalAmount)
    end
    
    player:say("**upgraded item**", ORANGE)
    doSendMagicEffect(getParentPos(item), gemT.ME_effect)
    item:setText("gems1", gemT.itemID)
    item:setText("gems1_count", finalAmount)
    gem:remove(count)
end

function upgradeHerbKnife(player, gem, knife, gemT)
    if not isInArray(toolsConf.herbknives, knife:getId()) then return end
    local eleType = gemT.eleType
    local enchant = knife:getText("enchant") or ""
    
    if enchant ~= eleType then
        knife:setText("enchant", eleType)
        tools_setCharges(player, knife, 1)
    else
        local previousCharges = tools_getCharges(knife)
        knife:setText("charges", previousCharges + 1)
    end
    
    player:say("**upgraded item**", ORANGE)
    doSendMagicEffect(getParentPos(knife), gemT.ME_effect)
    return gem:remove(1)
end

function gems_tryUpgrade(player, gem, item)
    if not item then return end
    local equipmentType = getItemType(item)
    if not equipmentType then return end

    local gemT = gems_getGemT(item)
    if not gemT then return true end
    local gemT2 = gems_getGemT(gem)
    if gemT.eleType ~= gemT2.eleType then return false, player:sendTextMessage(GREEN, "Each item can only be upgraded with 1 type of tier 1 gem.") end
    
    local gemCount = gems_getCount(item)
    local maxUpgradeAmount = gemT[equipmentType.."Max"] or 1
    if gemCount >= maxUpgradeAmount then return false, player:sendTextMessage(GREEN, "Item has been upgraded to maximum value with gems.") end
    return true
end

function gems_removeGem(item, amount, player)
    local gemT = gems_getGemT(item)
    if not gemT then return end
    local gemCount = gems_getCount(item)
    local amount = amount or 1
    local newValue = gemCount - amount
    if newValue < 1 then newValue = nil end

    if player then
        player:say("** removed gem **", ORANGE)
        player:giveItem(gemT.itemID, gemCount)
    end
    
    item:setText("gems1", newValue)
    item:setText("gems1_count", newValue)
    return true
end

function gems_item_onLook(player, item)
    local gemT = gems_getGemT(item)
    if not gemT then return "" end
    local desc = "\n["..gemT.eleType.." gem] "

    if item:isShield() then
        if gemT.eleType == "energy" then
            if energyGem(player, 100) == 0 then return desc..gemT.failText end
        end

        if gemT.eleType == "fire" then
            local weapon = player:getSlotItem(SLOT_LEFT)
            if weapon and not gems_getGemT(weapon) then return desc..gemT.failText end
        end
        return desc..gems_stringMod(player, gemT.shieldEffect, gemT.eleType)
    else
        local extraStr = ""
        local upgradeCount = gems_getCount(item)

        if item:isWeapon() then
            local extra = fireGem(player, gemT.eleType)
            if extra > 0 then extraStr = "+"..extra.."%" end
        elseif item:isArmor() then
            local extra = physicalGem(player, gemT.eleType, upgradeCount)
            if extra > 0 then extraStr = "+"..extra.."%" end
        end
        
        local upgradeType = gems_getUpgradeType(item)
        return desc..gemT.eleType.." "..upgradeType.." increased by "..upgradeCount.."% "..extraStr
    end
end

function gems_stringMod(player, text, eleType)
    local function randomAllowedType(ignoreSlots)
        local itemSlotPos = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET, SLOT_LEFT, SLOT_RIGHT}
        local allowedTypes = {}
        itemSlotPos = removeFromTable(itemSlotPos, ignoreSlots)
        
        local function insertEleType(slot)
            local item = player:getSlotItem(slot)
            if not item then return end
            local gemT = gems_getGemT(item)
            if not gemT then return end
            if isInArray(allowedTypes, gemT.eleType) then return end
            table.insert(allowedTypes, gemT.eleType)
        end

        for _, slot in pairs(itemSlotPos) do insertEleType(slot) end
        return tableCount(allowedTypes) == 0 and "fire" or randomValueFromTable(allowedTypes)
    end
    
    if text:match("randomtype2") then 
        text = text:gsub("randomtype2", randomAllowedType())
    elseif text:match("randomtype1") then
        text = text:gsub("randomtype1", randomAllowedType(SLOT_RIGHT))
    elseif text:match("randomtype")  then
        text = text:gsub("randomtype", randomAllowedType({SLOT_LEFT, SLOT_RIGHT}))
    end

    local function changeCountText(str, eleType, ignoreSlots)
        if text:match(str) then text = text:gsub(str, gems_getTotalCount(player, eleType, ignoreSlots)) return true end
    end
    local function changeSlotText(str, eleType, ignoreSlots)
        if text:match(str) then text = text:gsub(str, gems_getTotalSlotCount(player, eleType, ignoreSlots)) return true end
    end

    changeCountText("type_total_value3", eleType)
    changeCountText("type_total_value2", eleType, SLOT_LEFT)
    changeCountText("type_total_value1", eleType, SLOT_RIGHT)
    changeCountText("type_total_value", eleType, {SLOT_LEFT, SLOT_RIGHT})    
    changeSlotText("type_total_count2", eleType)
    changeSlotText("type_total_count1", eleType, SLOT_RIGHT)
    changeSlotText("type_total_count", eleType, {SLOT_LEFT, SLOT_RIGHT})
    
    local eleTypes = {"fire", "energy", "death", "ice", "physical", "earth"}
    for _, eleType in pairs(eleTypes) do
        if changeCountText(eleType.."_total_value3", eleType) then
        elseif changeCountText(eleType.."_total_value2", eleType, SLOT_LEFT) then
        elseif changeCountText(eleType.."_total_value1", eleType, SLOT_RIGHT) then
        elseif changeCountText(eleType.."_total_value", eleType, {SLOT_LEFT, SLOT_RIGHT}) then
        elseif changeSlotText(eleType.."_total_count2", eleType) then
        elseif changeSlotText(eleType.."_total_count1", eleType, SLOT_RIGHT) then
        elseif changeSlotText(eleType.."_total_count", eleType, {SLOT_LEFT, SLOT_RIGHT}) then
        end
    end
    
    if text:match("type") then text = text:gsub("type", eleType) end
    for formula in text:gmatch("%b()") do text = text:gsub("%b()", calculate(player, formula), 1) end
    return text
end

-- shield gems
function earthGem(player, healAmount)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return 0 end
    if gemT.eleType ~= "earth" then return 0 end

    local value = gems_getTotalCount(player, "earth")
    return percentage(healAmount, value*2)
end
    
function physicalGem(player, eleType, res)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return 0 end
    if gemT.eleType ~= "physical" then return 0 end

    local gemCount = gems_getTotalSlotCount(player, eleType)
    return percentage(res, 20*gemCount)
end

function fireGem(player, eleType)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return 0 end
    if gemT.eleType ~= "fire" then return 0 end
    
    local res = gems_getTotalCount(player, eleType, SLOT_LEFT)
    local count = gems_getTotalSlotCount(player, eleType)
    return math.floor(res/3*count)
end

function energyGem(player, damage)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return 0 end
    if gemT.eleType ~= "energy" then return 0 end

    local ignoreSlots = SLOT_RIGHT
    local gemList = gems_getGems(player, ignoreSlots)
    local differentGemCount = 0
    local total = 0
    local eleTypes = {"fire", "ice", "earth", "death", "energy"}

    local function addGem(slot, gems2)
        local item = player:getSlotItem(slot)
        local gemT

        if gems2 then
            gemT = gems2_getGemT(item)
            total = total + 1
        else
            gemT = gems_getGemT(item)
            total = total + gems_getCount(item)
        end

        if not isInArray(eleTypes, gemT.eleType) then return end
        eleTypes = removeFromTable(eleTypes, gemT.eleType)
        differentGemCount = differentGemCount + 1
    end

    for slot, gemID in pairs(gemList) do addGem(slot) end

    local gemList = gems2_getGems(player, ignoreSlots)
    for slot, gemID in pairs(gemList) do addGem(slot, true) end

    return differentGemCount >= 5 and percentage(damage, total) or 0
end

function deathGem(player)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return end
    if gemT.eleType ~= "death" then return end
    
    local chance = gems_getTotalCount(player, "earth") * 10
    if not chanceSuccess(chance) then return end

    local physicalRes = gems_getTotalCount(player, "physical")
    local executeAmount = math.floor(physicalRes/2)
    if executeAmount < 1 then return end

    local fireRes = gems_getTotalCount(player, "fire")
    local iceRes = gems_getTotalCount(player, "ice")
    local spectralDamage = math.floor((fireRes+iceRes)*30/5)
    if spectralDamage < 1 then return end

    local damTypes = {FIRE, ICE, ENERGY, EARTH, DEATH}
    local area = getAreaPos(player:getPosition(), areas["5x5_0"])
    local randomPosT = randomPos(area, executeAmount)

    for _, pos in pairs(randomPosT) do
        for _, type in pairs(damTypes) do dealDamagePos(0, pos, type, spectralDamage, 49, O_player_proc, math.random(29, 31)) end
    end
end

function iceGem(player)
    local gemT = gems_getGemT(player:getSlotItem(5))
    if not gemT then return end
    if gemT.eleType ~= "ice" then return end
    
    local summonT = {}
    local types = {
        fire = "fire elemental",
        ice = "ice elemental",
        energy = "energy elemental",
        earth = "earth elemental",
        death = "death elemental",
    }
    for eleType, eleName in pairs(types) do
        local resistance = gems_getTotalCount(player, eleType)
        if resistance > 0 then summonT[eleType] = resistance*2 end
    end
    
    if tableCount(summonT) == 0 then return end
    local random_eleType = randomKeyFromTable(summonT)
    local summonChance = summonT[random_eleType]
    if not chanceSuccess(summonChance) then return end
    
    local positions = getAreaAround(player:getPosition())
    local position = randomPos(positions, 1)[1]
    local elemental = createMonster(types[random_eleType], position) 
    if not elemental then return end
    elemental:setMaster(player)
    addEvent(removeCreature, 10000, elemental:getId())
end

-- get functions
function gems_getCount(item) return item:getText("gems1_count") or 0 end

function gems_getGemT(object)
    if not object then return end

    if type(object) == "userdata" then
        if not object:isItem() then return end
        local gemID = object:getText("gems1") or object:getId()
        return gems_getGemT(tonumber(gemID))
    elseif type(object) == "number" then
        return gems[object]
    elseif type(object) == "string" then
        for gemID, gemT in pairs(gems) do
            if gemT.eleType:lower() == object:lower() then return gemT end
        end
    end
end

function gems_getGems(player, ignoreSlots)
    local gemList = {}
    
    local function getGemID(slot)
        local item = player:getSlotItem(slot)
        if not item then return end
        local gemID = item:getText("gems1")
        if not gemID then return end
        gemList[slot] = gemID
    end
    local allSlots = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET, SLOT_LEFT, SLOT_RIGHT}
    local searchSlots = removeFromTable(allSlots, ignoreSlots)

    for _, slot in pairs(searchSlots) do getGemID(slot) end
    return gemList
end

function gems_getTotalCount(player, eleType, ignoreSlots)
    local gemList = gems_getGems(player, ignoreSlots)
    local totalValue = 0

    for slotPos, gemID in pairs(gemList) do
        local gemT = gems_getGemT(gemID)

        if gemT.eleType == eleType then
            local item = player:getSlotItem(slotPos)
            totalValue = totalValue + gems_getCount(item)
        end
    end
    
    local gemList2 = gems2_getGems(player, ignoreSlots)
    for slotPos, gemID in pairs(gemList2) do
        local gemT = gems2_getGemT(gemID)
        if gemT.eleType == eleType then totalValue = totalValue + 1 end
    end
    return totalValue
end

function gems_getTotalSlotCount(player, eleType, ignoreSlots)
    if ignoreSlots and type(ignoreSlots) ~= "table" then ignoreSlots = {ignoreSlots} end
    local gemList = gems_getGems(player, ignoreSlots)
    local totalCount = 0
    local foundSlots = ignoreSlots or {}

    for slotPos, gemID in pairs(gemList) do
        local gemT = gems_getGemT(gemID)
        if gemT.eleType == eleType then
            totalCount = totalCount + 1
            table.insert(foundSlots, slotPos)
        end
    end

    local gemList = gems2_getGems(player, foundSlots)
    for slotPos, gemID in pairs(gemList) do
        local gemT = gems2_getGemT(gemID)
        if gemT.eleType == eleType then totalCount = totalCount + 1 end
    end
    return totalCount
end

function gems_getUpgradeType(item)
    if item:isArmor() then return "resistance" end
    if item:isWeapon() then return "spell damage" end
    if item:isShield() then return "special effect" end
    Vprint(item:getName(), "ERROR in gems_getUpgradeType")
    return "UNKNOWN_UPGRADE_TYPE"
end

function gems_getGemIDT()
    local gemT = {}
    for gemID, t in pairs(gems) do table.insert(gemT, gemID) end
    return gemT
end

function Item.isGem(item)
    local itemID = item:getId()
    return gems_getGemT(itemID) or gems2_getGemT(itemID)
end

function Tile.isGem() return false end
function Creature.isGem() return false end

function Item.hasGem(item)
    if not item then return end
    return gems_getGemT(item) or gems2_getGemT(item)
end

function gems_getResistance(player, eleType)
    local itemSlotPos = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET}
    local percent = 0

    local function addPercent(slot)
        local item = player:getSlotItem(slot)
        if not item then return end
        local gemT = gems_getGemT(item)
        if not gemT or gemT.eleType ~= eleType then return end
        local upgradeCount = gems_getCount(item)
        percent = percent + upgradeCount + physicalGem(player, eleType, upgradeCount)
    end

    for _, slot in pairs(itemSlotPos) do addPercent(slot) end
    return percent
end