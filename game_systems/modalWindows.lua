local spamDelayT = {}
function modalWindows_createMW(playerID, mwID, param1, param2)
    local player = Player(playerID)
    if not player then return end
    
    local mwT = modalWindows[mwID]
    if not mwT then return print("missing modal window table| mwID - ["..mwID.."]") end
    
    local spamDelay = mwT.spamDelaySec

    if spamDelay then
        if spamDelayT[mwID] then return false, player:sendTextMessage(GREEN, "This modalwindow uses spamDelay, try again in "..getTimeText(spamDelayT[mwID])) end
        spamDelayT[mwID] = spamDelay
        addEvent(function() spamDelayT[mwID] = nil end, spamDelay*1000)
    end

    local name = mwT.name
    local title = mwT.title

    if type(name) == "string" then
        if _G[name] then name = _G[name] end
    end
    if type(name) == "function" then name = name(player, param1, param2) end

    if type(title) == "string" then
        if _G[title] then title = _G[title] end
    end
    if type(title) == "function" then title = title(player, param1, param2) end

    local window = ModalWindow(mwID, name, MWTitle(title))
    local choiceT = mwT.choices
    local buttonT = mwT.buttons
    
    if type(choiceT) == "string" then choiceT = _G[choiceT] end
    if type(buttonT) == "string" then buttonT = _G[buttonT] end
    if type(choiceT) == "function" then choiceT = choiceT(player, param1, param2) end
    if type(buttonT) == "function" then buttonT = buttonT(player, param1, param2) end
    
    for choiceID, v in pairs(choiceT) do
        if type(v) == "function" then
            local text = v(player, param1, param2)
            if text then window:addChoice(choiceID, text) end
        elseif type(_G[v]) == "function" then
            local text = _G[v](player, param1, param2)
            if text then window:addChoice(choiceID, text) end
        else
            window:addChoice(choiceID, v)
        end
    end
    
    for buttonID, v in pairs(buttonT) do
        if type(v) == "function" then
            local text = v(player, param1, param2)
            if text then window:addButton(buttonID, text) end
        elseif type(_G[v]) == "function" then
            local text = _G[v](player, param1, param2)
            if text then window:addButton(buttonID, text) end
        else
            window:addButton(buttonID, v)
        end
    end

    local save =  mwT.save
    local playerID = player:getId()

    if save then
        if type(save) == "string" then
            if save == "saveParams" then
                local saveData = param2 and {param1, param2} or param1
                modalWindow_savedDataByPid[playerID] = saveData
            elseif save == "choiceT" then
                modalWindow_savedDataByPid[playerID] = choiceT
            else
                save = _G[save]
            end
        end
        if type(save) == "function" then modalWindow_savedDataByPid[playerID] = save(player, param1, param2) end
    end

    if mwT.say and antiSpam(playerID, mwT.say, 5000) then player:say(mwT.say, ORANGE) end
	window:setDefaultEnterButton(mwT.enterButton or 100)
	window:setDefaultEscapeButton(mwT.escButton or 101)
	return window:sendToPlayer(player)
end

function saveParam1(player, param1) modalWindow_savedDataByPid[player:getId()] = param1 end
function clean_modalWindow_savedDataByPid() return clean_cidList(modalWindow_savedDataByPid, true) end
