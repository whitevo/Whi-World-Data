local branchID = MW.skillTree_distance

function power_throw(player)
    local percent = skillTree_getTalentValue(player, SV.power_throw, branchID)
    return chanceSuccess(percent)
end

function sharpening_projectile(player, damage)
    local percent = skillTree_getTalentValue(player, SV.sharpening_projectile, branchID)
    return percentage(damage, percent)
end

function steel_jaws(player, damage)
    local percent = skillTree_getTalentValue(player, SV.steel_jaws, branchID)
    return percentage(damage, percent)
end

function wounding(player, target, damType, onlyCheck)
    if not Player(player) then return end
    if damType ~= PHYSICAL then return end
    local chance = skillTree_getTalentValue(player, SV.wounding, branchID)
    if onlyCheck then return chance end
    if not target then return end
    if not chanceSuccess(chance) then return end

    doSendMagicEffect(target:getPosition(), {23,1})
    bindCondition(target, "ST_wounding", 5000, {speed = 30})
end

function archery(player)
    local percent = skillTree_getTalentValue(player, SV.archery, branchID)
    if not chanceSuccess(percent) then return end
    doSendMagicEffect(player:getPosition(), {4,8})
    return true
end

function sharp_shooter(player)
local percent = skillTree_getTalentValue(player, SV.sharp_shooter, branchID)

    return percent
end