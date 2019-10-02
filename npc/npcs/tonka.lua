npcConf_tonka = {
    name = "tonka",
    npcPos = {x = 641, y = 575, z = 7},
    npcShop = {
        [1] = {
            npcName = "tonka",
            items = {
                {itemID = 1294, sell = 2, maxStock = 10, genStockSecTime = 2*60},
            }
        },
        [2] = {
            npcName = "tonka",
            allSV = {[SV.smallStonesMission] = 1},
            items = {
                {itemID = 2663, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 2662, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 12434, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 3983, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 11304, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 15409, sell = 15, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 7457, sell = 25, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 7464, sell = 8, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 7458, sell = 8, maxStock = 2, genStockSecTime = 60*60},
                {itemID = 7463, sell = 8, maxStock = 2, genStockSecTime = 60*60},
            }
        },
        [3] = {
            npcName = "tonka",
            allSV = {[SV.bigDaddyKill] = 1},
            items = {itemID = toolsConf.pickaxes[1], itemAID = AID.other.tool, cost = 30, itemText = "charges(5)", oneAtTheTime = true},
        }
    },
    npcChat = {
        ["tonka"] = {
            [115] = {
                question = "Who are you?",
                allSV = {[SV.tonka1] = -1},
                setSV = {[SV.tonka1] = 1},
                answer = "I am Tonka, I make sure that the cyclopes don't come out to the forest.",
            },
            [116] = {
                question = "Are you here alone?!",
                allSV = {[SV.tonka1] = 1, [SV.tonka2] = -1},
                setSV = {[SV.tonka2] = 1},
                answer = "Don't worry about me, I can handle these big stupid creatures juuust fine.",
            },
            [117] = {
                question = "But still... do you need any help?",
                allSV = {[SV.tonka2] = 1, [SV.tonka3] = -1},
                setSV = {[SV.tonka3] = 1, [SV.smallStonesMission] = 0},
                answer = {"Well, I'm collecting small stones that the cyclopes drop.","You could always get me more of those."},
            },
            [118] = {
                question = "What is this place?",
                allSV = {[SV.tonka3] = 1, [SV.tonka4] = -1},
                setSV = {[SV.tonka4] = 1},
                answer = "You are in the Naaru Forest, and this mountain is called the Cyclops mountain.",
            },
            [119] = {
                question = "Does it mean cyclopes live on this mountain?",
                allSV = {[SV.tonka4] = 1, [SV.tonka5] = -1},
                setSV = {[SV.tonka5] = 1},
                answer = {"Yes, yes it does.","You can get inside the Cyclops cave through the mountain, most of the cyclops reside there."},
            },
            [120] = {
                question = "Any clues on how to fight them?",
                allSV = {[SV.tonka5] = 1, [SV.tonka6] = -1},
                setSV = {[SV.tonka6] = 1},
                answer = "The key is to not stand too far from them, but staying too close is dangerous too.",
            },
            [121] = {
                question = "What do you know about the Forgotten Village?",
                allSV = {[SV.tonka6] = 1, [SV.smith6] = 1, [SV.cook6] = 1, [SV.priest6] = 1, [SV.tanner6] = 1, [SV.task_master6] = 1, [SV.tonka7] = -1},
                setSV = {[SV.tonka7] = 1},
                answer = {
                    "I was one of the Elite. Not that it means anything now.",
                    "One of my order went mad after his daughter's death and started practicing black magic to bring her back.",
                    "Eventually he lost his mind and thousands of undead attacked the capital under his command."
                },
            },
            -- OTHER --
            [122] = {
                msg = "You have a good shield, you know the more defense you have, the easier it is to activate it's effect?",
                moreItems = {{itemID = 15491, count = 1}},
            },
            [123] = {
                question = "Anything cool we can do around here?",
                allSV = {[SV.tonka7] = 1, [SV.tonka8] = -1},
                setSV = {[SV.tonka8] = 1},
                answer = {"Yeah, I can take you to the 'speedball' minigame. Minigame rewards are vocation based potion herbs."},
            },
            [124] = {
                question = "Can you help me to make a potion?",
                allSV = {[SV.tonkaHerbs] = 1, [SV.tonka9] = -1},
                setSV = {[SV.tonka9] = 1},
                answer = {"Not really, but if you bring me a herb powder, I can help you identify it."},
            },
        },
    },
    AIDTiles_stepOut = {
        [AID.other.tonkaHoldTile] = {funcSTR = "tonka_hold"},
    },
}
centralSystem_registerTable(npcConf_tonka)

function tonka_minigameButton(player, npcName) return player:teleportTo({x = 667, y = 600, z = 8}, true) end

function tonka_hold(creature, item)
    if not creature:isNpc() then return end
    bindCondition(creature, "monsterSlow", -1, {speed = -creature:getSpeed()})
    teleport(creature, item:getPosition(), false, "S")
end

function tonka_loadTasks()
    local allNpcT = {dundee = {}}
    local npcT = allNpcT.dundee
    local loopID = 0

    local function registerTask(taskT, monsterName)
        if not taskT then return end
        local allSVT = taskT.requiredSV or {}
        allSVT[taskT.storageID2] = 1
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = "Need help with any more tasks?",
            allSV = allSVT,
            bigSVF = {[taskT.storageID] = 0},
            anySVF = {[taskT.storageID] = -2},
            setSV = {[taskT.storageID] = 0},
            answer = taskT.answer,
        }
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = "Where can I find "..monsterName,
            bigSV = {[taskT.storageID] = 0},
            bigSVF = {[taskT.storageID] = taskT.killsRequired},
            answer = monsterName.." can be found in "..taskT.location,
        }
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = "I have completed "..monsterName.." task",
            allSV = {[taskT.storageID2] = 1},
            bigSV = {[taskT.storageID] = taskT.killsRequired},
            setSV = {[taskT.storageID] = -2},
            addRep = {["dundee"] = taskT.reputation},
            answer = taskT.msg,
        }
    end
    
    for monsterName, t in pairs(monsters) do registerTask(t.task, monsterName) end
    central_register_npcChat(allNpcT)
end