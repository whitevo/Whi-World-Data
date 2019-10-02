function setActivated(playerID, sv)
    local player = Player(playerID)
    return player and player:getSV(sv) >= 2
end

function leatherSetAS(player)
    if not setActivated(player, SV.leatherSet) then return 0 end
    return getSV(player, SV.leatherSetAS) == 1 and player:getSpeed() or 0
end

-- equipment item effects
-- helm, helmets, head
function snaipaHelmet(player, damage)
    local damX = getSV(player, SV.snaipaHelmet)
    return damX > 0 and percentage(damage, damX) or 0
end

function snaipaHelmet_breakChance(player)
    local breakChance = getSV(player, SV.snaipaHelmet_breakChance)
    return breakChance > 0 and breakChance or 0
end

function kamikazeMask_explosionPercent(player)
    local percent = getSV(player, SV.kamikazeMask_explosionDam)
    return percent > 0 and percent or 0
end

function kamikazeMaskResistance(player, damage)
    local resMultipler = getSV(player, SV.kamikazeMask)
    if resMultipler < 1 then return end
    local playerID = player:getId()
    local eventData = {removeSV, playerID, SV.kamikazeMaskResistance}
    
    setSV(player, SV.kamikazeMaskResistance, percentage(damage, resMultipler))
    stopAddEvent(playerID, "kamikazeMaskResistance")
    registerAddEvent(playerID, "kamikazeMaskResistance", 10000, eventData)
end

function pinpuaHood(player, critHeal) return percentage(critHeal, getSV(player, SV.pinpuaHood)) end

function warriorHelmet(player, frontPos, damage, onlyCheck)
    if getSV(player, SV.warriorHelmet) ~= 1 then return end
    if onlyCheck then return true end
    local rightPos = getDirectionPos(frontPos, player:rightDir())
    local leftPos = getDirectionPos(frontPos, player:leftDir())

    dealDamagePos(player, rightPos, PHYSICAL, damage, 4, O_player_spells, 4)
    dealDamagePos(player, leftPos, PHYSICAL, damage, 4, O_player_spells, 4)
    strikeSpell_bonusEffects(player, rightPos)
    strikeSpell_bonusEffects(player, leftPos)
end

function blessedHoodOnCast(player, onlyCheck)
    if not player:isEquipped(18398, SLOT_HEAD) then return end
    local percentIncrease = getSV(player, SV.blessedHood)
    if onlyCheck then return percentIncrease end
    local playerID = player:getId()
    local eventData = {setSV, playerID, {[SV.blessedHood_stack] = 0}}

    stopAddEvent(playerID, "blessedHood")
    registerAddEvent(playerID, "blessedHood", 6000, eventData)
    addSV(player, SV.blessedHood_stack, percentIncrease, 10)
end

function blessedHood(player, damage) return percentage(damage, getSV(player, SV.blessedHood_stack)) end

function blessedTurban(player, onlyCheck)
    if not player:isEquipped(12442, SLOT_HEAD) then return end
    local percentIncrease = getSV(player, SV.blessedTurban)
    if onlyCheck then return percentIncrease end
    local playerID = player:getId()
    local eventData = {setSV, playerID, {[SV.blessedTurban_stack] = 0}}

    stopAddEvent(playerID, "blessedTurban")
    registerAddEvent(playerID, "blessedTurban", 4000, eventData)
    addSV(player, SV.blessedTurban_stack, percentIncrease, 20)
end

function blessedTurban_damage(player, damage, onlyCheck)
    local percentIncrease = getSV(player, SV.blessedTurban_stack)
    return onlyCheck and percentIncrease or percentage(damage, percentIncrease)
end

function blessedIronHelmet(player, onlyCheck)
    if not player:isEquipped(9735, SLOT_HEAD) then return end
    local percentIncrease = getSV(player, SV.blessedIronHelmet)
    if onlyCheck then return percentIncrease end
    local playerID = player:getId()
    local eventData = {setSV, playerID, {[SV.blessedIronHelmet_armor] = 0}}

    stopAddEvent(playerID, "blessedIronHelmet")
    registerAddEvent(playerID, "blessedIronHelmet", 5000, eventData)
    addSV(player, SV.blessedIronHelmet_armor, percentIncrease, 30)
end

