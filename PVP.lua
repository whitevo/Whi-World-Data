PVP_config = {
    cycleIncrease = 15, -- how much elo radius is increased each cycle
    countDown = 5,      -- in seconds
    defaultElo = 20,    -- winning elo points if both players have equal elo.
    topLeftCorner = {x = 575, y = 659, z = 8},
    botRightCorner = {x = 607, y = 695, z = 8},
    kickPos = {x = 578, y = 668, z = 7},
    leavePos = {x = 579, y = 669, z = 7},
    enterPos = {x = 591, y = 678, z = 8},
    winPoints = 25,
    lossPoints = 10,
}

PVP_waiting = {["1v1"] = {}, ["2v2"] = {}, ["3v3"] = {}, ["5v5"] = {}, ["10v10"] = {}}
--[[
.type[ID] = {
    players = {[guid] = cid}
    elo = INT           the ranked position points
    cycle = INT         how many times global matchmaker has tried to find match for 1 player (the elo radius increases every time)
}]]

PVP_fights = {}
--[[
[ID] = {
    type = STR                  PVP type (1v1, 2v2, etc)
    team1 = {[guid] = cid}
    team2 = {[guid] = cid}
    },
}]]

PVP_maps = { -- ranked maps
    [1] = {
        topLeftCorner = {x = 577, y = 665, z = 9},
        botRightCorner = {x = 588, y = 676, z = 9},
        inUse = false,              -- only used if this room is empty
        --clearPosT = {POS,}        -- generated in startUp with PVP_mapF
        --leftSidePosT = {POS,},    -- generated in startUp with PVP_mapF
        --rightSidePosT = {POS,},   -- generated in startUp with PVP_mapF
    },
    [2] = {
        topLeftCorner = {x = 593, y = 665, z = 9},
        botRightCorner = {x = 604, y = 676, z = 9},
    },
    [3] = {
        topLeftCorner = {x = 577, y = 681, z = 9},
        botRightCorner = {x = 588, y = 692, z = 9},
    },
    [4] = {
        topLeftCorner = {x = 593, y = 681, z = 9},
        botRightCorner = {x = 604, y = 692, z = 9},
    },
}

PVP_FFA_maps = { -- free for all maps
    [AID.areas.forgottenVillage.enterFFA] = {  -- UID of item which leads to this room (NB!! te leave UID MUST BE +1 in UID)
        topLeftCorner = {x = 610, y = 673, z = 9},
        botRightCorner = {x = 632, y = 684, z = 9},
        leavePos = {x = 610, y = 679, z = 8},
        --clearPosT = {POS,}        -- generated in startUp with PVP_mapF
    },
}

function PVP_mapF()
    for ID, t in pairs(PVP_maps) do
        local room = createSquare(t.topLeftCorner, t.botRightCorner)
        local clearPosT = removePositions(room, {"solid"})
        local leftSidePosT = {}
        local rightSidePosT = {}
        local minX = t.topLeftCorner.x
        local max2X = t.botRightCorner.x
        local middleLine = (max2X - minX) / 2
        local maxX = minX + middleLine - 1
        local min2X = max2X - middleLine + 1
        
        for _, pos in pairs(clearPosT) do
            local x = pos.x
            
            if x >= minX and x <= maxX then
                table.insert(leftSidePosT, pos)
            elseif x >= min2X and x <= max2X then
                table.insert(rightSidePosT, pos)
            end
        end
        
        PVP_maps[ID].clearPosT = clearPosT
        PVP_maps[ID].leftSidePosT = leftSidePosT
        PVP_maps[ID].rightSidePosT = rightSidePosT
    end
    
    for UID, t in pairs(PVP_FFA_maps) do
        local room = createSquare(t.topLeftCorner, t.botRightCorner)
        local clearPosT = removePositions(room, {"solid"})
        
        PVP_FFA_maps[UID].clearPosT = clearPosT
    end
end

function PVP_lever(player) PVP_MW(player) end

