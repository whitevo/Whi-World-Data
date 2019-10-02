local monumentText = "There seems to be something written in an odd language."
local questAccepetedMsg = "Quest accepted."
local statueText = {type = ORANGE, msg = {questAccepetedMsg, monumentText}}
local statueTextF = {type = ORANGE, msg = {monumentText}}
local completingMissionExp = 100
local AIDT = AID.quests.sabotage

quest_cyclopsSabotage = {
    questlog = {
        name = "Cyclops Sabotage Quest",
        questSV = SV.cyclopsSabotageQuest,
        trackerSV = SV.cyclopsSabotageQuestTracker,
        log = {
            [0] = "Find out what the scribblings on the monument hand in the cyclops dungeon mean.",
            [1] = "Find a way to make the cyclops leave the cyclops dungeon.",
            [2] = "Go back to Tonka and let her know you have distracted the cyclops.",
            [3] = "Enter the dungeon with Tonka.",
            [4] = "Talk with Tonka.",
            [5] = "Go back to the cyclops dungeon and write down the cyclops' spells written on the monument.",
        },
        hintLog = {
            [1] = {
                [SV.cyclopsSabotageQuestHint1] = "Bum suggested burning down everything in the cyclops dungeon.",
                [SV.cyclopsSabotageQuestHint2] = "Alice suggested sabotaging the food resorts the cyclops have in the dungeon.",
                [SV.cyclopsSabotageQuestHint3] = "Bum encouraged you to bait cyclopes to break the steel gate for you.",
                [SV.cyclopsSabotageQuestHint4] = "You had an idea to burn down the hay in the cyclops dungeon to meddle with another of the cyclopes' food source.",
            }
        },
    },
    npcChat = {
        ["tonka"] = {
            [126] = {
                question = "I found some strange monuments in the dungeon, do you know anything about that?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 0},
                setSV = {[SV.cyclopsSabotageQuestTracker] = 1, [SV.deerSabotage] = -1, [SV.foodStorageSabotage] = -1},
                answer = {
                    "Hmm, it sounds interesting. I'd like to see it for myself but there are too many cyclopes in the way.",
                    "Distract them and make most of them leave the dungeon."
                },
            },
            [127] = {
                question = "How can I distract the cyclopes?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 1},
                setSV = {[SV.cyclopsSabotageQuestTracker] = 1, [SV.deerSabotage] = -1, [SV.foodStorageSabotage] = -1},
                answer = "No idea, figure it out and let me know when you have done so.",
            },
            [128] = {
                question = "Most of the cyclopes left the cave to restock their food supply, now it's the best time to go into the cave.",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 2},
                setSV = {[SV.tonkaQuestTeleport] = 1, [SV.cyclopsSabotageQuestTracker] = 3},
                answer = "Alright, let me know when you are ready to go, I still need a fighter on my side.",
            },
            [129] = {
                question = "I am ready to go to the cyclops dungeon with you.",
                allSV = {[SV.tonkaQuestTeleport] = 1, [SV.cyclopsSabotageQuestTracker] = 3},
                checkFunc = "cyclopsSabotageQuest_fightZoneIsEmpty",
                answer = "Alright, let's explore!",
                teleport = {x = 853, y = 554, z = 8},
                funcSTR = "cyclopsSabotageQuest_enterDungeon",
            },
            [130] = {
                question = "I am ready to go inside the cyclops dungeon with you.",
                allSV = {[SV.tonkaQuestTeleport] = 1, [SV.cyclopsSabotageQuestTracker] = 3},
                checkFunc = "cyclopsSabotageQuest_fightZoneIsInUse",
                answer = "Sorry, this quest can only be done by 1 player at a time, please wait until other the player finishes.",
            },
            [131] = {
                question = "The monument was so damaged I couldn't decipher anything.",
                allSV = {[SV.cyclopsSabotageQuest] = 1},
                secTime = 10*60*60,
                answer = {
                    "Damn it! So close to discovering something useful, you have to explore deeper into the cave and report to me whenever you find similar scribblings.",
                    "Now you know what to look for.",
                    " >>> Whitevo here xD, the quest will continue when Cyclops Dungeon 2 is created, but that won't happen any time soon. Patch 0.1.8 at best <<<",
                },
            },
            [132] = {
                question = "Are you alright?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 4},
                setSV = {[SV.cyclopsSabotageQuestTracker] = 5},
                answer = "Yes, I'm fine, thanks for the help. I didn't finish writing down the spell, could you go down there and get it for me.",
            },
        },
        ["dundee"] = {
            [44] = {
                question = "Any idea how to make the cyclopes leave the cyclops dungeon?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 1},
                answer = "I would drag them all out with my bare hands!!!",
            },
        },
        ["niine"] = {
            [64] = {
                question = "Any idea how to make the cyclopes leave their dungeon?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 1},
                answer = "Sorry, no, just let them live there, it's safer for all of us that way.",
            },
        },
        ["bum"] = {
            [76] = {
                question = "Any idea how to make the cyclopes leave the dungeon?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 1},
                setSV = {[SV.cyclopsSabotageQuestHint1] = 1},
                answer = {"Well...", "You could always burn it down."},
            },
            [77] = {
                question = "Do you have any tools that could pry open steel gates?",
                allSV = {[SV.lookedCyclopsGate] = 1, [SV.cyclopsSabotageQuestTracker] = 1, [SV.smith7] = -1},
                setSV = {},
                answer = "What kind of question is that?",
            },
            [78] = {
                question = "Well... there is a pretty heavy steel gate in the cyclops dungeon and I kinda need to get to the other side.",
                allSV = {[SV.smith7] = 1, [SV.cyclopsSabotageQuestTracker] = 1, [SV.smith8] = -1},
                setSV = {[SV.cyclopsSabotageQuestHint3] = 1, [SV.smith8] = 1},
                answer = {
                    "I see.", "Unfortunately I don't have tools for something like that",
                    "Cyclopes are pretty dumb, but very strong. Maybe you can trick one of them to break the gate for you.",
                },
            },
        },
        ["alice"] = {
            [12] = {
                question = "Any idea how to make the cyclopes leave their dungeon?",
                allSV = {[SV.cyclopsSabotageQuestTracker] = 1},
                setSV = {[SV.cyclopsSabotageQuestHint2] = 1},
                answer = {
                    "Well, I'm no specialist, but every living being has to eat, including cyclopes.",
                    "If you sabotage their food resorts, they'll have to go gather more.",
                    "Although you should ask Dundee, he is a master hunter after all. He could be more helpful.",
                },
            },
        },
        ["peeter"] = {
            [103] = {
                question = "How's it going?",
                allSV = {[SV.heyHintTrigger] = 1, [SV.cyclopsSabotageQuestTracker] = 1, [SV.peeter8] = -1},
                setSV = {[SV.cyclopsSabotageQuestHint4] = 1, [SV.peeter8] = 1},
                answer = {
                    "I'm ok.", "Even though last night I spent hours putting out a fire.",
                    "One of the bandits threw a burning torch on some hay, damn it spreads fast..."
                },
            },
        }
    },
    mapEffects = {["startHand"] = {pos = {x = 748, y = 553, z = 8}}},
    AIDItems = {
        [AIDT.startHand] = {funcSTR = "cyclopsSabotageQuest_start"},
        [AIDT.steelGate] = {
            setSV = {[SV.lookedCyclopsGate] = 1},
            text = {msg = "A strong gate, it would require a huge amount of power to bust this open!"},
            teleport = {x = 724, y = 604, z = 8},
        }
    },
    AIDItems_onLook = {
        [AIDT.mysteryMonument] = {text = {msg = "A mysterious monument"}},
        [AIDT.rumBarrel1] = {text = {msg = "Smells like heavy alcohol."}},
        [AIDT.rumBarrel2] = {text = {msg = "Smells like heavy alcohol."}},
        [AIDT.portalOut] = {text = {msg = "Stepping on this tile will take you out of the dungeon."}},
        [AIDT.tonkaBody] = {text = {msg = "Drag Tonka out of the cave."}},
        [AIDT.startHand] = {
            allSV = {[SV.cyclopsSabotageQuest] = -1},
            setSV = {[SV.cyclopsSabotageQuest] = 0, [SV.cyclopsSabotageQuestTracker] = 0},
            textF = statueTextF,
            text = statueText,
            funcSTR = "questSystem_startQuestEffect",
        },
        [AIDT.steelGate] = {
            setSV = {[SV.lookedCyclopsGate] = 1},
            text = {msg = "A strong gate, it would require a huge amount of power to bust this open!"}
        },
    },
    AIDTiles_stepOut = {
        [AIDT.gateTile] = {funcSTR = "cyclopsSabotageQuest_removeGate"}
    },
    AIDTiles_stepIn = {
        [AIDT.heyHint] = {setSV = {[SV.heyHintTrigger] = 1}},
        [AIDT.portalOut] = {funcSTR = "cyclopsSabotageQuest_createMW"},
        [AIDT.tonkaHoldTile] = {funcSTR = "cyclopsSabotageQuest_holdTonka"},
    },
    modalWindows = {
        [MW.cyclopsSabotageQuest] = {
            name = "Leave the dungeon.",
            title = "Are you sure you want to leave without Tonka?",
            choices = {
                [1] = "Yes, fuck him, it's too dangerous!",
                [2] = "No, I will save him or die trying!",
            },
            buttons = {
                [100] = "Select",
                [101] = "Stay",
            },
            func = "cyclopsSabotageQuest_MW",
        }
    },
}
centralSystem_registerTable(quest_cyclopsSabotage)