function blessedIronHelmet_armor(player) 
    local armor = getSV(player, SV.blessedIronHelmet_armor)
    return armor > 0 and armor or 0
end

function amanitaHat(player, dam, damType, origin, onlyCheck)
    if damType ~= DEATH then return end
    if origin and origin == O_player_weapons_mage then return end
    if not Player(player) then return end
    local percent = getSV(player, SV.amanitaHat)
        
    if percent < 1 then return end
    if onlyCheck then return percent end
    local healAmount = percentage(-dam, percent)
        
    spells_healing(player, player, healAmount)
end

function arogjaHat_heal(player, onlyCheck)
    local healPercent = getSV(player, SV.arogjaHat)
    if healPercent < 1 then return end
    if onlyCheck then return healPercent end
    local highestBarrier = highestBarrierValue[player:getId()] or 0
    if highestBarrier < 1 then return end
    local healAmount = percentage(highestBarrier, healPercent)

    heal(player, healAmount)
    doSendMagicEffect(player:getPosition(), {2,31})
end

function equipHoodOfNaturalTalent(player)
    local shieldingPoints = getSV(player, SV.shieldingSkillpoints)
    local reduction = math.floor(shieldingPoints/2)
        
    bindCondition(player:getId(), "head", -1, {sL = -reduction+5})
end

function removeHoodOfNaturalTalent(player) return removeCondition(player, "head") end

function equipZvoidTurban(player)
    local shield = player:getSlotItem(CONST_SLOT_RIGHT)
    if not shield then return end
    local itemOz = shield:getType():getWeight()*1.2
    local playerOz = player:getCapacity()

    player:setCapacity(playerOz+itemOz)
    setSV(player, SV.zvoidTurban, itemOz)
    player:sendTextMessage(ORANGE, "shield suddenly is no longer affected by gravity.")
end

function removeZvoidTurban(player)
    local oldOz = getSV(player, SV.zvoidTurban)
    local playerOz = player:getCapacity()
        
    if oldOz > 0 then player:setCapacity(playerOz-oldOz) end
    removeSV(player, SV.zvoidTurban)
end

function traptrixQuiver(player, onlyCheck)
    local manaRefundPercent = getSV(player, SV.traptrixQuiver)
    if manaRefundPercent < 1 then return end
    if onlyCheck then return manaRefundPercent end
    local spellT = spells_getSpellT("trap")
    local manaRefund = percentage(spellT.manaCost, manaRefundPercent)

    player:addMana(manaRefund)
end

function fireQuiverDamage(player, target, damage, onlyCheck)
    if not Player(player) then return end
    local percent = getSV(player, SV.fireQuiverDamage)
    local extraDamage = percentage(damage, percent, true)

    if damage < 1 then return end
    if onlyCheck then return extraDamage end
    if not target then return end
    dealDamage(player, target, FIRE, extraDamage, 30, O_player_weapons_range)
end

function supaky(player, res, onlyCheck)
    if getSV(player, SV.supaky) ~= 1 then return end
    local svT = {
        [SV.rubydef] = {SV.rubyDefSpell, "fire"},
        [SV.opaldef] = {SV.opalDefSpell, "physical"},
        [SV.sapphdef] = {SV.sapphdefSpell, "ice"},
        [SV.onyxdef] = {SV.onyxdefSpell, "death"},
    }
    local usedDamTypes = {}
    local endTime = os.time() + 5

    for spellSV, t in pairs(svT) do
        if getSV(player, spellSV) == 1 then
            if onlyCheck then
                table.insert(usedDamTypes, t[2])
            else
                setSV(player, t[1], res)
                setSV(player, t[1] + 20000, endTime)
            end
        end
    end
    return tableToStr(usedDamTypes, ", ")
end

function akujaaku(player)
    local improvement = getSV(player, SV.akujaaku)
    return improvement > 0 and improvement or 0
end

function demonicShield(player)
    local extraMultiplier = getSV(player, SV.demonicShield)
    return extraMultiplier > 0 and extraMultiplier or 0
end

