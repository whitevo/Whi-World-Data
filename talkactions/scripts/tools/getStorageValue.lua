function onSay(player, words, param)
local sv = param
    
    if not tonumber(sv) then
        sv = SV[sv]
        if not sv then return player:sendTextMessage(ORANGE, "dont have SV["..param.."]") end
    end
    
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    player:sendTextMessage(ORANGE, "Storage "..param.." has value "..getSV(player, sv))
end