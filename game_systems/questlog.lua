--[[ questlog guide
    [_] = {
        questSV = INT,                  -1 = not accepted, 0 = ongoing, 1 = completed
        trackerSV = INT,                starts with 0, keeps track of quest progress
        category = STR or "quest"       what progress category it is | "quest", "mission"
        name = STR                      quest name

        log = {                         general guide for quest
            [INT] = {STR},              INT = tracker value | STR = text what you receive in questlog
        },
        hintLog = {                     extra guides for quest
            [INT] = {                   tracker value
                [INT] = {STR},          INT = storage value what must be 1 | STR = text what you receive in questlog
            }
        },

        AUTOMATIC
        choiceID = INT                  choiceID for modal window
    }
]]

questlog = questlog or {} -- usually registered here trough centralT

local questlogSystem = {
    modalWindows = {
        [MW.progressLog] = {
            name = "Progress",
            title = "Choose a category",
            choices = {
                [1] = "Lore",
                [2] = "Quests",
                [3] = "Missions",
                [4] = "Boss kills",
                [5] = "tasks",
            },
            buttons = {
                [100] = "Choose",
                [101] = "Close",
                [102] = "questlog_showCompletedButton",
            },
            say = "checking progress",
            func = "questlog_progressMW",
        },
        [MW.questlog] = {
            name = "Quests",
            title = "questLog_getQuestMWTitle",
            choices = "questlog_getQuestChoiceT",
            buttons = {[100] = "Choose", [101] = "Back"},
            say = "checking quest log",
            func = "questlog_questlogMW",
        },
        [MW.missionLog] = {
            name = "Missions",
            title = "questLog_getMissionMWTitle",
            choices = "questlog_getMissionChoiceT",
            buttons = {[100] = "Choose", [101] = "Back"},
            say = "checking mission log",
            func = "questlog_questlogMW",
        },
        [MW.bossLog] = {
            name = "Bosses",
            title = "questLog_getBossMWTitle",
            choices = "bossLog_createChoices",
            buttons = {[100] = "Choose", [101] = "Back"},
            say = "checking boss log",
            func = "bossLogMW",
        },
        [MW.taskLog] = {
            name = "Tasks",
            title = "questLog_getTaskMWTitle",
            choices = "taskLog_createChoices",
            buttons = {[100] = "Choose", [101] = "Back"},
            say = "checking task log",
            func = "taskLogMW",
        },
    },
}
centralSystem_registerTable(questlogSystem)
print("questlogSystem loaded..")

function central_register_questLog(questT)
    if not questT then return end
    local function getChoiceID()
        if questT.choiceID then return questT.choiceID end
        choiceID = #questlog + 1
        if choiceID > 250 then print("ERROR in central_register_questLog - choiceID is reaching maximum") end
        questT.choiceID = choiceID
        return choiceID
    end
    
    if not questT.log then return print("ERROR in central_register_questLog - missing logs for "..questT.name) end
    if not questT.category then questT.category = "quest" end

    for tracker, text in pairs(questT.log) do
        if type(text) ~= "table" then questT.log[tracker] = {text} end
    end
    
    if questT.hintLog then
        for tracker, hintT in pairs(questT.hintLog) do
            for tracker, text in pairs(hintT) do
                if type(text) ~= "table" then hintT[tracker] = {text} end
            end
        end
    end
    
    local questID = getChoiceID()
    questlog[questID] = questT
    if check_central_register_questLog then print("central_register_questLog") end
end

function questlog_progressMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return toggleSV(player, SV.showCompletedQuestlog), player:createMW(mwID) end
    if choiceID == 255 then return end
    if choiceID == 1 then return player:createMW(mwID), player:sendTextMessage(BLUE, "this feature can be added only with custom client") end
    if choiceID == 2 then return player:createMW(MW.questlog) end
    if choiceID == 3 then return player:createMW(MW.missionLog) end
    if choiceID == 4 then return player:createMW(MW.bossLog) end
    if choiceID == 5 then return player:createMW(MW.taskLog) end
end

function questlog_questlogMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 or choiceID == 255 then return player:createMW(MW.progressLog) end
    local questT = questlog_getQuestT(choiceID)
    questlog_sendQuestState(player, questT)
    return player:createMW(mwID)
end

function questlog_sendQuestState(player, questT)
    if player:getSV(questT.questSV) == 1 then return player:sendTextMessage(BLUE, "--- "..questT.name.." ---  COMPLETED") end
    local tracker = player:getSV(questT.trackerSV)
    local textLog = questT.log[tracker]
    if not textLog then return print("ERROR in questlog_sendQuestState - missing logs for tracker state ["..tracker.."]") end
    
    player:sendTextMessage(BLUE, "--- "..questT.name.." ---")
    for _, text in ipairs(textLog) do player:sendTextMessage(ORANGE, text) end

    local hintLogT = questT.hintLog and questT.hintLog[tracker]
    if hintLogT then
        for sv, textT in pairs(hintLogT) do
            if player:getSV(sv) == 1 then
                for _, text in ipairs(textT) do player:sendTextMessage(ORANGE, "HINT: "..text) end
            end
        end
    end
end

function questlog_showCompletedButton(player) return "C ["..getButtonState(player, SV.showCompletedQuestlog).."]" end

function bossLogMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 or choiceID == 255 then return player:createMW(MW.progressLog) end
    player:sendTextMessage(BLUE, "What information would you expect to see here, plz let me know?")
    return player:createMW(mwID)
