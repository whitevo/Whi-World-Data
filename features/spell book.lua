if not spellBookConf then
spellBookConf = {
    orderT = {
        ["word"] = 1,
        ["spellType"] = 2,
        ["manaCost"] = 3,
        ["cooldown"] = 4,
        ["mL"] = 5,
        ["level"] = 6,
        ["range"] = 7,
        ["improvement"] = 8,
        ["shareCDStr"] = 9,
    }
    --defaultOrderID = INT      tableCount(orderT)
}

feature_spellBook = {
    startUpFunc = "spellBook_startUp",
    modalWindows = {
        [MW.spellBook] = {
            name = "Spell book",
            title = "Choose a spell for more information",
            choices = "spellBookMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
                [102] = "All spells",
            },
            say = "*checking spell book*",
            func = "spellBookMW",
        },
        [MW.spellInfo] = {
            name = "Information about this spell",
            title = "spellInfoMW_title",
            choices = "spellInfoMW_choices",
            buttons = "spellInfoMW_buttons",
            func = "spellInfoMW",
            save = "choiceT",
        },
        [MW.spellFormulas] = {
            name = "Formulas about this spell",
            title = "spellInfoMW_title",
            choices = "spellFormulaMW_choices",
            buttons = {
                [100] = "details",
                [101] = "back",
            },
            func = "spellFormulaMW",
            save = "spellFormulaMW_save",
        },
    },
}
centralSystem_registerTable(feature_spellBook)
end

function spellBook_startUp()
    local ID = 0
        
    spellBookConf.defaultOrderID = tableCount(spellBookConf.orderT)
    
    for spellName, spellT in pairs(spells) do
        ID = ID+1
        spellT.spellID = ID
        spellT.spellName = spellName
        if not spellT.level then spellT.level = 1 end
        if not spellT.mL then spellT.mL = 0 end
        if not spellT.cooldown then spellT.cooldown = 1 end
        if not spellT.manaCost then spellT.manaCost = 0 end
        if spellT.actionID then central_register_actionEvent({[spellT.actionID] = {funcSTR = "spells_useScroll"}}, "AIDItems") end
        if not spellT.buffT then spellT.buffT = {} end
        if spellT.shareCD and type(spellT.shareCD) ~= "table" then spellT.shareCD = {spellT.shareCD} end
        
        if spellT.spellType == "fire"        then table.insert(fireSpells, spellName)
        elseif spellT.spellType == "ice"     then table.insert(iceSpells, spellName)
        elseif spellT.spellType == "death"   then table.insert(deathSpells, spellName)
        elseif spellT.spellType == "energy"  then table.insert(energySpells, spellName)
        end
        
        for _, buffName in ipairs(spellBuffToAll) do table.insert(spellT.buffT, buffName) end
        
        for i, buffName in pairs(spellT.buffT) do
            if type(buffName) == "string" then spellT.buffT[i] = spellBuffs[buffName] end
        end
        
        if spellT.formula then
            for _, formulaT in pairs(spellT.formula) do
                if formulaT.extras then
                    for i, buffName in pairs(formulaT.extras) do
                        if type(buffName) == "string" then formulaT.extras[i] = spellBuffs[buffName] end
                    end
                end
            end
        end
    end
    
    for spellName, spellT in pairs(spells) do
        if spellT.shareCD then
            local spellList = {}
            
            for i, spellSV in ipairs(spellT.shareCD) do spellList[i] = spells_getSpellT(spellSV).spellName end
            local msg = "Shares cooldown with: "
            local spellListStr = tableToStr(spellList, " and")
            spellT.shareCDStr = msg..spellListStr.." spell"..stringIfMore("s", tableCount(spellList))
        end
    end
end

local function showSpell(player, t, noClassCheck)
    local classMatches = noClassCheck or player:isVocation(t.vocation)
    local spellLearned = player:isGod() or getSV(player, t.spellSV) == 1
    if not classMatches then return end
    return spellLearned
end

function spellBookMW_choices(player, showAllSpells)
    local choiceT = {}

    for spellName, t in pairs(spells) do
        if showSpell(player, t, showAllSpells) then choiceT[t.spellID] = spellName end
    end
    return choiceT
end

local function handleEffectResult(result, extraT, return2)
    if not result then return end
    if tonumber(result) then
        if result == 0 then return end
        if result < 0 and not extraT.negative then return end
    end

    local text = extraT.text
    if text:match("EXTRA") then text = text:gsub("EXTRA", result) end
    if text:match("BONUS") then text = text:gsub("BONUS", return2) end
    return {text = text, replace = extraT.replace}
end

