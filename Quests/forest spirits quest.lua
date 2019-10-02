-- in fluids.lua blood function is activated
local startQuestText1 = "There's some kind of writing carved into the forest statue."
local startQuestText2 = "'Pour some blood on my dead children so they can leave this world as true wild animals.'"
local startQuestText3 = "Quest discovered. You earned 1 skillpoint"
local statueText = {type = ORANGE, msg = {startQuestText3, startQuestText1, startQuestText2}}
local statueTextF = {type = ORANGE, msg = {startQuestText1, startQuestText2}}
local AIDT = AID.quests.forestSpirits
local completingMissionExp = 40

quest_forestSpirits = {
    questlog = {
        name = "Forest Spirits Quest",
        questSV = SV.forestSpiritsQuest,
        trackerSV = SV.forestSpiritsQuestTracker,
        log = {
            [0] = "Free the spirits in the northern forest.",
        },
        hintLog = {
            [0] = {
                [SV.forestQuestHint1] = "Dundee told you to use blood on the stone tiles near the altar.",
                [SV.forestQuestHint2] = "Niine told you to follow some kind of green light.",
            }
        },
    },
    npcChat = {
        ["dundee"] = {
            [45] = {
                question = "I found some sort of burial altar in the forest and I think I have to do something there.",
                allSV = {[SV.forestSpiritsQuest] = 0},
                setSV = {[SV.forestQuestHint1] = 1},
                answer = {"Ah yes, bring blood and use it on the stone tile near the altar.", "Don't ask me how I know that... just trust me!"},
            },
        },
        ["niine"] = {
            [65] = {
                question = "Do you know what to do with the altar in the forest?",
                allSV = {[SV.forestSpiritsQuest] = 0},
                setSV = {[SV.forestQuestHint2] = 1},
                answer = "Follow the green light.",
            },
        },
        ["bum"] = {
            [81] = {
                question = "Do you know what to do with the altar thing in the woods?",
                allSV = {[SV.forestSpiritsQuest] = 0},
                answer = "I don't, but Dundee might.",
            },
        },
        ["alice"] = {
            [13] = {
                question = "There's some sort of statue in the woods to the north and I was wondering if you knew something about it.",
                allSV = {[SV.forestSpiritsQuest] = 0},
                answer = "I don't, but perhaps Niine does.",
            },
        }
    },
    mapEffects = {
        ["statue"] = {pos = {x = 543, y = 548, z = 7}},
    },
    AIDItems = {
        [AIDT.statue] = {
            allSV = {[SV.forestSpiritsQuest] = -1},
            setSV = {[SV.forestSpiritsQuest] = 0, [SV.forestSpiritsQuestTracker] = 0},
            addSV = {[SV.skillpoints] = 1},
            textF = statueTextF,
            text = statueText,
            funcSTR = "questSystem_startQuestEffect",
        },
        [AIDT.magicBush] = {
            allSV = {[SV.forestSpiritsQuest] = 0},
            transform = {itemID = 10763, itemAID = 0},
            text = {
                msg = "Something floates away",
                text = {msg = "*sparkles*"}
            },
            funcSTR = "forestSpiritsQuest_useBush",
        },
        [AIDT.magicTree] = {
            allSV = {[SV.forestSpiritsQuest] = 0},
            setSV = {[SV.forestSpiritsQuest] = 1},
            addSV = {[SV.skillpoints] = 2},
            transform = {itemID = 2702, itemAID = 0},
            rewardItems = {itemID = 5905, count = 3},
            text = {
                type = ORANGE,
                msg = {"Forest Spirits Quest completed", "You earned 2 extra skillPoints"},
            },
            expReward = completingMissionExp,
            funcSTR = "questSystem_completeQuestEffect",
        },
    },
    AIDItems_onLook = {
        [AIDT.statue] = {
            allSV = {[SV.forestSpiritsQuest] = -1},
            setSV = {[SV.forestSpiritsQuest] = 0, [SV.forestSpiritsQuestTracker] = 0},
            addSV = {[SV.skillpoints] = 1},
            textF = statueTextF,
            text = statueText,
            funcSTR = "questSystem_startQuestEffect",
        },
        [AIDT.book] = {text = {msg = "lot of animals are buried front of forest statue."}},
    },
}
centralSystem_registerTable(quest_forestSpirits)

local bloodCount = 0
local consuming = false
local function moreBlood(pos) text("*MOAAAAAR! RRR RR rrr..*", pos) end

function forestSpiritsQuest_pourBlood(player, item, itemEx)
    if not itemEx or type(itemEx) == "table" then return end
    if not itemEx:isItem() then return end
local itemPos = itemEx:getPosition()
local stoneTile = findItem(9727, itemPos)
    if not stoneTile then return end
    if stoneTile:getActionId() ~= AIDT.bloodTile then return end
    if item:getFluidType() ~= 2 then return end
    if consuming then return player:sendTextMessage(GREEN, "wait, something already is happening.") end
local itemID = item:getId()
local statuePos = {x = 543, y = 547, z = 7}

    itemPos:sendMagicEffect(14)
    item:remove()
    text("*Urrr rr r..*", statuePos)
    bloodCount = bloodCount + 1
    consuming = true
    addEvent(function() consuming = false end, 6000)
    if bloodCount > 1 then return forestSpiritsQuest_showBush() end
    addEvent(doSendTextMessage, 7000, player:getId(), ORANGE, "Seems like I have to add more blood.")
    addEvent(moreBlood, 6000, statuePos) 
    return true
end

function forestSpiritsQuest_showBush()
local skullPillarPos = {x=546, y=548, z=7}
local longPushPos = {x=544, y=544, z=7}
local track = getPath(skullPillarPos, longPushPos)
local delay = 1000
local interval = 700

    for i, pos in pairs(track) do addEvent(doSendMagicEffect, delay + interval*i, pos, 15) end
    addEvent(doTransform, delay + interval*tableCount(track), 10763, longPushPos, 10915, AID.quests.forestSpirits.magicBush)
    return true
end

function forestSpiritsQuest_useBush(player, item)
local magicTreePos = {x=540, y=541, z=7}
local itemPos = item:getPosition()
local track = getPath(itemPos, magicTreePos)
local delay = 1000
local interval = 700
    
    bloodCount = 0
    for i, pos in pairs(track) do addEvent(doSendMagicEffect, delay+interval*i, pos, 15) end
    addEvent(doTransform, delay + interval*tableCount(track), 2702, magicTreePos, 2699, AID.quests.forestSpirits.magicTree)
end