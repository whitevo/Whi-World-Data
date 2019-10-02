function poisonSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if not spellT then spellT = spells_getSpellT("poison") end
    local damage, buffDuration, debuffDuration = spells_getFormulas(player, spellT)

    player:sendTextMessage(ORANGE, "poison debuff duration is: "..getTimeText(debuffDuration))
    player:sendTextMessage(ORANGE, "poison buff duration is: "..getTimeText(buffDuration))
    if debuffDuration < 1 then return end
    if buffDuration < 1 then return end
    playerID = player:getId()
    doSendMagicEffect(player:getPosition(), {15,20})
    setSV(player, SV.poisonSpell, 1)
    stopAddEvent(playerID, "hunterPoison")
    registerAddEvent(playerID, "hunterPoison", buffDuration*1000, {removeHunterPoisonBuff, playerID})
end

function removeHunterPoisonBuff(playerID)
    local player = Player(playerID)
    if not player then return end

    removeSV(player, SV.poisonSpell)
    player:say("**poison out**", ORANGE)
    doSendMagicEffect(player:getPosition(), 9)
    player:sendTextMessage(ORANGE, "poison weared off")
end

local targetDebuffT = {}
function hunterPoison(player, target) -- notice its DEBUFF not a BUFF
    if getSV(player, SV.poisonSpell) ~= 1 then return end
    if not target then return true end
    
    local spellT = spells_getSpellT("poison")
    local originalDamage, buffDuration, debuffDuration = spells_getFormulas(player, spellT)
    if debuffDuration < 1 then return end

    local targetID = target:getId()
    local currentTime = os.time()
    local totalStacks = targetDebuffT[targetID] and targetDebuffT[targetID].lastHit+debuffDuration > currentTime and targetDebuffT[targetID].stack or 0
    local totalDamage = originalDamage

    totalStacks = totalStacks + 1
    if totalStacks > 20 then totalStacks = 20 end
    if not targetDebuffT[targetID] then targetDebuffT[targetID] = {} end
    targetDebuffT[targetID].stack = totalStacks
    targetDebuffT[targetID].lastHit = currentTime
    
    while totalStacks > 1 do
        local addDam = originalDamage - math.floor(originalDamage*0.14)
        originalDamage = addDam
        totalDamage = totalDamage + addDam
        totalStacks = totalStacks - 1
    end
    return dealDamage(player, targetID, EARTH, totalDamage, 17, O_player_spells)
end

function hunterPoison_earlyDamage(player)
    local earlyGameBonusDamage = 30 - 15*player:getMagicLevel()
    return earlyGameBonusDamage > 0 and earlyGameBonusDamage or 0
end

function clean_targetDebuffT(creatureID)
    if creatureID then targetDebuffT[creatureID] = nil return end
    local tablesDeleted = 0
    
    for cid, _ in pairs(targetDebuffT) do
        if not Creature(cid) then
            tablesDeleted = tablesDeleted + 1
            targetDebuffT[cid] = nil
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from clean_targetDebuffT") end
    return tablesDeleted
end
