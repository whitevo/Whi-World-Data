if not db.query("SELECT * FROM `savedItemlist` WHERE 1") then
    local queryT = {
        id = "INT NOT NULL AUTO_INCREMENT PRIMARY KEY (id)",
        listID = "TEXT NOT NULL",
        charID = "INT(6) NOT NULL",
        inBag = "ENUM('false', 'true') NOT NULL DEFAULT 'false'",
        itemID = "INT(5) NOT NULL",
        itemAID = "INT(5)",
        itemText = "TEXT NOT NULL",
        fluidType = "INT(3) NOT NULL",
        count = "INT(3) NOT NULL",
    }
    local queryStr = createQueryStr("savedItemlist", 'CREATE', queryT)
    db.query(queryStr)
    print("created savedItemlist to database")
end

function Player.saveItems(player, ID)
    local playerGUID = player:getGuid()
    local itemsT = {}
    local loopID = 0

    db.query("DELETE FROM `savedItemlist` WHERE `listID` = '"..ID.."' AND `charID` = "..playerGUID)

    local function saveItem(item, inBag)
        local queryT = {
            listID = ID,
            charID = playerGUID,
            itemID = item:getId(),
            itemAID = item:getActionId(),
            itemText = item:getAttribute(TEXT),
            fluidType = item:getFluidType(),
            count = item:getCount(),
            inBag = inBag,
        }
        loopID = loopID + 1
        itemsT[loopID] = queryT

        local queryStr = createQueryStr("savedItemlist", "INSERT", queryT)
        db.query(queryStr)
        return true
    end

    local equippedItemsT = player:getItems()
    for slotID, item in pairs(equippedItemsT) do saveItem(item) end
    
    local bag = player:getBag()
    if not bag then return itemsT end

    for slotID=0, bag:getSize() do
        local item = bag:getItem(slotID)
        if not item then break end
        saveItem(item, "true")
    end
    return itemsT
end

function Player.getItems(player, ignoreSlots)
    local itemsT = {}
    local ignoreSlots = type(ignoreSlots) ~= "table" and {ignoreSlots} or ignoreSlots
--    if not testServer() then table.insert(ignoreSlots, SLOT_FOR_STORE_BOX) end

    local function addItemToItemsT(slotID)
        if isInArray(ignoreSlots, slotID) then return end
        local item = player:getSlotItem(slotID)
        if not item then return end
        itemsT[slotID] = item
    end

    for slotID=1, 13 do addItemToItemsT(slotID) end
    return itemsT
end

function Player.loadItems(player, itemsT_or_ID, playerGUID)
    local function loadItems(itemsT)
        for slotID=0, 13 do
            local item = player:getSlotItem(slotID)
            if item then item:remove() end
        end

        for _, itemT in pairs(itemsT) do
            local inBag = type(itemT.inBag) == "string" and itemT.inBag == "true" or itemT.inBag
            if not inBag then createItem(itemT.itemID, nil, itemT.count, itemT.itemAID, itemT.fluidType, itemT.itemText, player) end
        end
        
        local bag = player:getBag()
        if bag then
            for _, itemT in pairs(itemsT) do
                local inBag = type(itemT.inBag) == "string" and itemT.inBag == "true" or itemT.inBag
                if inBag then createItem(itemT.itemID, nil, itemT.count, itemT.itemAID, itemT.fluidType, itemT.itemText, bag) end
            end
        end
        player:sendTextMessage(WHITE, "loaded items")
    end

    if type(itemsT_or_ID) == "table" then return loadItems(itemsT_or_ID) end
    local playerGUID = playerGUID or player:getGuid()
    local itemsT = {}
    local itemList = db.storeQuery("SELECT * FROM `savedItemlist` WHERE `listID` = '"..itemsT_or_ID.."' AND `charID` = "..playerGUID)
    local loopID = 0

    repeat
        loopID = loopID + 1
        itemsT[loopID] = {
            itemID = DBNumberResultReader(itemList, "itemID"),
            itemAID = DBNumberResultReader(itemList, "itemAID"),
            itemText = result.getString(itemList, "itemText"),
            fluidType = DBNumberResultReader(itemList, "fluidType"),
            count = DBNumberResultReader(itemList, "count"),
            inBag = result.getString(itemList, "inBag") == "true",
        }
    until not result.next(itemList)
    result.free(itemList)
    loadItems(itemsT)
end

-- svT = {[SV] = INT}
function Player.setSV(player, svT, v) return setSV(player, svT, v) end
function Player.getSV(player, sv, minAmount) return getSV(player, sv, minAmount) end
function Player.addSV(player, svT, v, limit) return addSV(player, svT, v, limit) end
function Player.removeSV(player, svT) return removeSV(player, svT) end

local function createSVT(svT, v)
    if not svT then return end
    if type(svT) ~= "table" then return {[svT] = v} end
    local newSVT = {}
        
    for sv, actualSV in pairs(svT) do
        if sv < 1000 then
            newSVT[actualSV] = v
        else
            newSVT[sv] = actualSV
        end
    end
    return newSVT
end

