npcConf_niine = {
    name = "niine",
    npcPos = {x = 572, y = 663, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    npcShop = {
        [1] = {
            npcName = "niine",
            bigSV = {[SV.priestRepL] = 1},
            items = {itemID = 13828, itemAID = AID.other.tool, cost = 20, itemText = "charges(3)", oneAtTheTime = true},
        },
        [2] = {
            npcName = "niine",
            allSV = {[SV.hehemiQuest] = 1},
            items = {itemID = seedBagConf.itemID, cost = 25, oneAtTheTime = true},
        },
    },
    npcChat = {
        ["niine"] = {
            [57] = {
                question = "Who are you?",
                allSV = {[SV.priest1] = -1},
                setSV = {[SV.priest1] = 1},
                answer = "I am Niine, the priest.",
            },
            [58] = {
                question = "What do you do?",
                allSV = {[SV.priest1] = 1, [SV.priest2] = -1},
                setSV = {[SV.priest2] = 1},
                answer = "I make sure everyone in the Forgotten Village stays healthy.",
            },
            [59] = {
                question = "Can I help you with anything?",
                allSV = {[SV.priest2] = 1, [SV.priest3] = -1},
                setSV = {[SV.priest3] = 1},
                answer = "I don't need help right now, but I'm sure the others do.",
            },
            [60] = {
                question = "What is this place?",
                allSV = {[SV.priest3] = 1, [SV.priest4] = -1},
                setSV = {[SV.priest4] = 1},
                answer = "This is the Forgotten Village, at least that is what we call it now.",
            },
            [61] = {
                question = "What happened here?",
                allSV = {[SV.priest4] = 1, [SV.priest5] = -1},
                setSV = {[SV.priest5] = 1},
                answer = "My father happened.",
            },
            [62] = {
                question = "What do you mean?",
                allSV = {[SV.priest5] = 1, [SV.priest6] = -1},
                setSV = {[SV.priest6] = 1},
                answer = "...", -- her father is the necromancer and her sister was the dying girl.
            },
            -- more story reveal on enchantingConf
            -- ITEM HINTS --
            [63] = {
                msg = {"Beautiful Yahshimaki!", "It seems that the more magic level you have, the more armor it gives to the healed target."},
                moreItems = {{itemID = 2537, count = 1}},
            },
        }
    },
    modalWindows = {
        [MW.priestRep] = {
            name = "niine_repMW_name",
            title = "Choose bulk of powders to donate",
            choices = "niine_repMW_createChoices",
            buttons = {
                [100] = "choose",
                [101] = "close",
            },
            func = "niine_repMW",
        },
    },
}
centralSystem_registerTable(npcConf_niine)

function niine_repMW_name(player) return "Niine Repution ["..player:getRep("niine").." / 100]" end
function niine_repMW_create(player) return player:createMW(MW.priestRep) end

function niine_repMW_createChoices(player)
local choiceT = {}
local choiceID = 0
    
    local function addChoice(herbT)
        local repT = herbT.rep
        local reputation = calculateItemRep(player, repT)
        
        choiceID = choiceID + 1
        if reputation > 0 then choiceT[choiceID] = repT.bulk.." "..herbT.name.." gives "..reputation.." reputation" return end
        choiceT[choiceID + 100] = "Niine does not need any more "..herbT.name
    end
    
    for herbAID, herbT in pairs(herbs) do
        if herbT.rep then addChoice(herbT) end
    end
    return choiceT
end

function niine_repMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID > 100 then return niine_repMW_create(player) end
local loopID = 0
    
    for herbAID, herbT in pairs(herbs) do
        local repT = herbT.rep
        
        if repT then
            loopID = loopID+1
            
            if choiceID == loopID then
                if player:removeItem(herbT.powderColor, repT.bulk, herbT.powderAID) then
                    local reputation = calculateItemRep(player, repT)
                    
                    addSV(player, repT.repSV, 1)
                    addRep(player, reputation, "niine")
                else
                    player:sendTextMessage(GREEN, "You don't have "..repT.bulk.." "..herbT.name.." in your bag")
                end
                return niine_repMW_create(player)
            end
        end
    end
end

function calculateItemRep(player, t)
local itemRep = getSV(player, t.repSV)
    
    if itemRep < 0 then return t.maxRep, setSV(player, t.repSV, 0) end
    if t.reduce then itemRep = math.floor(itemRep * t.reduce) end
    return t.maxRep - itemRep
end