-- mySQL query examples are in the bottom of page
--[[ bossRoomConf guide
    [{roomAID, kickAID, leaveAID, signAID, highscoreAID}] = {
        upCorner = POS
        downCorner = POS
        kickTimeSec = INT or 30     how long players need to wait before they can actaully kick players
        
        roomAID = INT               actionID which enters players to boss room | also used to get roomT directly | DEFAULT func = bossRoom_enter
        kickAID = INT               actionID which tries to kick players from stopping the path | DEFAULT func = bossRoom_kick
        leaveAID = INT              actionID which kicks yourself out of boss room | DEFAULT func = bossRoom_leave
        signAID = INT               actionID which purchases the boss protection | DEFAULT func = bossRoom_sign
        highscoreAID = INT          actionID which shows correct highscore window | DEFAULT func = bossRoom_checkHighscores
        enterPos = {POS}            positions where player will enter
        quePos = {POS}              positions where players need to stand to enter
        kickPos = POS               position where players are kicked
        bossPos = POS               position where boss is created (can have multible positions corresponds with bossName table)
        bossName = STR              
        clearObjects = {INT}        Items what will be deleted along with roomClear()
        respawnCost = INT           How much it costs to respawn in waiting room upon death
        bountyStr = STR             global variable for bounty amount
        respawnSV = INT             storage value where the respawn effect is stored.
        killSV = INT                storage value to keep track if player has killed the boss or not
        rewardExp = INT             expPercentAmount for killing boss first time
        rewardSkillPoint = INT      gives skillpoints for killing boss first time
        funcForAID = {
            [INT] = STR             INT = actionID of object when its used. || STR = function what will be executed instead default object script.
        }
        --AUTOMATIC
        kickStartTime = os.time()
        kickEvent = INT
    }
]]


bossRoomConf = bossRoomConf or {
    highscoreFormula = "(1000 - attempts*7 + kills*11)",
    bossRooms = {},
}

function central_register_bossRoom(bossT)
    if not bossT then return end
    bossRoomConf.bossRooms[{bossT.roomAID, bossT.kickAID, bossT.leaveAID, bossT.highscoreAID, bossT.signAID}] = bossT

    local function register_onUse(itemAID, defaultFuncStr, onLookStr)
        if not itemAID then return end
        if bossT.funcForAID then defaultFuncStr = bossT.funcForAID[itemAID] or defaultFuncStr end
        central_register_actionEvent({[itemAID] = {funcSTR = defaultFuncStr}}, "AIDItems")
        if type(onLookStr) ~= "table" then onLookStr = {msg = {onLookStr}} end
        AIDItems_onLook[itemAID] = {text = onLookStr}
    end

    local sign_onLookStr = {
        type = BLUE,
        msg = {
            "By Using this sign you pay "..(bossT.respawnCost or 0).." coins for Boss Protection.",
            "This effect wares off if ".. tableToStr(bossT.bossName, " or ").." kills you",
            "Effect also weares off if you leave the the Boss fighting room in any way."}}
            
    register_onUse(bossT.roomAID, "bossRoom_enter", "Use this lever to enter Boss Room")
    register_onUse(bossT.leaveAID, "bossRoom_leave", "Use this to teleport out of boss room")
    register_onUse(bossT.kickAID, "bossRoom_kick", "Use this lever to kick the afkers from the enter positions in 30 seconds")
    register_onUse(bossT.signAID, "bossRoom_sign", sign_onLookStr)
    register_onUse(bossT.highscoreAID, "bossRoom_checkHighscores", "Use the board to see "..tableToStr(bossT.bossName, " and ").." highscores")
end

function bossRoom_onDeath(monster)
    local playerT = getPlayerTFromDamageT(monster:getDamageMap())
    local playerNames = {}
    for i, player in ipairs(playerT) do playerNames[i] = player:getName() end

    local playerTStr = tableToStr(playerNames)
    local msg = playerTStr.." recently killed "..monster:getName()
    npcChat_insertConvo("town", msg)
end

function bossRoom_enter(player, item)
    local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
    local bossRoom = createAreaOfSquares({{upCorner = bossT.upCorner, downCorner = bossT.downCorner}})

    stopEvent(bossT.kickEvent)
    stopAddEvent("bossRoom "..bossT.roomAID, nil, true)
    bossT.kickStartTime = false
    
    for _, pos in pairs(bossRoom) do
        if findCreature("player", pos) then return false, player:sendTextMessage(GREEN, "Boss room is not empty") end
    end
    
    bossRoom_clear(bossT)
    for i, pos in pairs(bossT.quePos) do teleport(findCreature("player", pos), bossT.enterPos[i]) end
    bossRoom_makeBoss(bossT)
    changeLever(item)
    return true
