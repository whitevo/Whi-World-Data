local AIDT = AID.quests.rootedCatacombs

rootedCatacombsConf = {
    rewardExp = 100,
    kickPos = {x = 659, y = 749, z = 8}, --{x = 631, y = 753, z = 8},
    bossRoomUpCorner = {x = 648, y = 744, z = 8},
    bossRoomDownCorner = {x = 665, y = 760, z = 8},
    bridgeStartPos = {x = 633, y = 750, z = 8},
    bridgeEndPos = {x = 647, y = 750, z = 8},
    buttonPosT = {{x = 631, y = 749, z = 8}, {x = 631, y = 750, z = 8}, {x = 631, y = 751, z = 8}, {x = 632, y = 750, z = 8}},
    buttonCutPos = {x = 631, y = 752, z = 8},
    treeTriggerPos = {x = 662, y = 753, z = 8},
    triggerRadius = 4,
    treeMsgT = {
        "WOW, I HAVEN'T SEEN A LIVING PERSON FOR QUITE SOME TIME",
        "BE AWARE ABOUT THE COLLAPSED DEMON SKELETON",
        "I STILL SENSE LOT OF BLACK MAGIC FROM THAT RUBBLE",
        "THERE ARE LOT OF THINGS TO FILL YOU IN ABOUT, BUT",
        "FIRST CLEAR THE ROOM FROM THIS DEATHLY SENSATION",
    },
    bossT = {
        bossCorpsePos = {x = 661, y = 749, z = 8},
        corpsePieces = {5963, 21406, 3612},             -- in creating sequence
        towerDistanceFromSkeleton = 2,
        towerHealthGain = 1000,                         -- every 10 seconds | DEFAULT = 0
        -- bossID = boss:getId() when its created       | 0 == when boss is about to be summoned
        -- demonSkeletonTowers = {[{pos}] = towerID}    | towerID = tower:getId(), pos = tower:getPosition()
    },
}