function cyclopsSabotageQuest_removeGate(creature, item)
    if not creature:isMonster() then return end
local pos = {x = 723, y = 604, z = 8}
local palisteID = 3527
local gateID = 22578
local tile = Tile(pos)
local paliste = tile:getItemById(palisteID)
local gate = tile:getItemById(gateID)
    
    if paliste then
        addEvent(createItem, 2*60*1000, palisteID, pos, 1, AIDT.steelGate)
        paliste:remove()
    end
    if gate then
        addEvent(createItem, 2*60*1000, gateID, pos)
        gate:remove()
    end
end

function sabotageQuestDamage(monsterID, pos) -- when playere takes damage from monster
    if not samePositions({x = 724, y = 604, z = 8}, pos) then return end
local monster = Monster(monsterID)

    if not monster then return end
    if monster:getName():lower() ~= "cyclops" then return end
    cyclopsSabotageQuest_removeGate(monster)
end


local function cyclopsBarrelExplosion(creatureID, pos, AID)
local area 
    if AID == AIDT.rumBarrel1 then
        area = {
            {n,n,n,n,8,n},
            {3,4,5,6,7,8},
            {2,3,n,n,n,n},
            {1,2,n,n,n,n},
            {2,3,n,n,n,n},
        }
    elseif AID == AIDT.rumBarrel2 then
        area = {
            {n,n,n,n,8,n},
            {5,4,5,6,7,8},
            {4,3,n,n,n,n},
            {3,2,n,n,n,n},
            {2,1,n,n,n,n},
        }
    end