function getSV(playerID, sv, minAmount)
    local player = Player(playerID)
    if not player then return end
    local value = player:getStorageValue(sv)

    if minAmount and value < minAmount then
        value = minAmount
        player:setSV(sv, minAmount)
    end
    return value
end

function setSV(playerID, svT, v)
    local player = Player(playerID)
    if not player or not svT then return end
    svT = createSVT(svT, v)
    for storage, v in pairs(svT) do player:setStorageValue(storage, v) end
    return true
end

function addSV(playerID, svT, v, limit)
    local player = Player(playerID)
    if not player or not svT then return end
    svT = createSVT(svT, v)
    
    for storage, v in pairs(svT) do
        local valueBefore = math.max(player:getStorageValue(storage), 0)
        local newValue = math.max(valueBefore + v, 0)
        
        if limit and newValue > limit then newValue = limit end
        player:setStorageValue(storage, newValue)
    end
    return true
end

function removeSV(playerID, svT)
    local player = Player(playerID)
    if not player or not svT then return end
    svT = createSVT(svT, -1)
    for storage, v in pairs(svT) do player:setStorageValue(storage, -1) end
end

function compareSV(playerID, svT, operator, v)
    local player = Player(playerID)
    if not player then return end
    if not svT then return true end
    svT = createSVT(svT, v)

    if operator == ">" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) <= v then return end
        end
    elseif operator == "<" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) >= v then return end
        end
    elseif operator == ">=" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) < v then return end
        end
    elseif operator == "<=" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) > v then return end
        end
    elseif operator == "==" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) ~= v then return end
        end
    elseif operator == "~=" then
        for sv, v in pairs(svT) do
            if player:getStorageValue(sv) == v then return end
        end
    end
    return true
end

function getAccountSVT(accountID, sv, onlyOne)    
    if type(accountID) == "userdata" then accountID = accountID:getAccountId() end
    local playerGUIDT = getGuidTByAccID(accountID)
    local svT = {}

    for _, guid in pairs(playerGUIDT) do
        local playerData = db.storeQuery("SELECT `value` FROM `player_storage` WHERE `player_id` = "..guid.." AND `key` = "..sv)
        local charName = getPlayerNameByGUID(guid)
        local onlinePlayer = Player(charName)
        
        if onlinePlayer then
            table.insert(svT, getSV(onlinePlayer, sv))
        elseif playerData then
            table.insert(svT, DBNumberResultReader(playerData, "value"))
        end
    end
    
    if onlyOne then
        local biggestValue = -1
        for _, value in pairs(svT) do
            if value > biggestValue then biggestValue = value end
        end
        return biggestValue
    end
    return svT
end

function setAccountSV(accID, sv, v)
    local playerGUIDT = getGuidTByAccID(accID)

    for _, guid in pairs(playerGUIDT) do
        local playerData = db.storeQuery("SELECT `value` FROM `player_storage` WHERE `player_id` = "..guid.." AND `key` = "..sv)
        local charName = getPlayerNameByGUID(guid)
        
        if Player(charName) then
            setSV(charName, sv, v)
            playerSave(charName)
        elseif playerData then
            db.query("UPDATE `player_storage` SET `value` = "..v.." WHERE `key` = "..sv.." AND `player_id` = "..guid)
        else
            db.query("INSERT INTO `player_storage`(`player_id`, `key`, `value`) VALUES ("..guid..","..sv..","..v..")")
        end
    end
end

function getButtonState(player, sv) return getSV(player, sv) == 1 and "OFF" or "ON" end
function getAnswerState(player, sv) return getSV(player, sv) == 1 and "YES" or "NO" end
function toggleSV(player, sv) 
    if getSV(player, sv) ~= 1 then return 1, setSV(player, sv, 1) end
    return -1, removeSV(player, sv)
end

function capRemove(playerID, amount)
    local player = Player(playerID)
    if not player then return end
    player:setCapacity(player:getCapacity() - amount*100)
end

function Player.checkWeight(player, weight, errorMsg)
    if player:getFreeCapacity() >= weight then return true end
    local weightErrorMsg = errorMsg or "You found something, but its weights "..math.floor(weight/100).." cap."
    player:sendTextMessage(GREEN, weightErrorMsg)
end

function checkWeight(player, itemTable, weightErrorMsg)
    if not itemTable then return true end
    if itemTable.itemID then itemTable = {itemTable} end
    local totalWeight = 0

    for _, itemT in pairs(itemTable) do
        local itemCount =  itemT.count or 1
        local itemWeight = ItemType(itemT.itemID):getWeight() * itemCount
        totalWeight = itemWeight + itemCount
    end
    return player:checkWeight(totalWeight, weightErrorMsg)
end

function ownerIsPlayer(player, fromPos)
    if not player then return end
    if fromPos.x ~= CONTAINER_POSITION then return end
    if bit.band(fromPos.y, BIT_CONTAINER) ~= 64 then return end
    local container = player:getContainerById(bit.band(fromPos.y, BIT_CONTAINER_ID))
    return container:getTopParent() == player
end

function Player.isPzLocked(player) return Tile(player:getPosition()):isPzLocked() end

