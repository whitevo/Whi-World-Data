feature_god_createPotions = {
    modalWindows = {
        [MW.god_createPotion] = {
            name = "Create Potion",
            title = "Choose potion to make",
            choices = "potions_createChoices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "creating potions",
            func = "createPotionsMW",
        },
    }
}

centralSystem_registerTable(feature_god_createPotions)

function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createPotion)
end

function potions_createChoices(player)
local choiceT = {}
local loopID = 0

	for potionName, t in pairs(potions) do
        loopID = loopID+1
		choiceT[loopID] = potionName
	end
    return choiceT
end

function createPotionsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local choiceT = potions_createChoices(player)
local chosenPotionName = choiceT[choiceID]
local potT = potions[chosenPotionName]
    
    player:addItem(potT.itemID,1):setActionId(potT.itemAID)
    player:getPosition():sendMagicEffect(15)
    return player:createMW(mwID)
end