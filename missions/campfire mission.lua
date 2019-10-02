-- puttin out fire function in: Whi World\data\actions\scripts\cooking and brewing\fluids.lua
local AIDT = AID.missions.campfire
local rewardExp = 20

mission_campfire = {
    questlog = {
        name = "Campfire Mission",
        questSV = SV.campfireMission,
        trackerSV = SV.campfireTracker,
        category = "mission",
        log = {
            [0] = "Put down 4 campfires in Bandit Mountain.",
            [1] = "Put down 3 campfires in Bandit Mountain.",
            [2] = "Put down 2 campfires in Bandit Mountain.",
            [3] = "Put down 1 more campfire in Bandit Mountain.",
            [4] = "Report to Peeter",
        },
    },
    npcChat = {
        ["peeter"] = {
            [109] = {
                question = "Can I help you with that?",
                allSV = {[SV.peeter2] = 1, [SV.campfireMission] = -1},
                setSV = {[SV.campfireMission] = 0, [SV.campfireTracker] = 0},
                answer = {"I don't like these bandits feeling comfortable here, put down their campfires."},
            },
            [110] = {
                question = "I have put down all the campfires",
                allSV = {[SV.campfireTracker] = 4},
                rewardExp = rewardExp,
                setSV = {[SV.campfireMission] = 1, [SV.campfireTracker] = -1},
                answer = {
                    "They though they can just make campfires here with no consequences.", 
                    "I bet you made bandits learn some hard lessons!",
                    "Hopefully they will stop camping on this mountain before they burn it down.",
                },
            },
        },
    },
}
centralSystem_registerTable(mission_campfire)

function campfireMission(player, item, itemEx)
    local itemID = item:getId()
    local itemFluid = item:getFluidType()

    if itemID == 2005 and itemFluid == 1 then putOutCampfire(player, itemEx) end
end

function putOutCampfire(player, itemEx)
    if not itemEx then return end
    local itemExID = itemEx:getId()
    if itemExID ~= 1423 then return end
    local itemPos = itemEx:getPosition()
    local campfire = Tile(itemPos):getItemById(1423)
    local chance = 20
    local campfireAID = campfire:getActionId()
    
    if campfireAID < 100 then chance = 0 end
    text("huff", itemPos)
    
    if chanceSuccess(chance) and not findWaterPool(itemPos) then
        return player:sendTextMessage(ORANGE, "You failed to put fire out, But if you try again right now, it will go out for sure, becasue its wet under campfire.")
    end
    
    doTransform(itemExID, itemPos, 1422, campfireAID)
    
    if campfireAID < 100 then return shadowRoom_placeVial(player) end -- in areas/boss_rooms/shadow.lua 
    local partyMembers = getPartyMembers(player, 5)
        
    addEvent(doTransform, (campfireAID-100)*60*1000, 1422, itemPos, 1423, campfireAID)
    addEvent(text, (campfireAID-100)*60*1000, "hff", itemPos)
    
    for guid, pid in pairs(partyMembers) do
        local member = Player(pid)
        local tracker = getSV(member, SV.campfireTracker)
        
        if tracker >= 0 then
            local n = 3
            local campfiresLeft = n-tracker
            
            addSV(member, SV.campfireTracker, 1, 4)
            if campfiresLeft <= 0 then
                member:sendTextMessage(ORANGE, "go report mission to NPC Peeter")
            else
                member:sendTextMessage(ORANGE, "Put down "..campfiresLeft.." more campfire"..stringIfMore("s", campfiresLeft))
            end
        end
    end
end

function findWaterPool(pos)
    if findItem(2016, pos) then return true end
    if findItem(2017, pos) then return true end
    if findItem(2018, pos) then return true end
end