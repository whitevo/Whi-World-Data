function lootSystem_startUp()
    for monsterName, lootT in pairs(loot) do lootSystem_checkTable(lootT) end
    print("lootSystem_startUp()")
end

function lootSystem_checkTable(lootT)
    local function checkName(itemID, t)
        if t.name then return end
        
        if t.itemAID then
            local spellT = spells_getSpellT(t.itemAID)
            if spellT then t.name = spellT.word.." spell" return end

            local herbT = herbs_getHerbT(t.itemAID)
            if herbT then t.name = herbT.name return end
        end
        t.name = ItemType(itemID):getName()
    end
    
    local function addAID(t)
        local itemT = items_getStats(t.itemID)
        if not itemT or not itemT.itemAID then return end
        if t.itemAID and t.itemAID ~= itemT.itemAID then print("ERROR - both itemT and looT want to put unique itemAID on "..t.name) end
        t.itemAID = itemT.itemAID
    end

    if lootT.items then
        for itemID, t in pairs(lootT.items) do
            if t.partyBoost == nil then t.partyBoost = true end
            if not t.chance then t.chance = {0} end
            if not t.count then t.count = {1} end
            if not t.itemID then t.itemID = itemID end
            if type(t.chance) ~= "table" then t.chance = {t.chance} end
            if type(t.count) ~= "table" then t.count = {t.count} end
            checkName(t.itemID, t)
            addAID(t)
        end
    end
end

function lootSystem_onDeath(creature, lootBag) -- auto registered on created monsters
    if not creature then return end
    local monsterName = creature:getRealName()
    if not lootBag or type(lootBag) == "table" then return print("ERROR in lootSystem_onDeath - "..monsterName.." has no corpse to put loot into") end
    if not lootBag:isContainer() then return print("ERROR in lootSystem_onDeath - "..monsterName.." has no corpse to put loot into") end

    local lootT = loot[monsterName]
    if not lootT then return end

    local player = getHighestDamageDealerFromDamageT(creature:getDamageMap(), "player")
    if player and getChallengeT(player) then return end
    
    lootBag:setActionId(AID.other.corpse)
    lootSystem_dropBounty(lootBag, lootT.bounty)
    if not lootT.items then return end

    for _, itemT in pairs(lootT.items) do
        local allSVCheck = compareSV(player, itemT.allSV, "==")
        local bigSVCheck = compareSV(player, itemT.bigSV, ">=")
        
        if allSVCheck and bigSVCheck then lootSystem_addLoot(player, lootBag, itemT, lootT, creature) end
    end
end

function lootSystem_addLoot(player, lootBag, itemT, lootT, monster)
    local dropAmount = lootSystem_getDropAmount(player, itemT, lootT)
    if dropAmount == 0 then return end

    local function addItemText(item)
        if itemT.itemText then item:setAttribute(TEXT, itemT.itemText) end
        if itemT.unique then item:setText("cantStack", math.random(1, 5000)) end
    end

    local function addAID(item)
        if not itemT.itemAID then return end
        if type(itemT.itemAID) == "number" then return item:setActionId(itemT.itemAID) end
        item:setActionId(randomValueFromTable(itemT.itemAID))
    end

    local function addItem(amount)
        local item = lootBag:addItem(itemT.itemID, amount)
        addAID(item)
        items_randomiseStats(item)
        addItemText(item)
    end

    if monster:isBoss() and isEquipmentItem(itemT.itemID) then
        local playerT = getPlayerTFromDamageT(monster:getDamageMap())
        local playerNames = {}
        for i, player in ipairs(playerT) do playerNames[i] = player:getName() end
        local playerTStr = tableToStr(playerNames)
        npcChat_insertConvo("town", playerTStr.." recently looted "..itemT.name.." from "..monster:getName())
    end

    lootSystem_lootedFirstTime(player, lootT, itemT)
    if not itemT.fluidType then return addItem(dropAmount) end
    for x=1, dropAmount do addItem(itemT.fluidType) end
end

function lootSystem_getDropAmount(player, itemT, lootT)
    local extraChance = lootSystem_getExtraChance(player, itemT, lootT)
    local dropAmount = 0

    for i, chance in ipairs(itemT.chance) do
        local amount = itemT.count[i] or 1
        local function addDropAmount() dropAmount = dropAmount + math.random(1, amount) end

        local bonusChance = lootSystem_getBonusChance(player, chance, itemT, lootT)
        local totalChance = extraChance + bonusChance + chance

        while totalChance > 100 do
            totalChance = totalChance - 100
            addDropAmount()
        end

        if chanceSuccess(totalChance) then addDropAmount() end
    end
    return dropAmount
end

function lootSystem_getExtraChance(player, itemT, lootT)
    if not player then return 0 end
    local chance = 0 
    
    chance = chance + lootSystem_getfirstTimeChance(player, itemT, lootT)
    chance = chance + lootSystem_getVocationChance(player, itemT)
    chance = chance + lootSystem_getFurSetChance(player, itemT)
    
    for _, funcStr in ipairs(centralSystem_extraLootChance) do
        chance = chance + _G[funcStr](player, itemT, lootT)
    end
    return chance
end

