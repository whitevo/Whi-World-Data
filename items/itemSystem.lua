function items_startUp()
    for _, statT in pairs(itemsConf_itemStatT) do
        if not statT.extraInfo then statT.extraInfo = "" end
        if not statT.randomStat then statT.randomStat = 0 end
    end
    
    for setName, setT in pairs(setItemTable) do
        setT.name = setName
    end
    
    local function registerOnUse(itemT)
        if not itemT.onUseFunc then return end
        if not itemT.itemAID then return print("ERROR in items_startUp() - missing itemAID for onUseFunc for itemID: "..itemT.itemID) end
        central_register_actionEvent({[itemT.itemAID] = {funcStr = itemT.onUseFunc}}, "AIDItems")
    end

    local function registerStepIn(itemT)
        if not itemT.stepInFunc then return end
        central_register_actionEvent({[itemT.itemID] = {funcStr = itemT.stepInFunc}}, IDTiles_stepIn)
    end

    local function registerActionEvents(itemT)
        registerOnUse(itemT)
        registerStepIn(itemT)
    end
    
    for slot, slotT in pairs(itemTable) do
        for itemID, itemT in pairs(slotT) do
            local itemType = ItemType(itemID)
            
            if not itemT.slot then itemT.slot = slot end
            if itemType:getWeight() ~= itemT.weight then print("ERROR - weight does not match for itemID["..itemID.."]") end
            if not itemT.requiredTokens then itemT.requiredTokens = 2 end
            itemT.itemID = itemID
            registerActionEvents(itemT)
            
            if slot == "weapon" or slot == "arrows" then
                if not itemT.isWand then itemT.isWand = itemT.damType == "spectrum" end
                if testServer() and not itemT.me then itemT.me = 1 end
                if not itemT.damType then itemT.damType = PHYSICAL end
                if not itemT.range and slot == "weapon" then
                    itemT.range = itemT.isWand and 3 or itemT.breakchance and 4 or 1
                end
                if itemT.range and itemT.range > 1 or slot == "arrows" and not itemT.fe then itemT.fe = 1 end
            end

            if itemT.spellBuffs then
                for buffName, buffT in pairs(itemT.spellBuffs) do spellBuffs[buffName] = buffT end
            end
        end
    end

    generateAllItemTables()
    print("items_startUp()")
end

local lookTwice = {}
function items_onLook(player, item)
    local itemT = items_getStats(item)
    if not itemT then return print("ERROR - no itemStatT for itemID["..item:getId().."]") end
    local itemStatT = item:getStats()
    local itemName = itemT.name or item:getName()
    local itemCount = item:getCount()
    local desc = itemCount > 1 and plural(itemName, itemCount) or itemName
    local extraInfo = getSV(player, SV.extraInfo) == -1
    local setStatT = player:getSetStatT(item)
    local weightStr = "\nWeight: "..math.floor(item:getCustomWeight()/100) or ""
    local playerID = player:getId()
    local itemID = item:getId()
    local fullInfo = not itemT.noFullInfo and lookTwice[playerID] and lookTwice[playerID] == itemID

    lookTwice[player:getId()] = itemID
    
    if itemStatT.minDam and itemStatT.weaponSpeed then
        if not itemStatT.weaponSpeed then print("missing weaponSpeed on "..item:getName()) end -- stat check should be done on startUp
        local maxDam = itemStatT.maxDam or itemStatT.minDam
        local dps = math.floor((itemStatT.minDam + maxDam) / 2 / (itemStatT.weaponSpeed/1000))
        desc = desc.."\nDamage/sec: "..dps
        if extraInfo then desc = desc.." (weapon damage per second)" end
    end
    
    desc = desc..items_getStatInfo("minDam", itemStatT, extraInfo, fullInfo)
    desc = desc..items_getStatInfo("maxDam", itemStatT, extraInfo, fullInfo)
    desc = desc..items_getStatInfo("armor", itemStatT, extraInfo, fullInfo)
    desc = desc..items_getStatInfo("def", itemStatT, extraInfo, fullInfo)
    desc = desc..items_getStatDescInfo(itemT, player, item, fullInfo)
    desc = desc..gems_item_onLook(player, item)
    desc = desc..gems2_item_onLook(player, item)
    desc = desc..stones_item_onLook(player, item)
    desc = desc..items_getOtherStatInfo(itemStatT, extraInfo, fullInfo)
    desc = desc..items_getStatInfo("breakchance", itemStatT, extraInfo, fullInfo)
    desc = desc..weightStr
    
    if not setStatT then return desc end
    desc = desc.."\n\n>> "..setStatT.name.." <<"
    desc = desc..items_getStatInfo("minDam", itemStatT)
    desc = desc..items_getStatInfo("maxDam", itemStatT)
    desc = desc..items_getStatInfo("armor", setStatT)
    desc = desc..items_getStatInfo("def", setStatT)
    desc = desc..items_getStatDescInfo(setStatT, player, item)
    desc = desc..items_getOtherStatInfo(setStatT)
    return desc
