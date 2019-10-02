NPCSTATE_FRIENDLY = 1
NPCSTATE_HOSTILE = 2

local npcFollowTargetT = {} -- [creatureID] = npcT

function npcSystem_startUp()
    npcChat_configurationCheck()
    npcShop_startUp()
    npcConv_startUp()
    print("npcSystem_startUp()")
end

-- npc AI
local function npc_cleanTargetList(npc)
    local tokenMonsterFound = false
    
    for _, creatureID in pairs(npc:getTargetList()) do
        local c = Creature(creatureID)
        if c and c:getName() == "Diseased Dan" then tokenMonsterFound = true end
        if c and c:isPlayer() then npc:removeTarget(c) end
    end
    if not tokenMonsterFound then npc:addTarget(Creature("Diseased Dan")) end
end

local function npc_checkHomePos(npc)
    local npcT = getNpcT(npc)
    local npcPos = npc:getPosition()
    local npcArea = npcT.npcArea
    
    if npcArea and not isInRange(npcPos, npcArea.upCorner, npcArea.downCorner) then
        local tpMsgT = {"Well, time to go home!", ":D", "Abra cadabra!"}
        local msg = randomValueFromTable(tpMsgT)  
        npc:say(msg, ORANGE)
        doSendMagicEffect(npcPos, 3)
        doSendMagicEffect(npcT.spawnPos, 11)
        teleport(npc, npcT.spawnPos)
    end
end

local function npc_follow(npc)
    local npcT = getNpcT(npc)
    local followTarget
        
    if npcT.followTargetID then
        if not npcFollowTargetT[npcT.followTargetID] then npcFollowTargetT[npcT.followTargetID] = npcT end
        local target = Creature(npcT.followTargetID)
        if target then followTarget = target end
    elseif npcT.chatTargetID then
        local target = Creature(npcT.chatTargetID)
        if target and getDistanceBetween(npc:getPosition(), target:getPosition()) < 3 then
            followTarget = target
        else
            npcT.chatTargetID = nil
        end
    end
    npc:setFollowCreature(followTarget)
end

function npc_AI(npc)
    cyclopsSabotageQuest_tonkaAI(npc)
    npc_follow(npc)
    npc_cleanTargetList(npc)
    npc_checkHomePos(npc)
    npcConv_talk(npc)
    npc_attack(npc)
end

function npc_attack(npc)
    local spellT = AI_getSpellT(npc)
    if not spellT then return end

    for spellName, globalCdT in pairs(spellT) do
        AI_reverseCooldown(npc, spellName)
        if type(globalCdT) == "table" then
            cdT = globalCdT[npc:getId()]
            if AI_spellUnderCD(spellName, cdT) then AI_customSpell(npc, spellName, cdT) end
        end
    end
end

local disableNpcCreation = {true}
function createNpc(creationT) -- config guide: npc > npcConfig.lua
    if disableNpcCreation[2] then return end
    if disableNpcCreation[1] then
        disableNpcCreation[2] = true
        return print("createNpc() has been disabled")
    end
    
    local npcName = creationT.name
    local spawnPos = creationT.npcPos
    if not spawnPos then return end
    local npc = createMonster(npcName, spawnPos)

    if not npc then return print("ERROR npc ["..npcName.."] was not created") end
    local state = creationT.state or NPCSTATE_FRIENDLY
    local npcID = npc:getId()

    npc:registerEvent("damageSystem")
    registerEvent(npc, "onThink", "npc_AI")
    npc:registerEvent("onDeath")
    npc_conf.npcIDT[npcID] = {state = state, npcID = npcID, npcArea = creationT.npcArea, spawnPos = spawnPos}
    return npc
end

function npcSystem_playerDeath(player)
    local playerID = player:getId()
    local npcT = npcFollowTargetT[playerID]
    if not npcT then return end
    local party = player:getParty()

    npcFollowTargetT[playerID] = nil
    if not party then npcT.followTargetID = nil return end
    local partyMembers = getPartyMembers(player)
    local npc = Creature(npcT.npcID)
    if not npc then return end
    local npcPos = npc:getPosition()

    for guid, pid in pairs(partyMembers) do
        if pid ~= playerID then
            local player = Player(pid)
            
            if player then
                local playerPos = player:getPosition()
                if getDistanceBetween(playerPos, npcPos) < 10 then npcT.followTargetID = pid return end
            end
        end
    end
    npcT.followTargetID = nil
end

-- npc features
function npc_talk(player, npc)
    if getSV(player, SV.npcLookDisabled) == 1 then return end
    local npcName = npc:getName()
    local npcT = getNpcT(npc)

    if not npcT and npcName:lower() ~= "npc" then return end -- tutorial npc    
    if npcT.chatDisabled then return player:sendTextMessage(GREEN, "You see "..npcName) end
    local distance = getDistanceBetween(player:getPosition(), npc:getPosition())

    if distance > 3 then return player:sendTextMessage(GREEN, "Get closer to talk with "..npcName) end
    npcT.chatTargetID = player:getId()
    return npc_chat(player, npc)
end

-- userdata functions
function Monster.isNpc(creature) return getNpcT(creature) end
function Monster.setNpcState(monster, enum) getNpcT(monster).state = enum end

-- get functions
function getNpcT(monster)
    local creature = Creature(monster)
    return creature and npc_conf.npcIDT[creature:getId()]
end