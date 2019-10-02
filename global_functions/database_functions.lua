function createQueryStr(tableName, command, table)
    if not table then return error("ERROR in createQueryStr() - missing table") end
    command = command:lower()

    if command == "insert" then
        local queryStart = "INSERT INTO `"..tableName.."`"
        local paramListStr
        local valueListStr

        for k, v in pairs(table) do
            local listValue = "`"..k.."`"
            if not paramListStr then paramListStr = listValue else paramListStr = paramListStr..", "..listValue end
        end
        
        for k, v in pairs(table) do
            local listValue = type(v) == "number" and v or "'"..tostring(v).."'"
            if not valueListStr then valueListStr = listValue else valueListStr = valueListStr..", "..listValue end
        end
        return queryStart.."("..paramListStr..") VALUES ("..valueListStr..")"
    elseif command == "create" then
        local queryStart = "CREATE TABLE `"..tableName.."`"
        local primaryKey = ""
        local paramListStr
        
        for k, v in pairs(table) do
            local listKey = "`"..k.."`"
            local fullValue = listKey.." "..v

            if v:match("AUTO_INCREMENT") then primaryKey = ", PRIMARY KEY ("..listKey..")" end
            if not paramListStr then paramListStr = fullValue else paramListStr = paramListStr..", "..fullValue end
        end
        return queryStart.."("..paramListStr..primaryKey..") ENGINE = InnoDB;"
    end
    print("ERROR in createQueryStr() - no such command ["..command.."]")
end

function DBNumberResultReader(data, keyword, deleteQuery)
    if not data then return 0 end
    local value = result.getNumber(data, keyword)
        
    value = tonumber(value) or 0
    if deleteQuery then result.free(data) end
    return value
end

function getPlayerNameByGUID(guid)
    local playerData = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = " .. guid)

    if playerData then
        local value = result.getString(playerData, "name")
        result.free(playerData)
        return value
    end
    return "no_name: "..guid
end

function getPlayerVocByGUID(guid)
    local playerData = db.storeQuery("SELECT `vocation` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "vocation", true)
end

function getPlayerLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `level` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "level", true)
end

function getPlayerMagicLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `maglevel` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "maglevel", true)
end

function getPlayerShieldLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `skill_shielding` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_shielding", true)
end

function getPlayerSwordLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `skill_sword` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_sword", true)
end

function getPlayerDistanceLevelByGUID(guid)
local playerData = db.storeQuery("SELECT `skill_dist` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_dist", true)
end

function getPlayerFistLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `skill_fist` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_fist", true)
end

function getPlayerClubLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `skill_club` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_club", true)
end

function getPlayerAxeLevelByGUID(guid)
    local playerData = db.storeQuery("SELECT `skill_axe` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "skill_axe", true)
end

function getPlayerMaxHPByGUID(guid)
    local playerData = db.storeQuery("SELECT `healthmax` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "healthmax", true)
end

function getPlayerMaxMPByGUID(guid)
    local playerData = db.storeQuery("SELECT `manamax` FROM `players` WHERE `id` = " .. guid)
    return DBNumberResultReader(playerData, "manamax", true)
end

function getPlayerDeathTimeByGUID(guid)
    local lastDeath = db.storeQuery("SELECT `time` FROM `player_deaths` WHERE `player_id` = " .. guid .. " ORDER BY `time` DESC")
    return DBNumberResultReader(lastDeath, "time", true)
end

function getGuidTByAccID(accountID)
    local playerData = db.storeQuery("SELECT `id` FROM `players` WHERE `account_id` = "..accountID)
    local playerGUIDT = {}
        
    if not playerData then return {} end
    repeat
        local guid = result.getNumber(playerData, "id")
        table.insert(playerGUIDT, guid)
    until not result.next(playerData)
    result.free(playerData)
    return playerGUIDT
end

function getAccountIDByGuid(playerGuid)
    local playerData = db.storeQuery("SELECT `account_id` FROM `players` WHERE `id` = "..playerGuid)
    if not playerData then return end
    local accountID = result.getNumber(playerData, "account_id")

    result.free(playerData)
    return accountID
end

function getGuildIdByName(guildName)
    local temp = db.storeQuery("SELECT `id` FROM `guilds` WHERE `name` = '"..guildName.."'")
    local ID = result.getNumber(temp, "id")
        
    return ID and ID > 0 and ID
end

function getGuildLeaderByName(guildName)
    local temp = db.storeQuery("SELECT `ownerid` FROM `guilds` WHERE `name` = '"..guildName.."'")
    local playerGuid = result.getNumber(temp, "ownerid")

    return playerGuid and getPlayerNameByGUID(playerGuid)
end

function getHigestLevelChar(player)
    local accID = player:getAccountId()
    local playerData = db.storeQuery("SELECT `level` FROM `players` WHERE `account_id` = " .. accID)
    local highestLevel = 0

    repeat
        local level = result.getNumber(playerData, "level")
        if level > highestLevel then highestLevel = level end
    until not result.next(playerData)
    
    result.free(playerData)
    return highestLevel
end

function db_getGuildNames()
    local guildNameData = db.storeQuery("SELECT `name` FROM `guilds`")
    local guildList = {}
    
    repeat
        local guildName = result.getString(guildNameData, "name")
        table.insert(guildList, guildName)
    until not result.next(guildNameData)

    result.free(guildNameData)
    return guildList
end