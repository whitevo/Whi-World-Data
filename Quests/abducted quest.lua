local rewardExp = 50
local AIDT = AID.quests.abducted

quest_abducted = {
    startUpFunc = "abductedQuest_startUp",

    questlog = {
        name = "Abducted Quest",
        questSV = SV.BM_Quest_abducted,
        trackerSV = SV.BM_Quest_abducted_tracker,
        log = {[0] = "Escort Maya to Peeter."},
    },
    npcChat = {
        ["peeter"] = {
            [1] = {
                question = "Want me to find Bob too?",
                allSV = {[SV.BM_Quest_abducted] = 1},
                answer = {"That would be nice.", "Whitevo here xD | That bob finding quest wont come any time soon. It will come with final Bandit Mountain area: Hehemi Training Grounds"},
            },
        }
    },
    AIDItems = {
        [AIDT.tentEntrance] = {funcSTR = "abductedQuest_start"},
    },
    AIDItems_onLook = {
        [AIDT.tentEntrance] = {funcSTR = "abductedQuest_lookTent"},
        [AIDT.tent] = {funcSTR = "abductedQuest_lookTent"},
    },
    AIDTiles_stepOut = {
        [AIDT.mayaHoldTile] = {funcSTR = "abductedQuest_mayaHoldTile"},
    },
    monsters = {
        ["bamboo wall"] = {
            name = "bamboo wall",
            race = "object",
            spawnEvents = {onHealthChange = {"abductedQuest_bambooWallDamage"}},
        },
    },
    monsterResistance = {
        ["bamboo wall"] = {PHYSICAL = -60},
    },
}
centralSystem_registerTable(quest_abducted)

local abductedQuest_archanosStage = 1
local abductedQuest_trapActivated = false
local abductedQuest_trapCompletedBool = false

function abductedQuest_resetMaya()
    abductedQuest_trap(true)
    removeCreature("maya")
end

function abductedQuest_startUp()
    local msgT = addMsgDelayToMsgT(abductedQuest_msgT)
    local highestDelay = 0 

    for delay, msg in pairs(msgT) do
        if delay > highestDelay then highestDelay = delay end
    end
    abductedQuest_msgT = msgT
    abductedQuest_msgTEndTime = highestDelay
end

function abductedQuest_start(player)
    if getSV(player, SV.BM_Quest_abducted) == 1 then return player:sendTextMessage(GREEN, "You have already completed Abducted Quest") end
    if Creature("maya") then return player:sendTextMessage(GREEN, "There is nobody in tent") end
    local missingMembers = checkPartyDistanceFromPlayer(player, 6)
    if missingMembers then return player:sendTextMessage(GREEN, "Can't start 'abucted quest' because some of the party members are too far: "..missingMembers) end
    
    local partyMembers = getPartyMembers(player)
    local npc = createNpc({name = "maya", npcPos = {x = 407, y = 617, z = 6}})
    local npcID = npc:getId()
    local npcT = getNpcT(npc)

    abductedQuest_trapCompletedBool = false
    npcT.followTargetID = player:getId()
    registerEvent(npc, "onThink", "abductedQuest_npcAI")
    addEvent(creatureSay, 1500, npcID, "Help me to get to my uncle Peeter, he is somewhere near the right side of this whole mountain", YELLOW)
end

function abductedQuest_lookTent(player, item)
    if not Creature("maya") then return player:sendTextMessage(GREEN, "There seems to be someone in this tent") end
    return player:sendTextMessage(GREEN, "This tent seems to be empty")
end

function abductedQuest_npcAI(npc)
    local npcT = getNpcT(npc)
    local player = Player(npcT.followTargetID)

    if not player then return abductedQuest_resetMaya() end
    if not npcT.secretHint and math.random(1, 500) == 1 then
        npc:say("Btw, there are still Wyrens living on top of this mountain (not yet added to game doe)", YELLOW)
        npcT.secretHint = true
    end
    if abductedQuest_ambush(player, npc) then return end
    abductedQuest_complete(player, npc)
end

local bossPos = {x = 428, y = 587, z = 6}
function abductedQuest_ambush(player, npc)
    local npcT = getNpcT(npc)
    if abductedQuest_trapCompletedBool then return end
    if abductedQuest_trapActivated then return true end

    local npcPos = npc:getPosition()
    local upCorner = {x = 416, y = 585, z = 6}
    local downCorner = {x = 425, y = 588, z = 6}
    if not isInRange(npcPos, upCorner, downCorner) then return end

    local partyMembers = getPartyMembers(player)
    local trapPos = {x = 420, y = 588, z = 6}
    local npcSafePos = {x = 418, y = 590, z = 6}
    local npcID = npc:getId()

    for guid, pid in pairs(partyMembers) do
        local player = Player(pid)
        local playerPos = player:getPosition()
        if not isInRange(playerPos, upCorner, downCorner) then teleport(player, trapPos) end
    end
    
    abductedQuest_archanosStage = 1
    abductedQuest_trapActivated = true
    abductedQuest_trap()
    addEvent(walkTo, 1500, npcID, npcSafePos, {"solid", "noGround"}, 500)
    addEvent(creatureSay, 1500, npcID, "O my, This does not look good.", YELLOW)
    addEvent(creatureSay, 3000, npcID, "I will chill in this corner until "..player:getName().." handles this situation", YELLOW)
    
    local function createBoss()
        local boss = createMonster("fake archanos", bossPos, false)
        registerEvent(boss, "onThink", "abductedQuest_archanosAI")
    end
    addEvent(createBoss, 5000, "fake archanos", bossPos)
    addEvent(text, 5500, "Do not try to escape with our secrets!!", bossPos)
    return true