function yashimaki(player, target, onlyCheck)
    if getSV(player, SV.yashimaki_area) < 1 then return end
    local armor = player:getMagicLevel() * 2
    if onlyCheck then return armor end
    local playerID = target:getId()
    local eventData = {removeSV, playerID, SV.yashimakiArmor}

    Vprint(armor, "armor")
    setSV(target, SV.yashimakiArmor, armor)
    stopAddEvent(playerID, "yashimakiArmor")
    registerAddEvent(playerID, "yashimakiArmor", 10000, eventData)
end

function yashimaki_area(player)
    local areaIncrease = getSV(player, SV.yashimaki_area)
    return areaIncrease > 0 and areaIncrease or 0
end

function ghatitkShield(player, damage, damType, onlyCheck)
    if not Player(player) then return 0 end
    local extraDam = getSV(player, SV.ghatitkShield)
    if extraDam < 1 then return 0 end
    local damTypeStr = getEleTypeByEnum(damType)
    local damTypeT = damageTypeConfig[damTypeStr]

    if not damTypeT or not damTypeT.defSpellSV then return 0 end
    if onlyCheck then return extraDam.."%% more "..damTypeStr:lower().." damage" end
    if os.time() > getSV(player, damTypeT.defSpellSV + 20000) then return 0 end
    return getSV(player, damTypeT.defSpellSV) > 0 and percentage(damage, extraDam) or 0
end

function thunderBook(player, damage)
    local percent = getSV(player, SV.thunderBook)
    return percentage(damage, percent)
end

function zvoidShield(player)
    local zvoidShieldRes = getSV(player, SV.zvoidShield)
    return zvoidShieldRes > 0 and zvoidShieldRes or 0
end

function gribitShield(player, buff, duration, areaT, onlyCheck)
    if getSV(player, SV.gribitShield) ~= 1 then return end
    if onlyCheck then return true end
    
    for _, posT in pairs(areaT) do
        for _, pos in pairs(posT) do
            local player = findCreature("player", pos)
            if player then buffPlayer(player, buff, duration) end
        end
    end
end

function bianhurenActivate(player, buffAmount, duration, onlyCheck)
    if getSV(player, SV.bianhuren) ~= 1 then return end
    if onlyCheck then return buffAmount end
    if not duration then return end
    local playerID = player:getId()

    duration = duration-30*60
    setSV(player, SV.bianhurenReflect, buffAmount)
    stopAddEvent(playerID, "druidBuff_reflect")
    registerAddEvent(playerID, "druidBuff_reflect", duration*1000, {removeSV, playerID, SV.bianhurenReflect})
    return player:sendTextMessage(ORANGE, "your are reflecting "..buffAmount.."% physical damage for "..getTimeText(duration))
end

function bianhuren(player, attacker, damage, damType)
    if damType ~= PHYSICAL then return end
    if not attacker then return end
    if getSV(player, SV.bianhuren) ~= 1 then return end
    local reflectPercent = getSV(player, SV.bianhurenReflect)*3
    if reflectPercent < 1 then return end

    local reflectDamage = percentage(damage, reflectPercent)
    if reflectDamage > 0 then doDamage(attacker, PHYSICAL, reflectDamage, 1, O_player_proc, false, 4) end
end

function stoneShield(player, damage, onlyCheck)
    local damageAmount = getSV(player, SV.stoneShield)
    if damageAmount < 1 then return end
    if onlyCheck then return damageAmount - player:getDefence() end
    addSV(player, SV.stoneShield_damageTaken, -damage)
end

function stoneShield_breakDown(player)
    local damageAmount = getSV(player, SV.stoneShield)
    local damageTaken = getSV(player, SV.stoneShield_damageTaken)

    setSV(player, SV.stoneShield_damageTaken, 0)
    if damageAmount < 1 then return end
    if damageTaken < damageAmount - player:getDefence() then return end
    player:addMana(35)
    player:getPosition():sendMagicEffect(31)
end

function shikaraNankan(player)
    local percentIncrease = getSV(player, SV.shikaraNankan)
    local barrier = player:getBarrier()

    return barrier > 4 and percentage(barrier, percentIncrease) or 0
end

function goddessArmor(player, target, onlyCheck)
    if getSV(player, SV.goddessArmor) ~= 1 then return end
    if onlyCheck then return true end
    local pos = target:getPosition()

    removeRoot(pos)
    removeBind(pos)
end

