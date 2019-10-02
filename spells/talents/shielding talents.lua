local branchID = MW.skillTree_shielding

function bladed_shield(player)
local def = skillTree_getTalentValue(player, SV.bladed_shield, branchID)

    return def
end

function bladed_armor(player)
local armor = skillTree_getTalentValue(player, SV.bladed_armor, branchID)

    return armor
end

function power_of_love(player, healAmount, onlyCheck)
    local percent = skillTree_getTalentValue(player, SV.power_of_love, branchID)
        
    return onlyCheck and percent > 0 and percent or percentage(healAmount, percent)
end

mediationSpells = {"heal", "barrier", "armorup"}
function mediation(player, spellName, manaCost, onlyCheck)
    if not isInArray(mediationSpells, spellName) then return 0 end
    local percent = skillTree_getTalentValue(player, SV.mediation, branchID)
    local amount = percentage(manaCost, percent)

    return onlyCheck and amount or -amount
end

function skilled(player)
    local value = skillTree_getTalentValue(player, SV.skilled, branchID)
    if value < 1 then return removeCondition(player, "ST_skilled") end
    
    local conf = {
        [1] = {mL = -1},
        [2] = {mL = -1, wL = -1},
        [3] = {mL = -1, wL = -1, dL = -1},
        [4] = {mL = -1, wL = -1, dL = -1, sL = 1},
        [5] = {mL = -2, wL = -1, dL = -1, sL = 1},
        [6] = {mL = -2, wL = -2, dL = -1, sL = 1},
        [7] = {mL = -2, wL = -2, dL = -2, sL = 1},
        [8] = {mL = -2, wL = -2, dL = -2, sL = 2},
    }
    bindCondition(player, "ST_skilled", -1, conf[value])
end

function momentum(player)
local chance = skillTree_getTalentValue(player, SV.momentum, branchID)
    
    return chance
end