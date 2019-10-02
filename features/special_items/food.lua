function food_drinkWater(player, item, itemEx)
    if itemEx:getId() ~= player:getId() then return end
    if item:getId() ~= 2006 then return player:sendTextMessage(GREEN, "Don't want to drink from that") end
    if item:getFluidType() == 0 then return player:sendTextMessage(GREEN, "The container is empty") end
    if item:getFluidType() ~= 1 then return player:sendTextMessage(GREEN, "Don't want to drink that") end
    food_onUse(player, item)
end

function food_onUse(player, item)
    local foodT = food_getFoodT(item)
    if not foodT then return end
    local vocModT = food_getVocModT(player)
    local healthLimit = player:getMaxHealth()
    local vocationHP = vocModT.extraHP or 0
    local totalHealthRegen = food_getTotalHealthRegen(player)
    local addTotalHealthAmount = (vocationHP + foodT.hp) * foodT.duration
    if totalHealthRegen + addTotalHealthAmount > healthLimit then return player:sendTextMessage(GREEN, "I'm full, don't feel like eating more.") end
    local manaLimit = player:getMaxMana()
    local vocationMP = vocModT.extraMP or 0
    local totalManaRegen = food_getTotalManaRegen(player)
    local addTotalManaAmount = (vocationMP + foodT.mp) * foodT.duration

    if totalManaRegen + addTotalManaAmount > manaLimit then return player:sendTextMessage(GREEN, "I'm full, don't feel like eating more.") end
    food_register(player, item, foodT)
    food_activate(player)
    player:say(foodT.word, ORANGE)
    food_acticateSpice(player, item, foodT)
    food_activateDish(player, foodT.effect)
    if not fluidContainer_empty(item) then item:remove(1) end
end

local function totalAmount(player, tableKey) -- tableKey = "hp" or "mp"
    local foodT = registratedFood[player:getId()]
    local totalAmount = 0
    if not foodT then return totalAmount end
    local regenT = foodT[tableKey]
    if not regenT then return totalAmount end
    local currentTime = os.time()
    local vocModT = food_getVocModT(player)
    local extraAmount = vocModT["extra"..tableKey:upper()] or 0
    local speedMod = vocModT.speed or 0

    for amount, regenT in pairs(regenT) do
        if amount > 0 then
            local secondsLeft = regenT.duration - (currentTime - regenT.startTime)
            if speedMod > 0 then secondsLeft = math.floor(secondsLeft*(1+speedMod/1000)) end
            totalAmount = totalAmount + (extraAmount+amount)*secondsLeft
        end
    end
    return totalAmount
end

function food_getVocModT(player) return foodConf.foodVocationModifier[player:getVocation():getName():lower()] or {} end
function food_getTotalManaRegen(player) return totalAmount(player, "mp") end
function food_getTotalHealthRegen(player) return totalAmount(player, "hp") end

function food_register(player, item, food)
    local playerID = player:getId()
    local foodHP = food.hp + food_getSpiceBonus(item, food, "extraHP")
    local foodMP = food.mp + food_getSpiceBonus(item, food, "extraMP")
    local duration = food.duration + food_getSpiceBonus(item, food, "extraDuration")
    local currentTime = os.time()
    local regFoodT = registratedFood[playerID]

    if not regFoodT then
        registratedFood[playerID] = {
            ["hp"] = {[foodHP] = {duration = duration, startTime = currentTime}},
            ["mp"] = {[foodMP] = {duration = duration, startTime = currentTime}},
        }
        return
    end
    local bestHP = getBestRegistratedHP(playerID)
    local bestMP = getBestRegistratedMP(playerID)
    local allHPT = regFoodT["hp"]
    local allMPT = regFoodT["mp"]
    local hpTable = allHPT[foodHP]
    local mpTable = allMPT[foodMP]
        
    if hpTable then
        if bestHP > 0 and bestHP == foodHP then
            local passedTime = currentTime - hpTable.startTime
            local timeLeft = hpTable.duration - passedTime
            allHPT[bestHP].duration = timeLeft + duration
        else
            local currentDuration = hpTable.duration
            hpTable.duration = currentDuration+duration
        end
        hpTable.startTime = currentTime
    else
        if bestHP > 0 then
            local t = allHPT[bestHP]
            local passedTime = currentTime - t.startTime
            local timeLeft = t.duration - passedTime
            t.duration = timeLeft
        end
        allHPT[foodHP] = {duration = duration, startTime = currentTime}
    end
    
    if mpTable then
        if bestMP > 0 and bestMP == foodMP then
            local passedTime = currentTime - mpTable.startTime
            local timeLeft = mpTable.duration - passedTime
            allMPT[bestMP].duration = timeLeft + duration
        else
            local currentDuration = mpTable.duration
            mpTable.duration = currentDuration+duration
        end
        mpTable.startTime = currentTime
    else
        if bestMP > 0 then
            local t = allMPT[bestMP]
            local passedTime = currentTime - t.startTime
            local timeLeft = t.duration - passedTime
            t.duration = timeLeft
        end
        allMPT[foodMP] = {duration = duration, startTime = currentTime}
    end
