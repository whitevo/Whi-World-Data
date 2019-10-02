--[[ collectingMission guide
    [STR] = {                           npc name
        name = STR                      name of the mission
        msg = {STR}                     npc gives you mission with message
        question = STR or "You need any help?"
        completeMsg = {STR}             msg you get after completing mission
        
        missionSV = INT,                mission storage value -1 = not accepted, 0 = accepted, 1 = completed
        allSV = {[K]=V}                 if getSV(player, K) == V then it passes.
        bigSV = {[K]=V}                 if getSV(player, K) >= V then it passes.
        setSV = {[K]=V}                 setSV(player, K, V)
        
        items = {{                      list of items player needs to collect
            itemID = INT
            count = INT or 1
            itemAID = INT
            type = INT
        }},
        level = INT or 1,               minimum level for player to accept the mission
        addRep = {                      upon completing mission player gets INT amount of rep towards npc
            [STR] = INT                 STR = npc name
        },         
        
        rewardExp = INT,                upon completing mission player gets INT amount of exp
        addProfessionExp = {
            [STR] = INT                 professions_addExp(player, INT, STR) | STR = professionStr | INT = amount
        }
        rewardItems = {{                upon completing mission player gets items
            itemID = {INT}              if table then rewards only 1 item
            count = INT or 1
            itemAID = INT
            type = INT
        }},
        skipMissionStart = BOOL         skips generating this mission start to npc table

        AUTOMATIC
        npcName = STR                   table key
    }
]]

