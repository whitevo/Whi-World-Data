local AIDT = AID.quests.cursedBear

quest_cursedBearConf = {
    expReward = 30,
    bossRoomArea = {
        upCorner = {x = 700, y = 586, z = 7},
        downCorner = {x = 717, y = 603, z = 7},
        roomObstacles = {"solid", "noGround", "noTile"},
    },
    timers = {
        bearCorpseRespawn = 30*60*1000,
        ladderDespawn = 60*1000,
    }
}

quest_cursedBear = {
    startUpFunc = "cursedBearQuest_startUp",
    deathArea = {{
        upCorner = quest_cursedBearConf.bossRoomArea.upCorner,
        downCorner = quest_cursedBearConf.bossRoomArea.downCorner,
        func = "cursedBearQuest_death",
    }},
    questlog = {
        name = "Cursed Bear Quest",
        questSV = SV.cursedBearQuest,
        trackerSV = SV.cursedBearQuestTracker,
        log = {
            [0] = "Find a way inside the temple.",
            [1] = "Investigate the temple.",
            [2] = "Find a way to defeat the cursed bear.",
        },
        hintLog = {
            [2] = {[SV.cursedBearHint_bearKill] = "Make the bear walk under the holy light."}
        },
    },
    npcChat = {
        ["tonka"] = {
            [125] = {
                question = "Have you figured out how to kill the cursed bear?",
                allSV = {[SV.cursedBearQuestTracker] = 2},
                setSV = {[SV.cursedBearHint_bearKill] = 1},
                answer = {"It seems that undead spirits awakened the dead bear.", "I lured the bear under the holy light to kill it."},
            },
        },
    },
    mapEffects = {
        ["bear body"] = {pos = {x = 716, y = 592, z = 7}},
        ["ladder"] =    {pos = {x = 747, y = 596, z = 4}, me = 57},
    },
    monsters = {
        ["cursed bear"] = {
            name = "Cursed Bear",
            reputationPoints = 6,
            race = "undead",
            spawnEvents = {
                onThink = {"AI_onThink", "cursedBearQuest_lightTile"},
                onDeath = {"monster_onDeath", "bossRoom_onDeath"},
                onHealthChange = {"damageSystem_onHealthChange"},
            },
            killActions = {{
                allSV = {[SV.cursedBearQuestTracker] = 2},
                setSV = {[SV.cursedBearQuest] = 1, [SV.cursedBearQuestTracker] = -1},
                funcSTR = "cursedBearQuest_questCompleted",
                rewardExp = quest_cursedBearConf.expReward,
            }},
        },
        ["cursed puke"] = {
            name = "Cursed Puke",
            race = "element",
            spawnEvents = defaultMonsterSpawnEvents,
        },
    },
    monsterSpells = {
        ["cursed bear"] = {
            "damage: cd=2500, d=130-220, t=PHYSICAL",
            "bear puke",
        },
        ["cursed puke"] = {"damage: cd=1000, d=10-20, t=DEATH"}
    },
    monsterResistance = {
        ["cursed puke"] = {
            PHYSICAL = 20,
            ICE = -20,
            FIRE = -20,
            ENERGY = 70,
            DEATH = 95,
            HOLY = -100,
            EARTH = 20,
        },
        ["cursed bear"] = {
            PHYSICAL = 75,
            ICE = 90,
            FIRE = 90,
            ENERGY = 90,
            DEATH = 95,
            HOLY = 0,
            EARTH = 95,
        },
    },
    monsterLoot = {
        ["cursed bear"] = {
            [2150] = {chance = 100, count = 3}, -- death gem
            [5925] = {chance = 100, count = 3}, -- skeleton bone
        },
    },
    AIDItems = {
        [AIDT.bearCorpse] = {
            text = {text = {msg = "*GRRR*"}},
            createItems = {{itemID = 13320, delay = quest_cursedBearConf.timers.bearCorpseRespawn, itemAID = AIDT.bearCorpse}},
            removeItems = {{}},
            funcSTR = "cursedBearQuest_activateBossTimer",
        },
        [AIDT.ladder] = {
            allSV = {[SV.cursedBearQuestTracker] = 0},
            setSV = {[SV.cursedBearQuestTracker] = 1},
            text = {msg = "Investigate the temple"},
            teleport = {x = 710, y = 591, z = 7},
            teleportF = {x = 710, y = 591, z = 7},
        },
        [AIDT.ladderTile] = {
            takeItems = {
                {itemID = ITEMID.materials.log, count = 2},
                {itemID = 8309, count = 2},
            },
            textF = {msg = "You don't have the materials to build the ladder"},
            createItems = {{itemID = 8599, itemAID = AIDT.ladder}},
            removeItems = {{itemID = 8599, delay = quest_cursedBearConf.timers.ladderDespawn}},
            funcSTR = "cursedBearQuest_toggleLadderEffect",
        },
    },
    AIDItems_onLook = {
        [AIDT.ladderTile] = {text = {msg = "You need 2 logs and 2 nails to build a ladder"}},
    },
    AIDTiles_stepIn = {
        [AIDT.bearPuke] = {funcSTR = "bearPuke_stepIn"},
        [AIDT.hole] = {
            allSV = {[SV.cursedBearQuest] = -1},
            setSV = {[SV.cursedBearQuestTracker] = 0, [SV.cursedBearQuest] = 0},
            text = {type = ORANGE, msg = {"You found secret path to temple.", "Cursed Bear Quest has been started."}},
            funcSTR = "questSystem_startQuestEffect",
            teleport = {x = 742, y = 595, z = 3},
            transform = {itemID = 470, returnDelay = 30000},
            transformF = {itemID = 470, returnDelay = 30000},
            teleportF = {x = 742, y = 595, z = 3},
        },
    },
}
centralSystem_registerTable(quest_cursedBear)