function PVP_register(player, type)
local cid = player:getId()
local t = PVP_waiting[type]
    if not t then return print("PVP_register() bugged, missing type["..tostring(type).."]") end
    if PVP_alreadyWaiting(player) then return player:sendTextMessage(GREEN, "You have are already registered in ranked and looking for opponent") end
    if PVP_alreadyFighting(player) then return player:sendTextMessage(GREEN, "You are about to enter PVP pit") end
local partyMembers = getPartyMembers(player)
local elo = PVP_teamElo(partyMembers, type)

    for guid, cid in pairs(partyMembers) do
        doSendTextMessage(cid, GREEN, "You have successfully registered to "..type)
    end
    
local regT = {
        players = partyMembers,
        elo = elo,
        cycle = 1,
    }
    table.insert(t, regT)
end

function PVP_unregister(player)
local ID, type = PVP_getRegIDByCID(player:getId())

    if ID then PVP_waiting[type][ID] = nil end
end

function PVP_alreadyWaiting(player)
    for type, t in pairs(PVP_waiting) do
        for ID, regT in pairs(t) do
            for _, cid in pairs(regT.players) do
                if player:getId() == cid then return true end
            end
        end
    end
end

function PVP_alreadyFighting(player)
    for ID, regT in pairs(PVP_fights) do
        for _, cid in pairs(regT.team1) do
            if player:getId() == cid then return true end
        end
        for _, cid in pairs(regT.team2) do
            if player:getId() == cid then return true end 
        end
    end
end

function PVP_matchmaker()
    clean_PVP()
    for type, t in pairs(PVP_waiting) do
        local eloRanges = {}
        
        for ID, regT in pairs(t) do
            local cid = randomValueFromTable(regT.players)
            local elo = regT.elo
            local c = regT.cycle
            local modifier = PVP_config.cycleIncrease
            local min = elo - modifier*c
            local max = elo + modifier*c
            
            regT.cycle = c + 1
            if min < 0 then min = 0 end
            
            eloRanges[cid] = {
                min = min,
                max = max,
            }
        end
        
        for cid, t in pairs(eloRanges) do
            if PVP_compareElo(cid, t, eloRanges) then break end
        end
    end
end

function PVP_compareElo(cid, t, eloRanges)
local min = t.min
local max = t.max

    for cid2, eloT in pairs(eloRanges) do
        if cid ~= cid2 then
            if eloT.min <= max and eloT.max >= min then
                local team1 = PVP_getTeamByCID(cid)
                local team2 = PVP_getTeamByCID(cid2)
                local ID1, type = PVP_getRegIDByCID(cid)
                local ID2, type2 = PVP_getRegIDByCID(cid2)
                    
                    PVP_waiting[type][ID1] = nil
                    PVP_waiting[type2][ID2] = nil
                return PVP_match(team1, team2)
            end
        end
    end
end

function PVP_getRegIDByCID(cid)
    for type, t in pairs(PVP_waiting) do
        for ID, regT in pairs(t) do
            for guid, cid2 in pairs(regT.players) do
                if cid == cid2 then
                    return ID, type
                end
            end
        end
    end
end

function PVP_getTeamByCID(playerID)
    for type, t in pairs(PVP_waiting) do
        for ID, regT in pairs(t) do
            for guid, cid in pairs(regT.players) do
                if playerID == cid then
                    return regT.players
                end
            end
        end
    end
end

function PVP_match(team1, team2)
local teamSize = tableCount(team1)
local pvpType = PVP_getType(teamSize)

    if pvpType then
        local ID = tableCount(PVP_fights) + 1
        local mapID = PVP_getMapID(pvpType)
        
        for guid, cid in pairs(team1) do
            PVP_start(Player(cid), pvpType, ID, mapID, 1)
        end
        for guid, cid in pairs(team2) do
            PVP_start(Player(cid), pvpType, ID, mapID, 2)
        end
        PVP_fights[ID] = {
            type = pvpType,
            team1 = team1,
            team2 = team2,
            mapID = mapID,
        }
        return true
    end