npcMissions = {
    ["niine"] = {
        [1] = {
            name = "Antidote potion mission",
            items = {{itemID = 7477, count = 3, itemAID = AID.potions.antidote}},
            missionSV = SV.antidotePotionsMission,
            allSV = {[SV.vocationPotionMission] = 1},
            addRep = {["niine"] = 35},
            rewardExp = 19,
            level = 4,
            msg = "I'm running low on antidotes, it'd be great if you could get some for me. You never know when you might need one",
            completeMsg = "Thank you for these, you can rest assured I will save some for you to have when the time comes.",
        },
        [2] = {
            name = "Team preparation mission",
            items = {
                {itemID = 12468, itemAID = AID.potions.druid},
                {itemID = 7477,  itemAID = AID.potions.hunter},
                {itemID = 7495,  itemAID = AID.potions.mage},
                {itemID = 20135, itemAID = AID.potions.knigt},
            },
            missionSV = SV.teamPreparationMission,
            allSV = {[SV.antidotePotionsMission] = 1},
            addRep = {["niine"] = 35},
            rewardExp = 19,
            msg = {"The Forgotten Village has to be prepared if more undeads attack!", "Create some class potions for us."},
            completeMsg = "Many thanks!",
        },
        [3] = {
            name = "Hyperactive mission",
            items = {{itemID = 12544, count = 3, itemAID = AID.potions.flash}},
            missionSV = SV.hyperactiveMission,
            allSV = {[SV.teamPreparationMission] = 1},
            bigSV = {[SV.flysh] = 2},
            addRep = {["niine"] = 70},
            rewardExp = 19,
            msg = "I want to try out some new potions, get me some flash potions.",
            completeMsg = "Wow, looks sparkly. Thank you for these.",
        },
        [4] = {
            name = "The elders mission",
            items = {{itemID = 13735, count = 3, itemAID = AID.potions.spellcaster}},
            missionSV = SV.theElders,
            allSV = {[SV.hyperactiveMission] = 1},
            bigSV = {[SV.shadilyGloomyShroom] = 2},
            addRep = {["niine"] = 70},
            rewardExp = 19,
            msg = "I want to try out some new potions, get me some spellcaster potions.",
            completeMsg = "Oh my god! These are amazing!",
        },
        [5] = {
            name = "Controllers mission",
            items = {{itemID = 21403, count = 3, itemAID = AID.potions.silence}},
            missionSV = SV.controllersMission,
            allSV = {[SV.theElders] = 1},
            bigSV = {[SV.xuppeofron] = 2},
            addRep = {["niine"] = 70},
            rewardExp = 19,
            question = "Do you need any more potions?",
            msg = "Peeter asked for some silence potions, make me a few, will you.",
            completeMsg = "Thanks.",
        },
        [6] = {
            name = "Magic dust mission",
            missionSV = SV.ghostPowderMission,
            items = {{itemID = 5905, count = 12}},
            allSV = {[SV.ghoulMission] = 1},
            rewardExp = 20,
            msg = "I want to hone my enchanting skills, could you bring me some magic dust?",
            completeMsg = "Oooh, that is lovely! Time to do some enchanting!",
        },
    },
    ["dundee"] = {
        [1] = {
            name = "Fur bag mission",
            missionSV = SV.furBagMission,
            items = {
                {itemID = 7457},
                {itemID = 11224, count = 20},
                {itemID = 5896, count = 5},
            },
            rewardItems = {{itemID = 7343}},
            rewardExp = 20,
            bigSV = {[SV.taskerRepL] = 1},
            skipMissionStart = true,
        },
        [2] = {
            name = "Fur backpack mission",
            missionSV = SV.furBackpackMission,
            items = {
                {itemID = 11224, count = 20},
                {itemID = 5896, count = 8},
                {itemID = 5897, count = 7},
                {itemID = 13159, count = 5},
                {itemID = 7457},
            },
            allSV = {[SV.furBagMission] = 1},
            bigSV = {[SV.taskerRepL] = 2},
            rewardItems = {{itemID = 7342}},
            rewardExp = 20,
            skipMissionStart = true,
        },
    },
    ["peeter"] = {
        [1] = {
            name = "Blue cloth mission",
            items = {{itemID = 5912, count = 8}},
            missionSV = SV.blueClothMission,
            allSV = {[SV.campfireMission] = 1},
            rewardExp = 20,
            setSV = {[SV.brownClothMission] = 0, [SV.whiteClothMission] = 0, [SV.redClothMission] = 0},
            msg = "Bandits just keep coming out of this mountain and stealing our food. Stop them!",
        },
        [2] = {
            name = "Brown cloth mission",
            items = {{itemID = 5913, count = 8}},
            missionSV = SV.brownClothMission,
            allSV = {[SV.campfireMission] = 1},
            rewardExp = 20,
            skipMissionStart = true,
        },
        [3] = {
            name = "Red cloth mission",
            items = {{itemID = 5911, count = 8}},
            missionSV = SV.redClothMission,
            allSV = {[SV.campfireMission] = 1},
            rewardExp = 20,
            skipMissionStart = true,
        },
        [4] = {
            name = "White cloth mission",
            items = {{itemID = 5909, count = 8}},
            missionSV = SV.whiteClothMission,
            allSV = {[SV.campfireMission] = 1},
            rewardExp = 20,
            skipMissionStart = true,
        },
        [5] = {
            name = "Yellow cloth mission",
            items = {{itemID = 5914, count = 8}},
            missionSV = SV.yellowClothMission,
            allSV = {[SV.talkToPeeterMission] = 1},
            rewardExp = 15,
            msg = "Now that you know about Hehem, take down some stronger bandits to show them we stand strong!",
        },
        [6] = {
            name = "Green cloth mission",
            items = {{itemID = 5910, count = 8}},
            missionSV = SV.greenClothMission,
            allSV = {[SV.talkToPeeterMission] = 1},
            rewardExp = 15,
            skipMissionStart = true,
        },
    },
    ["eather"] = {
        [1] = {
            name = "Wolf mission",
            items = {{itemID = 11235, count = 4}, {itemID = 11200, count = 9}},
            missionSV = SV.wolfMission,
            rewardItems = {{itemID = 7458}},
            rewardExp = 25,
            skipMissionStart = true,
        },
        [2] = {
            name = "Boar mission",
            items = {{itemID = 11224, count = 4}, {itemID = 11200, count = 9}},
            missionSV = SV.boarMission,
            rewardItems = {{itemID = 7464}},
            rewardExp = 25,
            skipMissionStart = true,
        },
        [3] = {
            name = "Bear mission",
            items = {{itemID = 11224, count = 6}, {itemID = 11200, count = 15}},
            missionSV = SV.bearMission,
            rewardItems = {{itemID = 7463}},
            rewardExp = 25,
            skipMissionStart = true,
        },
        [4] = {
            name = "ghoul mission",
            items = {{itemID = 11136, count = 8}},
            missionSV = SV.ghoulMission,
            allSV = {[SV.boneMission] = 1},
            rewardExp = 20,
            msg = {"I need some stronger materials for my next product.", "Find me some ghoul flesh!"},
        },
        [5] = {
            name = "Mummy mission",
            items = {{itemID = 11208, count = 8}},
            missionSV = SV.mummyMission,
            allSV = {[SV.ghoulMission] = 1},
            rewardExp = 20,
            msg = {"Gather some mummy cloth for me, please.", "I want to see if I could actually do something with it."},
        },
    },
    ["alice"] = {
        [1] = {
            name = "Meatpie mission",
            items = {{itemID = 2666, count = 4}},
            missionSV = SV.meatpieMission,
            rewardExp = 20,
            allSV = {[SV.vialOfWaterMission] = 1},
            addProfessionExp = {["cooking"] = 10},
        },
        [2] = {
            name = "Ham and salad mission",
            items = {{itemID = 2671, count = 3}},
            missionSV = SV.hamAndSaladMission,
            allSV = {[SV.meatpieMission] = 1},
            level = 3,
            rewardExp = 20,
            addProfessionExp = {["cooking"] = 20},
            msg = "I want to impress the task master with my new dish, but I'm missing ham..",
        },
        [3] = {
            name = "Dumplings mission",
            items = {{itemID = 9995, count = 5}},
            missionSV = SV.dumplingsMission,
            level = 3,
            rewardExp = 19,
            addProfessionExp = {["cooking"] = 30},
            allSV = {[SV.recipeBookLearned] = 1},
            bigSV = {[SV.cookRepL] = 1, [SV.cookingLevel] = 1},
            setSV = {[SV.dumplings] = 2},
            msg = "Let's have a feast! I added the recipe to your recipe book.",
        },
        [4] = {
            name = "Easter ham mission",
            items = {{itemID = 12540, count = 5}},
            missionSV = SV.easterHamMission,
            level = 4,
            rewardExp = 19,
            addProfessionExp = {["cooking"] = 40},
            allSV = {[SV.recipeBookLearned] = 1, [SV.dumplingsMission] = 1},
            bigSV = {[SV.cookRepL] = 2, [SV.cookingLevel] = 2},
            setSV = {[SV.easterHam] = 2},
            msg = "Lets have another feast! I added the recipe to your recipe book.",
        },
        [5] = {
            name = "Delight juice mission",
            items = {{itemID = 9996, count = 5}},
            missionSV = SV.delightJuiceMission,
            level = 5,
            rewardExp = 19,
            addProfessionExp = {["cooking"] = 50},
            allSV = {[SV.recipeBookLearned] = 1, [SV.easterHamMission] = 1},
            bigSV = {[SV.cookRepL] = 3, [SV.cookingLevel] = 3},
            setSV = {[SV.delightJuice] = 2},
            msg = "Let's have a cocktail party!!! I added the recipe to your recipe book.",
        },
    },
    ["bum"] = {
        [1] = {
            name = "spear mission",
            items = {{itemID = 11214, count = 8}},
            rewardItems = {{itemID = 2389, count = 3}},
            missionSV = SV.spearMission,
            allSV = {[SV.craftSpearMission] = 1},
            msg = "Dundee is running low on spears, I need some deer antlers to make spears.",
            completeMsg = "Much obliged.",
            rewardExp = 25,
        },
        [2] = {
            name = "Bones mission",
            items = {{itemID = 5925, count = 12}},
            missionSV = SV.boneMission,
            level = 4,
            rewardExp = 20,
            msg = "I need some better materials to make tools, can you get me some strong bones?",
        },
    },
    ["tonka"] = {
        [1] = {
            name = "Small stone mission",
            items = {{itemID = 1294, count = 8}},
            missionSV = SV.smallStonesMission,
            rewardExp = 20,
            setSV = {[SV.tonkaHerbs] = 1},
            skipMissionStart = true,
        },
    },
}

