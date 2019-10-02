function onPrepareDeath(player, killer) -- getting 1 shotted will bug this. :|  to fix this, source edit needed.
    if not player then return end
    if royale_isInGame(player) then
        royale_onDeath(player)
        return -- in somes reason server crashes when i return nil with function
    end
    if duel_onDeath(player) then return end
    deathRegistration(player, killer)
    removeBuffsAndDebuffs(player)
    deadState(player, killer)
    deathPenalty(player, killer)
    tutorial_death(player)
    return true
end

function removeBuffsAndDebuffs(player)
    local playerPos = player:getPosition()
    
    while removeStun(playerPos) do end
    while removeBind(playerPos) do end
    while removeRoot(playerPos) do end
    removeDOT(player)
    resetStats(player)
    removeBuffs(player)
    removeAllConditions(player)
end

function deadState(player, killer)
    local playerPos = player:getPosition()
    local killerName = getKillerName(player, killer)
    local pid = player:getId()
    local monsterT = monsters[killerName]
    local healAmount = 10000
    
    if monsterT then
        local bossT = getBossRoom(monsterT.bossRoomAID)
        if bossT and bossT.respawnSV and getSV(player, bossT.respawnSV) == 1 then healAmount = 200 end
    else
        for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
            if bossT.upCorner and isInRange(playerPos, bossT.upCorner, bossT.downCorner) and getSV(player, bossT.respawnSV) == 1 then healAmount = 200 break end
        end
    end
    
    if playerPreviousOutfit[pid] then player:setOutfit(playerPreviousOutfit[pid]) end
    npcSystem_playerDeath(player) -- needs to be done first before party is disabled
    if player:getParty() then player:getParty():removeMember(player) end
    player:setTarget()
    player:addHealth(healAmount)
    addEvent(heal, 1000, pid, healAmount)
    player:addMana(healAmount)
    setSV(player, SV.playerIsDead, 1)
    addEvent(removeSV, 1000, pid, SV.playerIsDead)
    player:sendTextMessage(BLUE, "You died.")
end

