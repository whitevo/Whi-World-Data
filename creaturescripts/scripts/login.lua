lastUpdateID = 59    -- make sure lastUpdateID is same number as the one which is latest.
onLoginFunctions = {}

function patchUpdate(player)
    executeHistory(player)
    
    if onceOnLogin(player, 59) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.3.3")
        player:sendTextMessage(ORANGE, "small bug fixes and improved God Powers")
        player:sendTextMessage(ORANGE, "precision robe itemID has been changed. In some reason it randomly caused crashes onEquip")
        removeItemFromGame(player, 12429)
    end
end

--print("twaccy spellSystem is registered in onLogin")
print("twaccy rebirth is registered in onLogin")
function onLogin(player)
   -- player:registerEvent("spellSystem_healtChange") -- its twaccky registration - I disbaled the event too
    rebirth_onLogin(player) -- its twaccky rebirth

	if player:getLastLoginSaved() <= 0 then
        setSV(player, SV.onceOnLogin, lastUpdateID)
        skillTree_firstTimeOnLogin(player)
        player:sendTextMessage(GREEN, "Use arrow keys to move to blue tile.")
        player:sendTextMessage(BLUE, "Use arrow keys to move to blue tile.")
    end

    if player:getLevel() == 1 then player:addExpPercent(100) end
    player:sendTextMessage(BLUE, "You can join Battle Royale event with command !royale.")
    player:sendTextMessage(BLUE, "NB! Battle Royale event starts will cause few second lag spikes")
    patchUpdate(player)
    unBug(player)
    activityChart(player)
    setSV(player, SV.lastLogInTime, os.time())
    house_checkRent(player)
    recalulateCap(player)
    
    if getSV(player, SV.hardcoreLives) < 1 and getPlayerDeathTimeByGUID(player:getGuid()) < os.time()-2*60*60 then setSV(player, SV.hardcoreLives, 1) end  -- Hardcore lives
    
    if getSV(player, SV.playerIsDead) == 1 then
        teleport(player, player:homePos())
        removeSV(player, SV.playerIsDead)
    end
    
    bossRoom_removeBossProtection(player)
    teleportOutOnlogin(player)
    removeBuffs(player)
    mirror_removeOutfits(player)
    
    if getSV(player, SV.brirella) == 0 then setSV(player, SV.brirella, -2) end -- tonka "herb mission"
    
    addSkills(player)
    resetStats(player)
    someoneCameOnline(player)
    
    player:registerEvent("modalWindows")
    player:registerEvent("deathSystem")
    player:registerEvent("levelUp")
    player:registerEvent("damageSystem")
    
    centralSystem_onLogin(player)
    if testServer() then player:setSV(SV.isGod, 1) end
    return player:sendTextMessage(BLUE, "You can join Whi World Discord channel with this code: 7yBpnmU")
end

function centralSystem_onLogin(player)
    for _, t in ipairs(onLoginFunctions) do executeActionSystem(player, nil, t, player:getPosition()) end
end

function teleportOutOnlogin(player)
    local playerPos = player:getPosition()

    if getSV(player, SV.checkPoint) == 3 then return teleport(player, player:homePos()) end
    if tutorial_kickFromRoom(player) then return true end
    if bossRoomTP(player, true) then return true end
    if skeletonWarriorRoom_TPOut(player) then return true end
    if mummyRoom_tpOut(player) then return true end
    if building_tutorial_leaveArea(player) then return true end
    if house_kickOnLogin(player) then return true end
    if isInRange(playerPos, {x = 664, y = 592, z = 8}, {x = 686, y = 596, z = 8}) then return teleport(player, {x = 666, y = 601, z = 8}) end -- minigame room
    if isInRange(playerPos, {x = 823, y = 523, z = 8}, {x = 869, y = 556, z = 8}) then return teleport(player, {x = 639, y = 575, z = 7}) end -- cyclops sabotage fight room
    if rootedCatacombs_onLogOut(player) then return true end
end

function unBug(player)
    if getSV(player, SV.liamMission) == 0 then removeSV(player, {SV.liamMission, SV.liamTracker}) end
    removeSV(player, SV.isGod)
    removeSV(player, SV.ghostTP)
    removeSV(player, SV.player_ignoreDamage)
    removeSV(player, SV.KILLEDBOSSTEMP)     -- substitude for the real thing KILL IT LATER!! right now I jsut know its not possible..
    removeSV(player, SV.autoLoot_gold)
    removeSV(player, SV.barrierDebuffPercent)
    removeSV(player, SV.onLookTP)
    
    if player:isFakeDead() then
        player:removeSV(SV.fakedeathOutfit)
        player:setOutfit(defaultOutfit)
    end
end

function resetStats(player)
    local statSVs = {SV.extraEnergyDamage, SV.extraFireDamage, SV.extraEarthDamage, SV.extraDeathDamage, SV.extraIceDamage, SV.tempPhysicalResistance, SV.tempFireResistance, SV.tempIceResistance, SV.tempEnergyResistance, SV.tempDeathResistance, SV.tempEarthResistance, SV.foodArmor}

    for i, sv in pairs(statSVs) do setSV(player, sv, 0) end
end

function onceOnLogin(player, updateID, testing)
    local updateSV = SV.onceOnLogin
    local playerUpdateID = getSV(player, updateSV)

    if playerUpdateID < updateID or testing then
        if testing then
            player:sendTextMessage(ORANGE, "This is test server update, your character will be updated again when you relog")
        else
            setSV(player, updateSV, updateID)
        end
        return player:sendTextMessage(ORANGE, "--- --- --- --- --- --- --- --- --- ---")
    end
end

function someoneCameOnline(player)
    for _, p in pairs(Game.getPlayers()) do p:sendTextMessage(ORANGE, player:getName().." came online.") end    
end

function activityChart(player)
    local time = os.time()
    local activityChartTimes = getAccountSVT(player, SV.activityChart)

    for _, playerTime in pairs(activityChartTimes) do
        if playerTime >= time then return end
    end
    
    local currentTime = os.date("%X")
    local hoursElapsed = currentTime:getINT() + 1
    
    if hoursElapsed >= 24 then hoursElapsed = 0 end

    local timeLeftTillEndOfDay = (24 - hoursElapsed) * 60 * 60

    activityChart_makeEntry(true)
    setSV(player, SV.activityChart, time + timeLeftTillEndOfDay)
end

function activityChart_makeEntry(add)
    local date = os.date("%x")
    local queryData = db.storeQuery("SELECT `players_online` FROM `activity_chart` WHERE `date` = '"..date.."'")
    local uniqueOnlineCount = DBNumberResultReader(queryData, "players_online") or 0
    local firstEntry = 0
    
    if queryData then return add and db.query("UPDATE `activity_chart` SET `players_online` = "..(uniqueOnlineCount + 1).." WHERE `date` = '"..date.."'") end
    if add then firstEntry = 1 end
    print("created new entry: uniqueOnlineCount = "..uniqueOnlineCount..", add = "..tostring(add)..", date = "..date)
    db.query("INSERT INTO `activity_chart`(`players_online`, `date`) VALUES ("..firstEntry..", '"..date.."')")
end