end

function items_parseStatT(itemStatT)
    local text = ""
    text = text..items_getStatInfo("minDam", itemStatT)
    text = text..items_getStatInfo("maxDam", itemStatT)
    text = text..items_getStatInfo("armor", itemStatT)
    text = text..items_getStatInfo("def", itemStatT)
    text = text..items_getStatDescInfo(itemStatT)
    text = text..items_getOtherStatInfo(itemStatT)
    if itemStatT.weight then text = text.."\nWeight: "..itemStatT.weight/100 end
    return text
end

function items_randomiseStats(item)
    if not item then return end
    local itemStatT = items_getStats(item)
    if not itemStatT then return end
    
    for stat, value in pairs(itemStatT) do
        if itemsConf_itemStatT[stat] then item:setBonusStat(stat) end
    end
end


function Item.setBonusStat(item, stat, amount)
    amount = amount or items_getDefaultRandomStatAmount(stat)
    if amount == 0 then return item:setText(stat) end
    item:setText(stat, amount)
end

function items_mergeStatT(itemStatT, itemStatT2)
    if not itemStatT then return print("ERROR - missing itemStatT in items_mergeStatT()") end
    local newStatT = deepCopy(itemStatT)
    local singleValues = {"setDSV", "damType", "room", "itemID"} -- can only be 1 value | gives error if 2 different merged
    local tableValues = {"desc", "equipFunc", "deEquipFunc"}

    if not itemStatT2 then return newStatT end

    for stat, value in pairs(itemStatT2) do
        if itemsConf_itemStatT[stat] then
            local statValue = newStatT[stat] or 0
            newStatT[stat] = statValue + value
        elseif stat == "setSV" then
            if not newStatT.setSV then
                newStatT.setSV = value
            else
                for sv, v in pairs(value) do
                    if newStatT.setSV[sv] then print("ERROR - itemT already has that storage value") end
                    newStatT.setSV[sv] = v
                end
            end
        elseif isInArray(tableValues, stat) then
            if not newStatT[stat] then newStatT[stat] = {} end
            if type(value) ~= "table" then
                value = {value}
                itemStatT2[stat] = {value} -- should be done in startup
            end
            for _, funcStr in ipairs(value) do table.insert(newStatT[stat], funcStr) end
        elseif isInArray(singleValues, stat) then
            if newStatT[stat] then print("ERROR - itemT already has: "..stat) end
            newStatT[stat] = value
        end
    end
    return newStatT
end

function items_equipItem(player, itemT, setT)
    gems2_updateConditions(player)
    bindConditionTable(player, items_createConditionT(itemT))
    setSV(player, itemT.setSV)
    activateFunctionStr(itemT.equipFunc, player)
    items_equipSetItem(player, setT)
end

function items_deEquipItem(player, itemT, setT)
    gems2_updateConditions(player)
    activateFunctionStr(itemT.deEquipFunc, player)
    removeSV(player, itemT.setSV)
    removeCondition(player, items_createConditionT(itemT))
    items_deEquipSetItem(player, setT)
end

function items_setDSV(player, item, dSVT)
    if not dSVT then return end
    
    for sv, modT in pairs(dSVT) do
        local value = items_getItemSV(item, sv, modT)
        player:setSV(tonumber(sv), value)
    end
end

function items_removeDSV(player, item, dSVT)
    if not dSVT then return end
    for sv, modT in pairs(dSVT) do player:removeSV(tonumber(sv)) end
end