end

function bossRoom_kick(player, item)
    local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
    local kickTimeSec = bossT.kickTimeSec or 30

    if bossT.kickStartTime then return player:sendTextMessage(GREEN, "Kicking has already been initiated, wait "..getTimeText(kickTimeSec - (os.time() - bossT.kickStartTime))) end
    local bossRoom = createAreaOfSquares({{upCorner = bossT.upCorner, downCorner = bossT.downCorner}})
    local eventID = "bossRoom "..bossT.roomAID
    local kickPos = bossT.kickPos

    for _, pos in pairs(bossRoom) do
        if findCreature("player", pos) then return false, player:sendTextMessage(GREEN, "Can't kick players while other team is still doing the boss") end
    end
    
    bossT.kickStartTime = os.time()
    bossT.kickEvent = addEvent(function() bossT.kickStartTime = false end, kickTimeSec*1000)
    player:sendTextMessage(GREEN, "In 30 seconds people in que will be kicked")
    changeLever(item)
    stopAddEvent(eventID, nil, true)
    
    for i, pos in pairs(bossT.quePos) do
        registerAddEvent(eventID, i, kickTimeSec*1000, {massTeleport, pos, kickPos, "player"})
    end
    return true
end

function bossRoom_leave(player, item)
    local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
    removeSV(player, bossT.respawnSV)
    return teleport(player, bossT.kickPos)
end

function bossRoom_makeBoss(bossT)
    local bossPos = bossT.bossPos
    if not bossPos then return end
    local bossName = bossT.bossName

    if type(bossName) ~= "table" then
        bossName = {bossName}
        bossPos = {bossPos}
    end
    for i, pos in pairs(bossPos) do createMonster(bossName[i], pos) end
end

function bossRoom_clear(bossT)
    if not bossT then return end
    local upCorner = bossT.upCorner
    if not upCorner then return end
    local downCorner = bossT.downCorner
    local itemTable = bossT.clearObjects
    local room = createSquare(upCorner, downCorner)

    if itemTable ~= "table" then itemTable = {itemTable} end
    
    for i, pos in pairs(room) do
        for _, itemID in pairs(itemTable) do massRemove(pos, itemID) end
        massRemove(pos, "monster")
    end
end

function bossRoom_sign(player, item)
    local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
    local itemPos = item:getPosition()

    if getSV(player, bossT.respawnSV) == 1 then
        doSendMagicEffect(itemPos, 30)
        return player:sendTextMessage(GREEN, "You already have protection for this boss fight.")
    end
    if not player:removeMoney(bossT.respawnCost) then
        doSendMagicEffect(itemPos, 31)
        return player:sendTextMessage(GREEN, "You don't have enough gold to get this effect")
    end
    doSendMagicEffect(itemPos, 29)
    setSV(player, bossT.respawnSV, 1)
    bossRoom_addBounty(bossT.bountyStr, percentage(bossT.respawnCost, 25))
    return player:sendTextMessage(GREEN, "You will now respawn in this waiting room and don't loose HC life if you fail the boss fight.")
end

function bossRoom_addBounty(globalStr, amount)
    local bountyBefore = _G[globalStr] or 0
    _G[globalStr] = bountyBefore + amount
end

function bossRoom_checkHighscores(player, item)
    local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
    doSendMagicEffect(item:getPosition(), 29)
    modalWindow_savedDataByPid[player:getId()] = bossT
    return player:createMW(MW.bossHighscores, bossT)
end

function bossRoomMW_createName(player, bossT)
    local bossName = bossT.bossName
    if type(bossName) == "table" then bossName = bossName[1] end
    return bossName.." highscores"    
end

