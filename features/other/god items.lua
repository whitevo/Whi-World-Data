-- god command !god creates the items. (data/talkactions/scripts/creating/create godStuff.lua)
local feature_godItems = {
    AIDItems = {
        [AID.other.ghostOrb] = {funcStr = "ghostOrb_onUse"},
        [AID.other.tpRune] = {funcStr = "teleportRune_onUse"},
        [AID.other.luaRune] = {funcStr = "luaRune_onUse"},
        [AID.other.aoeRune] = {funcStr = "aoeRune_onUse"},
        [AID.other.copyRune] = {funcStr = "copyRune_onUse"},
    },
    AIDItems_onLook = {
        [AID.other.ghostOrb] = {text = {msg = "use this item to turn invisible"}},
        [AID.other.tpRune] = {text = {msg = "use this item on location where to teleport or onself to give yourself teleport powers"}},
        [AID.other.luaRune] = {text = {msg = "use on creature to set > luaCreatureUserData. Use on item to set > luaItemUserData)"}},
        [AID.other.aoeRune] = {text = {msg = "deals damage to an area"}},
        [AID.other.copyRune] = {text = {msg = "either copy or paste objects. Rune state can be changed by using it on itself."}},
    }
}
centralSystem_registerTable(feature_godItems)

local function removeGodItem(player, item)
    if testServer() then return end
    if not player:isGod() then return end
    player:sendTextMessage(GREEN, "You should not have that item!!")
    return item:remove()
end

function ghostOrb_onUse(player, item)
    local playerPos = player:getPosition()
    local isGhost = not player:isInGhostMode()

    if removeGodItem(player, item) then return end
    player:setGhostMode(isGhost)

	if isGhost then
		player:sendTextMessage(GREEN, "You are now invisible.")
		playerPos:sendMagicEffect(CONST_ME_YALAHARIGHOST)
	else
		player:sendTextMessage(GREEN, "You are visible again.")
        playerPos.x = playerPos.x+1
		playerPos:sendMagicEffect(CONST_ME_SMOKE)
	end
end

function teleportRune_onLook(player, item, itemEx, fromPos, toPos)

end

function teleportRune_onUse(player, item, itemEx, fromPos, toPos)
    if not toPos then return end
    if itemEx and itemEx:isPlayer() and player:getId() == itemEx:getId() then
        local state = toggleSV(player, SV.onLookTP)
        if state == 1 then return player:sendTextMessage(GREEN, "You now teleport by looking objects") end
        return player:sendTextMessage(GREEN, "OnLook teleporting turned off")
    end
   -- if removeGodItem(player, item) then return end
    player:teleportTo(toPos)
    if player:isInGhostMode() then return end
    doSendMagicEffect(toPos, CONST_ME_THUNDER)
    doSendMagicEffect(toPos, CONST_ME_PURPLEENERGY)
    doSendMagicEffect(toPos, CONST_ME_ENERGYAREA)
end

function luaRune_onUse(player, item, target, fromPos, toPos)
    local target = checkForItemEx(target, toPos)
    if not target then return end
    if not player:isGod() then return end
    local itemID = item:getId()
    local targeName = target:getName()

    if target:isCreature() then
        luaCreatureUserData = target
        player:sendTextMessage(BLUE, "new luaCreatureUserData name = ["..targeName.."]")
    elseif target:isItem() then
        luaItemUserData = target
        player:sendTextMessage(BLUE, "new luaItemUserData name = ["..targeName.."]")
    else
        player:sendTextMessage(BLUE, targeName.." is not creature nor item")
    end
end

function aoeRune_onUse(player, item, fromPos, itemEx, toPos)
    if not toPos then return end
    if removeGodItem(player, item) then return end
    local area = {
        {n, n, n, 6, 6, 6, n, n, n},
        {n, n, 6, 5, 5, 5, 6, n, n},
        {n, 6, 5, 4, 3, 4, 5, 6, n},
        {6, 5, 4, 3, 2, 3, 4, 5, 6},
        {6, 5, 3, 2, 1, 2, 3, 5, 6},
        {6, 5, 4, 3, 2, 3, 4, 5, 6},
        {n, 6, 5, 4, 3, 4, 5, 6, n},
        {n, n, 6, 5, 5, 5, 6, n, n},
        {n, n, n, 6, 6, 6, n, n, n},
    }
    local area = getAreaPos(toPos, area)
    local playerID = player:getId()

    for i, posT in pairs(area) do
        for _, pos in pairs(posT) do
            addEvent(dealDamagePos, i*100, playerID, pos, HOLY, 20000, 25, O_player_spells, 13, 23)
        end
    end
end

local loopID = 0
local creatureList = {}
local itemList = {}
local mode = "copy"
function copyRune_onUse(player, item, itemEx)
    if not itemEx or type(itemEx) ~= "userdata" then return end
    if item:getId() == itemEx:getId() then
        loopID = 0
        if mode == "copy" then
            mode = "paste"
            if creatureList[1] then return player:sendTextMessage(GREEN, "next monster is: "..creatureList[1]) end
            if itemList[1] then return player:sendTextMessage(GREEN, "next item is: "..itemList[1].itemName) end
        else
            creatureList = {}
            itemList = {}
            mode = "copy"
        end
        return player:sendTextMessage(GREEN, "turned in "..mode.." mode")
    end
    local itemPos = itemEx:getPosition()
    local playerPos = player:getPosition()

    if mode == "copy" then
        local name = itemEx:getName()
        
        if itemEx:isMonster() then
            if not isInArray(creatureList, name) then table.insert(creatureList, name) end
            local nameList = tableToStr(creatureList, ", ")
            player:sendTextMessage(GREEN, ">> "..nameList.." <<")
            itemList = {}
        elseif itemEx:isItem() then
            local itemT = {
                itemID = itemEx:getId(),
                itemAID = itemEx:getActionId(),
                itemText = itemEx:getAttribute(TEXT),
                itemType = itemEx:getFluidType(),
                itemName = name
            }
            table.insert(itemList, itemT)
            local allItemNames = {}
            for i, itemT in ipairs(itemList) do allItemNames[i] = itemT.itemName end
            local nameList = tableToStr(allItemNames, ", ")
            creatureList = {}
            player:sendTextMessage(GREEN, ">> "..nameList.." <<")
        end
        doSendDistanceEffect(itemPos, playerPos, 5)
    else
        loopID = loopID + 1
        local creatureCount = tableCount(creatureList)
        local itemCount = tableCount(itemList)
        local nextID = loopID + 1
        
        doSendDistanceEffect(playerPos, itemPos, 5)
        
        if creatureCount > 0 then
            if loopID > creatureCount then loopID = 1 end
            local monsterName = creatureList[loopID]
            
            createMonster(monsterName, itemPos)
            if nextID > creatureCount then nextID = 1 end
            player:sendTextMessage(GREEN, "next monster is: "..creatureList[nextID])
        elseif itemCount > 0 then
            if loopID > itemCount then loopID = 1 end
            local itemT = itemList[loopID]
            
            createItem(itemT.itemID, itemPos, 1, itemT.itemAID, itemT.itemType, itemT.itemText)
            if nextID > itemCount then nextID = 1 end
            player:sendTextMessage(GREEN, "next item is: "..itemList[nextID].itemName)
        end
    end
end