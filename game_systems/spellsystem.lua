function spells_onSay(player, words, param)
    if not spells_canCast(player) then return end
    local spellT = spells_getSpellT(words)
    if not spells_canCast(player, spellT, true) then return end
    spells_afterCanCast(player, spellT)
    _G[spellT.func](player:getId(), spellT, param)
end

function spells_canCast(player, spellT, takeMana)
    if spellT and spellT.targetRequired then
        local target = player:getTarget()
        if not target then return false, player:sendTextMessage(GREEN, "target required.") end
        if spellT.range and getDistanceBetween(player:getPosition(), target:getPosition()) > spellT.range then return false, player:sendTextMessage(GREEN, "target too far.") end
    end
    
    if not spellT and player:isGod() then return true end
    if player:isSilenced() then return false, player:sendTextMessage(GREEN, "You are silenced") end
    if player:isFakeDead() then return false, player:sendTextMessage(GREEN, "Can't cast spells while faking death.") end
    if player:isStunned() then return false, player:sendTextMessage(GREEN, "Can't cast spells while stunned.") end
    if not spellT then return true end
    if not spells_checkSlots(player, spellT.slot) then return end
    if player:isGod() then return true end
    if not player:isVocation(spellT.vocation) then return end
    if not spells_spellLearned(player, spellT.spellSV) then return false, player:sendTextMessage(GREEN, "You need to learn "..spellT.spellName.." first") end
    if player:getLevel() < spellT.level then return false, player:sendTextMessage(GREEN, "You need higher level to cast that spell.") end
    if spellT.mL > 0 and player:getMagicLevel() < spellT.mL then return false, player:sendTextMessage(GREEN, "You need higher magic level to cast that spell.") end
    if spells_onCooldown(player, spellT) then return end
    
    local manaCost = spells_getManaCost(player, spellT.spellName)
    if player:getMana() < manaCost then return false, player:sendTextMessage(GREEN, "Not enough Mana.") end
    if not takeMana then return true end
    player:addMana(-manaCost)

    potions_druidPotionHealthCost(player, manaCost)
    arcaneBoots_mana(player, manaCost)
    zvoidBoots_mana(player, manaCost)
    return true
end

function spells_afterCanCast(player, spellT)
    local time = spells_getCooldownInt()
    local spellCD = spells_getCooldown(player, spellT)
    local nextCastTime = time + spellCD
    
    spells_removeFromSlots(player, spellT.slot)
    deathGem(player)
    blessedIronHelmet(player)
    blessedTurban(player)
    blessedHoodOnCast(player)
    player:say(spellT.spellName, ORANGE)
    setSV(player, spellT.spellSV+20000, nextCastTime)
    
    if spellT.shareCD then
        for _, otherSpellSV in pairs(spellT.shareCD) do setSV(player, otherSpellSV+20000, nextCastTime) end
    end
end

function spells_getSpellT(object)
    if type(object) == "number" then
        for spellName, spellT in pairs(spells) do
            if spellT.spellSV == object or spellT.actionID == object or spellT.spellID == object then return spellT end
        end
    elseif type(object) == "string" then
        for spellName, spellT in pairs(spells) do
            if spellT.word == object or spellName == object then return spellT end
        end
    end
end

function spells_getFormulas(player, spellT)
    if not spellT.formula then return end
    local returnValues = {}
    for ID, formulaT in pairs(spellT.formula) do returnValues[ID] = spells_calculateFormulaAmount(player, formulaT, spellT) end
    return returnValues[1], returnValues[2], returnValues[3], returnValues[4]
end

function spells_getRange(player, spellT)
    local range = spellT.range or 1

    range = range + spell_power(player)
    range = range + precisionRobe(player)
    return range
end

function spells_generateParamT(player, string, amount, spellT, onlyCheck)
    local tempParams = string:match("%b()")
    local params = removeBrackets(tempParams)
    local paramT = params:split(", ")

    for i, p in pairs(paramT) do
        if p == "player"        then paramT[i] = player
        elseif p == "amount"    then paramT[i] = amount
        elseif p == "damType"   then paramT[i] = getEleTypeEnum(spellT.spellType)
        elseif p == "onlyCheck" then paramT[i] = onlyCheck
        elseif p == "spellName" then paramT[i] = spellT.spellName
        elseif p == "manaCost" then paramT[i] = spells_getManaCost(player, spellT.spellName)
        else paramT[i] = nil end
    end
    return paramT
