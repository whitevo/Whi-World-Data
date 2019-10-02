local wandTypes = {ICE, FIRE, EARTH, DEATH, ENERGY}
weaponHitCooldowns = {}

function onUseWeapon(player, var)
    local target = player:getTarget()
    if not target then return true end
    if player:isFakeDead() then return true end
    if checkWeaponCooldown(player) then return true end
    if royale_attack(player, target) then return true end
    if player:isStunned() then return player:sendTextMessage(GREEN, "Can't shoot while stunned.") end
    if player:isBinded() then return player:sendTextMessage(GREEN, "Can't attack while binded.") end
    if player:isWeakened() then return player:sendTextMessage(GREEN, "You are too tired to raize your weapon for attack.") end
    
    local weapon = player:getSlotItem(SLOT_LEFT)
    local weaponT = getWeaponT(weapon)
    if not weaponT then return player:sendTextMessage(GREEN, "you are using unregistered item") end
    local playerPos = player:getPosition()
    local targetPos = target:getPosition()
    local distance = getDistanceBetween(playerPos, targetPos)
    if distance > weaponT.range then return player:sendTextMessage(WHITE, "Get closer to target to shoot") end
    local attackAmount = 1
    local damType = weaponT.damType
    local playerID = player:getId()
    local targetID = target:getId()
    
    if weapon:isWand() then
        local vocation = player:getVocation():getName():lower()

        if vocation == "knight" or vocation == "hunter" then
            local manaCost = 4
            if player:getMana() < manaCost then return player:sendTextMessage(GREEN, "you are out of mana") end
            player:addMana(-manaCost)
        end
    elseif weapon:isRangeWeapon() then
        if distance ~= 1 then
            if not canShoot(player, target) then return player:sendTextMessage(WHITE, "Face towards target to shoot them") end
    
            if weapon:isSpear() then
                if not throwSpear(player, target, weapon, weaponT) then return true end -- cant throw last spear
                
                playerPos:sendDistanceEffect(targetPos, weaponT.fe)
                if not power_throw(player) and missProjectile(player) then return text("*miss*", targetPos) end
            else
                local ammo = player:getSlotItem(SLOT_AMMO)
                local ammoT = getAmmoT(ammo)
                if not ammoT then return player:sendTextMessage(WHITE, "You are out of ammo") end

                damType = ammoT.damType
                if archery(player) then attackAmount = 2 end
                local fe = hunterPoison(player) and 6 or ammoT.fe

                for x=0, attackAmount-1 do
                    addEvent(doSendDistanceEffect, x*250, playerID, targetID, fe)
                    shootArrow(player, targetPos, ammo, ammoT)

                    if missProjectile(player) then
                        attackAmount = attackAmount - 1
                        text("*miss*", targetPos)
                    end
                end
            end
        end
    end
    
    if attackAmount == 0 then return end

    local min, max = getWeaponBaseDamage(player)
    local damage = math.random(min, max)
    if damage < 1 then return end
    
    addWeaponCooldown(player, weaponT)
    
    if weapon:isWand() then
        local effectAmount = math.ceil(min/55)
        if effectAmount > 5 then effectAmount = 5 end

        if testServer() then
            for x=1, effectAmount do addEvent(doSendDistanceEffect, (x-1)*100, playerID, targetID, 4) end
        else
            doSendDistanceEffect(playerPos, targetPos, 4)
        end
        doSendMagicEffect(targetPos, {29, 18})

        local effect = testServer() and 37 or nil
        for x, damType in ipairs(wandTypes) do
            local damage = math.random(min, max)
            if testServer() then
                addEvent(dealDamage, (x-1)*100, playerID, targetID, damType, damage/5, effect, O_player_weapons_mage)
            else
                dealDamage(playerID, targetID, damType, damage/5, effect, O_player_weapons_mage)
            end
            potions_knight_armorOnHit(player)
        end
        return true
    end
    
    if weapon:isRangeWeapon() then
        if weapon:isSpear() then
            damage = damage + huntingSpear_damage(target, weapon, damage)
        end

        damage = damage + sharpening_projectile(player, damage)
    else
        damage = damage + sharpening_weapon(player, damage)
    end

    local function attack(target, origin)
        if not PVP_allowed(player, target) then return end
        dealDamage(player, target, damType, damage, weaponT.me, origin)
        potions_silence(player, target)
        hunterPoison(player, target)
        mummyDollHit(player, target)
        vampireDollHit(player, target)
        arcaneBootsDamage(player, target)
        zvoidBootsDamage(player, target)
        return true
    end

    if weapon:isRangeWeapon() then
        if weapon:isSpear() then
            if distance == 1 then return attack(target, O_player_weapons_melee) end
    
            if not power_throw(player) then return attack(target, O_player_weapons_range) end
            local posT = getPath(playerPos, targetPos)

            for _, pos in pairs(posT) do
                local target = findCreature("creature", pos)

                if target then
                    if missProjectile(player) then
                        text("*miss*", pos)
                    else
                        attack(target, O_player_weapons_range)
                    end
                end
            end
        else
            if distance == 1 then
                damage = math.floor(damage/4)
                return attack(target, O_player_weapons_melee)
            end
    
            for x=1, attackAmount do
                fireQuiverDamage(player, target, damage)
                attack(target, O_player_weapons_range)
            end
        end
    else
        attack(target, O_player_weapons_melee)
    end
    return true
end

