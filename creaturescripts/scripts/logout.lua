-- NB! dont forget hardcore teleport
onLogoutFunctions = {}

function onLogout(player)
    if not centralSystem_onLogout(player) then return end
    local playerID = player:getId()

    bomberman_unregister(player)
    teleportOutOnlogin(player)
    tutorial_logOut(player)
    speedball_removePlayer(player)
    removeFakeDeath(player)
    npcSystem_playerDeath(player)
    challengeEvent_endChallenge(player)
    
    if playerPreviousOutfit[playerID] then
        player:setOutfit(playerPreviousOutfit[playerID])
        playerPreviousOutfit[playerID] = nil
    end
    weaponHitCooldowns[playerID] = nil
    conditionsStacks[playerID] = nil
    temporarResByCid[playerID] = nil
    deSpam(playerID)
    clean_targetDebuffT(playerID)
    clean_scalingSystem(playerID)
    clean_allEvents(playerID)
    mummyRoom_clean(playerID)
    clean_highestBarrierValue(playerID)
    house_unregisterOffer(playerID)
    updateOnlineTime(player)
    someoneWentOffline(player)
    return true
end

function centralSystem_onLogout(player)
    for _, t in ipairs(onLogoutFunctions) do
       if not executeActionSystem(player, nil, t, player:getPosition()) then return end
    end
    return true
end

function someoneWentOffline(player)
    for _, p in pairs(Game.getPlayers()) do p:sendTextMessage(ORANGE, player:getName().." went offline.") end    
end