end

local wallIDT = {}
function abductedQuest_trap(remove)
local wallPostions = {{x = 416, y = 586, z = 6}, {x = 416, y = 587, z = 6}, {x = 416, y = 588, z = 6}}
local attackableWallPositions = {{x = 426, y = 585, z = 6}, {x = 426, y = 586, z = 6}, {x = 426, y = 587, z = 6}, {x = 426, y = 588, z = 6}}
local wallID = 3435
local monsterName = "bamboo wall"

    if remove then
        for _, pos in pairs(wallPostions) do
            local item = findItem(wallID, pos)
            if item then item:remove() end
        end
        for _, mid in pairs(wallIDT) do
            local monster = Monster(mid)
            if monster then monster:remove() end
        end
        wallIDT = {}
    else
        for _, pos in pairs(wallPostions) do createItem(wallID, pos) end
        for _, pos in pairs(attackableWallPositions) do
            local monster = createMonster(monsterName, pos)
            table.insert(wallIDT, monster:getId())
        end
    end
end

function abductedQuest_mayaHoldTile(creature, tile)
    if not creature:isNpc() then return end
    if not abductedQuest_trapActivated then return end
    bindCondition(creature, "monsterSlow", -1, {speed = -creature:getSpeed()})
    teleport(creature, tile:getPosition(), false)
end

abductedQuest_msgTEndTime = 0
abductedQuest_msgT = {
    "UNCLE!!! Oh my god, you will not believe what happened!",
    "Me and Bob sawed down the big tree to cross over the mountain gap,",
    "But soon after we crossed it, we were ambushed by bandits! :'(",
    "We were captured and taken to the nearby bandit camp, they questioned us and accused us of spying.",
    "Soon after, Bob was taken somewhere else! :<",
    "Shortly after that I was rescued and brought here.",
}
function abductedQuest_complete(player, npc)
local npcPos = npc:getPosition()
local upCorner = {x = 500, y = 586, z = 6}
local downCorner = {x = 504, y = 588, z = 6}
    if not isInRange(npcPos, upCorner, downCorner) then return end
local npcID = npc:getId()
local npcT = getNpcT(npcID)
local npc2 = Creature("peeter")
local targetID = npcT.followTargetID
    
    npc:unregisterEvent("onThink")
    npcT.followTargetID = npc2:getId()
    for delay, msg in pairs(abductedQuest_msgT) do addEvent(creatureSay, delay, npcID, msg) end
    addEvent(abductedQuest_endQuest, abductedQuest_msgTEndTime, targetID)
    return true
end

function abductedQuest_endQuest(pid)
    local player = Player(pid)

    abductedQuest_resetMaya()
    if not player then return end
    local partyMembers = getPartyMembers(player)

    for guid, pid in pairs(partyMembers) do
        local member = Player(pid)
        
        if getSV(member, SV.BM_Quest_abducted) ~= 1 then
            questSystem_completeQuestEffect(member)
            setSV(member, SV.BM_Quest_abducted, 1)
            setSV(member, SV.BM_Quest_abductedTracker, -1)
            member:addExpPercent(rewardExp)
            member:rewardItems({{itemID = gemBagConf.itemID}}, true)
        end
    end
end

function abductedQuest_bambooWallDamage(creature, attacker, primaryDamage, primaryType)
    if primaryType == LD then
        local maxHP = creature:getMaxHealth()
        local HP = creature:getHealth() - primaryDamage
        
        if maxHP/2 > HP then abductedQuest_archanosStage = 2 end
        if HP < 0 then abductedQuest_trapCompleted() end
        return primaryDamage, primaryDamage
    end
    
    primaryDamage = -primaryDamage
    if primaryDamage > 0 then return 0,0 end
    primaryDamage = primaryDamage + monsterResistance(creature, primaryDamage, primaryType)
    
    for _, wallID in pairs(wallIDT) do
        if not attacker then attacker = 0 end
        dealDamage(attacker, wallID, LD, primaryDamage, 27, O_environment)
    end
    return 0, 0
end

local textT = {"Is anyone there?", "hello?", "help?", "hm?"}
local cryForHelpTimes = 0
function abductedQuest_cryForHelp(pos)
    if Creature("maya") then return end
    if not samePositions(pos, {x = 408, y = 617, z = 6}) then return end