function bloodyShirt(player, onlyCheck)
    local multiplier = getSV(player, SV.bloodyShirt)
    if multiplier < 1 then return end
    local healAmount = 20 + player:getMagicLevel()*multiplier
    
    if onlyCheck then return healAmount end
    registerEvent(player, "onThink", "bloodyShirt_regen")
end

function bloodyShirt_regen(player)
    local multiplier = getSV(player, SV.bloodyShirt)
    if multiplier < 1 then return end
    local healAmount = 20 + player:getMagicLevel()*multiplier

    return spells_healing(player, player, healAmount , 1)
end

function leatherVest_extraThrowAxeBounces(player)
    local bounceTimes = getSV(player, SV.leatherVest)
    return bounceTimes > 0 and bounceTimes or 0
end

function kamikazeMantle_explosionPercent(player)
    local percent = getSV(player, SV.kamikazeMantle_explosion)
    return percent > 0 and percent or 0
end

function kamikazeMantle_activateDamageBoost(player, damage)
    local damagePercet = getSV(player, SV.kamikazeMantle_percent)
    if damagePercet < 1 then return end
    local damageProc = percentage(damage, damagePercet)

    addSV(player, SV.kamikazeMantle_damage, damageProc)
end

function kamikazeMantle_addDamage(player, onlyCheck)
    local extraDamage = getSV(player, SV.kamikazeMantle_damage)
    if onlyCheck then return extraDamage end
    removeSV(player, SV.kamikazeMantle_damage)
    return extraDamage > 0 and extraDamage or 0
end

function demonicRobe(player, damage, onlyCheck)
    local percentAbsorb = getSV(player, SV.demonicRobe)
    if percentAbsorb < 1 then return 0 end
    if onlyCheck then return percentAbsorb end
    local playerID = player:getId()

    for impID, cid in pairs(impTarget) do
        if cid == playerID then
            local imp = Monster(impID)
            if imp and imp:getHealth() < imp:getMaxHealth()/2 then return percentage(damage, percentAbsorb) end
            break
        end
    end
    return 0
end

function phadraRobe(player) return getSV(player, SV.phadraRobe) == 1 end

function ghatitkArmor(player, healAmount, onlyCheck)
    local percentIncrease = getSV(player, SV.ghatitkArmor)
    if onlyCheck then return percentIncrease end
    return percentIncrease > 0 and percentage(healAmount, percentIncrease) or 0
end

function traptrixCoat(player, onlyCheck)
    if getSV(player, SV.traptrixCoat) ~= 1 then return end
    if onlyCheck then return true end
    local playerPos = player:getPosition()
    local leftPos = getDirectionPos(playerPos, player:leftDir())
    local rightPos = getDirectionPos(playerPos, player:rightDir())
    
    placeHunterTrap(player, leftPos)
    placeHunterTrap(player, rightPos)
end

function stoneArmor_heal(player, onlyCheck)
    local multiplier = getSV(player, SV.stoneArmor)
    if multiplier < 1 then return end
    local healAmount = player:getShieldingLevel()*multiplier + 5
    
    if onlyCheck then return healAmount end
    if getSV(player, SV.armorUpSpell) < 1 then return end
    heal(player, healAmount)
end

function precisionRobe(player)
    local robeRange = getSV(player, SV.precisionRobe)
    return robeRange > 0 and robeRange or 0
end

function yashiteki_area(player)
    local areaIncrease = getSV(player, SV.yashiteki_area)
    return areaIncrease > 0 and areaIncrease or 0
end

function itemYashiteki(player)
    if not yashinuken(player) then return end
    player:sendTextMessage(ORANGE, "Your mend spell heals monsters again.")
    removeSV(player, SV.yashinuken)
end

function shimasuLegs(player, damage, res, damType)
    if damType ~= DEATH then return end
    if res < 1 then return end
    local percentIncrease = getSV(player, SV.shimasuLegs)
    local resisted = percentage(damage, percentIncrease)

    if resisted > 0 then return end
    addSV(player, SV.shimasuLegs_barrier, -resisted)
end

