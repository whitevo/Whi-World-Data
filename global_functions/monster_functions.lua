local function getSpawnEventsT(monster, autoRegisterEvents)
    local onThinkEvents = {}
    local onDeathEvents = {}
    local onHealthChangeEvents = {}

    local function registerEvents(baseTable, addedTable)
        if not addedTable then return end
        if type(addedTable) ~= "table" then addedTable = {addedTable} end
        for _, funcStr in pairs(addedTable) do table.insert(baseTable, funcStr) end
    end

    local monsterName = monster:getName():lower()
    registerEvents(onThinkEvents, spawnEvents.onThink[monsterName])
    registerEvents(onDeathEvents, spawnEvents.onDeath[monsterName])
    registerEvents(onHealthChangeEvents, spawnEvents.onHealthChange[monsterName])

    local autoRegisterEvents = autoRegisterEvents ~= false
    local monsterT = getMonsterT(monster)
    if autoRegisterEvents and monsterT and monsterT.spawnEvents then
        registerEvents(onThinkEvents, monsterT.spawnEvents.onThink)
        registerEvents(onDeathEvents, monsterT.spawnEvents.onDeath)
        registerEvents(onHealthChangeEvents, monsterT.spawnEvents.onHealthChange)
        if loot[monsterName] then registerEvents(onDeathEvents, "lootSystem_onDeath") end
    end

    local spawnEventsT = {}
    if tableCount(onThinkEvents) > 0 then spawnEventsT.onThinkEvents = onThinkEvents end
    if tableCount(onDeathEvents) > 0 then spawnEventsT.onDeathEvents = onDeathEvents end
    if tableCount(onHealthChangeEvents) > 0 then spawnEventsT.onHealthChangeEvents = onHealthChangeEvents end
    return spawnEventsT
end

function createMonster(name, pos, autoRegisterEvents)
    if not pos or not pos.x then return print("ERROR - no position in createMonster()") end
    local monster = Game.createMonster(name, pos, false, true)
    if not monster then return print("ERROR - monsterName ["..name.."] was not created") end
    local spawnEventsT = getSpawnEventsT(monster, autoRegisterEvents)
    local monsterID = monster:getId()
    
    global_monsterList[monsterID] = true

    if spawnEventsT.onThinkEvents then
        local scriptT = {[monsterID] = spawnEventsT.onThinkEvents}
        registerEvent_onThink(scriptT)
        monster:registerEvent("onThink")
    end
    
    if spawnEventsT.onDeathEvents then
        local scriptT = {[monsterID] = spawnEventsT.onDeathEvents}
        registerEvent_onDeath(scriptT)
        monster:registerEvent("onDeath")
    end
    
    if spawnEventsT.onHealthChangeEvents then
        local scriptT = {[monsterID] = spawnEventsT.onHealthChangeEvents}
        registerEvent_onHealthChange(scriptT)
        monster:registerEvent("onHealthChange")
    end
    return monster
end

function getRace(monsterID)
    local monster = Monster(monsterID)
    if not monster then return end
    local monsterName = monster:getName():lower()
    return monsters[monsterName] and monsters[monsterName].race
end

function clean_tauntedCreatures()
    local tablesDeleted = 0
        
    for cid, targetID in pairs(tauntedCreatures) do
        if not Creature(cid) or not Creature(targetID) then
            tauntedCreatures[cid] = nil
            tablesDeleted = tablesDeleted + 1
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from clean_tauntedCreatures") end
    return tablesDeleted
end

function getMonsterT(monster)
    if not monster or monster:isPlayer() or monster:getMaster() then return end
    local monsterName = monster:getName():lower()
    local monsterT = monsters[monsterName]

    if not monsterT then return end
    if type(monsterT) == "string" then monsterT = monsters[monsterT] end
    return monsterT
end

local function killActions(creature, monsterT)
    if not monsterT.killActions then return end
    local monsterName = monsterT.name:lower()
    local attackers = creature:getDamageMap()
    
    local function executeAction(playerID, actionT)
        local player = Player(playerID)
        if not player then return end
        if not compareSV(player, actionT.allSV, "==") then return end
        if actionT.funcSTR then _G[actionT.funcSTR](player) end
        if actionT.rewardExp then player:addExpPercent(actionT.rewardExp) end
        if actionT.setSV then setSV(player, actionT.setSV) end
    end
    
    for playerID, t in pairs(attackers) do
        for _, actionT in pairs(monsterT.killActions) do executeAction(playerID, actionT) end
    end
end

function monster_onDeath(creature, corpse)
    local monsterT = getMonsterT(creature)
    if not monsterT or not creature then return end
    local player = getHighestDamageDealerFromDamageT(creature:getDamageMap())
    if not player then return end
    if challengeEvent_monsterKill(player) then return end
    local creatureID = creature:getId()

    bossRoom_kill(creature, monsterT)
    killActions(creature, monsterT)
    if temporarResByCid[creatureID] then temporarResByCid[creatureID] = nil end
    if conditionsStacks[creatureID] then conditionsStacks[creatureID] = nil end
    clean_scalingSystem(creatureID)
    clean_allEvents(creatureID)
    clean_targetDebuffT(creatureID)
    
    for guid, playerID in pairs(getPartyMembers(player, 10)) do
        local player = Player(playerID)
        
        if player and antiSpam(playerID, creature:getId()) then
            dundee_repOnDeath(player, monsterT)
            dundee_taskOnDeath(player, monsterT)
        end
    end
    reSpawn(creature)
end