customSpells["bear puke"] = {
    cooldown = 5000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    changeEnvironment = {
        items = {9960},
        itemAID = AID.quests.cursedBear.bearPuke,
        removeItems = {9960},
        removeTime = 30*1000,
        summon = {
            delay = 30*1000,
            maxSummons = 15,
            summons = {["cursed puke"] = {amount = 2}}
        }
    },
}

function cursedBearQuest_startUp()
    local t = quest_cursedBearConf.bossRoomArea
    local area = createSquare(t.upCorner, t.downCorner)
    area = removePositions(area, t.roomObstacles)
    t.roomT = area
end

function bearPuke_stepIn(creature, item)
    if creature:isPlayer() then return bindCondition(creature, "bearPuke", 2000, {speed = -150}) end
    heal(creature, math.random(100, 200), 18)
end

function cursedBearQuest_activateBossTimer(player, item)
    local boss = createMonster("cursed bear", item:getPosition())
    if getSV(player, SV.cursedBearQuest) ~= 1 then setSV(player, SV.cursedBearQuestTracker, 2) end
    cursedBearQuest_toggleCorpseEffect()
    addEvent(cursedBearQuest_clearBossRoom, quest_cursedBearConf.timers.bearCorpseRespawn, boss:getId())
    return true
end

function cursedBearQuest_clearBossRoom(bossID)
    local room = createSquare(quest_cursedBearConf.bossRoomArea.upCorner, quest_cursedBearConf.bossRoomArea.downCorner)
    for _, pos in pairs(room) do addEvent(doSendMagicEffect, math.random(1, 2000), pos, math.random(49, 50)) end
    removeCreature(bossID)
    quest_cursedBear.mapEffects["bear body"].variable = false
end

function cursedBearQuest_toggleCorpseEffect()
    quest_cursedBear.mapEffects["bear body"].variable = true
    return true
end

function cursedBearQuest_toggleLadderEffect()
    local t = quest_cursedBear.mapEffects["ladder"]
    setTableVariable(t, "variable", true)
    addEvent(setTableVariable, quest_cursedBearConf.timers.ladderDespawn, t, "variable", false)
    return true
end

local lightEffectsAreActive = false
function cursedBearQuest_lightTile()
    if lightEffectsAreActive then return end
    local roomT = quest_cursedBearConf.bossRoomArea.roomT
    local lightPosT = randomPos(roomT, 5)
    local times = 10
    local delay = 1500
    
    lightEffectsAreActive = true
    addEvent(function() lightEffectsAreActive = false end, times*delay)
    
    for x=0, times-1 do
        for _, pos in pairs(lightPosT) do
            addEvent(dealDamagePos, delay*x, 0, pos, HOLY, math.random(100, 200), 50, O_environment_monster, CONST_ME_THUNDER)
            addEvent(dealDamagePos, delay*x, 0, {x=pos.x-1, y=pos.y, z=pos.z}, HOLY, math.random(100, 200), 50, O_environment_monster, CONST_ME_THUNDER)
            addEvent(dealDamagePos, delay*x, 0, {x=pos.x, y=pos.y-1, z=pos.z}, HOLY, math.random(100, 200), 50, O_environment_monster, CONST_ME_THUNDER)
        end
    end
end

function cursedBearQuest_questCompleted(player)
    player:sendTextMessage(ORANGE, "--- Cursed Bear Quest completed. ---")
    player:sendTextMessage(ORANGE, "You lifted the curse that was cast upon the temple.")
    player:sendTextMessage(BLUE, "Your resistance to undead type damage is permanently increased by 10%.")
    questSystem_completeQuestEffect(player)
    setSV(player, SV.cursedBearQuest_undeadRes, 10)
end

function cursedBearQuest_death(player)
    local area = quest_cursedBearConf.bossRoomArea.roomT
    teleport(player, player:homePos())

    for _, pos in pairs(area) do
        if findCreature("player", pos) then return true end
    end
    return cursedBearQuest_clearMonsters()
end

function cursedBearQuest_clearMonsters()
    local area = quest_cursedBearConf.bossRoomArea.roomT
    for _, pos in pairs(area) do massRemove(pos, "monster") end
    return true
end