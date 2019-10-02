function onSay(player, words, param)
    if not player:isGod() then return true end
local playerPos = player:getPosition()
local split = param:split(",")
local effect = CONST_ME_MAGIC_GREEN
local sv = split[1]
local newValue = split[2] or -1

    if not tonumber(sv) then
        sv = SV[sv]
        if not sv then return player:sendTextMessage(ORANGE, "dont have SV["..split[1].."]") end
    end
    
    setSV(player, sv, newValue)
    playerPos:sendMagicEffect(effect)
    player:sendTextMessage(ORANGE, "Storage "..split[1].." is set to "..newValue)
end