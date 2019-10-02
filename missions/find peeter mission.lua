local missionConf = {
    rewardExp = 5,
}

mission_findPeeter = {
    questlog = {
        name = "Find Peeter mission",
        questSV = SV.findPeeterMission,
        trackerSV = SV.findPeeterTracker,
        category = "mission",
        log = {
            [0] = "Find Bandit Mountain",
            [1] = "Find Peeter in Bandit Mountains",
        },
        hintLog = {
            [0] = {
                [SV.findPeeterHint1] = "Dundee told you that Bandit Mountain is to the west from north forest",
            },
            [1] = {
                [SV.findPeeterHint2] = "Niine told you that Peeter can be seen on Bandit Mountain from the small camp below the mountain",
            },
        }
    },
    npcChat = {
        ["eather"] = {
            [197] = {
                msg = {"I have now given you the essential items to survive", "You should go find Peeter and Tonka and see if they need any help"},
                allSV = {[SV.wolfMission] = 1, [SV.boarMission] = 1, [SV.bearMission] = 1, [SV.findPeeterMission] = -1},
                setSV = {[SV.findPeeterMission] = 0, [SV.findPeeterTracker] = 0, [SV.findTonkaMission] = 0, [SV.findTonkaTracker] = 0},
            },
        },
        ["niine"] = {
            [198] = {
                question = "Do you know where is Peeter?",
                answer = "His on the Bandit Mountain. You can see him from the camp below the mountain.",
                allSV = {[SV.findPeeterHint2] = -1, [SV.findPeeterMission] = 0},
                setSV = {[SV.findPeeterHint2] = 1},
            },
        },
        ["dundee"] = {
            [199] = {
                question = "Do you know where is Peeter?",
                answer = "Somewhere in Bandit Mountain which is the big mountain on the west",
                allSV = {[SV.findPeeterHint1] = -1, [SV.findPeeterMission] = 0},
                setSV = {[SV.findPeeterHint1] = 1},
            },
        },
        ["peeter"] = {
            [200] = {
                msg = "You were looking for me?",
                doAction = "You found Peeter and completed Find Peeter mission.",
                allSV = {[SV.findPeeterMission] = 0},
                setSV = {[SV.findPeeterMission] = 1},
                rewardExp = missionConf.rewardExp,
            },
        },
        
    },
}
centralSystem_registerTable(mission_findPeeter)