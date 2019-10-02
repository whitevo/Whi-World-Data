local feature_displayBuffs = {
    modalWindows = {
        [MW.durationBuffs] = {
            name = "Duration buffs",
            title = "currently ongoing effects",
            choices = "durationBuffsMW_choices",
            buttons = {
                [100] = "more info",
                [101] = "Close",
            },
            say = "Checking ongoing effect durations",
            func = "durationBuffsMW",
        }
    }
}

centralSystem_registerTable(feature_displayBuffs)
    
local savedBuffs = {}
function durationBuffsMW_choices(player)
    local choiceT = {}
    local allBuffT = player:getDurationBuffs()
    
    savedBuffs[player:getId()] = allBuffT
	for i, buffT in ipairs(allBuffT) do
        local extraText = buffT.extra or ""
        choiceT[i] = buffT.name..extraText.." - "..getTimeText(buffT.duration)
    end
    return choiceT
end

function durationBuffsMW(player, mwID, buttonID, choiceID)
    local playerID = player:getId()
    if buttonID == 101 then savedBuffs[playerID] = nil return end
    
    local allBuffT = savedBuffs[playerID]
    local buffT = allBuffT[choiceID]
    if not buffT then return end

    if buffT.effect then
        if type(buffT.effect) == "table" then
            for _, msg in ipairs(buffT.effect) do player:sendTextMessage(ORANGE, msg) end
        else
            player:sendTextMessage(ORANGE, buffT.effect)
        end
    end
    savedBuffs[playerID] = nil
    player:createMW(mwID)
end

function durationBuffs_createMW(player) return player and player:createMW(MW.durationBuffs) end

-- get functions
function Player.hasDurationBuffs(player) return player:getDurationBuffs(true) end
function hasDurationBuffs(player) return player and player:hasDurationBuffs() end

function Player.getDurationBuffs(player, onlyCheck)
    local allBuffs = {}
    local loopID = 0

    local function addBuff(buffT)
        if onlyCheck then return true end

        if buffT[1] then
            for _, buffT in ipairs(buffT) do addBuff(buffT) end
        else
            loopID = loopID + 1
            allBuffs[loopID] = buffT
        end
    end

    local buffDisplayFunctions = {
        food_buffDisplay,
        dishes_buffDisplay,
        potions_buffDisplay,
        gemDefSpell_buffDisplay,
        armorup_buffDisplay,
        poison_buffDisplay,
        innervate_buffDisplay,
        bianhurenReflect_buffDisplay,
        druidBuff_buffDisplay,
        deathTime_buffDisplay,
    }
    
    for _, func in ipairs(buffDisplayFunctions) do
        local buffT = func(player, onlyCheck)
        if buffT and addBuff(buffT) then return true end
    end
    return not onlyCheck and allBuffs
end

function dishes_buffDisplay(player, onlyCheck)
    local buffT = {}
    local currentTime = os.time()
    
    local function checkFood(foodName, effectT)
        if not effectT then return end

        for buffName, t in pairs(effectT) do
            if player:getSV(t.ID) > 0 then
                local startTime = player:getSV(t.startTimeSec) + t.duration/1000

                if currentTime < startTime then
                    if onlyCheck then return true end
                    table.insert(buffT, {name = foodName, duration = startTime - currentTime, effect = "increases "..buffName.." by "..t.value})
                end
            end
        end
    end
    
    for _, foodT in pairs(foodConf.food) do
        if checkFood(foodT.foodName, foodT.effect) then return true end
    end
    return tableCount(buffT) > 0 and buffT
end

function food_buffDisplay(player, onlyCheck)
    local buffT = {}
    local foodT = registratedFood[player:getId()]

    if foodT and foodT.mp and tableCount(foodT.mp) > 0 then
        if onlyCheck then return true end
        local vocModT = food_getVocModT(player)
        local totalDuration = 0
        local startTime
        local highestHP = 0
        local highestMP = 0

        for foodLevel, t in pairs(foodT.mp) do
            totalDuration = totalDuration + t.duration
            if foodLevel > highestMP then highestMP = foodLevel end
            if not startTime then startTime = t.startTime end
        end

        for foodLevel, t in pairs(foodT.hp) do
            if foodLevel > highestHP then highestHP = foodLevel end
        end
        
        if highestHP > 0 then highestHP = highestHP + vocModT.extraHP end
        if highestMP > 0 then highestMP = highestMP + vocModT.extraMP end

        totalDuration = totalDuration - (os.time() - startTime)
        table.insert(buffT, {name = "food", duration = totalDuration, effect = "Adds "..highestHP.." health and "..highestMP.." mana every second"})
    end
    return tableCount(buffT) > 0 and buffT
