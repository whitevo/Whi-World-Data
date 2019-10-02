if not global_monsterList then
    global_monsterList = {} -- [monsterID] = true
end

function Game.getMonsters() -- in future allow POS parameter so we can search monster by sections | this means creating monsters need to be consistent
    local monsterList = {}
    local loopID = 0
    local ignoreMonsterNameList = {"training pole", "bandit ambush", "blessed pillar", "token", "strut", "tutorial pole", "imp", "bone wall"}

    local function addMonster(monsterID)
        local monster = Monster(monsterID)
        if not monster then global_monsterList[monsterID] = nil return end
        if monster:isNpc() then global_monsterList[monsterID] = nil return end
        if isInArray(ignoreMonsterNameList, monster:getRealName()) then global_monsterList[monsterID] = nil return end
        loopID = loopID + 1
        monsterList[loopID] = monster
    end

    for monsterID, _ in pairs(global_monsterList) do addMonster(monsterID) end
    return monsterList
end

-- This guy who is stuck in map sends all the messages :D
function text(text, position)
    if not Position(position) then return end
    local messenger = Tile({x = 626, y = 658, z = 8}):getBottomCreature()
    return messenger:say(text, ORANGE, true, nil, position)
end

function doSendMagicEffect(pos, effectT, interval)
    if not effectT then return end

    if interval then
        if type(effectT) == "number" then return addEvent(doSendMagicEffect, interval, pos, effectT) end
        for i, effect in ipairs(effectT) do addEvent(doSendMagicEffect, (i-1)*interval, pos, effect) end
    else
        local position = Position(pos)
        if type(effectT) == "number" then return position:sendMagicEffect(effectT) end
        for _, effect in ipairs(effectT) do position:sendMagicEffect(effect) end
    end
    return true
end

function getPosition(objectID)
    local object = Creature(objectID)
    return object and object:getPosition()
end

function doSendDistanceEffect(startPos, endPos, effect)
    if type(startPos) == "number" then startPos = getPosition(startPos) end
    if type(endPos) == "number" then endPos = getPosition(endPos) end
    return startPos and endPos and Position(startPos):sendDistanceEffect(endPos, effect)
end

function spiralEffect(pos, magicEffect, distanceEffect)
    local tempPosX = pos.x
    local tempPosY = pos.y
    local tempPosZ = pos.z
    local positions = {}
        
    table.insert(positions, {x=tempPosX,    y=tempPosY,     z=tempPosZ})
    table.insert(positions, {x=tempPosX,    y=tempPosY-1,   z=tempPosZ})
    table.insert(positions, {x=tempPosX-1,  y=tempPosY,     z=tempPosZ})
    table.insert(positions, {x=tempPosX,    y=tempPosY+1,   z=tempPosZ})
    table.insert(positions, {x=tempPosX+1,  y=tempPosY,     z=tempPosZ})
    table.insert(positions, {x=tempPosX,    y=tempPosY-2,   z=tempPosZ})
    table.insert(positions, {x=tempPosX-2,  y=tempPosY,     z=tempPosZ})
    table.insert(positions, {x=tempPosX,    y=tempPosY+2,   z=tempPosZ})
    table.insert(positions, {x=tempPosX+2,  y=tempPosY,     z=tempPosZ})
        
    for a=1, #positions do
        addEvent(doSendMagicEffect, 100*(a-1), positions[a], magicEffect)
    end
    
    for b=1, #positions-1 do
        if b+1 <= #positions then
            addEvent(doSendDistanceEffect, 100*(b-1), positions[b], positions[b+1], distanceEffect)
        end
    end
end

function broadcast(message, messageType)
    messageType = messageType or RED
    print("BROADCAST: "..message)
    for _, player in pairs(Game.getPlayers()) do player:sendTextMessage(messageType, message) end
end

function clean_cidList(t, keyIsCid)
    local tablesDeleted = 0
    
    if keyIsCid then
        for cid, _ in pairs(t) do
            if not Creature(cid) then
                tablesDeleted = tablesDeleted + 1
                t[cid] = nil
            end
        end
    else
        for i, cid in pairs(t) do
            if not Creature(cid) then
                tablesDeleted = tablesDeleted + 1
                t[i] = nil
            end
        end
    end
    return tablesDeleted
end