local textPos = {x = 406, y = 616, z = 6}
local giveUpTimes = 10
    
    local function stop() cryForHelpTimes = 0 end
    local function helpMsg()
        if Creature("maya") then return stop() end
        if cryForHelpTimes > giveUpTimes then return stop() end
        local randomText = textT[math.random(1, #textT)]
        text(randomText, textPos)
        addEvent(helpMsg, 8000)
    end
    
    text("HEEELP!", textPos)
    addEvent(helpMsg, 8000)
end

local function getPositionsNearWall(area)
local highestXpos = 0
local xT = {}

    for _, pos in pairs(area) do
        if pos.x > highestXpos then highestXpos = pos.x end
    end
    for _, pos in pairs(area) do
        if pos.x == highestXpos then table.insert(xT, pos) end
    end
    return xT
end

local cooldown = 5
local timeLapsed = 0
local msgT = {
    "You thought you could get away so easily, with such important information?",
    "The world is not yet ready to know!",
    "Stupid people could never understand what we are fighting to achieve.",
    "We are not the bad ones!",
    "You shall not escape my amazing trap!",
    "I'm the master of fire, ice and energy! I'm a genius!",
    "Get rekt by my awesome power!",
}
local saidMsgT = {}

function abductedQuest_archanosAI(monster)
    timeLapsed = timeLapsed + 1
    if cooldown ~= timeLapsed then return end
    if not findByName({x = 426, y = 587, z = 6}, "bamboo wall") then return abductedQuest_trapCompleted() end
    local upCorner = {x = 416, y = 585, z = 6}
    local downCorner = {x = 425, y = 588, z = 6}
    local tempArea = createSquare(upCorner, downCorner)
    local area = removePositions(tempArea, "solid")
    local rightEdgeT = getPositionsNearWall(area)
    local monsterPos = monster:getPosition()
    local mid = monster:getId()
    local fieldID = 1495
    local wallArea = removePositions(rightEdgeT, fieldID)
    local pos = randomPos(wallArea)[1]
    local interval = 500
    local times = 5
    local magicEffect = 24
    local distanceEffect = 5
    local attackTime = (times+1)*interval

    timeLapsed = 0
    
    for x=1, times do addEvent(doSendMagicEffect, (x-1)*interval, pos, magicEffect) end
    addEvent(doSendDistanceEffect, attackTime, monsterPos, pos, distanceEffect)
    
    for xMod=0, 4 do
        local pos = {x=pos.x-xMod, y=pos.y, z=pos.z}
        addEvent(createItem, attackTime+(xMod*200), fieldID, pos, 1, AID.other.field_energy, nil, "minDam(100) maxDam(200)")
        addEvent(dealDamagePos, attackTime+(xMod*200), mid, pos, ENERGY, math.random(100,200), 11, O_monster_spells, 12)
        addEvent(removeItemFromPos, attackTime+(cooldown+4)*1000, fieldID, pos)
        addEvent(doSendMagicEffect, attackTime+(cooldown+4)*1000, pos, 12)
    end

    local r = getRandomNumber(1, #msgT, saidMsgT)    
    if r and math.random(1,4) == 1 then
        monster:say(msgT[r], YELLOW)
        table.insert(saidMsgT, r)
    end
    
    if abductedQuest_archanosStage == 1 then return end
    local airPos = {x = 422, y = 578, z = 6} -- distance effect where they will be first shot
    local posT = randomPos(area, 10, true)
    
    for x, areaPos in pairs(posT) do
        local pos = {x=airPos.x+math.random(0, 4), y=airPos.y, z=airPos.z}
        addEvent(doSendDistanceEffect, 200*(x-1), monsterPos, pos, 4)
        for x=0, 1 do addEvent(doSendMagicEffect, 2000+(x*500), areaPos, 37) end
        addEvent(doSendDistanceEffect, 3500+(100*(x-1)), pos, areaPos, 4)
        addEvent(dealDamagePos, 3500+(150*(x-1)), mid, areaPos, FIRE, math.random(150,250), 7, O_monster_spells, 7)
    end
end

function abductedQuest_trapCompleted()
local npcT = getNpcT()
local mid = findCreatureID("monster", bossPos)
local boss = Monster(mid)
local npcID = findCreatureID("npc", {x = 418, y = 590, z = 6})
    
    abductedQuest_trapActivated = false
    addEvent(massRemove, 2001, bossPos, "monster")
    abductedQuest_trap(true)
    abductedQuest_trapCompletedBool = true
    saidMsgT = {}
    timeLapsed = 0
    if npcID then removeCondition(npcID, "monsterSlow") end
    if not boss then return end
    boss:say("No way! Grr.. Have to report it to Borthonos, brb", YELLOW)
    addEvent(TPRune_effects, 2000, mid, bossPos)
end