function Player.isOwner(player, item)
    local accountID = item:getText("accountID")
    if not accountID or accountID == player:getAccountId() then return true end
    player:sendTextMessage(GREEN, item:getName().." is not your item")
end

function Player.isEquipped(player, itemID, slot)
    if slot then
        local item = player:getSlotItem(slot)
        if item and item:getId() == itemID then return item end
    else
        for x=1, 13 do
            local item = player:getSlotItem(x)
            if item and item:getId() == itemID then return item end
        end
    end
end

function Player.isPartyLeader(player)
    local party = player:getParty()
    return party and party:getLeader():getId() == player:getId()
end

function Player.isSilenced(player) return getSV(player, SV.silenced) == 1 or findItem(nil, player:getPosition(), AID.jazmaz.monsters.seaHero_field) end

function Player.isVocation(player, neededVocation)
    if player:isGod() then return true end
    if not neededVocation then return true end
    if type(neededVocation) == "string" and neededVocation == "all" then return true end
    if type(neededVocation) ~= "table" then neededVocation = {neededVocation} end
    local playerVocation = player:getVocation():getName():lower()
    return playerVocation == "none" or isInArray(neededVocation, playerVocation)
end

function global_playerSave(minutesPassed) return minutesPassed%15 == 0 and playerSave() end

function playerSave(playerID)
    if not playerID then
        local players = Game.getPlayers()
        local garbageDeleted = garbageCollection()
        
        for k, player in pairs(players) do player:save() end
        if garbageDeleted > 0 then print(garbageDeleted.. " unused tables deleted") end
    else
        local player = Player(playerID)
        if player then player:save() end
    end
end

function Player.hasBagRoom(player, amount)
    local bag = player:getBag()
    return bag and bag:getEmptySlots() >= (amount or 1)
end

function Player.getEmptySlots(player)
    local bag = player:getBag()
    return bag and bag:getEmptySlots() or 0
end

msgSpamFilter = {}
function doSendTextMessage(playerID, messageType, message, spamTime)
    local player = Player(playerID)
    if not player then return end

    if spamTime then
        if not msgSpamFilter[message] then msgSpamFilter[message] = {} end
        if msgSpamFilter[message][playerID] then return end
        msgSpamFilter[message][playerID] = true
        addEvent(setTableVariable, spamTime, msgSpamFilter[message], playerID, false)
    end
    messageType = messageType or GREEN
    player:sendTextMessage(messageType, message)
end

function Player.frontPos(player, yards)
    local playerPos = player:getPosition()
    local direction = player:getDirection()
    local tempPosX = playerPos.x
    local tempPosY = playerPos.y
    local tempPosZ = playerPos.z
    local yards = yards or 1

    if direction == 0 then return {x=tempPosX, y=tempPosY-yards, z=tempPosZ} end
    if direction == 1 then return {x=tempPosX+yards, y=tempPosY, z=tempPosZ} end
    if direction == 2 then return {x=tempPosX, y=tempPosY+yards, z=tempPosZ} end
    if direction == 3 then return {x=tempPosX-yards, y=tempPosY, z=tempPosZ} end
end

checkPoints = {
    [1] = {name = "tutorial prepartion room", pos = {x = 470, y = 778, z = 8}},
    [2] = {name = "tutorial prepartion room 2", pos = {x = 494, y = 783, z = 8}},
    [3] = {name = "map start", pos = {x = 524, y = 737, z = 8}},
    [4] = {name = "tutorial exit", pos = {x = 554, y = 705, z = 8}},
    [5] = {name = "Forgotten Village", pos = {x = 573, y = 657, z = 7}},    
}

function Player.homePos(player) return player:getCheckPointPos() end
function Player.getCheckPointT(player) return checkPoints[getSV(player, SV.checkPoint)] end
function Player.getCheckPointID(player) return getSV(player, SV.checkPoint) end

function Player.getCheckPointName(player)
    local t = player:getCheckPointT()    
    return t and t.name
end

function Player.getCheckPointPos(player)
    local t = player:getCheckPointT()
    return t and t.pos or {x = 525, y = 737, z = 8} -- tutorial Pos
end

function createMW(player, mwID, param1, param2) return player and Player:createMW(mwID, param1, param2) end
function Player.createMW(player, mwID, param1, param2) return modalWindows_createMW(player, mwID, param1, param2) end

function Player.hasFood(player)
    if not player:getBag() then return end
    if player:getItemCount(2006, nil, 1) > 0 then return true end
    
    for _, itemID in pairs(allTheFood) do
        if player:getItemCount(itemID, AID.other.food) > 0 then return true end
    end
end

function Player.getShieldingLevel(player) return player:getEffectiveSkillLevel(SKILL_SHIELD) end
function Player.getDistanceLevel(player) return player:getEffectiveSkillLevel(SKILL_DISTANCE) end
function Player.getWeaponLevel(player) return player:getEffectiveSkillLevel(SKILL_SWORD) end
function Player.getHandcombatLevel(player) return player:getEffectiveSkillLevel(SKILL_FIST) end

