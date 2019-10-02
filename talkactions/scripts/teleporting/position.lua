function onSay(player, words, param)
    if not player:isGod() then return end
    local xPos
    local yPos
    local zPos

    if not param:match("{") then
        local split = param:split(",")
        xPos = split[1] or "ERROR"
        yPos = split[2] or "ERROR"
        zPos = split[3] or "ERROR"
    else
        tempX = param:match("x = %d*")
        xPos = tempX:match("%d+") or "ERROR"
        tempY = param:match("y = %d*")
        yPos = tempY:match("%d+") or "ERROR"
        tempZ = param:match("z = %d*")
        zPos = tempZ:match("%d+") or "ERROR"
    end
    
    local position = {x=tonumber(xPos), y=tonumber(yPos), z=tonumber(zPos)}

    if not Tile(position) then return false, player:sendTextMessage(GREEN, "position {x="..xPos..", y="..yPos..", z="..zPos.."} does not exist") end
    return false, teleport(player, position)
end
