--[[ damageTriggerItems conf guide
    global = {                          triggers which are checked inside function dealDamagePos(...)
        [STR] = {                       
            itemID = {INT},             list of itemID's which are effected
            itemAID = {INT},            list of itemAID's which are effected
            specialOrigins = {INT}      list of origins what only affect this position trigger
            damType = {ENUM}            list of damage types what affect this position trigger
            damage = INT                required damage to proc the effect
            funcStr = STR               function what is triggered - _G[STR](item, damageT)
        }
    }
    
    custom = {                          triggers what are executed by calling damageTrigger_checkAndExecute(...)
        same confT as above
    }                         
]]

damageTriggerItems = {
    startUpFunc = "damageTriggerItems_startUp",

    global = {
        ["burnableHey"] = {
            itemID = {485, 5486, 5487, 5488, 5489, 5490, 5491, 5492, 5493, 5494, 5495, 5500, 5501, 5502, 5503, 5555, 5556, 3848, 3849, 3851, 3850},
            damType = FIRE,
            funcStr = "burnTheHey",
        },
    },
    custom = {
        ["cyclopsDungeonWalls"] = {
            itemID = {3523, 3509, 3525, 5296, 3517, 5297},
            funcStr = "cyclopsDungeonWalls_damageTrigger",
        },
    }
}

centralSystem_registerTable(damageTriggerItems)

function damageTriggerItems_startUp()
    local function checkConf(triggersT)
        for _, triggerT in pairs(triggersT) do
            if triggerT.itemAID and type(triggerT.itemAID) ~= "table" then triggerT.itemAID = {triggerT.itemAID} end
            if triggerT.itemID and type(triggerT.itemID) ~= "table" then triggerT.itemID = {triggerT.itemID} end
            if triggerT.damType and type(triggerT.damType) ~= "table" then triggerT.damType = {triggerT.damType} end
            if triggerT.specialOrigins and type(triggerT.specialOrigins) ~= "table" then triggerT.specialOrigins = {triggerT.specialOrigins} end
        end
    end

    checkConf(damageTriggerItems.global)
    checkConf(damageTriggerItems.custom)
    print("damageTriggerItems_startUp()")
end

local function damageTrigger_checkAndExecute(triggerT, damageT, tilePos)
    if triggerT.specialOrigins and not isInTable(triggerT.specialOrigins, damageT.origin) then return end
    if triggerT.damType and not isInTable(triggerT.damType, damageT.damType) then return end
    if triggerT.damage and triggerT.damage > damageT.damage then return end

    for _, item in ipairs(Tile(tilePos):getItems()) do
        if triggerT.itemID and isInTable(triggerT.itemID, item:getId()) or triggerT.itemAID and isInTable(triggerT.itemAID, item:getActionId()) then
            _G[triggerT.funcStr](item, damageT)
        end
    end
end

function damageTrigger_environmenItems(damageT, tilePos, customTriggers)
    local tile = Tile(tilePos)
    if not tile then return end

    for _, triggerT in pairs(damageTriggerItems.global) do
        damageTrigger_checkAndExecute(triggerT, damageT, tilePos)
    end
end

function damageTrigger_customItems_execute(triggerName, damageT, tilePos)
    return damageTrigger_checkAndExecute(damageTriggerItems.custom[triggerName], damageT, tilePos)
end

function central_register_damageTriggerItems(triggersT)
    if not triggersT then return end
    
    local function registerToTable(subKeyName)
        if not triggersT[subKeyName] then return end
        
        for triggerName, triggerT in pairs(triggersT[subKeyName]) do
            damageTriggerItems[subKeyName][triggerName] = triggerT
        end
    end

    registerToTable("global")
    registerToTable("custom")
end

print("damagetriggers loaded")