local ghatitkLegsResT = {}
function ghatitkLegs(player, creature, primaryDamage, primaryType, origin)
    if origin ~= O_player_weapons_melee then return end
    if not Player(player) then return end
    local maxRes = getSV(player, SV.ghatitkLegs)
    if maxRes < 1 then return end
    local damTypes = {[primaryType] = true}
    local _, talent_eleType = elemental_strikeAmount(player, primaryDamage, primaryType, true)
    local playerID = player:getId()

    if getSV(player, SV.fireQuiverDamage) > 0 and player:getItemById(2456) and player:getItemById(2544) then damTypes[FIRE] = true end
    if getSV(player, SV.arcaneBoots) == 2 then damTypes[ENERGY] = true end
    if getSV(player, SV.zvoidBoots_proc) == 1 then damTypes[ENERGY] = true end
    if getSV(player, SV.thunderstruck) > 0 then damTypes[ENERGY] = true end
    if talent_eleType then damTypes[getEleTypeEnum(talent_eleType)] = true end
    
    for damType, _ in pairs(damTypes) do
        if not ghatitkLegsResT[playerID] then ghatitkLegsResT[playerID] = {} end
        local oldStack = ghatitkLegsResT[playerID][damType] or 0
        local newStack = getSV(player, SV.ghatitkLegs_regTime) + 3 < os.time() and 1 or oldStack + 1
        
        if newStack > maxRes then newStack = maxRes end
        setSV(player, SV.ghatitkLegs_regTime, os.time())
        ghatitkLegsResT[playerID][damType] = newStack
    end
end

function ghatitkLegs_resistance(player, damTypeStr)
    if getSV(player, SV.ghatitkLegs_regTime) + 3 < os.time() then return 0 end
    local resT = ghatitkLegsResT[player:getId()]

    return resT and resT[getEleTypeEnum(damTypeStr)] or 0
end

function kamikazePants_explosionPercent(player)
    local percent = getSV(player, SV.kamikazePants_explosion)
    return percent > 0 and percent or 0
end

function kamikazePants_explodeBarrier(player) return getSV(player, SV.kamikazePants) > 0 and explodeBarrier(player) end
function kamikazeShortPants_radius(player) return getSV(player, SV.kamikazeShortPants) == 1 and 1 or 0 end

function frizenKilt(player, target, damType, origin, onlyCheck)
    if damType ~= ICE then return end
    if origin and origin == O_player_weapons_mage then return end
    if not Player(player) then return end
    local slowPercent = getSV(player, SV.frizenKilt)
    if slowPercent < 1 then return end
    if onlyCheck then return slowPercent end
    if not target then return end
    local condition =  target:getCondition(SLOW, SUB.SLOW.speed.frizenKilt)
    if condition then return condition:setTicks(4000) end
    local slow = percentage(target:getSpeed(), slowPercent)

    return bindCondition(target, "frizenKilt", 4000, {speed = -slow})
end

function demonicLegs(player, imp, onlyCheck)
    local percentIncrease = getSV(player, SV.demonicLegs)
    if percentIncrease < 1 then return end
    if onlyCheck then return percentIncrease end
    local maxHP = imp:getMaxHealth()
    local newMaxHP = percentage(maxHP, percentIncrease)

    imp:setMaxHealth(newMaxHP)
    imp:addHealth(newMaxHP)
    impResistance[imp:getId()] = {
        PHYSICAL = player:getResistance("physical"),
        ICE = player:getResistance("ice"),
        EARTH = player:getResistance("earth"),
        FIRE = player:getResistance("fire"),
        ENERGY = player:getResistance("energy"),
        HOLY = player:getResistance("holy"),
        DEATH = player:getResistance("death"),
    }
end

function stoneLegs(player, damage, onlyCheck)
    local percentProtection = getSV(player, SV.stoneLegs)
    if percentProtection < 1 then return 0 end
    if onlyCheck then return percentProtection end
    if getSV(player, SV.armorUpSpell) < 1 then return 0 end
    return percentage(damage, percentProtection)
end

function chamakLegs(player, target, damage, onlyCheck)
    local percent = getSV(player, SV.chamakLegs)
    if onlyCheck then return percent end
    if not target then return 0 end
    if not tauntedCreatures[target:getId()] then return 0 end
    return percentage(damage, percent)
end

