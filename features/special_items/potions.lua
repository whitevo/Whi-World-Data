function potions_onUse(player, item)
    local potionT = brewing_getPotionT(item:getActionId())
    local playerPos = player:getPosition()
    local positions = getAreaPos(playerPos, areas["outwards_explosion_3x3"])
    local potionType = potionT.potionType
    
    if potionType then
        for _, potionT in pairs(potions) do
            if potionT.potionType == potionType then potions_removePotion(player, potionT, true) end
        end
    end
    _G[potionT.buff.funcStr](player, potionT)
    _G[potionT.nerf.funcStr](player, potionT)
    text("*used "..potionT.name.."*", playerPos)
    item:remove(1)
    
    for i, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            if i == 1 then doSendMagicEffect(pos, 37, i*100) end
            if i == 2 then doSendMagicEffect(pos, 24, i*120) end
            if i == 3 then doSendMagicEffect(pos, 25, i*140) end
        end
    end
end

function Player.removePotion(player, potionID)
    local potionT = potions_getPotionT(potionID)
    if not potionT then return print("ERROR in player.removePotion() - missing potionT for potionID["..tostring(potionID).."]") end
    potions_removePotion(player, potionT, true)
end

function potions_removePotion(playerID, potionT, forceRemove)
    if not potionT.potionType and not forceRemove then return end
    local player = Player(playerID)
    if not player then return end
    if forceRemove then removeSV(player, {potionT.buff.endTimeSec, potionT.nerf.endTimeSec}) end
    _G[potionT.buff.funcStr](player, potionT, false, true)
    _G[potionT.nerf.funcStr](player, potionT, false, true)
end

function potions_onLook(player, item)
    if item:getId() == 10031 then
        local powderAID = item:getText("powderAID")
        local herbT = herbs_getHerbT(powderAID)
        return player:sendTextMessage(GREEN, "Unifinished Potion with - "..herbT.name)
    end
    local potionT = brewing_getPotionT(item:getActionId())
    
    if not potionT then return end
    local text = potionT.name.."\n"
    local duration = potionT.duration
    local buffText = potionT.buff.effect
    local nerfText = potionT.nerf.effect
    local buffTime = potionT.buff.secDuration
    local nerfTime = potionT.nerf.secDuration

    if buffText:match("VALUE") then
        local value = _G[potionT.buff.funcStr](player, potionT, true)
        buffText = buffText:gsub("VALUE", value)
    end
    if nerfText:match("VALUE") then
        local value = _G[potionT.nerf.funcStr](player, potionT, true)
        nerfText = nerfText:gsub("VALUE", value)
    end
    text = text.."buff: "..buffText.."\n"
    if buffTime then text = text.."Duration: "..getTimeText(buffTime).."\n" end
    text = text.."nerf: "..nerfText.."\n"
    if nerfTime then text = text.."Duration: "..getTimeText(nerfTime).."\n" end
    player:sendTextMessage(GREEN, text)
end

-- get functions
function potions_getPotionT(object)
    if type(object) == "string" then return potions[object] end
    if type(object) == "number" then
        for _, potionT in pairs(potions) do
            if potionT.itemAID == object then return potionT end
        end
    end
end