end

function spells_calculateFormulaAmount(player, formulaT, spellT)
    local minAmount = calculate(player, formulaT.min)
    local maxAmount = calculate(player, formulaT.max)

    if minAmount > maxAmount then maxAmount = minAmount end
    local amount = math.random(minAmount, maxAmount)
    local damType = getEleTypeEnum(spellT.spellType)

    if formulaT.extras then
        for _, extraT in ipairs(formulaT.extras) do
            local func = _G[extraT.func:gsub("%b()", "")]
            local paramT = spells_generateParamT(player, extraT.func, amount, spellT, false)
            local extraAmount = func(paramT[1], paramT[2], paramT[3], paramT[4], paramT[5], paramT[6])
            if tonumber(extraAmount) then amount = amount + extraAmount end
        end
    end
    
    if formulaT.damage then
        amount = amount + player:getExtraElementalDamage(damType, amount)
        amount = amount + blessedTurban_damage(player, amount)
        amount = amount + impBuff(player, amount)
    end
    return amount
end

function countMageImprovement(player, damType)
    local I = 0
    I = I + akujaaku(player)
    I = I + precisionRobe(player)
    I = I + spell_power(player)
    I = I + namiBootsRange(player)
    I = I + stoneMageImprovement(player, damType)
    return I
end

function stoneMageImprovement(player, damType)
    local item = player:getSlotItem(SLOT_LEFT)
    if not item then return 0 end

    local damTypeStr = getEleTypeByEnum(damType):lower()
    local stoneT = stones_getStoneT(damTypeStr.." stone")
    return item:getText(stoneT.itemTextKey) or 0
end

function checkSpellScroll(item, desc)
    if desc then return desc end
    if item:getId() ~= 5958 then return end
    local spellT = spells_getSpellT(item:getActionId())
    if not spellT then return end

    local vocation = spellT.vocation or "all classes"
    if spellT.vocation and type(spellT.vocation) == "table" then vocation = tableToStr(spellT.vocation, ", ") end
    return tostring("Level "..spellT.level.." Spell for "..vocation.." \n "..spellT.spellName.." \n "..spellT.effectT[1])
end

function spells_spellLearned(player, object)
    if type(object) == "number" then
        local spellSV = object
        if object < 10000 then
            local spellT = spells_getSpellT(object)
            if not spellT then return end -- temp thing with spells what are are planned to add for enchanting but not yet exist in game
            spellSV = spellT.spellSV
        end
        return getSV(player, spellSV) == 1
    else print("ERROR - not number in spells_spellLearned() "..tostring(object)) end
end

local wantToLearnT = {}
function spells_useScroll(player, item)
    local spellT = spells_getSpellT(item:getActionId())

    if not spellT then return end
    if spells_spellLearned(player, spellT.spellSV) then return player:sendTextMessage(GREEN, "You already know this spell") end    
    local vocationName = player:getVocation():getName():lower()
    local playerID = player:getId()

    if not wantToLearnT[playerID] then
        if vocationName ~= "none" or vocationName ~= spellT.vocation then
            wantToLearnT[playerID] = true
            addEvent(setTableVariable, 4000, wantToLearnT, playerID, nil)
            return player:sendTextMessage(GREEN, "Are you sure you want to learn ".. spellT.vocation.." spell?")
        end
    end
    setSV(player, spellT.spellSV, 1)
    player:sendTextMessage(GREEN, "you learned " ..spellT.spellName.. " spell") 
    spiralEffect(player:getPosition(), 50, CONST_ANI_HOLY)
    item:remove()
end

function spells_onCooldown(player, spellT, dontSendMsg)
    local nextCastTime = getSV(player, spellT.spellSV+20000)
    local currentTime = spells_getCooldownInt()
    
    if nextCastTime < currentTime then return end
    
    if not dontSendMsg and antiSpam(player:getId(), "spells_timeLeftStr" or 0, 300) then
        local timeLeft = nextCastTime - currentTime
        local timeLeftSec = math.ceil(timeLeft/1000)
        if timeLeftSec > 60*2 then return print("spells_onCooldown timeLeftSec was too much again: "..timeLeftSec) end
        local timeLeftStr = timeLeftSec > 3 and timeLeftSec.." seconds" or timeLeft.." millisec."
        
        doSendMagicEffect(player:getPosition(), 3)
        player:sendTextMessage(GREEN, "Spell under Cooldown. "..timeLeftStr)
    end
    return true
