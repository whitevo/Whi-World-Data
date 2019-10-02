npcConf_liam = {
    name = "liam",
    npcPos = {x = 424, y = 615, z = 9},
    npcShop = {
        npcName = "liam",
        allSV = {[SV.liamMission] = 1},
        items = {itemID = toolsConf.hammers[1], itemAID = AID.other.tool, cost = 25, itemText = "charges(5)", oneAtTheTime = true},
    },
    npcChat = {
        ["liam"] = {
            [82] = {
                question = "Who are you?",
                allSV = {[SV.liam1] = -1},
                setSV = {[SV.liam1] = 1},
                answer = "Me? I'm Liam.",
            },
            [83] = {
                question = "What is this place?",
                allSV = {[SV.liam1] = 1, [SV.liam4] = -1},
                setSV = {[SV.liam4] = 1},
                answer = "You are in the underground city of Hehemi, it's named after the General, Hehem.",
            },
            [84] = {
                question = "What do you know about Hehem?",
                allSV = {[SV.liam4] = 1, [SV.liam5] = -1},
                setSV = {[SV.liam5] = 1},
                answer = "He's the leader of the No-laws Army.",
            },
            [85] = {
                question = "What are you doing here?",
                allSV = {[SV.liam1] = 1, [SV.liam2] = -1},
                setSV = {[SV.liam2] = 1},
                answer = "I am trying to figure out why this orb inflicts harm when touched, as a matter of fact, would you mind helping to escort me out of here with it?",
            },
            -- ITEM INFORMATION --
            [87] = {
                msg = "Did you know your magic level increases the arcane boots damage?",
                moreItems = {{itemID = 7893, count = 1}},
            },
            [88] = {
                msg = {"Cool zvoid boots!", "I know that their damage scales with your magic proficiency level, but their power has a limit."},
                moreItems = {{itemID = 11117, count = 1}},
            },
        }
    }
}
centralSystem_registerTable(npcConf_liam)