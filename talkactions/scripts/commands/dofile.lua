local function isShortGlobalFile(param)
    local letterT = stringToLetterT(param)
    return letterT[#letterT] == "_"
end

function onSay(player, words, param)
    if not player:isGod() then return end
    if param:match("%.lua") then param = param:gsub("%.lua", "") end
    if isShortGlobalFile(param) then param = param.."functions" end
    
    local function canRename(name)
        if type(name) ~= "string" then return false end
        return os.rename(name, name) and true or false
    end

    local function executeDofile(dir)
        if not canRename(dir) then return end
        dofile(dir)
        return player:sendTextMessage(BLUE, param..".lua successfully loaded")
    end

    for _, folderName in ipairs(featureFolders) do
        if executeDofile("data/features/"..folderName.."/"..param..".lua") then return end
    end
    
    if executeDofile("data/games/"..param..".lua") then return end
    if executeDofile("data/features/"..param..".lua") then return end
    if executeDofile("data/items/"..param..".lua") then return end
    if executeDofile("data/game_systems/"..param..".lua") then return end
    if executeDofile("data/global_functions/"..param..".lua") then return end
    if executeDofile("data/spells/druid/"..param..".lua") then return end
    if executeDofile("data/spells/hunter/"..param..".lua") then return end
    if executeDofile("data/spells/knight/"..param..".lua") then return end
    if executeDofile("data/spells/mage/"..param..".lua") then return end
    if param:match("data/") and executeDofile(param..".lua") then return end
    player:sendTextMessage(BLUE, param..".lua does not exist in features-, spells nor global functions folder")
end