end

function PVP_start(player, type, ID, mapID, teamN)
    removeBuffsAndDebuffs(player)
    PVP_startCountDown(player, type)
    PVP_teleport(player, mapID, teamN)
    setSV(player, SV.arenaRegN, ID)
    setSV(player, SV.PVPEnabled, 1)
    equipTempPVPitems(player)
    player:addHealth(1000)
    player:addMana(1000)
end

function PVP_startCountDown(player, type)
local cid = player:getId()
local countdown = PVP_config.countDown

    player:sendTextMessage(ORANGE, "----- RANKED "..type.." IS STARTING -----")
    for x=0, countdown-1 do
        addEvent(doSendTextMessage, 1000*x, cid, BLUE, tostring(countdown-x))
    end
    addEvent(doSendTextMessage, countdown*1000, cid, ORANGE, "Good Luck")
end

function PVP_teleport(player, mapID, teamSide)
local map = PVP_maps[mapID]
local posistions

    if teamSide == 1 then
        posistions = map.leftSidePosT
    else
        posistions = map.rightSidePosT
    end
    
local posT = randomPos(posistions, 1)
local pos = posT[1]

    addEvent(teleport, PVP_config.countDown*1000, player:getId(), pos)
end

function PVP_getMapID(type)
local availableMaps = {}
    
    for ID, t in pairs(PVP_maps) do
        if not t.inUse then table.insert(availableMaps, ID) end
    end
local mapID = availableMaps[math.random(1, tableCount(availableMaps))]
local map = PVP_maps[mapID]
    
    map.inUse = true
return mapID
end

function PVP_arenaDeath(player)
    if compareSV(player, SV.arenaRegN, ">", 0) then
        local cid = player:getId()
        local regN = getSV(player, SV.arenaRegN)
        local pvpT = PVP_fights[regN]
        if not pvpT then return removeSV(player, SV.arenaRegN), print("something is wrong with PVP_arenaDeath()") end
        local team1 = pvpT.team1
        local team2 = pvpT.team2
        
        removeSV(player, SV.arenaRegN)
        
        if matchTableValue(team1, cid) then
            if not PVP_teamFighting(team1) then
                PVP_endMatch(team2, team1, regN)
            end
        elseif matchTableValue(team2, cid) then
            if not PVP_teamFighting(team2) then
                PVP_endMatch(team1, team2, regN)
            end
        else
            Uprint(PVP_fights, "ENTIRE PVP FIGHTING TABLE")
            print("PVP is bugged or player["..cid.."] had somehow wrong regN ["..regN.."] in PVP_arenaDeath()")
        end
        
        return true
    end
end

function PVP_teamFighting(team)
    for guid, cid in pairs(team) do
        if compareSV(cid, SV.arenaRegN, ">", 0) then return true end
    end
end

function PVP_endMatch(winTeam, lossTeam, regN)
local teamSize = tableCount(winTeam)
local pvpType = PVP_getType(teamSize)
local elo1 = PVP_teamElo(winTeam, pvpType)
local elo2 = PVP_teamElo(lossTeam, pvpType)
local totalEloWin = PVP_eloFormula(elo1, elo2)
local maxElo = PVP_config.defaultElo*2
local mapID = PVP_fights[regN].mapID
    
    PVP_maps[mapID].inUse = false
    
    for guid, cid in pairs(winTeam) do
        local player = Player(cid)
        local elo = getElo(guid, pvpType)
        local newElo = totalEloWin
        
        if elo < elo1 then
            local modifier = math.floor((elo1 - elo)/5)
            newElo = totalEloWin + modifier
        elseif elo > elo1 then
            local modifier = math.floor((elo - elo1)/5)
            newElo = totalEloWin - modifier
        end
        
        newElo = PVP_eloCheck(newElo)
        
        if player then
            local arenaPoints = PVP_APformula(player, elo)
            player:sendTextMessage(ORANGE, "You won "..pvpType.." and earned: "..newElo.." elo points!")
            restorePVP(player)
            removePVPItems(player)
            PVProomTP(player)
            PVP_addAP(player, arenaPoints + PVP_config.winPoints)
        end
        
        addElo(guid, pvpType, newElo)
    end
    
    for guid, cid in pairs(lossTeam) do
        local elo = getElo(guid, pvpType)
        local player = Player(cid)
        local newElo = totalEloWin
        
        if elo < elo2 then
            local modifier = math.floor((elo2 - elo)/5)
            newElo = totalEloWin + modifier
        elseif elo > elo2 then
            local modifier = math.floor((elo - elo2)/5)
            newElo = totalEloWin - modifier
        end
        
        newElo = PVP_eloCheck(newElo)
        
        if player then
            local arenaPoints = PVP_APformula(player, elo)
            player:sendTextMessage(ORANGE, "You lost "..pvpType.." and "..newElo.." elo points!")
            PVP_addAP(player, arenaPoints + PVP_config.lossPoints)
        end
        addElo(guid, pvpType, -newElo)
    end
    
    PVP_fights[regN] = nil