quest_rootedCatacombs = {
    startUpFunc = "rootedCatacombsQuest_startUp",
    
    questlog = {
        name = "Rooted Catacombs Quest",
        questSV = SV.rootedCatacombs_questSV,
        trackerSV = SV.rootedCatacombs_trackerSV,
        log = {
            [0] = {
                "Gain 4 different blessing to enter the boss room.",
                "You get 1 blessing from each room in the Rooted catacombs.",
            },
            [1] = {"Find 4 people to enter boss room and kill Demon Skeleton"}
        },
        hintLog = {
            [0] = {[SV.skeletonWarrior_questSV] = "You have obtained the Skeleton Warrior blessing"},
            [0] = {[SV.ghostBless_questSV] = "You have obtained the Ghost blessing"},
            [0] = {[SV.ghoulBless_questSV] = "You have obtained the Ghoul blessing"},
            [0] = {[SV.mummyBless_questSV] = "You have obtained the Mummy blessing"},
        },
    },
    area = {
        areaCorners = {{upCorner = {x = 648, y = 744, z = 8}, downCorner = {x = 665, y = 760, z = 8}}},
        blockObjects = {708},
    },
    mapEffects = {
        ["startTile"] = {pos = {x = 623, y = 753, z = 8}},
    },
    AIDItems_onLook = {
        [AIDT.demonSkeleton_healStealRune] = {
            text = {
                useOnFail = true,
                svText = {
                    [{SV.healStealRuneHint, -1}] = {msg = "demon rune"},
                    [{SV.healStealRuneHint, 0}] = {msg = "demon rune"},
                    [{SV.healStealRuneHint, 1}] = {msg = "demon rune\nwhen you get healed while standing on this rune, the health goes to demon skeleton instead"},
                }
            },
            allSV = {[SV.healStealRuneHint] = -1},
            setSV = {[SV.healStealRuneHint] = 0},
        },
        [AIDT.deadSkeleton_pillarHint] = {text = {msg = "There is a message carved under skeleten, need to get closer to read it."}},
        [AIDT.deadSkeleton_boneWallHint] = {text = {msg = "There is a message carved under skeleten, need to get closer to read it."}},
        [AIDT.demonSkeleton_fightGuide_page1] = {text = {msg = "There is something written on the note."}},
        [AIDT.demonSkeleton_fightGuide_page2] = {text = {msg = "There is something written on the note."}},
        [AIDT.demonSkeleton_fightGuide_page3] = {text = {msg = "There is something written on the note."}},
        [AIDT.demonSkeleton_fightGuide_page4] = {text = {msg = "There is something written on the note."}},
    },
    AIDItems = {
        [AIDT.skeletonCorpse] = {funcStr = "rootedCatacombsQuest_wakeBoss"},
        [AIDT.bossRoomLever] = {funcStr = "rootedCatacombsQuest_bossRoomLever"},
        [AIDT.deadSkeleton_pillarHint] = {text = {msg = "You read under skeleton body: Demon Skeleton doesn't absorb damage near blessed pillars", type = ORANGE}},
        [AIDT.deadSkeleton_boneWallHint] = {text = {msg = "You read under skeleton body: Demon Skeleton Bone Wall is immune to elemental damage, destroy it fast!!", type = ORANGE}},
        [AIDT.demonSkeleton_fightGuide_page1] = {
            text = {
                msg = {
                    "You read from note page 1 of 4:",
                    "I noticed that Demon Skeleton demonic explosion gets smaller when you get closer.",
                    "It does does deathly damage in front and fire damage diagonally.",
                    "I timed 4 seconds between explosion intervals. Perfect for knights to use rubydef and onyxdef",
                    "However next time I will have mage with me, because dispel spell is needed.",
                    "...",
                },
                type = ORANGE,
            }
        },
        [AIDT.demonSkeleton_fightGuide_page2] = {
            text = {
                msg = {
                    "You read from note page 2 of 4:",
                    ".. Demon Skeleton throws a bone every now and then, but luckily his dumb enough to warn before.",
                    "That bone can be catched, but it has massive force behind it so have your OpalDef ready for the catch.",
                    "...",
                },
                type = ORANGE,
            }
        },
        [AIDT.demonSkeleton_fightGuide_page3] = {
            text = {
                msg = {
                    "You read from note page 3 of 4:",
                    "In the Life Tree room with Demon Skeleton I was not able to bring the bridge back.",
                    "Somehow Demon Skeleton prevents it from working, but luckily I had charged teleport stone with me.",
                    "...",
                },
                type = ORANGE,
            }
        },
        [AIDT.demonSkeleton_fightGuide_page4] = {
            text = {
                msg = {
                    "You read from note page 4 of 4:",
                    ".. now you know you definitely need a knight to fight a Demon Skeleton.",
                    "Even still, knowing all that I do not recommend fighting Demon Skeleton with less than 4 people.",
                },
                type = ORANGE,
            }
        },
    },
    AIDTiles_stepIn = {
        [AIDT.startTile] = {
            allSV = {[SV.rootedCatacombs_questSV] = -1},
            setSV = {[SV.rootedCatacombs_questSV] = 0, [SV.rootedCatacombs_trackerSV] = 0},
            text = {
                type = ORANGE,
                msg = {"You have started the Rooted catacombs quest.", "get undead blessing to enter boss room."},
            },
            funcSTR = "questSystem_startQuestEffect",
        },
        [AIDT.blessCheckTile] = {funcStr = "rootedCatacombsQuest_blessCheck"},
        [AIDT.skeletonCorpse] = {funcStr = "rootedCatacombsQuest_wakeBoss"},
    },
    
    npcChat = {
        ["niine"] = {
            [1] = {
                question = "Demon Skeleton created a rune, do you know what it does?",
                answer = {"Yes I do", "When you stand on it and you get healed, the heal will be stealed by Demon Skeleton instead"},
                allSV = {[SV.healStealRuneHint] = 0},
                setSV = {[SV.healStealRuneHint] = 1},
            },
        },
    },
}
centralSystem_registerTable(quest_rootedCatacombs)

function rootedCatacombsQuest_startUp()
local positions = createAreaOfSquares(quest_rootedCatacombs.area.areaCorners)

    rootedCatacombsConf.bossT.demonSkeletonTowers = {}
    
    local function createBossTower(pos)
        local itemID = 1551
        local bossTower = findItem(itemID, pos)
        if not bossTower then return end
        local monster = createMonster("blessed pillar", pos)
        bossTower:remove()
        registerEvent(monster, "onThink", "demonSkeletonTowerAura")
        registerEvent(monster, "onHealthChange", "demonSkeletonTowerDamage")
        monster:setOutfit({lookTypeEx = itemID})
        rootedCatacombsConf.bossT.demonSkeletonTowers[pos] = monster:getId()
    end
    
    for _, pos in pairs(positions) do
        createBossTower(pos)
    end
