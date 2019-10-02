--[[    challenge events config guide
    infoMsgT = {STR}                        messages diaplyd on "info" button
    challengeIDSV = INT                     storage value what keeps track in which event payere currently is
    
    challenges = {
        [INT] = {                           choiceID in modal window and ID for challengeT
            name = STR                      challenge name
            requiredRepL = INT or 1         what dundee reputation required to do bid on challenge
            cost = INT or 0                 how much is base cost for challenge
            waveSV = INT                    storage Value for keeping track how far player has reached with this challenge
            startPositions = {POS,POS,POS}  first positions where players teleport into event
            upCorner = POS
            downCorner = POS
            time = INT or 60                time in seconds how long is base time for each wave.
            waveTime = INT or 10            Bonus time in seconds what is added every wave * amount of payers in team
            clearItems = {INT}              table of ItemID which will be deleted on challengeEvent_clearChallengeArea | hardcoded: "monsters",
            
            monsters = {                    table for the monsters what are going to be used in event
                [STR] = {                   monster name in lower letters
                    startAmount = INT or 1      What is the first amount of monsters what going to be summoned
                    teamAmount = INT or 0       How many monsters added to start Amount for each team member
                    startWave = INT or 1        In what wave the monsters will appear first
                    waveInterval = INT or 1     In how many waves the monster will appear again | 0 == never again
                    amountInterval = INT or 1   In each wave how much is the monster amount changed. | can be floating number | 0 == doesnt change
                    monsterHP = INT         What will be the created monster HP
                    teamHP = INT or 0       How much monster HP is increased for each team member
                    skipWave = {INT}        What waves this monster skips summoning itself
                }
            },
            
            mapFunc = STR                   function name for custom map activity | _G[STR](challengeT)
            stepInDamage = {                item what spawns in room and deals damage when stepped on | refresh every 30 seconds
                itemID = INT
                itemAID = INT
                extraItemT = {INT}          itemIDs what should be removed (incase original itemID changes)
                amount = INT or 1           how many items will spawn in room
                minDam = INT or 10          minimum damage what the object will do when stepped on
                maxDam = INT or 10          maximum damage what the object will do when stepped on
                damType = ENUM or PHYSICAL
                dealEff = ENUM or 3         The type of effect when item deals damage
                spawnEff = ENUM or 3        The type of effect when item pings for spawn (every second total of 5 times)
                removeEff = ENUM or 3       The type of effect when item is removed
            },
            shootingTower = {               towers shoot players
                itemID = INT                item ID near where to projectiles come from (position offset: x-1 and y-1)
                msDelay = INT or 500        deals damage INT amount it has been shot
                interval = INT or 1         in seconds when the tower will shoot again
                minDam = INT or 10
                maxDam = INT or 10
                damType = ENUM or PHYSICAL
                dealEff = ENUM or 3         The type of effect when item deals damage
                distEff = ENUM or 1         The distance effect from point A to B
                
                --automatic
                towerPosT = {POS}           holds the positions of all the towers
                cd = INT                    holds the tower cooldowns
            },
            -- automatic
            monsterNames = {STR}            names of all monsters usd in this challenge
            biggestBid = INT or 0           the biggest bid team holds (biggest bid will get to do the challenge)
            currentWave = INT or 0          how far players are with event (0 means not started)
            addEvents = {INT}               INT = eventID
            challengeID = INT               same INT as the table key
            players = {INT}                 INT = playerID who has bidded or doing the challenge
            area = {POS}                    positions where monsters/items can be created
        }
    }
    -- requiredRepL = INT                   minimum dundee reputation to see challenges
    -- unlockMessageT = {[INT] = STR}       repL = what challenge got unlocked
]]

-- onDeath and onLogOut gotta also do diz > challengeEvent_endChallenge(playerID)

