feature_god_createGems = {
    modalWindows = {
        [MW.god_createGems] = {
            name = "Create Gems",
            title = "Choose gem to make 5 of them",
            choices = "god_createGemsMW_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "creating gems",
            func = "god_createGemsMW",
        },
    }
}

centralSystem_registerTable(feature_god_createGems)
    
function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createGems)
end

function god_createGemsMW_choices(player)
    local choiceT = {}
    local loopID = 0

	for gemID, gemT in pairs(gems) do
        loopID = loopID+1
		choiceT[loopID] = gemT.eleType.." gem"
	end

    for gemID, gemT in pairs(gems2Conf.gems) do
        loopID = loopID+1
		choiceT[loopID] = gemT.name
    end
    return choiceT
end

function god_createGemsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    local choiceT = god_createGemsMW_choices(player)
    local gemName = choiceT[choiceID]
    local gems = player:addItem(gemName, 5)

    if not gems then
        local gemT = gems2_getGemT(gemName)
        player:addItem(gemT.gemID, 1)
    end
    player:getPosition():sendMagicEffect(15)
    return player:createMW(mwID)
end