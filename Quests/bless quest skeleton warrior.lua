local rewardExp = 25
local AIDT = AID.quests.skeletonWarrior

quest_skeletonWarrior = {
    questlog = {
        name = "Skeleton Warrior Quest",
        questSV = SV.skeletonWarrior_questSV,
        trackerSV = SV.skeletonWarrior_trackerSV,
        log = {
            [0] = {"Find a way to the floor below through the Skeleton Warrior maze in the Rooted catacombs and touch the gate keeper statue to get blessed."},
        },
    },
    mapEffects = {
        ["statue"] = {pos = {x = 560, y = 786, z = 9}},
    },
    AIDItems_onLook = {
        [AIDT.statue] = {text = {msg = "Gate keeper statue - Skeleton Warrior bless."}},
    },
    AIDItems = {
        [AIDT.rail] = {funcSTR = "skeletonWarriorQuest_start"},
        [AIDT.statue] = {
            allSV = {[SV.skeletonWarrior_trackerSV] = 0},
            setSV = {[SV.skeletonWarrior_questSV] = 1, [SV.skeletonWarrior_trackerSV] = -1},
            text = {type = BLUE, msg = {"You now have Skeleon Warrior bless"}},
            textF = {msg = {"You already have Skeleton Warrior bless"}},
            funcSTR = "questSystem_completeQuestEffect",
            exp = rewardExp,
        }
    },
}
centralSystem_registerTable(quest_skeletonWarrior)

function skeletonWarriorQuest_start(player, item)
    climbOn(player, item)
    if getSV(player, SV.skeletonWarrior_questSV) == -1 then
        setSV(player, SV.skeletonWarrior_questSV, 0)
        setSV(player, SV.skeletonWarrior_trackerSV, 0)
        player:sendTextMessage(ORANGE, "You started "..quest_skeletonWarrior.questlog.name..", find a way to floor below in Skeleton Warrior room")
        questSystem_startQuestEffect(player)
    end
end