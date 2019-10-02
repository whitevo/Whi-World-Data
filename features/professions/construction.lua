function construction_checkTable(cT)
    if not cT.positionT then cT.positionT = {} end
    if not cT.state then cT.state = 0 end
end

function construct(player, item)
    local CT = getCTByAID(itemAID)
    if not CT then return end
    if not CT.transform then return print("make new building method!!") end

    local itemPos = item:getPosition()
    if not comparePositionT(CT.positionT, itemPos) then table.insert(CT.positionT, itemPos) end

    local bridgeID = item:getId()
    if bridgeID == CT.transform then        return CT_duration(player, CT) end
    if bridgeID == CT.brokenTransform and not CT.constructed then return CT_duration(player, CT) end
    local eventData = {CT_breaking, CT}
    
    if CT.constructed then
        if not CT_construct(player, CT.repair) then return end
        stopAddEvent("constructions", CT.name)
        CT.time = os.time() + CT.completeDuration * 60
        CT_repair(CT)
        registerAddEvent("constructions", CT.name, CT.completeDuration * 1000 * 60 / 2, eventData)
        player:sendTextMessage(GREEN, CT.name .. " is repaired, it will last " .. CT.completeDuration .. " minutes.")
    elseif CT_construct(player, CT.items) then
        CT.state = CT.state + 1
        item:transform(CT.transform)
        stopAddEvent("constructions", CT.name)
        CT_repair(CT)
        
        if CT.state == CT.parts then
            CT.time = os.time() + CT.completeDuration * 60
            registerAddEvent("constructions", CT.name, CT.completeDuration * 1000 * 60 / 2, eventData)
            player:sendTextMessage(GREEN, CT.name .. " is built, it will last " .. CT.completeDuration .. " minutes.")
            CT.constructed = true
        else
            CT.time = os.time() + CT.duration * 60
            registerAddEvent("constructions", CT.name, CT.duration * 1000 * 60 / 2, eventData)
            player:sendTextMessage(GREEN, "Part of " .. CT.name .. " is built, it will last " .. CT.duration .. " minutes.")
        end
    end
end

function getCTByAID(itemAID)
    return constructions[itemAID]
end

function CT_construct(player, items)
    local itemCount = 0
    local hasAllItems = 0
    local text = ""
    
    for itemID, count in pairs(items) do
        local requestItemCount = player:getItemCount(itemID)
        local missingItemCount = count - requestItemCount
        
        itemCount = itemCount + 1
        
        if requestItemCount >= count then
            hasAllItems = hasAllItems + 1
        elseif missingItemCount > 1 then
            text = text .. tostring(missingItemCount .. " " .. ItemType(itemID):getPluralName() .. " \n")
        else
            text = text .. tostring(missingItemCount .. " " .. ItemType(itemID):getName() .. " \n")
        end
    end
    
    if itemCount == hasAllItems then
        for itemID, count in pairs(items) do
            player:removeItem(itemID, count)
        end
        return true
    else
        player:sendTextMessage(GREEN, "You are missing \n" .. text)
    end
end

function CT_breaking(t)
    local partsFound = 0

    for _, pos in pairs(t.positionT) do
        local part = findItem(t.transform, pos)
        
        if part then
            partsFound = partsFound + 1
            part:transform(t.brokenTransform)
        end
    end
    local eventData = {CT_destroy, t}
    local eventDuration = partsFound == t.parts and t.completeDuration or t.duration
    
    registerAddEvent("constructions", t.name, eventDuration * 1000 * 60 / 2, eventData)
end

function CT_destroy(t)
    for _, pos in pairs(t.positionT) do
        local brokenPart = findItem(t.brokenTransform, pos)
        
        massTeleport(pos, t.destroyPos, {"monster", "player"})
        if brokenPart then brokenPart:transform(460) end
    end
    t.state = 0
    t.constructed = false
end

function CT_duration(player, CT)
    local text = CT_getDurationText(CT)
    if not text then return end
    return player:sendTextMessage(GREEN, text)
end

function CT_getDurationText(CT)
    local timeLeft = CT.time - os.time()
    if timeLeft < 1 then return end
    return tostring(CT.name .. " will last: " .. getTimeText(timeLeft))
end

function CT_repair(CT)
    for _, pos in pairs(CT.positionT) do
        local brokenPart = findItem(CT.brokenTransform, pos)
        if brokenPart then brokenPart:transform(CT.transform) end
    end
end

function CT_look(player, item, desc)
    if desc then return desc end
    local itemAID = item:getActionId()
    local CT = getCTByAID(itemAID)
    
    if not CT then return desc end
    local itemID = item:getId()
    
    if CT.constructed then
        if itemID == CT.transform then
            return "You see " .. CT.name .. "\n" .. CT_getDurationText(CT)
        elseif itemID == CT.brokenTransform then
            return "You see broken " .. CT.name .. "\n" .. CT_getDurationText(CT)
        end
    elseif itemID == CT.transform then
        return "You see part of " .. CT.name .. "\n" .. CT_getDurationText(CT)
    elseif itemID == CT.brokenTransform then
        return "You see part of broken " .. CT.name .. "\n" .. CT_getDurationText(CT)
    elseif itemID == 460 then
        return "You need: " .. CT_getRequiredItemSTR(CT.items) .. " to build this part of " .. CT.name
    end
end

function CT_getRequiredItemSTR(items)
    local text = ""
    for itemID, count in pairs(items) do text = text..plural(ItemType(itemID):getName(), count).."\n" end
    return text
end

function central_register_construct(constructT)
    if not constructT then return end
    if not constructions then return print("ERROR in central_register_construct - missing constructions") end

    for AID, confT in pairs(constructT) do
        construction_checkTable(confT)
        constructions[AID] = confT
        central_register_actionEvent({[AID] = {funcSTR = "construct"}}, "AIDItems")
    end
end