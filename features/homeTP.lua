function homeTP_startUp()
    local choiceID = 0

    for itemAID, chargeT in pairs(homeTP_conf.teleports) do
        choiceID = choiceID + 1
        chargeT.choiceID = choiceID
        chargeT.pillarAID = itemAID
        if chargeT.pillarAID then central_register_actionEvent({[itemAID] = {funcSTR = "homeTP_onUse"}}, "AIDItems") end
    end
end

function homeTP_onUse(player, item)
    local chargeT = homeTP_getChargeT(item)
    if player:getSV(chargeT.SV) == 1 then return player:sendTextMessage(GREEN, "You already have "..chargeT.chargeName.." teleport charge") end

    player:setSV(chargeT.SV, 1)
    player:sendTextMessage(GREEN, chargeT.chargeName.." charge added to your teleport list")
    if player:getSV(SV.extraInfo) == -1 then player:sendTextMessage(BLUE, "You can see teleport charges in your player panel") end
end

function homeTP_getChargeT(object)
    if type(object) == "userdata" and object:isItem() then return homeTP_getChargeT(object:getActionId()) end
    if type(object) == "number" then
        for itemAID, chargeT in pairs(homeTP_conf.teleports) do
            if object == chargeT.pillarAID or object == chargeT.SV or object == chargeT.choiceID then return chargeT end
        end
    end
end

function homeTP_MWChoices(player)
    local choiceT = {}

	for itemAID, chargeT in pairs(homeTP_conf.teleports) do
        if player:getSV(chargeT.SV) == 1 then choiceT[chargeT.choiceID] = chargeT.chargeName.." charge" end
	end
    return choiceT
end

function homeTP_handleMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    homeTP_tryTeleport(player, choiceID)
end

function homeTP_tryTeleport(player, chargeID)
    if getChallengeT(player) then return player:sendTextMessage(GREEN, "Cant teleport while doing challenge") end
    if player:isPzLocked() then return player:sendTextMessage(GREEN, "You need to be out of combat") end
    local chargeT = homeTP_getChargeT(chargeID)
    local TPPos = {x = 580, y = 659, z = 6}

    if Tile(player:getPosition()):getActionId() ~= AID.other.homeTPTile then removeSV(player, chargeT.storageID) end
    npcSystem_playerDeath(player)
    speedball_removePlayer(player)
    deathTeleport(player)
    DG_unregister(player)
    player:teleportTo(TPPos)
    TPRune_effects(player, TPPos)
end

function TPRune_effects(creatureID, pos)
    local area = {
        {2,1,2},
        {1,0,1},
        {2,1,2},
    }
    local positions = getAreaPos(pos, area)
    local creature = Creature(creatureID)
        
    if creature then creature:say("* teleporting home *", ORANGE) end
    doSendMagicEffect(pos, 50)
    
    for i, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            local delay = 250*i
            
            if i == 1 then
                addEvent(doSendMagicEffect, delay, pos, 37)
                addEvent(doSendMagicEffect, delay, pos, 4)
                addEvent(createItem, delay, 1493, pos)
            elseif i == 2 then
                addEvent(doSendMagicEffect, delay, pos, 37)
                addEvent(createItem, delay, 1494, pos)
            end
            addEvent(decay, delay+1000, pos, fireFieldDecayT, true)
        end
    end
end

function hasTeleports(player) return tableCount(homeTP_MWChoices(player)) > 0 end
function playerTeleport_createMW(player) return player and player:createMW(MW.homeTP) end

function central_register_homeTP(allTPs)
    if not allTPs then return end
    if allTPs.chargeName then allTPs = {allTPs} end
    
    for _, t in pairs(allTPs) do
        if t.pillarAID then homeTP_conf.teleports[t.pillarAID] = t end
    end
end