function canShoot(player, target)
    local targetPos = target:getPosition()
    local playerPos = player:getPosition()
    if getSV(player, SV.chokkan) == 1 then return true end
    local creatureXpos = targetPos.x
    local creatureYpos = targetPos.y
    local playerXpos = playerPos.x
    local playerYpos = playerPos.y
    local playerDir = getDirectionStrFromCreature(player)
        
    if playerDir == "N" then
        if playerYpos <= creatureYpos then return end
    elseif playerDir == "E" then
        if playerXpos >= creatureXpos then return end
    elseif playerDir == "S" then
        if playerYpos >= creatureYpos then return end
    elseif playerDir == "W" then
        if playerXpos <= creatureXpos then return end
    end
    return true
end

function getWeaponBaseDamage(player)
    local weapon = player:getSlotItem(SLOT_LEFT)
    local weaponT = getWeaponT(weapon)
    if not weaponT then return 0, 0 end
    local minDam = weaponT.minDam + (weapon:getText("minDam") or 0)
    local maxDam = weaponT.maxDam + (weapon:getText("maxDam") or 0)

    local function addDam(amount)
        if not amount or amount < 1 then return end
        minDam = minDam + amount
        maxDam = maxDam + amount
    end
    
    if weapon:isWand() then
        addDam(furbish_wand(player))
        addDam(energyGem(player))
    elseif weapon:isRangeWeapon() then
        if not weapon:isSpear() then
            local ammo = player:getSlotItem(SLOT_AMMO)
            local ammoT = getAmmoT(ammo)
            if not ammoT then return 0, 0 end
            
            minDam = minDam + ammoT.minDam + (ammo:getText("minDam") or 0)
            maxDam = maxDam + ammoT.maxDam + (ammo:getText("maxDam") or 0)
        end

        maxDam = maxDam + hunterPassive_distance(player)
        minDam = minDam + hunterPassive_weapon(player)
    else
        local vocation = player:getVocation():getName():lower()
        if vocation == "mage" or vocation == "druid" then
            maxDam = maxDam - 50
            if maxDam <= 0 then return 0, 0 end
            minDam = minDam - 50
            if minDam <= 0 then minDam = 0 end
        elseif vocation == "hunter" then
            minDam = math.floor(minDam/2)
            maxDam = math.floor(maxDam/2)
        end
    end

    if not weapon:isWand() then
        minDam = minDam + undercut(player, minDam)
        maxDam = maxDam + lucky_strike(player, maxDam)
        maxDam = potions_flash_weaponDamage(player, minDam, maxDam)
    end

    minDam = minDam + blessedHood(player, minDam)
    maxDam = maxDam + blessedHood(player, maxDam)

    if minDam > maxDam then maxDam = minDam end
    return minDam, maxDam
end

function getWeaponT(item)
    if not item then return end
    local t = itemTable["weapon"][item:getId()]
    if t then return t end
    if item:getId() == 2544 then return end
    print("["..item:getName().."] is not a weapon")
end

function getAmmoT(item) return item and itemTable["arrows"][item:getId()] end

function missProjectile(player) return chanceSuccess(player:getMissChance()) end

function projectiles_equipped(player)
    local ammo = player:getSlotItem(SLOT_AMMO)
    if ammo and ammo:isProjectile() then return true end

    local weapon = player:getSlotItem(SLOT_LEFT)
    if weapon and weapon:isProjectile() then return true end
end

function huntingSpear_damage(target, spear, damage)
    if spear:getId() ~= 3965 then return 0 end
    target = Creature(target)
    if not target then return 0 end
    if target:getSpeed() < target:getBaseSpeed() then return percentage(damage, 10) end
    return 0
end

function clean_weaponHitCooldowns()
    local tablesDeleted = 0

    for playerID, bool in pairs(weaponHitCooldowns) do
        if not Player(playerID) or not bool then
            tablesDeleted = tablesDeleted + 1
            weaponHitCooldowns[playerID] = nil
        end
    end
    if tablesDeleted > 0 then print("CLEANED "..tablesDeleted.." from weaponHitCooldowns") end
    return tablesDeleted
end

function checkWeaponCooldown(player) return weaponHitCooldowns[player:getId()] end

function addWeaponCooldown(player, weaponT)
    local playerID = player:getId()
    local weaponAS = weaponT.weaponSpeed
    weaponAS = weaponAS - potions_flash_attackSpeed(player, weaponAS)
    local extraAS = leatherSetAS(player)
    local cd = weaponAS-extraAS

    if cd <= 0 then cd = 100 end
    if cd > 0 then
        weaponHitCooldowns[playerID] = true
        addEvent(setTableVariable, cd, weaponHitCooldowns, playerID, nil)
    end
    return cd
end

function shootArrow(player, pos, ammo, t, extraBreakChance)
    local breakChance = t.breakchance
    if not breakChance then return true end
    
    extraBreakChance = extraBreakChance or 0
    breakChance = breakChance + extraBreakChance
    breakChance = breakChance + quiverBreakChance(player)
    breakChance = breakChance + snaipaHelmet_breakChance(player)
    if not chanceSuccess(breakChance) then createItem(ammo:getId(), pos) end
    return ammo:remove(1)
end

function throwSpear(player, target, spear, weaponT)
    local breakChance = weaponT.breakchance

    if not breakChance or breakChance == 0 then return true end
    if spear:getCount() == 1 then return false, player:sendTextMessage(GREEN, "can't throw last spear") end
    if not chanceSuccess(breakChance) then createItem(spear:getId(), target:getPosition()) end
    return spear:remove(1)
end

function quiverBreakChance(player, onlyCheck)
local reduceBreakChance = getSV(player, SV.quiverBreakChance)
    
    if onlyCheck then return reduceBreakChance end
    return reduceBreakChance > 0 and -reduceBreakChance or 0
end

function hunterPassive_distance(player) return player:isHunter() and player:getDistanceLevel() * 5 or 0 end
function hunterPassive_weapon(player) return player:isHunter() and player:getWeaponLevel() * 5 or 0 end