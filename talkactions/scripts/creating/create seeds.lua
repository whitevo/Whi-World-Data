feature_god_createSeeds = {
    modalWindows = {
        [MW.god_createSeed] = {
            name = "Create Seed",
            title = "Choose seed to make",
            choices = "createSeed_choices",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
            },
            say = "creating seeds",
            func = "createSeedMW",
        },
    }
}

centralSystem_registerTable(feature_god_createSeeds)

function onSay(player, words, param)
    if not player:isGod() then return true end
    return false, player:createMW(MW.god_createSeed)
end

function createSeed_choices(player)
local choiceT = {}

	for seedAID, growT in pairs(farmingConf.growT) do
		choiceT[growT.choiceID] = growT.name
	end
    return choiceT
end

function createSeedMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local growT = farming_getGrowT(choiceID)

    player:giveItem(farmingConf.seedID, 1, growT.seedAID)
    player:getPosition():sendMagicEffect(15)
    return player:createMW(mwID)
end