local function createCustomText(itemList, answerMsg)
    if not itemList then return end
   
    for i, itemT in ipairs(itemList) do
        local itemName = ItemType(itemT.itemID):getName()
        local count = itemT.count or 1
        
        if itemT.itemAID then
            local potionT = potions_getPotionT(itemT.itemAID)
            if potionT then itemName = potionT.name end
        end
        
        if i > 1 then
            answerMsg = answerMsg.." and "..count.." "..itemName
        else
            answerMsg = answerMsg..count.." "..itemName
        end
    end
    return answerMsg
end

function autoConfigureCollectingMission()
    local configKeys = {"name", "msg", "question", "completeMsg", "missionSV", "allSV", "bigSV", "setSV", "addRep", "rewardExp", "rewardItems", "closeWindow", "skipMissionStart", "items", "level", "addProfessionExp"}

    local function missingError(missingKey, errorMsg) return print("ERROR - missing value in "..errorMsg..missingKey) end

    local function checkItemList(itemList)
        if not itemList then return end
        if itemList.itemID then return {itemList} end
        return itemList
    end
    
    for npcName, allMissionT in pairs(npcMissions) do
        local errorMsg = "npcMissions["..npcName.."]"
        
        if not isInArray(npc_conf.allNpcNames, npcName) then return print("ERROR - npc ["..npcName.."] does not exist in game or not registered correctly "..errorMsg) end
        
        for i, missionT in pairs(allMissionT) do
            local errorMsg = errorMsg.."["..i.."]"
            for key, v in pairs(missionT) do
                if not isInArray(configKeys, key) then return print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end
            if not missionT.missionSV then return missingError("missionSV", errorMsg) end
            if not missionT.items then return missingError("items", errorMsg) end
            if not missionT.name then return missingError("name", errorMsg) end
            
            missionT.items = checkItemList(missionT.items)
            missionT.rewardItems = checkItemList(missionT.rewardItems)
            
            if not missionT.skipMissionStart then
                if missionT.msg then
                    if type(missionT.msg) == "string" then missionT.msg = {missionT.msg} end
                elseif not missionT.question then
                    missionT.question = "You need any help?"
                    missionT.answer = {createCustomText(missionT.items, "Help me gather: "), createCustomText(missionT.rewardItems, "In return I give you: ")}
                end
            end
            if type(missionT.completeMsg) == "string" then missionT.msg = {missionT.doAction} end
            if not missionT.level then missionT.level = 1 end
            missionT.npcName = npcName
        end
    end
    return true
