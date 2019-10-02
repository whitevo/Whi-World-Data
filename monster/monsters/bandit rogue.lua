local monster_banditRogue = {
    monsterSpells = {
        ["bandit rogue"] ={
            "bandit rogue backstab",
            "bandit rogue barrier debuff",
            "bandit rogue smokescreen",
            "heal: cd=15000, p=5",
            "damage: cd=1000, d=35-95",
            "damage: cd=3000, d=20-60, r=5, fe=19",
            finalDamage = 10,
        },
    },
    monsters = {
        ["bandit rogue"] = {
            name = "Bandit Rogue",
            reputationPoints = 5,
            race = "human",
            HPScale = true,
            spawnEvents = defaultMonsterSpawnEvents,
            task = {
                groupID = 2,
                requiredSV = {[SV.bandithunterTaskOnce] = 1, [SV.banditMageTaskOnce] = 1, [SV.banditKnightTaskOnce] = 1, [SV.banditDruidTaskOnce] = 1},
                killsRequired = 12,
                storageID = SV.banditRogueTask,
                storageID2 = SV.banditRogueTaskOnce,
                skillPoints = 1,
                location = "Hehemi town",
                reputation = 12,
            },
        },
    },
    monsterResistance = {
        ["bandit rogue"] = {
            PHYSICAL = -25,
            DEATH = 20,
            EARTH = -30,
        },
    },
    monsterLoot = {
        ["bandit rogue"] = {
            storage = SV.b_rogue,
            items = {
                [5958] = {chance = 2, itemAID = {AID.spells.sapphdef, AID.spells.throwaxe}, knight = 2.5, firstTime = 3, partyBoost = "false"},   -- SpellScrolls
                [15491] = {chance = 2, knight = 5.5, firstTime = 4, partyBoost = "false"},                      -- stone shield
                [21692] = {chance = 2, knight = 5.5, firstTime = 4, partyBoost = "false"},                      -- stone armor
                [ITEMID.other.coin] = {chance = {40,20,10}, count = {1,3,2}},                                                -- coin
                [13881] = {chance = 7, itemAID = AID.herbs.mobberel},                                               -- mobberel
                [2422] = {chance = 12, itemAID = AID.other.tool, itemText = "charges(2)"},                          -- iron hammer
                [2674] = {chance = 15, count = 3, itemAID = AID.other.food},                                    -- apple
                [2666] = {chance = 20, itemAID = AID.other.food},                                               -- meat
                [5910] = {chance = 15},                                                                         -- green cloth
                [8305] = {chance = 22},                                                                         -- physical Gem
            }
        },
    }
}
centralSystem_registerTable(monster_banditRogue)


customSpells["bandit rogue backstab"] = {
    cooldown = 14000,
    targetConfig = {"cTarget"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            areaConfig = {area = areas["3x3_0"]},
            blockObjects = "solid",
            randomPos = 1,
        }
    },
    damage = {
        onTargets = true,
        minDam = 1,
        maxDam = 90,
        minScale = 4,
        maxScale = 8,
        damType = PHYSICAL,
        effectOnHit = 1,
        effectOnMiss = 10,
        executeAmount = 10,
        
        teleport = {
            targetConfig = {"caster"},
            position = {
                startPosT = {startPoint = "caster"},
                endPosT = {
                    endPoint = "friend",
                    pointPosFunc = "pointPosFunc_far",
                    checkPath = "solid",
                },
            },
            onTargets = true,
            delay = 1500,
            effectOnCast = 25,
            effectOnPos = 23,
        }
    },
    teleport = {
        targetConfig = {"caster"},
        onTargets = true,
        effectOnCast = 25,
        effectOnPos = 24,
    }
}

customSpells["bandit rogue barrier debuff"] = {
    cooldown = 25000,
    firstCastCD = -20000,
    targetConfig = {"cTarget"},
    position = {startPosT = {startPoint = "caster"}, endPosT = {endPoint = "cTarget"}},
    customFeature = {func = "banditRogue_barrierDebuff"},
    event = {onTargets = true, duration = 20, register = {onThink = "rogue_debuffEffect"}},
    magicEffect = {effect = {18, 5}},
    flyingEffect = {effect = 40},
}

function banditRogue_barrierDebuff(casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
    for targetID, posT in pairs(targetList) do
        setSV(targetID, SV.barrierDebuffPercent, 60)
        addEvent(addSV, 20*1000, targetID, SV.barrierDebuffPercent, -60)
    end
end

customSpells["bandit rogue smokescreen"] = {
    cooldown = 16000,
    firstCastCD = -11000,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster", areaConfig = {area = areas["star_3x3_1"]}},
    },
    changeEnvironment = {
        items = {11827},
        itemAID = AID.areas.hehemi.banditRogueSmoke,
        removeTime = 6000,
    }
}

function banditRogueSmoke(creature, item)
    if creature:isMonster() and not creature:isNpc() then bindCondition(creature, "invisible", 3000) end
end

local monsterStorageValue = {}
function rogue_debuffEffect(creature)
    local creatureID = creature:getId()
    local cooldown = monsterStorageValue[creatureID] or 0
    
    if cooldown < 3 then monsterStorageValue[creatureID] = cooldown + 1 return end
    monsterStorageValue[creatureID] = 0
    doSendMagicEffect(creature:getPosition(), 48)
end