function Player.getArmor(player)
    local itemSlotPos = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET}
    local valueSpells = {SV.armorUpSpell, SV.yashimakiArmor}
    local totalArmor = 0

    totalArmor = totalArmor + potions_speedPotion_armor(player)
    totalArmor = totalArmor + potions_knight_armor(player)
    totalArmor = totalArmor + food_getArmorBonus(player)
    totalArmor = totalArmor + bladed_armor(player)
    totalArmor = totalArmor + shikaraNankan(player)
    totalArmor = totalArmor + blessedIronHelmet_armor(player)
    totalArmor = totalArmor + player:getSetItemsStats("armor")
    
    for _, slot in pairs(itemSlotPos) do
        local item = player:getSlotItem(slot)
        
        if item then
            totalArmor = totalArmor + item:getStat("armor")
            totalArmor = totalArmor + armorStone(item)
        end
    end
    
    for _, sv in ipairs(valueSpells) do
        if getSV(player, sv) > 0 then totalArmor = totalArmor + getSV(player, sv) end
    end 
    
    if player:isKnight() then totalArmor = math.ceil(totalArmor * 1.5) end -- Knight passive
    return totalArmor
end

function Player.getDefence(player)
    local totalDefense = 0
    local shield = player:getSlotItem(CONST_SLOT_RIGHT)
    
    -- DEFENSE from items --
    if shield then
        totalDefense = totalDefense + shield:getStat("def")
        totalDefense = totalDefense + (shield:getText("def") or 0)
        totalDefense = totalDefense + bladed_shield(player)
        totalDefense = totalDefense + defenceStone(player)
        totalDefense = totalDefense + critBlock(player, totalDefense)
    end
    return totalDefense
end

function Player.getCriticalBlock(player)
    local chance = 0

    chance = chance + accuracy(player)
    chance = chance + criticalBlockStone(player)
    chance = chance + momentum(player)
    chance = chance + player:getStatFromItems("cbv")
    chance = chance + critStone(player)
    return chance
end

function Player.getCriticalHit(player)
    local chance = 0

    chance = chance + accuracy(player)
    chance = chance + sharp_shooter(player)
    chance = chance + chivitBoots(player)
    chance = chance + player:getStatFromItems("ccv")
    chance = chance + critStone(player)
    chance = chance + momentum(player)
    return chance
end

function Player.getCriticalHeal(player)
    local chance = 0
    
    chance = chance + accuracy(player)
    chance = chance + innervatePassive(player)
    chance = chance + player:getStatFromItems("cH")
    chance = chance + critStone(player)
    chance = chance + momentum(player)
    chance = chance + pinpuaHood(player, chance)
    return chance
end

function Player.getMissChance(player)
    local chance = player:getSV(SV.tutorial) == 1 and 0 or 7

    chance = chance + player:getDefence()
    chance = chance + player:getLevel()
    chance = chance - player:getDistanceLevel()
    return chance < 0 and 0 or chance
end

function Player.getResistance(player, resType, printMode)
    local totalResistance = 0
    local specificResTypeT = {
        fire = {
            getSV(player, SV.tempFireResistance),
            getSV(player, SV.tutorial_fireRes),
        },
        ice = {
            getSV(player, SV.tempIceResistance),
            getSV(player, SV.tutorial_iceRes),
        },
        death = {
            getSV(player, SV.tempDeathResistance),
            getSV(player, SV.kamikazeMaskResistance),
        },
        energy = {getSV(player, SV.tempEnergyResistance)},
        earth = {getSV(player, SV.tempEarthResistance)},
        physical = {getSV(player, SV.tempPhysicalResistance)},
        undead = {getSV(player, SV.cursedBearQuest_undeadRes)},
    }
    if printMode then Tprint("getResistance error - "..resType) end

    if specificResTypeT[resType] then
        for _, value in ipairs(specificResTypeT[resType]) do
            if value > 0 then totalResistance = totalResistance + value end
        end
    end

    totalResistance = totalResistance + potions_antidote_res(player, resType)
    totalResistance = totalResistance + potions_silence_resistance(player, resType)
    totalResistance = totalResistance + getTempResByCid(player, getEleTypeEnum(resType))
    totalResistance = totalResistance + ghatitkLegs_resistance(player, resType)
    totalResistance = totalResistance + gribitLegs(player, getEleTypeEnum(resType))
    totalResistance = totalResistance + gems_getResistance(player, resType)
    totalResistance = totalResistance + player:getStatFromItems(resType.."Res")
    totalResistance = totalResistance + player:getSetItemsStats(resType.."Res")
    if player:isDruid() or player:isMage() then
        totalResistance = totalResistance + percentage(totalResistance, 25, true)
    end
    return totalResistance
end

function Player.getStunRes(player) return player:getResistance("stun") end
function Player.getSlowRes(player) return player:getResistance("slow") end
function Player.getSilenceRes(player) return player:getResistance("silence") end