end

function PVProomTP(player)
local playerPos = player:getPosition()
local upCorner = deepCopy(PVP_config.topLeftCorner)
local downCorner = deepCopy(PVP_config.botRightCorner)
    
    if isInRange(playerPos, upCorner, downCorner) then
        return player:teleportTo(PVP_config.kickPos)
    end
    upCorner.z = 9
    downCorner.z = 9
    if isInRange(playerPos, upCorner, downCorner) then
        return player:teleportTo(PVP_config.kickPos)
    end
end

function PVP_FFATPOut(player)
local playerPos = player:getPosition()

    for _, ffaT in pairs(PVP_FFA_maps) do
        local upCorner = ffaT.topLeftCorner
        local downCorner = ffaT.botRightCorner
        
        if isInRange(playerPos, upCorner, downCorner) then
            playerPos.z = playerPos.z - 1
            return teleport(player, playerPos)
        end
    end
end

function PVP_APformula(player, elo)
local arenaPoints = 0
    if elo > 500 then
        arenaPoints = math.floor((elo-500)/50)
    end
return arenaPoints
end

function PVP_addAP(player, points)
    addSV(player, SV.arenaPoints, points)
    player:sendTextMessage(ORANGE, "You earned "..points.." arena points. You have now total of "..getSV(player, SV.arenaPoints).." arena points.")
end

function PVP_teamElo(team, type)
local elo = 0

    for guid, cid in pairs(team) do
        elo = elo + getElo(guid, type)
    end
    elo = math.floor(elo/tableCount(team))
return elo
end

function PVP_eloFormula(elo1, elo2)
local defaultElo = PVP_config.defaultElo
local elo = 0

    if elo1 >= elo2 then
        local base = elo1 - elo2
        
        if base <= defaultElo then return defaultElo end
        elo = defaultElo - math.floor(base/defaultElo)
    else
        local base = elo2 - elo1
        
        if base <= defaultElo then return defaultElo end
        elo = defaultElo + math.floor(base/defaultElo)
    end
    
    elo = PVP_eloCheck(elo)
return elo
end

function PVP_eloCheck(elo)
local defaultElo = PVP_config.defaultElo

    if elo > defaultElo*2 then return defaultElo*2 end
    if elo < 1 then return 1 end
return elo
end
    
function PVP_getType(teamSize)
    if teamSize == 1 then return "1v1" end
return false, print("PVP_getType() teamsize was: "..teamSize)
end

function PVP_stairsUp(player)
    if PVP_alreadyFighting(player) then
        teleport(player, PVP_config.enterPos)
        return player:sendTextMessage(GREEN, "Too late to leave, you would automatically loose.")
    end
    PVP_unregister(player)
    restorePVP(player)
    teleport(player, PVP_config.leavePos)
end

function PVP_FFA_ladderUp(player, item)
local mapID = item:getUniqueId()
local map = PVP_FFA_maps[mapID-1]
    
    teleport(player, map.leavePos)
    removeSV(player, SV.PVPEnabled)
   -- removePVPItems(player)
