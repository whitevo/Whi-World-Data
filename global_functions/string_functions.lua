function textToLineT(text)
   local t = {}
   local function helper(line) return "", table.insert(t, line) end
   helper((text:gsub("(.-)\r?\n", helper)))
   return t
end

function stringToLetterT(str)
    local strT = {}
    local loopID = 0

    for letter in str:gmatch(".") do
        loopID = loopID + 1
        strT[loopID] = letter
    end
    return strT
end

function chooseString(stringT, key)
    if type(stringT) ~= table then stringT = {stringT} end
    key = key or 1
    return stringT[key] or ""
end

function stringIfMore(string, INT, needINT)
    local needINT = needINT or 1
    local INT = tonumber(INT) or 1
    return INT > needINT and string or ""
end

function plural(word, amount)
    if not amount then return "1 "..word end
    local letterT = stringToLetterT(word)
    local s = letterT[#word] ~= "s" and stringIfMore("s", amount) or ""
    return amount.." "..word..s
end

function tableToStr(t, betweenText, iPairs)
    if type(t) ~= "table" then return t end
    local str = ""
    local betweenText = betweenText or ", "
    local tableCount = tableCount(t)
    
    if tableCount == 0 then return str end

    if iPairs then
        local smallestNumber = tableCount
        local biggestNumber = 0

        for i, v in pairs(t) do
            if i > biggestNumber then biggestNumber = i end
            if i < smallestNumber then smallestNumber = i end
        end

        if smallestNumber ~= 1 or biggestNumber ~= tableCount then
            iPairs = false
            str = str.."(NOT ipairs)"
        end
    end

    if iPairs then
        for i, v in ipairs(t) do
            if type(v) == "userdata" then v = "userdata" end
            str = i == 1 and v or str..betweenText..v
        end
    else
        for _, v  in pairs(t) do
            if type(v) == "userdata" then v = "userdata" end
            str = str == "" and v or str..betweenText..v
        end
    end
    return str
end

function getMSGDelay(msg)
    local l = tonumber(msg:len())
    
    if l < 50 then return math.floor(l/6)*1000 end
    if l < 100 then return math.floor(l/8)*1000 end
    if l < 150 then return math.floor(l/10)*1000 end
    return math.floor(l/12)*1000
end

function addMsgDelayToMsgT(msgT)
    local delay = 1000
    local messages = tableCount(msgT)
    local newMsgT = {}

    for delay, msg in pairs(msgT) do
        if delay > 1000 then
            newMsgT[delay] = msg
            msgT[delay] = nil
        end
    end
    
    for _, msg in ipairs(msgT) do
        local msgDelay = getMSGDelay(msg)
        newMsgT[delay] = msg
        delay = delay + msgDelay
    end
    return newMsgT
end

string.split = function(str, sep)
    local res = {}
    
    for v in str:gmatch("([^" .. sep .. "]+)") do
        res[#res + 1] = v
    end
    return res
end

string.trim = function(str)
    return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

string.getINT = function(str, sequence)
    local letterT = stringToLetterT(str)
    local sequence = sequence or 1
    local loopID = 0

    for _, letter in ipairs(letterT) do
        if tonumber(letter) then
            loopID = loopID + 1
            if loopID == sequence then return tonumber(letter) end
        end
    end
end

string.removeSpaces = function(str, fromStart, fromEnd, all)
    if all then return str:gsub("% ", "") end
    local letterT = stringToLetterT(str)
    local newString = ""
    local reversed_letterT = reverseTable(letterT)
    local letterCount = #letterT

    if fromStart or fromStart == nil then
        for i, letter in ipairs(letterT) do
            if letter ~= " " then break end
            letterT[i] = false
        end
    end

    if fromEnd or fromEnd == nil then
        for i, letter in ipairs(reversed_letterT) do
            if letter ~= " " then break end
            local key = letterCount - (i-1)
            letterT[key] = false
        end
    end

    for _, letter in ipairs(letterT) do
        if letter then newString = newString..letter end
    end
    return newString
end

function MWTitle(str)
    local strLength = str:len()
    local maxLength = 86
    if strLength > maxLength then return str end
    local spaceMaxDistance = 110
    local spaces = createSpaces(str, spaceMaxDistance)
    local spaceLength = spaces:len()

    if strLength < 10 then spaceLength = spaceLength + 60
    elseif strLength < 20 then spaceLength = spaceLength + 50
    elseif strLength < 40 then spaceLength = spaceLength + 30
    end
    
    local halfSpacesAmount = math.floor(spaceLength/2)
    if halfSpacesAmount < 1 then return str end
    local halfSpacesStr = ""
    
    for x=1, halfSpacesAmount do halfSpacesStr = halfSpacesStr.." " end
    return halfSpacesStr..str..halfSpacesStr
end

function removeBrackets(str) -- remove brackets usually used after: %b()
    str = str:gsub("[(]", '')
    str = str:gsub("[)]", '')
    return str
end

function activateFunctionStr(str, ...)
    if not str then return end
    
    if type(str) == "table" then
        for _, str in pairs(str) do activateFunctionStr(str, ...) end
        return
    end
    
    if not _G[str] then return print("MISSING FUNCTION: ["..str.."]() in activateFunctionStr()") end
    _G[str](...)
end

function createSpaces(str, stringDistance)
    local nameLength = str:len()
    local neededSpaces = stringDistance-nameLength
    local s=" "

    for w in str:gmatch(" ") do s=s.."  " end
    for w in str:gmatch("j") do s=s.."  " end
    for w in str:gmatch("t") do s=s.." " end
    for w in str:gmatch("i") do s=s.."  " end
    for w in str:gmatch("l") do s=s.."  " end
    if neededSpaces < 2 then return s end
    for x=1, neededSpaces do s=s.." " end
    return s
end