-- potion functions buffs and nerfs
function EXAMPLE_FUNCTION(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff -- nerf_or_buff
    local effectValue = effectT.defaultValue -- what_does_it_increase
        
    -- effectValue_modifiers
    if onlyValue then return effectValue end
    if removePotion then
        if reRegPotionRemove(player, potionT, effectT) then return end
        -- something_unique
        return
    end
    regPotion(player, potionT, effectT, effectValue)
    -- something_unique
end

local function regPotion(player, potionT, effectT, effectValue)
    local endTimeSec = os.time() + effectT.secDuration
    setSV(player, effectT.endTimeSec, endTimeSec)
    addEvent(potions_removePotion, endTimeSec*1000, player:getId(), potionT)
    setSV(player, effectT.effectSV, effectValue)
end

local function reRegPotionRemove(player, potionT, effectT)
    local endTimeSec = getSV(player, effectT.endTimeSec)
    if endTimeSec - 2 > os.time() then return addEvent(potions_removePotion, (endTimeSec - os.time())*1000, player:getId(), potionT) end
    removeSV(player, effectT.effectSV)
end

local function potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
    if onlyValue then return effectValue end
    if removePotion then return reRegPotionRemove(player, potionT, effectT) end
    regPotion(player, potionT, effectT, effectValue)
end

function potions_speedPotion_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- speed amount
    local level = player:getBrewingLevel()
    local subID = SUB.HASTE.speed.speedPotion
    
    effectValue = effectValue + level*5
    if onlyValue then return effectValue end

    if removePotion then
        if reRegPotionRemove(player, potionT, effectT) then return end
        player:removeCondition(ATTRIBUTES, subID)
        return
    end
    regPotion(player, potionT, effectT, effectValue)
    player:removeCondition(ATTRIBUTES, subID)
    bindCondition(player, "speedPotion", effectT.secDuration*1000, {speed = effectValue})
end

function potions_speedPotion_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- armor loss
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - level*2
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_speedPotion_armor(player)
    local removeArmorAmount = player:getSV(SV.speedPotion_nerf)
    return removeArmorAmount > 0 and -removeArmorAmount or 0
end

function potions_spellcaster_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- mana cost percent
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - level
    if effectValue < 1 then effectValue = 1 end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_spellcaster_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- heal amount
    local level = player:getBrewingLevel()
    
    effectValue = effectValue + math.floor(level/2)
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_spellCaster_heal(player, onlyCheck)
    local healAmount = getSV(player, SV.spellcasterPotion_buff)
    if healAmount < 1 then return end
    if onlyCheck then return healAmount end
    heal(player, healAmount, 15)
end

function potions_spellCaster_mana(player, manaCost)
    local manaPercent = getSV(player, SV.spellcasterPotion_nerf)
    if manaPercent < 1 then return 0 end
    return percentage(manaCost, manaPercent)
end

function potions_silence_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- % chance to silence
    local level = player:getBrewingLevel()
        
    effectValue = effectValue + level*3
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_silence_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- all elemental resistances reduced by %
    local level = player:getBrewingLevel()
    
    effectValue = effectValue - level*3
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_silence_resistance(player, damType)
    if not isInArray({"holy", "fire", "ice", "energy", "earth", "death"}, damType) then return 0 end
    local resistance = getSV(player, SV.silencePotion_nerf)    
    if resistance < 1 then return 0 end
    return -resistance
end

function potions_silence(player, target)
    if chanceSuccess(getSV(player, SV.silencePotion_buff)) then silence(target:getId()) end
end

function potions_flash_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- total energy res
    local energyRes = player:getResistance("energy")
    local level = player:getBrewingLevel()
    
    if energyRes < 1 then energyRes = 0 end
    effectValue = effectValue + energyRes + energyRes * (0.1 * level)
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_flash_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- % amount how much weapon attack is reduced
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - level*10
    if effectValue < 1 then effectValue = 0 end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_flash_attackSpeed(player, weaponAS)
    if getSV(player, SV.flashPotion_buff) < 0 then return 0 end
    local potionT = potions_getPotionT("flash potion")
    local percent = potions_flash_buff(player, potionT, true)

    return percentage(weaponAS, percent)
end

function potions_flash_weaponDamage(player, min, max)
    local damagePercent = getSV(player, SV.flashPotion_nerf)
    local newMax = max - percentage(max, damagePercent)
    
    if newMax < min then newMax = min end
    return newMax
end

function potions_druid_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- manacost reduce %
    local level = player:getBrewingLevel()
    
    effectValue = effectValue + level
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_druid_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- take health %
    local level = player:getBrewingLevel()
    
    effectValue = effectValue - math.floor(level/2)
    if effectValue < 2 then effectValue = 2 end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_druidPotionManaCost(player, manaCost) return -(percentage(manaCost, getSV(player, SV.druidPotion_buff), true)) end

function potions_druidPotionHealthCost(player, manaCost)
    local hpCost = potions_druidPotionManaCost(player, manaCost)
    if hpCost < 0 then return dealDamage(0, player, LD, -hpCost, 1, O_environment) end
end

function potions_hunter_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- earth damage
    local level = player:getBrewingLevel()
        
    effectValue = effectValue + level
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_hunter_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- speed amount
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - math.floor(level/2)
    if effectValue < 1 then effectValue = 1 end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_hunter_damage(player, target, damType, onlyCheck)
    if damType ~= PHYSICAL then return end
    if not Player(player) then return end
    local earthDam = getSV(player, SV.hunterPotion_buff)

    if earthDam < 1 then return end
    if onlyCheck then return earthDam end
    potions_hunter_slow(player, target, damType)
    addSV(player, SV.hunterPotion_damageStack, 1, 10)
    if getSV(player, SV.hunterPotion_damageTime) + 5 <= os.time() then setSV(player, SV.hunterPotion_damageStack, 1) end
    local stack = getSV(player, SV.hunterPotion_damageStack)
    local totalDam = earthDam * stack
    
    setSV(player, SV.hunterPotion_damageTime, os.time())
    bindCondition(target, "hunterPotionDamage", 4000, {dam = totalDam})
end

function potions_hunter_slow(player, target, damType, onlyCheck)
    if damType ~= PHYSICAL then return end
    local speed = getSV(player, SV.hunterPotion_nerf)
    
    if speed < 1 then return end
    if onlyCheck then return speed end
    addSV(player, SV.hunterPotion_slowStack, 1, 10)
    if getSV(player, SV.hunterPotion_damageTime) + 10 <= os.time() then setSV(player, SV.hunterPotion_slowStack, 1) end
    local stack = getSV(player, SV.hunterPotion_slowStack)
    local totalSlow = -speed * stack

    bindCondition(player, "hunterPotionSlow", 10000, {speed = totalSlow})
end

function potions_mage_buff(player, potionT, onlyValue, removePotion)
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- energy damage
    local level = player:getBrewingLevel()
    
    effectValue = effectValue - level * 15
    if onlyValue then return effectValue end
    if removePotion then
        if reRegPotionRemove(player, potionT, effectT) then return end
        unregisterEvent(player, "onThink", "potions_mage_aura")
        return
    end
    regPotion(player, potionT, effectT, effectValue)
    registerEvent(player, "onThink", "potions_mage_aura")
end

function potions_mage_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- mana % loss
    local level = player:getBrewingLevel()
    local subID = SUB.ATTRIBUTES.attributes.magePotion_maxMP
    
    effectValue = effectValue - math.floor(level/2)
    if effectValue < 1 then effectValue = 1 end
    if onlyValue then return effectValue end

    if removePotion then
        if reRegPotionRemove(player, potionT, effectT) then return end
        player:removeCondition(ATTRIBUTES, subID)
        return
    end
    regPotion(player, potionT, effectT, effectValue)
    player:removeCondition(ATTRIBUTES, subID)
    bindCondition(player, "magePotion_maxMP", effectT.secDuration*1000, {maxMP = -percentage(player:getMaxMana(), effectValue)})
end

function potions_mage_aura(player)
    local playerPos = player:getPosition()
    local area = getAreaAround(playerPos)
    local potionT = potions_getPotionT("mage potion")
    local baseValue = potions_mage_buff(player, potionT, true)
    local damage = baseValue + player:getMagicLevel() * 6 + player:getLevel() * 8
    
    damage = damage + elemental_powers(player, damage, ENERGY)
    
    for _, pos in pairs(area) do
        playerPos:sendDistanceEffect(pos, 33)
        dealDamagePos(0, pos, ENERGY, damage, 12, O_player_proc)
    end
end

function potions_knight_buff(player, potionT, onlyValue, removePotion, onlyCheck)
    if not potionT then potionT = potions_getPotionT("knight potion") end
    local effectT = potionT.buff
    local effectValue = effectT.defaultValue -- fire damage
    local level = player:getBrewingLevel()
    
    effectValue = effectValue + level * 8
    if onlyCheck then return getSV(player, SV.knightPotion_buff) > 0 and effectValue end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_knight_nerf(player, potionT, onlyValue, removePotion, onlyCheck)
    if not potionT then potionT = potions_getPotionT("knight potion") end
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- armor loss amount
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - math.floor(level/4)
    if effectValue < 1 then effectValue = 1 end
    if onlyCheck then return getSV(player, SV.knightPotion_nerf) > 0 and effectValue end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_knight_damage(player, target, damType, origin)
    if damType ~= PHYSICAL then return end
    if not isWeaponOrigin(origin) then return end
    if not Player(player) then return end

    local fireDam = getSV(player, SV.knightPotion_buff)
    if fireDam > 0 then dealDamage(player, target, FIRE, fireDam, 37, O_player_proc) end
end

function potions_knight_armorOnHit(player, origin)
    if not isWeaponOrigin(origin) then return end 
    if not Player(player) then return end
    local armorAmount = getSV(player, SV.knightPotion_nerf)
    
    if armorAmount < 1 then return end
    local armorSV = SV.knightPotion_armor
    local stackSV = SV.knightPotion_stacks
    
    addSV(player, stackSV, 1)
    if getSV(player, SV.knightPotion_armorTime) + 8 <= os.time() then setSV(player, stackSV, 1) end
    local newStack = getSV(player, stackSV) 
    
    setSV(player, armorSV, newStack*armorAmount)
    setSV(player, SV.knightPotion_armorTime, os.time())
    doSendMagicEffect(player:getPosition(), 25)
end

function potions_knight_armor(player)
    if getSV(player, SV.knightPotion_armorTime) + 8 <= os.time() then return 0 end
    local armor = getSV(player, SV.knightPotion_armor)
    
    if armor < 1 then armor = 0 end
    return -armor
end

function potions_antidote_buff(player, potionT, onlyValue, removePotion)
    if onlyValue or removePotion then return end
    player:removeCondition(DOT_EARTH, SUB.DOT_EARTH.dot.earth)
end

function potions_antidote_nerf(player, potionT, onlyValue, removePotion)
    local effectT = potionT.nerf
    local effectValue = effectT.defaultValue -- resistance loss %
    local level = player:getBrewingLevel()
        
    effectValue = effectValue - level * 2
    if effectValue < 10 then effectValue = 10 end
    return potions_defaultHandle(player, potionT, effectT, onlyValue, effectValue, removePotion)
end

function potions_antidote_res(player, damType)
    if damType == PHYSICAL or damType == COMBAT_LIFEDRAIN then return 0 end
    local resistanceReduce = getSV(player, SV.antidotePotion_nerf)

    if resistanceReduce < 1 then return 0 end
    return -resistanceReduce
end