function Player.getExtraElementalDamage(player, damType, currentDamage)
    local totalExtraDamage = 0
    local weapon = player:getSlotItem(6)
    local damType = type(damType) == "number" and getEleTypeByEnum(damType):lower() or damType:lower()
    local svExtraDamage = {
        fire = {SV.extraFireDamage},
        ice = {SV.extraIceDamage},
        death = {SV.extraDeathDamage},
        energy = {SV.extraEnergyDamage},
        earth = {SV.extraEarthDamage},
        physical = {SV.extraPhysicalDamage},
    }
    if svExtraDamage[damType] then
        for _, sv in ipairs(svExtraDamage[damType]) do
            local value = player:getSV(sv)
            if value > 0 then totalExtraDamage = totalExtraDamage + value end
        end
    end
    
    if weapon then
        local weaponGemPercent = gems_getCount(weapon)
        if weaponGemPercent > 0 then totalExtraDamage = totalExtraDamage + percentage(currentDamage, weaponGemPercent + fireGem(player, damType)) end
    end
    return totalExtraDamage
end

function Player.getDamagePerSecond(player)
    local weapon = player:getSlotItem(SLOT_LEFT)
    local weaponT = getWeaponT(weapon)
    if not weaponT then return 2 end
    
    local minDam, maxDam = getWeaponBaseDamage(player)
    if maxDam < 2 then return 2 end

    local avgDamage = (minDam + maxDam) / 2
    
    if weaponT.damType == PHYSICAL then
        local critChance = player:getCriticalHit()
        
        if critChance > 0 then
            local averageCritDamage = math.floor(avgDamage/critChance)
            avgDamage = avgDamage + averageCritDamage
        end
    end

    local currentAS = addWeaponCooldown(player, weaponT)
    return math.floor(avgDamage/(currentAS/1000))
end

local function singleStatValue(player, stat, statTable)
    local statValue = statTable[stat]
    
    if not statValue then
        local newStatT = {}
        local i = 0
        
        for statName, v in pairs(statTable) do
            i = i + 1
            newStatT[i] = statName
        end
        player:sendTextMessage(ORANGE, "statList: "..tableToStr(newStatT, ", "))
        return player:sendTextMessage(GREEN, "wrong stat value")
    end
    player:say("checking stats", ORANGE)
    return player:sendTextMessage(ORANGE, stat..": "..statValue)
end

local function getVocationBonusString(player)
    local vocationName = player:getVocation():getName()

    if vocationName == "mage" or vocationName == "druid" then
        return "\nclass passive: Your resistance values are increased by 25%\nvocation passive: dealing 50 less damage with melee weapons"
    end

    if vocationName == "knight" then
        return "\nclass passive: Your armor is increaseed by 50%\nvocation passive: using magic weapons takes 4 mana per hit"
    end

    if vocationName == "hunter" then
        return "\nclass passive: you deal 50% less damage with weapons in close range\nvocation passive: your distance skill increases ranged weapon maximum damage by 5\nvocation passive: your weapon skill increases ranged weapon minimum damage by 5"
    end
    return "\nclass passive: You don't have one :("
end

function Player.displayStats(player, targetPlayer, stat)
    local targetPlayer = targetPlayer or player
    local statTable = targetPlayer:getStats()
    
    if stat and stat ~= "" then return singleStatValue(targetPlayer, stat, statTable) end
    local text = " |->>>-| "..targetPlayer:getName().." STATS |-<<<-| "
    local weapon = targetPlayer:getSlotItem(SLOT_LEFT)
    local sayMsg = targetPlayer:getId() == player:getId() and "checking stats" or "checking "..targetPlayer:getName().." stats"

    text = text..getVocationBonusString(targetPlayer)
    text = text.."\ndamage type: "..getDamageType(targetPlayer)
    text = text.."\ndamage per second: "..targetPlayer:getDamagePerSecond()
    if weapon and weapon:isRangeWeapon() then text = text.."\nmiss chance: "..targetPlayer:getMissChance().."%" end
    text = text..items_parseStatT(statTable)
    player:say(sayMsg, ORANGE)
    return player:sendTextMessage(ORANGE, text)
end

playerFriendList = {}
function Player.getFriends(player, distance)
    local playerID = player:getId()
    local friendList = playerFriendList[playerID]
    local pos = player:getPosition()
    
    if friendList then
        clean_cidList(friendList)
        friendList = sortCreatureListByDistance(pos, friendList, distance)
        return friendList
    else
        friendList = {}
        for _, player in pairs(Game:getPlayers()) do
            local pid = player:getId()
            if pid ~= playerID then table.insert(friendList, pid) end
        end
    end
    playerFriendList[playerID] = friendList
    addEvent(setTableVariable, 4000, playerFriendList, playerID, nil)
    friendList = sortCreatureListByDistance(pos, friendList, distance)
    return friendList
end

function Player.getOnlineTime(player, logOut) return updateOnlineTime(player, (logOut or false)) end

