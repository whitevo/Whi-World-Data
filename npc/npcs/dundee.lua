npcConf_dundee = {
    name = "dundee",
    npcPos = {x = 567, y = 663, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    startUpFunc = "tonka_loadTasks", -- Why tonka tasks= you mean dundee??
    npcShop = {
        allSV = {[SV.campfireMission] = 1},
        npcName = "dundee",
        items = {
            {itemID = 2544, cost = 1, baseStock = 100},
            {itemID = 2467, sell = 4, maxStock = 2, genStockSecTime = 10*60},
            {itemID = 2461, sell = 4, maxStock = 2, genStockSecTime = 10*60},
            {itemID = 2649, sell = 4, maxStock = 2, genStockSecTime = 10*60},
            {itemID = 2643, sell = 4, maxStock = 2, genStockSecTime = 10*60},
        },
    },
    npcChat = {
        ["dundee"] = {
            [34] = {
                question = "Who are you?",
                allSV = {[SV.task_master1] = -1},
                setSV = {[SV.task_master1] = 1},
                answer = "I'm Dundee, the task master.",
            },
            [35] = {
                question = "What do you do?",
                allSV = {[SV.task_master1] = 1, [SV.task_master2] = -1},
                setSV = {[SV.task_master2] = 1},
                answer = {
                    "I put my skills as a hunter to use and gather meat for Alice, the cook.",
                    "I also help to protect this town from any ...unwanted visitors."
                },
            },
            [36] = {
                question = "Can I help you with something?",
                allSV = {[SV.task_master2] = 1, [SV.task_master3] = -1},
                setSV = {[SV.deerTask] = 0, [SV.wolfTask] = 0, [SV.boarTask] = 0, [SV.bearTask] = 0, [SV.task_master3] = 1},
                answer = {
                    "As a matter of fact you can.",
                    "There has been too much animal activity at night lately and they keep invading our food supply.",
                    "You could help to scare them off by killing as many as possible."
                },
            },
            [37] = {
                question = "What is this place?",
                allSV = {[SV.task_master2] = 1, [SV.task_master4] = -1},
                setSV = {[SV.task_master4] = 1},
                answer = {
                    "Welcome to the capital city of Naaru, well ...at least what's left of it.",
                    "Now this place is known as the Forgotten village."
                },
            },
            [38] = {
                question = "What happened here?",
                allSV = {[SV.task_master4] = 1, [SV.task_master5] = -1},
                setSV = {[SV.task_master5] = 1},
                answer = {
                    "Where the fuck did you crawl out of?!",
                    "This is where it all started, 5 long years ago."
                },
            },
            [39] = {
                question = "What started 5 years ago?",
                allSV = {[SV.task_master5] = 1, [SV.task_master6] = -1},
                setSV = {[SV.task_master6] = 1},
                answer = {
                    "You seriously don't know?",
                    "It was the first city the Undead army destroyed.",
                },
            },
            [40] = {
                question = "What is the Undead army?",
                allSV = {[SV.task_master6] = 1, [SV.task_master7] = -1},
                setSV = {[SV.task_master7] = 1},
                answer = "Exactly what it sounds like, idiot.",
            },
            [41] = {
                question = "Where are they now?",
                allSV = {[SV.task_master5] = 1, [SV.task_master8] = -1},
                setSV = {[SV.task_master8] = 1},
                answer = {
                    "They left somewhere north-west, but...",
                    "...the part north of the Forgotten village is still plagued by the undead.",
                    "But know this, you can't kill what is already dead.",
                    "If you are unlucky enough to meet one, run for your life or grind them down to dust!",
                },
            },
            -- collecting missions
            [42] = {
                msg = "You have grown strong. Could you find me some fur boots and thick fur.",
                bigSV = {[SV.taskerRepL] = 1},
                bigSVF = {[SV.furBagMission] = 0},
                setSV = {[SV.furBagMission] = 0},
            },
            [43] = {
                question = "Anything new and challenging to offer?",
                allSV = {[SV.furBagMission] = 1},
                bigSV = {[SV.taskerRepL] = 2},
                bigSVF = {[SV.furBackpackMission] = 0},
                setSV = {[SV.furBackpackMission] = 0},
                answer = "Well not really, but I do need loads of paws, in return I'll give you a fancy fur backpack.",
            },
        }
    }
}
centralSystem_registerTable(npcConf_dundee)

function dundee_repOnDeath(player, monsterT)
    local repLevel = player:getRepL("dundee")
    local monsterRep = monsterT.reputationPoints or 0
    local newRep = monsterRep - repLevel

    if newRep <= 0 then return end
    addRep(player, newRep, "dundee")
end

function dundee_taskOnDeath(player, monsterT)
    local taskT = monsterT.task
    if not taskT then return end
    local monstersKilled = getSV(player, taskT.storageID)
    local killsRequired = taskT.killsRequired
    local taskCompletedOnce = getSV(player, taskT.storageID2) == 1

    if not taskCompletedOnce and monstersKilled < 0 then
        setSV(player, taskT.storageID, 0)
        monstersKilled = 0
    end
    if monstersKilled < 0 or monstersKilled >= killsRequired then return end
    local monsterName = monsterT.name
    local killCount = monstersKilled + 1

    addSV(player, taskT.storageID, 1)
    
    if not taskCompletedOnce then
        if killCount ~= killsRequired then return player:sendTextMessage(ORANGE, "You are getting more skilled by killing "..monsterName, 60*1000*5) end
        addRep(player, taskT.reputation, "dundee")
        player:sendTextMessage(ORANGE, "You earned "..plural("skillpoint", taskT.skillPoints))
        addSV(player, SV.skillpoints, taskT.skillPoints)
        setSV(player, {[taskT.storageID2] = 1, [taskT.storageID] = -2})
    else
        if killCount == killsRequired then return player:sendTextMessage(ORANGE, "You completed the "..monsterName.."s task. Return to Dundee.") end
        player:sendTextMessage(ORANGE, "Task message: "..killCount.." of "..killsRequired.." "..monsterName.."'s killed.")
    end
end