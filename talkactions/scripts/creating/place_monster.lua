function onSay(player, words, param)
    if not player:isGod() then return true end
    local playerPos = player:getPosition()
    local split = param:split(",")
    local monsterName = split[1]
    local count = tonumber(split[2])
    local m

    if count then
        local area = getAreaAround(playerPos, 2)
        for _, pos in ipairs(area) do
            if count == 0 then break end
            count = count - 1
            createMonster(monsterName, pos)
        end
        m = true
    else
        m = createMonster(monsterName, playerPos)
    end
    
    if m then return false, playerPos:sendMagicEffect(CONST_ME_MAGIC_RED) end
    player:sendTextMessage(GREEN, "There is not enough room.")
    playerPos:sendMagicEffect(CONST_ME_POFF)
end
