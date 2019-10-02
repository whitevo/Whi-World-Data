local spamMap = {} -- [playerID] = {startTime = os.time(), msgAmount = INT}

function onSpeak(player, type, message)
	local playerAccountType = player:getAccountType()
	if player:getLevel() < 3 and playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
		return false, player:sendTextMessage(GREEN, "You may not speak into channels as long as you are not level 3+.")
	end
	
	local currentTime = os.time()
	if currentTime < player:getStorageValue(11901) then return false, player:sendTextMessage(GREEN, "You are still muted from world chat") end
	local playerID = player:getId()
	local spamT = spamMap[playerID]
    
    if not spamT then
        spamMap[playerID] = {startTime = currentTime, msgAmount = 0}
        spamT = spamMap[playerID]
    end
local spamAmount = spamT.msgAmount
    
    if spamAmount > 4 then
        if spamT.startTime + 5 > currentTime then
            player:setStorageValue(11901, currentTime + 60)
            return false, player:sendTextMessage(GREEN, "You have been muted for 1 minute for spamming world chat")
        else
            spamT.msgAmount = 0
            spamT.startTime = currentTime
        end
    else
        spamT.msgAmount = spamAmount + 1
    end
    
	if type == TALKTYPE_CHANNEL_Y then
		if playerAccountType >= ACCOUNT_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_O
		end
	elseif type == TALKTYPE_CHANNEL_O then
		if playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and not getPlayerFlagValue(player, PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	return type
end
