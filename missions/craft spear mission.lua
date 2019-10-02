-- mission crafting done in: data > actions > tools > iron hammer.lua (search by craftSpearMissionTracker)
local rewardExp = 10
local questSV = SV.craftSpearMission
local trackerSV = SV.craftSpearMissionTracker

mission_craftSpear = {
    questlog = {
        name = "Craft Spear Mission",
        questSV = questSV,
        trackerSV = trackerSV,
        category = "mission",
        log = {
            [0] = "Ask Bum to how to craft spear.",
            [1] = "Craft 1 Spear",
            [2] = "Let Bum know you crafted the spear",
        },
    },
    npcChat = {
        ["bum"] = {
            [26] = {
                question = "What are you doing?",
                allSV = {[questSV] = -1},
                setSV = {[questSV] = 0, [trackerSV] = 0},
                answer = "I'm crafting spears for Dundee",
            },
            [27] = {
                question = "Can I try to craft a spear",
                allSV = {[trackerSV] = 0},
                setSV = {[trackerSV] = 1},
                answer = {"sure, here take these antlers and use Iron Hammer on them.", "You can find hammer in my house."},
                rewardItems = {{itemID = 11214, count = 4}}
            },
            [28] = {
                question = "How do I craft the spear again?",
                allSV = {[trackerSV] = 1},
                answer = {"Use Iron Hammer on 4 antlers (they must be stacked)", "You can find hammer in my house."},
            },
            [29] = {
                question = "I crafted the spear!",
                allSV = {[trackerSV] = 2},
                setSV = {[trackerSV] = -1, [questSV] = 1},
                answer = "Nice! You can keep the spear",
                rewardExp = rewardExp,
            },
        },
    },
}
centralSystem_registerTable(mission_craftSpear)