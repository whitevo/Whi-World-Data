npcConf_peeter = {
    name = "peeter",
    npcPos = {x = 502, y = 587, z = 6},
    npcArea = {upCorner = {x = 499, y = 585, z = 6}, downCorner = {x = 504, y = 588, z = 6}},
    npcShop = {
        [1] = {
            npcName = "peeter",
            allSV = {[SV.blueClothMission] = 1},
            items = {
                {itemID = 5912, sell = 1},
                {itemID = 2456, sell = 18, maxStock = 3, genStockSecTime = 60*60},
            }
        },
        [2] = {
            npcName = "peeter",
            allSV = {[SV.brownClothMission] = 1},
            items = {
                {itemID = 5913, sell = 1},
                {itemID = 2190, sell = 18, maxStock = 3, genStockSecTime = 60*60},
            }
        },
        [3] = {
            npcName = "peeter",
            allSV = {[SV.redClothMission] = 1},
            items = {
                {itemID = 5911, sell = 1},
                {itemID = 2183, sell = 18, maxStock = 3, genStockSecTime = 60*60},
            }
        },
        [4] = {
            npcName = "peeter",
            allSV = {[SV.whiteClothMission] = 1},
            items = {
                {itemID = 5909, sell = 1},
                {itemID = 2380, sell = 18, maxStock = 3, genStockSecTime = 60*60},
                {itemID = 2398, sell = 18, maxStock = 3, genStockSecTime = 60*60},
            }
        },
        [5] = {
            npcName = "peeter",
            allSV = {[SV.campfireMission] = 1},
            items = {
                {itemID = 2544, cost = 1, baseStock = 100},
                {itemID = 2467, sell = 3, maxStock = 2, genStockSecTime = 10*60},
                {itemID = 2461, sell = 3, maxStock = 2, genStockSecTime = 10*60},
                {itemID = 2649, sell = 3, maxStock = 2, genStockSecTime = 10*60},
                {itemID = 2643, sell = 30, maxStock = 1, genStockSecTime = 60*60},
            }
        },
        [6] = {
            npcName = "peeter",
            allSV = {[SV.archanosKill] = 1},
            items = {itemID = toolsConf.saws[1], itemAID = AID.other.tool, cost = 30, itemText = "charges(5)", oneAtTheTime = true}
        },
    },
    npcChat = {
        ["peeter"] = {
            [93] = {
                question = "Who are you?",
                allSV = {[SV.peeter1] = -1},
                setSV = {[SV.peeter1] = 1},
                answer = "Hello, I am Peeter.",
            },
            [94] = {
                question = "What do you do?",
                allSV = {[SV.peeter1] = 1, [SV.peeter2] = -1},
                setSV = {[SV.peeter2] = 1},
                answer = "I keep an eye out for these bandits so they don't cut the Naaru forest down, or the Forgotten Village for that matter...",
            },
            [95] = {
                question = "What is this place?",
                allSV = {[SV.peeter2] = 1, [SV.peeter4] = -1},
                setSV = {[SV.peeter4] = 1},
                answer = "This place is called the Strangham Mountain, also known as Bandit Mountain.",
            },
            [96] = {
                question = "Why is it called Bandit Mountain?",
                allSV = {[SV.peeter4] = 1, [SV.peeter5] = -1},
                setSV = {[SV.peeter5] = 1},
                answer = "Because, as you can see, there's a shitload of bandits here.",
            },
            [97] = {
                question = "Why are the bandits here?",
                allSV = {[SV.peeter5] = 1, [SV.peeter6] = -1},
                setSV = {[SV.peeter6] = 1},
                answer = {
                    "The bandits were once the soldiers of Naaru, but after the Undead army invaded, they escaped to this mountain.",
                    "Now they work under Hehem and his 2 brothers: Archanos and Borthonos."
                },
            },
            [98] = {
                question = "What do you know about the Forgotten Village?",
                allSV = {[SV.smith6] = 1, [SV.cook6] = 1, [SV.priest6] = 1, [SV.tanner6] = 1, [SV.task_master6] = 1, [SV.peeter7] = -1},
                setSV = {[SV.peeter7] = 1},
                answer = {
                    "I know that Hehem was the General of the capital, Naaru.",
                    "But after the sudden attack of the Undead army, he and his soldiers were left crushed.",
                    "He's like a king here now, and his law is the so called No-Law.",
                    "They're called bandits for a reason."
                },
            },
        },
    },
    AIDTiles_stepIn = {
        [AID.other.peeterPushTile] = {funcSTR = "peeter_blockTileStepIn"}
    }
}
centralSystem_registerTable(npcConf_peeter)

function peeter_blockTileStepIn(creature, tile, _, fromPos, toPos)
    if creature:getName():lower() == "peeter" then return teleport(creature, fromPos) end
end