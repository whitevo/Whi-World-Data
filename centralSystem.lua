--[[ centralT config guide
    
    npcPos = POS,                       spawn position for npc
    
    mapEffects = {                      config guide: game_systems > map animation effects.lua
        [STR] = mapEffectsConfigT       STR must be unique in given config table, but not overall
    }
    registerEvent = {                   adds these events to monster when they are created to game
        [STR] = {                       "onThink", "onDeath", "onHealthChange"
            [STR] = {                   monstername
                STR,                    eventName
            }
        }
    }
    
    startUpFunc = STR                   startUp custom function
    startUpPriority = INT or 0          to activate startUp later
    
    area = {}                           config guide: globalevents > scripts > startup.lua
    questlog = {}                       config guide: game_systems > questlog.lua
    constructions = {}                  config guide: 
   
    npcArea = {}                        config guide: npc > npcSystem conf.lua
    npcChat = {}                        config guide: npc > npcSystem conf.lua
    npcShop = {}                        config guide: npc > npcSystem conf.lua
    
    discover = {}                       config guide: 
    monsterSpawns = {}                  config guide: game_systems > spawnSystem_conf.lua
    deathArea = {}                      config guide: game_systems > deathSystem_conf.lua
    modalWindows = {}                   config guide: game_systems > modalWindows.lua
    randomLoot = {}                     config guide: features > containers > random loot.lua
    itemRespawns = {}                   config guide: game_systems > itemRespawnSystem.lua
    keys = {}                           config guide: features > keys.lua
    damageTriggerItems = {}             config guide: features > damageTrigger_environmentItems.lua
    
    monsters = {}                       config guide: monsters > monsters.lua
    monsterResistance = {}              config guide: 
    monsterLoot = {}                    config guide: 
    monsterSpells = {}                  config guide: spells > monster_spells > configuration.lua

    homeTP = {}                         config guide: features > homeTP conf.lua
    bossRoom = {}                       config guide: features > bosses system.lua
    items = {}                          config guide: items > itemTable.lua
    
    onLogin = {}                        config guide: 
    onLogout = {}                       config guide: ?? | must return true if can logout
    onMove = {}                         overall onMove event before any other onMove event | creature, item, itemEx, fromPos, toPos, fromObject, toObject
    onMove2 = {}                        overall onMove event after all other onMove events | creature, item, itemEx, fromPos, toPos, fromObject, toObject
    IDItems = {}                        
    IDItems_onLook = {}                 
    IDItems_onMove = {}                 creature, item, itemEx, fromPos, toPos, fromObject, toObject
    AIDItems = {}                       
    AIDItems_onLook = {}                
    AIDItems_onMove = {}                creature, item, itemEx, fromPos, toPos, fromObject, toObject
    IDTiles_stepIn = {}
    IDTiles_stepOut = {}
    AIDTiles_stepIn = {}
    AIDTiles_stepOut = {}
    
    lootSystem_extraChance = {STR}      function strings | lootSystem_getExtraChance(player, itemT, lootT)
    lootSystem_bonusChance = {STR}      function strings | lootSystem_getBonusChance(player, baseChance, itemT, lootT)

    -automatic
    roomT = posT    all positions if upCorner and downCorner used
]]

-- NB avoiding dofiling centraltables with monsterSpells for now, converting is wtf!
local centralSystemLoaded = false

-- registering has to happen BEFORE THAT SYSTEM startUp()
-- these check lines can be deleted in future if no problems occured in sequence
check_central_register_items = false
check_central_register_actionEvent = false
check_central_register_monsterLoot = false
check_central_register_mapEffects = false
check_central_register_questLog = false
check_central_register_monsterSpawns = false
check_central_register_npcShop = false
check_central_register_npcChat = false
check_central_register_registerEvent = false
---------------------------------------------------------

globalAreas = {} -- not quite sure what the fuck is the point of this

-- centralSystem tables which must be here
startUpT = {} -- [funcStr] = priority level
loadUpSequence = {}

function centralSystem_registerTable(t) return table.insert(loadUpSequence, t) end

function central_registerAll()
    central_register_actionEvent(IDItems, "IDItems")
    central_register_actionEvent(AIDItems, "AIDItems")
    for _, t in ipairs(loadUpSequence) do central_registerSystems(t) end -- new
    centralSystemLoaded = true
end

