scaleBackup = {}
scaleMemory = {}
scaleCD = {}
local percent = 30

function scalingSystem_onThink(monster)
    if not monster:isMonster() then return end
    local players = monster:getEnemies()
    local monsterID = monster:getId()
    local monsterT = monsters[monster:getName():lower()]
    local backUpT = scalingSystem_getBackUpT(monsterID)

    for _, playerID in pairs(players) do
        local player = Player(playerID)
        
        if player and getDistanceBetween(player:getPosition(), monster:getPosition()) < 10 then
            if not matchTableKey(backUpT, playerID) then backUpT[playerID] = 5 end
        end
    end
    
    local function backUpCounter(playerID, counter)
        local player = Player(playerID)
        if not player then backUpT[playerID] = nil return end
        
        local distance = getDistanceBetween(player:getPosition(), monster:getPosition())
        if distance < 10 then backUpT[playerID] = 5 return end
        
        counter = counter - 1
        if counter < 1 then backUpT[playerID] = nil return end
        backUpT[playerID] = counter
    end

    for playerID, counter in pairs(backUpT) do backUpCounter(playerID, counter) end

    if not monsterT then return end
    if not monsterT.HPScale then return end

    if not scaleMemory[monsterID] then
        scaleMemory[monsterID] = {
            scale = 0,
            startHP = monster:getMaxHealth(),
        }
    end
    
    local scale = getScale(monsterID)
    if not scale then return end
    
    local memoryT = scaleMemory[monsterID]
    local mScale = memoryT.scale
    if scale == mScale then return end

    memoryT.scale = scale
    scale = scale - 1
    mScale = mScale - 1
    local maxHP = memoryT.startHP
    local addMaxHP = math.floor(maxHP*scale*percent/100)
    local monsterHP = monster:getHealth()
    local newMaxHealth = maxHP + addMaxHP
    
    if scale < mScale then
        local scalePercent = math.floor((mScale - scale) * percent/100)
        local takeHP = monsterHP * scalePercent
        
        if takeHP > maxHP * scalePercent then takeHP = maxHP * scalePercent end
        monster:setMaxHealth(newMaxHealth)
        monster:addHealth(-takeHP)
    elseif scale > mScale then
        local addHP = math.floor(monsterHP * scale * percent/100)
        
        monster:setMaxHealth(newMaxHealth)
        monster:addHealth(addHP)
    end
end

function scalingSystem_getBackUpT(monsterID)
    if not scaleBackup[monsterID] then
        scaleBackup[monsterID] = {}
        scaleCD[monsterID] = 5
    else
        local cd = scaleCD[monsterID] -1
        if cd > 0 then scaleCD[monsterID] = cd else scaleCD[monsterID] = 10 end
    end
    return scaleBackup[monsterID]
end

function getScale(monsterID)
    local monster = Creature(monsterID)
    if not monster or not monster:isMonster() then return end
    local backup = scaleBackup[monsterID]
    local backUpCount = tableCount(backup)
    return backUpCount > 0 and backUpCount or 0
end

function clean_scalingSystem(monsterID)
    if monsterID then
        scaleBackup[monsterID] = nil
        scaleMemory[monsterID] = nil
        scaleCD[monsterID] = nil
    else
        clean_cidList(scaleBackup, true)
        clean_cidList(scaleMemory, true)
        clean_cidList(scaleCD, true)
    end
end