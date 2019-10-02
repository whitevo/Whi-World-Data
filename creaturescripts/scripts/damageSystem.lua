function onHealthChange(creature, attacker, damage, damType, secD, secT, origin)
    return damageSystem_onHealthChange(creature, attacker, damage, damType, origin)
end

function damageSystem_onHealthChange(creature, attacker, damage, damType, origin)
    if creature:isPlayer() then return damageSystem_player(creature, attacker, damage, damType, origin) end
    return damageSystem_monster(creature, attacker, damage, damType, origin)
end

damageTypeConfig = {
    FIRE = {defSpellSV = SV.rubyDefSpell, effect = 37, fe = 4, sv = SV.fireDam},
    PHYSICAL = {defSpellSV = SV.opalDefSpell, effect = 27, fe = 30, sv = SV.physicalDam},
    ICE = {defSpellSV = SV.sapphdefSpell, effect = 44, fe = 29, sv = SV.iceDam},
    DEATH = {defSpellSV = SV.onyxdefSpell, effect = 18, fe = 11, sv = SV.deathDam},
    ENERGY = {sv = SV.energyDam},
    EARTH = {sv = SV.earthDam}
}
--[[ ORIGIN MAP
    O_player_spells = 12
    O_player_proc = 13
    O_monster_spells = 14
    O_monster_procs = 15
    O_environment = 16
    O_environment_player = 17
    O_environment_monster = 18
    O_monster_procs_player = 19
    O_player_weapons_range = 20
    O_player_weapons_melee = 21
    O_player_weapons_mage = 22
    O_player_weapons = 11
    O_fireProc = 23
    O_demonSkeletonTower = 24
    O_royale = 25
]]

function damageSystem_player(defender, attacker, damage, damType, origin)
    if origin == O_royale then return royale_onHealthChange(defender, damage, damType) end
    if damType == COMBAT_HEALING or damType == COMBAT_LIFEDRAIN then return damage, damType end
    damage = damage > 0 and damage or -damage
    if not damageSystem_canDoDamage(defender, attacker) then return 0 end

    potions_knight_damage(attacker, defender, damType, origin) -- fire proc
    potions_knight_armorOnHit(attacker, origin) -- reduces armor
    
    damage = damage - elemental_strikeDamage(attacker, defender, damage, damType) -- elemental proc
    damage = damage + green_powderDamage(attacker, damage, damType) -- dam increase
    damage = damage + ghatitkShield(attacker, damage, damType) -- dam increase
    damage = damage + chamakLegs(defender, attacker, damage) -- dam increase
    damage = damage - stoneLegs(defender, damage) -- dam reduce
    damage = damage - demonicRobe(defender, damage) -- dam reduce
    damage = damage + criticalHit(attacker, damage, origin, defender:getPosition()) -- dam increase

    bianhuren(defender, attacker, damage, damType) -- proc
    damage = damage - druidBuffSpell(defender, damage, damType) -- dam reduce
    damage = damage + playerResistance(defender, attacker, damage, damType) -- dam reduce
    damage = damage - knightSpellDefs(defender, damage, damType) -- dam reduce and proc
    if damage < 1 then return damageSystem_noDamage(defender, attacker, damage, damType) end
    
    damage = damage - playerArmor(defender, damType)
    damage = damage - barrierDamage(defender, damage, damType)
    damage = damage - defender:getDefence()
    if damage < 1 then return damageSystem_noDamage(defender, attacker, damage, damType) end

    damage = damage + kakkiBoots(defender, damage) -- dam reduce
    damage = damage + demon_master(defender, damage) -- dam increase
    damage = damage + damageSystem_pvpDamage(damage, origin) -- dam reduce
    damage = damage - onHitDebuff_damageReduction(attacker, damage, damType)
    if damage < 1 then return damageSystem_noDamage(defender, attacker, damage, damType) end
    
    iceGem(defender)
    stoneShield(defender, damage)
    stoneArmor_heal(defender)
    gensoFedo(defender, damage)
    intrinsicLegs(defender, damage, damType)

    onHitDebuff_damage(defender, damage, damType, origin)
    potions_hunter_damage(attacker, defender, damType)
    tactical_strike(attacker, origin)
    crushing_strength(attacker, defender, damType, origin)
    liquid_fire(attacker, defender, damage, damType, origin)
    hit_and_runFunc(attacker, damType)
    amanitaHat(attacker, damage, origin, damType)
    wounding(attacker, defender, damType)
    frizenKilt(attacker, defender, damType, origin)
    ghatitkLegs(attacker, defender, damage, damType, origin)
    mental_power(attacker, defender, damType, origin)
    thunderstruck(attacker, defender, damType)
    damage = finalDamage(attacker, damage)
    damage = veryFinalDamage(defender, damage)
    return damage, damType
