--[[ duellingConf guide
    bannerID = INT or 1819                      itemID for banner
    bannerDistance = INT or 10                  how far players can go from banner before lossTimer starts
    lossTimer = INT or 10                       how many seconds player has time to return into banner radius before they loose
    bannerCountdownMsgT = {
        [INT] = STR                             INT = delay in seconds | STR message given in bannerPosition
    },

    AUTOMATIC
    duels = {
        [INT] = {                               playerID
            targetID = INT,
            attackerID = INT,
            attacker_outOfBoundsTime = INT      how long attacker has been too far from banner
            defender_outOfBoundsTime = INT      how long attacker has been too far from banner
            bannerPos = POS                     position where banner was places down | also means players are in combat
        }
    }
]]

duellingConf = {
    bannerID = 1819,
    bannerDistance = 10,
    lossTimer = 10,
    bannerCountdownMsgT = {[0] = "fight in 3!", [1000] = "fight in 2!", [2000] = "fight in 1!", [3000] = "ATTACK!!!"},
}

feature_duelling = {
    startUpFunc = "duel_startUp",
}
centralSystem_registerTable(feature_duelling)

function duel_startUp()
    if not duellingConf.bannerID then duellingConf.bannerID = 1819 end
    if not duellingConf.bannerDistance then duellingConf.bannerDistance = 10 end
    if not duellingConf.lossTimer then duellingConf.lossTimer = 10 end
    if not duellingConf.bannerCountdownMsgT then duellingConf.bannerCountdownMsgT = {} end
    if not duellingConf.duels then duellingConf.duels = {} end
end

function duel_playerPanel_requestDuel(player, target)
    return not duel_playerPanel_acceptDuel(player, target) and not duel_playerPanel_cancelRequest(player, target)
end

function duel_playerPanel_acceptDuel(player, target)
    local duelT = duel_getDuelT(target)
    return duelT and not duelT.bannerPos and duelT.targetID == player:getId()
end

function duel_playerPanel_cancelRequest(player, target)
    local duelT = duel_getDuelT(player)
    return duelT and not duelT.bannerPos and duelT.targetID == target:getId()
end

function duel_cancelRequest(player, target)
    local duelT = duel_getDuelT(player)
    if not duelT then return end
    if duelT.bannerPos then return end
    
    player:sendTextMessage(BLUE, "You canceled duel request with "..target:getName()..".")
    target:sendTextMessage(BLUE, player:getName().." canceled duel request.")
    duel_deleteDuelT(player)
end

function duel_tryRequest(player, target)
    local duelT = duel_getDuelT(player)
    if not duelT then return duel_request(player, target) end

    local oldTarget = Player(duelT.targetID)
    local oldTargetName = oldTarget:getName()
    if duelT.bannerPos then return player:sendTextMessage(GREEN, "Finish your current duel with "..oldTargetName.." first.") end
    
    local targetDuelT = duel_getDuelT(target)
    if targetDuelT.targetID == player:getId() then return duel_start(player, target) end
    if targetDuelT.bannerPos then return player:sendTextMessage(GREEN, oldTargetName.." is busy duelling, try later.") end

    duel_cancelRequest(player, target)
    duel_request(player, target)
end

function duel_request(player, target)
    local targetID = target:getId()
    local playerID = player:getId()

    duellingConf.duels[playerID] = {
        targetID = targetID,
        attackerID = playerID,
    }
    player:sendTextMessage(BLUE, "You sent duel request to "..target:getName()..".")
    target:sendTextMessage(BLUE, player:getName().." requested a duel!")
end

function duel_start(player, target)
    local bannerPos = player:getPosition()
    local duelT = duel_getDuelT(player)
    
    duelT.attacker_outOfBoundsTime = 0
    duelT.defender_outOfBoundsTime = 0
    duelT.bannerPos = bannerPos
    registerEvent(player, "onThink", "duel_onThink")
    registerEvent(target, "onThink", "duel_onThink")
    createItem(duellingConf.bannerID, bannerPos)
    target:sendTextMessage(BLUE, player:getName().." has accepted your duel request")
    for delay, msg in pairs(duellingConf.bannerCountdownMsgT) do addEvent(text, delay, msg, bannerPos) end
end

function duel_unregister(duelT)
    local function unRegister(playerID)
        local player = Player(playerID)
        if not player then return end
        unregisterEvent(player, "onThink", "duel_onThink")
        player:sendCancelTarget()
    end

    unRegister(duelT.attackerID)
    unRegister(duelT.targetID)
    removeItemFromPos(duellingConf.bannerID, duelT.bannerPos)
    duel_deleteDuelT(duelT.attackerID)
end

function duel_deleteDuelT(playerID)
    local duelT = duel_getDuelT(playerID)
    if not duelT then return end
    duellingConf.duels[duelT.attackerID] = nil
end

function duel_onThink(player)
    local duelT = duel_getDuelT(player)
    if not duelT then return unregisterEvent(player, "onThink", "duel_onThink") end
    local playerIsAttacker = player:getId() == duelT.attackerID

    local function setTimer(newAmount)
        if playerIsAttacker then duelT.attacker_outOfBoundsTime = newAmount else duelT.defender_outOfBoundsTime = newAmount end
    end

    if getDistanceBetween(player:getPosition(), duelT.bannerPos) <= duellingConf.bannerDistance then return setTimer(0) end

    local timer = playerIsAttacker and duelT.attacker_outOfBoundsTime or duelT.defender_outOfBoundsTime
    if timer == duellingConf.lossTimer then return duel_winner(duelT.targetID) end

    local timeLeft = duellingConf.lossTimer - timer
    setTimer(timer + 1)
    player:sendTextMessage(GREEN, "You have "..plural("second", timeLeft).." left to go back into banner radius")
end

function duel_winner(playerID)
    local duelT = duel_getDuelT(playerID)
    if not duelT then return print("ERROR in duel_winner - wtf how?") end
    
    local msg = Player(playerID):getName().." won the duel"
    doSendTextMessage(duelT.attackerID, ORANGE, msg)
    doSendTextMessage(duelT.attackerID, GREEN, msg)
    doSendTextMessage(duelT.targetID, ORANGE, msg)
    doSendTextMessage(duelT.targetID, GREEN, msg)
    duel_unregister(duelT)
end

function duel_onDeath(player)
    local duelT = duel_getDuelT(player)
    if not duelT then return end
    local playerID = player:getId()
    local winnerID = playerID == duelT.attackerID and duelT.targetID or duelT.attackerID

    local function setHealthTo1(playerID)
        local player = Player(playerID)
        if not player then return end
        local playerHP = player:getHealth()
        player:addHealth(-(playerHP-1))
    end
    duel_winner(winnerID)
    player:addHealth(1000)
    addEvent(setHealthTo1, 200, playerID)
    return true
end

-- get functions
function duel_getDuelT(object)
    if type(object) == "table" then return object and Player(object.targetID) and object end
    if type(object) == "userdata" then return duel_getDuelT(object:getId()) end
    
    if type(object) == "number" then
        for attackerID, duelT in pairs(duellingConf.duels) do
            if object == attackerID then return duel_getDuelT(duelT) end
            if duelT.targetID and object == duelT.targetID then return duel_getDuelT(duelT) end
        end
    end
end

function duel_isInDuel(player)
    local duelT = duel_getDuelT(player)
    if not duelT then return end
    return duelT.bannerPos
end