local positions = getAreaPos(pos, area)
    
    for i, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            local delay = (i-1)*250
            
            if i <= 3 then
                addEvent(createItem, delay, 1492, pos, 1, AID.other.field_fire, nil, "minDam(250) maxDam(350)")
                addEvent(dealDamagePos, delay, 0, pos, FIRE, math.random(250, 400), 16, O_environment, 7)
            elseif i <= 6 then
                addEvent(createItem, delay, 1492, pos, 1, AID.other.field_fire, nil, "minDam(200) maxDam(300)")
                addEvent(dealDamagePos, delay, 0, pos, FIRE, math.random(150, 250), 16, O_environment, 16)
            else
                addEvent(createItem, delay, 1493, pos)
                addEvent(dealDamagePos, delay, 0, pos, FIRE, math.random(50, 100), 16, O_environment, 37)
            end
            addEvent(decay, delay+1000, pos, fireFieldDecayT, true)
            addEvent(cyclopsAlcoholBarrels, delay+100, creatureID, pos)
        end
    end
end

function cyclopsAlcoholBarrels(creatureID, pos)  -- in player:onMoveItem()
    local tile = Tile(pos)
    if not tile then return end
    
    local barrelID = 1770
    local barrel = tile:getItemById(barrelID)
    if not barrel then return end
    
    local barrelAID = barrel:getActionId()
    local barrelTime = 4*60*1000
    if barrelAID ~= AIDT.rumBarrel1 and barrelAID ~= AIDT.rumBarrel2 then return end
    
    local creature = Creature(creatureID)
    creatureID = creature and creature:getId() or creatureID

    doSendMagicEffect(pos, 4)
    createItem(1494, pos)
    addEvent(removeItemFromPos, 2000, barrelID, pos)
    addEvent(removeItemFromPos, 2500, 1494, pos)
    addEvent(createItem, barrelTime, 1770, pos, 1, barrelAID)
    addEvent(cyclopsBarrelExplosion, 2000, creatureID, pos, barrelAID)
    addEvent(cyclopsSabotageQuest_sabotageKitchen, 10000, creatureID, SV.foodStorageSabotage)
    return true
