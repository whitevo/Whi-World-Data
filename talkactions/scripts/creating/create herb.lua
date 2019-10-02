feature_god_createHerbs = {
    modalWindows = {
        [MW.god_createHerb] = {
            name = "Create Herb",
            title = "Choose herb to make 5 of them",
            choices = "herbs_createChoices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "creating herbs",
            func = "createHerbsMW",
        },
    }
}

centralSystem_registerTable(feature_god_createHerbs)

function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createHerb)
end

function herbs_createChoices(player)
local choiceT = {}
local loopID = 0

	for herbAID, herbT in pairs(herbs) do
        loopID = loopID+1
		choiceT[loopID] = herbT.name
	end
    return choiceT
end

function createHerbsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local choiceT = herbs_createChoices(player)
local chosenHerbName = choiceT[choiceID]
local herbT = herbs_getHerbT(chosenHerbName)

    herbs_createHerbPowder(player, herbT, 20, true)
    player:getPosition():sendMagicEffect(15)
    return player:createMW(mwID)
end