function bossRoomMW_showHighscores(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    local bossT = modalWindow_savedDataByPid[player:getId()]
    local bossName = bossT.bossName

    if type(bossName) == "table" then bossName = bossName[1] end
    player:createMW(mwID, bossT)
    if choiceID == 1 then return bossRoomMW_overallHS(player, bossName) end
    if choiceID == 2 then return bossRoomMW_vocationHS(player, bossName, "druid") end
    if choiceID == 3 then return bossRoomMW_vocationHS(player, bossName, "knight") end
    if choiceID == 4 then return bossRoomMW_vocationHS(player, bossName, "mage") end
    if choiceID == 5 then return bossRoomMW_vocationHS(player, bossName, "hunter") end
end

local function skipRankTable(player, monsterName)
    if monsterName == "dummy" then return player:sendTextMessage(ORANGE, "There is no need to show rankings, its tutorial afterall.") end
end

local function sendMsg(player, rank, dataT, playerName)
    local vocation = dataT[2]
    local attempts = dataT[3]
    local kills = dataT[4]
    local deaths = dataT[5]
    playerName = playerName or player:getName()
    
    return player:sendTextMessage(ORANGE, "["..rank.."] "..playerName.."("..vocation.."): Attempts = "..attempts.."  |  Kills = "..kills.."  |  Deaths = "..deaths)
end

local function finalMessage(player, rankTable, playerRank, breakLoop, playerInList)
	if not breakLoop then return end
	if playerInList then return true end
	if playerRank < 1 then return true end
    local playerGUID = player:getGuid()
        
    for _, highscorePlayerT in pairs(rankTable[playerRank]) do
		for _ , highscoreStatT in pairs(highscorePlayerT) do
            if type(highscoreStatT) == "number" then
                Vprint(playerRank, "playerRank")
                Uprint(rankTable, "ERROR in finalMessage")
            else
                if highscoreStatT[1] == playerGUID then
                    return sendMsg(player, playerRank, highscoreStatT)
                end
            end
		end
    end
    return true
end

local function highscoreMessage(player, t, rank)
    local playerGUID = player:getGuid()
    local playerFound = false
    local DBGuid = t[1]

    if DBGuid == playerGUID then playerFound = true end
    sendMsg(player, rank, t, getPlayerNameByGUID(DBGuid))
    return playerFound
end

function bossRoomMW_overallHS(player, bossName)
    local playerGUID = player:getGuid()
    local attempts, kills, deaths = getMonsterHighscore(bossName)
    local rankTable, playerRank = getPlayerHighscore(playerGUID, bossName)
    local times = 9 -- how many ranks shows before shows player rank
    local breakLoop = false
    local playerInList = false
    
    player:sendTextMessage(ORANGE, "--------------------------------")
    player:sendTextMessage(BLUE, bossName.." highscores - overall")
    player:sendTextMessage(BLUE, "Out of "..attempts.." attempts, "..bossName.." has been killed "..kills.." times!")
    if not rankTable then return end
    if skipRankTable(player, bossName) then return end
    
    for rank, rankT in ipairs(rankTable) do
        for _, statT in ipairs(rankT) do
            times = times-1
            if times < 0 then breakLoop = true end
            if highscoreMessage(player, statT, rank) then playerInList = true end
            if finalMessage(player, rankTable, playerRank, breakLoop, playerInList) then return end
        end
    end
end

function bossRoomMW_vocationHS(player, monsterName, vocation)
    local playerGUID = player:getGuid()
    local attempts, kills, deaths = getVocationMonsterHighscore(monsterName, vocation)
    local rankTable, playerRank = getPlayerVocationHighscore(playerGUID, monsterName, vocation)
    local times = 9 -- how many ranks shows before shows player rank
    local breakLoop = false
    local playerInList = false

    player:sendTextMessage(ORANGE, "--------------------------------")
    player:sendTextMessage(BLUE, monsterName.." highscores - "..vocation.."s only")
    player:sendTextMessage(BLUE, "Out of "..attempts.." attempts, "..monsterName.." has been killed "..kills.." times by "..vocation.."s!")
    if not rankTable then return end
    if skipRankTable(player, monsterName) then return end
    
    for rank, rankT in ipairs(rankTable) do
        for i, statT in ipairs(rankT) do
            times = times-1
            if times < 0 then breakLoop = true end
            if highscoreMessage(player, statT, rank) then playerInList = true end
            if finalMessage(player, rankTable, playerRank, breakLoop, playerInList) then return end
        end
    end
end

function bossRoom_clearHighscores()
    db.query([[DELETE FROM `highscores` WHERE `vocation` = "none"]])
    db.query([[DELETE FROM `highscores` WHERE NOT EXISTS (SELECT 1 FROM `players` WHERE highscores.guid = players.id)]])
end

function bossRoom_death(player, monsterName)
    monsterName = monsterName:lower()
    if monsterName == "big daddy defencemode" then monsterName = "big daddy" end
    if not monsters[monsterName] or not monsters[monsterName].bossRoomAID then return end
    local playerGUID = player:getGuid()
    local vocation = player:getVocation():getName()
    bossRoom_updateHS(player, monsterName)
    local temp = db.storeQuery("SELECT `attempts`, `deaths` FROM `highscores` WHERE `guid` = "..playerGUID.." AND `vocation` = '"..vocation.."' AND `monster` = '"..monsterName.."'")
    local attempts = result.getNumber(temp, "attempts")
    local deaths = result.getNumber(temp, "deaths")

    db.query("UPDATE `highscores` SET `attempts` = "..(attempts+1).. ", `deaths` = "..(deaths+1).." WHERE `guid` = "..playerGUID.." AND `vocation` = '"..vocation.."' AND `monster` = '"..monsterName.."'")
end

function bossRoom_updateHS(player, monsterName)
    local playerGUID = player:getGuid()
    local vocation = player:getVocation():getName()
    local results = db.storeQuery("SELECT * FROM `highscores` WHERE `guid` = "..playerGUID.." AND `vocation` = '"..vocation.."' AND `monster` = '"..monsterName.."'")

    if results then return end
    db.query("INSERT INTO highscores(`guid`, `vocation`, `monster`) VALUES ("..playerGUID..", '"..vocation.."', '"..monsterName.."')")
end

function bossRoom_kill(creature, monsterT)
    if not monsterT.bossRoomAID then return end
    local bossT = getBossRoom(monsterT.bossRoomAID)
    if not bossT then return end
    local monsterName = monsterT.name:lower()
    local attackers = creature:getDamageMap()
    
    for pid, t in pairs(attackers) do
        local player = Player(pid)
        
        if player then
            bossRoom_updateKills(player, monsterName)
            
            if bossT.killSV then 
                if getSV(player, bossT.killSV) ~= 1 then
                    setSV(player, bossT.killSV, 1)
                    if bossT.rewardExp then player:addExpPercent(bossT.rewardExp) end
                    if bossT.rewardSkillPoint then player:addSV(SV.skillpoints, bossT.rewardSkillPoint) end
                else
                    player:sendTextMessage(GREEN, "You already got experience from this boss")
                end
            end
            addEvent(playerSave, 3*60*1000, pid)
        end
    end
    bossRoom_clear(bossT)
end

function bossRoom_updateKills(player, monsterName)
    local playerGUID = player:getGuid()
    local vocation = player:getVocation():getName()
    bossRoom_updateHS(player, monsterName)
    local temp = db.storeQuery("SELECT attempts, kills FROM highscores WHERE guid = "..playerGUID.." AND vocation = '"..vocation.."' AND monster = '"..monsterName.."'")
    local attempts = result.getNumber(temp, "attempts")
    local kills = result.getNumber(temp, "kills")
    db.query("UPDATE highscores SET attempts = "..(attempts+1).. ", kills = "..kills+(1).." WHERE guid = "..playerGUID.." AND vocation = '"..vocation.."' AND monster = '"..monsterName.."'")
end

function bossRoom_takeHCLife(player, monsterT)
    local function checkSV(bossT)
        if getSV(player, bossT.respawnSV) ~= 1 then return true end
        setSV(player, bossT.respawnSV, 0)
    end
    
    if monsterT then
        local bossT = getBossRoom(monsterT.bossRoomAID)
        if bossT and bossT.respawnSV then
            return checkSV(bossT)
        end
    else
        local playerPos = player:getPosition()
        
        for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
            if bossT.upCorner and isInRange(playerPos, bossT.upCorner, bossT.downCorner) then
                return checkSV(bossT)
            end
        end
    end
    
    bossRoom_removeBossProtection(player)
    return true
end

function bossRoom_removeBossProtection(player)
    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.respawnSV then removeSV(player, bossT.respawnSV) end
    end
end

function bossRoomTP(player, login)
local playerPos = player:getPosition()

    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.upCorner and isInRange(playerPos, bossT.upCorner, bossT.downCorner) then
            if not login then return end
            return player:teleportTo(bossT.kickPos)
        end
    end
end

-- get functions
function Monster.isBoss(monster)
    local monsterT = getMonsterT(monster)
    if not monsterT then return end
    return monsterT.boss or monsterT.bossRoomAID
end

function getBossRoom(aid)
    if not aid then return end
    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if isInArray(AIDT, aid) then return bossT end
    end
    print("missing bossroom with aid: "..tostring(aid))
end

function getBossNameByLocation(player)
    local playerPos = player:getPosition()

    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.upCorner and isInRange(playerPos, bossT.upCorner, bossT.downCorner) then
            local bossName = bossT.bossName
            if bossName == "table" then bossName = bossName[1] end
            return bossName
        end
    end
end

local function returnMonsterHighscore(highscoreData)
    local attempts, kills, deaths = 0, 0, 0

    if highscoreData then
        attempts = result.getNumber(highscoreData, "attempts")
        kills = result.getNumber(highscoreData, "kills")
        deaths = result.getNumber(highscoreData, "deaths")
        result.free(highscoreData)
    end
    return attempts, kills, deaths
end

local function createHighscoreRankTable(highscoreData, playerGUID) -- rank = {guid, vocation, attempts, kills, deaths, hsPoints}
    if not highscoreData then return end
    local t = {}
    local playerKey = 0
    local key = 1

    repeat
        local attempts = result.getNumber(highscoreData, "attempts")
        local kills = result.getNumber(highscoreData, "kills")
        local deaths = result.getNumber(highscoreData, "deaths")
        local guid = result.getNumber(highscoreData, "guid")
        local vocation = result.getString(highscoreData, "vocation")
        local hsPoints = result.getNumber(highscoreData, "hsPoints")
        
        if not getPlayerNameByGUID(guid):match("no_name") then
            if t[key] then
                if t[key][1][6] == hsPoints then
                    t[key][#t[key]+1] = {guid, vocation, attempts, kills, deaths, hsPoints}
                else 
                    key = key+1
                    t[key] = {{guid, vocation, attempts, kills, deaths, hsPoints}}
                end
            else
                t[key] = {{guid, vocation, attempts, kills, deaths, hsPoints}}
            end
            if playerGUID and playerGUID == guid then playerKey = key end
        end
    until not result.next(highscoreData)

    result.free(highscoreData)
    return t, playerKey
end

function getMonsterHighscore(monsterName)
    local highscoreData = db.storeQuery("SELECT SUM(attempts) AS attempts, SUM(kills) AS kills, SUM(deaths) AS deaths FROM highscores WHERE monster = '"..monsterName.."'")
    return returnMonsterHighscore(highscoreData)
end

function getPlayerHighscore(playerGUID, monsterName)
    local highscoreData = db.storeQuery("SELECT SUM(attempts) AS attempts, SUM(kills) AS kills, SUM(deaths) AS deaths, vocation, guid, "..bossRoomConf.highscoreFormula.." as hsPoints FROM highscores WHERE attempts > 0 and monster = '"..monsterName.."' GROUP BY guid ORDER BY hsPoints DESC")
    return createHighscoreRankTable(highscoreData, playerGUID)
end

function getVocationMonsterHighscore(monsterName, vocation)
    local highscoreData = db.storeQuery("SELECT SUM(attempts) AS attempts, SUM(kills) AS kills, SUM(deaths) AS deaths FROM highscores WHERE monster = '"..monsterName.."' and vocation = '"..vocation.."'")
    return returnMonsterHighscore(highscoreData)
end

function getPlayerVocationHighscore(playerGUID, monsterName, vocation)
    local highscoreData = db.storeQuery("SELECT SUM(attempts) AS attempts, SUM(kills) AS kills, SUM(deaths) AS deaths, vocation, guid, "..bossRoomConf.highscoreFormula.." as hsPoints FROM highscores WHERE attempts > 0 and monster = '"..monsterName.."' and vocation = '"..vocation.."' GROUP BY guid ORDER BY hsPoints DESC")
    return createHighscoreRankTable(highscoreData, playerGUID)
end

--[[ Some queryies for checking buggerinos or whatever
first lets see what is fucked up badly
    SELECT `kills`, `deaths`, `attempts`, `monster` FROM `highscores` WHERE `attempts`+3 < `deaths`+`kills`

then lets reset these fuckups to previous state manually
    UPDATE `highscores` SET `kills`= 0,`deaths`= 0,`attempts`= 0 WHERE `attempts`+3 < `deaths`+`kills`
    
then lets see what are the small fuckups 
    SELECT `kills`, `deaths`, `attempts`, `monster` FROM `highscores` WHERE `attempts` < `deaths`+`kills`
    
Lets just roll with it and increase the attempts to required amount?
    UPDATE `highscores` SET `attempts`= `deaths`+`kills` WHERE `attempts` < `deaths`+`kills`

EXPORT excel file for backup | CSV for MS Excel 
    tick: Put columns names in the first row
    untick: Save on server in the directory W:\UniServerZ\etc\phpmyadmin/
    
    
Other queries what are executed by scripts:
    SELECT SUM(attempts) AS attempts, SUM(kills) AS kills, SUM(deaths) AS deaths, vocation, guid, (1000 - attempts*9 + kills*12) as hsPoints FROM highscores WHERE attempts > 0 and monster = 'big daddy' GROUP BY id ORDER BY hsPoints DESC
]]
