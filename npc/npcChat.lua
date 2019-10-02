local recentQuestionT = {} -- [playerID] = {[chatID] = os.time() + chatT.secTime}

function npcChat_insertConvo(chatGroupName, message, participants)
    if not npcConv_conf.chatGroups[chatGroupName] then npcConv_conf.chatGroups[chatGroupName] = {} end
    local chatGroup = npcConv_conf.chatGroups[chatGroupName]
    local participants = chatGroup.participants or participants
    if not participants then return print("ERROR npcChat_insertConvo - missing participants") end
    
    local tempChatT = addMsgDelayToMsgT({message})
    local sortedKeys = sorting(tempChatT, "low")
    local newChatT = {}
    local starterTurnToTalk = true
    
    for _, delayK in ipairs(sortedKeys) do
        local msg = tempChatT[delayK]
        
        if starterTurnToTalk then
            newChatT[delayK] = msg
            starterTurnToTalk = false
        else
            newChatT[delayK+1] = msg
            starterTurnToTalk = true
        end
    end
    
    local convoID = tableCount(chatGroup.convos) + 1
    while chatGroup.convos[convoID] do convoID = convoID + 1 end
    chatGroup.convos[convoID] = newChatT
end

function npcChat_createButtons(player, npc)
    local npcName = npc:getName():lower()
    local shopList = shopSystem_getShopList(player, npcName)
    local playerLevel = player:getLevel()
    local buttons = {}

    local function buttonAllowed(buttonT)
        if not buttonT.buttonText then return end
        if buttonT.npcName and buttonT.npcName ~= npcName then return end
        if buttonT.level and buttonT.level > playerLevel then return end
        if buttonT.allSV then
            for sv, v in pairs(buttonT.allSV) do
                if getSV(player, sv) ~= v then return end
            end
        end
        return true
    end

    buttons[100] = "ask/say"
    if tableCount(shopList) > 0 then buttons[102] = "trade" end
    
    for buttonID, buttonT in pairs(npc_conf.npcButtons) do
        if buttonAllowed(buttonT) then buttons[buttonID] = buttonT.buttonText end
    end
    
    -- perhaps move these special functionalities also under npc file
    if npcName == "niine" then
        player:addHealth(5000)
        player:addMana(5000)
        player:getPosition():sendMagicEffect(13)
        removeSV(player, SV.armorUpSpell)
    elseif npcName == "bum" then
        for slot, tokenT in pairs(equipmentTokens) do
            if player:getItem(tokenT.itemID, tokenT.itemAID) then
                buttons[111] = "upgrade" break
            end
        end
    end
    
    if tableCount(buttons) < 4 then buttons[101] = "bye" end
    return buttons
end

function anySV_findMatch(player, anySVT)
    for sv, valueT in pairs(anySVT) do
        if type(valueT) ~= "table" then valueT = {valueT} end
        for _, v in ipairs(valueT) do
            if getSV(player, sv) == v then return true end
        end
    end
end

local function npcChat_canAsk(player, t)
    local function askTimePassed()
        local recentQuestions = recentQuestionT[player:getId()]
        if not recentQuestions then return true end
        local nextAskTime = recentQuestions[t.chatID] or 0
        if os.time() > nextAskTime then return true end
    end
    
    if not askTimePassed() then return end
    if t.level and t.level > player:getLevel() then return end
    if not compareSV(player, t.allSV, "==") then return end
    if t.anySV and not anySV_findMatch(player, t.anySV) then return end
    if t.anySVF and anySV_findMatch(player, t.anySVF) then return end
    if not compareSV(player, t.bigSV, ">=") then return end
    if not compareSV(player, t.bigSVF, "<") then return end
    if not player:hasItems(t.moreItems, t.removeOnly1) then return end
    if t.moreItemsF and player:hasItems(t.moreItemsF, t.removeOnly1) then return end
    if t.checkFunc and not _G[t.checkFunc](player) then return end
    return true
end

function npcChat_createChoices(player, npc)
    local chatT = getNpcChatT(npc)
    local choiceID = 0
    local choiceT = {}

    for chatID, t in pairs(chatT) do
        choiceID = choiceID + 1
        if npcChat_canAsk(player, t) then
            if t.msg then
                npcChat_executeFeatures(player, npc, t)
            else
                local displayMsg = t.question
                if not displayMsg then displayMsg = t.action end
                choiceT[choiceID] = displayMsg
            end
        end
    end
    
    if choiceID > 250 then print("ERROR - there is too too many questions for npc "..npc:getName()) end
    return choiceT
end

local function npcChat_registerRecentQuestion(player, chatT)
    local playerID = player:getId()
    local t = recentQuestionT[playerID]
    local chatID = chatT.chatID
    local nextAllowedAskTime = os.time() + chatT.secTime

    if not t then recentQuestionT[playerID] = {[chatID] = nextAllowedAskTime} return end
    t[chatID] = nextAllowedAskTime
end

function npcChat_getNpcName(player, npc) return npc:getName() end
function npcChat_saveMWParam(player, npc) return npc:getName():lower() end

