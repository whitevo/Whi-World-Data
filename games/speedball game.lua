local AIDT = AID.games.speedball
if not speedBallConfT then
speedBallConfT = {
    speedBallPointsSV = SV.speedBallPoints,
    costItemID = 5880,                      -- item ID which is required to buy buffs and enter minigame
    enterPos = {x = 665, y = 596, z = 8},   -- where player will be ported when entering minigame
    exitPos =  {x = 667, y = 600, z = 8},   -- where player will be taken after finishing minigame
    completePoints = 10,                    -- how many points for finishing minigame
    pointYardItemID = 2786,                 -- gives yard points
    defaultYardItemID = 2784,               -- default yard item ID
    yardPoints = 3,                         -- how many points given for each pointYardItemID found
    yardLineCornerT = {{upCorner = {x = 672, y = 591, z = 8}, downCorner = {x = 686, y = 591, z = 8}}},
    ballRoomCornerT = {{upCorner = {x = 672, y = 592, z = 8}, downCorner = {x = 686, y = 596, z = 8}}},
    pointTileItemID = 109,                  -- gives tile points
    defaultTileItemID = 103,                -- default tile item ID
    tilePoints = 1,                         -- how many points given for each pointTileItemID found
    
    ballID = 11257,                                     -- item ID of the ball
    balls = {                                           -- list of balls used for minigame
        {pos = {x=673, y=592, z=8}, direction = "S"},   -- direction = direction ball is going on startUp
        {pos = {x=675, y=593, z=8}, direction = "S"},   -- pos = position where ball is on startUp
        {pos = {x=676, y=593, z=8}, direction = "W"},
        {pos = {x=681, y=595, z=8}, direction = "E"},
        {pos = {x=680, y=594, z=8}, direction = "SE"},
        {pos = {x=682, y=596, z=8}, direction = "S"},
    },
    herbT = { -- leverAID = herbAID OR seedAID
        [AIDT.stranth] = 2087,
        [AIDT.oawildory] = 2085,
        [AIDT.eaddow] = 2083,
        [AIDT.jeshMint] = 2081,
        
        [AIDT.stranthSeed] = 4090,
        [AIDT.oawildorySeed] = 4089,
        [AIDT.eaddowSeed] = 4088,
        [AIDT.jeshMintSeed] = 4087,
    },
    bonusT = {
        [AIDT.speed] = {
            condition = HASTE, -- applying any kind of condition means adding 500 "minigame" speed
            conditionID =  SUB.HASTE.speed.minigame, -- removal is hardcoded
            bonus = "extra speed",
            applyMsg = "You gained extra speed for 5minutes.",
        },
        [AIDT.armor] = {
            bonusSV = SV.speedBallArmor,    -- removal is hardcoded
            bonus = "protection from 1 ball hit",
        },
        [AIDT.bonusPoints] = {
            bonusSV = SV.speedBallBonus,    -- removal is hardcoded
            bonus = "point multiplier activated",
        },
    },
    players = {},                           -- {_, pid} all players in minigame
}

speedball_objects = {
    startUpFunc = "speedBall_startUp",
    area = {
        areaCorners = speedBallConfT.ballRoomCornerT,
        blockObjects = {1290},
        setActionID = {
            [103] = AIDT.ground,
        },
    },
    AIDTiles_stepIn = {
        [AIDT.enter] = {funcSTR = "speedball_enter"},
        [AIDT.finish] = {funcSTR = "speedball_finish"},
        [AIDT.gates] = {
            onlyPlayer = true,
            teleport = {x = 671, y = 594, z = 8},
        },
        [AIDT.ground] = {funcSTR = "speedball_ground"},
    },
    AIDItems = {
        [AIDT.speed] = {funcSTR = "speedball_bonus"},
        [AIDT.armor] = {funcSTR = "speedball_bonus"},
        [AIDT.bonusPoints] = {funcSTR = "speedball_bonus"},
        [AIDT.oawildory] = {funcSTR = "speedball_buyHerb"},
        [AIDT.eaddow] = {funcSTR = "speedball_buyHerb"},
        [AIDT.jeshMint] = {funcSTR = "speedball_buyHerb"},
        [AIDT.stranth] = {funcSTR = "speedball_buyHerb"},
        [AIDT.stranthSeed] = {funcSTR = "speedball_buySeed"},
        [AIDT.jeshMintSeed] = {funcSTR = "speedball_buySeed"},
        [AIDT.eaddowSeed] = {funcSTR = "speedball_buySeed"},
        [AIDT.oawildorySeed] = {funcSTR = "speedball_buySeed"},
    },
    AIDItems_onLook = {
        [AIDT.oawildory] = {text = {msg = "Oawildory herb costs 50 points"}},
        [AIDT.eaddow] = {text = {msg = "Eaddow herb costs 50 points"}},
        [AIDT.jeshMint] = {text = {msg = "JeshMint herb costs 50 points"}},
        [AIDT.stranth] = {text = {msg = "Stranth herb costs 50 points"}},
        [AIDT.stranthSeed] = {text = {msg = "Stranth seed costs 100 points"}},
        [AIDT.jeshMintSeed] = {text = {msg = "JeshMint seed costs 100 points"}},
        [AIDT.eaddowSeed] = {text = {msg = "Eaddow seed costs 100 points"}},
        [AIDT.oawildorySeed] = {text = {msg = "Oawildory seed costs 100 points"}},
    },
}