end

local cooldown = 10
local currentCooldown = 0
function demonSkeletonTowerAura(creature)
    if currentCooldown ~= cooldown then currentCooldown = currentCooldown + 1 return end
local posT = getAreaAround(creature:getPosition(), 2, 1)
local healAmount = rootedCatacombsConf.bossT.towerHealthGain or 0

    currentCooldown = 0
    dealDamage(0, creature, COMBAT_HEALING, healAmount, 49, O_demonSkeletonTower)
    for _, pos in pairs(posT) do doSendMagicEffect(pos, 13) end
end

function demonSkeletonTowerDamage(creature, attacker, damage, damType, origin)
    if origin ~= O_demonSkeletonTower then return 0 end
    if creature:getHealth() < damage then return 0 end
    return damage
end

function demonSkeletonTower(attacker, target) return attacker and target and target:getName() == "blessed pillar" end

function rootedCatacombsQuest_wakeBoss(player)
local bossT = rootedCatacombsConf.bossT
local bossPos = bossT.bossCorpsePos
    
    for _, itemID in ipairs(bossT.corpsePieces) do
        if not removeItemFromPos(itemID, bossPos) then return end
    end
local area = {
    {n,1,3},
    {4,0,2},
    {5,3,4},
}
local areaT = getAreaPos(bossPos, area)
local interval = 500
local intervalAmount = tableCount(areaT) - 1
    
    local function summonBoss()
        local monster = createMonster("demon skeleton", bossPos)
        registerEvent(monster, "onHealthChange", "demonSkeleton_healthProtection")
        bossT.bossID = monster:getId()
    end
    
    for i, posT in pairs(areaT) do
        for _, pos in pairs(posT) do addEvent(doSendMagicEffect, interval*(i-1), pos, {3, 43}) end
    end
    
    bossT.bossID = 0
    for x=0, intervalAmount do addEvent(doSendMagicEffect, interval*x, bossPos, 18) end
    addEvent(summonBoss, interval*intervalAmount)
end

function demonSkeleton_healthProtection(creature, attacker, damage, damType)
    if damType == COMBAT_HEALING then return damage end
local tower = getDemonSkeletonTower(creature)

    if not tower then return percentage(damage, 20) end
local towerHealthLeft = tower:getHealth()
    
    damage = damage < 0 and -damage or damage
    if towerHealthLeft < damage then return percentage(damage, 20) end
    dealDamage(0, tower, ENERGY, damage, 14, O_demonSkeletonTower)
    doSendDistanceEffect(tower:getPosition(), creature:getPosition(), 5)
    return damage
end

function getDemonSkeletonTower(creature)
local creaturePos = creature:getPosition()
local bossT = rootedCatacombsConf.bossT

    for pos, towerID in pairs(bossT.demonSkeletonTowers) do
        if getDistanceBetween(pos, creaturePos) <= bossT.towerDistanceFromSkeleton then return Creature(towerID) end
    end
end

function rootedCatacombsQuest_bossRoomLever(player, item)
local bossT = rootedCatacombsConf.bossT

    if bossT.bossID or findItem(bossT.corpsePieces[1], bossT.bossCorpsePos) then
        player:sendTextMessage(GREEN, "Black magic protects the lever")
        doSendMagicEffect(item:getPosition(), 18)
        return rootedCatacombsQuest_wakeBoss(player)
    end
    changeLever(item)
    -- open escape bridge
end

function rootedCatacombsQuest_blessCheck(player)
    if player:getSV(SV.rootedCatacombs_questSV) == 1 then return end
local blessT = {
    ["Ghost bless"] = SV.ghostBless_questSV,
    ["Skeleton Warrior bless"] = SV.skeletonWarrior_questSV,
    ["Ghoul bless"] = SV.ghoulBless_questSV,
    ["Mummy bless"] = SV.mummyBless_questSV,
}
    for blessName, sv in pairs(blessT) do
        if player:getSV(sv) ~= 1 then
            teleport(player, {x = 621, y = 752, z = 8})
            return player:sendTextMessage(GREEN, "You are missing "..blessName)
        end
    end
    
    player:setSV(SV.rootedCatacombs_trackerSV, 1)
end