function Game.convertIpToString(ip)
    local band = bit.band
    local rshift = bit.rshift
    return string.format(
        "%d.%d.%d.%d",
        band(ip, 0xFF),
        band(rshift(ip, 8), 0xFF),
        band(rshift(ip, 16), 0xFF),
        rshift(ip, 24)
    )
end

function removeItemFromGame(player, itemID)
    local depot = player:getDepot()
    local slotIndex = 0

    player:removeItem(itemID, "all")
    if not depot then return end
    
    local function removeItem(item)
        if compare(item:getId(), itemID) then return item:remove()end
    end

    for x=0, depot:getSize() do
        local item = depot:getItem(x-slotIndex)
        
        if not item then return end

        if item:isContainer(true) then
            local slotIndex = 0

            for x=0, item:getSize() do
                local item2 = item:getItem(x-slotIndex)
                
                if not item2 then break end
                if removeItem(item2) then slotIndex = slotIndex + 1 end
            end
        end

        if removeItem(item) then slotIndex = slotIndex + 1 end
    end
end

-- ADDEVENT MANIPULATIONS
allEvents = {}
function registerAddEvent(creatureID, key, duration, eventData)
    if eventData[10] then
        print("ERROR in registerAddEvent() - max param amount is currently 9")
        Uprint(eventData, "eventData")
    end
    if not allEvents[creatureID] then allEvents[creatureID] = {} end
    local ET = allEvents[creatureID]
    local dT = eventData -- just to shorten addEvent line
    
    ET[key] = {}
    ET[key].eventID = addEvent(dT[1], duration, dT[2], dT[3], dT[4], dT[5], dT[6], dT[7], dT[8], dT[9])
    ET[key].regTime = os.time()
    ET[key].duration = duration -- milliseconds
    ET[key].eventData = eventData
    ET[key].timeLeft = function(eventT) return eventT.duration/1000 - (os.time()-eventT.regTime) end -- seconds
end

function stopAddEvent(ID, key, entireTree) -- entireTree = all the addevents under the same ID
    local ET = allEvents[ID]
    if not ET then return end
    
    if entireTree then
        for _, eventT in pairs(ET) do stopEvent(eventT.eventID) end
        allEvents[ID] = nil
        return
    end
    
    local eventT = ET[key]
    if not eventT then return end
    
    local eventID = eventT.eventID
    local previousDuration = math.floor(eventT.duration/1000)
    local timePassed = os.time() - eventT.regTime
    
    if timePassed < previousDuration then stopEvent(eventID) end
    ET[key] = nil
end

function updateAddEvent(ID, key, extratime)
    local eventT = getAddEvent(ID, key)
    if not eventT then return end
    
    local eventID = eventT.eventID
    local previousDuration = math.floor(eventT.duration/1000)
    local timePassed = os.time() - eventT.regTime
    
    if timePassed < previousDuration then
        local newDuration = (previousDuration - timePassed)*1000 + extratime
        local dataT = eventT.eventData
        stopEvent(eventID)
        eventT.eventID = addEvent(dataT[1], newDuration, dataT[2], dataT[3], dataT[4], dataT[5])
        eventT.regTime = os.time()
        eventT.duration = newDuration
    end
end

function getAddEvent(ID, key)
    if type(ID) == "userdata" then ID = ID:getId() end
    if type(key) == "userdata" then key = key:getId() end
    local ET = allEvents[ID]
    if not ET or not ET[key] then return end
    
    local eventT = ET[key]
    if eventT.duration/1000 - (os.time()-eventT.regTime) < 1 then return end
    return eventT
end

function clean_allEvents(creatureID)
    local tablesDeleted = 0
    if creatureID then allEvents[creatureID] = nil return end
    
    for cid, eventT in pairs(allEvents) do
        for _, t in pairs(eventT) do
            if not t.duration then return 0, Uprint(t, "clean_allEvents is weird") end
            if t.regTime + math.floor(t.duration/1000) + 1 < os.time() then
                tablesDeleted = tablesDeleted + 1
                allEvents[cid] = nil
            end
        end
    end
--    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from allEvents") end
    return tablesDeleted
end

antispamT = {}
function antiSpam(ID, tableKey, msTime)
    local tableKey = tableKey or 0
    if not antispamT[tableKey] then antispamT[tableKey] = {} end
    local spamT = antispamT[tableKey]

    if not spamT[ID] then
        local msTime = msTime or 500
        spamT[ID] = true
        addEvent(setTableVariable, msTime, spamT, ID, nil)
        return true
    end
