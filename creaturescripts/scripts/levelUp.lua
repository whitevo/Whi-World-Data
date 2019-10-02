function onAdvance(player, skill, oldLevel, newLevel)
    if newLevel < 3 then return end
    local payerPos = player:getPosition()
    local area = getAreaPos(player:getPosition(), areas["inwards_explosion_3x3"])
    local delay = 300

    addSV(player, SV.skillpoints, 1)
    player:sendTextMessage(ORANGE, "you earned 1 skillpoint!")
    
    for i, posT in pairs(area) do
        for _, pos in pairs(posT) do addEvent(doSendMagicEffect, delay*i, pos, 25) end
    end
    addEvent(doSendMagicEffect, delay*tableCount(area), payerPos, 38)
end

