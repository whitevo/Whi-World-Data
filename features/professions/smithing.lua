function smithing_useHammer(player, item, itemEx)
    if not itemEx:isItem() then return end
    local anvilPos = itemEx:getPosition()
    if not findItem(2555, anvilPos) then return end
    return smithing_quickCraft(player, item, itemEx) or player:createMW(MW.smithing, anvilPos)
end

function smithing_quickCraft(player, item, itemEx)
    local itemID = itemEx:getId()
    local craftingName = smithingConf.quickCraft[itemID]
    if not craftingName then return end
    local itemPos = itemEx:getPosition()
    local craftT = smithingConf.craftingMaterials[craftingName]

    tools_addCharges(player, item, -craftT.takeCharges)
    createItem(craftT.itemID, itemPos, craftT.count)
    player:addSmithingExp(craftT.exp)
    addEvent(removeItemFromPos, 100, itemID, itemPos, 1)
    return true
end

function smithingMW_save(player, usingAnvil) return usingAnvil end
function smithingMW_title2(player) return smithingMW_title(player, true) end

function smithingMW_title(player, usingAnvil)
    if not usingAnvil then return "USE HAMMER ON ANVIL TO HAVE MORE CRAFTING OPTIONS" end
    return "Your smithing level is: "..player:getSmithingLevel().." ["..player:getSmithingExp().."/"..player:getSmithingTotalExp().."]"
end

function smithingMW_buttons(player, anvilPos)
    local buttonT = {[100] = "show", [101] = "back"}

    if anvilPos and player:hasHouse() then
        local houseT = building_getHouseT(player)
        if isInRange(anvilPos, houseT.upCorner, houseT.downCorner) then buttonT[102] = "remove anvil" end
    end
    return buttonT
end

function smithingMW(player, mwID, buttonID, choiceID, usingAnvil)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if buttonID == 102 then return removeItemFromPos(2555, usingAnvil) end
    if choiceID == 1 then return player:createMW(MW.smithing_equipment, usingAnvil) end
    if choiceID == 2 then return player:createMW(MW.smithing_materials, usingAnvil) end
    if choiceID == 3 then return player:createMW(MW.smithing_other, usingAnvil) end
end

function smithing_canCraft(player, craftT, usingAnvil, group)
    if group and craftT.group ~= group then return false, true end
    if not compareSV(player, craftT.allSV, "==") then return false, true end
    if not compareSV(player, craftT.bigSV, ">=") then return false, true end
    if not usingAnvil and craftT.needAnvil then return false, true end
    if not player:hasHammerCharges(craftT.takeCharges) then return end
    if craftT.reqT and not player:hasItems(craftT.reqT) then return end
    return true
end

function smithing_createChoiceStr(player, craftT, canCraft)
    local text = ""
    local choiceText = ""
        
    if canCraft then
        local msgT = itemRequirementStrT(craftT.reqT)
        
        for i, msg in ipairs(msgT) do
            if i == 1 then choiceText = msg else choiceText = choiceText..", "..msg end
        end
        text = " [takes: "..choiceText.."]"
    else
        local missingReqT = {}
        
        for i, itemT in pairs(craftT.reqT) do
            local haveCount = player:getItemCount(itemT.itemID, itemT.itemAID, itemT.fluidType, true)
            
            if haveCount == 0 then
                missingReqT[i] = itemT
            elseif haveCount < itemT.count then
                missingReqT[i] = {
                    count = itemT.count - haveCount,
                    itemID = itemT.itemID,
                    itemAID = itemT.itemAID,
                    fluidType = itemT.fluidType,
                }
            end
        end
        
        local msgT = itemRequirementStrT(missingReqT)
        
        for i, msg in ipairs(msgT) do
            if i == 1 then choiceText = msg else choiceText = choiceText..", "..msg end
        end
        text = " [missing: "..choiceText.."]"
    end
    return craftT.craftName..text
end

local function createChoiceT(player, usingAnvil, group)
    local choiceT = {}
        
    for craftName, craftT in pairs(smithingConf.craftingMaterials) do
        local canCraft, dontShow = smithing_canCraft(player, craftT, usingAnvil, group)
        if not dontShow then choiceT[craftT.ID] = smithing_createChoiceStr(player, craftT, canCraft) end
    end
    return choiceT
end

function smithing_otherMW_choices(player, usingAnvil) return createChoiceT(player, usingAnvil, "other") end
function smithing_equipmentMW_choices(player, usingAnvil) return createChoiceT(player, usingAnvil, "equipment") end
function smithing_materialsMW_choices(player, usingAnvil) return createChoiceT(player, usingAnvil, "materials") end

function smithing_craftMW(player, mwID, buttonID, choiceID, usingAnvil)
    if buttonID == 101 then return player:createMW(MW.smithing, usingAnvil) end
    if choiceID == 255 then return player:createMW(mwID, usingAnvil) end
    local craftT = smithing_getCraftT(choiceID)

    if buttonID == 100 then
        local text = craftT.craftName.."\n"
        local takeChargesStr = craftT.takeCharges and craftT.takeCharges > 0 and plural("charge", craftT.takeCharges).." on your smithing hammer\n" or ""
        local itemName = ItemType(craftT.itemID):getName()
        
        text = text.."Requires:\n"..takeChargesStr
        text = text..itemRequirementStr(craftT.reqT).."\n"
        text = text.."Gives "..craftT.exp.." smithing experience for crafting.\n\n"
        text = text.."You get "..plural(itemName, craftT.count)
        player:showTextDialog(craftT.itemID, text)
        return player:createMW(mwID, usingAnvil)
    end
    
    if not smithing_canCraft(player, craftT, usingAnvil) then
        player:sendTextMessage(GREEN, "You can't craft "..craftT.craftName.." right now")
        return player:createMW(mwID, usingAnvil)
    end
    
    if not player:rewardItems(craftT, false, "You don't have enough cap to create this item") then return player:createMW(mwID, usingAnvil) end
    tools_addHammerCharges(player, -craftT.takeCharges)
    player:removeItemList(craftT.reqT)
    player:addSmithingExp(craftT.exp)
end

-- get functions and is functions
function smithing_getCraftT(choiceID)
    for craftName, craftT in pairs(smithingConf.craftingMaterials) do
        if craftT.ID == choiceID then return craftT end
    end
end

function Player.addSmithingExp(player, amount)
    local newLevel = professions_addExp(player, amount, smithingConf.professionT.professionStr)
    if not newLevel then return end
    local msgT = smithingConf.levelUpMessages[newLevel] or {}

    player:sendTextMessage(GREEN, "Your smithing skill is now level "..newLevel.."!")
    for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
end

function Player.getSmithingExp(player) return professions_getExp(player, smithingConf.professionT.professionStr) end
function Player.getSmithingLevel(player) return professions_getLevel(player, smithingConf.professionT.professionStr) end
function Player.getSmithingTotalExp(player) return professions_getTotalExpNeeded(player, smithingConf.professionT.professionStr) end