end

function taskLogMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 or choiceID == 255 then return player:createMW(MW.progressLog) end
    local loopID = 0
        
    for monsterName, t in pairs(monsters) do
        local taskT = t.task
        
        if taskT then
            loopID = loopID+1
            if loopID == choiceID then
                local killsLeft = taskT.killsRequired - getSV(player, taskT.storageID)
                player:sendTextMessage(ORANGE, "--- For "..monsterName.." task: You need to kill "..killsLeft.." more ---")
                if killsLeft == 0 then player:sendTextMessage(ORANGE, "Report back to Dundee in Forgotten Village") end
                return player:createMW(mwID)
            end
        end
    end
    
    for herbAID, herbT in pairs(herbs) do
        local stage = getSV(player, herbT.learnedSV)
        loopID = loopID + 1
        
        if loopID == choiceID then
            if stage == 0 then
                if herbT.hintInfo then player:sendTextMessage(ORANGE, "task hint: "..herbT.hintInfo) end
            elseif stage == 1 then
                if herbT.herbHint then player:sendTextMessage(ORANGE, "You now know: "..herbT.herbHint) end
                player:sendTextMessage(ORANGE, "return back to Tonka with the "..herbT.name.." information you discovered")
            end
            return player:createMW(mwID)
        end
    end
end

function bossLog_createChoices(player)
    local choiceT = {}
    local loopID = 0
        
    for AIDT, bossT in pairs(bossRoomConf.bossRooms) do
        if bossT.killSV then
            local bossKilled = getSV(player, bossT.killSV) == 1
            local bossNames = tableToStr(bossT.bossName, " and ")
            loopID = loopID + 1
            
            if not bossKilled then
                choiceT[loopID] = "[not killed] : "..bossNames
            elseif bossKilled and getSV(player, SV.showCompletedQuestlog) ~= 1 then
                choiceT[loopID] = "[killed] : "..bossNames
            end
        end
    end
    return choiceT
end

function taskLog_createChoices(player)
    local choiceT = {}
    local loopID = 0
        
    for monsterName, t in pairs(monsters) do
        local taskT = t.task
        
        if taskT then
            loopID = loopID+1
            if getSV(player, taskT.storageID) >= 0 then
                choiceT[loopID] = "[ongoing] : "..monsterName.." task"
            end
        end
    end
    
    for herbAID, herbT in pairs(herbs) do
        local stage = getSV(player, herbT.learnedSV)
        loopID = loopID + 1
        
        if stage == 0 or stage == 1 then
            choiceT[loopID] = "[ongoing] : looking information for "..herbT.name
        end
    end
    return choiceT
end

function questlog_createProgressLogMW(player) return player:createMW(MW.progressLog) end

-- get functions
function questlog_getQuestT(object)
    if type(object) == "number" then
        if questlog[object] then return questlog[object] end
    end
end

function questLog_getQuestMWTitle(player)
    local completed, total = questLog_getCompleteCount(player, "quest")
    return "You have completed ["..completed.."/"..total.."] quests."
end

function questLog_getMissionMWTitle(player)
    local completed, total = questLog_getCompleteCount(player, "mission")
    return "You have completed ["..completed.."/"..total.."] missions."
end

function questLog_getBossMWTitle(player)
    local completed, total = questLog_getCompleteCount2(player, bossRoomConf.bossRooms, "killSV")
    return "You have killed ["..completed.."/"..total.."] bosses."
end

function questLog_getTaskMWTitle(player)
    local completed, total = questLog_getCompleteCount2(player, monsters, "storageID2", "task")
    return "You have completed ["..completed.."/"..total.."] tasks."
end

function questLog_getCompleteCount2(player, globalTable, SVkey, nextTableKey)
    local completed = 0
    local total = 0
    
    for _, t in pairs(globalTable) do
        local t = not nextTableKey and t or t[nextTableKey]
        
        if t and t[SVkey] then
            total = total+1
            completed = completed + (player:getSV(t[SVkey]) == 1 and 1 or 0)
        end
    end
    return completed, total
end

function questLog_getCompleteCount(player, category)
    local total = 0
    local completed = 0
    
    for questID, questT in pairs(questlog) do
        if not category or questT.category == category then
            total = total+1 
            completed = completed + (player:getSV(questT.questSV) == 1 and 1 or 0)
        end
    end
    return completed, total
end

function questlog_getChoiceT(player, category)
    local choiceT = {}
    local showQuests = getSV(player, SV.showCompletedQuestlog) == -1

    local function addQuest(logT)
        if logT.category ~= category then return end
        local currentQuestStage = getSV(player, logT.questSV)
        if currentQuestStage < 0 then return end
        if currentQuestStage == 1 and not showQuests then return end
        local state = currentQuestStage == 0 and "[ongoing] : " or "[completed] : "
        choiceT[logT.choiceID] = state..logT.name
    end

    for questID, logT in pairs(questlog) do addQuest(logT) end
    if tableCount(choiceT) == 0 and not showQuests then choiceT[255] = "you have no ongoing "..category.."s and you have disabled showing completed "..category.."s" end
    return choiceT
end

function questlog_getQuestChoiceT(player) return questlog_getChoiceT(player, "quest") end
function questlog_getMissionChoiceT(player) return questlog_getChoiceT(player, "mission") end