centralSystem_registerTable(speedball_objects)
end

function speedBall_startUp()
local ballRoom = speedBallConfT.ballRoomCornerT
local posT = createAreaOfSquares(ballRoom) 
local ballID = speedBallConfT.ballID

    for _, pos in ipairs(posT) do removeItemFromPos(ballID, pos) end
    for _, ballT in pairs(speedBallConfT.balls) do createItem(ballID, ballT.pos) end
end

function speedball_enter(player)
    if not player:isPlayer() then return end

    if not player:removeItem(speedBallConfT.costItemID, 1) then return player:sendTextMessage(GREEN, "Costs 1 copper ore to enter minigame.") end
    table.insert(speedBallConfT.players, player:getId())
    teleport(player, speedBallConfT.enterPos)
end

function speedball_finish(player)
    if not player:isPlayer() then return end
    teleport(player, speedBallConfT.exitPos)
    speedball_givePoints(player, speedBallConfT.completePoints)
    speedball_removeBonuses(player)
    speedball_removePlayer(player)
end

function speedball_ground(player, item)
local yardPos = item:getPosition()

    yardPos.y = speedBallConfT.yardLineCornerT[1].upCorner.y
    item:transform(speedBallConfT.pointTileItemID)
    if doTransform(speedBallConfT.defaultYardItemID, yardPos, speedBallConfT.pointYardItemID) then doSendMagicEffect(yardPos, {15, 19}, 250) end
end

function speedball_removePlayer(player) speedBallConfT.players = removeFromTable(speedBallConfT.players, player:getId()) end

function speedball_removeBonuses(player)
    removeCondition(player, "minigame")
    removeSV(player, {SV.speedBallBonus, SV.speedBallArmor})
end

local function speedball_yardPoints(points)
local yardLine = speedBallConfT.yardLineCornerT
local posT = createAreaOfSquares(yardLine) 

    for _, pos in ipairs(posT) do
        local itemID = speedBallConfT.pointYardItemID
        if not findItem(itemID, pos) then return points end
        points = points + speedBallConfT.yardPoints
        doTransform(itemID, pos, speedBallConfT.defaultYardItemID)
    end
    return points
end

local function speedball_tilePoints(points)
local ballRoom = speedBallConfT.ballRoomCornerT
local posT = createAreaOfSquares(ballRoom) 

    local function addPoint(pos)
        local itemID = speedBallConfT.pointTileItemID
        if not findItem(itemID, pos) then return points end
        points = points + speedBallConfT.tilePoints
        doTransform(itemID, pos, speedBallConfT.defaultTileItemID, true)
    end
    
    for _, pos in ipairs(posT) do addPoint(pos) end
    return points
end

function speedball_givePoints(player, points)
    points = points or 0
    points = speedball_yardPoints(points)
    points = speedball_tilePoints(points)
    if getSV(player, SV.speedBallBonus) == 1 then points = points*2 end
    addSV(player, speedBallConfT.speedBallPointsSV, points)
    player:sendTextMessage(GREEN, "You earned "..points.." speedball points.")
end

function speedball_bonus(player, item)
local bonusConf = speedBallConfT.bonusT
local bonusT = bonusConf[item:getActionId()]
    
    if not bonusT then return error("missing bonusT in speedball_bonus()") end
local condition = bonusT.condition
local bonusSV = bonusT.bonusSV
    changeLever(item)
    
    local function checkForBonus(player)
        if condition and player:getCondition(condition, bonusT.conditionID) then return true end
        if bonusSV then return getSV(player, bonusSV) == 1 end
    end
    
    if checkForBonus(player) then return player:sendTextMessage(GREEN, "You already have "..bonusT.bonus..".") end
    if not player:removeItem(speedBallConfT.costItemID, 1) then return player:sendTextMessage(GREEN, "This boost costs 1 copper ore and you dont have it.") end
    
    if condition then bindCondition(player:getId(), "minigame", 5*60*1000, {speed = 500}) end
    if bonusSV then setSV(player, bonusSV, 1) end
    player:sendTextMessage(GREEN, bonusT.applyMsg)
