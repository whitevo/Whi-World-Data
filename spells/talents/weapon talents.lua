local branchID = MW.skillTree_weapon

function sharpening_weapon(player, damage)
    if not Player(player) then return 0 end
    local percent = skillTree_getTalentValue(player, SV.sharpening_weapon, branchID)

    return percentage(damage, percent)
end

function crushing_strength(player, creature, damType, origin, onlyCheck)
    if damType ~= PHYSICAL then return end
    if not isWeaponOrigin(origin) and not onlyCheck then return end
    if not Player(player) then return end
    
    local modifier = skillTree_getTalentValue(player, SV.crushing_strength, branchID)
    if modifier < 1 then return end

    local mL = player:getMagicLevel()
    local damage = modifier * mL
    if onlyCheck then return damage end

    local cd = player:getSV(SV.crushing_strength_cd)
    local duration = 5
    local time = os.time()
    if cd + duration > time then return end

    player:setSV(SV.crushing_strength_cd, time)
    onHitDebuff_registerDamage(creature, ENERGY, ENERGY, damage, duration, 5, O_player_proc, "crushing_strength")
end

function tactical_strike(player, origin, onlyCheck)
    if not Player(player) then return end
    if not isWeaponOrigin(origin) and not onlyCheck then return end
    local chance = skillTree_getTalentValue(player, SV.tactical_strike, branchID)

    if chance < 1 then return end
    if onlyCheck then return chance end
    if getSV(player, SV.armorUpSpell) < 1 then return end
    if chanceSuccess(chance) then updateAddEvent(player:getId(), "armorup", 1000) end
end

function accuracy(player)
    if not Player(player) then return 0 end
    local critChance = skillTree_getTalentValue(player, SV.accuracy, branchID)
    return critChance
end

function hit_and_runFunc(player, damType, onlyCheck)
    if damType ~= PHYSICAL then return end
    if not Player(player) then return end
    local chance = skillTree_getTalentValue(player, SV.hit_and_run, branchID)

    if onlyCheck then return chance end
    if chanceSuccess(chance) then
        player:getPosition():sendMagicEffect(22)
        bindCondition(player, "ST_hit_and_run", 5000, {speed = 25})
    end
end

function weapon_scabbard_addCap(player)
    local sv = SV.weapon_scabbard
    local mod = skillTree_getTalentValue(player, sv, branchID)
    if mod == 0 then return end
    local extraCap = mod * 100
    local playerOz = player:getCapacity()

    player:setCapacity(playerOz + extraCap)
end

function removeScabbard(player)
    local sv = SV.weapon_scabbard
    local mod = skillTree_getTalentValue(player, sv, branchID)
    if mod == 0 then return end
    local extraCap = mod * 100
    local playerOz = player:getCapacity()

    player:setCapacity(playerOz - extraCap)
end

function elemental_strikeDamage(player, target, damage, damType)
    if not target then return 0 end
    local baseDamage, eleType = elemental_strikeAmount(player, damage, damType)
    if baseDamage < 1 then return 0 end
    
    local finalDamage = baseDamage
    damType = getEleTypeEnum(eleType)
    finalDamage = finalDamage + elemental_powers(player, finalDamage, damType)
    doDamage(target, damType, finalDamage, getEffectByType(damType), O_player_proc) -- should not be proc
    return baseDamage
end

function elemental_strikeAmount(player, damage, damType, onlyCheck)
    if damType ~= PHYSICAL then return 0 end
    if not Player(player) then return 0 end
    local percent = skillTree_getTalentValue(player, SV.elemental_strike, branchID)
    if percent < 1 then return 0 end

    local eleTypes = {"fire", "energy", "death", "ice", "earth"}
    local highestRes = 0
    local eleType = false

    for _, damTypeStr in pairs(eleTypes) do
        local res = player:getResistance(damTypeStr)
        
        if res > highestRes then
            highestRes = res
            eleType = damTypeStr
        end
    end
    
    if not eleType then return 0 end
    if onlyCheck then return percent, eleType end
    local convertedDamage = percentage(damage, percent)
    return convertedDamage, eleType
end

function lucky_strike(player, maxDam)
    local sv = SV.lucky_strike
    local percent = skillTree_getTalentValue(player, sv, branchID)

    if percent <= 0 then return 0 end
    if getSV(player, SV.lucky_strike_crit) ~= 1 then return 0 end    
    removeSV(player, SV.lucky_strike_crit)
    return percentage(maxDam, percent)
end

function lucky_strike_crit(player)
    local value = skillTree_getTalentValue(player, SV.lucky_strike, branchID)
    if value <= 0 then return 0 end
    setSV(player, SV.lucky_strike_crit, 1)
end

function undercut(player, minDam)
    local percent = skillTree_getTalentValue(player, SV.undercut, branchID)
    if percent <= 0 then return 0 end

    if getSV(player, SV.undercut_crit) ~= 1 then return 0 end
    removeSV(player, SV.undercut_crit)
    return minDam * percent/100
end

function undercut_crit(player)
    local value = skillTree_getTalentValue(player, SV.undercut, branchID)
    if value <= 0 then return end
    setSV(player, SV.undercut_crit, 1)
end