function items_equipSetItem(player, setT)
    if not setT then return end
    local itemIDT = items_getEquippedSetPieceT(player, setT.name)
    local setPieceCount = tableCount(itemIDT)
    items_activateSetEffects(player, setT.name, setPieceCount)
end

function items_deEquipSetItem(player, setT)
    if not setT then return end
    local itemIDT = items_getEquippedSetPieceT(player, setT.name)
    local setPieceCount = tableCount(itemIDT) - 1

    items_activateSetEffects(player, setT.name, setPieceCount)
end

function items_activateSetEffects(player, setName, setPieceCount)
    local setT = items_getSetItemT(setName)
    local speed = 0

    for requiredCount, t in pairs(setT.stats) do
        if setPieceCount >= requiredCount then
            if t.speed then speed = speed + t.speed end
            if t.setSV then setSV(player, t.setSV) end
        elseif t.setSV then
            removeSV(player, t.setSV)
        end
    end
    
    if speed > 0 then
        bindCondition(player, setName, -1, {speed = speed})
    else
        removeCondition(player, setName)
    end
    
    if setPieceCount < 1 then return player:removeSV(setT.sv) end
    player:setSV(setT.sv, setPieceCount)
end

function createSetStatT(setName, setPieceCount)
    local setT = items_getSetItemT(setName)
    local itemStatT = {name = setName}

    for piecesRequired, itemT in pairs(setT.stats) do
        if setPieceCount >= piecesRequired then itemStatT = items_mergeStatT(itemStatT, itemT) end
    end
    return itemStatT
end

local skillParams = {"sL", "wL", "dL", "sLf", "mL"}
function items_createConditionT(itemT)
    local slotSTR = itemT.slot
    local conditionT = {}
    local skillConditions = {}

    for stat, v in pairs(itemT) do
        if isInArray(skillParams, stat) then
            skillConditions[stat] = v
        elseif stat == "speed" then
            table.insert(conditionT, {slotSTR.."Haste", -1, {speed = v}})
        end
    end
    
    if tableCount(skillConditions) > 0 then table.insert(conditionT, {slotSTR, -1, skillConditions}) end
    if tableCount(conditionT) > 0 then return conditionT end
end

-- get functions
function items_getDefaultRandomStatAmount(stat)
    local statT = itemsConf_itemStatT[stat]
    local statAmount = statT and statT.randomStat
        
    if not statAmount or statAmount == 0 then return 0 end
    statAmount = math.random(-statAmount, statAmount)
    if stat == "armor" and statAmount < 0 then return 0 end
    if stat == "def" and statAmount < 0 then return 0 end
    return statAmount
end

function items_getSetItemT(setName) return setItemTable[setName] end

function Item.getSetItemT(item)
    local itemID = item:getId()

    for setName, setT in pairs(setItemTable) do
        if isInArray(setT.setItems, itemID) then return setT end
    end
end

function Player.getSetStatT(player, item)
    local setT = item:getSetItemT()
    if not setT then return end
    local itemIDT = items_getEquippedSetPieceT(player, setT.name)
    local setPieceCount = tableCount(itemIDT)
    local itemID = item:getId()

    if not itemIDT[itemID] then
        local slotPos = getSlotStr(itemID)
        local addsPieceCount = true
        
        for itemID, slotStrPos in pairs(itemIDT) do
            if slotPos == slotStrPos then addsPieceCount = false break end
        end
        if addsPieceCount then setPieceCount = setPieceCount + 1 end
    end
    
    if setPieceCount == 1 then return {name = setT.name} end
    return createSetStatT(setT.name, setPieceCount)
end

function items_getEquippedSetPieceT(player, setName)
    local setT = items_getSetItemT(setName)
    local itemIDT = {}

    for _, itemID in ipairs(setT.setItems) do
        if player:getItemById(itemID) then itemIDT[itemID] = getSlotStr(itemID) end
    end
    return itemIDT
end