end

function damageSystem_monster(defender, attacker, damage, damType, origin)
    local startTime = os.mtime() -- temp
    if damType == COMBAT_HEALING or damType == COMBAT_LIFEDRAIN then return damage, damType end
    damage = damage > 0 and damage or -damage
    if not damageSystem_canDoDamage(defender, attacker) then return 0 end
    if damageSystem_taunted(defender, attacker, damage, damType, origin) then return 0 end

    damage = damage + damageSystem_damageIncreaseMonsters(attacker, damage, damType, origin)

    potions_knight_damage(attacker, defender, damType, origin)
    potions_knight_armorOnHit(attacker, origin)
    
    damage = damage - elemental_strikeDamage(attacker, defender, damage, damType)
    damage = damage + green_powderDamage(attacker, damage, damType)
    damage = damage + ghatitkShield(attacker, damage, damType)
    damage = damage + monsterResistance(defender, damage, damType)
    damage = damage + criticalHit(attacker, damage, origin, defender:getPosition())
    damage = damage - onHitDebuff_damageReduction(attacker, damage, damType)
    if damage < 1 then return damageSystem_noDamage(defender, attacker, damage, damType) end

    onHitDebuff_damage(defender, damage, damType, origin)
    potions_hunter_damage(attacker, defender, damType)
    tactical_strike(attacker, origin)
    crushing_strength(attacker, defender, damType, origin)
    liquid_fire(attacker, defender, damage, damType, origin)
    hit_and_runFunc(attacker, damType)
    amanitaHat(attacker, damage, origin, damType)
    wounding(attacker, defender, damType)
    frizenKilt(attacker, defender, damType, origin)
    ghatitkLegs(attacker, defender, damage, damType, origin)
    mental_power(attacker, defender, damType, origin)
    thunderstruck(attacker, defender, damType)
    damage = finalDamage(attacker, damage)
    damage = veryFinalDamage(defender, damage)
    return damage, damType
end

function damageSystem_noDamage(defender, attacker, damage, damType)
    damage = finalDamage(attacker, damage)
    damage = veryFinalDamage(defender, damage)
    if damage > 0 then return damage, damType end
    if antiSpam(defender:getId(), 20) then defender:getPosition():sendMagicEffect(4) end
    return 0, damType
end

function damageSystem_canDoDamage(defender, attacker)
    if defender:getCondition(INVISIBLE, 1) then return end
    if imp_ownerIsAttackingWithAoe(defender, attacker) then return end
    if attacker and attacker:isPlayer() then setSV(attacker, SV.lastHit, os.time()) end
    if defender:isPlayer() then
        if defender:isFakeDead() then return end
        if defender:getSV(SV.player_ignoreDamage) == 1 then return end
        if defender:getSV(SV.playerIsDead) == 1 then return end
        if isPvpOrigin(origin) then
            if not duel_isInDuel(defender) then return end
        end
        defender:setSV(SV.lastDmg, os.time())
    end
    return true
end

function damageSystem_taunted(creature, attacker, damage, damType, origin)
    local tauntCreatures = {"sea brawler", "green slime"}

    if isInArray(tauntCreatures, creature:getRealName()) then return end
    local friendList = creature:getFriends(2)
    
    for _, monsterID in pairs(friendList) do
        local monster = Creature(monsterID)

        if isInArray(tauntCreatures, monster:getRealName()) then
            doSendDistanceEffect(creature:getPosition(), monster:getPosition(), 7)
            dealDamage(attacker, monsterID, damType, damage, 1, origin)
            return true
        end
    end
end

function damageSystem_damageIncreaseMonsters(attacker, damage, damType, origin)
    if not attacker or not attacker:isMonster() then return 0 end
    local buffCreatures = {
        ["sea counceler"] = {distance = 3, damageBuffPercent = 10},
        ["sea king"] = {distance = 2, damageBuffPercent = 25},
        ["sea hero"] = {distance = 2, damageBuffPercent = 25},
    }
    local friendList = attacker:getFriends(3)
    local monsterPos = attacker:getPosition()
    local bonusDamage = 0

    for _, monsterID in pairs(friendList) do
        local monster = Creature(monsterID)
        local buffT = buffCreatures[monster:getRealName()]
        
        if buffT and getDistanceBetween(monster:getPosition(), monsterPos) <= buffT.distance then
            bonusDamage = bonusDamage + percentage(primaryDamage, buffT.damageBuffPercent)
        end
    end
    return bonusDamage
