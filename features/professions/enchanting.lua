function enchanting_startUp()
    local loopID = 0
    local levelUpMessages = {}

    addProfession(enchantingConf.professionT)
    for spellName, itemAID in pairs(AID.spells) do AIDItems_onMove[itemAID] = {funcStr = "enchanting_moveToAltar"} end
    
    for _, itemT in ipairs(enchantingConf.magicDustItems) do
        if itemT.itemID then IDItems_onMove[itemT.itemID] = {funcStr = "enchanting_moveToAltar"} end
        if itemT.itemAID then AIDItems_onMove[itemT.itemAID] = {funcStr = "enchanting_moveToAltar"} end
    end
    
    for spellName, spellCrafT in pairs(enchantingConf.spellScrolls) do
        loopID = loopID + 1
        spellCrafT.name = spellName
        spellCrafT.itemAID = AID.spells[spellName]
        spellCrafT.choiceID = loopID
        if not spellCrafT.exp then spellCrafT.exp = enchantingConf.defaults.exp end
        
        if spellCrafT.enchantinglevel then
            if not levelUpMessages[spellCrafT.enchantinglevel] then levelUpMessages[spellCrafT.enchantinglevel] = {} end
            table.insert(levelUpMessages[spellCrafT.enchantinglevel], "enchanting level up: You can now craft "..spellName.." spell")
        end
    end
    
    loopID = 0
    for n, craftT in pairs(enchantingConf.other) do
        if craftT.reqT and craftT.reqT.itemID then craftT.reqT = {craftT.reqT} end
        if craftT.reqT then
            for _, itemT in ipairs(craftT.reqT) do
                if not itemT.count then itemT.count = enchantingConf.defaults.count end
            end
        end
        if not craftT.exp then craftT.exp = enchantingConf.defaults.exp end
        if not craftT.itemID then print("ERROR - missing itemID in enchantingConf.other["..n.."]") end
        if not craftT.count then craftT.count = craftingConf.defaults.count end
        if not craftT.enchantinglevel then craftT.enchantinglevel = 0 end
        
        if craftT.bigSV and craftT.bigSV[SV.enchantinglevel] then
            local level = craftT.bigSV[SV.enchantinglevel]
            if not levelUpMessages[level] then levelUpMessages[level] = {} end
            table.insert(levelUpMessages[level], "enchanting level up: You can now craft "..n)
        end
        
        loopID = loopID + 1
        craftT.ID = loopID
        craftT.craftName = n
    end
    
    enchantingConf.levelUpMessages = levelUpMessages
end

function enchantingMW_title(player) return "Your enchanting level is: "..player:getEnchantingLevel().." ["..player:getEnchantingExp().."/"..player:getEnchantingTotalExp().."]" end

function enchanting_spellScrollsMW_choices(player)
    local choiceT = {}
    local level = player:getEnchantingLevel()

    for _, spellCrafT in pairs(enchantingConf.spellScrolls) do
        if not spellCrafT.enchantinglevel or level >= spellCrafT.enchantinglevel then
            local spellLearnedString = spells_spellLearned(player, spellCrafT.itemAID) and "learned" or "not learned"
            choiceT[spellCrafT.choiceID] = spellCrafT.name..createSpaces(spellCrafT.name, 20).."["..spellLearnedString.."]"
        end
    end
    return choiceT
end

function enchanting_canCraft(player, craftT) return smithing_canCraft(player, craftT) end
function enchanting_createChoiceStr(player, craftT, canCraft) return smithing_createChoiceStr(player, craftT, canCraft) end

function enchanting_otherMW_choices(player)
    local choiceT = {}
        
    for craftName, craftT in pairs(enchantingConf.other) do
        local canCraft, dontShow = enchanting_canCraft(player, craftT)
        if not dontShow then choiceT[craftT.ID] = enchanting_createChoiceStr(player, craftT, canCraft) end
    end
    return choiceT
end

function enchantingMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if choiceID == 1 then return player:createMW(MW.enchanting_spellScrolls) end
    if choiceID == 2 then return player:createMW(MW.enchanting_other) end
end

function enchanting_spellScrollsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.enchanting) end
    local craftT = enchanting_getSpellCraftT(choiceID)

    if buttonID == 100 then
        local spellT = spells_getSpellT(craftT.itemAID)
        local text = craftT.name.." spell\n"
        
        text = text.."Requires:\n"..itemRequirementStr(craftT.reqT).."\n"
        text = text.."Gives "..craftT.exp.." enchanting experience for crafting.\n\n"
        
        if not spellT then
            text = text.."This spell does not yet exist in game"
        else
            text = text.."Spell Effect:\n"
            for _, effect in ipairs(spellT.effectT) do text = text..effect.."\n" end
        end
        
        player:showTextDialog(5958, text)
        return player:createMW(mwID)
    end
    
    if not player:hasItems(craftT.reqT) then
        player:sendTextMessage(GREEN, "You can't craft "..craftT.name.." right now")
        return player:createMW(mwID)
    end
    
    player:removeItemList(craftT.reqT)
    player:addEnchantingExp(craftT.exp)
    player:rewardItems({itemID = 5958, itemAID = craftT.itemAID})
