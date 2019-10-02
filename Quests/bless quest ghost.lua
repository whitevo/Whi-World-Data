local AIDT = AID.quests.ghostBless
local confT = {
    exp = 25,
    dogStatueID = 1450,
    totalStatueAmount = 4   -- last dog statue which completes quest
}

local function questLog_log()
    local function logMsg(amount) return "Obtain "..amount.." more auras from diffrent ghost room dog statues, to obtain a bless" end

    local logT = {}
    for x=0, confT.totalStatueAmount-1 do logT[x] = logMsg(confT.totalStatueAmount-x) end
    return logT
end

local quest_ghostBless = {
    startUpFunc = "ghostBlessQuest_registerDogStatues",
    
    area = {
        regions = {rootedCatacombsGhostRoom},
        setActionID = {
            [confT.dogStatueID] = AIDT.dogStatue,
            [1590] = AIDT.rail,
        },
    },
    questlog = {
        name = "Ghost Bless Quest",
        questSV = SV.ghostBless_questSV,
        trackerSV = SV.ghostBless_trackerSV,
        log = questLog_log(),
    },
    mapEffects = {
        ["dogStatue"] = {
            posT = {
                {x = 576, y = 711, z = 8},
                {x = 576, y = 743, z = 8},
                {x = 608, y = 711, z = 8},
                {x = 608, y = 743, z = 8},
            },
            me = 13,
        },
    },
    AIDItems_onLook = {
        [AIDT.dogStatue] = {text = {msg = "Gatekeeper statue - dog who sees it all"}},
    },
    AIDItems = {
        [AIDT.rail] = {funcSTR = "ghostBlessQuest_rail"},
        [AIDT.dogStatue] = {funcSTR = "ghostBlessQuest_dogStatue"}
    },
}
centralSystem_registerTable(quest_ghostBless)

function ghostBlessQuest_registerDogStatues()
local area = createAreaOfSquares(rootedCatacombsGhostRoom.area.areaCorners)
local ID = 0 -- corresponds with trackerSV

    local function registerDogStatue(pos)
        local statue = findItem(confT.dogStatueID, pos)
        if not statue then return end
        statue:setText("regID", ID)
        ID = ID + 1
        return true
    end
    
    local function registerObject(pos)
        if registerDogStatue(pos) then return end
    end
    
    for _, pos in pairs(area) do registerObject(pos) end
end

local makeGhost = true
function ghostBlessQuest_dogStatue(player, item)
    if getSV(player, SV.ghostBless_questSV) == 1 then return player:sendTextMessage(GREEN, "You have already completed "..quest_ghostBless.questlog.name) end
    local statueID = item:getText("regID")
    local tracker = getSV(player, SV.ghostBless_trackerSV)
    if tracker > statueID then return player:sendTextMessage(GREEN, "You already have the aura from this statue, find different one") end
    local playerPos = player:getPosition()
    local areaAround = getAreaAround(playerPos)

    if makeGhost then
        for _, pos in pairs(getAreaAround(item:getPosition())) do
            if not Tile(pos):hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then createMonster("ghost", pos) end
        end
        makeGhost = false
        addEvent(function() makeGhost = true end, 15000)
    end
    
    if tracker ~= statueID then
        playerPos:sendMagicEffect(21)
        if tracker == 0 then return player:sendTextMessage(GREEN, "This dog aura doesn't want to attach on you right now") end
        for _, pos in ipairs(areaAround) do doSendDistanceEffect(playerPos, pos, 15) end
        player:sendTextMessage(GREEN, "All the aura you collected so far oozed out of you.")
        player:sendTextMessage(BLUE, "You need to start collecting auras all over again.")
        return player:setSV(SV.ghostBless_trackerSV, 0)
    end
    local statuesLeft = confT.totalStatueAmount - tracker - 1

    playerPos:sendMagicEffect(19)
    player:sendTextMessage(GREEN, "You consumed some of the aura what is oozing from the statue")
    player:sendTextMessage(ORANGE, "Find and touch "..statuesLeft.." more different dog statue"..stringIfMore("s", statuesLeft) .." what has aura")
    if statueID ~= confT.totalStatueAmount - 1 then return addSV(player, SV.ghostBless_trackerSV, 1) end
    player:sendTextMessage(BLUE, "You can now have Ghost bless")
    player:addExpPercent(confT.exp)
    player:removeSV(SV.ghostBless_trackerSV)
    player:setSV(SV.ghostBless_questSV, 1)
    questSystem_completeQuestEffect(player)
end

function ghostBlessQuest_rail(player, item)
    local questStatus = getSV(player, SV.ghostBless_questSV)

    climbOn(player, item)
    if questStatus == 1 then return end
    player:setSV(SV.ghostBless_trackerSV, 0)
    if questStatus == 0 then return player:sendTextMessage(GREEN, "All the aura you collected so far oozed out of you.") end
    player:sendTextMessage(GREEN, "You started "..quest_ghostBless.questlog.name)
    player:sendTextMessage(ORANGE, "Collect aura from Ghost room dog statues")
    player:setSV(SV.ghostBless_questSV, 0)
    questSystem_startQuestEffect(player)
end