end

function damageSystem_pvpDamage(damage, origin)
    if not isPvpOrigin(origin) then return 0 end
    local damageReduction = percentage(damage, 80)
    return -damageReduction
end

function playerResistance(player, attacker, damage, damType)
    local typeS = getEleTypeByEnum(damType):lower()
    local res = player:getResistance(typeS)
    local sv = getDamTypeSV(damType)
    local specialRes = getSV(player, sv)
    if specialRes >= 0 then setSV(player, sv, specialRes + res) end
    
    local attackerRace = getRace(attacker)
    local raceRes = attackerRace and player:getResistance(attackerRace) or 0
    local totalRes = res + raceRes
    local negative = totalRes < 0
    if negative then totalRes = -totalRes end
    local resistedDamage = percentage(damage, totalRes)

    intrinsicLegs(player, damType)
    shimasuLegs(player, damage, res, damType)
    return negative and resistedDamage or -resistedDamage
end

function playerArmor(player, damType)
    if damType ~= PHYSICAL then return 0 end
    local totalArmor = player:getArmor()
    local absorbedDamage = 0

    if totalArmor < 2 then return 0 end
    return math.random(totalArmor/2, totalArmor)
end

function finalDamage(attacker, damage)
    if not Monster(attacker) then return damage end
    local monsterName = attacker:getRealName()
    local spellT = monsterSpells[monsterName]

    if spellT.finalDamage and spellT.finalDamage > damage then return spellT.finalDamage end
    return damage
end

takeNoDamage = {}
function veryFinalDamage(defender, damage)
    local defenderID = defender:getId()
    return takeNoDamage[defenderID] and 0 or damage
end

function monsterResistance(monster, damage, damType)
    local monsterName = monster:getName():lower()
    local resTable = elementalResistances[monsterName]
    if monsterName == "imp" then resTable = impResistance[monster:getId()] end
    if not resTable then return 0 end
    
    local damTypeS = getEleTypeByEnum(damType)
    local resistance = resTable[damTypeS]
    if not resistance then return 0 end

    local totalRes = resistance + getTempResByCid(monster, damType)
    local negative = totalRes < 0
    if negative then totalRes = -totalRes end
    
    local resistedDamage = percentage(damage, totalRes)
    return negative and resistedDamage or -resistedDamage
end

function knightSpellDefs(player, damage, damType)
    local primaryTypeString = getEleTypeByEnum(damType)
    local damTypeT = damageTypeConfig[primaryTypeString]

    if not damTypeT or not damTypeT.defSpellSV then return 0 end
    local sv = damTypeT.defSpellSV
    local resistance = getSV(player, sv)

    if resistance < 1 then return 0 end
    if os.time() > getSV(player, sv + 20000) then return 0 end
    if resistance > 100 then resistance = 100 end
    local playerPos = player:getPosition()
    local positions = getAreaAround(playerPos)
    local resistedAmount = percentage(damage, resistance)
    local spellT = spells_getSpellT("onyxdef") -- all use same formulas
    local _, maxHealAmount = spells_getFormulas(player, spellT)
    local healAmount = resistedAmount*2
    local resistedStorage = getSV(player, damTypeT.sv)

    if healAmount > maxHealAmount then healAmount = maxHealAmount end
    healAmount = healAmount + ghatitkArmor(player, healAmount)
    removeSV(player, sv)
    player:sendTextMessage(ORANGE, "you resisted "..resistedAmount.." damage")
    spells_healing(player, player, healAmount)
    doSendMagicEffect(playerPos, damTypeT.effect)
    for _, pos in pairs(positions) do playerPos:sendDistanceEffect(pos, damTypeT.fe) end
    if resistedStorage >= 0 then setSV(player, damTypeT.sv, resistedStorage + resistance) end
    return resistedAmount
end

function getDamTypeSV(type)
    local string = getEleTypeByEnum(type)
    local damTypeT = damageTypeConfig[string]
    if damTypeT then return damTypeT.sv end
end