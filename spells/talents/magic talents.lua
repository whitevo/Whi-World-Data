local branchID = MW.skillTree_magic

function furbish_wand(player)
local sv = SV.furbish_wand
local damage = skillTree_getTalentValue(player, sv, branchID)

    return damage
end

function mental_power(player, target, damType, origin, onlyCheck)
    if damType ~= ENERGY then return end
    if origin and origin == O_player_weapons_mage then return end
    if not Player(player) then return end
    
    local value = skillTree_getTalentValue(player, SV.mental_power, branchID)
    if value == 0 then return end
    if onlyCheck then return value end
    onHitDebuff_registerDamageNerfPercent(target, PHYSICAL, value, duration, "mental power")
end

function liquid_fire(player, target, damage, damType, origin, onlyCheck)
    if damType ~= FIRE then return end
    if origin and origin == O_fireProc or origin == O_player_weapons_mage then return end
    if not Player(player) then return end
    local percent = skillTree_getTalentValue(player, SV.liquid_fire, branchID)

    if onlyCheck then return percent end
    damage = percentage(-damage, percent)
    if damage < 1 then return end
    if target and target:isPlayer() and not PVP_allowed(player, target) then return end
    
    local function liquid_fire_damage(creatureID, damage)
        damage = damage + elemental_powers(player, damage, FIRE)
        doDamage(creatureID, FIRE, damage, 16, O_fireProc)
    end
    local targetID = target:getId()
    local times = 5
    local interval = 2
    local eventData = {liquid_fire_damage, targetID, damage}
        
    for x=1, times do
        stopAddEvent(targetID, "liquid_fire"..x)
        registerAddEvent(targetID, "liquid_fire"..x, x*interval*1000, eventData)
    end
end

function green_powderDamage(player, damage, damType, onlyCheck)
    if not Player(player) then return 0 end
    if damType ~= EARTH then return 0 end
    local percent = skillTree_getTalentValue(player, SV.green_powder, branchID)
    return onlyCheck and percent or percentage(damage, percent)
end

function thunderstruck(player, target, damType, onlyCheck)
    if damType ~= PHYSICAL then return end
    if not Player(player) then return end
    local sv = SV.thunderstruck
    local talentPoints = getSV(player, sv)

    if talentPoints <= 0 then return end
    local weapon = player:getSlotItem(SLOT_LEFT)
    local weaponT = getWeaponT(weapon)

    if not weaponT then return end
    local talenT = skillTree_getTalentBySV(sv, branchID)
    local minDam = weaponT.minDam + (getFromText("minDam", weapon:getAttribute(TEXT)) or 0)
    local extraDamage = math.floor(minDam + player:getMagicLevel()*8 + player:getWeaponLevel()*12 / (11 - talenT.value * talentPoints))

    if onlyCheck then return extraDamage end
    if not target then return end
    extraDamage = extraDamage + elemental_powers(player, extraDamage, ENERGY)
    dealDamage(player, target, ENERGY, extraDamage, 73, O_player_proc)
end

function measuring_mind(player, spellName)
local manaCostReduce = skillTree_getTalentValue(player, SV.measuring_mind, branchID)

    if manaCostReduce == 0 then return 0 end

    for _, iceSpellName in pairs(iceSpells) do
        if spellName == iceSpellName then return -manaCostReduce end
    end
    
    for _, fireSpellName in pairs(fireSpells) do
        if spellName == fireSpellName then return manaCostReduce end
    end
    return 0
end

function measuring_soul(player, spellName)
local sv = SV.measuring_soul
local manaCostReduce = skillTree_getTalentValue(player, sv, branchID)

    if manaCostReduce == 0 then return 0 end

    for _, deathSpellName in pairs(deathSpells) do
        if spellName == deathSpellName then return -manaCostReduce end
    end
    
    for _, energySpellName in pairs(energySpells) do
        if spellName == energySpellName then return manaCostReduce end
    end
    return 0
end

function spell_power(player)
local improve = skillTree_getTalentValue(player, SV.spell_power, branchID)

    return improve
end

function juicy_magicFunc(pid)
    local player = Player(pid)
    if not player then return end
    local extraMana = skillTree_getTalentValue(player, SV.juicy_magic, branchID)

    if extraMana == 0 then return removeCondition(player, "ST_juicy_magic") end
    bindCondition(player, "ST_juicy_magic", -1, {maxMP = extraMana})
end

function wisdom(player)
    local value = skillTree_getTalentValue(player, SV.wisdom, branchID)
    if value <= 0 then return removeCondition(player, "ST_wisdom") end

    local conf = {
        [1] = {sL = -1},
        [2] = {sL = -1, wL = -1},
        [3] = {sL = -1, wL = -1, dL = -1},
        [4] = {sL = -1, wL = -1, dL = -1, mL = 1},
        [5] = {sL = -2, wL = -1, dL = -1, mL = 1},
        [6] = {sL = -2, wL = -2, dL = -1, mL = 1},
        [7] = {sL = -2, wL = -2, dL = -2, mL = 1},
        [8] = {sL = -2, wL = -2, dL = -2, mL = 2},
    }
    bindCondition(player, "ST_wisdom", -1, conf[value])
end

function demon_master(player, damage, onlyCheck)
    local sv = SV.demon_master
    local percent = skillTree_getTalentValue(player, sv, branchID)
    if percent <= 0 then return 0 end

    local impID = getImpByPid(player:getId())
    local imp = Monster(impID)
    if not imp then return 0 end
    if onlyCheck then return percent end

    local damageReduction = percentage(damage, percent)
    imp:addHealth(damageReduction)
    return -damageReduction
end

function elemental_powers(player, damage, damType)
    if damType == PHYSICAL then return 0 end
    if damType == LD then return 0 end
local percent = skillTree_getTalentValue(player, SV.elemental_powers, branchID)

    return percentage(damage, percent)
end