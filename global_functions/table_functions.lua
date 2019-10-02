local function printTable(table, spaces)
    local newSpaces = spaces.."  "

    local function createKeyTableStr(currentStr, table)
        local firstValue = true
                
        for k2, v2 in pairs(table) do
            if firstValue then
                currentStr = currentStr.."["..k2.."] = "..v2
                firstValue = false
            else
                currentStr = currentStr..", ["..k2.."] = "..v2
            end
        end
        return currentStr
    end

    for k,v in pairs(table) do
        if type(v) == "table" then
            if type(k) == "table" then
                local Tstr = createKeyTableStr(newSpaces.."{", k)
                print(Tstr.."} = {")
                printTable(v, "  "..spaces)
            else
                print(newSpaces..k.." = {")
                printTable(v, "  "..spaces)
            end
        else
            if type(k) == "table" then
                local Tstr = createKeyTableStr(newSpaces.."{", k)
                print(Tstr.."} = "..tostring(v))
            else
                print(newSpaces..k.." = "..tostring(v))
            end
        end
    end
    print(spaces.."}")
end

function Uprint(table, printName)
    if type(table) == "userdata" then table = getmetatable(table) end
    if not printName then printName = "table" end
    print()
    print(" ---==| "..printName.." |==---")
    print("{")
    if table then
        printTable(table, "")
    end
    print("---==|___________|==---")
    print()
end

function Vprint(variable, variableName, player)
    local n = variableName or "variable"
    local printMsg = n..": "..tostring(variable)
    print(printMsg)
    if player and type(player) == "userdata" and player:isPlayer() then player:sendTextMessage(ORANGE, printMsg) end
end

local function printTable2(table, spaces)
    local newSpaces = spaces.."  "
    local tableInfo = ""

    for k,v in pairs(table) do
        if type(v) == "table" then
            if type(k) == "table" then
                for keyT, v2 in pairs(k) do print(keyT.."  "..tostring(v2)) end
            else
                printTable2(v, "  "..spaces)
            end
        else
            tableInfo = tableInfo..tostring(v)..", "
        end
    end
    print("{"..tableInfo.."}")
end

function Aprint(table, printName)
    if not printName then printName = "table" end
    print()
    print(" ---==| "..printName.." |==---")
    if table then printTable2(table, "") end
    print("---==|___________|==---")
    print()
end

function Tprint(titelName)
    print()
    print("   ___##:. "..titelName.." .:##___   ")
    print()
end

function compare(v1, v2)
    if not v1 or not v2 then return true end
    if v1 == v2 then return true end
end

function tableCount(t)
    local count = 0
    if not t or type(t) ~= "table" then return count end
    for _, v in pairs(t) do count = count + 1 end
    return count
end

function deepCopy(object)
    local lookup_table = {}

    local function _copy(object)
        local new_table = {}

        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        
        lookup_table[object] = new_table
        
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function matchTableValue(t, value)
    for k, v in pairs(t) do
        if v == value then return true end
    end
end

function matchTableKey(t, key)
    for k, v in pairs(t) do
        if key == k then return true end
    end
end

function sortIpairsT(t, string)
    if string == "high" then
        table.sort(t, function(a, b) return b < a end) 
    elseif string == "low" then
        table.sort(t, function(a, b) return b > a end)
    end
    return t
end

function sorting(unsortedTable, string)
    local sortedTable = {}
    local loopID = 0

    for k, v in pairs(unsortedTable) do
        loopID = loopID + 1
        sortedTable[loopID] = k
    end
    return sortIpairsT(sortedTable, string)
end

function sortByValue(unsortedTable, string)
    local sortedTable = {}
    local loopID = 0

    for k, v in pairs(unsortedTable) do
        loopID = loopID + 1
        sortedTable[loopID] = v
    end
    return sortIpairsT(sortedTable, string)
end

function sortByTableValue(unsortedTable, string, key)
local sortedT = {}
local sortedValueT = {}
local loopID = 0
local tempUnsortedTable = deepCopy(unsortedTable)
    
    for k, t in pairs(unsortedTable) do
        loopID = loopID + 1
        sortedValueT[loopID] = t[key]
    end

    sortedValueT = sortIpairsT(sortedValueT, string)
    
    for i, value in ipairs(sortedValueT) do
        for k, t in pairs(tempUnsortedTable) do
            if t[key] == value then
                sortedT[i] = t
                tempUnsortedTable[k] = nil
                break
            end
        end
    end
    return sortedT
end

function reverseTable(unsortedTable)
    local sortedTable = {}
    if tableCount(unsortedTable) ~= #unsortedTable then return print("ERROR - reverseTable only reverses ipairs tables"), Uprint(unsortedTable, "unsortedTable") end
    for x=1, #unsortedTable do table.insert(sortedTable, unsortedTable[#unsortedTable-(x-1)]) end
    return sortedTable
end

function isMatrix(table)
    if not table then return 0 end
    local layer = 0
    
    local function checkNewTable()
        for _, t in pairs(table) do
            if type(t) == "table" then
                table = t
                return true
            end
        end
    end
    
    while checkNewTable() do layer = layer + 1 end
    return layer
end

function removeFromTable(table, valueT, maxAmount)
    if type(valueT) ~= "table" then valueT = {valueT} end
    local valuesRemoved = 0
    local newT = {}
    
    local function addValue(k, v)
        if not isInArray(valueT, v) then newT[k] = v return end
        if not maxAmount or maxAmount < valuesRemoved then valuesRemoved = valuesRemoved + 1 return end
        newT[k] = v
    end

    for k, v in pairs(table) do addValue(k, v) end
    return newT
end

function randomKeyFromTable(t, ignoreList)
    if not t then return end
    if tableCount(t) == 0 then return end
    local allowedKeys = {}

    if ignoreList then
        for k, v in pairs(t) do
            if not isInArray(ignoreList, k) then table.insert(allowedKeys, k) end
        end
    else
        for k, v in pairs(t) do table.insert(allowedKeys, k) end
    end
    
    local allowedKeyAmount = tableCount(allowedKeys)
    if allowedKeyAmount == 0 then return end
    return allowedKeys[math.random(1, allowedKeyAmount)]
end

function randomValueFromTable(t)
    if not t then return end
    local count = tableCount(t)
    
    if count == 0 then return end
    local r = math.random(1, count)
    local loopID = 0
    
    for k, v in pairs(t) do
        loopID = loopID + 1
        if loopID == r then return v end
    end
end

function setTableVariable(table, key, newValue) table[key] = newValue end

function getSameTableValue(t1, t2)
    if not t1 or not t2 then return end

    for _, v in pairs(t1) do
        if matchTableValue(t2, v) then return v end
    end
end