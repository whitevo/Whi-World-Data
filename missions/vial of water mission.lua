local rewardExp = 20
local questSV = SV.vialOfWaterMission
local trackerSV = SV.vialOfWaterTracker

mission_vialOfWater = {
    questlog = {
        name = "Vial of Water Mission",
        questSV = questSV,
        trackerSV = trackerSV,
        category = "mission",
        log = {
            [0] = {
                "Create vial of water and take it to Alice.",
                "You can buy empty vial from Alice",
                "Ocean to fill the vial can be found from East of Forgotten Village",
            },
            [1] = "Take vial of water to Alice",
        },
    },
    npcChat = {
        ["alice"] = {
            [14] = {
                question = "need any kind of help from me?",
                allSV = {[questSV] = -1},
                setSV = {[questSV] = 0, [trackerSV] = 0},
                answer = "You seem to have some hope. Make me 1 vial of water.",
            },
            [15] = {
                question = "I have created vial of water",
                allSV = {[trackerSV] = 1},
                moreItems = {{itemID = 2006, type = 1}},
                removeItems = {{itemID = 2006, type = 1}},
                setSV = {[questSV] = 1, [trackerSV] = -1},
                rewardExp = rewardExp,
                answer = "Nicely done my sweet customer",
                actionAnswer = "Vial of Water Mission Completed",
            },
        }
    },
}
centralSystem_registerTable(mission_vialOfWater)
-- vial fill function in Actions > cooking and brewing > food system.lua

function vialOfWaterMission_fillVial(player, fluidSource)
    if getSV(player, trackerSV) == 0 and fluidSource == 1 then setSV(player, trackerSV, 1) end
end