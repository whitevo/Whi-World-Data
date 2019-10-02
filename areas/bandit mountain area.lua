local AIDT = AID.areas.banditMountain
local northRegion = banditMountainNorth.area.areaCorners
local banditHomePosT = {} -- {monsterID = pos}

banditMountainArea = {
    name = "Bandit Mountain Area",
    startUpFunc = "banditMountainArea_startUp",
    area = {
        regions = {banditMountainUpFloor, banditMountainNorth, banditMountainSouth},
        blockObjects = {919},
        setActionID = {
            [3868] = AIDT.verticalLeatherStand,
            [3870] = AIDT.verticalWolfFurStand,
            [3867] = AIDT.horizontalLeatherStand,
            [3869] = AIDT.horizontalWolfFurStand,
            [3872] = AIDT.handAxeStump,
            [2742] = AID.herbs.brirella,
            [1423] = AID.other.fireDOT100,
            [1739] = AIDT.crates,
            [1738] = AIDT.boxes,
            [1748] = AIDT.chests,
            [1740] = AIDT.chests,
            [7605] = AIDT.emptyTent,
            [7606] = AIDT.emptyTent,
            [7607] = AIDT.emptyTent,
            [7608] = AIDT.emptyTent,
        },
    },
    itemRespawns = {
        {pos = {x = 503, y = 587, z = 6}, itemID = 2005, spawnTime = 20, fluidType = 1},    -- bucket
    },
    randomLoot = {
        [AIDT.crates] = {
            CDmin = 50,
            CDmax = 90,
            items = {
                {itemID = 2006, chance = 150, type = 0},                                -- vial
                {itemID = 2674, count = 2, itemAID = AID.other.food},                   -- apple
                {itemID = 2666, chance = 50, itemAID = AID.other.food},                 -- meat
                {itemID = 8298, chance = 40, itemAID = AID.herbs.brirella_powder},
                {itemID = 8298, chance = 40, itemAID = AID.herbs.iddunel_powder},
                {itemID = 8298, chance = 40, itemAID = AID.herbs.jesh_mint_powder},
                {chance = 30, itemID = farmingConf.seedID, itemAID = AID.herbs.iddunel_seed},
                {chance = 30, itemID = farmingConf.seedID, itemAID = AID.herbs.jesh_mint_seed},
                {chance = 30, itemID = farmingConf.seedID, itemAID = AID.herbs.mobberel_seed},
                {chance = 30, itemID = farmingConf.seedID, itemAID = AID.herbs.brirella_seed},
            }
        },
        [AIDT.boxes] = {
            items = {
                {itemID = ITEMID.other.coin, chance = 150, count = 4},                               -- gold coin
                {itemID = {2147, 9970, 2146, 2149}, chance = 150},                      -- gems: fire, ice, energy, earth
                {itemID = {5896, 5897}, chance = 80},                                   -- bear and wolf paw
                {itemID = 2544, chance = 100, count = 4},                               -- arrows
                {itemID = 13159, chance = 40},                                          -- rabbit paw
            }
        },
        [AIDT.chests] = {
            multibleAllowed = true,
            items = {
                {itemID = 2558, itemAID = AID.other.tool, chance = 150, itemText = "charges(5)"},  -- saw
                {itemID = farmingConf.seedID, chance = 100, itemAID = AID.herbs.iddunel_seed},
                {itemID = farmingConf.seedID, chance = 100, itemAID = AID.herbs.mobberel_seed},
                {itemID = {2183, 2190, 2398, 2456}, chance = 150, rollStats = true},    -- kaiju wall(wans), mace, atsui kori(wand), bow
                {itemID = {5909, 5911, 5912, 5913}, chance = 1000},                     -- cloths: red, white, blue, brown
            },
        },
    },
    AIDItems = {
        [AIDT.handAxeStump] = {
            createItems = {{delay = 120*60*1000}, {itemID = 8786}},
            rewardItems = {{itemID = 2380, itemText = "randomStats"}},
            removeItems = {{itemID = 8786, delay = 120*60*1000}, {}}
        },
        [AIDT.verticalLeatherStand] = {
            createItems = {{delay = 10*60*1000}, {itemID = 3758}, {itemID = 3761}},
            rewardItems = {{itemID = 11200}},
            removeItems = {{itemID = 3758, delay = 10*60*1000}, {itemID = 3761, delay = 10*60*1000}, {}}
        },
        [AIDT.verticalWolfFurStand] = {
            createItems = {{delay = 10*60*1000}, {itemID = 3758}, {itemID = 3761}},
            rewardItems = {{itemID = 11235}},
            removeItems = {{itemID = 3758, delay = 10*60*1000}, {itemID = 3761, delay = 10*60*1000}, {}}
        },
        [AIDT.horizontalLeatherStand] = {
            createItems = {{delay = 10*60*1000}, {itemID = 3758}, {itemID = 3759}},
            rewardItems = {{itemID = 11200}},
            removeItems = {{itemID = 3758, delay = 10*60*1000}, {itemID = 3759, delay = 10*60*1000}, {}}
        },
        [AIDT.horizontalWolfFurStand] = {
            createItems = {{delay = 10*60*1000}, {itemID = 3758}, {itemID = 3759}},
            rewardItems = {{itemID = 11235}},
            removeItems = {{itemID = 3758, delay = 10*60*1000}, {itemID = 3759, delay = 10*60*1000}, {}}
        },
        [AIDT.secretPassage] = {
            text = {msg = "Secret found, but its not yet added to game, this one wont be added any time soon anyway, Maybe Patch 0.1.9"},
        },
    },
    AIDItems_onLook = {
        [AIDT.emptyTent] = {text = {msg = "This tent seems to be empty"}},
    },
    monsters = {
        ["bandit ambush"] = {
            name = "bandit ambush",
            race = "object",
            spawnEvents = {onThink = {"banditAmbush_onThink"}},
        },
    },
}
centralSystem_registerTable(banditMountainArea)