end

function food_activate(player)
    local playerID = player:getId()
    if not registratedFood[playerID] then return unregisterEvent(player, "onThink", "food_onThink") end
    food_update(playerID)
    local bestHP = getBestRegistratedHP(playerID)
    local bestMP = getBestRegistratedMP(playerID)
    if bestHP == 0 and bestMP == 0 then return unregisterEvent(player, "onThink", "food_onThink") end
    local HPduration = getRegistratedHPFoodDuration(playerID, bestHP)
    local MPduration = getRegistratedMPFoodDuration(playerID, bestMP)
    local vocModT = food_getVocModT(player)
    local speedMod = vocModT.speed or 0
    local vocHP = vocModT.extraHP or 0
    local vocMP = vocModT.extraMP or 0

    if not onThinkFood[playerID] then onThinkFood[playerID] = {} end
    local onThinkT = onThinkFood[playerID]
    registerEvent(player, "onThink", "food_onThink")
    onThinkT.timer = 0
    
    if HPduration < MPduration and bestHP ~= 0 then
        onThinkT.duration = HPduration + 1
    else
        onThinkT.duration = MPduration + 1
    end

    if bestHP > 0 then
      --  removeCondition(player, "foodHP") not sure can they stay removed?
        bindCondition(playerID, "foodHP", HPduration*1000, {gainHP = bestHP+vocHP, HPinterval = 1000-speedMod})
    end
    
    if bestMP > 0 then
      --  removeCondition(player, "foodMP")
        bindCondition(playerID, "foodMP", MPduration*1000, {gainMP = bestMP+vocMP, MPinterval = 1000-speedMod})
    end
end

function food_update(playerID, skipHPtable, skipMPtable)
    local currentTime = os.time()
    local bestHP = getBestRegistratedHP(playerID)
    local bestMP = getBestRegistratedMP(playerID)
    local regFoodT = registratedFood[playerID]
    if not regFoodT then return end
    local allHPT = regFoodT["hp"]
    local allMPT = regFoodT["mp"]
    local hpTable = allHPT[bestHP]
    local mpTable = allMPT[bestMP]

    if hpTable and not skipHPtable then
        local passedTime = currentTime - hpTable.startTime
        if passedTime < hpTable.duration then
            local timeLeft = hpTable.duration-passedTime
            hpTable.duration = timeLeft
        elseif bestHP ~= 0 then
            allHPT[bestHP] = nil
            return food_update(playerID, true)
        else
            allHPT[bestHP] = nil
        end
    end
    
    if mpTable and not skipMPtable then
        local passedTime = currentTime - mpTable.startTime
        if passedTime < mpTable.duration then
            local timeLeft = mpTable.duration-passedTime
            mpTable.duration = timeLeft
        elseif bestMP ~= 0 then
            allMPT[bestMP] = nil
            return food_update(playerID, true, true)
        else
            allMPT[bestMP] = nil
        end
    end
    
    for str, t in pairs(allHPT) do allHPT[str].startTime = currentTime end
    for str, t in pairs(allMPT) do allMPT[str].startTime = currentTime end
end

function food_onThink(player)
    local onThinkT = onThinkFood[player:getId()]
    if not onThinkT then return end

    onThinkT.timer = onThinkT.timer+1
    if onThinkT.duration > onThinkT.timer then return end
    
    food_activate(player)
    onThinkT.timer = 0
end

function food_useBerryBush(player, item)
    local maxBerryCount = (item:getActionId()-100) * 10
    local itemPos = item:getPosition()
    local respawnTime = math.random(7*60*1000, 12*60*1000)
    if maxBerryCount < 1 then maxBerryCount = 1 end
    local amount = math.random(0, maxBerryCount)

    addEvent(doTransform, respawnTime, 2786, itemPos, item:getId(), true)
	item:transform(2786)
    if amount == 0 then return player:sendTextMessage(GREEN, "You did not find any eatable berries this time") end
    createItem(2677, itemPos, amount, AID.other.food)
end