local function value_formula(player, spellT, formulaT, dontHandleResults)
    local minAmount, maxAmount
    local extraText = ""
    local bonusEffectT = {}
        
    if formulaT.func then
        minAmount, maxAmount = _G[formulaT.func](player)
    else
        minAmount = calculate(player, formulaT.min)
        maxAmount = calculate(player, formulaT.max)
        extraText = formulaT.extraText or ""
    end

    if minAmount > maxAmount then maxAmount = minAmount end

    if formulaT.extras then
        local loopID = 0
        
        for _, extraT in ipairs(formulaT.extras) do
            local avarageAmount = math.floor((minAmount + maxAmount) / 2)
            local func = _G[extraT.func:gsub("%b()", "")]
            local paramT = spells_generateParamT(player, extraT.func, avarageAmount, spellT, true)
            local result, return2 = func(paramT[1], paramT[2], paramT[3], paramT[4], paramT[5], paramT[6])
            
            if result then
                local minValueParamT = spells_generateParamT(player, extraT.func, minAmount, spellT)
                local minResult = func(minValueParamT[1], minValueParamT[2], minValueParamT[3], minValueParamT[4], minValueParamT[5], minValueParamT[6])
                
                if not dontHandleResults then
                    loopID = loopID + 1
                    bonusEffectT[loopID] = handleEffectResult(result, extraT, return2)
                end
                
                if tonumber(minResult) then
                    local maxValueParamT = spells_generateParamT(player, extraT.func, maxAmount, spellT)
                    local maxResult = func(maxValueParamT[1], maxValueParamT[2], maxValueParamT[3], maxValueParamT[4], maxValueParamT[5], maxValueParamT[6])
                    minAmount = minAmount + minResult
                    maxAmount = maxAmount + maxResult
                end
            end
        end
    end

    minAmount, maxAmount = spells_sparkAndDeathDam(player, spellT.spellName, minAmount, maxAmount)

    if formulaT.damage then
        minAmount = minAmount + player:getExtraElementalDamage(spellT.spellType, minAmount)
        maxAmount = maxAmount + player:getExtraElementalDamage(spellT.spellType, maxAmount)
        minAmount = minAmount + blessedTurban_damage(player, minAmount)
        maxAmount = maxAmount + blessedTurban_damage(player, maxAmount)
        minAmount = minAmount + impBuff(player, minAmount)
        maxAmount = maxAmount + impBuff(player, maxAmount)
    end

    if minAmount < 0 then minAmount = 0 end
    if minAmount >= maxAmount then return minAmount..extraText, bonusEffectT end
    return minAmount.." - "..maxAmount..extraText, bonusEffectT
end

function spellInfoMW_choices(player, spellName)
    local spellT = spells_getSpellT(spellName)
    local choiceT = {}
    local effectT = deepCopy(spellT.effectT)
    local effectID = tableCount(effectT)
    local orderID = spellBookConf.defaultOrderID
    local bonusEffectT = {}

    local function nextOrderID() orderID = orderID + 1 return orderID end
    local function nextEffectID() effectID = effectID + 1 return effectID end
    local function getOrderID(k) return spellBookConf.orderT[k] or nextOrderID() end
    
    local function parse_formulas(allFormulaT)
        for _, formulaT in ipairs(allFormulaT) do
            if not formulaT.dontShow then
                local result, bonusT = value_formula(player, spellT, formulaT)
                
                choiceT[getOrderID()] = formulaT.name..": "..result
                
                for _, t in ipairs(bonusT) do
                    if t.replace then effectT[t.replace] = t.text else table.insert(bonusEffectT, t.text) end
                end
            end
        end
    end
    
    local function parse_cooldown(cooldown, key)
        local spellCD = spells_getCooldown(player, spellT)
        choiceT[getOrderID(key)] = key..": "..getTimeText(spellCD, true)
    end
    
    local function parse_default(value, key) choiceT[getOrderID(key)] = key..": "..value end
    local function parse_range(_, key) choiceT[getOrderID(key)] = key..": "..spells_getRange(player, spellT) end
    local function parse_manaCost(_, key) choiceT[getOrderID(key)] = key..": "..spells_getManaCost(player, spellName).." mana" end
    local function parse_shareCD(v, key) choiceT[getOrderID(key)] = v end
    
    local function parse_level(requiredLevel, key)
        if player:getLevel() >= requiredLevel then return end
        choiceT[getOrderID(key)] = key..": "..requiredLevel
    end
    
    local function parse_mL(requiredMagicLevel, key)
        if requiredMagicLevel < 1 then return end
        choiceT[getOrderID(key)] = key..": "..requiredMagicLevel
    end
    
    local function parse_improvement(improvement, key)
        if spellName == "spark" then improvement = improvement + countMageImprovement(player, ENERGY) end
        if spellName == "death" then improvement = improvement + countMageImprovement(player, DEATH) end
        if spellName == "mend" then improvement = improvement + countMendIncrease(player) end
        choiceT[getOrderID(key)] = key..": "..improvement
    end
    
    local function parse_spellT(key, v)
        if key == "word"        then return parse_default(v, key) end
        if key == "spellType"   then return parse_default(v, key) end
        if key == "formula"     then return parse_formulas(v) end
        if key == "cooldown"    then return parse_cooldown(v, key) end
        if key == "manaCost"    then return parse_manaCost(v, key) end
        if key == "range"       then return parse_range(v, key) end
        if key == "level"       then return parse_level(v, key) end
        if key == "mL"          then return parse_mL(v, key) end
        if key == "improvement" then return parse_improvement(v, key) end
        if key == "shareCDStr"  then return parse_shareCD(v, key) end
    end
    
    for key, v in pairs(spellT) do parse_spellT(key, v) end
    
    for _, extraT in pairs(spellT.buffT) do
        local func = _G[extraT.func:gsub("%b()", "")]
        local paramT = spells_generateParamT(player, extraT.func, nil, spellT, true)
        local result, return2 = func(paramT[1], paramT[2], paramT[3], paramT[4], paramT[5], paramT[6])
        local bonusT = {handleEffectResult(result, extraT, return2)}
        
        if bonusT[1] then
            for _, t in ipairs(bonusT) do
                if t.replace then effectT[t.replace] = t.text else table.insert(bonusEffectT, t.text) end
            end
        end
    end
    
    for _, effect in ipairs(bonusEffectT) do table.insert(effectT, effect) end
