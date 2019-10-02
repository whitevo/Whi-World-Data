-- mission started on "find peeter mission.lua"
local missionConf = {
    rewardExp = 5,
}

mission_findTonka = {
    questlog = {
        name = "Find Tonka mission",
        questSV = SV.findTonkaMission,
        trackerSV = SV.findTonkaTracker,
        category = "mission",
        log = {
            [0] = "Find Tonka near Cyclops Mountains",
        },
        hintLog = {
            [0] = {
                [SV.findTonkaHint1] = "Dundee told you that Cyclops Mountain is to the east from north forest",
                [SV.findTonkaHint2] = "Bum told you can that Cyclops Mountain is straight to north from ocean line.",
            },
        }
    },
    npcChat = {
        ["bum"] = {
            [201] = {
                question = "Do you know where is Tonka?",
                answer = "His near the Cyclops Mountain. Just walk to the ocean from here and then keep walking north to find the mountains.",
                allSV = {[SV.findTonkaHint2] = -1, [SV.findTonkaMission] = 0},
                setSV = {[SV.findTonkaHint2] = 1},
            },
        },
        ["dundee"] = {
            [202] = {
                question = "Do you know where is Tonka?",
                answer = "Somewhere near Cyclops Mountain which is are small mountains on the east",
                allSV = {[SV.findTonkaHint2] = -1, [SV.findTonkaMission] = 0},
                setSV = {[SV.findTonkaHint2] = 1},
            },
        },
        ["tonka"] = {
            [203] = {
                msg = "You were looking for me?",
                doAction = "You found Tonka and completed Find Tonka mission.",
                allSV = {[SV.findTonkaMission] = 0},
                setSV = {[SV.findTonkaMission] = 1},
                rewardExp = missionConf.rewardExp,
            },
        },
        
    },
}
centralSystem_registerTable(mission_findTonka)