if "" then return end

function takeDamage(creatureID, damage)
    local creature = Creature(creature)
    if not creature then return end
    local effectOnHit = testServer() and 1
    doTargetCombatHealth(0, creatureID, LD, damage, damage, effectOnHit)
end

function dealDamage(attacker, target, damType, damage, effectOnHit, origin, maxRange, flyingEffect)
    if not attacker or type(attacker) == "number" and attacker == 0 then
        damage = damageSystem_onHealthChange(target, attacker, damage, damType, origin)
        
        return takeDamage(creatureID, damage)
    end

--[[
    attacker = Creature(attacker)
    target = Creature(target)
    if not attacker or not target then return end
    local attackerPos = attacker:getPosition()
    local targetPos = target:getPosition()
    local range = maxRange or 10

    if getDistanceBetween(attackerPos, targetPos) > range then return end
    local attackerID = attacker:getId()
    local targetID = target:getId()

    origin = origin or O_monster_spells
    if origin == O_monster_spells and attacker:isPlayer() then origin = O_player_spells end

    if target:isMonster() and attacker:isMonster() then attackerID = 0 end
    
    if range > 2 then
        local pathOpen = getPath(attackerPos, targetPos, {"blockThrow"}) -- maybe do onlyCheck
        
        if pathOpen then
            if flyingEffect then attackerPos:sendDistanceEffect(targetPos, flyingEffect) end
            doTargetCombatHealth(attackerID, targetID, damType, damage, damage, effectOnHit, origin)
        end
    else
        if flyingEffect then attackerPos:sendDistanceEffect(targetPos, flyingEffect) end
        doTargetCombatHealth(attackerID, targetID, damType, damage, damage, effectOnHit, origin)
    end
    return true
    ]]
end

function damageSystem_onHealthChange(creature, attacker, damage, damType, origin)
    if creature:isPlayer() then return damageSystem_player(creature, attacker, damage, damType, origin) end
    return damageSystem_monster(creature, attacker, damage, damType, origin)
end

function damageSystem_player(defender, attacker, damage, damType, origin)
    if origin == O_royale then return royale_onHealthChange(defender, damage, damType) end
    damage = damage > 0 and damage or -damage
    if not damageSystem_canDoDamage(defender, attacker) then return 0 end
    
    -- attacker must be player:
    damage = damage + criticalHit(attacker, damage, origin, defender:getPosition())
    damage = damage - elemental_strikeDamage(attacker, defender, damage, damType) -- converts % physical damage to elemental damage

    potions_knight_damage(attacker, defender, damType, origin)      -- deals fire damage
    potions_knight_armorOnHit(attacker, origin)                     -- removes armor
    
    damage = damage + green_powderDamage(attacker, damage, damType) -- increases EARTH damage
    damage = damage + ghatitkShield(attacker, damage, damType)      -- increases elemental damage
    --
    bianhuren(defender, attacker, damage, damType)                  -- reflects % physical damage back to attacker

    damage = damage - chamakLegs(defender, attacker, damage)        -- reduces % damage of taunted creatures
    damage = damage - stoneLegs(defender, damage)                   -- reduces % damage when armorup active
    damage = damage - demonicRobe(defender, damage)                 -- reduces % damage when imp is below 50% hp
    damage = damage - druidBuffSpell(defender, damage, damType)     -- reduces % damage
    damage = damage + playerResistance(defender, attacker, damage, damType)
    damage = damage - knightSpellDefs(defender, damage, damType)    -- reduces % damage if def spell is active
    damage = damage - playerArmor(defender, damType)                -- reduces physical damage by armor
    damage = damage - defender:getDefence()                         -- reduces damage by defence
    damage = damage - barrierDamage(defender, damage, damType)      -- reduces damage by barrier
    if damage < 1 then return damageSystem_noDamage(defender, attacker, damage, damType) end
    -- POOLELI
    damage = damage + kakkiBoots(defender, damage)
    damage = damage + demon_master(defender, damage)
    damage = damage + damageSystem_pvpDamage(damage, origin)
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

function damageSystem_canDoDamage(defender, attacker)
    if defender:getCondition(INVISIBLE, SUB.INVISIBLE.invisible.invisible) then return end
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