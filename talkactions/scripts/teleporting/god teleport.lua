feature_god_teleport = {
    modalWindows = {
        [MW.god_teleport] = {
            name = "god teleport panel",
            title = "Choose where to teleport",
            choices = "god_teleportMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "*preparing to teleport*",
            func = "god_teleportMW",
        },
        [MW.god_teleport_toPlayer] = {
            name = "god teleport panel",
            title = "Choose player to teleport on",
            choices = "god_teleport_toPlayerMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            func = "god_teleport_toPlayerMW",
        },
        [MW.god_teleport_toBoss] = {
            name = "god teleport panel",
            title = "Choose boss to teleport on",
            choices = "god_teleport_toBossMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            func = "god_teleport_toBossMW",
        },
        [MW.god_teleport_toNpc] = {
            name = "god teleport panel",
            title = "Choose npc to teleport on",
            choices = "god_teleport_toNpcMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            func = "god_teleport_toNpcMW",
        },
    }
}

    
centralSystem_registerTable(feature_god_teleport)

--[[    god_teleportConf guide
    [STR] = POS         STR = location name | POS = position
]]
local god_teleportConf = {
    ["town"] = {x = 572, y = 658, z = 7},
    ["tutorial"] = {x = 526, y = 762, z = 8},
    ["maya"] =  {x = 407, y = 613, z = 6},
    ["temple"] = {x = 695, y = 595, z = 7},
    ["catacombs"] = {x = 614, y = 753, z = 8},
    ["hehem"] = {x = 442, y = 627, z = 12},
    ["forest"] = {x = 544, y = 549, z = 7},
    ["forest2"] = {x = 701, y = 538, z = 7},
    ["itemroom"] = {x = 653, y = 631, z = 8},
}

function onSay(player, words, param)
    if not player:isGod() then return true end
    if Creature(param) then return false, teleport(player, Creature(param):getPosition()) end
local bossNameT = god_teleport_toBossMW_choices(player)

    if isInArray(bossNameT, param) then
        for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
            if bossT.kickPos then
                local bossName = type(bossT.bossName) == "table" and bossT.bossName[1] or bossT.bossName
                if bossName == param then return false, player:teleportTo(bossT.kickPos) end
            end
        end
    end
    if god_teleportConf[param] then return false, teleport(player, god_teleportConf[param]) end
    return false, player:createMW(MW.god_teleport)
end

function god_teleportMW_choices(player)
local choiceT = {}
local loopID = 3
    
    choiceT[1] = "on player"
    choiceT[2] = "on npc"
    choiceT[3] = "to bossRoom"
	for locationName, pos in pairs(god_teleportConf) do
        loopID = loopID + 1
		choiceT[loopID] = locationName
	end
    return choiceT
end


function god_teleportMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 1 then return player:createMW(MW.god_teleport_toPlayer) end
    if choiceID == 2 then return player:createMW(MW.god_teleport_toNpc) end
    if choiceID == 3 then return player:createMW(MW.god_teleport_toBoss) end
local loopID = 3

    for locationName, pos in pairs(god_teleportConf) do
        loopID = loopID + 1
        if loopID == choiceID then return player:teleportTo(pos) end
	end
end

function god_teleport_toBossMW_choices(player)
local choiceT = {}
local loopID = 0
    
    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.kickPos then
            local bossName = bossT.bossName
            
            loopID = loopID + 1
            if type(bossName) == "table" then bossName = bossName[1] end
            choiceT[loopID] = bossName
        end
    end
    return choiceT
end

function god_teleport_toBossMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.god_teleport) end
local loopID = 0

    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.kickPos then
            loopID = loopID + 1
            if loopID == choiceID then return player:teleportTo(bossT.kickPos) end
        end
	end
end

function god_teleport_toPlayerMW_choices(player)
    local choiceT = {}
    local loopID = 0
    local playerID = player:getId()

    for _, player in pairs(Game.getPlayers()) do
        if player:getId() ~= playerID then
            loopID = loopID + 1
            choiceT[loopID] = player:getName()
        end
    end
    modalWindow_savedDataByPid[playerID] = choiceT
    return choiceT
end

function god_teleport_toPlayerMW(player, mwID, buttonID, choiceID, playerT)
    if buttonID == 101 then return player:createMW(MW.god_teleport) end
    if choiceID == 255 then return end
    local playerName = playerT[choiceID]
    local target = Player(playerName)
        
    if not target then return player:sendTextMessage(GREEN, "this player is no longer online") end
    teleport(player, target:getPosition()) 
end

function god_teleport_toNpcMW_choices(player)
    local choiceT = {}
    local loopID = 0

    for _, npcName in ipairs(npc_conf.allNpcNames) do
        if Creature(npcName) then
            loopID = loopID + 1
            choiceT[loopID] = npcName
        end
    end
    modalWindow_savedDataByPid[player:getId()] = choiceT
    return choiceT
end

function god_teleport_toNpcMW(player, mwID, buttonID, choiceID, npcT)
    if buttonID == 101 then return player:createMW(MW.god_teleport) end
    if choiceID == 255 then return end
local npcName = npcT[choiceID]
local target = Creature(npcName)
    
    if not target then return player:sendTextMessage(GREEN, npcName.." no longer exists") end
    teleport(player, target:getPosition()) 
end