function updateOnlineTime(player, logOut)
    local loggedInTime = player:getSV(SV.lastLogInTime)
    local totalOnlineTime = player:getSV(SV.onlineTime)
    
    if loggedInTime < 10^9 then return 0, print("loggedInTime is suddently fucked up: "..loggedInTime) end
    if totalOnlineTime > 10^6 then
        print("online time is messed up ["..totalOnlineTime.."] Restarted it")
        player:removeSV(SV.onlineTime)
        return 0
    end

    local currentTime = os.time()
    local onlineTime = currentTime - loggedInTime
    
    if logOut or logOut == nil then
        print(player:getName().." was online "..getTimeText(onlineTime).." | logged out: "..getCurrentTime())
        player:setSV(SV.lastLogInTime, currentTime)
        player:addSV(SV.onlineTime, onlineTime)
    end
    return onlineTime + totalOnlineTime
end

function Player.getPartyMembers(player, distance) return getPartyMembers(player, distance) end

function getPartyMembers(player, distance)
    local party = player:getParty()
    if not party then return {[player:getGuid()] = player:getId()} end
    local playerPos = player:getPosition()
    local entireParty = party:getMembers()
    local partyMembers = {}

    table.insert(entireParty, party:getLeader())
    for _, member in pairs(entireParty) do
        if distance then
            if getDistanceBetween(playerPos, member:getPosition()) < distance then
                partyMembers[member:getGuid()] = member:getId()
            end
        else
            partyMembers[member:getGuid()] = member:getId()
        end
    end
    return partyMembers
end

function checkPartyDistanceFromPlayer(player, distance)
    if not distance then return true, print("missing distance in checkPartyDistanceFromPlayer()") end
    local partyMembers = getPartyMembers(player)
    local totalMembers = tableCount(partyMembers)
    local playerPos = player:getPosition()
    local missingMembers = {}

    for guid, pid in pairs(partyMembers) do
        local member = Player(pid)
        if getDistanceBetween(playerPos, member:getPosition()) > distance then table.insert(missingMembers, member:getName()) end
    end
    
    if #missingMembers == 0 then return end
    local memberString = ""
    
    for i, name in pairs(missingMembers) do
        if i > 1 then
            memberString = ", "..memberString
        else
            memberString = name
        end
    end
    return memberString
end

local function getTotalExp(level)
    local nextExp = (50*level*level*level/3) - (100*level*level) + (850*level/3) - 200
    return nextExp > 0 and nextExp or 0
end

function Player.addExpPercent(player, percent)
    local L = player:getLevel()
    local totalExp = getTotalExp(L+1)
    local expNeeded = totalExp - getTotalExp(L)
    local playerExp = player:getExperience()
    local missingExp = math.ceil(totalExp - playerExp)
    local addExp = percentage(expNeeded, percent)

    if addExp > missingExp then
        local nextTotalExp = getTotalExp(L+2)
        local newExpNeeded = nextTotalExp - getTotalExp(L+1)
        local usedPercent = math.ceil(100/(expNeeded/missingExp))
        local extraExp = percentage(newExpNeeded, percent - usedPercent)
        addExp = missingExp + extraExp
    end
    
    if addExp < 1 then return print("addExpPercent wanted to crash!") end
    player:addExperience(addExp)
    player:sendTextMessage(ORANGE, "You earned: "..percent.."% experience.")
end

function Player.removeExpPercent(player, percent)
    local L = player:getLevel()
    local totalExp = getTotalExp(L+1)
    local playerExp = player:getExperience()
    local expNeeded = totalExp - getTotalExp(L)
    local currentExp = math.floor(expNeeded - (totalExp - playerExp))
    if currentExp < 1 then currentExp = 0 end
    local removeExp = percentage(expNeeded, percent)

    if removeExp > currentExp then
        local nextTotalExp = getTotalExp(L)
        local newExpNeeded = nextTotalExp - getTotalExp(L-1)
        local usedPercent = currentExp == 0 and 0 or percent - math.floor(100/removeExp/currentExp)
        local extraExp = percentage(newExpNeeded, percent - usedPercent)
        removeExp = currentExp + extraExp
    end
    
    if removeExp < 1 then return print("ERROR - removeExpPercent wanted to crash!") end
    player:removeExperience(removeExp)
    player:sendTextMessage(ORANGE, "You lost: "..percent.."% experience.")
end

function Player.getDepot(player) return player:getDepotChest(0, true) end
function Player.getBag(player) return player:getSlotItem(SLOT_BACKPACK) end

function Player.hasItems(player, itemList, need1)
    if not itemList then return true end
    if itemList.itemID or itemList.itemAID then itemList = {itemList} end
    
    for _, itemT in pairs(itemList) do
        if not itemT.itemID and not itemT.itemAID then return true end
        local count = itemT.count or 1
        
        if type(itemT.itemID) == "table" then
            local itemFound = false
            for _, itemID in ipairs(itemT.itemID) do
                local itemCount = player:getItemCount(itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer)
                
                if itemCount >= count then
                    if need1 then return true end
                    itemFound = true
                    break
                end
            end
            if not itemFound then return end
        else
            if need1 then
                if player:getItemCount(itemT.itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer) >= count then return true end
            elseif player:getItemCount(itemT.itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer) < count then
                return false
            end
        end
    end
    if not need1 then return true end
end