function food_onLook(item, desc)
    if desc then return desc end
    if item:getId() == 2006 and item:getFluidType() ~= 1 then return end
    local foodT = food_getFoodT(item)
    if not foodT then return end

    local upgradeCount = item:getText("spiceCount") or 0
    local newDesc = foodT.foodName
    local count = item:getCount()
    local weight = math.floor(item:getWeight()/count/100)

    if count > 1 then
        newDesc = newDesc.." ("..count..")\nWeight: "..weight.." ("..weight*count..")"
    else
        newDesc = newDesc.."\nWeight: "..weight
    end
    
    newDesc = newDesc.."\nGives: "..foodT.hp.." HP and "..foodT.mp.." MP per second"
    newDesc = newDesc.."\nDuration: "..foodT.duration.." seconds\n"
    newDesc = newDesc..food_getSpiceEffect(upgradeCount, foodT.spice)
    newDesc = newDesc..food_getDishEffect(foodT.effect)
    return newDesc
end

function food_activateDish(player, effectT)
    if not effectT then return end
    local playerID = player:getId()

    for effect, t in pairs(effectT) do
        if effect == "maxMP" then bindCondition(playerID, "delightJuice", t.duration, {maxMP = t.value}) end
        if effect == "cap" then player:addCap(t.value, t.ID, t.duration) end
        if effect == "armor" then
            setSV(player, t.ID, 1)
            addEvent(removeSV, t.duration, playerID, t.ID)
        end
        setSV(player, t.startTimeSec, os.time())
    end
end

function food_acticateSpice(player, item, foodT)
    local bonusT = food_getSpiceBonusT(item, foodT)
    if not bonusT then return end
    local playerID = player:getId()
    local duration = foodT.duration*1000

    if bonusT.eleDamEnergy  and bonusT.eleDamEnergy > 0 then addExtraEleDamage(playerID, bonusT.eleDamEnergy, "energy", duration) end
    if bonusT.eleDamFire    and bonusT.eleDamFire > 0   then addExtraEleDamage(playerID, bonusT.eleDamFire, "fire", duration) end
    if bonusT.eleDamEarth   and bonusT.eleDamEarth > 0  then addExtraEleDamage(playerID, bonusT.eleDamEarth, "earth", duration) end
    if bonusT.eleDamDeath   and bonusT.eleDamDeath > 0  then addExtraEleDamage(playerID, bonusT.eleDamDeath, "death", duration) end
    if bonusT.eleDamIce     and bonusT.eleDamIce > 0    then addExtraEleDamage(playerID, bonusT.eleDamIce, "ice", duration) end
    if bonusT.resPhysical   and bonusT.resPhysical > 0  then addTempResistance(playerID, bonusT.resPhysical, "physical", duration) end
    if bonusT.resFire       and bonusT.resFire > 0      then addTempResistance(playerID, bonusT.resFire, "fire", duration) end
    if bonusT.resIce        and bonusT.resIce > 0       then addTempResistance(playerID, bonusT.resIce, "ice", duration) end
    if bonusT.resEnergy     and bonusT.resEnergy > 0    then addTempResistance(playerID, bonusT.resEnergy, "energy", duration) end
    if bonusT.resDeath      and bonusT.resDeath > 0     then addTempResistance(playerID, bonusT.resDeath, "death", duration) end
    if bonusT.resEarth      and bonusT.resEarth > 0     then addTempResistance(playerID, bonusT.resEarth, "earth", duration) end
    if bonusT.armor         and bonusT.armor > 0        then addFoodArmor(playerID, bonusT.armor, duration) end
    if bonusT.speed         and bonusT.speed > 0        then bindCondition(playerID, "speedSpice", duration, {speed =  bonusT.speed}) end
end

function addFoodArmor(cid, amount, duration)
    local player = Player(cid)
    if not player then return end

    addSV(player, SV.foodArmor, amount)
    if duration and duration > 0 then addEvent(addFoodArmor, duration, cid, -amount) end
end

-- get functions
function Item.isFood(item)
    if item:getId() == 2006 and item:getFluidType() == 1 then return true end
    return item:getActionId() == AID.other.food
end

function food_getFoodT(object)
    if type(object) == "userdata" then return food_getFoodT(object:getId()) end

    if type(object) == "number" then
        for foodID, foodT in pairs(foodConf.food) do
            if object == foodT.itemID then return foodT end
        end
    end
end

function Player.getFoodLimit(player)
    local playerFoodLimit = player:getCondition(REGEN, SUB.REGEN.regen.foodLimit) or 0

    if playerFoodLimit ~= 0 then playerFoodLimit = math.floor(playerFoodLimit:getTicks()/1000) end
    return playerFoodLimit
end

local function getBestValue(playerID, key)
    if not registratedFood[playerID] then return 0 end
    local bestValue = 0

    for strength, t in pairs(registratedFood[playerID][key]) do
        if strength > bestValue then bestValue = strength end
    end
    return bestValue
end

function getBestRegistratedHP(playerID) return getBestValue(playerID, "hp") end
function getBestRegistratedMP(playerID) return getBestValue(playerID, "mp") end

