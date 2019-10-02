-- buffDisplay is in "show ongoing buffs.lua"
local pullInEffect = {
    {n, n, 1, n, n},
    {n, 1, 2, 1, n},
    {1, 2, 0, 2, 1},
    {n, 1, 2, 1, n},
    {n, n, 1, n, n},
}

function buffSpell(playerID, spellT)
    local player = Player(playerID)
    
    if not player then return end
    if not spellT then spellT = spells_getSpellT("buff") end
    
    local buffAmount, duration = spells_getFormulas(player, spellT)
    local playerPos = player:getPosition()
    local areaT = getAreaPos(playerPos, pullInEffect)
    
    if not bianhurenActivate(player, buffAmount, duration) then
        buffPlayer(player, buffAmount, duration)
        gribitShield(player, buffAmount, duration, areaT)
    end
    
    for i, posT in pairs(areaT) do
        local delay = (i-1)*500
        for _, pos in pairs(posT) do addEvent(doSendMagicEffect, delay, pos, 46) end
    end
    addEvent(doSendMagicEffect, 1200, playerPos, 55)
end

function buffPlayer(player, buffAmount, duration)
    local playerID = player:getId()
    local buffPercent = getSV(player, SV.buffSpell)
    
    if buffPercent < buffAmount then
        player:sendTextMessage(ORANGE, "your are buffed "..buffAmount.."% for "..getTimeText(duration))
        setSV(player, SV.buffSpell, buffAmount)
    else
        player:sendTextMessage(ORANGE, "Previous "..buffPercent.."% buff duration has been reset, it lasts "..getTimeText(duration).." again.")
    end

    player:sendTextMessage(ORANGE, "This buff gives overall damage reduction.")
    stopAddEvent(playerID, "druidBuff")
    registerAddEvent(playerID, "druidBuff", duration*1000, {removeSV, playerID, SV.buffSpell})
end

function druidBuffSpell(player, damage, damType)
    local buff = getSV(player, SV.buffSpell)
    if buff < 1 then return 0 end
    return percentage(damage, buff)
end