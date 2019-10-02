actionSystem = {}
actionSystem.__index = actionSystem

setmetatable(
    actionSystem, {
        __call = function(class, ...) return class(...) end,
    }
)

function actionSystem.new() return setmetatable({}, actionSystem) end

--[[
    onUse | extra = fromPos or itemEx, toPos
    extra = fromPos or itemEx | toPos only with onUse

    toObjects can be: 
    tile > if item moved to map position
    player > if item moved to slot position
    container > if item moved inside container
]]
function executeActionSystem(creature, item, t, itemEx, fromPos, toPos, fromObject, toObject)
    local itemT = actionSystem.new()

    itemT = itemT:giveVariables(t)
    if not timers(creature, itemT) then return executeActionSystem2(creature, item, itemT) end
    
    if creature:isPlayer() then
        local player = creature
        if not itemT:anySV2(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:checkSVTable(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:bigSV2(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:hasItemList(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:hasItemListF(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:takeItems2(player) then return executeActionSystem2(player, item, itemT) end
        if not itemT:rewardItems2(player) then return not itemT.returnFalse end
        itemT:text2(player, item)
        itemT:teleport2(player, item)
        itemT:setSVTable(player)
        itemT:addSVTable(player)
        itemT:giveHP(player)
        itemT:giveMP(player)
        itemT:exp2(player)
    elseif itemT.onlyPlayer then
        return
    end
    
    local creaturePos = getParentPos(creature)
    if not fromPos then fromPos = creaturePos end
    fromPos = fromPos.x == CONTAINER_POSITION and creaturePos or fromPos
    
    itemT:createMonster2(creature, item)
    itemT:ME_effects(creature, item)
    itemT:transform2(creature, item)
    itemT:createItems2(creature, item)
    
    local returnValue = itemT:func(creature, item, itemEx, fromPos, toPos, fromObject, toObject)
    
    itemT:removeItems2(creature, item)
    if itemT.returnFalse then return false end
    return returnValue
end

function actionSystem_onMoveFunctions(player, item, fromPos, toPos, fromObject, toObject)
    for _, moveT in ipairs(onMoveT) do
        local returnValue = executeActionSystem(player, item, moveT, nil, fromPos, toPos, fromObject, toObject)
        if returnValue then return true end
    end
    local actionT = AIDItems_onMove[item:getActionId()] or IDItems_onMove[item:getId()]
        
    if actionT then return executeActionSystem(player, item, actionT, nil, fromPos, toPos, fromObject, toObject) end
    
    for _, moveT in ipairs(onMoveT2) do
        local returnValue = executeActionSystem(player, item, moveT, nil, fromPos, toPos, fromObject, toObject)
        if returnValue then return true end
    end
end

function executeActionSystem2(player, item, itemT)
    if not player:isPlayer() then return not itemT.returnFalse end
    itemT:teleport3(player)
    itemT:text3(player, item)
    itemT:transform3(player, item)
    return not itemT.returnFalse
end

function actionSystem_checkTable(t)
    local function checkTimeT(t)
        local timeT = t.timers
        if not timeT then return end
        if timeT.time and not timeT.lastTime then timeT.lastTime = 0 end
        if timeT.guidTime and not timeT.lastGuidTime then timeT.lastGuidTime = {} end
    end

    local function checkTakeT(t)
        local takeItemT = t.takeItems
        if not takeItemT then return end

        for _, itemT in pairs(takeItemT) do
            if not itemT.count then itemT.count = 1 end
        end
    end

    checkTimeT(t)
    checkTakeT(t)
end

function actionSystem_startUp()
    for _, t in pairs(IDItems) do actionSystem_checkTable(t) end
    for _, t in pairs(AIDItems) do actionSystem_checkTable(t) end
    for _, t in pairs(AIDTiles_stepIn) do actionSystem_checkTable(t) end
    for _, t in pairs(AIDTiles_stepOut) do actionSystem_checkTable(t) end
    print("actionSystem_startUp()")
end

function actionSystem_onLook(player, target)
    if getSV(player, SV.lookDisabled) == 1 then return end
    if target:isCreature() then return end
    local t = AIDItems_onLook[target:getActionId()] or IDItems_onLook[target:getId()]
    if not t then return end

    if player:isGod() then player:sendTextMessage(GREEN, "god info:"..godOnLook(player, target)) end
    executeActionSystem(player, target, t)
    return true
end

function actionSystem:giveVariables(t)
    for key, v in pairs(t) do self[key] = v end
    return self
end

function actionSystem:transform2(player, item)
    local t = self.transform
    if not t or not item then return end
    local itemID = item:getId()
    local itemAID = t.itemAID or item:getActionId()
    local itemPos = item:getPosition()

    if t.returnDelay then addEvent(doTransform, t.returnDelay, t.itemID, itemPos, itemID, item:getActionId()) end
    
    if t.itemID then
        if t.itemID == 0 then return item:remove() end
        doTransform(itemID, itemPos, t.itemID, itemAID)
    elseif itemAID then
        item:setActionId(itemAID)
    end
end

function actionSystem:transform3(player, item)
    local t = self.transformF
    if not t or not item then return end
    local itemID = item:getId()
    local itemAID = t.itemAID or item:getActionId()
    local itemPos = item:getPosition()

    if t.itemID then
        if t.itemID == 0 then return item:remove() end
        doTransform(itemID, itemPos, t.itemID, itemAID)
    elseif itemAID then
        item:setActionId(itemAID)
    end
    
    if t.returnDelay then addEvent(doTransform, t.returnDelay, t.itemID, itemPos, itemID, itemAID) end
end

function actionSystem:setSVTable(player) return self.setSV and setSV(player, self.setSV) end
function actionSystem:addSVTable(player) return self.addSV and setSV(player, self.addSV) end
function actionSystem:rewardItems2(player) return not self.rewardItems and true or player:rewardItems(self.rewardItems) end

function actionSystem:hasItemList(player)
    local t = self.hasItems
    if not t then return true end
    if t.itemID or t.itemAID then t = {t} end

    for _, itemT in pairs(t) do
        if player:getItemCount(itemT.itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer) < (itemT.count or 1) then return end
    end
    return true
end

function actionSystem:hasItemListF(player)
    local t = self.hasItemsF
    if not t then return true end
    if t.itemID or t.itemAID then t = {t} end

    for _, itemT in pairs(t) do
        if player:getItemCount(itemT.itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer) >= (itemT.count or 1) then return end
    end
    return true
end

function actionSystem:takeItems2(player)
    local t = self.takeItems
    if not t then return true end
    if t.itemID or t.itemAID then t = {t} end
    
    for _, itemT in pairs(t) do
        if player:getItemCount(itemT.itemID, itemT.itemAID, itemT.type, itemT.dontCheckPlayer) < (itemT.count or 1) then return end
    end
    for _, itemT in pairs(t) do
        player:removeItem(itemT.itemID, itemT.count, itemT.itemAID, itemT.type, itemT.dontCheckPlayer)
    end
    return true
end

function actionSystem:ME_effects(player, item)
    local t = self.ME
    if not t then return end
    local pos = t.pos
    
    if not pos then
        if not item then return print("ERROR - done fucked it up actionSystem:ME_effects()") end
        pos = item:getPosition()
    elseif type(pos) == "string" then
        if pos == "itemPos" then
            if not item then return print("ERROR 2 - done fucked it up actionSystem:ME_effects()") end
            pos = item:getPosition()
        elseif pos == "homePos" then
            pos = player:homePos()
        elseif pos == "playerPos" then
            pos = player:getPosition()
        else
            print("ERROR 3 - dont have such position in actionSystem:ME_effects() : "..tostring(pos))
        end
    end
    
    if not pos then return end
    local effects = t.effects
    local interval = t.interval or 0
        
    if type(effects) == "number" then effects = {effects} end
    for i, e in ipairs(effects) do addEvent(doSendMagicEffect, interval*(i-1), pos, e) end
end

function timers(player, itemT)
    if not itemT.timers then return true end
    if itemT:timeTrigger(player) then return end
    if itemT:GUIDTrigger(player) then return end
    return true
end

function actionSystem:checkSVTable(player) return compareSV(player, self.allSV, "==") end
function actionSystem:bigSV2(player) return compareSV(player, self.bigSV, ">=") end

function actionSystem:anySV2(player)
    local t = self.anySV
    if not t then return true end
    return anySV_findMatch(player, t)
end

function actionSystem:timeTrigger(player)
    local t = self.timers
    local time = t.time
    if not time then return end
    local waitTime = t.lastTime + time

    if waitTime < os.time() then
        t.lastTime = os.time()
    else
        local text = t.text
        
        if not text and t.showTime then text = "You need to wait " end
        if text and player:isPlayer() then
            if t.showTime then text = text..getTimeText(waitTime - os.time()) end
            player:sendTextMessage(GREEN, text)
        end
        return true
    end
end

function actionSystem:GUIDTrigger(player)
    local t = self.timers
    local time = t.guidTime
    if not time or not player:isPlayer() then return end
    local guid = player:getGuid()
    local lastTime = t.lastGuidTime[guid] or 0
    local waitTime = lastTime + time

    if waitTime < os.time() then
        t.lastGuidTime[guid] = os.time()
    else
        local text = t.text
        
        if not text and t.showTime then text = "You need to wait " end
        if text then
            if t.showTime then text = text..getTimeText(waitTime - os.time()) end
            player:sendTextMessage(GREEN, text)
        end
        return true
    end
end

function actionSystem:func(player, item, itemEx, fromPos, toPos, fromObject, toObject)
    local f = self.funcSTR or self.funcStr
    if not f then return true end
    if not _G[f] then Vprint(f, "func doesnt exist") end
    return _G[f](player, item, itemEx, fromPos, toPos, fromObject, toObject)
end

function actionSystem:teleport2(player, item)
    local pos = self.teleport
    if not pos then return end
    local playerPos = player:getPosition()

    if type(pos) == "string" then
        if pos == "itemPos" and item then pos = item:getPosition() end
        if pos == "homePos" and player then pos = player:homePos() end
    end
    if samePositions(playerPos, pos) then return end
    teleport(player, pos)
end

function actionSystem:teleport3(player) return self.teleportF and teleport(player, self.teleportF) end

local function sendMessages(player, msgT)
    local textType = msgT.type or GREEN
    local messages = msgT.msg

    if not messages then return end
    if type(messages) ~= "table" then messages = {messages} end
    for i, MSG in ipairs(messages) do player:sendTextMessage(textType, MSG) end
end

local function svMessages(player, svMsgT)
    if not svMsgT then return end
    
    for svT, msgT in pairs(svMsgT) do
        if getSV(player, svT[1]) == svT[2] then
            sendMessages(player, msgT)
        end
    end
end

function actionSystem:text2(player, item)
    local t = self.text

    if not t then return end
    sendMessages(player, t)
    if not t.text then return svMessages(player, t.svText) end
    local itemPos = item and item:getPosition()
    local pos = t.text.position or itemPos

    text(t.text.msg, pos)
end

function actionSystem:text3(player, item)
    local t = self.textF

    if not t then
        if self.text and self.text.useOnFail then return self:text2(player, item) end
        return
    end
    
    sendMessages(player, t)
    if not t.text then return svMessages(player, t.svText) end
    local itemPos = item and item:getPosition()
    local pos = t.text.position or itemPos

    text(t.text.msg, pos)
end

function actionSystem:giveHP(player) return self.health and player:addHealth(self.health) end
function actionSystem:giveMP(player) return self.mana and player:addMana(self.mana) end
function actionSystem:exp2(player) return self.exp and player:addExpPercent(self.exp) end

local function createItemT(player, item, itemT)
    local newItemT = {
        delay = itemT.delay,
        pos = itemT.pos or item and item:getPosition(),
        itemID = itemT.itemID or item and item:getId(),
        itemAID = itemT.itemAID,
        count = itemT.count or 1,
        fluidType = itemT.type or itemT.fluidType,
    }
    if not newItemT.itemID then return error("ERROR - itemID missing createItemT()") end
    if not newItemT.pos then return error("ERROR - pos missing createItemT()") end
    return newItemT
end

function actionSystem:createItems2(player, item)
    local bigItemT = self.createItems
    if not bigItemT then return end

    for _, itemT in pairs(bigItemT) do
        local newItemT = createItemT(player, item, itemT)
        
        if item and newItemT.itemID == item:getId() then
            newItemT.itemAID = item:getActionId()
            newItemT.fluidType = item:getFluidType()
        end
        
        if newItemT.delay then
            addEvent(createItem, newItemT.delay, newItemT.itemID, newItemT.pos, newItemT.count, newItemT.itemAID, newItemT.fluidType)
        else createItem(newItemT.itemID, newItemT.pos, newItemT.count, newItemT.itemAID, newItemT.fluidType) end
    end
end

function actionSystem:removeItems2(player, item)
    local bigItemT = self.removeItems
    if not bigItemT then return end
    
    for _, itemT in pairs(bigItemT) do
        local newItemT = createItemT(player, item, itemT)
        
        if newItemT.delay then addEvent(removeItemFromPos, newItemT.delay, newItemT.itemID, newItemT.pos, newItemT.count)
        else removeItemFromPos(newItemT.itemID, newItemT.pos, newItemT.count) end
    end
end

function actionSystem:createMonster2(player, item)
    local t = self.createMonster
    if not t then return end
        
    for _, monsterT in pairs(t) do
        local name = monsterT.name
        local pos = monsterT.pos or item and item:getPosition()
        local count = monsterT.count or 1
        local delay = monsterT.delay
        
        if not pos then return print("ERROR - pos missing actionSystem:createMonster2()") end
        for c=1, count do
            if delay then createMonster(name, pos) else addEvent(createMonster, delay, name, pos) end
        end
    end
end

function central_register_actionEvent(actionT, central_actionT)
    if not actionT then return end
    if not central_actionT then return error("ERROR in central_register_actionEvent - missing central_actionT") end

    if type(central_actionT) == "string" then
        if central_actionT == "IDItems" then
            central_actionT = IDItems
            
            for ID, t in pairs(actionT) do
                Game.doRegisterItemAction(ID, (t.allowFarUse == false or true), t.blockWalls)
            end
        elseif central_actionT == "AIDItems" then
            central_actionT = AIDItems
            
            for ID, t in pairs(actionT) do
                Game.doRegisterIdAction(ID, (t.allowFarUse == false or true), t.blockWalls)
            end
        end
    end

    for ID, t in pairs(actionT) do
        actionSystem_checkTable(t)
        central_actionT[ID] = t
    end

    if check_central_register_actionEvent then print("central_register_actionEvent") end
end
