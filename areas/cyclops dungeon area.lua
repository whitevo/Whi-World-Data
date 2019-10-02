local AIDT = AID.areas.cyclopsDungeon

cyclopsDungeon = {
    area = {
        regions = {cyclopsDungeonMountain, cyclopsDungeonFloor1, cyclopsDungeonSabotageRegion},
        blockObjects = {9026, 8133},
        setActionID = {
            [17751] = AID.herbs.flysh,
            [17750] = AID.herbs.shadily_gloomy_shroom,
        },
    },
    discover = {
        [AIDT.discoverTile] = {
            rewardSP = 1,
            SV = SV.CyclopsDungeon,
            name = "Cyclops Dungeon",
        },
    },
    AIDTiles_stepIn = {
        [AIDT.enter] = {teleport = {x = 771, y = 575, z = 8}},
    },
    AIDItems_onLook = {
        [AIDT.oilBarrel] = {text = {msg = "This barrel oozes out some black liquid"}},
    },
    AIDItems = {
        [AIDT.greyBook] = {funcSTR = "herbs_discoverHint"},
        [AIDT.HC_leave] = {teleport = {x = 629, y = 539, z = 7}},
        [AIDT.leave] = {teleport = {x = 632, y = 564, z = 7}},
        [AIDT.HC_gemAltar] = {
            timers = {
                text = "New gem is reformed in ",
                guidTime = 4*60*60,
                showTime = true,
            },
            rewardItems = {{itemID = {2147, 9970, 2150, 2146, 2149}}},
            ME = {
                pos = "itemPos",
                effects = {29,23,14},
                interval = 400,
            }
        },
    },
    homeTP = {
        pillarAID = AIDT.HC_pillar,
        chargeName = "Cyclops Dungeon",
        SV = SV.CD_teleportCharge,
    },
    itemRespawns = {
        {pos = {x = 779, y = 632, z = 8}, itemID = 2666, itemAID = AID.other.food, container = 2835, spawnTime = 30},   -- meat
        {pos = {x = 721, y = 604, z = 8}, itemID = 2671, itemAID = AID.other.food, container = 1739},                   -- ham
        {pos = {x = 721, y = 605, z = 8}, itemID = 2666, itemAID = AID.other.food, maxAmount = 2},                      -- meat
        {pos = {x = 779, y = 632, z = 8}, itemID = 11214, container = 2835, spawnTime = 30},                            -- antler
        {pos = {x = 716, y = 530, z = 8}, itemID = 2005, spawnTime = 40, fluidType = 0},                                -- bucket
        {pos = {x = 728, y = 604, z = 8}, itemID = 2666, itemAID = AID.other.food},                                     -- meat
        {pos = {x = 721, y = 604, z = 8}, itemID = 2671, itemAID = AID.other.food},                                     -- ham
        {pos = {x = 733, y = 600, z = 8}, itemID = 2671, itemAID = AID.other.food},                                     -- ham
    },
    monsterSpawns = {{
        name = "cyclops dungeon",
        spawnTime = 3*60*1000,
        monsterT = {
            ["cyclops"] = {},
        },
        spawnPoints = {
            {x = 793, y = 614, z = 8},
            {x = 764, y = 612, z = 8},
            {x = 748, y = 573, z = 8},
            {x = 770, y = 555, z = 8},
            {x = 745, y = 549, z = 8},
            {x = 758, y = 530, z = 8},
            {x = 722, y = 533, z = 8},
            {x = 720, y = 561, z = 8},
            {x = 719, y = 588, z = 8},
            {x = 630, y = 550, z = 7},
            {x = 630, y = 551, z = 6},
            {x = 650, y = 565, z = 6},
        },
    }},
}
centralSystem_registerTable(cyclopsDungeon)

local itemsToRemove = {3509, 3525, 3523} -- all positions gotta have same items
local removeFromPositions = {{x = 753, y = 526, z = 8}, {x = 754, y = 526, z = 8}}
local barrelT = {
    barrelID = 1770,
    barrelAID = AIDT.oilBarrel,
    pos = {x = 753, y = 527, z = 8},
}
local pathOpenDuration = 5 -- in minutes
local area = { -- 1-3 will also create fire field
    {n, n, n, 4, 4, 5, n},
    {n, n, n, 3, 3, 4, n},
    {n, n, n, 2, 2, n, n},
    {n, n, n, 1, 2, n, n},
    {n, n, n, 2, 2, 3, 4},
    {n, 5, 4, 3, 3, 4, 5},
    {n, 6, 5, 4, 4, 5, 5},
    {n, n, 5, 5, 5, 5, n},
    {n, n, 5, 6, 6, n, n},
}

function cyclopsDungeonOilBarrel(item, pos)
    local tile = Tile(pos)
    if not tile then return end
    
    local barrel = tile:getItemById(barrelT.barrelID)
    if not barrel then return end

    cyclopsBarrelExplosion(item, barrel)
    return true
end

local function barrelFire(i, pos)
    if i == 1 then
        createItem(1492, pos, 1, AID.other.field_fire, nil, "minDam(200) maxDam(300)")
    elseif i == 2 then
        createItem(1493, pos)
    elseif i == 3 then
        createItem(1494, pos)
    end
    decay(pos, fireFieldDecayT, true)
end

local function constructBlock()
    for _, pos in pairs(removeFromPositions) do
        for _, itemID in pairs(itemsToRemove) do createItem(itemID, pos) end
    end
    createItem(barrelT.barrelID, barrelT.pos, 1, barrelT.barrelAID)
end

function cyclopsBarrelExplosion(moveitem, tileitem)
    local damPosTable = getAreaPos(barrelT.pos, area)
    
    for i, posT in pairs(damPosTable) do
        for j, pos in pairs(posT) do
            if i <= 3 then addEvent(barrelFire, 250*i, i, pos) end
            addEvent(dealDamagePos, 200*i, 0, pos, FIRE, math.random(250, 400), 16, O_environment, 7)
        end
    end
    
    for _, pos in pairs(removeFromPositions) do
        local tile = Tile(pos)
        
        for _, itemID in pairs(itemsToRemove) do
            local item = tile:getItemById(itemID)
            if item then item:remove() else return end
        end
    end
    
    if tileitem then tileitem:remove() end
    if moveitem then moveitem:remove() end
    addEvent(constructBlock, pathOpenDuration*60*1000)
end

function heatSpellOnBarrel(pos)
    local barrel = Tile(barrelT.pos):getItemById(barrelT.barrelID)
    if samePositions(pos, barrelT.pos) and barrel then cyclopsBarrelExplosion(nil, barrel) end
end

function cyclopsDungeonWalls_damageTrigger()

end