end

function potions_buffDisplay(player, onlyCheck)
    local buffT = {}
    local currentTime = os.time()

    local function checkPotion(potionT, buffOrNerf)
        local effectT = potionT[buffOrNerf]
        if not effectT.endTimeSec then return end

        local endTime = getSV(player, effectT.endTimeSec)
        if currentTime > endTime then return end
        if onlyCheck then return true end
        
        local effectStr = effectT.effect
        local value = _G[effectT.funcStr](player, potionT, true)
        
        effectStr = effectStr:gsub("VALUE", value)
        table.insert(buffT, {name = potionT.name, duration = endTime - currentTime, extra = " ("..buffOrNerf..")", effect = effectStr})
    end
    
    for potionName, potionT in pairs(potions) do
        if checkPotion(potionT, "buff") then return true end
        if checkPotion(potionT, "nerf") then return true end
    end
    return tableCount(buffT) > 0 and buffT
end

function deathTime_buffDisplay(player)
    local deathTime = getPlayerDeathTimeByGUID(player:getGuid())
    local hardcoreDoorTime = deathTime + 2*60*60
    local currentTime = os.time()
    
    if hardcoreDoorTime <= currentTime then return end
    return {name = "death timer", duration = hardcoreDoorTime - currentTime, extra = " (debuff)", effect = "While this active, you can not pass trough hardcore doors"}
end

function druidBuff_buffDisplay(player)
    if bianhurenActivate(player, 1, nil, true) then return end
    local eventT = getAddEvent(player, "druidBuff")
    if not eventT then return end
    
    local timeLeft = eventT:timeLeft()
    return {name = "druid buff", duration = timeLeft, extra = " (buff)", effect = "gives "..player:getSV(SV.buffSpell).."% overall damage reduction"}
end
    
function bianhurenReflect_buffDisplay(player)
    local reflectAmount = player:getSV(SV.bianhurenReflect)
    if not bianhurenActivate(player, reflectAmount, nil, true) then return end
    
    local eventT = getAddEvent(player, "druidBuff_reflect")
    if not eventT then return end    

    local timeLeft = eventT:timeLeft()
    return {name = "druid buff", duration = timeLeft, extra = " (buff)", effect = "reflects "..reflectAmount.."% of physical damage"}
end
    
function innervate_buffDisplay(player)
    local eventT = getAddEvent(player, "innervate")
    if not eventT then return end

    local timeLeft = eventT:timeLeft()
    return {name = "innervate", duration = timeLeft, extra = " (buff)", effect = "regenerates mana rapidly"}
end

function poison_buffDisplay(player)
    local eventT = getAddEvent(player, "hunterPoison")
    if not eventT then return end

    local timeLeft = eventT:timeLeft()
    return {name = "poison", duration = timeLeft, extra = " (buff)", effect = "your range or close combat weapons will debuff targets with poison spell"}
end

function armorup_buffDisplay(player)
    local eventT = getAddEvent(player, "armorup")
    if not eventT then return end

    local timeLeft = eventT:timeLeft()
    return {name = "armorup", duration = timeLeft, extra = " (buff)", effect = "increases your armor by "..player:getSV(SV.armorUpSpell)}
end

function gemDefSpell_buffDisplay(player)
    local buffT = {}
    local currentTime = os.time()
    local svT = {
        [SV.rubyDefSpell] = "fire",
        [SV.opalDefSpell] = "physical",
        [SV.sapphdefSpell] = "ice",
        [SV.onyxdefSpell] = "death",
    }
    for spellSV, damType in pairs(svT) do
        local protectionAmount = player:getSV(spellSV)

        if protectionAmount > 0 then
            local timeLeft = player:getSV(spellSV + 20000) - currentTime
    
            if timeLeft > 0 then
                local effectT = {"Increases "..damType.." resistance against first "..damType.." hit", "Heals 2 times the amount resisted"}
                table.insert(buffT, {name = damType.." protection", duration = timeLeft, extra = " (buff)", effect = effectT})
            end
        end
    end
    return tableCount(buffT) > 0 and buffT
end