function rootedCatacombsBosslever_onUse(player, item)
local cutPos = rootedCatacombsConf.buttonCutPos

    if findItem(708, cutPos) then return player:sendTextMessage(GREEN, "lever wont move right now") end
    
    for _, pos in ipairs(rootedCatacombsConf.buttonPosT) do
       -- if not findCreature("player", pos) then return player:sendTextMessage(GREEN, "Lever is stuck") end
    end
local bossRoom = createSquare(rootedCatacombsConf.bossRoomUpCorner, rootedCatacombsConf.bossRoomDownCorner)

    for _, pos in pairs(bossRoom) do
        if findCreature("player", pos) then return player:sendTextMessage(GREEN, "Boss room is not empty") end
    end
local bridgeStartPos = rootedCatacombsConf.bridgeStartPos
local bridgeEndPos = rootedCatacombsConf.bridgeEndPos
local bridgeRevealInterval = 1000
local bridgeRemoveTime = 10000
local loopID = 0
local creature = findCreature("player", cutPos)
    
    if creature then teleport(creature, rootedCatacombsConf.kickPos, true) end
    createItem(708, cutPos)
    addEvent(createItem, bridgeRemoveTime + bridgeRevealInterval*(bridgeEndPos.x - bridgeStartPos.x), 419, cutPos)
    rootedCatacombs_createTreeTrigger()
    
    local function removeBridgePart(pos)
        local player = findCreature("player", pos)
        local upEdgePos = {x = pos.x, y = pos.y-1, z = pos.z}
        local downEdgePos = {x = pos.x, y = pos.y+1, z = pos.z}
        
        if player then teleport(player, rootedCatacombsConf.kickPos) end
        createItem(708, pos)
        removeItemFromPos(18912, upEdgePos)
        removeItemFromPos(18916, downEdgePos)
    end
    
    local function makeBridgePart(pos)
        local itemID = randomValueFromTable({18767, 18768, 18769})
        local upEdgePos = {x = pos.x, y = pos.y-1, z = pos.z}
        local downEdgePos = {x = pos.x, y = pos.y+1, z = pos.z}
        
        addEvent(removeBridgePart, bridgeRemoveTime, pos)
        createItem(itemID, pos)
        createItem(18912, upEdgePos)
        createItem(18916, downEdgePos)
    end
    
    for xPos = bridgeStartPos.x, bridgeEndPos.x do
        local pos = {x = xPos, y = bridgeStartPos.y, z = bridgeStartPos.z}
        loopID = loopID + 1
        addEvent(makeBridgePart, bridgeRevealInterval*loopID, pos)
    end
end

function rootedCatacombs_createTreeTrigger()
    local triggerPos = rootedCatacombsConf.treeTriggerPos
    if findByName(triggerPos, "token") then return end
    local monster = createMonster("token", triggerPos)
    
    monster:setHiddenHealth(true)
    registerEvent(monster, "onThink", "rootedCatacombs_treeStartsTalking")
end

function rootedCatacombs_treeStartsTalking(creature)
    local startTalking = false
    local startPos = creature:getPosition()

    for _, creatureID in pairs(creature:getTargetList()) do
        local target = Creature(creatureID)
        if target and getDistanceBetween(startPos, target:getPosition()) <= rootedCatacombsConf.triggerRadius then startTalking = true break end
    end

    if not startTalking then return end
    
    local msgT = addMsgDelayToMsgT(rootedCatacombsConf.treeMsgT)

    for delay, msg in pairs(msgT) do addEvent(text, delay, msg, startPos) end
    creature:remove()
end

function rootedCatacombs_onLogOut(player)
    local playerPos = player:getPosition()

    if isInRange(playerPos, rootedCatacombsConf.bridgeStartPos, rootedCatacombsConf.bridgeEndPos) then return teleport(player, rootedCatacombsConf.kickPos) end
    if isInRange(playerPos, rootedCatacombsConf.bossRoomUpCorner, rootedCatacombsConf.bossRoomDownCorner) then return teleport(player, rootedCatacombsConf.kickPos) end
    if comparePositionT(rootedCatacombsConf.buttonPosT, playerPos) then return teleport(player, rootedCatacombsConf.kickPos) end
    if samePositions(rootedCatacombsConf.buttonCutPos, playerPos) then return teleport(player, rootedCatacombsConf.kickPos) end
end