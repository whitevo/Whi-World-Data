--[[
.players = {
    cid = {
        rumDrinks = INT,    how many sips of RUM taken
        wineDrinks = INT,   how many sips of WINE taken
        beerDrinks = INT,   how many sips of BEER taken
        order = STR,        "waiting" - waits for next task to do
                            "rum"  - has to drink RUM next
                            "wine" - has to drink WINE next
                            "beer" - has to drink BEER next
                            
                            INT or {INT} - players on these itemID's drink.
                            "table" - has to go on the table
                            "redChair" - has to go on the red chair
                            "timberChair" - has to go on the sturdy chair
                            "guessWINE" - has to go guess who has least drank WINE with commmand !guess
                            "guessRUM" - has to go guess who has least drank RUM with commmand !guess
                            "guessBEER" - has to go guess who has least drank BEER with commmand !guess
                            "WINEmaster" - has to go guess who has drank most WINE with commmand !guess
                            "BEERmaster" - has to go guess who has drank most BEER with commmand !guess
                            "RUMmaster" - has to go guess who has drank most RUM with commmand !guess
                            "drunk" - most drunk player(s) drink
                            "sober" - least drunk player(s) drink
    }
}
]]

local drinkRemindTime = 25000
local banTime = 120

drinkingGameEvent = {
    bannedAccounts = {},
    players = {},
    usedKeyT = {},
    newCycleN = 0,
    tasks = {
        [1] = {
            taskName = "Table Task",
            info = "Go onto a table! Players who don't get onto a table DRINK!",
            order = "table",
        },
        [2] = {
            taskName = "Red Chair Task",
            info = "Sit on a red chair! Players who don't sit the fuck down onto a correct chair DRINK!",
            order = "redChair",
        },
        [3] = {
            taskName = "Timber Chair Task",
            info = "Sit on a timber chair! Players who don't get their ass down onto a correct chair DRINK!",
            order = "timberChair",
        },
        [4] = {
            taskName = "WINE derpers",
            info = "Guess who has drank the least WINE with command !guess",
            order = "guessWINE",
            requiredCycle = 10,
            noSameResults = true,
        },
        [5] = {
            taskName = "BEER derpers",
            info = "Guess who has drank the least BEER with command !guess",
            order = "guessBEER",
            requiredCycle = 5, 
            noSameResults = true,
        },
        [6] = {
            taskName = "RUM derpers",
            info = "Guess who has drank the least RUM with command !guess",
            order = "guessRUM",
            requiredCycle = 15,
            noSameResults = true,
        },
        [7] = {
            taskName = "WINE masters",
            info = "Guess who has drank the most WINE with command !guess",
            order = "WINEmaster",
            requiredCycle = 10,
            noSameResults = true,
        },
        [8] = {
            taskName = "BEER masters",
            info = "Guess who has drank the most BEER with command !guess",
            order = "BEERmaster",
            requiredCycle = 5,
            noSameResults = true,
        },
        [9] = {
            taskName = "RUM masters",
            info = "Guess who has drank the most RUM with command !guess",
            order = "RUMmaster",
            requiredCycle = 15,
            noSameResults = true,
        },
        [10] = {
            taskName = "Y YU NO DRINK",
            info = "Players who are least drunk, DRINK",
            order = "sober",
            func = "DG_soberTask",
            requiredCycle = 5,
        },
        [11] = {
            taskName = "PASS OUT ALREADY",
            info = "Players who are most drunk, DRINK",
            order = "drunk",
            func = "DG_drunkTask",
            requiredCycle = 15,
        },
        [12] = {
            taskName = "Dark Side",
            info = "Players who are on a dark tile, DRINK",
            order = 414,
            func = "DG_tileTask"
        },
        [13] = {
            taskName = "Yellow Side",
            info = "Players who are on a yellow tile, DRINK",
            order = 420,
            func = "DG_tileTask",
        },
        [14] = {
            taskName = "BE CAREFUL",
            info = "Players who are standing on a table, DRINK",
            order = 1616,
            func = "DG_tileTask",
        },
        [15] = {
            taskName = "Get Comfy",
            info = "Players who are standing on a chair, DRINK",
            order = {1666, 1667, 1668, 1669, 12787, 12788, 12789, 12790},
            func = "DG_tileTask",
        },
    },
}

local AIDT = AID.games.drinking