end

local function advanceQuest(player)
    player:sendTextMessage(ORANGE, "You have sabotaged both food resorts in Cyclops Dungeon, Cyclops are furiated.")
    player:sendTextMessage(ORANGE, "Hurry to Tonka and bring him the good news.")
    setSV(player, SV.cyclopsSabotageQuestTracker, 2)
end

function cyclopsSabotageQuest_sabotageKitchen(creatureID)
local player = Player(creatureID)
    if not player then return end
local partyT = getPartyMembers(player)
    
    for guid, pid in pairs(partyT) do
        local member = Player(pid)
        local taskSV = SV.foodStorageSabotage
        
        if getSV(member, SV.cyclopsSabotageQuestTracker) == 1 and getSV(member, taskSV) ~= 1 then
            member:setStorageValue(taskSV, 1)
            member:sendTextMessage(ORANGE, "Cyclops Dungeon food storage has been sabotaged.")
            if getSV(member, SV.deerSabotage) == 1 then return advanceQuest(member) end
            member:sendTextMessage(ORANGE, "Cyclopses still seem to have some kind of food sources left in this dungeon.")
        end
    end
end

local function unmadDeer(monsterID)
local deer = Monster(monsterID)
    
    if deer then
        local currentHP = deer:getHealth()
        local maxHP = deer:getMaxHealth()
        local lostHP = maxHP-currentHP
        local newMonster = createMonster("deer", deer:getPosition())
        
        deer:remove()
        newMonster:addHealth(-lostHP)
    end
end

local function madDeers()
local zone = createSquare({x = 776, y = 635, z = 8}, {x = 789, y = 642, z = 8})

    for _, pos in pairs(zone) do
        local deer = findByName(pos, "deer")
        
        if deer then
            local currentHP = deer:getHealth()
            local maxHP = deer:getMaxHealth()
            local lostHP = maxHP-currentHP
            local newMonster = createMonster("mad deer", pos)
            local monsterID = newMonster:getId()
            
            deer:remove()
            newMonster:addHealth(-lostHP)
            addEvent(unmadDeer, 2*60*1000, monsterID)
        end
    end
end

function cyclopsSabotageQuest_sabotageDeers(creatureID, heyAID)
    if heyAID ~= AIDT.heyToBurn then return end
local player = Player(creatureID)
    if not player then return end
local partyT = getPartyMembers(player)
    
    madDeers()
    for guid, pid in pairs(partyT) do
        local member = Player(pid)
        local taskSV = SV.deerSabotage
        
        if getSV(member, SV.cyclopsSabotageQuestTracker) == 1 and getSV(member, taskSV) ~= 1 then
            member:setStorageValue(taskSV, 1)
            member:sendTextMessage(ORANGE, "Cyclops Dungeon deer farm has been sabotaged.")
            if getSV(member, SV.foodStorageSabotage) == 1 then return advanceQuest(member) end
            member:sendTextMessage(ORANGE, "Cyclopses still seem to have some kind of food sources left in this dungeon.")
        end
    end
end

function madDeerAI(monster)
    if monster:getRealName() ~= "mad deer" then return end
    if not findItem(1492, monster:getPosition()) then return end
    doDamage(monster, FIRE, math.random(200, 300), 16, O_environment)
end

local sabotageCreatures = {}
local tonkaBodyID = 3128
cyclopsSabotageFightZoneInUse = false

function clearSabotageQuestRoom()
local tonkaBody = getItemFromTracker(tonkaBodyID, AIDT.tonkaBody)
    
    if tonkaBody then tonkaBody:remove() end
    for _, cyclopsID in pairs(sabotageCreatures) do removeCreature(cyclopsID) end
    sabotageCreatures = {}
    cyclopsSabotageFightZoneInUse = false
end

local function createSabotageCyclops() return table.insert(sabotageCreatures, createMonster("cyclops", {x = 842, y = 545, z = 8}):getId()) end

function cyclopsSabotageQuest_createCyclopses()
    addEvent(createSabotageCyclops, 3000)
    addEvent(createSabotageCyclops, 8000)
end

function cyclopsSabotageQuest_enterDungeon(player)
local npc = createNpc({name = "tonka", npcPos = {x = 851, y = 554, z = 8}})
local npcID = npc:getId()
local npcT = getNpcT(npcID)
    
    registerEvent(npc, "onThink", "cyclopsSabotageQuest_tonkaAI")
    table.insert(sabotageCreatures, npcID)
    npcT.followTargetID = player:getId()
    npcT.chatDisabled = true
    cyclopsSabotageFightZoneInUse = true
