barrierStorages = {SV.barrierSpell, SV.shimasuLegs_barrier}
local highestBarrierValue = {} -- [playerID] = highestBarrierAchieved
local barrierMap = {} -- [playerID = {[os.time()] = barrierDamTaken]

function Player.getBarrier(player)
    local totalBarrier = 0

    for _, sv in pairs(barrierStorages) do
        local barrierAmount = getSV(player, sv)
        if barrierAmount > 0 then totalBarrier = totalBarrier + barrierAmount end
    end
    
    if totalBarrier < 1 then return 0 end
    barrier_registerHighestValue(player, totalBarrier)
    return totalBarrier
end

function barrierDamage(player, damage, damType)
    if damage < 1 then return 0 end
    if player:getBarrier() < 1 then return 0 end
    damage = damage + getBarrierDebuff(player, damage, damType)
    return player:takeBarrier(damage)
end

function barrier_registerHighestValue(player, totalBarrier)
local playerID = player:getId()

    if not highestBarrierValue[playerID] then highestBarrierValue[playerID] = totalBarrier return end
    if highestBarrierValue[playerID] < totalBarrier then highestBarrierValue[playerID] = totalBarrier end
end

function clean_highestBarrierValue(playerID)
    if playerID then highestBarrierValue[playerID] = nil return end
    
    for playerID, maxBarrier in pairs(highestBarrierValue) do
        if not Player(playerID) then highestBarrierValue[playerID] = nil end
    end
end

function Player.takeBarrier(player, amount)
    local playerID = player:getId()
    if not barrierMap[playerID] then barrierMap[playerID] = {} end
    local barrierT = barrierMap[playerID]
    local time = os.time()
    local previousDam = barrierT[time] or 0
    local damageAbsorbed = 0
    local playerPos = player:getPosition()

    local function removeBarrierFromSV(sv)
        if damageAbsorbed >= amount then return 0 end
        local barrierAmount = getSV(player, sv)
        
        if barrierAmount < 1 then return 0 end

        if barrierAmount > amount then
            barrierT[time] = previousDam + amount
            playerPos:sendMagicEffect(31)
            registerAddEvent(playerID, time, 1000, {sayBarrierAbsorbed, playerID, time})
            addSV(player, sv, -amount)
            damageAbsorbed = damageAbsorbed + amount
        else
            barrierT[time] = previousDam + barrierAmount
            damageAbsorbed = damageAbsorbed + barrierAmount
            setSV(player, sv, 0)
        end
    end
    
    for _, sv in pairs(barrierStorages) do removeBarrierFromSV(sv) end
    if player:getBarrier() > 0 then return damageAbsorbed end
    local positions = getAreaAround(playerPos)

    for _, pos in pairs(positions) do playerPos:sendDistanceEffect(pos, 37) end
    arogjaHat_heal(player)
    kamikazePants_explodeBarrier(player)
    player:sendTextMessage(ORANGE, "BARRIER IS BROKEN!")
    highestBarrierValue[playerID] = 0
    Vprint(damageAbsorbed, "damageAbsorbed 2")
    return damageAbsorbed
end

function sayBarrierAbsorbed(playerID, time)
    local player = Player(playerID)
    if not player then return end

    local dam = barrierMap[playerID][time]
    if not dam then return end
    local barrier = player:getBarrier()
    if barrier == 0 then return end

    player:say(dam.. " damage absorbed", ORANGE)
    player:sendTextMessage(ORANGE, "barrier can absorb "..barrier.." damage more")
end

function getBarrierDebuff(player, damage, damType)
    if not creature or damage >= 0 then return 0 end
    local percent = player:getSV(SV.barrierDebuffPercent)
    if amount < 1 then return 0 end
    return percentage(damage, percent)
end

function explodeBarrier(player) -- removes barrier and deals damage depending on barrier amount
    local playerID = player:getId()
    local damage = highestBarrierValue[playerID] or 0
    local percent = 0
    local distance = 1 + kamikazeShortPants_radius(player)
    local damType = DEATH
    local playerPos = player:getPosition()
    local positions = getAreaAround(playerPos, distance)
    local totalDamageMade = 0

    percent = percent + kamikazeMask_explosionPercent(player)
    percent = percent + kamikazeMantle_explosionPercent(player)
    percent = percent + kamikazePants_explosionPercent(player)
    percent = percent + immortalKamikaze_explosionPercent(player)
    
    damage = damage + elemental_powers(player, damage, damType)
    damage = damage + percentage(damage, percent)
    
    highestBarrierValue[playerID] = 0
    kamikazeMaskResistance(player, damage)
    
    for _, pos in pairs(positions) do
        local creature = findCreature("creature", pos)
        if creature then
            totalDamageMade = totalDamageMade + damage
            dealDamage(player, creature, damType, damage, 18, O_player_proc)
        end
        playerPos:sendDistanceEffect(pos, 11)
    end
    
    kamikazeMantle_activateDamageBoost(player, totalDamageMade)
    for _, sv in pairs(barrierStorages) do setSV(player, sv, 0) end
end