function items_getStatInfo(attribute, itemStatT, extraInfo, fullInfo, dontUseN)
    local stat = itemStatT[attribute]
    if not stat then return "" end
    if not fullInfo and stat == 0 then return "" end

    local statT = itemsConf_itemStatT[attribute]
    if not statT then return "" end
    
    local bestValue = ""
    if fullInfo then
        local itemT = items_getStats(itemStatT.itemID)

        if itemT[attribute] and statT.randomStat > 0 then
            bestValue = "["..itemT[attribute] + statT.randomStat.."]"
        elseif stat == 0 then
            return ""
        end
    end
    
    local percentSymbol = statT.percent and "%" or ""
    local positiveSymbol = stat > 0 and "+" or ""
    local nStr = dontUseN and "" or "\n"
    local desc = nStr..statT.fullName..": "..positiveSymbol..stat..bestValue..percentSymbol
    if extraInfo then desc = desc..statT.extraInfo end
    return desc
end

function items_getOtherStatInfo(itemStatT, extraInfo, fullInfo)
    local exludedStats = {"minDam", "maxDam", "name", "weight", "armor", "def", "desc", "equipFunc", "deEquipFunc", "setDSV", "setSV", "spellBuffs", "bindConditions", "set", "breakchance"}
    local desc = ""

    for stat, v in pairs(itemStatT) do
        if not isInArray(exludedStats, stat) then desc = desc..items_getStatInfo(stat, itemStatT, extraInfo, fullInfo) end
    end
    return desc
end

function items_getStatDescInfo(itemT, player, item, fullInfo)
    local desc = ""

    if not itemT.desc then return desc end
    
    for _, text in ipairs(itemT.desc) do
        local displayText = text
        
        if itemT.setDSV then
            for sv, modT in pairs(itemT.setDSV) do
                local key = "SV"..sv

                if text:match(key) then
                    local value = items_getItemSV(item, sv, modT)
                    local formulaStr = displayText:match("%b()")

                    if formulaStr and formulaStr:match(key) then
                        local activeFormula = displayText:gsub(key, value)
                        local maxFormula = displayText:gsub(key, modT.max)
                        displayText = activeFormula
                        
                        for formula in displayText:gmatch("%b()") do
                            local total = calculate(player, formula)
                            
                            if total and fullInfo then
                                local formula = maxFormula:match("%b()")
                                local maxTotal = calculate(player, formula)
                            
                                total = total.."["..maxTotal.."]"
                            end

                            if total then displayText = displayText:gsub("%b()", total, 1) end
                        end
                    elseif fullInfo then
                        value = value.."["..modT.max.."]"
                    end
                    
                    displayText = displayText:gsub(key, value)
                end
            end
        end
        
        desc = desc.."\n"..displayText
    end
    return desc
end

function items_getItemSV(item, sv, modT)
    local bestValue = modT.min < modT.max and modT.max or modT.min
    local worstValue = modT.min < modT.max and modT.min or modT.max
    if not item then return "("..worstValue.."-"..bestValue..")" end
    local key = "SV"..sv
    local value = item:getText(key)
    
    if value then return value end
    value = math.random(worstValue, bestValue)
    item:setText(key, value)
    return value
end

function Item.getStats(item, stat)
    local itemStatsT = items_getStats(item)
    if not itemStatsT then return end
    local bonusStatT = {}

    if not stat then
        local itemText = item:getAttribute(TEXT)
        local keyValueT = itemTextToT(itemText)

        for attribute, value in pairs(keyValueT) do
            if itemsConf_itemStatT[attribute] then bonusStatT[attribute] = value end
        end

        local resT = {"fire", "ice", "death", "holy", "earth", "energy", "physical"}
        for attribute, value in pairs(itemStatsT) do
            if tonumber(value) and value ~= 0 then
                for _, eleType in pairs(resT) do
                    if eleType.."Res" == attribute then
                        bonusStatT[attribute] = (bonusStatT[attribute] or 0) + gems2_getResistanceGemPercent(item)
                    end
                end
            end
        end
    else
        local bonusValue = item:getText(stat) or 0
        if tonumber(itemStatsT[stat]) and itemStatsT[stat] ~= 0 then bonusValue = bonusValue + gems2_getResistanceGemPercent(item) end
        bonusStatT[stat] = bonusValue
    end
    return items_mergeStatT(itemStatsT, bonusStatT)
end

function items_getStats(item)
    local itemID = item
    if type(item) == "userdata" then itemID = item:getId() end
    
    for slot, itemT in pairs(itemTable) do
        if itemT[itemID] then return itemT[itemID] end
    end
end

