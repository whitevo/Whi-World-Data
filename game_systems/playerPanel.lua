--[[ playerPanelConf guide
    choiceT = {
        [_] = {                             choiceID
            godSV = {[SV] = INT},           if any of these storage value match, no need other requirements
            bigSV = {[SV] = INT},           storage value needs to be >= INT
            allSV = {[SV] = INT},           storage value needs to be == INT
            reqStr = STR                    function str for any custom requirements | _G[t.reqStr](player, target)
            name = STR,                     choice name | can be function name
            lookingSelf = true              this choice appear when looking yourself
            lookingTarget = false           this choice appears when looking target
            funcStr = STR                   function str which will be executed when chosen
        }
    }
]]

playerPanelConf = {
    choiceT = {
        {name = "Config", funcStr = "config_createMW"},
        {name = "Questlog", funcStr = "questlog_createProgressLogMW"},
        {name = "duration buffs", funcStr = "durationBuffs_createMW", reqStr = "hasDurationBuffs"},
        {
            name = "check stats",
            funcStr = "playerPanel_displayeStats",
            godSV = {[SV.tutorial] = 1},
            bigSV = {[SV.tutorialTracker]=44},
            lookingTarget = true,
        },
        {
            name = "Skilltree",
            funcStr = "skillTree_createMW",
            godSV = {[SV.tutorial] = 1},
            bigSV = {[SV.tutorialTracker]=48},
        },
        {
            name = "Spellbook",
            funcStr = "spellBook_createMW",
            godSV = {[SV.tutorial] = 1},
            bigSV = {[SV.tutorialTracker]=37},
        },
        {name = "Reputation", funcStr = "reputation_createMW", allSV = {[SV.tutorial] = 1}},
        {name = "teleport list", funcStr = "playerTeleport_createMW", reqStr = "hasTeleports"},
        {name = "professions", funcStr = "professions_createMW", allSV = {[SV.tutorial] = 1}},
        {name = "profession levels", funcStr = "professions_showAll", allSV = {[SV.tutorial] = 1}, lookingSelf = false, lookingTarget = true},
        {name = "invite to party", funcStr = "inviteToParty", reqStr = "canInviteToParty", lookingSelf = false, lookingTarget = true},
        {name = "Join their party", funcStr = "addMemberToParty", reqStr = "canJoinParty", lookingSelf = false, lookingTarget = true},
        {
            name = "Keychain",
            funcStr = "keys_createMW",
            godSV = {[SV.tutorial] = 1},
            bigSV = {[SV.tutorialTracker]=16},
        },
        {name = "speedBall minigame points", funcStr = "playerPanel_showMiniGamePoints", reqStr = "hasSpeedBallPoints"},
        {name = "spells", funcStr = "spells_showTargetSpellList", lookingSelf = false, lookingTarget = true},
        {name = "Look gear", funcStr = "lookGearFeatureError", lookingSelf = false, lookingTarget = true},
        {name = "request duel", reqStr = "duel_playerPanel_requestDuel", funcStr = "duel_tryRequest", lookingSelf = false, lookingTarget = true},
        {name = "accept duel", reqStr = "duel_playerPanel_acceptDuel", funcStr = "duel_start", lookingSelf = false, lookingTarget = true},
        {name = "cancel duel request", reqStr = "duel_playerPanel_cancelRequest", funcStr = "duel_cancelRequest", lookingSelf = false, lookingTarget = true},
    }
}

local feature_playerPanel = {
    startUpFunc = "playerPanel_startUp",
    modalWindows = {
        [MW.playerPanel] = {
            name = "playerPanel_MWName",
            title = "Choose interaction option.",
            choices = "playerPanel_createChoices",
            buttons = {[100] = "choose", [101] = "close"},
            save = "playerPanel_MWSave",
            func = "playerPanel_handleMW",
        }
    }
}

centralSystem_registerTable(feature_playerPanel)

function playerPanel_startUp()
    for choiceID, t in pairs(playerPanelConf.choiceT) do
        if t.lookingSelf == nil then t.lookingSelf = true end
    end
    print("playerPanel_startUp()")
end

function playerPanel_MWName(player, target)
    local onlineTime = target:getOnlineTime()
    local timeText = getTimeText(onlineTime)
    return "["..target:getLevel().."] "..target:getName().." - "..target:getVocation():getName().." - online time: "..timeText
end

function playerPanel_MWSave(player, target) return target:getId() end

function playerPanel_createChoices(player, target)
    local lookingSelf = player:getId() == target:getId()
    local choiceT = {}
    
    local function addChoice(choiceID, t)
        if lookingSelf and not t.lookingSelf then return end
        if not lookingSelf and not t.lookingTarget then return end

        if not t.godSV or not compareSV(player, t.godSV, "==") then
            if not compareSV(player, t.allSV, "==") then return end
            if not compareSV(player, t.bigSV, ">=") then return end
            if t.reqStr and not _G[t.reqStr](player, target) then return end
        end
        choiceT[choiceID] = t.name
    end

    for choiceID, t in ipairs(playerPanelConf.choiceT) do addChoice(choiceID, t) end
    return choiceT
end

function playerPanel_handleMW(player, mwID, buttonID, choiceID, targetID)
    if mwID ~= MW.playerPanel then return end
    if buttonID == 101 then return end
    local target = Player(targetID)
    if not target then return end
    
    local choiceT = playerPanelConf.choiceT[choiceID]
    if not choiceT then return print("ERROR in playerPanel_handleMW - how did that even happen: "..choiceID) end
    return _G[choiceT.funcStr](player, target)
end

function lookGearFeatureError(player, target)
    player:createMW(MW.playerPanel, target)
    player:sendTextMessage(ORANGE, "look gear feature will come with OTC on patch 0.2+")
end

function playerPanel_displayeStats(player, target) return target:getId() == player:getId() and player:displayStats() or player:displayStats(target) end

function playerPanel_showMiniGamePoints(player)
    player:createMW(MW.playerPanel, player)
    player:sendTextMessage(ORANGE, "speedball minigame points: "..getSpeedBallPoints(player))
end

print("playerPanel loaded..")