local AIDT = AID.games.challenge
if not challengeConf then
challengeConf = {
    challengeIDSV = SV.challengeID,
    
    infoMsgT = {
        "You will be teleported into room where you have to fight for life against enemies who come in 10 waves",
        "While inside challenge, monsters do not give reputation exp, task kills nor loot",
        "Instead of dieing in challenge you will be teleported back to your home town.",
        "If you join challenge while in party, all the team members have to be near task master, team can have up to 3 members.",
        "The more players in team the more creatures will be spawned each wave.",
        "In the end of challenge, you will be rewarded with gem pouch.",
        "Each challenge has milestone rewards. At wave 4, 8 and 10 player will receive skillpoint once.",
    },
    challenges = {
        [1] = {
            name = "forest challenge",
            cost = 10,
            requiredRepL = 2,
            waveSV = SV.forestChallenge,
            startPositions = {{x = 717, y = 758, z = 7}, {x = 718, y = 758, z = 7}, {x = 719, y = 758, z = 7}},
            upCorner = {x = 710, y = 750, z = 7},
            downCorner = {x = 726, y = 766, z = 7},
            time = 90,
            waveTime = 15,
            
            stepInDamage = {
                itemID = 4208,
                itemAID = AIDT.forestTrap,
                extraItemT = 4209,
                amount = 25,
                minDam = 50,
                maxDam = 80,
                dealEff = 21,
                spawnEff = 17,
                removeEff = 9,
                damType = EARTH,
            },
            shootingTower = {
                itemID = 5390,
                msDelay = 1200,
                interval = 4,
                minDam = 10,
                maxDam = 30,
                distEff = 20,
                dealEff = 21,
                damType = EARTH,
            },
            monsters = {
                ["wolf"] = {
                    startAmount = 3,
                    teamAmount = 2,
                    amountInterval = -1,
                },
                ["deer"] = {
                    startAmount = 2,
                    teamAmount = 2,
                    amountInterval = -1,
                },
                ["boar"] = {
                    teamAmount = 1,
                    amountInterval = 0.5,
                    skipWave = {5, 10}
                },
                ["bear"] = {
                    teamAmount = 1,
                    startWave = 2,
                    amountInterval = 0.5,
                },
                ["white deer"] = {
                    startWave = 5,
                    waveInterval = 5,
                    monsterHP = 3000,
                    teamHP = 2000,
                },
            },
        },
        [2] = {
            name = "bandits challenge",
            cost = 20,
            requiredRepL = 3,
            waveSV = SV.banditChallenge,
            startPositions = {{x = 743, y = 758, z = 7}, {x = 744, y = 758, z = 7}, {x = 745, y = 758, z = 7}},
            upCorner = {x = 736, y = 750, z = 7},
            downCorner = {x = 752, y = 766, z = 7},
            time = 100,
            waveTime = 20,
            clearItems = {1500},
            
            stepInDamage = {
                itemID = 2579,
                itemAID = AIDT.banditTrap,
                extraItemT = 2578,
                amount = 15,
                minDam = 100,
                maxDam = 150,
                dealEff = 4,
                spawnEff = 35,
                removeEff = 32,
            },
            shootingTower = {
                itemID = 874,
                msDelay = 1300,
                interval = 5,
                minDam = 10,
                maxDam = 30,
                distEff = 32,
                dealEff = 48,
                damType = ENERGY,
            },
            monsters = {
                ["bandit hunter"] = {
                    startAmount = 3,
                    teamAmount = 1,
                    amountInterval = -1,
                    skipWave = {10},
                },
                ["bandit knight"] = {
                    startAmount = 2,
                    teamAmount = 1,
                    amountInterval = -0.5,
                    skipWave = {10}
                },
                ["bandit mage"] = {
                    amountInterval = 0.1,
                    skipWave = {10}
                },
                ["bandit druid"] = {
                    teamAmount = 1,
                    amountInterval = 0,
                    skipWave = {10},
                },
                ["bandit sorcerer"] = {
                    startWave = 3,
                    teamAmount = 1,
                    amountInterval = 0.3,
                    skipWave = {4, 8, 10},
                },
                ["bandit rogue"] = {
                    startWave = 4,
                    amountInterval = 0.4,
                    skipWave = {8, 10},
                },
                ["bandit shaman"] = {
                    startWave = 3,
                    teamAmount = 1,
                    amountInterval = 0.4,
                    skipWave = {8, 10},
                },
                ["archanos"] = {
                    startWave = 4,
                    waveInterval = 6,
                    monsterHP = 3000,
                    teamHP = 1500,
                },
                ["borthonos"] = {
                    startWave = 8,
                    waveInterval = 2,
                    monsterHP = 4000,
                    teamHP = 1500,
                },            
            },
        },
        [3] = {
            name = "undead challenge",
            cost = 30,
            requiredRepL = 4,
            waveSV = SV.undeadChallenge,
            startPositions = {{x = 718, y = 783, z = 7}, {x = 717, y = 783, z = 7}, {x = 719, y = 783, z = 7}},
            upCorner = {x = 710, y = 775, z = 7},
            downCorner = {x = 726, y = 791, z = 7},
            time = 120,
            waveTime = 20,
            clearItems = {3113, 3114, 2230, 2231, 21407, 21408}, -- BONES, ghoul corpses
            mapFunc = "challengeEvent_undeadMap",
            
            monsters = {
                ["skeleton"] = {
                    startAmount = 1,
                    teamAmount = 1,
                    startWave = 1,
                    waveInterval = 1,
                    amountInterval = 0.5,
                },
                ["skeleton warrior"] = {
                    startAmount = 1,
                    teamAmount = 1,
                    startWave = 2,
                    waveInterval = 2,
                    amountInterval = 0.5,
                },
                ["ghoul"] = {
                    startAmount = 1,
                    teamAmount = 1,
                    startWave = 3,
                    waveInterval = 2,
                    amountInterval = 0.5,
                },
                ["mummy"] = {
                    startAmount = 1,
                    teamAmount = 1,
                    startWave = 4,
                    waveInterval = 1,
                    amountInterval = 0.3,
                },
                ["ghost"] = {
                    startAmount = 1,
                    teamAmount = 1,
                    startWave = 5,
                    waveInterval = 1,
                    amountInterval = 0.5,
                },
            },
        },
        
    }
}

