local AIDT = AID.areas.shadowRoom
local confT = {
    bossArea = {upCorner = {x = 508, y = 709, z = 9}, downCorner = {x = 522, y = 722, z = 9}},
    altars = { -- fluid type = altar position
        [2] = {x = 508, y = 714, z = 9},
        [15]= {x = 508, y = 715, z = 9},
        [4] = {x = 508, y = 716, z = 9},
    },
    firePosT = {{x = 508, y = 709, z = 9}, {x = 522, y = 709, z = 9}, {x = 508, y = 722, z = 9}, {x = 522, y = 722, z = 9}},
    bossPos = {x = 515, y = 715, z = 9},
    explosionArea = {
        {9, 8, 8, 7, 7, 6, 6, 5, 6, 6, 7, 7, 8, 8, 9},
        {8, 8, 7, 7, 6, 6, 5, 5, 5, 6, 6, 7, 7, 8, 8},
        {8, 7, 7, 6, 6, 5, 5, 4, 5, 5, 6, 6, 7, 7, 8},
        {7, 7, 6, 6, 5, 5, 4, 4, 4, 5, 5, 6, 6, 7, 7},
        {7, 6, 6, 5, 5, 4, 4, 3, 4, 4, 5, 5, 6, 6, 7},
        {6, 6, 5, 5, 4, 4, 3, 2, 3, 4, 4, 5, 5, 6, 6},
        {6, 5, 5, 4, 4, 3, 2, 1, 2, 3, 4, 4, 5, 5, 6},
        {5, 5, 4, 4, 3, 2, 1, 0, 1, 2, 3, 4, 4, 5, 5},
        {6, 5, 5, 4, 4, 3, 2, 1, 2, 3, 4, 4, 5, 5, 6},
        {6, 6, 5, 5, 4, 4, 3, 2, 3, 4, 4, 5, 5, 6, 6},
        {7, 6, 6, 5, 5, 4, 4, 3, 4, 4, 5, 5, 6, 6, 7},
        {7, 7, 6, 6, 5, 5, 4, 4, 4, 5, 5, 6, 6, 7, 7},
        {8, 7, 7, 6, 6, 5, 5, 4, 5, 5, 6, 6, 7, 7, 8},
        {8, 8, 7, 7, 6, 6, 5, 5, 5, 6, 6, 7, 7, 8, 8},
        {9, 8, 8, 7, 7, 6, 6, 5, 6, 6, 7, 7, 8, 8, 9},
    },
}

