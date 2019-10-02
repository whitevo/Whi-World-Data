local AIDT = AID.areas.forgottenVillage

npcConf_cook = {
    name = "alice",
    npcPos = {x = 574, y = 663, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    AIDItems_onMove = {
        [AIDT.apples] = {funcSTR = "alice_apples_onMove"}
    },
    AIDItems = {
        [AIDT.apples] = {funcSTR = "alice_apples_onMove"}
    },
    npcShop = {
        [1] = {
            npcName = "alice",
            items = {
                {itemID = 2006, cost = 10, fluidType = 0, oneAtTheTime = true},
                {itemID = 12287, cost = 3, oneAtTheTime = true},
            },
        },
        [2] = {
            npcName = "alice",
            allSV = {[SV.meatpieMission] = 1},
            items = {itemID = 2666, itemAID = AID.other.food, cost = 6, sell = 2, maxStock = 16, baseStock = 8, genStockSecTime = 2*60},
        },
        [3] = {
            npcName = "alice",
            allSV = {[SV.hamAndSaladMission] = 1},
            items = {itemID = 2671, itemAID = AID.other.food, cost = 11, sell = 4, maxStock = 12, baseStock = 6, genStockSecTime = 2*60},
        },
        [4] = {
            npcName = "alice",
            anySVF = {[SV.recipeBookLearned] = 1},
            items = {itemID = 10006, cost = 40, itemAID = AID.other.cookBook, oneAtTheTime = true},
        }
    },
    npcChat = {
        ["alice"] = {
            [1] = {
                question = "Who are you?",
                allSV = {[SV.cook1] = -1},
                setSV = {[SV.cook1] = 1},
                answer = "My name is Alice.",
            },
            [2] = {
                question = "What do you do?",
                allSV = {[SV.cook1] = 1, [SV.cook2] = -1},
                setSV = {[SV.cook2] = 1},
                answer = "I make sure my friends in the Forgotten Village are fed.",
            },
            [3] = {
                question = "Can I get some food?",
                allSV = {[SV.cook2] = 1, [SV.cook3] = -1},
                setSV = {[SV.cook3] = 1},
                answer = {"I don't consider people I've never seen before my friends...", "But perhaps in time."},
            },
            [4] = {
                question = "What is this place?",
                allSV = {[SV.cook3] = 1, [SV.cook4] = -1},
                setSV = {[SV.cook4] = 1},
                answer = "This is the Forgotten Village."
            },
            [5] = {
                question = "That's kind of dramatic, why is it called that?",
                allSV = {[SV.cook4] = 1, [SV.cook5] = -1},
                setSV = {[SV.cook5] = 1},
                answer = "Isn't it obvious? Take a look around."
            },
            [6] = {
                question = "What happened here?",
                allSV = {[SV.cook5] = 1, [SV.cook6] = -1},
                setSV = {[SV.cook6] = 1},
                answer = "An Elite decided to use our village as target practice for his death magic.", -- his father is a necromancer and his sister was the dying girl.
            },
            [7] = {
                question = "How can I spice food?",
                secTime = 60*60,
                anySVF = {[SV.extraInfo] = 1},
                answer = {
                    "There are 2 types of food: main ingredients and secondary ingredients.",
                    "Main ingredients are usually the ones that give substantially more HP or MP back compared to secondary ingredients.",
                    "Some main ingredients are: meat, ham, apples.",
                    "Some secondary ingredients are: blueberries, carrots.",
                    "Only main ingredients can be spiced.",
                    "Food is spiced by using a herb powder on a main ingredient type food.",
                    "But be careful, using the wrong combination will ruin your food.",
                    "To avoid this happening, purchase my patented recipe book!"
                },
            },
            [8] = {
                question = "How do I spice food?",
                secTime = 60*60,
                anySVF = {[SV.extraInfo] = 1},
                answer = {
                    "There are 2 types of food: main ingredients and secondary ingredients.",
                    "Main ingredients are usually the ones that give substantially more HP or MP back compared to secondary ingredients.",
                    "Some main ingredients are: meat, ham, apples.",
                    "Some secondary ingredients are: blueberries, carrots.",
                    "Only main ingredients can be spiced.",
                    "Food is spiced by using a herb powder on a main ingredient type food.",
                    "But be careful, using the wrong; combination will ruin your food.",
                    "To avoid this happening, purchase my patented recipe book!",
                },
            },
            [9] = {
                question = "How can I make dishes?",
                secTime = 60*60,
                anySVF = {[SV.extraInfo] = 1},
                answer = {
                    "There are 3 categories of food related items: vials, ingredients and dishes.",
                    "Unfinished dishes are made by using an empty bowl on an ingredient.",
                    "Dishes can be made by using unfinished dishes on other ingredients.",
                    "Be aware, using the wrong combination will spoil your food.",
                },
            },
            [10] = {
                question = "How are potions made?",
                secTime = 60*60,
                anySVF = {[SV.extraInfo] = 1},
                answer = {
                    "The activity of producing potions is called brewing.",
                    "To brew an unfinished potion, you need to use a herb powder on a vial of water.",
                    "To brew a potion, you need to use another herb powder with an unfinished potion.",
                    "As usual, a wrong combination will ruin your ingredients.",
                },
            },
            [11] = {
                question = "How can I find herbs?",
                secTime = 60*60,
                anySVF = {[SV.extraInfo] = 1},
                answer = {
                    "Herbs can be harvested from certain trees and flowers, you might also loot them from creatures.",
                    "Look at trees and plants that look like they might provide herbs to check if they do.",
                    "To pick up a herb, simply use it.",
                    "Use the herb to crush it into powder.",
                }
            },
        },
    },
    modalWindows = {
        [MW.cookRep] = {
            name = "alice_repMW_name",
            title = "Choose food you give to Alice",
            choices = "alice_repMW_createChoices",
            buttons = {
                [100] = "choose",
                [101] = "close",
            },
            func = "alice_repMW",
        },
    },
}

centralSystem_registerTable(npcConf_cook)

function alice_repMW_name(player) return "Alice Repution ["..player:getRep("alice").." / 100]" end
function alice_repMW_create(player) return player:createMW(MW.cookRep) end

local function canAddChoice(ID, t)
    return type(ID) == "number" and t.repSV
end

local function getFoodRep(player, foodT)
    local foodRep = getSV(player, foodT.repSV)
    if foodRep < 0 then setSV(player, foodT.repSV, 0) return 0 end
    return foodRep
end

function alice_repMW_createChoices(player)
    local choiceT = {}
    local choiceID = 0
    
    local function addChoice(itemID, foodT)
        local foodRep = getFoodRep(player, foodT)
        local reputation = foodT.maxRep - foodRep
        local itemName = ItemType(itemID):getName()
        
        choiceID = choiceID + 1
        if reputation > 0 then choiceT[choiceID] = itemName.." gives "..reputation.." reputation" return end
        choiceT[choiceID + 100] = "Alice does not need any more "..itemName
    end
    
    for itemID, foodT in pairs(foodConf.food) do
        if canAddChoice(itemID, foodT) then addChoice(itemID, foodT) end
    end
    return choiceT
end

function alice_repMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID > 100 then return alice_repMW_create(player) end
    local loopID = 0
        
    for ID, t in pairs(foodConf.food) do
        if canAddChoice(ID, t) then
            loopID = loopID + 1
            if choiceID == loopID then
                if player:removeItem(ID, 1) then
                    local foodRep = getFoodRep(player, t)
                    setSV(player, t.repSV, foodRep + 1)
                    addRep(player, t.maxRep - foodRep, "alice")
                else
                    player:sendTextMessage(GREEN, "You don't have "..ItemType(ID):getName().." in your bag")
                end
                return alice_repMW_create(player)
            end
        end
    end
end

function alice_apples_onMove(player, item, fromPos)
    local npc = Creature("alice")

    local function takeApples() item:setActionId(AID.other.food) end
    if not npc then return takeApples() end
    if not pathIsOpen(item:getPosition(), npc:getPosition(), "blockThrow") then return takeApples() end
    return creatureSay(npc, "These are my apples..") 
end