function gribitLegs(player, damType, onlyCheck)
    if onlyCheck then return getSV(player, SV.gribitShield) > 0 and getSV(player, SV.gribitLegs) end
    local percentIncrease = getSV(player, SV.buffSpell)
    if percentIncrease < 1 then return 0 end
    if damType ~= EARTH then return 0 end
    local partyMembers = getPartyMembers(player, 5)
    
    for guid, cid in pairs(partyMembers) do
        if cid ~= player:getId() and getSV(cid, SV.gribitShield) > 0 then
            local percentIncrease = getSV(cid, SV.gribitLegs)
            if percentIncrease > 0 then return percentIncrease end
        end
    end
    return 0
end

function speedzyLegs(player, onlyCheck)
    if not player:isPlayer() then return end
    local duration = getSV(player, SV.speedzyLegs_duration)

    if duration < 1 then return end
    if onlyCheck then return duration end
    local speedzyBuffStack = getSV(player, SV.speedzyLegs)
    local stack = speedzyBuffStack > 0 and speedzyBuffStack or 1
    local speedzyLegsBuff = player:getCondition(HASTE, SUB.HASTE.speed.speedzyLegs)

    bindCondition(player, "speedzyLegs", duration*1000, {speed = stack*stack*2})
    return not speedzyLegsBuff and setSV(player, SV.speedzyLegs, 1) or addSV(player, SV.speedzyLegs, 1, 8)
end

function gensoFedo(player, damage)
    if damage >= 0 then return end
    local healAmount = getSV(player, SV.gensoFedo)
    if healAmount < 1 then return end
    local barrier = player:getBarrier()
    local barrierDamage = math.ceil(healAmount/2)

    heal(player, healAmount)
    player:takeBarrier(barrierDamage)
end

function intrinsicLegs(player, damType)
    if damType == PHYSICAL then return end
    local requiredPercent = getSV(player, SV.intrinsicLegs)

    if requiredPercent < 1 then return end
    local damTypeStr = getEleTypeByEnum(primaryType):lower()
    local res = player:getResistance(damTypeStr)
    local mana = 0

    while res-requiredPercent >= 0 do
        mana = mana + 1
        res = res - requiredPercent
    end
    if mana > 5 then mana = 5 end
    if mana > 0 then player:addMana(mana) end
end

function chivitBoots(player)
    local critChance = getSV(player, SV.chivitBoots)
    if critChance < 1 then return 0 end
    if player:getHealth() >= math.floor(player:getMaxHealth()/4) then return 0 end
    return critChance
end

function kakkiBoots(player, damage)
    local protection = getSV(player, SV.kakkiBoots)
    if protection < 1 then return 0 end
    if player:getMana() >= math.floor(player:getMaxMana()/4) then return 0 end
    return percentage(damage, protection)
end

function zvoidBoots_mana(player, manaCost, onlyCheck)
    local requiredManaCost = getSV(player, SV.zvoidBoots_mana)
    if manaCost <= requiredManaCost then return end
    if onlyCheck then return getSV(player, SV.zvoidBoots_damage)*10 end
    setSV(SV.zvoidBoots_proc, 1)
end

function zvoidBootsDamage(player, target)
    if getSV(player, SV.zvoidBoots_proc) ~= 1 then return end
    local multiplier = getSV(player, SV.zvoidBoots_damage)

    removeSV(player, SV.zvoidBoots_proc)
    if multiplier < 1 then return end
    local damage = player:getMagicLevel() * multiplier
    local maxDam = multiplier * 10

    if damage > maxDam then damage = maxDam end
    dealDamage(player:getId(), target:getId(), ENERGY, damage, 5, O_player_proc, false, 12)
end

function arcaneBoots_mana(player, manaCost, onlyCheck)
    local maxManaCost = getSV(player, SV.arcaneBoots_mana)
    if manaCost >= maxManaCost then return end
    if onlyCheck then return getSV(player, SV.arcaneBoots_damage)*10 end
    setSV(player, SV.arcaneBoots_proc, 1)
end

function arcaneBootsDamage(player, target)
    if getSV(player, SV.arcaneBoots_proc) ~= 1 then return end
    local multiplier = getSV(player, SV.arcaneBoots_damage)

    removeSV(player, SV.arcaneBoots_proc)
    if multiplier < 1 then return end
    local damage = player:getMagicLevel() * multiplier
    local maxDam = multiplier * 10

    if damage > maxDam then damage = maxDam end
    dealDamage(player, target, ENERGY, damage, 5, O_player_proc, false, 12)