local monster_shadow = {
    name = "Shadow boss room",
    area = {
        areaCorners = {
            {upCorner = {x = 524, y = 715, z = 8}, downCorner = {x = 532, y = 717, z = 8}},
            confT.bossArea,
        },
    },
    keys = {
        ["Shadow room key"] = {
            itemAID = AIDT.shadowKey,
            keyID = SV.shadowRoomKey,
            keyFrom = "Found in Forgotten Village",
            keyWhere = "Used for the door in tutorial room.",
        },
    },
    AIDItems = {
        [AIDT.door] = {
            bigSV = {[SV.shadowRoomKey]=0},
            setSV = {[SV.shadowRoomKey]=1},
            funcSTR = "automaticDoor",
            textF = {msg = "This door needs key and you don't have it."},
        },
    },
    AIDTiles_stepIn = {
        [AIDT.damageDolls] = {funcSTR = "shadowRoom_doll"},
    },
    AIDTiles_stepOut = {
        [AIDT.damageDolls] = {funcSTR = "shadowRoom_doll"},
    },
    registerEvent = {
        onHealthChange = {shadow = "shadow_energyShield"}
    },
    bossRoom = {
        upCorner = confT.bossArea.upCorner,
        downCorner = confT.bossArea.downCorner,
        roomAID = AIDT.lever,
        leaveAID = AIDT.leave,
        signAID = AIDT.sign,
        highscoreAID = AIDT.highscores,
        quePos = {{x = 525, y = 717, z = 8}},
        enterPos = {{x = 518, y = 715, z = 9}},
        kickPos = {x = 528, y = 717, z = 8},
        bossName = "shadow",
        clearObjects = {11207, 9019},
        respawnCost = 10,
        bountyStr = "shadowRoomBounty",
        respawnSV = SV.shadowRoomRespawn,
        killSV = SV.shadowKill,
        rewardExp = 50,
        funcForAID = {
            [AIDT.lever] = "shadowRoom_enter",
        },
    },
    monsters = {
        ["shadow"] = {
            name = "Shadow",
            reputationPoints = 10,
            race = "undead",
            bossRoomAID = AIDT.lever,
            spawnEvents = defaultBossSpawnEvents,
        },
    },
    monsterSpells = {
        ["shadow"] = {
            "shadow doll summon",
            "shadow blast",
            "shadow movement",
            "damage: cd=1000, d=100-300",
            "damage: cd=1000, d=30-80, r=7, fe=8",
        },
    },
    monsterResistance = {
        ["shadow"] = {
            PHYSICAL = 25,
            ICE = 0,
            FIRE = 62,
            ENERGY = 80,
            DEATH = 50,
            HOLY = -50,
            EARTH = 30,
        },
    },
    monsterLoot = {
        ["shadow"] = {
            storage = SV.shadow,
            bounty = {[ITEMID.other.coin] = {amount = "shadowRoomBounty"}},
            items = {
                [1954] = {itemAID = AID.recipes.warriorBoots, chance = 15, knight = 15, firstTime = 25, partyBoost = "false"},  -- warrior boots recipe
                [2522] = {chance = 15, druid = 15, firstTime = 25, partyBoost = "false"},   -- bianhuren
                [7730] = {chance = 15, mage = 15, firstTime = 25, partyBoost = "false"},    -- kamikaze pants
                [2150] = {chance = 100, partyBoost = "false"},                              -- death gem
                [2286] = {chance = 100},                                                    -- skill stone
            }
        },
    },
}
centralSystem_registerTable(monster_shadow)

local function checkVials(item, toPos)
    for requiredFluidType, altarPos in pairs(confT.altars) do
        if item and samePositions(toPos, altarPos) then
            if item:getFluidType() ~= requiredFluidType then return true end
        else
            local vial = findItem(2006, altarPos)
            if not vial or vial:getFluidType() ~= requiredFluidType then return true end
        end
    end
end

local function movedToShadowRoomAltar(item, toPos)
    if item:getId() ~= 2006 then return end
    for requiredFluidType, altarPos in pairs(confT.altars) do
        if samePositions(toPos, altarPos) then return true end
    end
end

local function checkFirePlaces()
    for i, pos in pairs(confT.firePosT) do
        if findItem(1423, pos) then return true end
    end
end