local challenge_objects = {
    startUpFunc = "challengeEvent_startUp",
    AIDTiles_stepIn = {
        [AIDT.banditTrap] = {funcSTR = "challengeEvent_banditTrap"},
        [AIDT.forestTrap] = {funcSTR = "challengeEvent_forestTrap"},
    },
    modalWindows = {
        [MW.challengeEvent] = {
            name = "Challenge event",
            title = "Choose challenge",
            choices = "challengeEvent_eventMW_createChoises",
            buttons = {
                [100] = "Choose",
                [101] = "Close",
                [102] = "Info",
            },
            func = "challengeEvent_eventMW",
        }
    }
}
centralSystem_registerTable(challenge_objects)
end

function challengeEvent_startUp()
local errorMsg = "challengeEvent - challengeConf"
local IDList = {}
local challengeTKeys = {"name", "cost", "waveSV", "startPositions", "upCorner", "downCorner", "time", "waveTime", "clearItems", "stepInDamage", "monsters", "shootingTower", "mapFunc", "requiredRepL"}
local stepTKeys = {"itemID", "itemAID", "extraItemT", "amount", "minDam", "maxDam", "damType", "dealEff", "spawnEff", "removeEff"}
local towerTKeys = {"itemID", "msDelay", "interval", "minDam", "maxDam", "damType", "dealEff", "distEff"}
local monsterTKeys = {"startAmount", "teamAmount", "startWave", "waveInterval", "amountInterval", "monsterHP", "teamHP", "skipWave"}
local lowestRepL = 100

    local function missingError(missingKey, errorMsg) print("ERROR - missing value in "..errorMsg..missingKey) end
    
    if not challengeConf.challenges then return missingError("challenges", errorMsg) end
    if not challengeConf.infoMsgT then return missingError("infoMsgT", errorMsg) end
    if not challengeConf.challengeIDSV then return missingError("challengeIDSV", errorMsg) end
    
    challengeConf.unlockMessageT = {}
    
    for challengeID, challengeT in pairs(challengeConf.challenges) do
        local errorMsg = errorMsg..".challenges["..challengeID.."]"
        local monsterT = challengeT.monsters
        
        for key, v in pairs(challengeT) do
            if not isInArray(challengeTKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
        end
        if IDList[challengeID] then print("ERROR - challengeID ["..challengeID.."] already exists in "..errorMsg) end
        if not challengeT.name then missingError("name", errorMsg) end
        if not challengeT.waveSV then missingError("waveSV", errorMsg) end
        if not challengeT.startPositions then return missingError("startPositions", errorMsg) end
        if not challengeT.upCorner then return missingError("upCorner", errorMsg) end
        if not challengeT.downCorner then return missingError("upCorner", errorMsg) end
        if not monsterT then return missingError("monsters", errorMsg) end
        local area = createSquare(challengeT.upCorner, challengeT.downCorner)
        local stepT = challengeT.stepInDamage
        local towerT = challengeT.shootingTower
        local monsterNames = {}
        
        if towerT then
            local errorMsg = errorMsg..".shootingTower"
            local towerPosT = {}
            local towerPosKey = 0
            
            if not towerT.itemID then return missingError("itemID", errorMsg) end
            for key, v in pairs(towerT) do
                if not isInArray(towerTKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end
            if not towerT.msDelay then towerT.msDelay = 500 end
            if not towerT.interval then towerT.interval = 1 end
            if not towerT.minDam then towerT.minDam = 10 end
            if not towerT.maxDam then towerT.maxDam = 10 end
            if not towerT.damType then towerT.damType = PHYSICAL end
            if not towerT.distEff then towerT.distEff = 1 end
            if not towerT.dealEff then towerT.dealEff = 3 end
            
            for i, pos in pairs(area) do
                local item = findItem(towerT.itemID, pos)
                if item then
                    local itemPos = item:getPosition()
                    towerPosKey = towerPosKey + 1
                    towerPosT[towerPosKey] = {x = itemPos.x-1, y = itemPos.y-1, z = itemPos.z}
                end
            end
            towerT.cd = 0
            towerT.towerPosT = towerPosT
        end
        
        if not challengeT.cost then challengeT.cost = 0 end
        if not challengeT.requiredRepL then challengeT.requiredRepL = 1 end
        if not challengeT.time then challengeT.time = 60 end
        if not challengeT.waveTime then challengeT.waveTime = 10 end
        if not challengeT.clearItems then challengeT.clearItems = {} end
        if type(challengeT.clearItems) ~= "table" then challengeT.clearItems = {challengeT.clearItems} end
        if challengeT.startPositions.x then print("ERROR - need table of positions in "..errorMsg) end
        if tableCount(challengeT.startPositions) ~= 3 then print("ERROR - there must 3 startPositions in "..errorMsg) end
        
        challengeConf.unlockMessageT[challengeT.requiredRepL] = "You can now try your best in event - "..challengeT.name
        if challengeT.requiredRepL < lowestRepL then lowestRepL = challengeT.requiredRepL end
        
        for monsterName, t in pairs(monsterT) do
            local errorMsg = errorMsg..".monsters["..monsterName.."]"
            for key, v in pairs(t) do
                if not isInArray(monsterTKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end
            table.insert(monsterNames, monsterName)
            if not t.startAmount then t.startAmount = 1 end
            if not t.teamAmount then t.teamAmount = 0 end
            if not t.startWave then t.startWave = 1 end
            if not t.waveInterval then t.waveInterval = 1 end
            if not t.amountInterval then t.amountInterval = 1 end
            if not t.teamHP then t.teamHP = 0 end
            if not t.skipWave then t.skipWave = {} end
            if type(t.skipWave) ~= "table" then t.skipWave = {t.skipWave} end
        end
        
        IDList[challengeID] = true
        challengeT.area = removePositions(area, "solid")
        challengeT.players = {}
        challengeT.addEvents = {}
        challengeT.biggestBid = 0
        challengeT.currentWave = 0
        challengeT.challengeID = challengeID
        challengeT.monsterNames = monsterNames
        
        if stepT then
            local errorMsg = errorMsg..".stepInDamage"
            for key, v in pairs(stepT) do
                if not isInArray(stepTKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end
            if type(stepT.extraItemT) ~= "table" then stepT.extraItemT = {stepT.extraItemT} end
            if not stepT.itemAID then missingError("itemAID", errorMsg) end
            if not stepT.amount then stepT.amount = 1 end
            if not stepT.minDam then stepT.minDam = 10 end
            if not stepT.maxDam then stepT.maxDam = 10 end
            if not stepT.damType then stepT.damType = PHYSICAL end
            if not stepT.dealEff then stepT.dealEff = 3 end
            if not stepT.spawnEff then stepT.spawnEff = 3 end
            if not stepT.removeEff then stepT.removeEff = 3 end
        end
    end
    
    challengeConf.requiredRepL = lowestRepL
end

function challengeEvent_unlockEventMsg(player, newL, npcName)
    if npcName ~= "dundee" then return end
local levelMsg = challengeConf.unlockMessageT[newL]
    if not levelMsg then return end
local extraInfo = player:getSV(SV.extraInfo) == -1 and " (talk to dundee for more info)" or ""
    player:sendTextMessage(ORANGE, levelMsg..extraInfo)
end

function challengeEvent_button(player)
    if player:getRepL("dundee") > challengeConf.requiredRepL then return player:createMW(MW.challengeEvent) end
    player:sendTextMessage(GREEN, "You need repuation level "..challengeConf.requiredRepL.." towards Dundee before you can enter challenges. You can see reputation in your player panel.")
end

function challengeEvent_eventMW_createChoises(player)
local choiceT = {}

    local function addChoice(choiceID, challengeT)
        if challengeT.currentWave > 0 then choiceT[choiceID + 100] = challengeT.name.." challenge is currently being challenged. Its on wave "..challengeT.currentWave return end
        local challengeCost = challengeEvent_getNextBidAmount(challengeT.biggestBid, challengeT.cost)
        local yourWave = getBestWave(player, challengeT)
        
        choiceT[choiceID] = "["..yourWave.." / 10] "..challengeT.name.." challenge - currently costs "..challengeCost.." coins"
    end
    
    for choiceID, challengeT in pairs(challengeConf.challenges) do addChoice(choiceID, challengeT) end
    return choiceT
end

function challengeEvent_eventMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return challengeEvent_displayInfo(player) end
    if choiceID > 100 then return end
    if challengeEvent_hasStarted(choiceID) then return player:sendTextMessage(GREEN, "Sorry challenge already started you were too late to bid.") end
local playerChallengeT = getChallengeT(player)
    
    if playerChallengeT then
        if playerChallengeT.challengeID == choiceID then return player:sendTextMessage(GREEN, "Can not outbid yourself") end
        return player:sendTextMessage(GREEN, "You can only bid on 1 challenge theme at once. You already have bidded on "..playerChallengeT.name)
    end
local team = getPartyMembers(player, 7)
    
    if tableCount(team) > 3 then return player:sendTextMessage(GREEN, "Team maximum size can be 3") end
local challengeT = getChallengeT(choiceID)

    for _, playerID in pairs(team) do
        local player = Player(playerID)
        
        if player then
            local repL = player:getRepL("dundee")
            
            if repL < challengeT.requiredRepL then
                return player:sendTextMessage(GREEN, player:getName().." needs "..challengeT.requiredRepL - repL.." more repuation levels towards Dundee before they can do this challenge")
            end
        end
    end
    
    if not challengeEvent_betOnChallenge(challengeT, team) then return end
    table.insert(challengeT.addEvents, addEvent(challengeEvent_start, 10*1000, choiceID))
end

function challengeEvent_betOnChallenge(challengeT, team)
local totalCost = challengeEvent_getNextBidAmount(challengeT.biggestBid, challengeT.cost)
    
    local function sendMessageToTeam(msg)
        for guid, playerID in pairs(team) do doSendTextMessage(playerID, GREEN, msg) end
    end
    
    for guid, playerID in pairs(team) do
        local player = Player(playerID)
        if getChallengeT(player) then return sendMessageToTeam(player:getName().." is already registered to challenge event") end
        if player:getMoney() < totalCost then return sendMessageToTeam(player:getName().." does not have enough money to join challenge") end
    end
local players = getChallengePlayers(challengeT)
    
    for guid, playerID in pairs(players) do
        local player = Player(playerID)
        
        if challengeT.biggestBid > 0 then
            player:addMoney(challengeT.biggestBid)
            player:sendTextMessage(GREEN, "You have been outbidded from "..challengeT.name..", your "..challengeT.biggestBid.." coins are returned to you.")
        end
        setSV(player, challengeConf.challengeIDSV, -1)
    end
    
    for guid, playerID in pairs(team) do
        local player = Player(playerID)
        player:removeMoney(totalCost)
        setSV(player, challengeConf.challengeIDSV, challengeT.challengeID)
    end
    
    for i, event in pairs(challengeT.addEvents) do stopEvent(event) end
    challengeT.addEvents = {}
    challengeT.players = team
    challengeT.biggestBid = totalCost
    sendMessageToTeam("In 10 seconds you will be ported to "..challengeT.name..", unless your entrance fee is outbidded.")
    return true
end


function challengeEvent_activateMap(challengeT) return challengeT.mapFunc and _G[challengeT.mapFunc](challengeT) end

function challengeEvent_undeadMap(challengeT)
    if tableCount(challengeT.players) == 0 then return end
local duration = 20000
local spikes = {8009, 8010, 8386, 8387}
local area = createSquare(challengeT.upCorner, challengeT.downCorner)
local ignoreIDList = {21515, 8627, 8588, 8589, 10094, 8629, 6216, 6217}
local ignoreTiles = {416, 417, 7348}
local positions = randomPos(area, 40)
    
    local function createSpike(pos)
        local itemID = randomValueFromTable(spikes)
        doSendMagicEffect(pos, {4, 4, 4, 8}, 500)
        addEvent(createItem, 2500, itemID, pos)
        addEvent(dealDamagePos, 2500, 0, pos, PHYSICAL, math.random(200, 300), 1)
        addEvent(removeItemFromPos, duration, itemID, pos)
    end
    
    for _, pos in pairs(positions) do
        local tile = Tile(pos)
        
        if not isInArray(ignoreTiles, tile:getGround():getId()) then
            local tileItems = tile:getItems()
            local ignoreTile = true
            
            for _, item in ipairs(tileItems) do
                ignoreTile = true
                if isInArray(ignoreIDList, item:getId()) then break end
                ignoreTile = false
            end
            
            if not ignoreTile then createSpike(pos) end
        end
    end
    addEvent(challengeEvent_undeadMap, duration, challengeT)
end

function challengeEvent_start(challengeID)
local challengeT = getChallengeT(challengeID)
local players = getChallengePlayers(challengeT)
local startPositions = challengeT.startPositions
local startPosKey = 0

    for guid, playerID in pairs(players) do
        local player = Player(playerID)
        startPosKey = startPosKey + 1
        teleport(player, startPositions[startPosKey])
        player:sendTextMessage(GREEN, "Wave 1 starts in 5 seconds.")
    end
    
    if startPosKey == 0 then return end
    challengeEvent_clearChallengeArea(challengeID)
    challengeEvent_activateMap(challengeT)
    table.insert(challengeT.addEvents, addEvent(challengeEvent_nextWave, 5000, challengeID))
end

function challengeEvent_nextWave(challengeID)
    if not challengeEvent_roomCleared(challengeID) then return challengeEvent_finishChallenge(challengeID) end
    challengeEvent_startWave(challengeID)
end

local function maybeStartNewWave(challengeID)
    if not challengeEvent_roomCleared(challengeID) then return end
    challengeEvent_startWave(challengeID)
end

function challengeEvent_monsterKill(player)
    local challengeT = getChallengeT(player)
    if challengeT then return addEvent(maybeStartNewWave, 1000, challengeT.challengeID) end
end

function challengeEvent_startWave(challengeID)
    local challengeT = getChallengeT(challengeID)
    local players = getChallengePlayers(challengeT)
    local newWave = challengeT.currentWave + 1
    local waveTimeMultiplier = newWave
    if newWave > 10 then waveTimeMultiplier = 10 end
    local nextWaveStartTime = challengeT.time*1000 + waveTimeMultiplier*challengeT.waveTime*1000
    local timeStr = getTimeText(nextWaveStartTime/1000)

    challengeT.currentWave = newWave
    challengeEvent_createMonsters(challengeID)
    for i, event in pairs(challengeT.addEvents) do stopEvent(event) end
    challengeT.addEvents = {}
    for i, playerID in pairs(players) do doSendTextMessage(playerID, BLUE, timeStr.." to complete wave "..newWave) end
    table.insert(challengeT.addEvents, addEvent(challengeEvent_nextWave, nextWaveStartTime, challengeID))
    table.insert(challengeT.addEvents, addEvent(challengeEvent_30secLeftMsg, nextWaveStartTime-30*1000, challengeID))
end

function challengeEvent_finishChallenge(challengeID)
local challengeT = getChallengeT(challengeID)
local players = getChallengePlayers(challengeT)

    for guid, playerID in pairs(players) do
        doSendTextMessage(playerID, GREEN, "Time is up.")
        challengeEvent_endChallenge(playerID)
    end
    challengeEvent_resetChallenge(challengeID)
end

function challengeEvent_endChallenge(playerID, dontTeleport)
local player = Player(playerID)
    if not player then return end
local challengeT = getChallengeT(player)
    if not challengeT then return end
local players = getChallengePlayers(challengeT)
local completedWave = challengeT.currentWave - 1
local yourBestWave = getBestWave(player, challengeT)
    
    teleport(player, player:homePos())
    if completedWave > 0 then gemPouch_createToPlayer(player, completedWave) end
    player:sendTextMessage(ORANGE, "You completed "..plural("wave", completedWave))
    player:sendTextMessage(ORANGE, "You are rewarded with gem pouch, the higher wave you complete the bigger the gem pouch will be.")
    challengeEvent_rewardSkillPoint(player, completedWave, yourBestWave, 4)
    challengeEvent_rewardSkillPoint(player, completedWave, yourBestWave, 8)
    challengeEvent_rewardSkillPoint(player, completedWave, yourBestWave, 10)
    if completedWave > yourBestWave then setSV(player, challengeT.waveSV, completedWave) end
    player:addHealth(10000)
    player:addMana(10000)
    removeSV(player, challengeConf.challengeIDSV)
    challengeT.players[player:getGuid()] = nil
    if tableCount(players) == 0 then challengeEvent_resetChallenge(challengeT.challengeID) end
    return true
end

function challengeEvent_resetChallenge(challengeID)
local challengeT = getChallengeT(challengeID)
local players = getChallengePlayers(challengeT)
    
    for guid, playerID in pairs(players) do removeSV(playerID, challengeConf.challengeIDSV) end
    challengeT.players = {}
    challengeT.biggestBid = 0
    challengeT.currentWave = 0
    for i, event in pairs(challengeT.addEvents) do stopEvent(event) end
    challengeT.addEvents = {}
end

function challengeEvent_rewardSkillPoint(player, completedWave, yourBestWave, rewardWave)
    if completedWave <= yourBestWave or completedWave < rewardWave or yourBestWave >= rewardWave then return end
    addSV(player, SV.skillpoints, 1)
    player:sendTextMessage(ORANGE, "You earned Skillpoint for completing wave "..rewardWave)
end

function challengeEvent_createMonsters(challengeID)
local challengeT = getChallengeT(challengeID)
local players = getChallengePlayers(challengeT)
local teamSize = tableCount(players)
local teamAmountMultiplier = teamSize - 1
local area = challengeT.area
local currentWave = challengeT.currentWave
    
    local function summonMonster(monsterName, monsterT)
        if isInArray(monsterT.skipWave, currentWave) then return end
        
        for wave = 0, currentWave, monsterT.waveInterval do
            if currentWave == monsterT.startWave + wave then
                local baseAmount = monsterT.startAmount
                local bonusAmount = monsterT.teamAmount * teamAmountMultiplier
                local waveAmount = math.floor(math.floor((currentWave-1)/monsterT.waveInterval) * monsterT.amountInterval)
                local totalMonsterAmount = baseAmount + bonusAmount + waveAmount
                
                for i=1, totalMonsterAmount do
                    local randomPos = randomValueFromTable(area)
                    local monster = createMonster(monsterName, randomPos)
                    local monsterHP = monsterT.monsterHP
                    
                    if monsterHP or monsterT.teamHP > 0 then monster:setMaxHealth(monsterHP + monsterT.teamHP*teamAmountMultiplier) end
                end
                return
            end
        end
    end

    for monsterName, monsterT in pairs(challengeT.monsters) do summonMonster(monsterName, monsterT) end
end

function challengeEvent_30secLeftMsg(challengeID)
local challengeT = getChallengeT(challengeID)
local players = getChallengePlayers(challengeT)

    for guid, playerID in pairs(players) do doSendTextMessage(playerID, GREEN, "Hurry the fuck up! You have 30 seconds left to complete the wave!!") end
end

function challengeEvent_roomCleared(challengeID)
local challengeT = getChallengeT(challengeID)
local area = challengeT.area

    for _, monsterName in pairs(challengeT.monsterNames) do
        for _, pos in pairs(area) do
            if findByName(pos, monsterName) then return end
        end
    end
    return true
end

function challengeEvent_clearChallengeArea(challengeID)
local challengeT = getChallengeT(challengeID)
local area = challengeT.area
    
    for _, pos in pairs(area) do
        for _, itemID in pairs(allTheFood) do massRemove(pos, itemID) end
        for _, itemID in pairs(challengeT.clearItems) do massRemove(pos, itemID) end
        massRemove(pos, "monster")
    end
end

function challengeEvent_displayInfo(player)
    player:sendTextMessage(BLUE, ">>> >> > Challenge event info < << <<<")
    for _, msg in ipairs(challengeConf.infoMsgT) do player:sendTextMessage(ORANGE, msg) end
    return player:createMW(MW.challengeEvent)
end

function challengeEvent_hasStarted(ID) return getChallengeT(ID).currentWave > 0 end

function challengeEvent_spawnAllChallengeItems(secPassed)
    if secPassed%30 ~= 0 then return end

    for ID, challengeT in pairs(challengeConf.challenges) do
        if challengeEvent_hasStarted(ID) then challengeEvent_spawnChallengeItems(ID) end
    end
end

function challengeEvent_allTowersShoot(secPassed)
--    if secPassed%1 ~= 0 then return end
    for ID, challengeT in pairs(challengeConf.challenges) do
        if challengeEvent_hasStarted(ID) then challengeEvent_shootWithTower(ID) end
    end
end

local function removeChallengeItem(stepT, randomPos)
    if removeItemFromPos(stepT.itemID, randomPos, 1, stepT.itemAID) then return doSendMagicEffect(randomPos, stepT.removeEff) end
    for _, itemID in ipairs(stepT.extraItemT) do
        if removeItemFromPos(itemID, randomPos, 1, stepT.itemAID) then return doSendMagicEffect(randomPos, stepT.removeEff) end
    end
end

function challengeEvent_spawnChallengeItems(challengeID)
local challengeT = getChallengeT(challengeID)
local stepT = challengeT.stepInDamage
    if not stepT then return end
local area = challengeT.area
local exludeNumbers = {}
    
    for i = 1, stepT.amount do
        local randomN = getRandomNumber(1, tableCount(area), exludeNumbers)
        local randomPos = area[randomN]
        local e = stepT.spawnEff
        exludeNumbers[i] = randomN
        doSendMagicEffect(randomPos, {e,e,e,e,e}, 1000)
        addEvent(createItem, 5000, stepT.itemID, randomPos, 1, stepT.itemAID)
        addEvent(removeChallengeItem, 30000, stepT, randomPos)
    end
end

function challengeEvent_shootWithTower(challengeID)
local challengeT = getChallengeT(challengeID)
local towerT = challengeT.shootingTower
    if not towerT then return end
local CD = towerT.cd
    
    towerT.cd = CD + 1
    if CD < towerT.interval then return end
local towerPosT = towerT.towerPosT
    
    towerT.cd = 0
    for _, pos in pairs(towerPosT) do
        local randomDelay = math.random(1, 2000)
        addEvent(challengeEvent_projectile, randomDelay, challengeT, pos)
    end
end

function challengeEvent_projectile(challengeT, startPos)
local players = getChallengePlayers(challengeT)
local playerID = randomValueFromTable(players)
local player = Player(playerID)
    if not player then return end
local towerT = challengeT.shootingTower
local playerPos = player:getPosition()

    addEvent(dealDamagePos, towerT.msDelay, 0, playerPos, towerT.damType, math.random(towerT.minDam, towerT.maxDam), towerT.dealEff, O_environment_player)
    addEvent(doSendDistanceEffect, towerT.msDelay, startPos, playerPos, towerT.distEff)
end

-- get functions
function getChallengeT(ID)
    if type(ID) == "number" and ID < 101 then return challengeConf.challenges[ID] end
local challengeID = getSV(ID, challengeConf.challengeIDSV)
    if challengeID then return challengeConf.challenges[challengeID] end
end

function challengeEvent_getNextBidAmount(currentBid, baseCost)
    if currentBid == 0 then return baseCost end
local bidIncrease = math.floor(currentBid/10)

    if bidIncrease < 5 then bidIncrease = 5 end
    return currentBid + bidIncrease
end

function getChallengePlayers(ID)
local challengeT = ID
local removeList = {}

    if type(ID) == "number" then
        challengeT = getChallengeT(ID)
        if not challengeT then return {} end
        challengeT = challengeT
    end
local players = challengeT.players
    
    if not players then return print("ERROR - wrong ID ["..tostring(ID).."] in getChallengePlayers()") end
    for guid, playerID in pairs(players) do
        if not Player(playerID) then table.insert(removeList, guid) end
    end
    
    if tableCount(removeList) > 0 then
        local playerT = challengeConf.challenges[challengeT.challengeID].players
        for _, guid in ipairs(removeList) do playerT[guid] = nil end
        players = playerT
    end
    return players
end

function getBestWave(player, challengeT)
local bestWave = getSV(player, challengeT.waveSV)
    
    if bestWave < 0 then return 0, setSV(player, challengeT.waveSV, 0) end
    return bestWave
end

-- other
local function stepItemDamage(creature, item, stepT)
    dealDamage(0, creature, stepT.type, math.random(stepT.minDam, stepT.maxDam), stepT.dealEff, O_environment)
    if not stepT.extraItemT then return item:remove() end
local toItemID = randomValueFromTable(stepT.extraItemT)

    doTransform(item:getId(), item:getPosition(), toItemID, true)
end

function challengeEvent_forestTrap(creature, item)
    if not creature:isPlayer() then return end
local stepT = challengeConf.challenges[1].stepInDamage
    
    stepItemDamage(creature, item, stepT)
end

function challengeEvent_banditTrap(creature, item)
    if not creature:isPlayer() then return end
local stepT = challengeConf.challenges[2].stepInDamage
    
    stepItemDamage(creature, item, stepT)
end