function onSay(player, words, param)
    if not player:isGod() then return true end
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
    
    setSV(target, sv, split[3])
    playerPos:sendMagicEffect(effect)
    player:sendTextMessage(ORANGE, target:getName().." SV["..split[2].."] is set to "..split[3])
end