end

function spells_getManaCost(player, spellName)
    local spellT = spells_getSpellT(spellName)
    local baseMana = spellT.manaCost

    if type(baseMana) == "string" then baseMana = percentage(player:getMaxMana(), tonumber(baseMana:match("%d+")), true) end
    local manaCost = spells_manaCostModifiers(player, spellName, baseMana)

    return manaCost < 0 and 0 or manaCost
end

function spells_manaCostModifiers(player, spellName, manaCost)
    local newManaCost = warriorBoots(player, spellName)
    if newManaCost then return newManaCost end

    manaCost = manaCost + mediation(player, spellName, manaCost) -- %
    manaCost = manaCost + player:getExtraManacost(spellName)
    manaCost = manaCost + potions_spellCaster_mana(player, manaCost)
    manaCost = manaCost + potions_druidPotionManaCost(player, manaCost)
    manaCost = manaCost + measuring_soul(player, spellName)
    manaCost = manaCost + measuring_mind(player, spellName)
    manaCost = manaCost + sightStone(player, manaCost)
    return manaCost
end


local function slotCheckFailed(player, slotT) return false, player:sendTextMessage(GREEN, slotT.failText) end

local function correctItem(item, slotT)
    local itemID = item:getId()
    local requiredCount = slotT.count or 1
    local itemCount = item:getCount()
        
    if type(slotT.items) ~= "table" then slotT.items = {slotT.items} end
    
    for _, requiredItemID in pairs(slotT.items) do
        if type(requiredItemID) == "string" then
            local itemTable = _G[requiredItemID]
            
            for _, requiredItemID in pairs(itemTable) do
                if itemID == requiredItemID then 
                    if itemCount < requiredCount then return else return true end
                end
            end
        elseif itemID == requiredItemID then
            if itemCount < requiredCount then return else return true end
        end
    end
end

function spells_checkSlots(player, slotTable)
    if not slotTable then return true end
    
    for slot, slotT in pairs(slotTable) do
        local item = player:getSlotItem(slot)
        if not item then return slotCheckFailed(player, slotT) end
        if not correctItem(item, slotT) then return slotCheckFailed(player, slotT) end
    end
    return true
end

function spells_removeFromSlots(player, slotTable)
    if not slotTable then return end
    for slot, slotT in pairs(slotTable) do
        if slotT.remove then
            local item = player:getSlotItem(slot)
            local removeCount = slotT.count or 1
            item:remove(removeCount)
        end
    end
end

function spells_healing(player, target, healAmount, healEffect)
    yashimaki(player, target)
    goddessArmor(target, target)
    heal(target, healAmount, healEffect)
end

function oldSpellScroll_onUse(player, item)
    item:remove()
    player:sendTextMessage(GREEN, "Sorry, this was old spellscroll, it no longer works corretly. Here is a compensation for broken item")
    player:rewardItems({itemID = 5905, count = 10})
end

function Player.getExtraManacost(player, spellName)
    if spellName == "spark" then
        return countMageImprovement(player, ENERGY) * 2
    elseif spellName == "death" then
        return countMageImprovement(player, DEATH) * 2
    end
    return 0
end

function spells_getCooldownInt() return os.mtime() % (10^8) end

function spells_getCooldown(player, spellT)
    local cd = spellT.cooldown

    cd = cd + trapSpellCooldown(player, spellT.spellName, cd)
    cd = cd + spellImprovementCooldown(player, spellT)
    cd = cd + gems2_getCooldownGemAmount(player)
    if cd < 1 then cd = 1 end
    return cd*1000
end

function spellImprovementCooldown(player, spellT)
    if not spellT.improvement then return 0 end
    local spellName = spellT.spellName
    
    local function calc(improvement) return math.floor(improvement/3) end
    if spellName == "spark" then return calc(countMageImprovement(player, ENERGY)) end
    if spellName == "death" then return calc(countMageImprovement(player, DEATH)) end
    if spellName == "mend" then return calc(countMendIncrease(player)) end
    return 0
end

function spells_showTargetSpellList(player, target) return player:sendTextMessage(ORANGE, target:getName().." spells: "..getSpellList(target)) end