end

function PVP_FFA_ladderDown(player, item)
local mapID = item:getUniqueId()
local map = PVP_FFA_maps[mapID]
local posT = randomPos(map.clearPosT, 1)
local pos = posT[1]
    
    player:addHealth(10000)
    player:addMana(10000)
    teleport(player, pos)
    setSV(player, SV.PVPEnabled, 1)
    setSV(player, SV.deathProtection, 1)
  --  equipTempPVPitems(player)
end

function PVP_enterPVProom(player)
    if not player:isPlayer() then return end
    
    if player:getLevel() < 3 then return player:sendTextMessage(GREEN, "Only players who are level 3 or higher can enter PVP room") end
    if player:hasFood() then return player:sendTextMessage(GREEN, "Can't enter PVP room with food in the bag.") end
    if getSV(player, SV.tradeWindowClosedTime) > os.time() then return player:sendTextMessage(GREEN, "Can't enter PVP shortly after trading with NPC") end
    if getSV(player, SV.arenaPoints) < 0 then PVP_addAP(player, 101) end
    removeSV(player, SV.PVPEnabled)
    teleport(player, PVP_config.enterPos)
end

function clean_PVP()
local tablesDeleted = 0
    
    for ID, t in pairs(PVP_fights) do
        local allOffline = true
        for _, cid in pairs(t.team1) do
            if Player(cid) then
                allOffline = false
                break
            end
        end
        if allOffline then
            for _, cid in pairs(t.team1) do
                if Player(cid) then
                    allOffline = false
                    break
                end
            end
        end
        if allOffline then
            tablesDeleted = tablesDeleted + 1
            PVP_fights[ID] = nil
        end
    end
    for type, t in pairs(PVP_waiting) do
        for ID, regT in pairs(t) do
            for _, cid in pairs(regT.players) do
                if not Player(cid) then
                    tablesDeleted = tablesDeleted + 1
                    t[ID] = nil
                    break
                end
            end
        end
    end
return tablesDeleted
end

function PVP_MW(player)
local window = ModalWindow(MW.rankedPVP, "Ranked PVP", "Choose PVP option.")
    
    window:addChoice(1, "Ranked 1v1")
    window:addChoice(2, "Ranked 2v2")
    window:addChoice(3, "Ranked 3v3")
    window:addChoice(4, "Ranked 5v5")
    window:addChoice(5, "Ranked 10v10")
	window:addButton(100, "choose")
	window:addButton(101, "close")
    window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)
	window:sendToPlayer(player)
end

function personalPVP_MW(player)
local window = ModalWindow(MW.tempPVP_window, "temporar PVP window", "Change PVP equipment.")
    
    window:addChoice(1, "Ranked 1v1 elo: "..getElo(player:getGuid(), "1v1"))
	window:addButton(100, "change")
	window:addButton(101, "close")
    window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)
	window:sendToPlayer(player)
end

function changePVPItems(player)
local window = ModalWindow(MW.tempPVP_items, "temporar PVP items", "PVP items will be equipped automatically when entering PVP pit.")
    
    window:addChoice(1, "head slot: "..tempPVPitem(player, "head"))
    window:addChoice(2, "body slot: "..tempPVPitem(player, "body"))
    window:addChoice(3, "legs slot: "..tempPVPitem(player, "legs"))
    window:addChoice(4, "boots slot: "..tempPVPitem(player, "boots"))
    window:addChoice(5, "weapon slot: "..tempPVPitem(player, "weapon"))
    window:addChoice(6, "shield slot: "..tempPVPitem(player, "shield"))
	window:addButton(100, "change")
	window:addButton(101, "close")
	window:addButton(102, "stats")
    window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)
	window:sendToPlayer(player)
end