end

function warriorBoots(player, spellName)
    if spellName ~= "strike" then return end
    local newManaCost = getSV(player, SV.warriorBoots)
    return newManaCost > 0 and getSV(player, SV.armorUpSpell) > 0 and newManaCost
end

function namiBoots_equipped(player) return getSV(player, SV.namiBoots) > 0 end

function namiBootsRange(player)
    local namiRange = getSV(player, SV.namiBoots)
    return namiRange > 0 and namiRange or 0
end

function yashinuken_area(player)
    local areaIncrease = getSV(player, SV.yashinuken_area)
    return areaIncrease > 0 and areaIncrease or 0
end

function yashinuken(player) return getSV(player, SV.yashinuken) == 1 end

function atsuiKori(player, target, pos, damage, damType, onlyCheck)
    local function reverseDamType()
        if damType == FIRE then return ICE, getEffectByType(ICE), SV.atsuiKori_ice end
        if damType == ICE then return FIRE, 6, SV.atsuiKori_fire end
    end
    local damType, effect, sv = reverseDamType()
    local percentAmount = getSV(player, sv)

    if percentAmount < 1 then return end

    damage = percentage(damage, percentAmount)
    if onlyCheck then return percentAmount, getEleTypeByEnum(damType):lower() end
    if not target then return dealDamagePos(player, pos, damType, damage, effect, O_player_spells) end
    potions_spellCaster_heal(player)
    dealDamage(player, target, damType, damage, effect, O_player_spells)
end

function kaijuWall(player)
    local kajuBarrier = getSV(player, SV.kaijuWall)
    return kajuBarrier > 0 and kajuBarrier or 0
end

function immortalKamikaze_explosionPercent(player)
    local percent = getSV(player, SV.immortalKamikaze_explosion)
    return percent > 0 and percent or 0
end

function zvoidTurban(cid, item, slot)
    local player = Player(cid)

    if player:getStorageValue(SV.zvoidTurban) > 0 then
        local itemOz = item:getType():getWeight()
        local playerOz = player:getCapacity()
        local newitem = item:clone()
        
        item:remove()
        player:setCapacity(playerOz+itemOz)
        player:addItemEx(newitem, true, slot)
        player:setCapacity(playerOz)
        player:sendTextMessage(GREEN, "Can't DeEquip shield while zvoid turban is ON.")
        return true
    end
end

function kamikazeWand_onUse(player)
    if getSV(player, SV.immortalKamikaze_explosion) < 1 then return player:sendTextMessage(GREEN, "equip weapon first.") end
    if player:getBarrier() < 1 then return player:sendTextMessage(ORANGE, "You don't have barrier") end
    arogjaHat_heal(player)
    explodeBarrier(player)
end

function purifyingMallet_onUse(player)
    local cooldown = getSV(player, SV.purifyingMallet_cd)
    if cooldown < 1 then return player:sendTextMessage(GREEN, "equip weapon first.") end
    if os.time() <= getSV(player, SV.purifyingMalletCD) + cooldown then return player:sendTextMessage(GREEN, "weapon is under cooldown") end
    local playerPos = player:getPosition()
    local area = getAreaAround(playerPos)
    local damage = 30*player:getWeaponLevel() + 15*player:getLevel()

    dispelDebuffs(player, 10)
    setSV(player, SV.purifyingMalletCD, os.time())
    
    for _, pos in pairs(area) do
        damage = damage + sharpening_weapon(player, damage)
        damage = damage + elemental_powers(player, damage, HOLY)
        dealDamagePos(player, pos, HOLY, damage, 50, O_player_proc)
        playerPos:sendDistanceEffect(pos, 27)
    end
end

function yashinukenWand_onUse(player)
    if player:getSV(SV.yashinuken_area) < 1 or player:getSV(SV.yashiteki_area) < 1 then return player:sendTextMessage(GREEN, "you need to equip both items first") end
    
    if not yashinuken(player) then 
        setSV(player, SV.yashinuken, 1)
        player:sendTextMessage(ORANGE, "Your mend spell no longer heals monsters.")
    else
        removeSV(player, SV.yashinuken)
        player:sendTextMessage(ORANGE, "Your mend spell heals monsters again.")
    end
end