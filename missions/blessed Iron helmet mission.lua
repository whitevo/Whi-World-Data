local rewardExp = 10
local questSV = SV.blessedIronHelmetMission
local trackerSV = SV.blessedIronHelmetTracker

mission_blessedIronHelmet = {
    questlog = {
        name = "blessed iron helmet mission",
        questSV = questSV,
        trackerSV = trackerSV,
        category = "mission",
        log = {
            [0] = {"Take blessed iron helmet to Bum"},
        },
    },
    npcChat = {
        ["bum"] = {
            [193] = {
                msg = {"Wow nice helmet you have there", "If you bring me Blessed Iron Helmet too I can teach you how to smith it"},
                allSV = {[trackerSV] = -1, [questSV] = -1},
                setSV = {[trackerSV] = 0, [questSV] = 0},
                moreItems = {itemID = 9735},
            },
            [194] = {
                action = "give Blessed Iron Helmet to Bum",
                doAction = "you gave the Blessed Iron Helmet to Bum",
                answer = "Neeeet!",
                actionAnswer = "Bum teaches you how to smith Blessed Iron Helmet",
                allSV = {[trackerSV] = 0, [questSV] = 0},
                setSV = {[questSV] = 1, [trackerSV] = -1},
                moreItems = {itemID = 9735, dontCheckPlayer = true},
                removeItems = {itemID = 9735, dontCheckPlayer = true},
                rewardExp = rewardExp,
                addProfessionExp = {["smithing"] = 50},
            },
        }
    },
}
centralSystem_registerTable(mission_blessedIronHelmet)