function getRandomNumber(startV, endV, exludeNumberT)
    local randomNT = {}

    if not exludeNumberT then return math.random(startV, endV) end

    for n = startV, endV do
        if not matchTableValue(exludeNumberT, n) then table.insert(randomNT, n) end
    end
    local maxCount = tableCount(randomNT)

    return maxCount > 0 and randomNT[math.random(1, maxCount)]
end

function chanceSuccess(percent)
    if not percent or percent <= 0 then return false end
    if percent >= 100 then return true end
    local baseValue = 10000
    local randomNumber = math.random(1, baseValue)
    local requiredValue = percentage(baseValue, percent)
    
    return randomNumber <= requiredValue
end

function percentage(value, percent, ceil)
    if not value then return 0 end
    if not percent or percent <= 0 then return 0 end
	local result = value * percent/100
	return ceil and math.ceil(result) or math.floor(result)
end

function converFormulaToNumbers(player, formula)
    formula = formula:gsub("mL", player:getMagicLevel())
    formula = formula:gsub("sL", player:getShieldingLevel())
    formula = formula:gsub("dL", player:getDistanceLevel())
    formula = formula:gsub("wL", player:getWeaponLevel())
    formula = formula:gsub("L",  player:getLevel())
    return formula
end

function calculate(player, formula, commaPlaces)
    if not formula then return 0 end
    if type(formula) == "number" then return formula end
    if player then formula = converFormulaToNumbers(player, formula) end
    local value = loadstring("return " .. formula)() -- something is passing player mod stats, but not sure where and why
    return round(value, commaPlaces)
end

function round(num, commaPlaces)
    local mult = 10^(commaPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end