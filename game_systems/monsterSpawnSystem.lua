function monsterSpawns_startUp()
    if "" then return print("monsterSpawns_startUp() has been disabled") end
    for areaName, spawnT in pairs(spawns) do
        local areaPosT = createAreaOfSquares(spawnT.areaCorners)
        
        if not areaPosT then
            spawnT.spawnPosByMid = {}
            spawnT.amount = tableCount(spawnT.spawnPoints)
            areaPosT = spawnT.spawnPoints
        else
            areaPosT = removePositions(areaPosT, {"solid", "noTile"})
        end

        if spawnT.ignoreAreas then
            for i, pos in pairs(areaPosT) do
                for _, t in ipairs(spawnT.ignoreAreas) do
                    if isInRange(pos, t.upCorner, t.downCorner) then areaPosT[i] = nil end
                end
            end
        end

        spawnT.areaPosT = areaPosT
        
        for monsterName, mT in pairs(spawnT.monsterT) do
            mT.midT = {}
            if not mT.hpPercent then mT.hpPercent = 10 end
            if not mT.amount then mT.amount = "unlimited" end
        end
    end
    
    for areaName, spawnT in pairs(spawns) do spawn_summonMonster(spawnT, spawnT.amount) end
    print("monsterSpawns_startUp()")
end

function spawn_getSpawnPositions(spawnT, amount, mid)
    if amount > 1 or not spawnT.spawnPoints then
        if not spawnT.areaPosT then return print("areaPosT is missing IN spawns["..spawnT.name.."]") end
        return randomPos(spawnT.areaPosT, amount, true)
    elseif amount == 1 then
        if not mid then return randomPos(spawnT.areaPosT, amount, true) end
        local spawnPos = spawnT.spawnPosByMid[mid]
        if not spawnPos then return print("ERROR - spawnPos in spawn_getSpawnPositions") end
        spawnT.spawnPosByMid[mid] = nil
        return {spawnPos}
    end
    Vprint(amount, "ERROR - amount in spawn_getSpawnPositions")
end

function spawn_summonMonster(spawnT, amount, mid)
    if not spawnT then return end
    if type(spawnT) == "string" then spawnT = getSpawnTByID(spawnT) end
    local spawnPositions = spawn_getSpawnPositions(spawnT, amount, mid)

    for _, pos in pairs(spawnPositions) do
        local function spawn()
            local randomMonsterName = spawn_getValidMonster(spawnT)
            if not randomMonsterName then return end
            local monster = createMonster(randomMonsterName, pos)
            local monsterT = spawnT.monsterT[randomMonsterName]
            local mid = monster:getId()
            
            if not monster then return print("["..tostring(randomMonsterName).."] could not be summoned to pos: "..tostring(pos).." in spawn_summonMonster") end
            
            if monsterT.hpPercent then
                local randomPercent = math.random(0, monsterT.hpPercent)
                
                if randomPercent > 0 then
                    local monsterMaxHP = monster:getMaxHealth()
                    local mod = monsterMaxHP * randomPercent/100
                    
                    if math.random(1,2) == 1 then
                        monster:setMaxHealth(monsterMaxHP + mod)
                        monster:addHealth(mod)
                    else
                        monster:setMaxHealth(monsterMaxHP - mod)
                    end
                end
            end
            
            if spawnT.spawnPosByMid then spawnT.spawnPosByMid[mid] = pos end
            table.insert(monsterT.midT, mid)
        end
        
        doSendMagicEffect(pos, {33,33,33,33,33}, 1000)
        addEvent(spawn, 5000)
    end
end

function reSpawn(monster)
    local spawnT = getSpawnTByMonster(monster)
    if not spawnT then return end
    local monsterT = spawnT.monsterT
    local specificMonsterT = monsterT[monster:getName():lower()]
    local monsterID = monster:getId()

    if specificMonsterT.spawnLockDuration then specificMonsterT.spawnLockTime = os.time() + specificMonsterT.spawnLockDuration end
    specificMonsterT.midT = removeFromTable(specificMonsterT.midT, monsterID)
    addEvent(spawn_summonMonster, spawnT.spawnTime, spawnT.name, 1, monsterID)
end

function getSpawnTByMonster(monster)
    local monsterName = monster:getName():lower()
    local monsterID = monster:getId()

    local function monsterIsInSpawnT(spawnT)
        local monsterT = spawnT.monsterT[monsterName]
        if not monsterT then return end
        if not isInArray(monsterT.midT, monsterID) then return end
        return true
    end

    for areaName, spawnT in pairs(spawns) do
        if monsterIsInSpawnT(spawnT) then return spawnT end
    end
end

function getSpawnTByID(key) return spawns[key] end

local exludeMonsters = {}
function spawn_getValidMonster(spawnT)
    local monsterT = deepCopy(spawnT.monsterT)
        
    if tableCount(exludeMonsters) == 0 then
        for monsterName, t in pairs(monsterT) do
            if t.spawnLockTime and os.time() < t.spawnLockTime then
                table.insert(exludeMonsters, monsterName)
            end
        end
    end
    for _, monsterName in pairs(exludeMonsters) do monsterT[monsterName] = nil end
    if tableCount(monsterT) == 0 then exludeMonsters = {} return end
        
    local randomMonsterName = randomKeyFromTable(monsterT)
    local t = monsterT[randomMonsterName]

    if type(t.amount) == "number" and tableCount(t.midT) >= t.amount then
        table.insert(exludeMonsters, randomMonsterName)
        return spawn_getValidMonster(spawnT)
    else
        exludeMonsters = {}
        return randomMonsterName
    end
end

function central_register_monsterSpawns(spawnT)
    if not spawnT then return end
    for areaName, t in pairs(spawnT) do spawns[(t.name or areaName)] = t end
    if check_central_register_monsterSpawns then print("central_register_monsterSpawns") end
end