end

function enchanting_otherMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.enchanting) end
    if choiceID == 255 then return player:createMW(mwID) end
    local craftT = enchanting_getOtherCraftT(choiceID)
    
    if buttonID == 100 then
        local text = craftT.craftName.."\n"
        local itemName = craftT.itemName or ItemType(craftT.itemID):getName()

        text = text.."Requires:\n"..itemRequirementStr(craftT.reqT).."\n"
        text = text.."Gives "..craftT.exp.." enchanting experience for crafting.\n\n"
        text = text.."You get "..plural(itemName, craftT.count)
        if craftT.gems2_Info then text = text.."\n\n"..gems2_getLookText(craftT.itemID, "gemLook") end
        player:showTextDialog(craftT.itemID, text)
        return player:createMW(mwID)
    end

    if craftT.enchantinglevel > player:getEnchantingLevel() then
        player:sendTextMessage(GREEN, "You need enchanting level "..craftT.enchantinglevel.." to craft this item")
        return player:createMW(mwID)
    end

    if not enchanting_canCraft(player, craftT) then
        player:sendTextMessage(GREEN, "You can't craft "..craftT.craftName.." right now")
        return player:createMW(mwID)
    end
    
    if not player:rewardItems(craftT, false, "You don't have enough cap to create this item") then return player:createMW(mwID) end
    player:removeItemList(craftT.reqT)
    player:addEnchantingExp(craftT.exp)
    player:createMW(mwID)
end

-- get functions
function enchanting_getSpellCraftT(choiceID)
    for _, spellCrafT in pairs(enchantingConf.spellScrolls) do
        if choiceID == spellCrafT.choiceID then return spellCrafT end
    end
end

function enchanting_getOtherCraftT(choiceID)
    for craftName, craftT in pairs(enchantingConf.other) do
        if craftT.ID == choiceID then return craftT end
    end
end

function Player.addEnchantingExp(player, amount)
    local newLevel = professions_addExp(player, amount, enchantingConf.professionT.professionStr)
    if not newLevel then return end
    local msgT = enchantingConf.levelUpMessages[newLevel] or {}

    player:sendTextMessage(GREEN, "Your enchanting skill is now level "..newLevel.."!")
    for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
end

function Player.getEnchantingExp(player) return professions_getExp(player, enchantingConf.professionT.professionStr) end
function Player.getEnchantingLevel(player) return professions_getLevel(player, enchantingConf.professionT.professionStr) end
function Player.getEnchantingTotalExp(player) return professions_getTotalExpNeeded(player, enchantingConf.professionT.professionStr) end

-- other functions
function enchanting_moveToAltar(player, item, toPos)
    if not findItem(7472, toPos, AID.enchanting.fireAltar) then return end
    local itemAID = item:getActionId()
        
    local function createDust(magicDustAmount, chance)
        local itemAmount = item:getCount()
        local totalDustAmount = 0
        
        magicDustAmount = magicDustAmount or 1
        chance = chance or 100
        
        for x=1, itemAmount do
            if chanceSuccess(chance) then totalDustAmount = totalDustAmount + magicDustAmount end
        end
        
        if totalDustAmount > 0 then
            local posT = getAreaAround(toPos, 2)
            posT = removePositions(posT, "solid")
            
            for x=1, totalDustAmount do
                local randomPos = randomPos(posT, 1)[1]
                local delay = x*100
                
                addEvent(createItem, delay, 5905, randomPos, 1)
                addEvent(doSendMagicEffect, delay, randomPos, {5, 30})
                addEvent(doSendDistanceEffect, delay, toPos, randomPos, 4)
            end
        end
        return item:remove()
    end
    local spellT = spells_getSpellT(itemAID)

    if spellT then
        setSV(player, SV.enchantingAltarHint, 1)
        return createDust(spellT.magicDust)
    end
    local itemID = item:getId()

    for _, itemT in ipairs(enchantingConf.magicDustItems) do
        if itemT.itemAID and itemAID == itemT.itemAID then return createDust(itemT.magicDust, itemT.chance) end
        if itemT.itemID and itemID == itemT.itemID then return createDust(itemT.magicDust, itemT.chance) end
    end
end