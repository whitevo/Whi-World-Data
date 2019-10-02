local rewardExp = 20
local AIDT = AID.missions.boneFlute

mission_boneFlute = {
    questlog = {
        name = "Bone Flute Mission",
        questSV = SV.fluteMission,
        trackerSV = SV.fluteMissionTracker,
        category = "mission",
        log = {
            [0] = {"find out where you could find bone flute"},
            [1] = {"find bone flute altar in Rooted Catacombs - skeleton warrior room."},
            [2] = {"create bone flute"},
            [3] = {"take bone flute to the priest"},
        },
        hintLog = {
            [2] = {
                [SV.fluteMissionHint] = "Bum told you to put skeleton bones on the bone flute altar",
            }
        }
    },
    npcChat = {
        ["bum"] = {
            [25] = {
                question = "You seems to work with bones. Do you know how to use bone altar?",
                allSV = {[SV.fluteMissionHint] = 0, [SV.fluteMissionTracker] = 2},
                anySVF = {[SV.fluteMission] = 1},
                setSV = {[SV.fluteMissionHint] = 1},
                answer = {
                    "Yeah, I used to make these altars, Although I didn't apply the magic.", 
                    "You had to put skeleton bones onto altar, if I remember correctly."
                },
            },
        },
        ["niine"] = {
            [66] = {
                question = "I have collected some bones for Bum, do you want some too?",
                allSV = {[SV.boneMission] = 1, [SV.fluteMission] = -1},
                setSV = {[SV.fluteMission] = 0, [SV.fluteMissionTracker] = 0, [SV.fluteMissionHint] = -1},
                answer = {
                    "Nah not that interesting.",
                    "Speaking of bones I'm interested in bone flute.",
                    "Perhaps you can find such a rare item, I like to collect weird stuff :D",
                },
            },
            [67] = {
                question = "I have found the bone flute for you",
                allSV = {[SV.fluteMission] = 0},
                setSV = {[SV.fluteMission] = 1, [SV.fluteMissionTracker] = -1},
                moreItems = {{itemID = 21249, count = 1}},
                removeItems = {{itemID = 21249, count = 1}},
                rewardExp = rewardExp,
                addRep = {["niine"] = 40},
                answer = {"woah you found it", "GJ and ty :D"},
                actionAnswer = "Bone Flute Mission completed",
            },
        },
        ["dundee"] = {
            [46] = {
                question = "Do you know anything about bone flute?",
                allSV = {[SV.fluteMissionTracker] = 0},
                answer = {
                    "no idea what is that, sounds like a rare item",
                    "perhaps Niine knows she is colleting rare items.",
                    "Tonka might know something too",
                },
            },
        },
        ["tonka"] = {
            [135] = {
                question = "Do you know anything about bone flute?",
                allSV = {[SV.fluteMissionTracker] = 0},
                setSV = {[SV.fluteMissionTracker] = 1},
                answer = {
                    "Idk what it is used for, however..",
                    ".. I know it has something to do with bone altar in Rooted catacombs - skeleton warrior room",
                },
            },
        },
    },
    mapEffects = {
        ["altar"] = {posT = {{x = 570, y = 768, z = 8}, {x = 571, y = 768, z = 8}}},
    },
    AIDItems_onLook = {
        [AIDT.altar] = {
            anySV = {[SV.fluteMissionTracker] = {0,1}},
            setSV = {[SV.fluteMissionTracker] = 2, [SV.fluteMissionHint] = 0},
            text = {msg = "You see some kind of magic altar, its made with bones."},
            textF = {msg = "You see some kind of magic altar, its made with bones."},
        },
    },
    AIDItems = {
        [AIDT.altar] = {
            anySV = {[SV.fluteMissionTracker] = {0,1}},
            setSV = {[SV.fluteMissionTracker] = 2, [SV.fluteMissionHint] = 0},
        },
    },
}
centralSystem_registerTable(mission_boneFlute)

function boneFluteMission_onMoveItem(player, item, toPos)
    local boneID = 5925
    if item:getId() ~= boneID then return end
    local altar = findItem(13731, toPos) or findItem(13480, toPos)
    if not altar or altar:getActionId() ~= AIDT.altar then return end
    local bone = findItem(boneID, getDirectionPos(toPos, "W")) or findItem(boneID, getDirectionPos(toPos, "E"))
    if not bone then return end
    local bonePos = bone:getPosition()

    if bone:getUniqueId() == item:getUniqueId() then 
        if bone:getCount() == 1 then return end
        item:remove(2)
    else
        item:remove(1)
        bone:remove(1)
    end

    for x=0, 2 do
        local delay = 500
        addEvent(doSendDistanceEffect, x*delay, toPos, bonePos, 15)
        addEvent(doSendDistanceEffect, x*delay + 250, bonePos, toPos, 15)
    end
    
    if getSV(player, SV.fluteMission) == 0 then setSV(player, SV.fluteMissionTracker, 3) end
    
    addEvent(doSendMagicEffect, 1500, bonePos, 3)
    addEvent(doSendMagicEffect, 1500, toPos, 3)
    addEvent(doSendMagicEffect, 1500, toPos, 14)
    addEvent(createItem, 1500, 21249, toPos)
    return true
end