local DG_objects = {
    AIDTiles_stepOut = {
        [AIDT.redChair] = {funcSTR = "DG_stepOut"},
        [AIDT.timberChair] = {funcSTR = "DG_stepOut"},
        [AIDT.table] = {funcSTR = "DG_stepOut"},
    },
    AIDTiles_stepIn = {
        [AIDT.leaveBar] = {funcSTR = "DG_unregister"},
        [AIDT.redChair] = {funcSTR = "DG_stepOnRedChair"},
        [AIDT.timberChair] = {funcSTR = "DG_stepOnTimberChair"},
        [AIDT.table] = {funcSTR = "DG_stepOnTable"},
    },
    AIDItems_onLook = {
        [AIDT.rum]  = {text = {msg = "RUM bottle"}},
        [AIDT.wine]  = {text = {msg = "WINE vial"}},
        [AIDT.beer]  = {text = {msg = "BEER cup"}},
    },
    AIDItems = {
        [AIDT.enterBar] = {teleport = {x = 570, y = 670, z = 6}},
        [AIDT.book] = {funcSTR = "DG_book_onUse"},
        [AIDT.rum]  = {funcSTR = "DG_useRum"},
        [AIDT.wine] = {funcSTR = "DG_useWine"},
        [AIDT.beer] = {funcSTR = "DG_useBeer"},
    },
    modalWindows = {
        [MW.drinkingGame] = {
            name = "Whi World Drinking Game",
            title = "Choose your action",
            choices = {
                [1] = "Join drinking game",
                [2] = "Take drinking game guide",
                [3] = "DG_kickPlayerChoice",
            },
            buttons = {[100] = "choose", [101] = "close"},
            func = "DG_mainWindowMW",
        },
        [MW.drinkingGame_kick] = {
            naem =  "Kick player from Drinking Game",
            title = "Choose player to kick from drinking game",
            choices = "DG_kickMWChoices",
            buttons = {[100] = "choose", [101] = "close"},
            func = "DG_kickMW",
        },
        [MW.drinkingGame_leastDrinks] = {
            name =  "Drinking Game GUESS",
            title = "DG_leastDrinksMWTitle",
            choices = "DG_leastDrinksMWChoices",
            buttons = {[100] = "choose", [101] = "close"},
            func = "DG_leastDrinksMW",
        },
        [MW.drinkingGame_mostDrinks] = {
            name =  "Drinking Game GUESS",
            title = "DG_mostDrinksMWTitle",
            choices = "DG_leastDrinksMWChoices",
            buttons = {[100] = "choose", [101] = "close"},
            func = "DG_mostDrinksMW",
        }
    },
}
centralSystem_registerTable(DG_objects)

