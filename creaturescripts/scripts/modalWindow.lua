function onModalWindow(player, mwID, buttonID, choiceID)
    local mwT = modalWindows[mwID]
    if not mwT then return end

    local func = mwT.func
    if not func then return end

    if type(func) == "string" then func = _G[func] end
    if not func then return end
    return func(player, mwID, buttonID, choiceID, modalWindow_savedDataByPid[player:getId()])
end