function Player.getStats(player)
    return {
        def = player:getDefence(),
        barrier = player:getBarrier(),
        armor = player:getArmor(),
        
        energyRes = player:getResistance("energy"),
        iceRes = player:getResistance("ice"),
        fireRes = player:getResistance("fire"),
        earthRes = player:getResistance("earth"),
        deathRes = player:getResistance("death"),
        physicalRes = player:getResistance("physical"),
        holyRes = player:getResistance("holy"),
        waterRes = player:getResistance("water"),
        pvpRes = player:getResistance("pvp"),
        undeadRes = player:getResistance("undead"),
        dragonRes = player:getResistance("dragon"),
        beastRes = player:getResistance("beast"),
        stunRes = player:getStunRes(),
        slowRes = player:getSlowRes(),
        silenceRes = player:getSilenceRes(),
        
        mL = player:getMagicLevel(),
        sL = player:getShieldingLevel(),
        wL = player:getWeaponLevel(),
        dL = player:getDistanceLevel(),
        sLf = player:getHandcombatLevel(),
        ccv = player:getCriticalHit(),
        cH = player:getCriticalHeal(),
        cbv = player:getCriticalBlock(),
        speed = player:getSpeed(),
    }
end

function Item.getStat(item, stat)
    local statT = item:getStats(stat)
    return statT and statT[stat] or 0
end

function Player.getStatFromItems(player, stat)
    local itemSlotPos = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET, SLOT_BACKPACK, SLOT_ARMOR, SLOT_RIGHT, SLOT_LEFT}
    local totalStat = 0
        
    for _, slot in pairs(itemSlotPos) do
        local item = player:getSlotItem(slot)
        if item then totalStat = totalStat + item:getStat(stat) end
    end
    return totalStat
end

function Player.getSetItemsStats(player, stat)
    local totalAmount = 0
        
    for setName, setT in pairs(setItemTable) do
        local equippedItemsCount = getSV(player, setT.sv)
        
        if equippedItemsCount > 1 then
            for requiredItemCount, statT in pairs(setT.stats) do
                if equippedItemsCount >= requiredItemCount and statT[stat] then
                    totalAmount = totalAmount + statT[stat]
                end
            end
        end
    end
    return totalAmount
end

function Item.isEquipment(item) return isEquipmentItem(item:getId()) end

function isEquipmentItem(itemID)
    itemID = type(itemID) == "userdata" and itemID:getId() or itemID
    return items_getStats(itemID) and true
end

function Item.hasMaxStats(item)
    local itemStatT = item:getStats()
    local itemT = items_getStats(item)

    for stat, v in pairs(itemT) do
        local statT = itemsConf_itemStatT[stat]
        if statT and itemStatT[stat] < v + statT.randomStat then return false end
    end
    
    if itemT.setDSV then
        local itemText = item:getAttribute(TEXT)
        
        for sv, modT in pairs(itemT.setDSV) do
            local bonus = getFromText("SV"..sv, itemText) or 0
            if bonus < modT.max then return false end
        end
    end
    return true
end

function generateAllItemTables()
    for slot, itemT in pairs(itemTable) do
        if slot == "weapon" then
            for itemID, t in pairs(itemT) do table.insert(allWeapons, itemID) end
        elseif slot == "boots" then
            for itemID, t in pairs(itemT) do table.insert(allBoots, itemID) end
        elseif slot == "legs" then
            for itemID, t in pairs(itemT) do table.insert(allLegs, itemID) end
        elseif slot == "body" then
            for itemID, t in pairs(itemT) do table.insert(allBodies, itemID) end
        elseif slot == "shield" then
            for itemID, t in pairs(itemT) do table.insert(allShields, itemID) end
        elseif slot == "quiver" then
            for itemID, t in pairs(itemT) do table.insert(allQuivers, itemID) end
        elseif slot == "head" then
            for itemID, t in pairs(itemT) do table.insert(allHeads, itemID) end
        elseif slot == "bag" then
            for itemID, t in pairs(itemT) do table.insert(allNormalBags, itemID) end
        end
    end
end

function central_register_items(itemsT)
    if not itemsT then return end

    for itemType, items in pairs(itemsT) do
        local itemT = itemTable[itemType]
        for itemID, statT in pairs(items) do itemT[itemID] = statT end
    end
    if check_central_register_items then print("central_register_items") end
end