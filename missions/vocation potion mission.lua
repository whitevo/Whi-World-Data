local rewardExp = 20
local questSV = SV.vocationPotionMission
local trackerSV = SV.vocationPotionTracker

mission_vocationPotion = {
    questlog = {
        name = "Vocation Potion Mission",
        questSV = questSV,
        trackerSV = trackerSV,
        category = "mission",
        log = {
            [0] = {
                "Create any of the 4 vocation potions.",
                "First ingredient for vocation potions can be bought from Speedball Minigame",
            },
            [1] = "Take vocation potion to Tonka",
        },
    },
    npcChat = {
        ["tonka"] = {
            [136] = {
                question = "need any more help from me?",
                allSV = {[questSV] = -1, [SV.smallStonesMission] = 1},
                setSV = {[questSV] = 0, [trackerSV] = 0},
                answer = {"I'm running low on special vocation potions.", "make me your own made vocation potion and bring it to me."},
            },
            [137] = {
                question = "I have created the vocation potion",
                allSV = {[trackerSV] = 1},
                funcSTR = "vocationPotionMission_findPotion",
            },
        },
    },
}
centralSystem_registerTable(mission_vocationPotion)

local vocationPotionAIDT = {2208, 2209, 2210, 2211}
function vocationPotionMission_createdPot(player, potionAID)
    if getSV(player, trackerSV) ~= 0 then return end
    if not isInArray(vocationPotionAIDT, potionAID) then return end
    setSV(player, trackerSV, 1)
end

function vocationPotionMission_findPotion(player)
    for _, potionAID in pairs(vocationPotionAIDT) do
        local potT = brewing_getPotionT(potionAID)
        if player:getItemCount(potT.itemID, potionAID) > 0 then
            return vocationPotionMission_complete(player, potT)
        end
    end
    player:sendTextMessage(BLUE, "Tonka: You maybe have created it, but I wanted you to bring it to me xD")
end

function vocationPotionMission_complete(player, potT)
    player:removeItem(potT.itemID, 1, potT.itemAID)
    setSV(player, questSV, 1)
    removeSV(player, trackerSV)
    player:sendTextMessage(BLUE, "Tonka: Nice dude! This is perfect!!")
    player:sendTextMessage(BLUE, "Tonka: Btw, if you show me any kind of herb powder I might know something about it.")
    player:sendTextMessage(BLUE, "Tonka: I'm guy with connections if you know what I mean.")
    player:sendTextMessage(BLUE, mission_vocationPotion.questlog.name.." completed")
end