local sortedEffectT = sorting(effectT, "low")

    for _, k in ipairs(sortedEffectT) do choiceT[getOrderID()] = "Effect: "..effectT[k] end
    return choiceT
end

function spellBookMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return player:createMW(MW.spellBook, true) end
    if choiceID == 255 then return end
    local spellT = spells_getSpellT(choiceID)
        
    player:createMW(MW.spellInfo, spellT.spellName)
end

function spellInfoMW_title(player, spellName) return spellName end

function spellInfoMW_buttons(player, spellName)
    local buttonT = {}
    local spellT = spells_getSpellT(spellName)

    buttonT[100] = "print all"
    buttonT[101] = "Back"
    if spellT.formula then buttonT[102] = "formulas" end
    return buttonT
end

function spellInfoMW(player, mwID, buttonID, choiceID, choiceT)
    if not choiceT then print("fuck mah laif") end
    local spellWord = choiceT[1]:match("%!.+")
    local spellName = spellWord:match("%a+")

    if buttonID == 101 then return player:createMW(MW.spellBook) end
    if buttonID == 102 then return player:createMW(MW.spellFormulas, spellName) end
    local sortedT = sorting(choiceT, "low")

    player:sendTextMessage(BLUE, ">>> "..spellName.." <<<")
    for _, key in ipairs(sortedT) do player:sendTextMessage(ORANGE, choiceT[key]) end
    player:createMW(MW.spellBook)
end

function spellFormulaMW_choices(player, spellName)
local spellT = spells_getSpellT(spellName)
local formulaT = spellT.formula
local choiceT = {}

    for choiceID, t in ipairs(formulaT) do
        if t.func then
            choiceT[choiceID] = t.name..": "..t.func.." = "..value_formula(player, spellT, t, true)
        else
            local maxStr = t.max and " - "..t.max or ""
            choiceT[choiceID] = t.name..": "..t.min..maxStr.." = "..value_formula(player, spellT, t, true)
        end
    end
    return choiceT
end

function spellFormulaMW_save(player, spellName) return spellName end

function spellFormulaMW(player, mwID, buttonID, choiceID, spellName)
    if buttonID == 101 then return player:createMW(MW.spellInfo, spellName) end
local spellT = spells_getSpellT(spellName)
local formulaT = spellT.formula[choiceID]
local loopID = 0
local amount, msgT = value_formula(player, spellT, formulaT)
    
    if formulaT.func then
        player:sendTextMessage(ORANGE, spellName.." - "..formulaT.name..": "..formulaT.func.." = "..amount)
    else
        local min = formulaT.min and converFormulaToNumbers(player, formulaT.min)
        local max = formulaT.max and " - "..converFormulaToNumbers(player, formulaT.max) or ""
        
        player:sendTextMessage(ORANGE, spellName.." - "..formulaT.name..": "..min..max.." = "..amount)
    end
    
    for _, t in ipairs(msgT) do player:sendTextMessage(ORANGE, spellName.." - "..t.text) end
    player:createMW(MW.spellFormulas, spellName)
end

function spellBook_createMW(player) return player and player:createMW(MW.spellBook) end

function getSpellList(player)
    local str
        
    for spellName, t in pairs(spells) do
        if showSpell(player, t) then str = str and  str..", "..spellName or spellName end
    end
    return str or "*doesn't have spells*"
end