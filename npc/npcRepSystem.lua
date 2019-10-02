reputationT = { -- key is modal window choice ID
    [1] = {
        name = "dundee",
        occupation = "task master",
        repSV = SV.taskerRep,
        repLSV = SV.taskerRepL,
        dontShopRepIncrease = true,
    },
    [2] = {
        name = "alice",
        occupation = "cook",
        repSV = SV.cookRep,
        repLSV = SV.cookRepL,
    },
    [3] = {
        name = "eather",
        occupation = "tanner",
        repSV = SV.tannerRep,
        repLSV = SV.tannerRepL,
    },
    [4] = {
        name = "niine",
        occupation = "priest",
        repSV = SV.priestRep,
        repLSV = SV.priestRepL,
    },
    [5] = {
        name = "bum",
        occupation = "smith",
        repSV = SV.smithRep,
        repLSV = SV.smithRepL,
        notExist = true,
    },
}

function reputation_createChoices()
    local choiceT = {}

    for choiceID, t in pairs(reputationT) do
        local extraText = ""
        if t.occupation then extraText = " - "..t.occupation end
        choiceT[choiceID] = t.name..extraText
    end
    return choiceT
end

function reputationMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    local repT = getRepT(choiceID) 
    local npcName = repT.name
        
    player:sendTextMessage(BLUE, "--- -- - "..npcName.." reputation - -- ---")
    player:sendTextMessage(ORANGE, "reputation Level = "..getRepL(player, npcName))
    player:sendTextMessage(ORANGE, "reputation experience = ["..getRep(player, npcName).." / 100]")
    return player:createMW(mwID)
end

function addRep(player, addRep, npcName)
    local repT =  getRepT(npcName)
    local currentRep = getRep(player, npcName)
    local newRep = currentRep + addRep
    local msg =  "Your reputation towards "..npcName.." has been "
    local currentRepL = getRepL(player, npcName)
        
    if addRep < 0 then msg = msg.."decreased by "..-addRep else msg = msg.."increased by "..addRep end
    if not repT.dontShopRepIncrease then player:sendTextMessage(ORANGE, msg) end
    
    if newRep >= 100 then
        local positions = getAreaPos(player:getPosition(), areas["5x5_1 circle"])
        addSV(player, repT.repLSV, 1)
        newRep = newRep - 100
        
        for i, posT in pairs(positions) do
            for _, pos in pairs(posT) do
                local randomEffect = math.random(29, 31)
                local randomInterval = math.random(0, 2000)
                addEvent(doSendMagicEffect, randomInterval, pos, randomEffect)
            end
        end
        player:sendTextMessage(ORANGE, "Your reputation level towards "..npcName.." is now: "..currentRepL+1)
        challengeEvent_unlockEventMsg(player, currentRepL+1, npcName)
    elseif newRep < 0 and currentRepL > 0 then
        addSV(player, repT.repLSV, -1)
        newRep = newRep + 100
        player:sendTextMessage(ORANGE, "Your reputation level towards "..npcName.." is now: "..currentRepL-1)
    end
    
    setSV(player, repT.repSV, newRep)
end

function reputation_createMW(player) return player and player:createMW(MW.reputation) end

-- get functions
function getRepT(ID) -- or userData or string
    if tonumber(ID) then return reputationT[ID] end
    local npcName = ID
    if type(ID) == "userdata" then npcName = ID:getRealName() end
    
    for _, repT in pairs(reputationT) do
        if repT.name == npcName then return repT end
    end
end

function getRep(player, npcName)
    local repT = getRepT(npcName)
    if not repT then return Vprint(npcName, "npcName") end
    local reputation = getSV(player, repT.repSV)

    if reputation < 0 then return 0, setSV(player, repT.repSV, 0) end
    return reputation
end

function getRepL(player, npcName)
    local repT = getRepT(npcName)
    local repLevel = getSV(player, repT.repLSV)

    if repLevel < 0 then return 0, setSV(player, repT.repLSV, 0) end
    return repLevel
end

function Player.getRep(player, npcName) return getRep(player, npcName) end
function Player.getRepL(player, npcName) return getRepL(player, npcName) end