function npc_chat(player, npc)
    local npcName = npc:getName()
        
    if npcName == "maya" then return player:sendTextMessage(GREEN, "There is no need to talk with maya") end
    if not getNpcChatT(npc) then return player:sendTextMessage(GREEN, npcName.." is not updated yet") end
    player:say("*talking with "..npcName.."*", ORANGE)
    tonkaHerbs_notification(player)
    return player:createMW(MW.npc, npc)
end

local function npcChat_handleButtons(player, buttonID)
    if buttonID == 100 then return end
    if buttonID == 101 then return true end
    local buttonT = npc_conf.npcButtons[buttonID]
        
    if not buttonT then return true, print("ERROR - unknown buttonID["..buttonID.."] in npcChat_handleButtons()") end
    _G[buttonT.func](player, modalWindow_savedDataByPid[player:getId()])
    return true
end

function npcChat_chatMW(player, mwID, buttonID, choiceID)
    local playerID = player:getId()
    local npcName = modalWindow_savedDataByPid[playerID]
    if not npcName then return print("ERROR - somehow there is no npc name in npcChat_chatMW()")end
    if npcChat_handleButtons(player, buttonID) then return end
    if choiceID == 255 then return end
    local npc = Creature(npcName)
    if not npc then return end
    local chatT = getNpcChatT(npc)
    local loopID = 0

    for chatID, t in pairs(chatT) do
        loopID = loopID + 1
        if loopID == choiceID then return npcChat_executeFeatures(player, npc, t) end
    end
end

local function npcChat_feature_checkShop(player, npc)
    local npcName = npc:getRealName():lower()
    local shopList = shopSystem_getShopList(player, npcName)
    local shopListCount = tableCount(shopList)
    
    local function checkShop(playerID, npcName, countBefore)
        local player = Player(playerID)
        if not player then return end
        local shopList = shopSystem_getShopList(player, npcName)
        local shopListCount = tableCount(shopList)
        if countBefore < shopListCount then player:sendTextMessage(ORANGE, npcName.." shop list got updated") end
    end
    addEvent(checkShop, 500, player:getId(), npcName, shopListCount)
end

function npcChat_executeFeatures(player, npc, t)
    local npcName = npc:getName()
    
    npcChat_feature_checkShop(player, npc)
    npcChat_registerRecentQuestion(player, t)
    if t.question then player:sendTextMessage(ORANGE, "You: "..t.question) end
    if t.doAction then for _, msg in ipairs(t.doAction) do player:sendTextMessage(ORANGE, msg) end end
    if t.msg then for _, msg in ipairs(t.msg) do player:sendTextMessage(BLUE, npcName..": "..msg) end end
    if t.answer then for _, msg in ipairs(t.answer) do player:sendTextMessage(BLUE, npcName..": "..msg) end end
    if t.actionAnswer then for _, msg in ipairs(t.actionAnswer) do player:sendTextMessage(BLUE, msg) end end
    setSV(player, t.setSV)
    addSV(player, t.addSV)
    player:removeItemList(t.removeItems, t.removeOnly1)

    if t.rewardExp then
        player:addExpPercent(t.rewardExp)
        spiralEffect(player:getPosition(), 4, 38)
    end

    if t.addProfessionExp then
        for professionStr, amount in pairs(t.addProfessionExp) do
            professions_addExp(player, amount, professionStr)
            player:sendTextMessage(ORANGE, "you earned "..amount.." experience towards "..professionStr.." profession")
        end
    end

    if t.addRep then for npcName, amount in pairs(t.addRep) do addRep(player, amount, npcName) end end
    player:rewardItems(t.rewardItems, true)
    activateFunctionStr(t.funcSTR, player, npc)
    if t.teleport then return teleport(player, Position(t.teleport)) end
    if not t.closeWindow and not t.funcSTR then player:createMW(MW.npc, npc) end
end

function npcConv_talk(npc)
    local npc = Creature(npc)
    if not npc then return end

    local groupList = npcConv_getGroups(npc)
    if tableCount(groupList) == 0 then return end

    local npcPos = npc:getPosition()
    local nearbyPositions = getAreaPos(npcPos, areas["5x5_0"])
    local nearbyNPCT = findFromPos("npc", nearbyPositions)
    if tableCount(nearbyNPCT) == 0 then return end
    
    local randomNpcID = randomValueFromTable(nearbyNPCT)
    local npc2 = Creature(randomNpcID)
    local groupList2 = npcConv_getGroups(npc2)
    local groupID = getSameTableValue(groupList, groupList2)
    if not groupID then return end

    local groupT = npcConv_getGroupT(groupID)
    local convoID = randomKeyFromTable(groupT.convos, groupT.talkedConvoIDT)
    if not convoID then
        Uprint(groupT, "groupT")
        groupT.talkedConvoIDT = {}
        return print("ERROR in npcConv_talk talkedConvoIDT was not reset iteration before")
    end
    
    if groupT.toDelete then
        groupT.convos[convoID] = nil
    else
        local nextKeyID = #groupT.talkedConvoIDT + 1
        if nextKeyID >= tableCount(groupT.convos) then groupT.talkedConvoIDT = {} else groupT.talkedConvoIDT[nextKeyID] = convoID end
        groupT.nextChatTime = os.time() + groupT.chatCD
    end

    local convT = groupT.convos[convoID]
    local npcID = npc:getId()
    
    for delay, text in pairs(convT) do
        local delayStr = tostring(delay)
        local strL =  string.len(delayStr)
        local talkerID =  tonumber(string.sub(delayStr, strL, strL)) == 1 and randomNpcID or npcID
        addEvent(creatureSay, delay, talkerID, text)
    end
