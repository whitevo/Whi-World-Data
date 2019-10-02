local area = {
    {1,n,1},
    {n,0,n},
    {1,n,1},
}

function innervateSpell(playerID, spellT, targetName)
    local player = Player(playerID)
    if not player then return end
    local target = player

    if targetName ~= "" then
        target = Player(targetName)
        if not target or not phadraRobe(player) then return player:sendTextMessage(GREEN, "Can't cast innervate to target") end
    end
    local duration = 60000
    local targetID = target:getId()

    target:sendTextMessage(GREEN, "Innervate has been casted on you")
    target:sendTextMessage(ORANGE, "Innervate lasts "..(duration/1000).." seconds")
    registerEvent(target, "onThink", "innervate_onThink")
    stopAddEvent(targetID, "innervate")
    stopAddEvent(targetID, "innervate_msg")
    registerAddEvent(targetID, "innervate_msg", duration, {doSendTextMessage, targetID, ORANGE, "Innervate is over"})
    registerAddEvent(targetID, "innervate", duration, {unregisterEvent, targetID, "onThink", "innervate_onThink"})
end

local function effect(player, stage)
    local playerPos = player:getPosition()
    local positions = getAreaPos(playerPos, area)
    
    for _, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            if stage == 1 then
                doSendMagicEffect(pos, 2)
                doSendDistanceEffect(playerPos, pos, 44)
            elseif stage == 2 then
                doSendMagicEffect(playerPos, 26)
                doSendDistanceEffect(pos, playerPos, 44)
            end
        end
    end
end

local effectStage = {} -- {[playerID] = INT}
function innervate_onThink(player)
    local amount = math.floor(player:getMaxMana()/2/60)
    local playerID = player:getId()
    local stage = effectStage[playerID] or 0

    if stage == 2 then effectStage[playerID] = 0 else effectStage[playerID] = stage + 1 end
    player:addMana(amount)
    effect(player, stage)
end

function innervatePassive(player)
    if getSV(player, SV.innervate) ~= 1 then return 0 end
    local spellT = spells_getSpellT("innervate")
    if spells_onCooldown(player, spellT, true) then return 0 end
    local chance = spells_getFormulas(player, spellT)
    return chance
end