--[[ itemRespawns config guide
    [_] = {
        pos = POS                   spawn position
        container = INT             itemID of container in that position where item spawns
        maxAmount = INT or count    item can stack up until this amount.
        itemID = INT                itemID which will be added to that position/container.
        count = INT or 1            how many items will be added there
        itemAID = INT               
        fluidType = INT
        itemText = STR
        chance = INT or 100         % chance to spawn item
        spawnTime = INT or 60       in minutes
        offsetTime = INT or 10      in minutes
        rollStats = false           rolls random stats on equipment item
        aboveItems = {INT}          list of itemID's in ipairs which are spawned on top of itemID if they are missing.
        
        --nextAllowedSpawnTime = INT    os.time()
    }
]]
-- NB!! count == 1 if you put fluid item inside container
if not itemRespawns then itemRespawns = {} else print("YOU NEED TO RESTART SERVER IF YOU WANT OLD ITEMS TO RESPAWN TOO") end

function itemRespawns_spawnItems()
    for _, spawnT in pairs(itemRespawns) do itemRespawns_trySpawn(spawnT) end
end

local function timeCheck(allowedTime)
    if not allowedTime then return true end
    if allowedTime <= os.time() then return true end
end

local function setNewAllowedTime(spawnT)
    local spawnTime = spawnT.spawnTime or 60
    local offSet = spawnT.offsetTime or 10
    local randomTime = math.random(-offSet, offSet)
    local nextTime = spawnTime + randomTime

    spawnT.nextAllowedSpawnTime = os.time() + nextTime*60
end

function itemRespawns_trySpawn(spawnT)
    if not timeCheck(spawnT.nextAllowedSpawnTime) then return end
    local chance = spawnT.chance or 100
    setNewAllowedTime(spawnT)
    if not chanceSuccess(chance) then return end
    local pos = spawnT.pos
    local spawnItemID = spawnT.itemID
    local count = spawnT.count or 1
    local maxAmount = spawnT.maxAmount or count
    local countIncreased = false
    local newItem

    if spawnT.container then
        local container = findItem(spawnT.container, pos)
        if not container then return print("ERROR - missing container for itemRespawns"), Uprint(pos) end
        local itemCount = container:getItemCountById(spawnItemID)
        if itemCount >= maxAmount then return end
        local newAmount = count + itemCount
        if newAmount > maxAmount then count = newAmount-maxAmount end
        
        newItem = createItem(spawnItemID, pos, count, spawnT.itemAID, spawnT.fluidType, spawnT.itemText)
       
        if type(newItem) == "table" then
            for _, item in ipairs(newItem) do item:moveTo(container) end
        else
            newItem:moveTo(container)
        end
    else
        local item = findItem(spawnItemID, pos)
        
        if item then
            local itemCount = item:getCount()
            if itemCount >= maxAmount then return end
            local newAmount = count + itemCount
            if newAmount > maxAmount then newAmount = maxAmount end
            
            countIncreased = true
            item:remove()
            newItem = createItem(spawnItemID, pos, newAmount, spawnT.itemAID, spawnT.fluidType, spawnT.itemText)
        else
            newItem = createItem(spawnItemID, pos, count, spawnT.itemAID, spawnT.fluidType, spawnT.itemText)
        end
        if spawnT.rollStats then items_randomiseStats(newItem) end
    end
    
    if newItem and spawnT.aboveItems then
        if type(spawnT.aboveItems) ~= "table" then spawnT.aboveItems = {spawnT.aboveItems} end
        
        for _, itemID in ipairs(spawnT.aboveItems) do
            local item = findItem(itemID, pos)
            
            if countIncreased then
                if item then item:remove() end
                createItem(itemID, pos)
            elseif not item then
                createItem(itemID, pos)
            end
        end
    end
end

print("itemRespawnSystem loaded..")