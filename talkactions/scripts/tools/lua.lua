function onSay(player, words, param)
    if not player:isGod() then return true end
    local creature = luaCreatureUserData
    local item = luaItemUserData
    local target = player:getTarget()
    
    if not item then
        if param:match("item:") or param:match("%(item") then return false, player:sendTextMessage(GREEN, "missing item object") end
    end
    if not creature then
        if param:match("c:") or param:match("%(c%,") then return false, player:sendTextMessage(GREEN, "missing creature object") end
    end
    local res, err = loadstring(param)
    
    _G["p"] = player
    _G["player"] = player
    _G["playerID"] = player:getId()
    _G["playerPos"] = player:getPosition()
    
    if target then
        _G["t"] = target
        _G["target"] = target
    end

    if creature then
        _G["m"] = creature
        _G["c"] = creature
        _G["cid"] = creature:getId()
        _G["creatureID"] = creature:getId()
        _G["pos"] = creature:getPosition()
    end
    
    if item then
        _G["item"] = item
        _G["itemPos"] = item:getPosition()
    end
    
    if not res then return false, player:sendTextMessage(BLUE, "Lua Script Error: " .. err .. ".") end
local ret, err = pcall(res)
    if not ret then return false, player:sendTextMessage(BLUE, "Lua Script Error: " .. err .. ".") end
    player:sendTextMessage(ORANGE, "Lua Script: "..param)
end