--[[ conf guide
    xmlFolderPath = STR         path where are all the monster xml files you want to convert
    outputFolderPath = STR      path where you want the converted lua table file to be created
    outputFileName = STR        file name what the new file name will have
]]

local conf = {
    xmlFolderPath = "data/xml_files",
    outputFolderPath = "data",
    outputFileName = "monster_lua_tables.lua",
}

function generateMonstersT()
    conf.tempMonstersT = {}
    for fileName in io.popen([[dir "./]]..conf.xmlFolderPath..[[" /b /aa]]):lines() do
        addInfoFromFiles(fileName)
    end
    createMonstersT_file()
end

local function findCapturePattern(lineT, pattern, exitPattern)
    for _, line in ipairs(lineT) do
        if exitPattern and line:match(exitPattern) then return end
        local capture = string.match(line, pattern)
        if capture then return capture end
    end
end

local function findName(lineT) return findCapturePattern(lineT, 'monster name%=%"([%s?%w+]*)') end
local function findArmor(lineT) return findCapturePattern(lineT, 'armor%=%"(%d+)') or 0 end
local function findDefence(lineT) return findCapturePattern(lineT, 'defense%=%"(%d+)') or 0 end

local function findRes(lineT, damType)
    local immune = findCapturePattern(lineT, 'immunity '..damType..'%=%"(%-?%d+)', "%<%/immunities%>") or 0
    if immune == 1 then return 100 end
    return findCapturePattern(lineT, 'element '..damType..'Percent%=%"(%-?%d+)', "%<%/elements%>") or 0
end

function addInfoFromFiles(fileName)
    local file = io.open(conf.xmlFolderPath.."/"..fileName, "rb")
    local text = file:read("*all")
    local lineT = textToLineT(text)
    local monsterName = findName(lineT)
    if not monsterName then return print("ERROR - Did not find monsterName from file: "..fileName) end
    if conf.tempMonstersT[monsterName] then return print("ERROR - duplicate monsterName found! "..monsterName) end
    
    conf.tempMonstersT[monsterName] = {
        armor = findArmor(lineT),
        defence = findDefence(lineT),
        physicalRes = findRes(lineT, "physical"),
        deathRes = findRes(lineT, "death"),
        holyRes = findRes(lineT, "holy"),
        energyRes = findRes(lineT, "energy"),
        earthRes = findRes(lineT, "earth"),
        iceRes = findRes(lineT, "ice"),
        fireRes = findRes(lineT, "fire"),
    }
end

local function newLine(tabAmount)
    local str = "\n"
    local tabStr = "    "
    for _ = 1, tabAmount do str = str..tabStr end
    return str
end

function createMonstersT_file()
    local toFile = io.open(conf.outputFolderPath.."/"..conf.outputFileName, "w")
    if not toFile then return print("toFile not found") end
    fileText = "monstersT = {"
    
    for monsterName, monsterT in pairs(conf.tempMonstersT) do
        fileText = fileText..newLine(1).."['"..monsterName.."'] = {"
        
        for key, value in pairs(monsterT) do
            fileText = fileText..newLine(2)..key.." = "..value..","
        end
        fileText = fileText..newLine(1).."},"
    end

    fileText = fileText..newLine(0).."}"
    toFile:write(fileText)
    toFile:close()
end