end

function deSpam(playerID)
    if antispamT[playerID] then antispamT[playerID] = nil end
    
    for k, t in pairs(antispamT) do
        for ID, bool in pairs(t) do
            if ID == playerID then antispamT[k][ID] = nil end
        end
    end
end

function weeklyTaskReset(daysPassed)
    if daysPassed and daysPassed%7 ~= 0 then return end
    local storageT = {}
    
    for monsterName, t in pairs(monsters) do
        local taskT = t.task
        
        if taskT then
            local groupID = taskT.groupID
            
            if groupID then
                if not storageT[groupID] then storageT[groupID] = {} end
                table.insert(storageT[groupID], taskT.storageID)
            else
                print("missing GROUP ID in monsters["..monsterName.."].task")
            end
        end
    end

    for groupID, svT in pairs(storageT) do
        local randomTask = svT[math.random(1, #svT)]
        local players = Game.getPlayers()
        
        print("Weekly task reset: ID = "..randomTask)
        db.query("UPDATE `player_storage` SET `value` = -1 WHERE `value` = -2 AND `key` = "..randomTask)
        for k, player in pairs(players) do
            if getSV(player, randomTask) == -2 then
                removeSV(player, randomTask)
                if not antiSpam(player:getId()) then
                    player:sendTextMessage(BLUE, "Weekly task reset, unlocked new task for you.")
                end
            end
        end
    end
    
    storageT = nil
    return true
end

function questSystem_startQuestEffect(player)
    local areaT = getAreaPos(player:getPosition(), areas["acceptQuest"])
        
    for i, posT in pairs(areaT) do
        for j, pos in pairs(posT) do
            local RNG = math.random(1,2)
            local rngT = {5, 18}
            
            addEvent(doSendMagicEffect, i*200, pos, rngT[RNG])
            if areaT[i+1] and areaT[i+1][j] then 
                addEvent(doSendDistanceEffect, i*200-200, pos, areaT[i+1][j], CONST_ANI_REDSTAR)
            end
            if areaT[i] and areaT[i][j+1] then 
                addEvent(doSendDistanceEffect, i*200-200, pos, areaT[i][j+1], CONST_ANI_REDSTAR)
            end
        end
    end
    return true
end

function questSystem_completeQuestEffect(startPos)
    if type(startPos) == "userdata" then startPos = startPos:getPosition() end
local areaT = getAreaPos(startPos , areas["quest completed"])
    
    for i, posT in pairs(areaT) do
        for j, pos in pairs(posT) do
            local RNG = math.random(1,2)
            local rngT = {5, 18}
            
            addEvent(doSendMagicEffect, i*200, pos, rngT[RNG])
            if j+1 <= #posT and i+1 <= tableCount(areaT) then 
                addEvent(doSendDistanceEffect, i*200-200, pos, areaT[i+1][j+1], CONST_ANI_REDSTAR)
            end
        end
    end
    return true
end

function garbageCollection()
    local garbage = 0
    garbage = garbage + clean_impTarget()
    garbage = garbage + clean_impResistance()
    garbage = garbage + clean_allEvents()
    garbage = garbage + clean_playerPreviousOutfit()
    garbage = garbage + clean_speedBallMinigame()
    garbage = garbage + clean_weaponHitCooldowns()
    garbage = garbage + clean_modalWindow_savedDataByPid()
    garbage = garbage + clean_conditionsStacks()
    garbage = garbage + clean_tempResistances()
    garbage = garbage + clean_targetDebuffT()
    garbage = garbage + clean_tauntedCreatures()
    clean_highestBarrierValue()
    mummyRoom_clean()
    return garbage
end

function serverSave_stage2(cleanMap)
	Game.setGameState(GAME_STATE_CLOSED)
    if cleanMap then cleanMap() end
    Game.setGameState(GAME_STATE_NORMAL)
end

function serverSave_stage1()
    broadcast("Server is saving game in 1 minutes. Find safe spot, it will log you out.")
    Game.setGameState(GAME_STATE_STARTUP)
    addEvent(serverSave_stage2, 60000)
end

function serverSave_start()
    broadcast("Server is saving game in 3 minutes. Find safe spot, it will log you out.")
    activityChart_makeEntry()
	addEvent(serverSave_stage1, 120000)
end