end

function npcSystem_loadMissions()
    if not autoConfigureCollectingMission() then return end
    local allNpcT = {}
    local loopID = 0

    local function create_takeMission(missionT, npcName)
        if missionT.skipMissionStart then return end
        local npcT = allNpcT[npcName]
        local allSVT = missionT.allSV
        
        if not allSVT then
            allSVT = {[missionT.missionSV] = -1}
        else
            allSVT[missionT.missionSV] = -1
        end
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = missionT.question,
            msg = missionT.msg,
            allSV = allSVT,
            bigSV = missionT.bigSV,
            level = missionT.level,
            setSV = {[missionT.missionSV] = 0},
            answer = missionT.answer,
        }
    end
    
    local function create_checkMission(missionT, npcName)
        local npcT = allNpcT[npcName]
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = "What do i need for "..missionT.name.."?",
            allSV = {[missionT.missionSV] = 0},
            moreItemsF = missionT.items,
            answer = createCustomText(missionT.items, "You need: ").." for "..missionT.name,
        }
    end
    
    local function create_completeMission(missionT, npcName)
        local npcT = allNpcT[npcName]
        local thankOptions = {"Thank you these item will come handy.", "Oh my, I was waiting for these items.", "FINALLY!"}
        local thankSTR = randomValueFromTable(thankOptions)
        local setSVT = missionT.setSV
        
        if not setSVT then
            setSVT = {[missionT.missionSV] = 1}
        else
            setSVT[missionT.missionSV] = 1
        end
        
        loopID = loopID + 1
        npcT[loopID] = {
            question = "I have completed "..missionT.name,
            moreItems = missionT.items,
            allSV = {[missionT.missionSV] = 0},
            addRep = missionT.addRep,
            rewardExp = missionT.rewardExp,
            addProfessionExp = missionT.addProfessionExp,
            rewardItems = missionT.rewardItems,
            removeItems = missionT.items,
            setSV = setSVT,
            answer = {thankSTR},
        }
    end

    local function registerToQuestlog(missionT)
        local textT = missionT.msg or {}
        if type(textT) ~= "table" then textT = {textT} end
        table.insert(textT, createCustomText(missionT.items, "Help "..missionT.npcName.." gather: "))

        local questT = {
            questSV = missionT.missionSV,
            trackerSV = missionT.missionSV,
            category = "mission",
            name = missionT.name,
            log = {[0] = textT},
        }
        central_register_questLog(questT)
    end

    for npcName, allMissionT in pairs(npcMissions) do
        allNpcT[npcName] = {}
        
        for _, missionT in pairs(allMissionT) do
            registerToQuestlog(missionT)
            create_takeMission(missionT, npcName)
            create_checkMission(missionT, npcName)
            create_completeMission(missionT, npcName)
        end
    end
    central_register_npcChat(allNpcT)
    npcChat_configurationCheck()
end