function central_registerSystems(centralT)
    central_register_insertToTable(centralT.lootSystem_extraChance, centralSystem_extraLootChance)
    central_register_insertToTable(centralT.lootSystem_bonusChance, centralSystem_bonusLootChance)
    central_register_insertToTable(centralT.onLogin, onLoginFunctions, true)
    central_register_insertToTable(centralT.onLogout, onLogoutFunctions, true)
    central_register_insertToTable(centralT.deathArea, death_conf.deathAreas)
    central_register_insertToTable(centralT.itemRespawns, itemRespawns)
    central_register_insertToTable(centralT.onMove, onMoveT)
    central_register_insertToTable(centralT.onMove2, onMoveT2)
    
    central_register_intoGlobalT(centralT.modalWindows, modalWindows)
    central_register_intoGlobalT(centralT.monsterResistance, elementalResistances)
    central_register_intoGlobalT(centralT.monsters, monsters)
    central_register_intoGlobalT(centralT.monsterSpells, monsterSpells)

    central_register_homeTP(centralT.homeTP)
    central_register_keys(centralT)
    central_register_monsterLoot(centralT.monsterLoot)
    central_register_construct(centralT.constructions)
    central_register_area(centralT.area)
    central_register_discover(centralT.discover)
    central_register_damageTriggerItems(centralT.damageTriggerItems)

    central_register_actionEvent(centralT.IDItems, "IDItems")
    central_register_actionEvent(centralT.AIDItems, "AIDItems")

    central_register_actionEvent(centralT.IDItems_onLook, IDItems_onLook)
    central_register_actionEvent(centralT.IDItems_onMove, IDItems_onMove)
    central_register_actionEvent(centralT.AIDItems_onLook, AIDItems_onLook)
    central_register_actionEvent(centralT.AIDItems_onMove, AIDItems_onMove)
    central_register_actionEvent(centralT.AIDTiles_stepIn, AIDTiles_stepIn)
    central_register_actionEvent(centralT.AIDTiles_stepOut, AIDTiles_stepOut)
    central_register_actionEvent(centralT.IDTiles_stepIn, IDTiles_stepIn)
    central_register_actionEvent(centralT.IDTiles_stepOut, IDTiles_stepOut)

    central_register_questLog(centralT.questlog)
    central_register_mapEffects(centralT.mapEffects)
    central_register_randomLoot(centralT.randomLoot)
    central_register_monsterSpawns(centralT.monsterSpawns)
    central_register_bossRoom(centralT.bossRoom)
    central_register_items(centralT.items)
    
    createNpc(centralT) -- this should have its own npc table with npc paramaters instead of directly inside the centralT
    central_register_npcChat(centralT.npcChat)
    central_register_npcShop(centralT.npcShop)
    central_register_registerEvent(centralT.registerEvent)
    
    central_register_startUp(centralT)
end

function central_register_intoGlobalT(newT, global_table)
    if not newT then return end
    for k, t in pairs(newT) do global_table[k] = t end
end

function central_register_startUp(centralT)
    if not centralT.startUpFunc then return end
    if centralSystemLoaded then return addEvent(_G[centralT.startUpFunc], 1000) end
    local priority = centralT.startUpPriority or 0
    startUpT[centralT.startUpFunc] = priority
end

function central_register_area(areaT)
    if not areaT then return end

    if areaT.regions then
        areaT.areaCorners = {}
        for areaName, centralT in pairs(areaT.regions) do
            for _, areaCorners in pairs(centralT.area.areaCorners) do
                table.insert(areaT.areaCorners, areaCorners)
            end
        end
    end
    table.insert(globalAreas, areaT)
end

function central_register_insertToTable(table, global_table, directInsert)
    if not table then return end
    if directInsert then global_table[#global_table + 1] = table return end
    if type(table) ~= "table" then table = {table} end

    for _, v in pairs(table) do
        local key = #global_table + 1
        global_table[key] = v
    end
end

function central_register_registerEvent(eventT) -- this function should be somewhere else
    if not eventT then return end
    for event, eventConfT in pairs(eventT) do
        for monsterName, eventNames in pairs(eventConfT) do
            if type(eventNames) ~= "table" then eventNames = {eventNames} end
            spawnEvents[event][monsterName] = eventNames
        end
    end

    if check_central_register_registerEvent then print("central_register_registerEvent") end
end

print("centralSystem loaded..")