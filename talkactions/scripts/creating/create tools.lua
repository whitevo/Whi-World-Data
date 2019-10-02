feature_god_createTools = {
    modalWindows = {
        [MW.god_createTools] = {
            name = "Create Tools",
            title = "Choose tool to make",
            choices = "tools_createMW_choices",
            buttons = {
                [100] = "create",
                [101] = "Close",
            },
            say = "*creating tools*",
            func = "tools_createMW",
        },
    }
}

centralSystem_registerTable(feature_god_createTools)

function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createTools)
end

function tools_createMW_choices(player)
local choiceT = {
    [1] = ItemType(toolsConf.saws[1]):getName(),
    [2] = ItemType(toolsConf.hammers[1]):getName(),
    [3] = ItemType(toolsConf.herbknives[1]):getName(),
    [4] = ItemType(toolsConf.pickaxes[1]):getName(),
    [5] = ItemType(toolsConf.shovels[1]):getName(),
}   
    return choiceT
end

function tools_createMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 1 then return player:giveItem(toolsConf.saws[1], 1, AID.other.tool, nil, "charges(20)") end
    if choiceID == 2 then return player:giveItem(toolsConf.hammers[1], 1, AID.other.tool, nil, "charges(20)") end
    if choiceID == 3 then return player:giveItem(toolsConf.herbknives[1], 1, AID.other.tool, nil, "charges(20)") end
    if choiceID == 4 then return player:giveItem(toolsConf.pickaxes[1], 1, AID.other.tool, nil, "charges(20)") end
    if choiceID == 5 then return player:giveItem(toolsConf.shovels[1], 1, AID.other.tool, nil, "charges(20)") end
end