-- dealDamagePos(0, playerPos, DEATH, 100, 1, O_environment)
-- local item = player:getSlotItem(SLOT_FEET)
-- put here commented variables for initializing luaItems and LuaCreature if I cant use runes xD

-- testKey = testKey or 0
function testEnvironment(player, testNumber, luaItem, luaCreature) -- testNumber starts with 0 by default
    local playerID = player:getId()
    local target = player:getTarget()
    local playerPos = player:getPosition()
    local startTime = os.mtime()
    local msg = nil
    local printT = nil
    
    player:sendTextMessage(ORANGE, "test "..testNumber)

    dofile("data/monster/monsters/rabbit.lua")
  --  dealDamagePos(0, playerPos, DEATH, 10, 1, O_environment)
    if "" then return end
  
    --  if not player:isGod() then return end
  --  if tostring(msg) then player:sendTextMessage(ORANGE, tostring(msg)) end
  --  if printT then Uprint(printT) end

    local target = player:getTarget()

    if testNumber == 0 then
        if not target then return player:say("You dont have target", ORANGE) end
        local monsterName = target:getName()
        local monsterTargetName = target:getTarget() and target:getTarget():getName() or "NO_TARGET"
        local followTargetName = target:getFollowCreature() and target:getFollowCreature():getName() or "NO_TARGET"
        local targetList = target:getTargetList()
        local targetListStr = tableToStr(targetList, nil, true)
        local friendList = target:getFriendList()
        local friendListStr = tableToStr(friendList, nil, true)
        local ignoreList = target:getIgnoreList()
        local ignoreListStr = tableToStr(ignoreList, nil, true)
        local ignoreNameList = {}
        
        for i, creatureID in ipairs(ignoreList) do
            print(i)
            ignoreNameList[i] = Creature(creatureID) and Creature(creatureID):getName()
        end
        
        Uprint(ignoreNameList)
        local ignoreListNameStr = tableToStr(ignoreNameList, nil, true)
        
        player:sendTextMessage(BLUE, monsterName.." current attack target: "..monsterTargetName)
        player:sendTextMessage(BLUE, monsterName.." current follow target: "..followTargetName)
        player:sendTextMessage(BLUE, monsterName.." targetList["..#targetList.."]: "..targetListStr)
        player:sendTextMessage(BLUE, monsterName.." friendList["..#friendList.."]: "..friendListStr)
        player:sendTextMessage(BLUE, monsterName.." ignoreList["..#ignoreList.."]: "..ignoreListStr)
        player:sendTextMessage(BLUE, monsterName.." ignoreNameList: "..ignoreListNameStr)
    elseif testNumber == 1 then
        local monsterT = {"wolf", "bear"}
        local moveXPos = 0
        
        for _, monsterName in ipairs(monsterT) do
            moveXPos = moveXPos + 2
            local monsterPos = {x=playerPos.x + moveXPos, y=playerPos.y, z=playerPos.z}
            local monster = Game.createMonster(monsterName, monsterPos, false, true)
           -- monster:registerEvent("onThink_sayTarget")
            bindCondition(monster, "monsterSlow", -1, {speed = -monster:getSpeed()})
        end
    elseif testNumber == 2 then
        if not target then return player:say("You dont have target", ORANGE) end

        if isInTargetList(target, player) then
            target:removeTarget(player)
            player:sendTextMessage(ORANGE, "REMOVED youreslf from "..target:getName().." targetlist")
        else
            target:addTarget(player)
            player:sendTextMessage(ORANGE, "ADDED youreslf to "..target:getName().." targetlist")
        end
    elseif testNumber == 3 then
        if not target then return player:say("You dont have target", ORANGE) end
        
        target:setTarget(player)
        player:sendTextMessage(ORANGE, target:getName().." is now focusing you")
    end
    
end

local interval = 4
local intervalCD = {}
function onThink_sayTarget(monster)
    local monsterID = monster:getId()
    local cd = intervalCD[monsterID] or 0
    if cd + 1 < 3 then intervalCD[monsterID] = cd + 1 return end
    
    local targetListAmount = #monster:getTargetList()
    local target = monster:getTarget()
    local targetName = target and target:getName() or "noTarget"
    monster:say("list: "..targetListAmount.." - target: "..targetName, ORANGE)
    intervalCD[monsterID] = 0
end

function isInTargetList(target, player)
    local targetList = target:getTargetList()
    local playerID = player:getId()

    for _, creatureID in ipairs(targetList) do
        if creatureID == playerID then return true end
    end
end

--dofile("data/quests/rooted catacombs quest.lua")
--dofile("data/areas/regions/rooted catacombs mummy.lua")
--dofile("data/items/items.lua")
--dofile("data/spells/lib/spells.lua")
-- dofile("data/creaturescripts/scripts/damageSystem.lua")