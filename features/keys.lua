--[[ keyRing config guide
    [STR] = {               key name
        itemAID = INT           key AID
        keyID = INT             storage value for key | -1 == dont have key | 0 == has key but not used yet | 1 == key used
        keyFrom = STR           where key was found
        keyWHere = STR          where key was used
        removeKey = false       if true then removes the ley when its added to keyring
        --keyName = STR         table key
    }
]]
keyRing = {}

local features_keys = {
    startUpFunc = "keys_startUp",
    modalWindows = {
        [MW.keyChain] = {
            name = "Key Chain",
            title = "Choose a key for extra information",
            choices = "keys_createChoices",
            buttons = {[100] = "Info", [101] = "Close"},
            say = "checking keychain",
            func = "keysMW",
        },
    },
}
centralSystem_registerTable(features_keys)

function keys_startUp()
    for keyName, keyT in pairs(keyRing) do
        keyT.keyName = keyName
    end
end

function keys_createChoices(player)
    local t = {}
    local loopID = 0

	for keyName, keyT in pairs(keyRing) do
        loopID = loopID+1
		if getSV(player, keyT.keyID) ~= -1 then t[loopID] = keyName end
	end
    return t
end

function keysMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    local choiceT = keys_createChoices(player)
    local chosenKeyName = choiceT[choiceID]
    local keyT = keyRing[chosenKeyName]

    player:sendTextMessage(ORANGE, "-- "..chosenKeyName.." info --")
    player:sendTextMessage(BLUE, keyT.keyFrom)
    if getSV(player, keyT.keyID) == 1 then player:sendTextMessage(BLUE, keyT.keyWhere) end
    player:sendTextMessage(ORANGE, "-- ----- --")
    return player:createMW(mwID)
end

function keys_onUse(player, item, itemEx)
    local keyT = keys_getKeyT(item)
    if not keyT then return player:sendTextMessage(BLUE, "THIS KEY MAY BE BROKEN CONTACT GOD/GM") end
    
    if compareSV(player, keyT.keyID, "==", -1) then
        player:sendTextMessage(ORANGE, keyT.keyName.." has been added to you key collection.")
        player:say("** collected "..keyT.keyName.." **", ORANGE)
        setSV(player, keyT.keyID, 0)
        if keyT.removeKey then item:remove() end
        if keyT.checkpoint then setSV(player, SV.checkPoint, keyT.checkpoint) end
    else
        player:sendTextMessage(ORANGE, "You already have this key")
    end
    return player:sendTextMessage(GREEN, "You can see your keyring when you LOOK your character.")
end

function keys_createMW(player) return player and player:createMW(MW.keyChain) end

function keys_getKeyT(object)
    if type(object) == "userdata" then return keys_getKeyT(object:getActionId()) end
    if type(object) == "number" then
        for keyName, keyT in pairs(keyRing) do
            if keyT.itemAID == object then return keyT end
        end
    end
end

function central_register_keys(centralT)
    local keyT = centralT.keys
    if not keyT then return end
    
    for keyName, t in pairs(keyT) do
        local aid = t.itemAID
        
        if aid and not AIDItems[aid] and not centralT.AIDItems[aid] then
            central_register_actionEvent({[aid] = {funcSTR = "keys_onUse"}}, "AIDItems")
        end
        keyRing[keyName] = t
    end
end