function DG_mainWindowMW(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    if choiceID == 1 then return not DG_register(player) and player:createMW(mwID) end
    if choiceID == 2 then return drinkingGameGuide(player) end
    if choiceID == 3 then return player:createMW(MW.drinkingGame_kick) end
end

function DG_kickMW(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    local players = drinkingGameEvent.players
    local loopID = 0
    
    for cid, t in pairs(players) do
        loopID = loopID+1
        
        if choiceID == loopID then
            local player2 = Player(cid)
            if player2 then player:say("I voted to kick: "..player2:getName(), ORANGE) end
            return DG_kick(player, cid)
        end
    end
end

local function handleResult(player, playerData, drink, result)
    playerData.order = "waiting"
    
    if result then
        player:sendTextMessage(BLUE, "SO WRONG!!") -- should I make standings?
        DG_order(player, drink)
    else
        player:sendTextMessage(BLUE, "OMG YOU ARE RIGHT!")
        DG_newRound()
    end
end

function DG_leastDrinksMW(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    local loopID = 0
    local yourChoiceValue = 0
    local players = drinkingGameEvent.players
    local playerData = drinkingGameEvent.players[player:getId()]
    local drink = playerData.order:gsub("guess", ""):lower()
    local smallestDrinkValue = 100
    
    for cid, t in pairs(players) do
        local value = t[drink.."Drinks"]
        loopID = loopID+1
        if smallestDrinkValue > value then smallestDrinkValue = value end
        if choiceID == loopID then yourChoiceValue = value end
    end
    
    local yourResult = yourChoiceValue > smallestDrinkValue
    handleResult(player, playerData, drink, yourResult)
end

function DG_mostDrinksMW(player, mwID, buttonID, choiceID)
    if choiceID == 255 then return end
    if buttonID == 101 then return end
    local loopID = 0
    local biggestDrinkValue = 0
    local yourChoiceValue = 0
    local players = drinkingGameEvent.players
    local playerData = drinkingGameEvent.players[player:getId()]
    local drink = playerData.order:gsub("master", ""):lower()
    
    for cid, t in pairs(players) do
        local value = t[drink.."Drinks"]
        
        loopID = loopID+1
        if biggestDrinkValue < value then biggestDrinkValue = value end
        if choiceID == loopID then yourChoiceValue = value end
    end
    local yourResult = yourChoiceValue < biggestDrinkValue
    handleResult(player, playerData, drink, yourResult)
end

function DG_leastDrinksMWTitle(player, order) return "Guess who has drank least "..order:gsub("guess", "") end
function DG_mostDrinksMWTitle(player, order) return "Guess who has drank the most "..order:gsub("master", "") end

function DG_leastDrinksMWChoices(player, order)
    local players = drinkingGameEvent.players
    local loopID = 0
    local choiceT = {}

    for cid, t in pairs(players) do
        loopID = loopID+1
        choiceT[loopID] = Player(cid):getName()
    end
    return choiceT
end

function DG_kickMWChoices(player)
    local players = drinkingGameEvent.players
    local playerID = player:getId()
    local choiceT = {}
    local loopID = 0

    for cid, t in pairs(players) do
        loopID = loopID+1
        if cid ~= playerID then choiceT[loopID] = "kick >> "..Player(cid):getName() end
    end
    return choiceT
end

function DG_book_onUse(player) return player:createMW(MW.drinkingGame) end
function DG_kickPlayerChoice(player) return playingDG(player) and "Kick player" end

function DG_stepOnRedChair(player) return DG_stepOn(player, "redChair") end
function DG_stepOnTimberChair(player) return DG_stepOn(player, "timberChair") end
function DG_stepOnTable(player) return DG_stepOn(player, "table") end

function DG_checkTarget(player, target, drinkType)
    if not target or target:getId() ~= player:getId() then return player:sendTextMessage(GREEN, "invalid target") end
    return DG_drink(player, drinkType)
end

function DG_useRum(player, item, itemEx) return DG_checkTarget(player, itemEx, "rum") end
function DG_useWine(player, item, itemEx) return DG_checkTarget(player, itemEx, "wine") end
function DG_useBeer(player, item, itemEx) return DG_checkTarget(player, itemEx, "beer") end

function DG_register(player)
    local players = drinkingGameEvent.players
    local cid = player:getId()

    clean_drinkingGameEvent()
    
    for accID, banReleaseTime in pairs(drinkingGameEvent.bannedAccounts) do
        if player:getAccountId() == accID then
            local banTimeLeft = banReleaseTime - os.time()
            
            if banTimeLeft > 0 then
                return player:sendTextMessage(GREEN, "You gotta wait "..getTimeText(banTimeLeft))
            end
        end
    end
    
    for cid, t in pairs(players) do
        if type(t) ~= "table" then
            if t.order:match("guess") or t.order:match("master") then
                player:sendTextMessage(BLUE, "Players are in the middle of the guessing game, wait a few seconds and try again.")
                return false, player:sendTextMessage(GREEN, "Can't join drinking game yet")
            end
        end
    end
    
    players[cid] = {
        rumDrinks = 0,
        wineDrinks = 0,
        beerDrinks = 0,
        order = "waiting"
    }
    drinkingGameEvent.newCycleN = 0
    player:sendTextMessage(BLUE, "You have sucessfully joined the drinking game. Take a sip of RUM and go with the flow.")
    DG_order(player, "rum")
    return true
end

function clean_drinkingGameEvent()
    local players = drinkingGameEvent.players

    for cid, t in pairs(players) do
        if not Player(cid) then players[cid] = nil end
    end
end

function DG_order(player, order)
    local cid = player:getId()
    local playerData = drinkingGameEvent.players[cid]
    local playerPos = player:getPosition()

    if playerData.order ~= "waiting" then return end
    
    playerPos:sendMagicEffect(40)
    playerPos:sendMagicEffect(36)
    playerData.order = order
    player:sendTextMessage(GREEN, "take a sip of "..order:upper())
    player:sendTextMessage(ORANGE, "take a sip of "..order:upper())
    
    for pid, t in pairs(drinkingGameEvent.players) do
        if cid ~= pid then Player(pid):sendTextMessage(ORANGE, player:getName().." has to drink: "..order:upper()) end
    end
    return true
end

function playingDG(player)
    local players = drinkingGameEvent.players
    return players[player:getId()]
end

function DG_randomDrink(player) return DG_order(player, randomValueFromTable({"rum", "wine", "beer"})) end

function DG_drink(player, drink)
    local cid = player:getId()
    local playerData = drinkingGameEvent.players[cid]
    if not playerData then return end

    local order = playerData.order
    local drinkKey = drink.."Drinks"
    local drinksBefore = playerData[drinkKey] 
    local drinks = {"rum", "wine", "beer"}
    local hasToDrink = false

    for _, drink2 in pairs(drinks) do
        if playerData.order == drink then hasToDrink = true end
    end
    if not hasToDrink then return end
    if playerData.order ~= drink then return player:sendTextMessage(GREEN, "This is: "..drink:upper().. ", but you got to go for: "..playerData.order:upper()) end
    
    playerData[drinkKey] = drinksBefore + 1
    playerData.order = "waiting"
    player:say("*sip*", ORANGE)
    DG_newRound()
    return true
end

local eventStackStop = "OFF"
local DG_addEvent
function DG_newRound()
    local players = drinkingGameEvent.players

    clean_drinkingGameEvent()
    stopEvent(DG_addEvent)
    eventStackStop = "OFF"
    DG_addEvent = addEvent(DG_remindDrink, drinkRemindTime)
    
    if not DG_readyCheck() then return end
    for cid, t in pairs(players) do
        local player = Player(cid)
        player:sendTextMessage(BLUE, "Next round starts in 3 seconds!!")
        addEvent(doSendTextMessage, 1000, cid, BLUE, "Next round starts in 2 seconds!!")
        addEvent(doSendTextMessage, 2000, cid, BLUE, "Next round starts in 1 second!!")
    end
    addEvent(DG_nextTask, 3000)
end

function DG_remindDrink()
    if eventStackStop == "ON" then return end
    local players = drinkingGameEvent.players
    local drinks = {"rum", "wine", "beer"}
    eventStackStop = "ON"
    DG_addEvent = addEvent(DG_remindDrink, drinkRemindTime)
    eventStackStop = "OFF"
    
    clean_drinkingGameEvent()
    
    for cid, t in pairs(players) do
        local player = Player(cid)
        
        for _, drink in pairs(drinks) do
            if t.order == drink then player:say("Not sure should I take another sip of: "..drink:upper(), ORANGE) end
        end
    end
end

function DG_readyCheck()
    local players = drinkingGameEvent.players
    local playerCount = DG_getPlayerCount()
    
    for cid, t in pairs(players) do
        if t.order ~= "waiting" then return end
    end
    if playerCount >= 2 then return true end
end

function DG_nextTask()
    local tasks = drinkingGameEvent.tasks
    local allowedTasks = getAllowedTaskIDs()
    local randomTaskID = allowedTasks[math.random(1, #allowedTasks)]
    local key = math.random(1, 5)

    drinkingGameEvent.usedKeyT[key] = randomTaskID
    drinkingGameEvent.newCycleN = drinkingGameEvent.newCycleN + 1
    DG_task(tasks[randomTaskID])
end

function getAllowedTaskIDs()
    local tasks = drinkingGameEvent.tasks
    local allowedTasks = {}
    local usedTasks = drinkingGameEvent.usedKeyT
        
    for ID, taskT in pairs(tasks) do
        local allowed = true
        
        if matchTableValue(usedTasks, ID) then
            allowed = false
        else
            if taskT.requiredCycle and taskT.requiredCycle > drinkingGameEvent.newCycleN then allowed = false end
            
            if taskT.noSameResults then
                local players = drinkingGameEvent.players
                local highestDrunkenValue = 0
                local lowestDrunkenValue = 1000
                local playerAmount = 0
                local drunkPlayers = 0
                local soberPlayers = 0
                
                for cid, t in pairs(players) do
                    local value = DG_getDrunkValue(t)
                    playerAmount = playerAmount + 1
                    
                    if value > highestDrunkenValue then highestDrunkenValue = value end
                    if value < lowestDrunkenValue then lowestDrunkenValue = value end
                end
                
                for cid, t in pairs(players) do
                    local player = Player(cid)
                    local value = DG_getDrunkValue(t)
                    
                    if value == highestDrunkenValue then drunkPlayers = drunkPlayers + 1 end
                    if value == lowestDrunkenValue then soberPlayers = soberPlayers + 1 end
                end
                
                if drunkPlayers > playerAmount/2 or soberPlayers > playerAmount/2 then allowed = false end
            end
        end
        
        if allowed then table.insert(allowedTasks, ID) end
    end
    
    if tableCount(allowedTasks) == 0 then
        drinkingGameEvent.usedKeyT = {}
        allowedTasks = getAllowedTaskIDs()
    end
    return allowedTasks
end

function DG_getPlayerCount()
    clean_drinkingGameEvent()
    return tableCount(drinkingGameEvent.players)
end

function DG_task(taskT)
    local players = drinkingGameEvent.players
    local activateStepOn = false
        
    local function addStepOn(cid, object)
        if not activateStepOn then activateStepOn = {} end
        activateStepOn[cid] = object
    end
    
    clean_drinkingGameEvent()
    for cid, t in pairs(players) do
        local player = Player(cid)
        local playerPos = player:getPosition()
        local stepOrders = {"table", "redChair", "timberChair"}
        
        player:sendTextMessage(GREEN, "----- "..taskT.taskName.."! -----")
        player:sendTextMessage(ORANGE, taskT.info)
        
        for _, order in ipairs(stepOrders) do
            if taskT.order == order and findItem(nil, playerPos, AIDT[order]) then addStepOn(cid, order) break end
        end
        t.order = taskT.order
    end
    
    if activateStepOn then
        for cid, object in pairs(activateStepOn) do DG_stepOn(Player(cid), object) end
    end
    
    if taskT.func then activateFunctionStr(taskT.func) end
end

------- TASK FUNCTIONS
function DG_stepOn(player, object)
    if not player:isPlayer() then return end
    clean_drinkingGameEvent()
    local cid = player:getId()
    local players = drinkingGameEvent.players
    local playerData = players[cid]
    local playerCount = 0
    local playersOnObject = 0
    
    if playerData then
        local order = playerData.order
        
        if type(order) ~= "table" then
            if order == object then
                playerData.action = object
            elseif order:match("Chair") and object:match("Chair") then
                playerData.order = "waiting"
                playerData.action = nil
                DG_randomDrink(player)
            end
        else
            Uprint(order, "is it ever a table?? DG_stepOn()")
        end
    end
    
    for cid, t in pairs(players) do
        if t.order == object then
            playerCount = playerCount + 1
            
            if t.action and t.action == object then
                playersOnObject = playersOnObject +1
            end
        end
    end
    
    if playerCount > 1 then
        if playerCount <= 4 then
            local lastDrinker = playerCount - playersOnObject
            
            if lastDrinker == 1 then
                DG_stepOnTaskFinish(object)
            end
        elseif playersOnObject == 3 then
            DG_stepOnTaskFinish(object)
        end
    else
        for cid, t in pairs(players) do
            if t.order == object then
                players[cid].order = "waiting"
                players[cid].action = nil
            end
        end
    end
end

function DG_stepOnTaskFinish(object)
    local players = drinkingGameEvent.players
    local playersWhoDrink = {}

    clean_drinkingGameEvent()
    for cid, t in pairs(players) do
        if t.order == object then
            if t.action ~= object then
                table.insert(playersWhoDrink, cid)
            end
            t.order = "waiting"
            t.action = nil
        end
    end
    
    for cid, t in pairs(players) do
        local player = Player(cid)
        
        if isInArray(playersWhoDrink, cid) then
            DG_randomDrink(player)
        else
            player:sendTextMessage(ORANGE, "Players who were slow to get on "..object..": "..DG_playerListSTR(playersWhoDrink))
        end
    end
end

function DG_stepOut(player)
    if not player:isPlayer() then return end
    local cid = player:getId()
    local players = drinkingGameEvent.players
    local playerData = players[cid]

    if playerData then playerData.action = nil end
end

function DG_guess(player)
    local cid = player:getId()
    local players = drinkingGameEvent.players
    local playerData = players[cid]
        
    clean_drinkingGameEvent()
    
    if playerData then
        if type(playerData.order) ~= "table" then
            if playerData.order:match("guess") then
                return player:createMW(MW.drinkingGame_leastDrinks, playerData.order)
            elseif playerData.order:match("master") then
                return player:createMW(MW.drinkingGame_mostDrinks, playerData.order)
            end
        end
    end
    player:sendTextMessage(GREEN, "You don't have to guess right now.")
end

function DG_drunkTask()
    local players = drinkingGameEvent.players
    local highestDrunkenValue = 0
    local playersWhoDrink = {}

    for cid, t in pairs(players) do
        if t.order == "drunk" then
            local value = DG_getDrunkValue(t)
            
            if value > highestDrunkenValue then
                highestDrunkenValue = value
            end
        end
    end
    
    for cid, t in pairs(players) do
        if t.order == "drunk" then
            local value = DG_getDrunkValue(t)
            
            t.order = "waiting"
            if value == highestDrunkenValue then
                table.insert(playersWhoDrink, cid)
            end
        end
    end
    
    for cid, t in pairs(players) do
        local player = Player(cid)
        
        if isInArray(playersWhoDrink, cid) then
            DG_randomDrink(player)
        else
            player:sendTextMessage(ORANGE, "Players who just can't get enough: "..DG_playerListSTR(playersWhoDrink))
        end
    end
end

function DG_soberTask()
    local players = drinkingGameEvent.players
    local lowestDrunkenValue = 1000
    local playersWhoDrink = {}
        
    for cid, t in pairs(players) do
        if t.order == "sober" then
            local value = DG_getDrunkValue(t)
            
            if value < lowestDrunkenValue then
                lowestDrunkenValue = value
            end
        end
    end
    
    for cid, t in pairs(players) do
        if t.order == "sober" then
            local value = DG_getDrunkValue(t)
            
            t.order = "waiting"
            if value == lowestDrunkenValue then
                table.insert(playersWhoDrink, cid)
            end
        end
    end
    
    for cid, t in pairs(players) do
        local player = Player(cid)
        
        if isInArray(playersWhoDrink, cid) then
            DG_randomDrink(player)
        else
            player:sendTextMessage(ORANGE, "Players who were too sober for their own good: "..DG_playerListSTR(playersWhoDrink))
        end
    end
end

function DG_getDrunkValue(t)
    local rum = t.rumDrinks
    local wine = t.wineDrinks
    local beer = t.beerDrinks
    local drunkValue = rum*3 + wine*2 + beer

    return drunkValue
end

function DG_tileTask()
    local players = drinkingGameEvent.players
    local lowestDrunkenValue = 1000

    for cid, t in pairs(players) do
        local itemT = t.order
        local player = Player(cid)
        local playerPos = player:getPosition()
        local tile = Tile(playerPos)
        
        t.order = "waiting"
        
        if type(itemT) == "number" then
            if tile:getItemById(itemT) then
                DG_randomDrink(player)
            end
        elseif type(itemT) == "table" then
            for _, itemID in pairs(itemT) do
                if tile:getItemById(itemID) then
                    DG_randomDrink(player)
                    break
                end
            end
        end
    end
    DG_newRound()
end

function drinkingGameGuide(player)
    player:sendTextMessage(BLUE, "--- Whi World Drinking Game ---")
    player:sendTextMessage(YELLOW, "--- It's simple. All you have to do is check the console text for things you have to do ---")
    player:sendTextMessage(YELLOW, "--- If it's your turn to drink, then go to the nearest table with the corresponding drink on it and use the drink on yourself ---")
    player:sendTextMessage(YELLOW, "--- Drinking game starts when there are at least 2 participants ---")
    player:sendTextMessage(BLUE, "--- When you are trying to drink along in real life, then first drink in real life and then ingame ---")
    player:createMW(MW.drinkingGame)
end

function DG_unregister(player)
    local players = drinkingGameEvent.players
    local cid = player:getId()
        
    if banTime then
        drinkingGameEvent.bannedAccounts[player:getAccountId()] = os.time()+banTime
    end
    players[cid] = nil
    DG_newRound()
end

function DG_kick(player, playerID)
    local players = drinkingGameEvent.players

    clean_drinkingGameEvent()
    
    for cid, t in pairs(players) do
        if cid == playerID then
            local kickerID = player:getId()
            
            if not t.kickT then
                t.kickT = {kickerID}
                return
            end
            
            local playerCount = DG_getPlayerCount()
            local voteCount = tableCount(t.kickT)
            
            if not matchTableValue(t.kickT, kickerID) then
                if voteCount + 1 > playerCount/2 then
                    Player(cid):sendTextMessage(GREEN, "You have been kicked from drinking game :(")
                    DG_unregister(Player(cid), banTime)
                else
                    table.insert(t.kickT, kickerID)
                end
            end
            return
        end
    end
end

function DG_playerListSTR(t)
    local playerListSTR = ""

    for k, cid in pairs(t) do
        local player = Player(cid)
        
        if player then
            if k > 1 then
                playerListSTR = playerListSTR..", "..player:getName():upper()
            else
                playerListSTR = playerListSTR..player:getName():upper()
            end
        end
    end
    return playerListSTR
end