function getRegistratedHPFoodDuration(playerID, strength)
    if not registratedFood[playerID]["hp"][strength] then return 0 end
    return registratedFood[playerID]["hp"][strength].duration or 0
end

function getRegistratedMPFoodDuration(playerID, strength)
    if not registratedFood[playerID]["mp"][strength] then return 0 end
    return registratedFood[playerID]["mp"][strength].duration or 0
end

function food_getSpiceEffect(upgradeCount, spiceT)
    local newDesc = ""
    if upgradeCount <= 0 then return newDesc end
    if not spiceT then return newDesc end
    local timesStr = "time"
    local tempEffects = {}
    local effects = {
        ["extraHP"] = "HP amount per second is increased by VALUE",
        ["extraMP"] = "MP amount per second is increased by VALUE",
        ["extraDuration"] = "increases the food duration by VALUE seconds",
        ["eleDamEnergy"] = "adds +VALUE extra damage to you energy spells",
        ["eleDamFire"] = "adds +VALUE extra damage to you fire spells",
        ["eleDamEarth"] = "adds +VALUE extra damage to you earth spells",
        ["eleDamDeath"] = "adds +VALUE extra damage to you death spells",
        ["eleDamIce"] = "adds +VALUE extra damage to you ice spells",
        ["resPhysical"] = "increases your physical resistance by VALUE%",
        ["resFire"] = "increases your fire resistance by VALUE%",
        ["resIce"] = "increases your ice resistance by VALUE%",
        ["resEnergy"] = "increases your energy resistance by VALUE%",
        ["resDeath"] = "increases your death resistance by VALUE%",
        ["resEarth"] = "increases your earth resistance by VALUE%",
        ["armor"] = "increases your armor by VALUE",
        ["speed"] = "increases your speed by VALUE",
    }

    for effectName, effectInfo in pairs(effects) do tempEffects[effectName] = 0 end
    if upgradeCount > 1 then timesStr = "times" end
    newDesc = newDesc.." spiced "..upgradeCount.." "..timesStr.."\n"

    for powderAID, t in pairs(spiceT) do
        for spiceCount, effectT in pairs(t) do
            if upgradeCount >= spiceCount then
                for effectName, extraValue in pairs(effectT) do
                    tempEffects[effectName] = tempEffects[effectName] + extraValue
                end
            end
        end
    end

    for effectName, value in pairs(tempEffects) do
        if value > 0 then
            local effecInfo = effects[effectName]
            effecInfo = effecInfo:gsub("VALUE", value)
            newDesc = newDesc..effecInfo.."\n"
        end
    end
    return newDesc
end

function food_getDishEffect(table)
    local newDesc = ""

    if not table then return newDesc end
    
    for effectName, effectT in pairs(table) do
        local duration = effectT.duration/1000
        
        if duration > 120 then duration = tostring((duration/60).." minutes") else duration = tostring(duration.." seconds") end
        if effectName == "cap" then newDesc = newDesc.."increases your cap by "..effectT.value.." for "..duration.."\n" end
        if effectName == "armor" then newDesc = newDesc.."increases your armor by "..effectT.value.." for "..duration.."\n" end
        if effectName == "maxMP" then newDesc = newDesc.."increases your maximum mana points by "..effectT.value.." for "..duration.."\n" end
    end
    return newDesc
end

function food_getSpiceBonus(item, foodT, attribute)
    local bonusT = food_getSpiceBonusT(item, foodT)
    if not bonusT then return 0 end
    return bonusT[attribute] or 0
end

function food_getSpiceBonusT(item, foodT)
    if not foodT.spice then return end
    local itemText = item:getAttribute(TEXT)
    local powderAID = getFromText("spiceAID", itemText)
    if not powderAID then return end
    local powderBonusT = foodT.spice[powderAID]
    local spiceCount = getFromText("spiceCount", itemText)
    local bonusT = {}

    local function updateBonusT(bonusName, amount)
        if not bonusT[bonusName] then bonusT[bonusName] = amount return end
        bonusT[bonusName] = bonusT[bonusName] + amount
    end
    
    for upgradeCount, upgradeT in pairs(powderBonusT) do
        if spiceCount >= upgradeCount then
            for bonusName, amount in pairs(upgradeT) do updateBonusT(bonusName, amount) end
        end
    end
    if tableCount(bonusT) == 0 then return end
    return bonusT
end

-- other functions
function food_getArmorBonus(player)
    local totalArmor = 0
    local dumplingsT = food_getFoodT(9995)
    local armorT = dumplingsT.effect.armor

    if getSV(player, SV.foodArmor) > 0 then totalArmor = totalArmor + getSV(player, SV.foodArmor) end
    if getSV(player, armorT.ID) == 1 then totalArmor = totalArmor + armorT.value end
    return totalArmor
end