end

function cyclopsSabotageQuest_createMW(player) return player:createMW(MW.cyclopsSabotageQuest) end

function cyclopsSabotageQuest_MW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 2 then return end
    clearSabotageQuestRoom()
    player:teleportTo({x = 639, y = 549, z = 7})
end

function cyclopsSabotageQuest_moveTonkaBody(player, item, toPos) -- in player:onMoveItem()
    if item:getId() ~= tonkaBodyID then return end
    if item:getActionId() ~= AIDT.tonkaBody then return end
    tracking(item, toPos)
    if not samePositions({x = 860, y = 554, z = 8}, toPos) then return end
    player:teleportTo({x = 641, y = 576, z = 7})
    player:sendTextMessage(ORANGE, "You saved Tonka")
    setSV(player, SV.cyclopsSabotageQuestTracker, 4)
    clearSabotageQuestRoom()
    return true
end

function cyclopsSabotageQuest_start(player)
    if getSV(player, SV.cyclopsSabotageQuest) == -1 then
        player:sendTextMessage(ORANGE, questAccepetedMsg)
        player:sendTextMessage(ORANGE, monumentText)
        setSV(player, {SV.cyclopsSabotageQuest, SV.cyclopsSabotageQuestTracker}, 0)
        questSystem_startQuestEffect(player)
    elseif getSV(player, SV.cyclopsSabotageQuestTracker) == 5 then
        player:sendTextMessage(BLUE, "The monument has been damaged, the spell words are unreadable.")
        player:addExpPercent(completingMissionExp)
        questSystem_completeQuestEffect(player)
        setSV(player, {[SV.cyclopsSabotageQuest] = 1, [SV.cyclopsSabotageQuestTracker] = -1})
    elseif getSV(player, SV.cyclopsSabotageQuest) == 0 then
        player:sendTextMessage(ORANGE, monumentText)
    else
        player:sendTextMessage(GREEN, "The monument has been damaged, the spell words are unreadable.")
    end
end

function cyclopsSabotageQuest_fightZoneIsEmpty(player) return not cyclopsSabotageFightZoneInUse end
function cyclopsSabotageQuest_fightZoneIsInUse(player) return cyclopsSabotageFightZoneInUse end

local cyclopsSabotageQuest_tonkaAIActivated = false
function cyclopsSabotageQuest_tonkaAI(npc)
    if cyclopsSabotageQuest_tonkaAIActivated then return end
local npcPos = npc:getPosition()
    if not isInRange(npcPos, {x = 835, y = 546, z = 8}, {x = 841, y = 552, z = 8}) then return end
local npcT = getNpcT(npc)
local npcID = npc:getId()
    
    local function shitHappens()
        npcPos = npc:getPosition()
        doSendDistanceEffect({x = 845, y = 544, z = 8}, npcPos, 12)
        doSendMagicEffect(npcPos, 32)
        addEvent(doSendMagicEffect, 1000, npcPos, 32)
        createItem(3128, npcPos, 1, AID.quests.sabotage.tonkaBody)
        tracker[3128] = {lastPos = npcPos, currentPos = npcPos}
        cyclopsSabotageQuest_createCyclopses()
        npc:remove()
        cyclopsSabotageQuest_tonkaAIActivated = false
    end
    
    npcT.followTargetID = false
    cyclopsSabotageQuest_tonkaAIActivated = true
    creatureSay(npc, "We're here!")
    creatureSay(npc, "Interesting marks, I'm going to take a closer look, give me some time.")
    walkTo(npcID, {x = 840, y = 550, z = 8}, {"solid","noGround"}, 500)
    addEvent(doTurn, 3000, npcID, "N")
    addEvent(creatureSay, 3000, npcID, "Ah yes, I see, it makes sense.")
    addEvent(creatureSay, 6000, npcID, "I haven't encountered cyclops magic before, but if I'm not mistaken, these are old magic words.")
    addEvent(creatureSay, 13000, npcID, "Let me just write something down in my notebook and then we'll get out of here.")
    addEvent(shitHappens, 17000)
end

function cyclopsSabotageQuest_holdTonka(creature, item)
    if not creature:isNpc() then return end
    bindCondition(creature, "monsterSlow", -1, {speed = -creature:getSpeed()})
    teleport(creature, item:getPosition(), false, "N")
end