function banditMountainArea_startUp()
    local positions = createAreaOfSquares(banditMountainArea.area.areaCorners)

    for _, pos in pairs(positions) do
        if findItem(1423, pos) then createMonster("bandit ambush", pos) end
    end
end

local escapeDistance = 20
function bandidEscapes(monster)
    local monsterID = monster:getId()
    local startPos = banditHomePosT[monsterID]
    if not startPos then return end
    local monsterPos = monster:getPosition()
    
    if getDistanceBetween(startPos, monsterPos) < escapeDistance then return end
    text("*escape*", monsterPos)
    doSendMagicEffect(monsterPos, 3)
    banditHomePosT[monsterID] = nil
    return monster:remove()
end

function banditMountain_chopBigTree(player, item, itemEx)
    if not itemEx:isItem() then return end
    if itemEx:getActionId() ~= AIDT.bigTree then return end
    local charges = tools_getCharges(item)
        if charges < 3 then return player:sendTextMessage(GREEN, "You need at least 3 charges on your "..item:getName()) end
    local respawnTime = 1000*60*60*2
    local t = {
        zMin = 2,
        zMax = 4,
        upCorner = {x = 464, y = 629},
        downCorner = {x = 468, y = 634},
    }
    local trunkT = {{x = 465, y = 631, z = 5}, {x = 466, y = 631, z = 5}, {x = 465, y = 632, z = 5}, {x = 466, y = 632, z = 5}}
    local bridgeT = {
        [4186] = {x = 459, y = 632, z = 5},
        [4188] = {x = 460, y = 632, z = 5},
        [4191] = {x = 461, y = 632, z = 5},
        [4192] = {x = 462, y = 632, z = 5},
        [4190] = {x = 463, y = 632, z = 5},
        [4187] = {x = 464, y = 632, z = 5},
        [4193] = {x = 465, y = 632, z = 5},
    }
    local function sawTree(pos)
        for _, item in pairs(Tile(pos):getItems()) do
            addEvent(createItem, respawnTime, item:getId(), pos, 1, item:getActionId())
            item:remove()
        end
    end
    
    local function dropCreature(pos)
        for _, c in pairs(Tile(pos):getCreatures()) do teleport(c, {x = 462, y = 631, z = 6}) end
    end
    
    for _, pos in pairs(trunkT) do sawTree(pos) end
    
    for z = t.zMin, t.zMax do
        local area = createSquare({x=t.upCorner.x, y=t.upCorner.y, z=z}, {x=t.downCorner.x, y=t.downCorner.y, z=z})
        for _, pos in pairs(area) do if Tile(pos) then sawTree(pos) end end
    end
    
    for itemID, pos in pairs(bridgeT) do
        doTransform(460, pos, 460)
        addEvent(doTransform, respawnTime, 460, pos, 460, 100)
        createItem(itemID, pos)
        addEvent(removeItemFromPos, respawnTime, itemID, pos)
        addEvent(dropCreature, respawnTime-1000, pos)
    end
    tools_setCharges(player, item, charges -3)
    return true
end

local checkDelay = {}
function banditAmbush_onThink(creature)
    if not creature:getCondition(INVISIBLE, 1) then bindCondition(creature, "invisible", -1) end
    local monsterID = creature:getId()
    local delay = checkDelay[monsterID] or 0
    if delay > os.time() then return end
    
    local radius = 3
    local enemies = creature:getEnemies(radius)
    if tableCount(enemies) == 0 then return end
    
    local spawnPointT = {} -- {[spawnPos] = {monsterID,}

    local function getSpawnT(pos)
        for spawnPos, monsterT in pairs(spawnPointT) do
            if samePositions(spawnPos, pos) then return monsterT end
        end
        spawnPointT[pos] = {}
        return spawnPointT[pos]
    end
    local pos = creature:getPosition()
    local spawnT = getSpawnT(pos)

    for i, monsterID in pairs(spawnT) do
        if Monster(monsterID) then
            checkDelay[monsterID] = os.time() + 10
            return
        else
            spawnT[i] = nil
        end
    end
    
    local area = createSquare({x=pos.x-radius, y=pos.y-radius, z=pos.z}, {x=pos.x+radius, y=pos.y+radius, z=pos.z})
    local positions = randomPos(area, 4, true)
    local bandits = {"bandit knight", "bandit mage", "bandit druid", "bandit hunter"}

    for tableKeyForName, pos in pairs(positions) do
        local bandit = createMonster(bandits[tableKeyForName], pos)
        local monsterID = bandit:getId()
        banditHomePosT[monsterID] = pos
        table.insert(spawnT, monsterID)
    end
    
    local ambushRespawnTime = 5*60*1000

    abductedQuest_cryForHelp(pos)
    addEvent(createMonster, ambushRespawnTime, creature:getName(), pos)
    creature:remove()
end