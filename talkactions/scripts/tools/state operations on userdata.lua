--[[ operationsConf guide
    creatureOperations = {              all the operations what can be done to creature
        [STR] = {                       operation name
            choiceMsg = STR             description message
                                        STATE = stateCheckFunc and "ON" or "OFF"
            stateCheckFunc = STR        function to check if state is activated or not | stateCheckFunc(player, userdata)
            operationFunc = STR         function what activates when operation chosen | opereationFunc(player, userdata)
            
            AUTOMATIC
            choiceID = INT
        }
    }
    itemOperations = {}                 same guide as for creatureOperations
]]

operationConf = {
    creatureOperations = {
        noDam = {
            choiceMsg = "takes no damage: STATE",
            stateCheckFunc = "state_takesNoDamage",
            operationFunc = "stateReg_takesNoDamage",
        }
    },
    itemOperations = {
        canMove = {
            choiceMsg = "can move item: STATE (only works for items which can be moved by default)",
            stateCheckFunc = "canBeMoved",
            operationFunc = "stateReg_canMove",
        },
        clone = {
--            createItem(itemID, pos, count, itemAID, fluidType, itemText, object)
            choiceMsg = "!i itemID, count, itemAID, fluidType, itemText",
            operationFunc = "god_cloneLuaItem",
        },
    }
}

operationFeature = {
    startUpFunc = "operation_startUp",
    modalWindows = {
        [MW.userdataOperations_main] = {
            name = 'state operations on userdata',
            title = 'choose userdata',
            choices = 'operation_main_MW_choices',
            buttons = {[100] = 'Choose', [101] = 'Close'},
            say = 'accessed userdata operations',
            func = 'operation_main_MW_handle',
        },
        [MW.userdataOperations_creature] = {
            name = 'state operations on creature userdata',
            title = 'operation_userdata_MW_title',
            choices = 'operation_userdata_MW_choices',
            buttons = {[100] = 'Choose', [101] = 'Close'},
            func = 'operation_userdata_MW_handle',
            save = 'saveParams',
        },
        [MW.userdataOperations_item] = {
            name = 'state operations on item userdata',
            title = 'operation_userdata_MW_title',
            choices = 'operation_userdata_MW_choices',
            buttons = {[100] = 'Choose', [101] = 'Close'},
            func = 'operation_userdata_MW_handle',
            save = 'saveParams',
        },
    },
}

centralSystem_registerTable(operationFeature)
function onSay(player, words, param)
    if not player:isGod() then return true end
    player:createMW(MW.userdataOperations_main)
end

function operation_startUp()
    local loopID = 0

    local function addChoiceID(mwT)
        loopID = loopID + 1
        mwT.choiceID = loopID
    end
    
    for _, mwT in pairs(operationConf.creatureOperations) do addChoiceID(mwT) end
    for _, mwT in pairs(operationConf.itemOperations) do addChoiceID(mwT) end
end

function operation_main_MW_choices(player)
    local choiceT = {}
    if luaCreatureUserData then choiceT[1] = "creature userdata name: "..luaCreatureUserData:getName() end
    if luaItemUserData then choiceT[2] = "item userdata name: "..luaItemUserData:getName() end
    return choiceT
end

function operation_main_MW_handle(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    if choiceID == 1 then return player:createMW(MW.userdataOperations_creature, luaCreatureUserData) end
    if choiceID == 2 then return player:createMW(MW.userdataOperations_item, luaItemUserData) end
end

function operation_userdata_MW_title(player, userdata) return "userdata name: "..userdata:getName() end

local function operation_parseChoiceMsg(player, userdata, mwT)
    local msg = mwT.choiceMsg
    if not mwT.stateCheckFunc then return msg end

    local stateStr = _G[mwT.stateCheckFunc](player, userdata) and "ON" or "OFF"
    msg = msg:gsub("STATE", stateStr)
    return msg
end

function operation_userdata_MW_choices(player, userdata)
    local choiceT = {}
    local opT = userdata:isItem() and operationConf.itemOperations or operationConf.creatureOperations
    for _, mwT in pairs(opT) do choiceT[mwT.choiceID] = operation_parseChoiceMsg(player, userdata, mwT) end
    return choiceT
end

function operation_userdata_MW_handle(player, mwID, buttonID, choiceID, userdata)
    if buttonID == 101 then return end
    local operationT = operation_get_operationT(choiceID)
    if not operationT then return print("ERROR in operation_userdata_MW_handle - missing operationT for choiceID: "..choiceID) end
    _G[operationT.operationFunc](player, userdata)
    return player:createMW(MW.userdataOperations_main)
end

-- get functions
function operation_get_operationT(choiceID)
    for _, mwT in pairs(operationConf.creatureOperations) do
        if mwT.choiceID == choiceID then return mwT end
    end

    for _, mwT in pairs(operationConf.itemOperations) do
        if mwT.choiceID == choiceID then return mwT end
    end
end

-- custom state functions
function state_takesNoDamage(player, creature) return takeNoDamage[creature:getId()] end

function stateReg_takesNoDamage(player, creature)
    local bool = not state_takesNoDamage(player, creature) and true or false
    takeNoDamage[creature:getId()] = bool
end

function stateReg_canMove(player, item)
    local bool = canBeMoved(player, item) and true or false
    local itemAID = item:getActionId()
    
    if itemAID > 0 then
        byAID[itemAID] = bool
    else
        byID[item:getId()] = bool
    end
end

function god_cloneLuaItem(player, item)
    local itemID = item:getId()
    local count = item:getCount()
    local itemAID = item:getActionId()
    local fluidType = item:getFluidType()
    local itemText = item:getAttribute(TEXT)
    
    player:sendTextMessage("!i "..itemID..","..count..","..itemAID..","..fluidType..","..itemText, BLUE)
    createItem(itemID, pos, count, itemAID, fluidType, itemText)
end