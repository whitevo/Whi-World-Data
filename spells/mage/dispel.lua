local dispelRune = {
    AIDItems = {
        [AID.other.dispelRune] = {funcStr = "dispelRune_onUse"},
    },
    AIDItems_onMove = {
        [AID.other.mendRune] = {funcStr = "discardItem"},
    }
}
centralSystem_registerTable(dispelRune)

function dispelSpell(playerID)
    local player = Player(playerID)
    if not player then return end
    if player:getEmptySlots() == 0 then return player:sendTextMessage(GREEN, "Not enough room for rune*") end
    if player:getItemCount(2272) > 0 then return player:sendTextMessage(GREEN, "You already have this rune*") end
    return player:giveItem(2272):setActionId(AID.other.dispelRune)
end

local function getChance(player, spellT)
    local chance = spells_getFormulas(player, spellT)
    local times = 1

    while chance >= 100 do
        times = times + 1
        chance = chance-100
    end
    return chanceSuccess(chance) and times+1 or times
end

function dispelRune_onUse(player, item, itemEx, fromPos, toPos)
    if not spells_canCast(player) then return end
    local spellT = spells_getSpellT("dispel")
    if not spells_canCast(player, spellT, true) then return end

    spells_afterCanCast(player, spellT)
    doSendDistanceEffect(player:getPosition(), toPos, 36)
    local target = findCreature("creature", toPos) 
    if not target then return end

    local times = getChance(player, spellT)
    doSendMagicEffect(toPos, {40,48})
    if target:isPlayer() then return dispelDebuffs(target, times) end
    dispelBuffs(target, times)
end

function dispelDebuffs(playerID, times)
    local removeCount = times
    local player = Player(playerID)
    if not player then return end
    local playerID = player:getId()
    local playerPos = player:getPosition()

    removeStun(playerPos)
    removeRoot(playerPos)
    removeBind(playerPos)
    
    for debuffID, t in pairs(onHitDebuff_damNerfT) do
        if removeCount <= 0 then return true end
        if t.creatureID == playerID then
            onHitDebuff_damNerfT[debuffID] = nil
            removeCount = removeCount-1
        end
    end

    for debuffID, t in pairs(onHitDebuff_damageT) do
        if removeCount <= 0 then return true end
        if t.creatureID == playerID then
            onHitDebuff_damageT[debuffID] = nil
            removeCount = removeCount-1
        end
    end

    if player:getSV(SV.barrierDebuffPercent) > 0 then
        removeCount = removeCount-1
        removeSV(SV.barrierDebuffPercent)
    end
    
    for condition, condT in pairs(conditions) do
        if condition == "SLOW" or condition == "DOT_FIRE" or condition == "DOT_EARTH" then
            for param, t in pairs(condT) do
                for ID, subID in pairs(t) do
                    if removeCount <= 0 then return true end
                    if player:getCondition(_G[condition], subID) then
                        player:removeCondition(_G[condition], subID)
                        removeCount = removeCount-1
                    end
                end
            end
        end
    end
end

function dispelBuffs(monsterID, times)
    local monster = Monster(monsterID)
    if not monster then return end
    local removeCount = times
    local onThink = {"banditShamanAura", "ghoul_regen"} -- list of debuffable onThink events
    local onDeath = {"skeletonWarrior_boneShield"}
    local onHealthChange = {}

    for _, eventName in pairs(onThink) do unregisterEvent(monster, "onThink", eventName) end
    for _, eventName in pairs(onDeath) do unregisterEvent(monster, "onDeath", eventName) end
    for _, eventName in pairs(onHealthChange) do unregisterEvent(monster, "onHealthChange", eventName) end
end