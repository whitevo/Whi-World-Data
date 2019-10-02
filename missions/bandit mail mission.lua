local AIDT = AID.missions.banditMail
local rewardExp = 30

mission_banditMail = {
    startUpFunc = "banditMailMission_registerWagons",
    
    questlog = {
        name = "Bandit Mail Mission",
        questSV = SV.banditMailMission,
        trackerSV = SV.banditMailMissionTracker,
        category = "mission",
        log = {
            [0] = "find something useful from bandit wagons.",
            [1] = "find the use for the key you found from wagon.",
            [2] = "find out what Archanos is hiding here and the use for key.",
            [3] = "take letter to Peeter.",
        },
        hintLog = {
            [1] = {[SV.banditMailMission_keyHint] = "Peeter said a chest was recently brought to north part of mountain."},
            [2] = {[SV.banditMailMission_keyHint] = "Peeter said a chest was recently brought to north part of mountain."},
        },
    },
    deathArea = {{
        upCorner = {x = 505, y = 536, z = 6},
        downCorner = {x = 537, y = 562, z = 6},
        func = "banditMailMission_death",
    }},
    monsters = {
        ["archanos death elemental"] = {name = "Death Elemental", race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
        ["archanos fire elemental"] = {name = "Fire Elemental", race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
        ["archanos ice elemental"] = {name = "Ice Elemental", race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
        ["archanos energy elemental"] = {name = "Energy Elemental", race = "element", spawnEvents = defaultMonsterSpawnEventsSmall},
    },
    monsterResistance = {
        ["archanos death elemental"] = {
            PHYSICAL = 30,
            ICE = 50,
            FIRE = -40,
            ENERGY = 40,
            DEATH = 100,
            HOLY = -100,
        },
        ["archanos fire elemental"] = {
            PHYSICAL = 30,
            ICE = -50,
            FIRE = 100,
            ENERGY = 60,
            DEATH = 60,
        },
        ["archanos ice elemental"] = {
            PHYSICAL = 30,
            ICE = 100,
            FIRE = -50,
            ENERGY = 60,
            DEATH = 60,
        },
        ["archanos energy elemental"] = {
            PHYSICAL = 30,
            ICE = 60,
            FIRE = 60,
            ENERGY = 100,
            DEATH = 60,
            EARTH = -50,
        },
    },
    monsterSpells = {
        ["archanos death elemental"] = {"damage: cd=2000, d=15-40, t=DEATH, r=6, fe=11"},
        ["archanos fire elemental"] = {"damage: cd=2000, d=20-50, t=FIRE, r=4, fe=4"},
        ["archanos ice elemental"] = {"damage: cd=2000, d=25-60, t=ICE, r=4, fe=37"},
        ["archanos energy elemental"] = {"damage: cd=2000, d=30-70, t=ENERGY, r=4, fe=5"},
    },
    AIDTiles_stepIn = {
        [AIDT.bossEncounter] = {funcSTR = "banditMailMission_encounterBoss"},
    },
    AIDItems = {
        [AIDT.letter] = {funcSTR = "banditMailMission_letter"},
        [AIDT.chest] = {funcSTR = "banditMailMission_chest"},
        [AIDT.wagon] = {
            allSV = {[SV.banditMailMissionTracker] = 0},
            funcSTR = "banditMailMission_wagon",
        },
    },
    npcChat = {
        ["peeter"] = {
            [104] = {
                question = "Need any more help?",
                allSV = {[SV.BM_Quest_abducted] = 1, [SV.banditQuest] = 1},
                bigSVF = {[SV.banditMailMission] = 0},
                setSV = {[SV.banditMailMission] = 0, [SV.banditMailMissionTracker] = 0},
                funcSTR = "banditMailMission_giveWagonID",
                answer = {"I heard that some bandits have access to militar intel.", "Search trough bandit wagons to find out more."},
            },
            [105] = {
                question = "I found key from wagons any idea where to use it?",
                allSV = {[SV.banditMailMissionTracker] = 1},
                anySVF = {[SV.banditMailMission_keyHint] = 1},
                setSV = {[SV.banditMailMission_keyHint] = 1},
                answer = {"hmm maybe", "few days ago I did see bandits moving a large chest to north-east part of mountain", "Didn't think much of it, but perhaps it is the one."},
            },
            [106] = {
                question = "I found this letter and weapons from the chest",
                allSV = {[SV.banditMailMissionTracker] = 3, [SV.banditMailMission_openedLetter] = 1},
                moreItems = {{itemID = 2597, itemAID = AIDT.letter}},
                removeItems = {{itemID = 2597, itemAID = AIDT.letter}},
                setSV = {[SV.banditMailMissionTracker] = -1, [SV.banditMailMission] = 1},
                funcSTR = "banditMailMission_complete",
                answer = {"Letter seems to be already opened. *quints eyez on you*", "*Peeter reads letter*", "Uff, This doesn't look good", "alright thanks for help, you can go now"},
            },
            [107] = {
                question = "I found this letter and weapons from the chest",
                allSV = {[SV.banditMailMissionTracker] = 3, [SV.banditMailMission_openedLetter] = -1},
                moreItems = {{itemID = 2597, itemAID = AIDT.letter}},
                removeItems = {{itemID = 2597, itemAID = AIDT.letter}},
                rewardItems = {{itemID = ITEMID.other.coin, count = 40}},
                setSV = {[SV.banditMailMissionTracker] = -1, [SV.banditMailMission] = 1, [SV.banditMailMission_peeterTrust] = 1},
                funcSTR = "banditMailMission_complete",
                answer = {"*Peeter reads letter*", "Uff, This doesn't look good, I need to speak with Dundee", "Thanks for your help"},
            },
            [108] = {
                question = "I found chest in north area there were only weapons",
                allSV = {[SV.banditMailMissionTracker] = 3},
                setSV = {[SV.banditMailMissionTracker] = -1, [SV.banditMailMission] = 1},
                funcSTR = "banditMailMission_complete",
                answer = {"hmm okey, I assumed that much", "oh well, I guess something is cooking, but nothing too dangerous"},
            },
        },
    },
    keys = {
        ["Blue Bandit Key"] = {
            itemAID = AIDT.key,
            removeKey = true,
            keyID = SV.banditMailMission_key,
            keyFrom = "Found from wagon in Bandit Mountain",
            keyWhere = "Used for opening a large chest which is at North-East side of Bandit Mountain",
        },
    },
}
centralSystem_registerTable(mission_banditMail)

local wagonID = 0
function banditMailMission_registerWagons()
    wagonID = 0
    for _, pos in pairs(createAreaOfSquares(banditMountainArea.area.areaCorners)) do banditMailMission_registerWagon(pos) end
end

function banditMailMission_registerWagon(pos)
    local wagon = findItem(8735, pos)
    if not wagon then wagon = findItem(8737, pos) end
    if not wagon then return end

    wagonID = wagonID + 1
    wagon:setActionId(AIDT.wagon)
    wagon:setText("banditMailMission_wagonID", wagonID)
end

function banditMailMission_wagon(player, item)
    local wagonID = getFromText("banditMailMission_wagonID", item:getAttribute(TEXT))
    
    if wagonID == getSV(player, SV.banditMailMission_wagonID) then
        if player:rewardItems({{itemID = 2090, itemAID = AIDT.key}}) then
            setSV(player, SV.banditMailMissionTracker, 1)
        end
    else
        text("** searching wagon **", item:getPosition())
        player:sendTextMessage(GREEN, "You did not find anything useful from this wagon.")
    end
end

function banditMailMission_giveWagonID(player) setSV(player, SV.banditMailMission_wagonID, math.random(1, wagonID)) end

local banditMailMission_elementalCIDT = {}
local function banditMailMission_removeElementals()
    if tableCount(banditMailMission_elementalCIDT) > 0 then
        for _, cid in pairs(banditMailMission_elementalCIDT) do
            local element = Creature(cid)
            
            if element then
                local pos = element:getPosition()
                local name = element:getName()
                
                if name:match("fire") then doSendMagicEffect(pos, 6) end
                if name:match("ice") then doSendMagicEffect(pos, 44) end
                if name:match("energy") then doSendMagicEffect(pos, 31) end
                element:remove()
            end
        end
    end
    banditMailMission_elementalCIDT = {}
end

local palisadePos = {x = 504, y = 548, z = 6}
local palisadeID = 12522
function banditMailMission_encounterBoss(player, item)
    if getSV(player, SV.banditMailMissionTracker) ~= 1 then return end
    local partyMembers = getPartyMembers(player, 20)
    local element = createMonster("archanos death elemental", {x = 515, y = 556, z = 6})
    local boss = createMonster("fake archanos", {x = 514, y = 550, z = 6}, false)

    for guid, playerID in pairs(partyMembers) do
        local member = Player(playerID)
        
        if getSV(member, SV.banditMailMissionTracker) == 1 then setSV(playerID, SV.banditMailMissionTracker, 2) end
        teleport(playerID, item:getPosition())
    end
    banditMailMission_removeElementals()
    createItem(palisadeID, palisadePos)
    banditMailMission_bossAI(boss)
    table.insert(banditMailMission_elementalCIDT, element:getId())
end

local walkDelay = 600
local function archanosEscape(cid)
    local boss = Creature(cid)
    if not boss then return end
    local escapePath = getPath(boss:getPosition(), {x = 516, y = 550, z = 6}, {"solid", "noTile"})
    local escapePath2 = getPath({x = 516, y = 550, z = 6}, {x = 522, y = 545, z = 6}, {"solid", "noTile"})
    local escapePath3 = getPath({x = 522, y = 545, z = 6}, {x = 529, y = 540, z = 6}, {"solid", "noTile"})
    local escapePath4 = getPath({x = 529, y = 540, z = 6}, {x = 535, y = 537, z = 6}, {"solid", "noTile"})
    local finalDelay = 0

    bindCondition(boss, "monsterHaste", -1, {speed = 150})
    for _, pos in pairs(escapePath2) do table.insert(escapePath, pos) end
    for _, pos in pairs(escapePath3) do table.insert(escapePath, pos) end
    for _, pos in pairs(escapePath4) do table.insert(escapePath, pos) end
    table.insert(escapePath, {x = 536, y = 536, z = 6})
    for i, pos in ipairs(escapePath) do
        finalDelay = finalDelay + walkDelay
        addEvent(teleport, i*walkDelay, cid, pos, true)
    end
    addEvent(text, finalDelay+1000, "*click*", {x = 536, y = 535, z = 6})
    addEvent(text, finalDelay+1500, "*rumble*", {x = 536, y = 535, z = 6})
    addEvent(doSendMagicEffect, finalDelay+1500, {x = 536, y = 535, z = 6}, 27)
    addEvent(doSendMagicEffect, finalDelay+1500, {x = 536, y = 536, z = 6}, 7)
    addEvent(removeCreature, finalDelay+1500, cid)
end

local function summonArchanosElementals()
    local firstWavePosT = {{x = 511, y = 549, z = 6}, {x = 512, y = 549, z = 6}, {x = 512, y = 548, z = 6}}
    local secondWavePosT = {{x = 519, y = 549, z = 6}, {x = 520, y = 549, z = 6}, {x = 521, y = 549, z = 6}, {x = 521, y = 548, z = 6}}
    local thirdWavePosT = {{x = 527, y = 541, z = 6}, {x = 528, y = 541, z = 6}, {x = 516, y = 555, z = 6}}
    
    local function summonElement(name, pos)
        local monster = createMonster(name, pos)
        if not monster then return end
        table.insert(banditMailMission_elementalCIDT, monster:getId())
    end
    for _, pos in pairs(firstWavePosT) do summonElement("archanos fire elemental", pos) end
    for _, pos in pairs(secondWavePosT) do addEvent(summonElement, 7000, "archanos ice elemental", pos) end
    for _, pos in pairs(thirdWavePosT) do addEvent(summonElement, 14000, "archanos energy elemental", pos) end
end

function banditMailMission_bossAI(boss)
    if not boss then return print("banditMailMission_bossAI() ERROR - boss was not created") end
    local path = getPath(boss:getPosition(), {x = 511, y = 548, z = 6}, "solid")
    local cid = boss:getId()
    local talkDelay = 500
    
    bindCondition(boss, "monsterHaste", 2500, {speed = 150})
    
    for i, pos in ipairs(path) do
        talkDelay = talkDelay + walkDelay
        addEvent(teleport, i*walkDelay, cid, pos, true)
    end
    
    addEvent(creatureSay, talkDelay, cid, "What The Fuck!?")
    addEvent(creatureSay, talkDelay + 2000, cid, "You again..")
    addEvent(creatureSay, talkDelay + 4000, cid, "Plz just go away already, you don't know what you are doing.")
    addEvent(summonArchanosElementals, talkDelay + 6000)
    addEvent(archanosEscape, talkDelay + 6000, cid)
end

local function secretLoot(player, item)
    local lastUsed = getFromText("lastUsed", item:getAttribute(TEXT))
    local waitTime = 60*60*2 -- 2 hours
    local time = os.time()
    
    if not lastUsed then
        player:sendTextMessage("chest is empty")
        return item:setText("lastUsed", time)
    end
    if lastUsed + waitTime > time then return player:sendTextMessage("chest is empty") end
    player:rewardItems({{itemID = {2190, 2183}, itemText = "randomStats"}}, true)
    item:setText("lastUsed", time)
end

function banditMailMission_chest(player, item)
    massRemove(palisadePos, palisadeID)
    if getSV(player, SV.banditMailMission_key) == 2 then return secretLoot(player, item) end
    if getSV(player, SV.banditMailMissionTracker) ~= 2 then return player:sendTextMessage(GREEN, "Chest is locked") end
    if getSV(player, SV.banditMailMission_key) == -1 then return player:sendTextMessage(GREEN, "You don't have the fitting key in keyring") end
    if not player:rewardItems({{itemID = 2597, itemAID = AIDT.letter}, {itemID = {2190, 2183}, itemText = "randomStats"}}) then return end
    setSV(player, SV.banditMailMission_key, 2)
    setSV(player, SV.banditMailMissionTracker, 3)
    item:setText("lastUsed", os.time())
end

local banditMailMission_letterUsers = {}
function banditMailMission_letter(player, item)
    local playerID = player:getId()

    if not banditMailMission_letterUsers[playerID] then
        player:sendTextMessage(BLUE, "Are you sure you want open this letter? Peeter would notice it.")
        player:sendTextMessage(BLUE, "If you still want to read letter, open(use) letter in next 30 seconds.")
        player:sendTextMessage(GREEN, "*hesitating to open letter*")
        banditMailMission_letterUsers[playerID] = true
        addEvent(setTableVariable, 30*1000, banditMailMission_letterUsers, playerID, nil)
        return true
    end
    
    setSV(player, SV.banditMailMission_openedLetter, 1)
    player:sendTextMessage(ORANGE, "--- letter ---")
    player:sendTextMessage(ORANGE, "Here are some new wands for your mages and druids.")
    player:sendTextMessage(ORANGE, "Make sure they are prepared for war.") -- "btw are you prepared for war?" this question will be asked in boss room if you did open letter
    player:sendTextMessage(ORANGE, "Kind regards, Hehem")
    return true
end

function banditMailMission_complete(player)
    player:sendTextMessage(ORANGE, "--- Bandit Mail Mission completed ---")
    player:addExpPercent(rewardExp)
    questSystem_completeQuestEffect(player:getPosition())
end

function banditMailMission_death(player)
    if getSV(player, SV.banditMailMission) ~= 0 then return end
    if getSV(player, SV.banditMailMissionTracker) == 2 then setSV(player, SV.banditMailMissionTracker, 1) end
    teleport(player, player:homePos())
    massRemove(palisadePos, palisadeID)
    return true
end