function shadowRoom_placeVial(player, item, toPos)
    if item and not movedToShadowRoomAltar(item, toPos) then return end
    local bossPos = confT.bossPos
    if checkFirePlaces() then return false, text("aaaargh, too bright!!", bossPos) end
    if checkVials(item, toPos) then return end
    
    for requiredFluidType, altarPos in pairs(confT.altars) do
        local vial = findItem(2006, altarPos)
        if not vial and item then vial = item end
        if vial then vial:remove() end
    end
    local room = createAreaOfSquares({confT.bossArea})
    local damPosTable = getAreaPos(bossPos, confT.explosionArea)

    for x=1, 30 do
        local texts = {"*rumble*", "*crumble*", "*shakerino*"}
        local randomPos = randomPos(room, 1)
        local randomText = texts[math.random(1, #texts)]
        
        addEvent(text, x*300, randomText, randomPos[1])
    end
    
    for i, posT in pairs(damPosTable) do
        for _, pos in pairs(posT) do
            addEvent(dealDamagePos, 300*30+200*i, 0, pos, FIRE, 500, 6, O_environment, 7)
        end
    end
    addEvent(createMonster, 300*30, "shadow", bossPos)
    return true
end

local function dollDmg(creature, pos, damType, effect, hitEffect)
    if creature:isPlayer() then return doDamage(creature, damType, 200, effect, O_environment) end
    
    if not creature:isMonster() then return end
local damPosTable = getAreaPos(pos, confT.explosionArea)
    
    for i, posT in pairs(damPosTable) do
        for _, pos in pairs(posT) do
            addEvent(dealDamagePos, 300*(i+1), 0, pos, damType, 300, hitEffect, O_environment_player, effect)
        end
    end
end

function shadowRoom_doll(creature, item)
    if item:getId() == 11207 then
        dollDmg(creature, item:getPosition(), ICE, 43, 42)
    elseif item:getId() == 9019 then
        dollDmg(creature, item:getPosition(), FIRE, 16, 37)
    end
    item:remove()
end

function shadowRoom_enter(player, item)
local bossT = getBossRoom(item:getActionId())
    if not bossT then return end
local bossRoom = createAreaOfSquares({{upCorner = bossT.upCorner, downCorner = bossT.downCorner}})

    changeLever(item)
    if player:hasFood() then return player:sendTextMessage(GREEN, "can't enter Shadow room with food") end
    
    for _, pos in pairs(bossRoom) do
        if findCreature("player", pos) then return player:sendTextMessage(GREEN, "Boss room is not empty") end
    end
    
    shadowRoom_litFirePlaces(player, item)
    bossRoom_clear(bossT)
    for i, pos in pairs(bossT.quePos) do teleport(findCreature("player", pos), bossT.enterPos[i]) end
end

function shadowRoom_litFirePlaces(player, item)
    local room = createAreaOfSquares({confT.bossArea})
    for i, pos in ipairs(room) do doTransform(1422, pos, 1423) end
end

function shadowRoom_leaveRoom(player, item)
    if not bossRoom_leave(player, item) then return end
    local svT = {SV.mummyDollBuff, SV.mummyDollBuff, SV.vampireDollBuff, SV.shadowRoomRespawn}
    removeSV(player, svT)
    unregisterEvent(player, "onThink", "fireAura")
    unregisterEvent(player, "onThink", "iceAura")
end

function shadowRoom_moveDoll(player, item, toPos)
    if toPos.x ~= 65535 then return end
    if item:getActionId() ~= AIDT.damageDolls then return end
    local itemID = item:getId()

    if itemID == 11207 then   --mummy doll
        doDamage(player, ICE, 170, 43, O_monster_spells)
        setSV(player, SV.mummyDollBuff, 1)
        registerEvent(player, "onThink", "iceAura")
    elseif itemID == 9019 then --vampire doll
        doDamage(player, FIRE, 170, 16, O_monster_spells)
        setSV(player, SV.vampireDollBuff, 1)
        registerEvent(player, "onThink", "fireAura")
    end
    return item:remove()
end

function shadow_energyShield(creature, attacker, damage, damType, origin)
    if not attacker then return damage, damType end
    dealDamage(creature, attacker, ENERGY, math.random(35, 65), 48, O_monster_procs)
    attacker:getPosition():sendMagicEffect(31)
    creature:getPosition():sendMagicEffect(31)
    return damage, damType
end

customSpells["shadow doll summon"] = {
    cooldown = 16000,
    firstCastCD = 10000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {
            startPoint = "caster",
            areaConfig = {area = areas["5x5_0"]},
            blockObjects = {"enemy", 11207, 9019, "solid"},
            randomPos = 4,
        },
    },
    changeEnvironment = {items = {11207, 9019}, itemAID = AIDT.damageDolls, randomised = true},
    magicEffect = {effect = 29}
}

local shadowBlastArea = {
    {n, n,  4,  4,  4,  4, 4,  4,  4,  4,  4, n, n},
    {n, 4,  4,  3,  3,  3, 3,  3,  3,  3,  4, 4, n},
    {4, 4,  3,  n,  2,  2, 2,  2,  2,  n,  3, 4, 4},
    {4, 3,  n,  2,  2,  n, 2,  n,  2,  2,  n, 3, 4},
    {4, 3,  2,  2,  2,  1, 1,  1,  2,  2,  2, 3, 4},
    {4, 3,  2,  n,  1,  1, 1,  1,  1,  n,  2, 3, 4},
    {4, 3,  2,  2,  1,  1, 0,  1,  1,  2,  2, 3, 4},
    {4, 3,  2,  n,  1,  1, 1,  1,  1,  n,  2, 3, 4},
    {4, 3,  2,  2,  2,  1, 1,  1,  2,  2,  2, 3, 4},
    {4, 3,  n,  2,  2,  n, 2,  n,  2,  2,  n, 3, 4},
    {4, 4,  3,  n,  2,  2, 2,  2,  2,  n,  3, 4, 4},
    {n, 4,  4,  3,  3,  3, 3,  3,  3,  3,  4, 4, n},
    {n, n,  4,  4,  4,  4, 4,  4,  4,  4,  4, n, n},
}
local shadowHealArea = {
    {n,  1,  n,  n, n,  n,  n,  1,  n},
    {1,  n,  n,  1, n,  1,  n,  n,  1},
    {n,  n,  n,  n, n,  n,  n,  n,  n},
    {n,  1,  n,  n, n,  n,  n,  1,  n},
    {n,  n,  n,  n, 0,  n,  n,  n,  n},
    {n,  1,  n,  n, n,  n,  n,  1,  n},
    {n,  n,  n,  n, n,  n,  n,  n,  n},
    {1,  n,  n,  1, n,  1,  n,  n,  1},
    {n,  1,  n,  n, n,  n,  n,  1,  n},
}

customSpells["shadow blast"] = {
    cooldown = 10000,
    targetConfig = {"enemy"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = shadowBlastArea}}},
	damage = {
        interval = 150,
        minDam = 200,
        maxDam = 200, 
        damType = PHYSICAL,
        effect = 3,
        effectOnHit = 18,
        effectOnMiss = 3,
    },
    heal = {
        position = {startPosT = {startPoint = "caster", areaConfig = {area = shadowHealArea}}},
        effect = {2, 29},
        minHeal = 10,
        maxHeal = 20,
    }
}