end

function speedball_buySeed(player, item)
local herbT = herbs_getHerbT(speedBallConfT.herbT[item:getActionId()])
local herbName = herbT.name
local cost = 100

    changeLever(item)
    if getSpeedBallPoints(player) < cost then return player:sendTextMessage(GREEN, "You don't have enough speedBall points to buy "..herbName) end
    addSV(player, speedBallConfT.speedBallPointsSV, -cost)
    player:giveItem(farmingConf.seedID, 1, herbT.seedAID)
    player:sendTextMessage(GREEN, "You bought "..herbName.." seed for "..cost.." points.")
end

function speedball_buyHerb(player, item)
local herbT = herbs_getHerbT(speedBallConfT.herbT[item:getActionId()])
    if not herbT then return error("missing herbT in speedball_buyHerb()") end
local herbPoints = herbT.speedBallPoints
local herbName = herbT.name

    changeLever(item)
    if getSpeedBallPoints(player) < herbPoints then return player:sendTextMessage(GREEN, "You don't have enough speedBall points to buy "..herbName) end
    herbs_createHerbPowder(player, herbT)
    addSV(player, speedBallConfT.speedBallPointsSV, -herbPoints)
    player:sendTextMessage(GREEN, "You bought "..herbName.." for "..herbPoints.." points.")
end

-- onThink fuction
function speedball_moveBalls()
    if tableCount(speedBallConfT.players) == 0 then return true end
    for ID, ballT in pairs(speedBallConfT.balls) do speedball_moveBall(ballT) end
    return true
end

function speedball_moveBall(ballT)
local item = findItem(speedBallConfT.ballID, ballT.pos)
    if not item then return error("missing item in speedball_moveBall()") end
local newPos = speedball_newBallPos(item, ballT)
local itemPos = item:getPosition()
local player = Tile(itemPos):getBottomCreature()

    if not player then player = Tile(newPos):getBottomCreature() end
    ballT.pos = newPos
    item:moveTo(newPos)
    
    if player and getSV(player, SV.speedBallArmor) ~= 1 then
        speedball_givePoints(player)
        speedball_removeBonuses(player)
        speedball_removePlayer(player)
        return teleport(player, speedBallConfT.exitPos)
    end
    removeSV(player, SV.speedBallArmor)
end

function speedball_newBallPos(item, ballT)
local itemPos = item:getPosition()
local posX = itemPos.x
local posY = itemPos.y
local northEdge = speedBallConfT.ballRoomCornerT[1].upCorner.y
local southEdge = speedBallConfT.ballRoomCornerT[1].downCorner.y
local westEdge = speedBallConfT.ballRoomCornerT[1].upCorner.x
local eastEdge = speedBallConfT.ballRoomCornerT[1].downCorner.x
local direction = ballT.direction

    if direction:match("S") then
        posY = posY + 1
        
        if posY > southEdge then
            posY = posY - 1
            ballT.direction = direction:gsub("S", "N")
        end
    elseif direction:match("N") then
        posY = posY - 1
        
        if posY < northEdge then
            posY = posY + 1
            ballT.direction = direction:gsub("N", "S")
        end
    end
    
    if direction:match("W") then
        posX = posX + -1
        
        if posX < westEdge then
            posX = posX + 1
            ballT.direction = direction:gsub("W", "E")
        end
    elseif direction:match("E") then
        posX = posX + 1
        
        if posX > eastEdge then
            posX = posX - 1
            ballT.direction = direction:gsub("E", "W")
        end
    end
    return {x=posX, y=posY, z=itemPos.z}
end

function clean_speedBallMinigame()
    local tablesDeleted = 0

    for i, cid in pairs(speedBallConfT.players) do
        if not Player(cid) then
            tablesDeleted = tablesDeleted + 1
            speedBallConfT.players[i] = nil
        end
    end
    return tablesDeleted
end

function getSpeedBallPoints(player) 
    local points = getSV(player, speedBallConfT.speedBallPointsSV)
    
    if points < 0 then return 0, setSV(player, speedBallConfT.speedBallPointsSV, 0) end
    return points
end

function hasSpeedBallPoints(player) return getSpeedBallPoints(player) > 0 end