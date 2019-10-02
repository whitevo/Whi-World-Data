local AIDT = AID.quests.mummyBless
local questSV = SV.mummyBless_questSV
local trackerSV = SV.mummyBless_trackerSV

local confT = {
    exp = 25
}
quest_MummyBless = {
    questlog = {
        name = "Mummy Bless Quest",
        questSV = questSV,
        trackerSV = trackerSV,
        log = {
            [0] = "Figure out a way to get into the other chambers in the mummy room.",
            [1] = "Find the gate keeper statue somewhere in these chambers.",
        },
        hintLog = {
            [0] = {
                [SV.mummyBless_hintFromNote] = "Connect the floorboards so that an electric current can pass from one well to the other.",
                [SV.mummyBless_hintFromTanner] = "Connect the metal wires under the floor tiles so that they connect the wells to each other.",
            },
        },
    },
    npcChat = {
        ["eather"] = {
            [56] = {
                question = "Do you know how to advance further in the catacombs' mummy room?",
                allSV = {[trackerSV] = 0},
                setSV = {[SV.mummyBless_hintFromTanner] = 1},
                answer = {
                    "The room with metal wires inside the floor?",
                    "Aren't the wires already connected?",
                    "Hmm, never had to connect them myself, but as far as I know, the wires have to connect the two wells.",
                },
            },
        },
    },
    mapEffects = {
        ["gatekeeper statue"] = {pos = {x = 643, y = 775, z = 9}},
    },
    AIDItems = {
        -- ghoulBlessQuest_start() is activated inside mummyRoom_enter()
        [AIDT.blessStatue] = {funcSTR = "mummyBlessQuest_bless"},
        [AIDT.ladder] = {teleport = {x = 636, y = 776, z = 8}},
    },
    AIDItems_onLook = {
        [AIDT.blessStatue] = {text = {msg = "Gatekeeper statue - Mummy bless"}},
    },
}
centralSystem_registerTable(quest_MummyBless)

function mummyBlessQuest_start(player)
local questStatus = getSV(player, questSV)

    if questStatus == 0 or questStatus == 1 then return end
    setSV(player, trackerSV, 0)
    setSV(player, questSV, 0)
    player:sendTextMessage(ORANGE, "You started "..quest_MummyBless.questlog.name..", solve ancient puzzles to advance further in this room.")
end

function mummyBlessQuest_bless(player, item)
    if getSV(player, questSV) == 1 then return player:sendTextMessage(GREEN, "You already have Mummy bless") end
    setSV(player, questSV, 1)
    removeSV(player, trackerSV)
    player:sendTextMessage(BLUE, "You now have Mummy bless")
    player:addExpPercent(confT.exp)
    questSystem_completeQuestEffect(player)
end

function mummyBlessQuest_puzzleSolved(player) -- inside lineTile_checkLines()
    if getSV(player, trackerSV) == 0 then setSV(player, trackerSV, 1) end
end