function deathRegistration(player, killer)
    local byPlayer = getKilledByPlayer(killer)
    local killerName = getKillerName(player, killer)
    local damageT = player:getDamageMap()
    local byPlayerMostDamage = getHighestDamageDealerFromDamageT(damageT) and 1 or 0
    local playerGUID = player:getGuid()
    local mostDamageKillerName = getMostDamageKillerName(player)
        
    tutorialNerf(player, killer, killerName)
    bossRoom_death(player, killerName)
	db.query("INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (" .. playerGUID .. ", " .. os.time() .. ", " .. player:getLevel() .. ", " .. db.escapeString(killerName) .. ", " .. byPlayer .. ", " .. db.escapeString(mostDamageKillerName) .. ", " .. byPlayerMostDamage .. ", " .. 0 .. ", " .. 0 .. ")")

    local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGUID)
    local deathRecords = 0
    local tmpResultId = resultId

	while tmpResultId ~= false do
		tmpResultId = result.next(resultId)
		deathRecords = deathRecords + 1
	end

	if resultId ~= false then result.free(resultId)	end

    local limit = deathRecords - death_conf.maxDeathRegisters
	if limit > 0 then db.asyncQuery("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGUID .. " ORDER BY `time` LIMIT " .. limit)	end
end

function tutorialNerf(player, killer, killerName)
    if killer and killerName == "dummy" then
        if killer:getHealth() < killer:getMaxHealth()/2 then addSV(player, SV.dummyNerf, 1) end
    end
end
    
function getKillerName(player, killer)
    local bossName = getBossNameByLocation(player)
    if bossName then return bossName end
    if not killer then return "field item" end

    local master = killer:getMaster()
    if master and master ~= killer then return master:getRealName() end
    return killer:getRealName()
end

function getKilledByPlayer(killer)
    if not killer then return 0 end
    if killer:isPlayer() then return 1 end
    
    local master = killer:getMaster()
    if master and master:isPlayer() then return 1 end
    return 0
end

function getCreatureFromDamageMap(creature)
    local mostDamage = 0
    local killer

    for cid, t in pairs(creature:getDamageMap()) do
        local killerCreature = Creature(cid)

        if killerCreature then            
            if t.total > mostDamage then
                mostDamage = t.total
                killer = killerCreature
            end
        end
    end
    return killer
end

function getMostDamageKillerName(player)
    local creature = getCreatureFromDamageMap(player)
    if not creature then return "field item" end
    return creature:getName()
end

function deathProtection(player) return getSV(player, SV.deathProtection) == 1 end

function takeHardcoreLife(player, killerName)
    local monsterT = monsters[killerName]
    if deathProtection(player) then return false end
    if player:getLevel() <= 2 then return false, player:sendTextMessage(BLUE, "Until level 2 you are protected with HC protection. Which means you do not loose hardcore life until then") end
    if bossRoom_takeHCLife(player, monsterT) then return addSV(player, SV.hardcoreLives, -1) end
end

function removeBuffs(player)
    for k, potionT in pairs(potions) do potions_removePotion(player, potionT, true) end
    removeSV(player, SV.bianhurenReflect)
    removeSV(player, SV.buffSpell)
    removeSV(player, SV.vampireDollBuff)
    removeSV(player, SV.mummyDollBuff)
    removeSV(player, SV.dumplingsArmor)
    removeSV(player, SV.easterHamCap)
    removeSV(player, SV.silenced)
    removeSV(player, SV.poisonSpell)
    removeSV(player, SV.yashimakiArmor)
    removeSV(player, SV.armorUpSpell)
    
    removeSV(player, SV.barrierDebuffPercent)

    local playerID = player:getId()
    for debuffID, t in pairs(onHitDebuff_damNerfT) do
        if t.creatureID == playerID then onHitDebuff_damNerfT[debuffID] = nil end
    end

    for debuffID, t in pairs(onHitDebuff_damageT) do
        if t.creatureID == playerID then onHitDebuff_damageT[debuffID] = nil end
    end
end

function removeAllConditions(player) removeCondition(player, allRemoveableConditions) end

function deathPenalty(player, killer)
    if challengeEvent_endChallenge(player) then return end
    local killerName = getKillerName(player, killer)
    local deathProtection = not takeHardcoreLife(player, killerName)
    local corpse = createItem(6022, player:getPosition())
    
    corpse:setAttribute(DESCRIPTION, "corpse of "..player:getName())
    corpse:decay()
    player:removeSV(SV.deathProtection)
    deathTeleport(player, deathProtection)
    if deathProtection then return player:sendTextMessage(BLUE, "You were in protected zone or had death protection. You did not loose anything.") end
    
    player:sendTextMessage(BLUE, "severe Death Penalty is enabled after you kill lore boss: Demon Skeleton")
    player:sendTextMessage(BLUE, "Right now if you lost anything its all put in your corpse where you died")
    player:setSV(SV.lastDeathTime, os.time())
    death_looseItems(player, corpse)
--    death_downgradeItems(player)
end

function death_looseItems(player, corpse)
    local bag = player:getBag()

    if not bag then return end
    local movedCylinder = 0
    
    for x=0, bag:getSize()-1 do
        local item = bag:getItem(x-movedCylinder)
        
        if not item then return end

        if not item:isContainer() and not isInArray(death_conf.ignoreItemsOnLoss, item:getId()) then
            item:moveTo(corpse)
            Vprint(item:getName(), "was moved to body on death")
        end
    end
end

function death_downgradeItems(player)
    local function downGradeItem(slot)
        local item = player:getSlotItem(slot)
        if not item then return end
        death_looseStone(player, item)
        gems_removeGem(item, 2)
        death_weakenStats(player, item)
    end

    for slot=0, 13 do downGradeItem(slot) end
end

function death_weakenStats(player, item)
    if not item:isEquipment() then return end
    local defaultStatT = items_getStats(item)
    local randomStat = randomKeyFromTable(defaultStatT)
    if type(randomStat) == "number" then return end
    return itemSystem_reduceStat(player, item, randomStat)
end

function death_looseStone(player, item)
    local stoneList = stones_getStones(item)
    local stoneID = randomKeyFromTable(stoneList)
    if not stoneID then return end

    local stoneT = stones_getStoneT(stoneID)
    local removeAmount = math.random(1, stoneT.stoneL)*2
    stones_removeStoneByID(player, item, stoneID, removeAmount) 
end

function deathTeleport(player, deathProtection)
    local townPos = player:homePos()

    if samePositions(player:getPosition(), townPos) then return end
    if deathArea(player) then return end
    if bossRoomTP(player, deathProtection) then return end
    if tutorial_completedTP(player) then return end
    player:teleportTo(townPos)
end

function deathArea(player)
    local playerPos = player:getPosition()
    
    for _, t in pairs(death_conf.deathAreas) do
        if isInRange(playerPos, t.upCorner, t.downCorner) then 
            if _G[t.func](player) then return true end
        end
    end
end