end

-- get functions
function getNpcChatT(npc)
    if type(npc) == "string" then return npc_conf.npcChatT[npc] end
    return npc_conf.npcChatT[npc:getName():lower()]
end

function npcConv_getGroupT(groupID) return npcConv_conf.chatGroups[groupID] end

function npcConv_getGroups(npc)
    local npcName = npc:getRealName()
    local currentTime = os.time()
    local groupNameT = {}
    
    for groupName, groupT in pairs(npcConv_conf.chatGroups) do
        if currentTime > groupT.nextChatTime and isInArray(groupT.participants, npcName) then table.insert(groupNameT, groupName) end
    end
    return groupNameT
end

-- other functions
function npcChat_configurationCheck()
    local configKeys = {"msg", "question", "action", "doAction", "answer", "actionAnswer", "secTime", "anySV", "anySVF", "allSV", "bigSV", "bigSVF", "level", "checkFunc", "moreItems", "moreItemsF", "removeItems", "removeOnly1", "rewardItems", "setSV", "addSV", "teleport", "addRep", "rewardExp", "closeWindow", "funcSTR", "addProfessionExp", "chatID"}

    local function missingError(missingKey, errorMsg) print("ERROR - missing value in "..errorMsg..missingKey) end
    local function checkItemList(itemList)
        if not itemList then return end
        if itemList.itemID then return {itemList} end
        return itemList
    end
    
    for npcName, allChatT in pairs(npc_conf.npcChatT) do
        for chatID, chatT in pairs(allChatT) do
            local errorMsg = "npc_conf.npcChatT["..npcName.."]["..chatID.."]."
            if not isInArray(npc_conf.allNpcNames, npcName) then print("ERROR - npc ["..npcName.."] does not exist in game or not registered correctly "..errorMsg) end
            for key, v in pairs(chatT) do
                if not isInArray(configKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end
            if chatT.action and not chatT.doAction then missingError("doAction", errorMsg) end
            if type(chatT.msg) == "string" then chatT.msg = {chatT.msg} end
            if type(chatT.doAction) == "string" then chatT.doAction = {chatT.doAction} end
            if type(chatT.answer) == "string" then chatT.answer = {chatT.answer} end
            if type(chatT.actionAnswer) == "string" then chatT.actionAnswer = {chatT.actionAnswer} end
            if not chatT.secTime then chatT.secTime = 30 end
            chatT.moreItems = checkItemList(chatT.moreItems)
            chatT.moreItemsF = checkItemList(chatT.moreItemsF)
            chatT.removeItems = checkItemList(chatT.removeItems)
            chatT.rewardItems = checkItemList(chatT.rewardItems)
            chatT.chatID = chatID
        end
    end
end

function npcConv_startUp()
    local currentTime = os.time()
    
    for groupName, groupT in pairs(npcConv_conf.chatGroups) do
        if not groupT.chatCD then groupT.chatCD = 180 end
        groupT.nextChatTime = currentTime + groupT.chatCD
        groupT.talkedConvoIDT = {}

        for chatID, chatT in pairs(groupT.convos) do
            local tempChatT = addMsgDelayToMsgT(chatT)
            local sortedKeys = sorting(tempChatT, "low")
            local newChatT = {}
            local starterTurnToTalk = true
            
            for _, delayK in ipairs(sortedKeys) do
                local msg = tempChatT[delayK]
                
                if starterTurnToTalk then
                    newChatT[delayK] = msg
                    starterTurnToTalk = false
                else
                    newChatT[delayK+1] = msg
                    starterTurnToTalk = true
                end
            end
            groupT.convos[chatID] = newChatT
        end
    end
end

function central_register_npcChat(npcT)
    if not npcT then return end
    
    for npcName, allChatT in pairs(npcT) do
        if not npc_conf.npcChatT[npcName] then
            if isInArray(npc_conf.allNpcNames, npcName) then print("no need npc: "..npcName.." in allNpcNames table") end
            npc_conf.npcChatT[npcName] = {}
        end
        if not isInArray(npc_conf.allNpcNames, npcName) then table.insert(npc_conf.allNpcNames, npcName) end

        local global_npc_allChatT = npc_conf.npcChatT[npcName]
        
        for _, chatT in pairs(allChatT) do
            local newChatID = #global_npc_allChatT + 1
            if newChatID == 254 then print("ERROR in central_register_npcChat - "..npcName.." chatID has reached to maximum value!!") end
            global_npc_allChatT[newChatID] = chatT
        end
    end
    if check_central_register_npcChat then print("central_register_npcChat") end
end