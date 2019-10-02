local fakeOutfit = {
    lookTypeEx = 20422
}
playerPreviousOutfit = {}

function fakedeathSpell(playerID, spellT)
local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("fakedeath") end
local duration = spells_getFormulas(player, spellT)
local playerPos = player:getPosition()
    
    playerID = player:getId()
    playerPreviousOutfit[playerID] = player:getOutfit()
    doSendMagicEffect(playerPos, {21, 3})
    createItem(11320, playerPos, 1, AID.other.fakeDeathMoveCheck)
    player:setOutfit(fakeOutfit)
    setSV(player, SV.fakedeathOutfit, 1)
    addEvent(removeFakeDeath, duration*1000, playerID)
    bloodyShirt(player)
end

function Player.isFakeDead(player) return getSV(player, SV.fakedeathOutfit) == 1 end

function removeFakeDeath(playerID, item)
local player = Player(playerID)
    if not player then return end
local fakeDeathPos = player:getPosition()
    
    playerID = player:getId()
    if item then fakeDeathPos = item:getPosition() end
    if playerPreviousOutfit[playerID] then player:setOutfit(playerPreviousOutfit[playerID]) end
    removeSV(player, SV.fakedeathOutfit)
    removeItemFromPos(11320, fakeDeathPos)
    unregisterEvent(player, "onThink", "bloodyShirt_regen")
end

function clean_playerPreviousOutfit()
    local tablesDeleted = 0

    for cid, t in pairs(playerPreviousOutfit) do
        if not Player(cid) then
            tablesDeleted = tablesDeleted + 1
            playerPreviousOutfit[cid] = nil
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from playerPreviousOutfit") end
    return tablesDeleted
end
