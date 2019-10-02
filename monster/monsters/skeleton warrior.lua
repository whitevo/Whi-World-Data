local monster_skeletonWarrior = {
    registerEvent = {
        onDeath = {["skeleton warrior"] = "skeletonWarriorRoom_death"}
    },
    monsters = {
        ["skeleton warrior"] = {
            name = "Skeleton Warrior",
            reputationPoints = 5,
            race = "undead",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 3,
                requiredSV = {[SV.ghostTaskOnce] = 1},
                killsRequired = 10,
                storageID = SV.SW_task,
                storageID2 = SV.SW_taskOnce,
                skillPoints = 1,
                location = "In Rooted Catacombs",
                reputation = 15,
            },
        },
    },
    monsterSpells = {
        ["skeleton warrior"] = {
            "warrior skeleton heal",
            "skull bomb",
            "skeleton warrior strike",
            "bone shield",
            "damage: cd=1000, d=60-90",
            finalDamage = 10,
        },
    },
    monsterResistance = {
        ["skeleton warrior"] = {
            PHYSICAL = 30,
            ICE = 60,
            FIRE = 55,
            ENERGY = 55,
            DEATH = 90,
            HOLY = -50,
            EARTH = 60,
        },
    },
    monsterLoot = {
        ["skeleton warrior"] = {
            storage = SV.skeletonWarrior,
            items = {
                [18404] = {chance = 2, knight = 4, firstTime = 2, partyBoost = "false"},    -- ghatitk armor
                [18399] = {chance = 2, hunter = 4, firstTime = 2, partyBoost = "false"},    -- traptrix coat
                [21725] = {chance = 2, druid = 4, firstTime = 2, partyBoost = "false"},     -- phadra robe
                [6391] = {chance = 2, hunter = 4, firstTime = 2, partyBoost = "false"},     -- Chokkan
                [8905] = {chance = 2, knight = 4, firstTime = 2, partyBoost = "false"},     -- Supaky
                [2532] = {chance = 2, druid = 4, firstTime = 2, partyBoost = "false"},      -- Kodayasu
                [13559] = {chance = 2, mage = 4, firstTime = 2, partyBoost = "false"},      -- demonic robe
                [2521] = {chance = 2, mage = 4, firstTime = 2, partyBoost = "false"},       -- Akujaaku
                [ITEMID.other.coin] = {chance = {45,30,20}, count = {2,5,8}},                            -- coin
                [2150] = {chance = 10},                                                     -- death gem
                [2297] = {chance = 20},                                                     -- crit stone
            }
        },
    },
}
centralSystem_registerTable(monster_skeletonWarrior)


function skeletonWarriorRoom_death(monster)
    local bones = {
        2231,   -- healing bone
        21408,  -- damage bone
    }
    local explosionTime = 1000
    local itemTravelTime = 200
    local itemRemoveTime = 50000
    local boneAmount = 4
    local monsterPos = monster:getPosition()
    local area = getAreaAround(monsterPos, 3)
    local area2 = getAreaAround(monsterPos)
    local boneArea = removePositions(area2, "solid")
    local bonePositions = randomPos(boneArea, boneAmount)
    
    for _, pos in pairs(area) do
        local door = skeleton_getDoor(pos)
        
        if door then
            local dir = skeletonWarriorAreaConf.skeletonDoors[door:getId()]
            if dir == "N" or dir == "S" then
                skeletonWarriorRoom_changeDoor(door, "open", skeletonWarriorAreaConf.closeDoorTime)
            end
        end
    end
    
    for x=0, math.floor(explosionTime/350) do
        addEvent(doSendMagicEffect, x*300, monsterPos, 3)
    end
    
    if tableCount(bonePositions) > 0 then
        for _, pos in pairs(bonePositions) do
            local delay = math.random(0, 1) * 150
            local boneID = bones[math.random(#bones)]
            
            addEvent(doSendDistanceEffect, explosionTime + delay, monsterPos, pos, 10)
            addEvent(createItem, itemTravelTime + explosionTime + delay, boneID, pos)
            addEvent(removeItemFromPos, itemTravelTime + explosionTime + delay + itemRemoveTime, boneID, pos)
            addEvent(dealDamagePos, itemTravelTime + explosionTime + delay, 0, pos, PHYSICAL, math.random(150, 260), 4, O_monster_procs_player)
        end
    end
end

customSpells["warrior skeleton heal"] = {
    cooldown = 5000,
    targetConfig = {[2231] = {range = 1}, "caster"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_1"]}, onlyItemPos = {2231}, randomPos = 1}},
    changeEnvironment = {
        removeItems = {2231},
        say = {msg = "*grab*", hook = true},
        magicEffect = {effect = 39},
        heal = {targetConfig = {"caster"}, onTargets = true, hook = true, effect = 15, minHeal = 500},
    }
}

customSpells["skull bomb"] = {
    cooldown = 15000,
    targetConfig = {["cTarget"] = {range = 6, obstacles = "solid"}},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    flyingEffect = {effect = 10},
    magicEffect = {effect = {30,30,30}, effectInterval = 1000},
    damage = {
        delay = 500,
        minDam = 40,
        maxDam = 80,
        damType = PHYSICAL,
        effect = 10,
        effectOnHit = 1,
        
        changeEnvironment = {items = {20129}, itemAID = AID.areas.skeletonWarriorRoom.skeletonBomb, removeTime = 3000},
        damage = {
            position = {
                startPosT = {startPoint = "endPos"},
                endPosT = {endPoint = "endPos", areaConfig = {area = areas["3x3_0"]}, blockObjects = "solid", randomPos = 3},
            },
            delay = 3000,
            minDam = 120,
            maxDam = 220,
            damType = PHYSICAL,
            effect = 4,
            effectOnHit = 1,
            
            flyingEffect = {effect = 10},
            changeEnvironment = {items = {2231}, removeTime = 50000},
        },
    },
}

local strikeArea = {
    {1},
    {1},
    {0},
}
customSpells["skeleton warrior strike"] = {
    cooldown = 7000,
    targetConfig = {"enemy"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = strikeArea}}},
    damage = {minDam = 55, maxDam = 80, damType = DEATH, effect = 18, effectOnHit = 4},
}

customSpells["bone shield"] = {
    cooldown = 10000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster", areaConfig = {area = areas["3x3_0"]}}, endPosT = {endPoint = "caster"}},
    say = {onTargets = true, msg = "!bone shield"},
    event = {onTargets = true, register = {onHealthChange = "skeletonWarrior_boneShield"}, duration = 3},
    magicEffect = {onTargets = true, effect = 18},
    flyingEffect = {effect = 11},
}

function skeletonWarrior_boneShield(creature, attacker, damage, damType)
    if not attacker or damType ~= PHYSICAL or not attacker:isPlayer() then return damage, damType end
    local creaturePos = creature:getPosition()

    for _, pos in pairs(getAreaAround(creaturePos)) do creaturePos:sendDistanceEffect(pos, 11) end
    doSendMagicEffect(creaturePos, {11,31})
    dealDamage(creature, attacker, DEATH, math.random(50, 100), 18, O_monster_procs)
    unregisterEvent(creature, "onHealthChange", "bone shield")
    return 0, damType
end