local tempSlot = {}
function PVPitemList(player, slot)
local window = ModalWindow(MW.tempPVP_equip, "temporar PVP items", "Choose PVP item to equip when entering PVP pit")
local IDModifier = getTempPVPItemIDMod(slot)
local loopID = 0

    for itemID, t in pairs(itemTable[slot]) do
        loopID = loopID + 1
        if compareSV(player, SV[itemID], ">=", 1) then
            window:addChoice(IDModifier + loopID, ItemType(itemID):getName())
        end
    end
    
    tempSlot[player:getId()] = slot
	window:addButton(100, "look")
	window:addButton(101, "close")
	window:addButton(102, "equip")
    window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)
	window:sendToPlayer(player)
end

function onModalWindow(player, modalWindowId, buttonId, choiceId)
    if modalWindowId == MW.rankedPVP then
        if choiceId == 255 then return end
        if buttonId == 101 then return end
        
        if choiceId == 1 then
            if tableCount(getPartyMembers(player)) > 1 then return player:sendTextMessage(ORANGE, "Leave party to join 1v1") end
            return PVP_register(player, "1v1")
        else
            player:sendTextMessage(ORANGE, "There is barely any players playing Whi World at this moment, I have not scripted PVP for more than 2 players.")
        end
        return PVP_MW(player)
    elseif modalWindowId == MW.tempPVP_window then
        if choiceId == 255 then return end
        if buttonId == 101 then return end
        
        changePVPItems(player)
    elseif modalWindowId == MW.tempPVP_items then
        if choiceId == 255 then return end
        if buttonId == 101 then return end
        
        if buttonId == 102 then
            PVP_itemStats(player)
            return changePVPItems(player)
        end
        
        if choiceId == 1 then
            PVPitemList(player, "head")
        elseif choiceId == 2 then
            PVPitemList(player, "body")
        elseif choiceId == 3 then
            PVPitemList(player, "legs")
        elseif choiceId == 4 then
            PVPitemList(player, "boots")
        elseif choiceId == 5 then
            PVPitemList(player, "weapon")
        elseif choiceId == 6 then
            PVPitemList(player, "shield")
        end
    elseif modalWindowId == MW.tempPVP_equip then
        if choiceId == 255 then return changePVPItems(player) end
        if buttonId == 101 then return changePVPItems(player) end
        local slot = tempSlot[player:getId()]
        local IDModifier = getTempPVPItemIDMod(slot)
        local loopID = 0
        
        if buttonId == 102 then
            for itemID, t in pairs(itemTable[slot]) do
                loopID = loopID + 1
                
                if compareSV(player, SV[itemID], "==", 2) then
                    setSV(player, SV[itemID], 1)
                end
                
                if choiceId == loopID + IDModifier then
                    setSV(player, SV[itemID], 2)
                end
            end
        elseif buttonId == 100 then
            for itemID, t in pairs(itemTable[slot]) do
                loopID = loopID + 1
                
                if choiceId == loopID + IDModifier then
                    local itemStatT = getItemStats(itemID)
                    
                    player:sendTextMessage(ORANGE, itemStatT:generateLookInfo(player))
                    return PVPitemList(player, slot)
                end
            end
        end
        return changePVPItems(player)
    end
end

-- types: "1v1", "2v2", etc
function getElo(guid, type)
local dbT = "`arena_"..type.."`"
local playerData = db.storeQuery("SELECT `elo` FROM "..dbT.." WHERE `playerid` = "..guid)
local elo = 1000

    if playerData then return DBNumberResultReader(playerData, "elo") end
    db.query("INSERT INTO "..dbT.."(`playerid`) VALUES ("..guid..")")
    return elo
end

function addElo(guid, type, newElo)
local dbT = "`arena_"..type.."`"
local playerData = db.storeQuery("SELECT `elo` FROM "..dbT.." WHERE `playerid` = "..guid)
    
    if not playerData then return print("addElo() happened before player even had elo Oo!?") end
local elo = DBNumberResultReader(playerData, "elo")
local totalElo = math.max(elo + newElo, 1)

    db.query("UPDATE "..dbT.." SET `elo` = "..totalElo.." WHERE `playerid` = "..guid)
end