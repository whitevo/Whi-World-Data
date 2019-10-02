local monster_banditShaman = {
    AIDTiles_stepIn = {
        [AID.areas.hehemi.banditShamanField] = {funcSTR = "banditShaman_slowField_stepIn"},
    },
    monsterSpells = {
        ["bandit shaman"] = {
            "bandit shaman slow ground",
            "bandit shaman blue fire",
            "bandit shaman heal aura",
            "heal: cd=15000, p=5",
            "damage: cd=3000, d=20-30, r=7, t=ICE, fe=11",
            finalDamage = 10,
        }
    },
    monsters = {
        ["bandit shaman"] = {
            name = "Bandit Shaman",
            reputationPoints = 5,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.bandithunterTaskOnce] = 1, [SV.banditMageTaskOnce] = 1, [SV.banditKnightTaskOnce] = 1, [SV.banditDruidTaskOnce] = 1},
                killsRequired = 12,
                storageID = SV.banditShamanTask,
                storageID2 = SV.banditShamanTaskOnce,
                skillPoints = 1,
                location = "Hehemi town",
                reputation = 12,
            },
        },
    },
    monsterResistance = {
        ["bandit shaman"] = {
            PHYSICAL = -25,
            DEATH = 20,
        },
    },
    monsterLoot = {
        ["bandit shaman"] = {
            storage = SV.b_shaman,
            items = {
                [5958] = {chance = 2, itemAID = AID.spells.mend, druid = 2.5, firstTime = 3, partyBoost = "false"},  -- SpellScroll: mend
                [8909] = {chance = 2, druid = 5.5, firstTime = 4, partyBoost = "false"},                -- gribit shield
                [2508] = {chance = 2, druid = 5.5, firstTime = 4, partyBoost = "false"},                -- yashiteki
                [ITEMID.other.coin] = {chance = {40,20,10}, count = {1,3,2}},                                        -- coin
                [13881] = {chance = 7, itemAID = AID.herbs.mobberel},                               -- mobberel
                [2422] = {chance = 12, itemAID = AID.other.tool, itemText = "charges(2)"},          -- iron hammer
                [2674] = {chance = 15, count = 3, itemAID = AID.other.food},                            -- apple
                [2666] = {chance = 20, itemAID = AID.other.food},                                       -- meat
                [5910] = {chance = 15},                                                                 -- green cloth
                [2149] = {chance = 22},                                                                 -- earth Gem
            }
        },
    }
}
centralSystem_registerTable(monster_banditShaman)

customSpells["bandit shaman slow ground"] = {
    cooldown = 12000,
    firstCastCD = -6000,
    targetConfig = {
        ["enemy"] = {obstacles = {"solid"}},
    },
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = areas["star_3x3_1"]},
            blockObjects = "solid",
        }
    },
    changeEnvironment = {
        items = {11638},
        removeTime = 8000,
    },
    magicEffect = {
        effect = {14,14,14,14,14,14,14,14},
        effectInterval = 1000,
        waveInterval = 200,
    },
    conditions = {
        conditionT = {
			["monsterSlow"] = {
				paramT = {["speed"] = -40},
				duration = 3000,
				maxStack = 10,
			},
		},
        noMonsters = true,
        repeatAmount = 8,
        interval = 1000,
    }
}

customSpells["bandit shaman blue fire"] = {
    cooldown = 6000,
    targetConfig = {
       ["cTarget"] = {obstacles = {"solid"}}
    },
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = areas["star_1x1_0"]},
            blockObjects = "solid",
        }
    },
    changeEnvironment = {
        items = {9662},
        itemAID = AID.areas.hehemi.banditShamanField,
        removeTime = 12000,
        
        flyingEffect = {effect = 29},
        magicEffect = {effect = 2},
    }
}

customSpells["bandit shaman heal aura"] = {
    cooldown = 3000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {endPoint = "caster", areaConfig = {area = areas["3x3_0"]}}
    },
    flyingEffect = {effect = 35},
    magicEffect = {effect = 2},
    spellLockCD = {onTargets = true, [20000] = "bandit shaman heal aura"},
    event = {onTargets = true, duration = 15, register = {onThink = "banditShamanAura"}},
}

function banditShaman_slowField_stepIn(creature, item)
    if creature:isPlayer() then
        dealDamage(0, creature, ICE, math.random(30, 50), 16, O_monster_spells)
    elseif creature:isMonster() then
        if creature:isNpc() or creature:getRealName() == "imp" then
            dealDamage(0, creature, ICE, math.random(10, 30), 38, O_monster_spells)
        else
            creature:addHealth(500)
        end
    end
    item:remove()
end

local monsterStorageValue = {}

function banditShamanAura(creature)
    local creatureID = creature:getId()
    if not monsterStorageValue[creatureID] then monsterStorageValue[creatureID] = 1 end

    for x=0, 5 do
        addEvent(fly, x*200, creatureID, monsterStorageValue[creatureID])
        monsterStorageValue[creatureID] = monsterStorageValue[creatureID]+1
        if monsterStorageValue[creatureID] == 9 then monsterStorageValue[creatureID] = 1 end
    end
end

function fly(creatureID, direction)
    local monster = Monster(creatureID)
    if not monster then return false end
    local monsterPos = monster:getPosition()
    local newPos = getDirectionPos(monsterPos, compass3[direction])
    local tile = Tile(newPos)
    if not tile then return false end
    
    local creature = tile:getBottomCreature()
    if direction-1 == 0 then direction = 9 end
    local previousPos = getDirectionPos(monsterPos, compass3[direction-1])
    
    doSendDistanceEffect(previousPos, newPos, 37)
    doSendMagicEffect(newPos, 2)
    
    if creature and creature:isMonster() then
        if creature:getRealName() == "imp" then return end
        if creature:isNpc() then return end
        local scale = getScale(creatureID)
        creature:addHealth(math.floor(225+300*scale*25/100))
    end
end