local northArea = {
    {1},
    {0},
}
local northWestArea = {
    {1, n, n},
    {n, 0, n},
    {n, n, n},
}
customSpells["shadow movement"] = {
    cooldown = 5000,
    firstCastCD = 10000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "cTarget", areaConfig = {useStartPos = true, area = northArea, relativeArea = northWestArea}},
    },
    teleport = {targetConfig = {"caster"},walkSpeed = 50, teleportInterval = 200},
	damage = {
        minDam = 150,
        maxDam = 300, 
        damType = PHYSICAL,
        effect = 1,
        effectOnHit = 35,
    },
}

function aura(creatureID, direction, flyEffect)
    local creature = Creature(creatureID)
    if not creature then return end

    local creaturePos = creature:getPosition()
    local startPos = getDirectionPos(creaturePos, compass1[direction])
    direction = direction + 1
    local newDir = direction == 5 and 1 or direction
    local endPos = getDirectionPos(creaturePos, compass1[newDir])
    doSendDistanceEffect(startPos, newPos, flyEffect)
end

function fireAura(creatureID)
    local creatureID = creature:getId()
    for direction=1, 4 do addEvent(aura, (x-1)*250, creatureID, direction, 4) end
    doSendMagicEffect(creature:getPosition(), 2)
end

function iceAura(creatureID)
    local creatureID = creature:getId()
    for direction=1, 4 do addEvent(aura, (x-1)*250, creatureID, direction, 37) end
    doSendMagicEffect(creature:getPosition(), 2)
end

function mummyDollHit(player, target)
    if getSV(player, SV.mummyDollBuff) ~= 1 then return end
    local damage = 350

    damage = damage + elemental_powers(player, damage, ICE)
    doDamage(target:getId(), ICE, damage, 43, O_player_proc)
    removeSV(player, SV.mummyDollBuff)
    unregisterEvent(player, "onThink", "iceAura")
end

function vampireDollHit(player, target)
    if getSV(player, SV.vampireDollBuff) ~= 1 then return end
    local damage = 1150

    damage = damage + elemental_powers(player, damage, FIRE)
    doDamage(target:getId(), FIRE, damage, 16, O_player_proc)
    removeSV(player, SV.vampireDollBuff)
    unregisterEvent(player, "onThink", "fireAura")
end