function lootSystem_getBonusChance(player, baseChance, itemT, lootT)
    if not player then return 0 end
    local chance = 0 
    
    chance = chance + lootSystem_getFurBagChance(player, baseChance, itemT, lootT)
    chance = chance + lootSystem_getPartyChance(player, baseChance, itemT, lootT)
    
    for _, funcStr in ipairs(centralSystem_bonusLootChance) do
        chance = chance + _G[funcStr](player, baseChance, itemT, lootT)
    end
    return chance
end

function lootSystem_getfirstTimeChance(player, itemT, lootT)
    if not itemT.firstTime then return 0 end
    local partyMembers = getPartyMembers(player, 6)

    for guid, playerID in pairs(partyMembers) do
        if compareSV(playerID, lootT.storage, "~=", 1) then return itemT.firstTime end
    end
    return 0
end

function lootSystem_lootedFirstTime(player, itemT, lootT)
    if not player then return end
    if lootSystem_getfirstTimeChance(player, itemT, lootT) < 1 then return end
    local partyMembers = getPartyMembers(player, 6)
    for guid, playerID in pairs(partyMembers) do setSV(playerID, lootT.storage, 1) end
end

function lootSystem_getVocationChance(player, itemT)
    local partyMembers = getPartyMembers(player, 6)

    for guid, playerID in pairs(partyMembers) do
        local player = Player(playerID)
        
        if player then
            local playerVoc = player:getVocation():getName():lower()
            if itemT[playerVoc] then return itemT[playerVoc] end
        end
    end
    return 0
end

local paws = {5896, 5897, 13159}
function lootSystem_getFurBagChance(player, baseChance, itemT, lootT)
    if not isInArray(paws, itemT.itemID) then return 0 end
    local partyMembers = getPartyMembers(player, 6)
    
    for guid, playerID in pairs(partyMembers) do
        if compareSV(playerID, SV.furBagBonus, "==", 1) then return baseChance*2 end
    end
    return 0
end

local furSetItems = {
    [SV.furSetAnimalLeather] = {11200},
    [SV.furSetFurItems] = {11235, 11224},
    [SV.furSetPawItems] = paws,
}
function lootSystem_getFurSetChance(player, itemT)
    local function getItemSV()
        for sv, itemIDT in pairs(furSetItems) do
            if isInArray(itemIDT, itemT.itemID) then return sv end
        end
    end
    local itemSV = getItemSV()
    if not itemSV then return 0 end
    
    local function extraBonus(sv)
        local bonusChance = getSV(player, sv)
        if bonusChance >= 1 then return bonusChance else return 0 end
    end
    
    local partyMembers = getPartyMembers(player, 6)
    
    for guid, playerID in pairs(partyMembers) do
        if setActivated(playerID, SV.furSet) then
            local extraChance = getSV(playerID, itemSV)
            if extraChance > 0 then return extraChance end
        end
    end
    return 0
end

function lootSystem_getPartyChance(player, baseChance, itemT)
    if not player then return 0 end
    if not itemT.partyBoost then return 0 end
    local players = getPartyMembers(player, 10)
    local playerAmount = tableCount(players)-1

    return  playerAmount > 0 and playerAmount*baseChance*lootSystem_partyChance or 0
end

function lootSystem_dropBounty(lootBag, bountyT)
    if not bountyT then return end

    local function addBounty(rewardID, amountStr)
        local amount = _G[amountStr] or 0
        if amount < 1 then return end
        _G[amountStr] = 0
        lootBag:addItem(rewardID, amount)
    end

    for rewardID, t in pairs(bountyT) do addBounty(rewardID, t.amount) end
end

function autoLoot_gold(player, item)
    if not player:isPlayer() then return end
    if getSV(player, SV.autoLoot_gold) == -1 then return end
    local goldID = ITEMID.other.coin
    if player:getEmptySlots() == 0 and not player:getItem(goldID) then return end

    if item:getId() == goldID then
        autoLoot_loot(player, goldID, item:getCount()) 
        return item:remove()
    end
    
    if not item:isContainer() then return end
    local slotIndex = 0
        
    for x=0, item:getSize() do
        local item = item:getItem(x-slotIndex)
        if not item then break end
        if item:getId() == goldID then
            slotIndex = slotIndex + 1
            autoLoot_loot(player, goldID, item:getCount())
            item:remove()
        end
    end
end

function autoLoot_corpse(player, corpse)
    if not player:isPlayer() then return end
    autoLoot_gold(player, corpse)
    autoLoot_herb(player, corpse)
    autoLoot_gems(player, corpse)
    autoLoot_seeds(player, corpse)
end

function autoLoot_loot(player, itemID, amount) return player:rewardItems({itemID = itemID, count = amount}) end

function lootSystem_canOpenCorpse(player, item) -- return true to not allow onUse
    if ghoul_corpse_onUse(player, item) then return true end
end

function central_register_monsterLoot(lootT)
    if not lootT then return end
    if not loot then return print("ERROR in central_register_monsterLoot - missing loot") end
    if type(lootT) ~= "table" then updateT = {lootT} end
    
    for key, lootT in pairs(lootT) do
        local mainT = loot[key]

        lootSystem_checkTable(lootT)
        
        if not mainT then
            loot[key] = lootT
        else
            for k, v in pairs(lootT) do mainT[k] = v end
        end
    end
    
    if check_central_register_monsterLoot then print("central_register_monsterLoot") end
end