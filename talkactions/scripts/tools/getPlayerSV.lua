function onSay(player, words, param)
local playerPos = player:getPosition()
local split = param:split(",")
local effect = CONST_ME_MAGIC_GREEN
    if tonumber(split[1]) then return player:sendTextMessage(GREEN, "can't fucking do that!") end
local target = Player(split[1])
local sv = split[2]

    if not tonumber(sv) then
        sv = SV[sv]
        if not sv then return player:sendTextMessage(ORANGE, "dont have SV["..split[2].."]") end
    end
    
    playerPos:sendMagicEffect(effect)
    player:sendTextMessage(ORANGE, target:getName().." storage "..split[2].." has value "..getSV(target, sv))
end