function Player.getItem(player, itemID, itemAID, searchBag, searchPlayer)
    if searchPlayer ~= false then
        for x=0, 13 do
            local item = player:getSlotItem(x)
            
            if item and compare(item:getId(), itemID) and compare(item:getActionId(), itemAID) then return item end
        end
    end
    
    if searchBag ~= false then
        local bag = player:getBag()
        
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                if compare(item:getId(), itemID) and compare(item:getActionId(), itemAID) then return item end
            end
        end
    end
end

function Player.giveItem(player, itemID, count, itemAID, fluidType, itemText)
    local itemType = ItemType(itemID)
    if itemType:getId() == 0 then return print("ERROR in giveItem() - item with ID: "..itemID..", does not exist in game") end
    local fillSlotsBags = {gemBagConf.itemID, herbBagConf.itemID, seedBagConf.itemID}
    local playerPos = player:getPosition()

    if isInArray(fillSlotsBags, itemID) then
        local specialBag = makeItem(player, itemID, nil, 1, itemAID, nil, itemText)
        if not specialBag then
            return print("ERROR - special bag doesnt exist? "..tostring(specialBag).." - itemID: "..itemID.." itemAID: "..tostring(itemAID))
        end
        if specialBag:isContainer(true) then specialBag:addItem(11754, 1) end
        specialBag:setText("accountID", player:getAccountId())
        return specialBag
    end
    local bag = player:getBag()
    local count = count or 1

    if not bag then
        if itemType:isContainer() and not itemIsSpecialBag(itemID) then return makeItem(player, itemID, nil, 1, itemAID, nil, itemText) end
        if isProjectile(itemID) or itemID == 2051 or itemID == 2467 then return makeItem(player, itemID, nil, count, itemAID, nil, itemText) end
        return createItem(itemID, playerPos, count, itemAID, fluidType, itemText, player)
    end
    
    local emptySlots = bag:getEmptySlots(false)
    
    if itemType:isStackable() then
        local stackedItem = player:getItem(itemID, itemAID)
        if stackedItem then
            count = count + stackedItem:getCount()
            stackedItem:remove()
            return makeItem(player, itemID, nil, count, itemAID, fluidType, itemText)
        end
        if emptySlots == 0 and not isProjectile(itemID) then return createItem(itemID, playerPos, count, itemAID, fluidType, itemText, player) end
        return makeItem(player, itemID, nil, count, itemAID, fluidType, itemText)
    end
    
    if emptySlots < count then return createItem(itemID, playerPos, count, itemAID, fluidType, itemText, player) end
    
    if isInArray(allNormalBags, itemID) then
        local tokenBag = player:addItem(9076, 1)
        tokenBag:setText("tokenBag", itemID)
        return tokenBag
    end
    
    return makeItem(player, itemID, nil, count, itemAID, fluidType, itemText)
end

