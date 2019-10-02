local monster_ghoul = {
    registerEvent = {
        onDeath = {ghoul = "ghoul_explosion"}
    },
    monsters = {
        ["ghoul"] = {
            name = "Ghoul",
            reputationPoints = 5,
            race = "undead",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 3,
                killsRequired = 10,
                storageID = SV.ghoulTask,
                storageID2 = SV.ghoulTaskOnce,
                skillPoints = 1,
                location = "In Rooted Catacombs",
                reputation = 15,
            }
        },
    },
    monsterSpells = {
        ["ghoul"] = {
            "ghoul strike",
            "ghoul regen",
            "ghoul gas",
            "damage: cd=2000, d=25-50, t=DEATH",
            finalDamage = 12,
        },
    },
    monsterResistance = {
        ["ghoul"] = {
            PHYSICAL = 15,
            ICE = 30,
            FIRE = 50,
            ENERGY = 30,
            DEATH = 75,
            HOLY = -30,
            EARTH = 75,
        },
    },
    monsterLoot = {
        ["ghoul"] = {
            storage = SV.ghoul,
            items = {
                [11303] = {chance = 4, knight = 2, firstTime = 2, partyBoost = "false"},    -- kakki boots
                [23540] = {chance = 4, knight = 2, firstTime = 2, partyBoost = "false"},    -- chivit boots
                [18400] = {chance = 3, hunter = 4, firstTime = 5, partyBoost = "false"},    -- chamak legs
                [2504] = {chance = 3, knight = 4, firstTime = 5, partyBoost = "false"},     -- stone legss
                [11117] = {chance = 4, druid = 2, firstTime = 2, partyBoost = "false"},     -- zvoid boots
                [2507] = {chance = 3, druid = 4, firstTime = 5, partyBoost = "false"},      -- gribit legs
                [7893] = {chance = 4, mage = 2, firstTime = 2, partyBoost = "false"},       -- arcane boots
                [2495] = {chance = 3, mage = 4, firstTime = 5, partyBoost = "false"},       -- demonic legs
                [ITEMID.other.coin] = {chance = {45,30,20}, count = {2,5,8}},
                [2150] = {chance = 10},                                                     -- death gem
                [2312] = {chance = 20},                                                     -- sight stone
                [11136] = {chance = 25},                                                    -- ghoul flesh
            }
        },
    },
}
centralSystem_registerTable(monster_ghoul)


local ghoulArea = {
    {     2, {3,11},      4},
    {{9,14}, {1,10}, {5,12}},
    {     8, {7,13},      6},
}
local itemArea = {
    [1] = 13618,
    [2] = 13615,
    [3] = 13616,
    [4] = 13616,
    [5] = 13616,
    [6] = 13617,
    [7] = 13618,
    [8] = 13618,
    [9] = 13618,
    [10] = 13614,
    [11] = 13615,
    [12] = 13617,
    [13] = 13617,
    [14] = 13615,
}
function ghoul_explosion(monster, corpse)
    local monsterPos = monster:getPosition()
    local area = getAreaPos(monsterPos, ghoulArea)
    --local area = removePositions(tempArea, "solid")

    text("*bleagh*", monsterPos)
    for i, posT in pairs(area) do
        for _, pos in pairs(posT) do
            if i < 10 then doSendMagicEffect(pos, 29) end
            createItem(itemArea[i], pos, 1, AID.areas.ghoulRoom.ghoul_bodyRemains)
            addEvent(removeItemFromPos, 90000, itemArea[i], pos)
        end
    end
    addEvent(reviveGhoul, 60000, monsterPos)
end


function reviveGhoul(revivePos)
    local corpse = Tile(revivePos):getItemById(3113)
    if not corpse then return end
    local area = getAreaAround(revivePos)
    local effects = {42, 15}
    local effects2 = {29, 30, 31}
        
    for x=1, 3 do
        for _, pos in pairs(area) do
            local delay = math.random(0, 2000)
            local effect = effects[math.random(2)]
            local effect2 = effects2[math.random(3)]
            
            addEvent(doSendDistanceEffect, delay, pos, revivePos, effect)
            addEvent(doSendMagicEffect, delay, pos, effect2)
        end
    end
    corpse:remove()
    addEvent(createMonster, 1000, "ghoul", revivePos)
end

function ghoulMove(player, item, toPos)
    if item:getId() ~= 5976 and item:getId() ~= 3113 then return end
    if getDistanceBetween(item:getPosition(), toPos) < 2 then return end
    return player:sendTextMessage(GREEN, "Ghoul body is too heavy to throw. You can drag it 1 tile at once.")
end

function ghoul_bodyRemains(creature, item)
    if not creature:isPlayer() then return end
    doSendMagicEffect(creature:getPosition(), 14)
    bindCondition(creature, "monsterSlow", 3000, {speed = -150})
end

function ghoul_corpse_onUse(player, item)
    local ghoulPukeList = getGhoulPuke()
    local tileItems = Tile(item:getPosition()):getItemList()

    for _, itemT in pairs(tileItems) do
        if isInArray(ghoulPukeList, itemT.itemID) then return player:sendTextMessage(GREEN, "This puke seems to keep ghoul alive.") end
    end
end

function getGhoulPuke()
    local items = {}

    for _, itemID in pairs(itemArea) do
        if not isInArray(items, itemID) then table.insert(items, itemID) end
    end
    return items
end

local strikeArea = {
    {1},
    {1},
    {0},
}
    
customSpells["ghoul strike"] = {
    cooldown = 3000,
    targetConfig = {"enemy"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = strikeArea}}},
    damage = {
        minDam = 125,
        maxDam = 225,
        damType = DEATH,
        effect = 18,
        effectOnHit = 4,
    },
}

customSpells["ghoul regen"] = {
    cooldown = 30000,
    firstCastCD = 15000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "caster", areaConfig = {area = areas["3x3_0"]}},
    },
	event = {onTargets = true, register = {onThink = "ghoul_regen"}},
    magicEffect = {onTargets = true, effect = 8},
    flyingEffect = {effect = 15},
}

customSpells["ghoul gas"] = {
    cooldown = 10000,
    targetConfig = {"cTarget"},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    changeEnvironment = {
        delay = 2000,
        items = {1503},
        itemAID = AID.areas.ghoulRoom.ghoulGasField,
        removeItems = {1503},
        removeTime = 60000,
        
        damage = {
            hook = true,
            minDam = 200,
            maxDam = 500,
            damType = EARTH,
            effectOnHit = 21,
        },
    },
    flyingEffect = {effect = 31},
    magicEffect = {effect = {40,40,40,40}, effectInterval = 500}
}

function ghoul_gasField(creature, item)
    if not creature:isPlayer() then return end
    doSendMagicEffect(creature:getPosition(), 8)
    bindCondition(creature:getId(), "earth", 10000, {dam = 40, interval = 500})
end

function ghoul_regen(monster)
    doSendMagicEffect(monster:getPosition(), 15)
    monster:addHealth(35)
end