function Player.rewardItems(player, itemList, dontCheckWeight, weightErrorMsg)
    if not itemList then return end
    if itemList.itemID then itemList = {itemList} end
    
    if not dontCheckWeight and not checkWeight(player, itemList, weightErrorMsg) then return end
    
    for _, itemT in pairs(itemList) do
        local count = itemT.count or 1
        local itemID = itemT.itemID
        local itemAID = itemT.itemAID
        local itemType = itemT.type or itemT.fluidType
        local TEXT = itemT.itemText
        local itemName = itemT.itemName or ItemType(itemID):getName()
        
        if type(itemID) == "table" then itemID = itemID[math.random(1, #itemID)] end
        if type(itemAID) == "table" then itemAID = itemAID[math.random(1, #itemAID)] end
        player:giveItem(itemID, count, itemAID, itemType, TEXT)
        player:sendTextMessage(ORANGE, "You obtained: "..plural(itemName, count))
    end
    return true
end

function Player.getItemCount(player, itemID, itemAID, fluidType, dontCheckPlayer)
    local bag = player:getBag()
    local itemsFound = 0
    
     local function countItem(item)
        if compare(item:getId(), itemID) and compare(item:getActionId(), itemAID) and compare(item:getFluidType(), fluidType) then
            itemsFound = itemsFound + item:getCount()
        end
    end

    if not dontCheckPlayer then
        for x=0, 13 do
            local item = player:getSlotItem(x)
            
            if item then countItem(item) end
        end
    end
    
    if not bag then return itemsFound end
    for x=0, bag:getSize() do
        local item = bag:getItem(x)
        
        if not item then break end
        countItem(item)
    end
    return itemsFound
end

function Player.removeItem(player, itemID, count, itemAID, fluidType, dontCheckPlayer)
    if not count then count = 1 end
    if count == 0 then return true end
    local bag = player:getBag()
    
    if not bag then return end
    local itemCount = player:getItemCount(itemID, itemAID, fluidType, dontCheckPlayer)
    
    if type(count) == "string" and count == "all" then count = itemCount end
    if itemCount < count then return end
    local itemsRemoved = 0
    local movedCylinder = 0
    
    for x=0, bag:getSize() do
        local item = bag:getItem(x-movedCylinder)
        
        if itemsRemoved >= count then
            if itemsRemoved > count then
                local leftovers = itemsRemoved - count
                player:giveItem(itemID, leftovers, itemAID, fluidType)
            end
            return true
        end
        
        if item then
            if compare(item:getId(), itemID) and compare(item:getActionId(), itemAID) and compare(item:getFluidType(), fluidType) then
                itemsRemoved = itemsRemoved+item:getCount()
                movedCylinder = movedCylinder+1
                item:remove()
            end
        end
    end
    
    if not dontCheckPlayer then
        for x=0, 13 do
            local item = player:getSlotItem(x)
            
            if item then
                if compare(item:getId(), itemID) and compare(item:getActionId(), itemAID) and compare(item:getFluidType(), fluidType) then
                    itemsRemoved = itemsRemoved + item:getCount()
                    item:remove()
                end
            end
        end
    end
    
    if itemsRemoved < count then
        print("removeItem, got somehow passed even though player didnt have enough items..")
        return false, player:sendTextMessage(BLUE, "If you see this message then report this to me(Whitevo) and tell me to look console, because one of the scripts is FUCKED UP")
    end
end

function Player.removeItemList(player, itemList, removeOnly1)
    if not itemList then return true end
    if itemList.itemID or itemList.itemAID then itemList = {itemList} end
    if not player.hasItems(itemList, removeOnly1) then return end
    local totalItems = tableCount(itemList)
    local itemsRemoved = 0
        
    for _, itemT in pairs(itemList) do
        if not itemT.itemID and not itemT.itemAID then return true end
        local fluidType = itemT.type or itemT.fluidType
        
        if type(itemT.itemID) == "table" then
            for _, itemID in ipairs(itemT.itemID) do
                local itemCount = player:getItemCount(itemID, itemT.itemAID, fluidType, itemT.dontCheckPlayer)
                
                if player:removeItem(itemID, itemT.count, itemT.itemAID, fluidType, itemT.dontCheckPlayer) then
                    itemsRemoved = itemsRemoved + 1
                    break
                end
            end
        else
            if player:removeItem(itemT.itemID, itemT.count, itemT.itemAID, fluidType, itemT.dontCheckPlayer) then itemsRemoved = itemsRemoved + 1 end
        end
        if itemsRemoved == totalItems then return true end
    end
end

function removeItemOutOfBag(player, item, fromPos, pos) -- even extension function
    if not item:hasCustomWeight() then return end
    if not ownerIsPlayer(player, fromPos) then return end
    if ownerIsPlayer(player, pos) then return end
    local customWeight = item:getCustomWeight()
    local originalWeight = item:getWeight()
    local weight = customWeight - originalWeight
    
    return player:changeWeight(weight)
end

function pickUpItem(player, item)
    if not player:isPlayer() then return end
    local itemID = item:getId()
    local count = item:getCount()
    local weight = ItemType(itemID):getWeight()
    local freeCap = player:getFreeCapacity()

    if weight > freeCap then return end
    if weight*count > freeCap then count = math.floor(freeCap/weight) end
    player:say("*grab*", ORANGE)
    item:remove(count)
    if player:getEmptySlots() > 0 then return player:giveItem(itemID, count) end
    
    local item = player:getItem(itemID)
    if not item then return player:giveItem(itemID, count) end

    local currentCount = item:getCount()
    local newCount = currentCount + count
    local leftOvers = 0
    
    if newCount > 100 then
        newCount = 100
        leftOvers = newCount-100
    end
    item:remove()
    player:giveItem(itemID, newCount)
    if leftOvers > 0 then player:giveItem(itemID, leftOvers) end
end

function canInviteToParty(player, target) return player and player:canInviteToParty(target, true) end
function canJoinParty(player, target) return player and player:canJoinParty(target, true) end

local function errorMsg(player, msg, dontShow) return false, not dontShow and player:sendTextMessage(GREEN, msg) end

function Player.canInviteToParty(player, target, dontShowErrorMsg)
    if not target then return end
    if target:getParty() then return errorMsg(player, target:getName().." is already in a party", dontShowErrorMsg) end
    local party = player:getParty()
    if not party then return true end
    if party:getLeader():getId() ~= player:getId() then return errorMsg(player, "Only party leader can invite", dontShowErrorMsg) end

    local targetID = target:getId()
    for _, invitee in ipairs(party:getInvitees()) do
        if invitee:getId() == targetID then return errorMsg(player, "You have already invited "..target:getName().." to your party", dontShowErrorMsg) end
    end
    return true
end

function Player.canJoinParty(player, target, dontShowErrorMsg)
    if not target then return end
    if player:getParty() then return end
    local party = target:getParty()
    if not party then return errorMsg(player, target:getName().." doesn't have a party", dontShowErrorMsg) end

    local playerID = player:getId()    
    for _, invitee in ipairs(party:getInvitees()) do
        if invitee:getId() == playerID then return true end
    end
end

function inviteToParty(partyOwner, invitee)
    if testServer() then return print("ERROR - no party features in test server") end
    local party = partyOwner:getParty() or Party(partyOwner)
    party:addInvite(invitee)
end

function addMemberToParty(partyOwner, invitee) return playerOwner:getParty():addMember(invitee) end