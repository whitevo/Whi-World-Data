function triggerDOT(creatureID, damage, damType, interval, effect, formula, origin, duration)
    if not Creature(creatureID) then return end
    if not duration then
        local formula = formula or "d/2"
        local f = formula:gsub("d", damage)
        damage = calculate(nil, f)
    else
        duration = duration - interval
        if duration < 1 then return end
    end
    if damage < 2 then return end

    local eventData = {triggerDOT, creatureID, damage, damType, interval, effect, formula, origin, duration}
    removeDOT(creatureID, damType)
    registerAddEvent(creatureID, damType, interval, eventData)
    doDamage(creatureID, damType, damage, effect, origin)
end

function damageOverTime(creature, damage, damType, interval, effect, formula, origin, duration)
    local origin = origin or O_environment
    local creatureID = creature:getId()
    local eventData = {triggerDOT, creatureID, damage, damType, interval, effect, formula, origin, duration}

    removeDOT(creature, damType)
    registerAddEvent(creatureID, damType, interval, eventData)
    doDamage(creatureID, damType, damage, effect, origin)
end

function removeDOT(creatureID, damType)
    local creature = Creature(creatureID)
    if not creature then return end
    
    local creatureID = creature:getId()
    if damType then return stopAddEvent(creatureID, damType) end

    local allDamTypes = {1,2,4,8,16,32,512,1024,2048}
    for _, damType in ipairs(allDamTypes) do stopAddEvent(creatureID, damType) end
end

function fieldDOT_fire(creature, item)
    local minDam = item:getText("minDam")
    if not minDam then return print("ERROR in fieldDOT_fire - no minDam"), Uprint(item:getPosition()) end
    local maxDam = item:getText("maxDam") or minDam
    damageOverTime(creature, math.random(minDam, maxDam), FIRE, 3000, 16)
end

function fieldDOT_energy(creature, item)
    local minDam = item:getText("minDam")
    if not minDam then return print("ERROR in fieldDOT_energy - no minDam"), Uprint(item:getPosition()) end
    local maxDam = item:getText("maxDam") or minDam
    damageOverTime(creature, math.random(minDam, maxDam), ENERGY, 1000, 12, "d/4*3-5")
end

function fieldDOT_earth(creature, item)
    local minDam = item:getText("minDam")
    if not minDam then return print("ERROR in fieldDOT_earth - no minDam"), Uprint(item:getPosition()) end
    local maxDam = item:getText("maxDam") or minDam
    damageOverTime(creature, math.random(minDam, maxDam), EARTH, 4000, 21, "d/6*5-1")
end

function fireDOT100(creature) return damageOverTime(creature, math.random(50, 100), FIRE, 3000, 16) end

function doDamage(creatureID, damType, damage, effectOnHit, origin)
    local target = Creature(creatureID)
    if not target or target:getCondition(INVISIBLE, SUB.INVISIBLE.invisible.invisible) then return end
    doTargetCombatHealth(0, creatureID, damType, damage, damage, effectOnHit, origin)
end

function dealDamage(attacker, target, damType, damage, effectOnHit, origin, maxRange, flyingEffect)
    if not attacker or type(attacker) == "number" and attacker == 0 then return doDamage(target, damType, damage, effectOnHit, origin) end
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
end

local damageMap = {}
local function noMoreDMG(cid, creature, origin)
    if cid > 0 and origin >= 100 then
        local cid2 = creature:getId()
        if damageMap[cid2] then return true end
        damageMap[cid2] = true
        addEvent(setTableVariable, 900, damageMap, cid2, nil)
    end
end

function dealDamagePos(attackerID, pos, damType, damage, effectOnHit, origin, spellEffect, effectOnMiss)
    local tile = Tile(pos)
    if not tile then return end
    local attacker = Creature(attackerID)
    local attackerID = attacker and attacker:getId() or 0
    local target = tile:getBottomCreature()

    if spellEffect then doSendMagicEffect(pos, spellEffect) end
    if not target then return false, doSendMagicEffect(pos, effectOnMiss) end
    local targetID =  target:getId()

    if targetID == attackerID then return end
    origin = origin or O_environment
    if origin == O_environment_player and not target:isPlayer() then return end
    if origin == O_environment_monster and not target:isMonster() then return end
    if origin == O_monster_spells and target:isMonster() then return end
    if origin == O_monster_procs_player and not target:isPlayer() then return end
    if origin == O_player_spells or origin == O_player_proc then
        if attackerID == 0 then
            if target:isPlayer() then return end
        else
            if attacker:isMonster() and target:isPlayer() then return end
            if attacker:isPlayer() and not PVP_allowed(attacker, target) then return end
        end
    end
    
    if attacker and attacker:isPlayer() then -- SkillTree stuff and other effects
        potions_spellCaster_heal(attacker)
    end
    
    if not noMoreDMG(attackerID, target, origin) then
        if attacker and attacker:isMonster() and target:isMonster() then attackerID = 0 end
        if not effectOnHit and testServer() then effectOnHit = 1 end
        doTargetCombatHealth(attackerID, targetID, damType, damage, damage, effectOnHit, convertOrigin(origin))
        return target
    end
end

function heal(cid, amount, effect)
    local creature = Creature(cid)
    if not creature then return end
    local maxHp = creature:getMaxHealth()
    local currentHP = creature:getHealth()
    local amount = amount or 0
    
    if type(amount) ~= "number" then --temp
        print("amount is broken in heal()")
        Uprint(creature:getPosition(), "creaturePos")
        amount = 0
    end

    if creature:isPlayer() then
        amount = amount + earthGem(creature, amount)
        amount = amount + power_of_love(creature, amount)
        speedzyLegs(creature)
    end
    
    if effect then doSendMagicEffect(creature:getPosition(), effect) end
    if maxHp == currentHP then return end
    if demonSkeleton_healStealRune(creature, amount) then amount = 0 end
    if amount < 1 then return end
    return creature:addHealth(amount)
end

function healPosition(position, amount, effect)
    local tile = Tile(position)
    if not tile then return end
    
    local creature = tile:getBottomCreature()
    if creature then return heal(creature, amount, effect) end

    return effect and doSendMagicEffect(position, effect)
end

function criticalHeal(player, amount, onlyCheck)
    local critChance = player:getCriticalHeal()
    if onlyCheck then return critChance end
    return chanceSuccess(critChance) and amount or 0
end

function criticalHit(player, damage, origin, targetPos)
    if not Player(player) then return 0 end
    if not isWeaponOrigin(origin) or origin == O_player_weapons_mage then return 0 end
    if not chanceSuccess(player:getCriticalHit()) then return 0 end
    lucky_strike_crit(player)
    if targetPos then text("*crit*", targetPos) end
    return damage
end

function critBlock(player, def) return chanceSuccess(player:getCriticalBlock()) and def or 0 end

local function groundControlMagicEffect(position, duration, effect)
    local function showEffect() return findItem(11320, position) and doSendMagicEffect(position, effect) end
    for delay=0, duration, 900 do addEvent(showEffect, delay) end
end

function root(cid, duration)
    local target = Creature(cid)
    if not target then return end
    local position = target:getPosition()
    duration = duration or 1000
    
    if target:isMonster() then
        if target:getName():lower() == "mummy" then return end
        bindCondition(target, "monsterSlow", duration, {speed = -target:getSpeed()})
    else
        duration = duration - percentage(duration, target:getSlowRes())
        if duration < 350 then return end
        createItem(11320, position, 1, AID.other.root)
        target:sendTextMessage(ORANGE, "You are rooted for "..getTimeText(duration/1000))
        addEvent(removeRoot, duration, position)
    end
    groundControlMagicEffect(position, duration, 46)
end

function bind(cid, duration)
    local target = Creature(cid)
    if not target then return end
    local position = target:getPosition()
    duration = duration or 1000
    
    if target:isMonster() then
        bindCondition(target, "monsterSlow", duration, {speed = -target:getSpeed()})
    else
        if duration < 350 then return end
        createItem(11320, position, 1, AID.other.bind)
        target:sendTextMessage(ORANGE, "You are binded for "..getTimeText(duration/1000))
        addEvent(removeBind, duration, position)
    end
    groundControlMagicEffect(position, duration, 4)
end

function stun(cid, duration, stunL)
    local target = Creature(cid)
    if not target then return end
    local position = target:getPosition()
    duration = duration or 1000

    if target:isMonster() then
        silence(target, duration)
        bindCondition(target, "monsterSlow", duration, {speed = -target:getSpeed()}) 
    else
        local stunRes = target:getStunRes()
        local playerStunL = math.ceil(stunRes/100)
        local stunL = stunL or 1
        
        if playerStunL > stunL then return end
        if playerStunL == stunL then duration = duration - percentage(duration, stunRes) end
        if duration < 350 then return end
        createItem(11320, position, 1, AID.other.stun)
        target:sendTextMessage(ORANGE, "You are stunned for "..getTimeText(duration/1000))
        addEvent(removeStun, duration, position)
    end
    groundControlMagicEffect(position, duration, 32)
end

function silence(creatureID, duration)
    local creature = Creature(creatureID)
    local cid = creature:getId()
    local duration = duration or 1000

    if creature:isPlayer() then
        local silenceRes = creature:getSilenceRes()
        duration = duration - percentage(duration, silenceRes)
        setSV(creature, SV.silenced, 1)
    elseif creature:isMonster() then
        local spellT = AI_getSpellT(creature) or {}
        
        for spellName, cdT in pairs(spellT) do
            if spellName ~= "finalDamage" then spellT[spellName][cid].silenced = true end
        end
    end
    addEvent(removeSilence, duration, cid)
end

function stunPos(position, duration, stunLevel) return stun(findCreature("creature", position), duration, stunLevel) end
function rootPos(position, duration) return root(findCreature("creature", position), duration) end
function bindPos(position, duration) return bind(findCreature("creature", position), duration) end
function removeStun(position) return removeItemFromPos(11320, position, 1, AID.other.stun) end
function removeRoot(position) return removeItemFromPos(11320, position, 1, AID.other.root) end
function removeBind(position) return removeItemFromPos(11320, position, 1, AID.other.bind) end

function removeSilence(creatureID)
    local creature = Creature(creatureID)
    if not creature then return end
    local cid = creature:getId()
    if creature:isPlayer() then return removeSV(cid, SV.silenced) end
    local spellT = AI_getSpellT(creature) or {}

    for spellName, cdT in pairs(spellT) do
        if spellName ~= "finalDamage" then spellT[spellName][cid].silenced = false end
    end
end

function PVP_allowed(attacker, target)
    if target and attacker and target:isPlayer() and attacker:isPlayer() then
        if duel_isInDuel(attacker) and duel_isInDuel(target) then return true end
        if attacker:getSV(SV.PVPEnabled) == -1 then return end
        if attacker:getSV(SV.PVPEnabled) == -1 then return end
    end
    return true
end

function isPvpOrigin(origin)
    if origin == O_player_spells then return true end
    if origin == O_player_proc then return true end
    if origin == O_player_weapons then return true end
    if origin == O_player_weapons_mage then return true end
    if origin == O_player_weapons_melee then return true end
    if origin == O_player_weapons_range then return true end
end

if not conditions then
    conditions = {} -- {conditionKey = {condition = Condition(), param = param}}
    allRemoveableConditions = {}
end

function createConditions()
    local conditionIndex = 0

    for condition, condT in pairs(SUB) do
        for param, t in pairs(condT) do
            for key, ID in pairs(t) do
                if not conditions[key] then conditions[key] = {} end
                conditions[key].condition = Condition(_G[condition], ID)
                conditions[key].param = param
                
                if ID >= 100 then
                    conditionIndex = conditionIndex+1
                    allRemoveableConditions[conditionIndex] = {key}
                end
            end
        end
    end
end

-- ID == STR(the last key in SUB table) t == {param = INT}
function bindCondition(cid, ID, duration, t)
    local creature = Creature(cid)
    if not creature then return end
    if creature:getName():lower() == "shadow" and ID ~= "tempSpeed" then return end
    local conditionT = conditions[ID]
    if not conditionT then return print("ERROR - wrong id in bindCondition: "..ID) end
    local param = conditionT.param
    local condition = conditionT.condition

    if t then
        if creature:isPlayer() and param == "speed" and creature:getSpeed() <= 50 then return end
        creature:removeCondition(condition:getType(), condition:getId())
        
        if param == "attributes" then
            local maxMana = t.maxMP or 0
            local maxHealth = t.maxHP or 0
            condition:setParameter(MAXMANAPOINTS, maxMana)
            condition:setParameter(MAXHEALTHPOINTS, maxHealth)
        elseif param == "speed" then
            if creature:isPlayer() then
                local limit = 50
                local creatureSpeed = creature:getSpeed()
                local finalSpeed = creatureSpeed + t.speed
                
                if finalSpeed < limit then t.speed = t.speed + (limit - finalSpeed) end
            end
            condition:setParameter(SPEED, t.speed)
        elseif param == "regen" then
            local gainHP = t.gainHP or 0
            local gainMP = t.gainMP or 0
            local HPinterval = t.HPinterval or 1000
            local MPinterval = t.MPinterval or 1000
            
            condition:setParameter(HEALTHGAIN, gainHP)
            condition:setParameter(HEALTHTICKS, HPinterval)
            condition:setParameter(MANAGAIN, gainMP)
            condition:setParameter(MANATICKS, MPinterval)
        elseif param == "skills" then
            local sL = t.sL or 0
            local wL = t.wL or 0
            local dL = t.dL or 0
            local sLf = t.sLf or 0
            local mL = t.mL or 0
            
            condition:setParameter(P_SKILL_SHIELD, sL)
            condition:setParameter(P_SKILL_CLUB, wL)
            condition:setParameter(P_SKILL_SWORD, wL)
            condition:setParameter(P_SKILL_AXE, wL)
            condition:setParameter(P_SKILL_DISTANCE, dL)
            condition:setParameter(P_SKILL_FIST, sLf)
            condition:setParameter(MAGIC_LEVEL, mL)
        elseif param == "dot" then -- origin is 1, so can't do much about this shit.
            local interval = t.interval or 1000
            local dam = t.dam or 0
            
            condition:setParameter(DOT, dam)
            condition:setParameter(INTERVAL, interval)
        elseif param ~= "invisible" then
            return print("condition: '"..tostring(param).."' doesn't exist in bindCondition()")
        end
    end
    
    condition:setTicks(duration)
    creature:addCondition(condition)
    return true
end

-- conditionT == {{ID, duration, attributeT}}
function bindConditionTable(player, conditionT)
    if not conditionT then return end
    local cid = player:getId()
        
    for _, t in pairs(conditionT) do
        local conditionKey = t[1]
        local duration = t[2]
        local attributeT = t[3] -- {stat = value}
        bindCondition(cid, conditionKey, duration, attributeT)
    end
end
-- contidion table: {{ID}} Ex: {{"head"}, {"monsterHaste"}},
function removeCondition(creatureID, conditionT)
    local creature = Creature(creatureID)
        
    if not creature or not conditionT then return end
    if type(conditionT) ~= "table" then conditionT = {{{conditionT}}} end
    if type(conditionT[1]) ~= "table" then conditionT = {{conditionT}} end
    if type(conditionT[1][1]) ~= "table" then conditionT = {conditionT} end
    
    for _, t in pairs(conditionT) do
        for _, t2 in pairs(t) do
            local conditionKey = t2[1]
            if type(conditionKey) ~= "string" then
                print("ERROR - condition key is not string in removeCondition()")
                Uprint(conditionT)
            end
            local conditT = conditions[conditionKey]
            
            if conditT then
                local condition = conditT.condition
                local ID = conditT.condition:getId()
                local conditionType = conditT.condition:getType()
                
                if creature:getCondition(conditionType, ID) then
                    if conditT.param == "speed" then
                        addEvent(function(cid)
                            if Creature(cid) then Creature(cid):removeCondition(conditionType, ID) end
                        end, 0, creature:getId())
                    else
                        creature:removeCondition(conditionType, ID)
                    end
                end
            end
        end
    end
end

function getPlayerTFromDamageT(damageT)
    local playerT = {}
    
    for creatureID, t in pairs(damageT) do
        local player = Player(creatureID)
        if player then table.insert(playerT, player) end
    end
    return playerT
end

function getHighestDamageDealerFromDamageT(damageT, object)
    local highestDam = 0
    local mostDamPlayer
    local object = object or "player"

    local function update(creatureID, damage)
        if damage <= highestDam then return end
        local creature = Creature(creatureID)
        if not creature then return end
        if not targetIsCorrect(creature, object) then return end
        highestDam = damage
        mostDamPlayer = creature
    end

    for creatureID, t in pairs(damageT) do update(creatureID, t.total) end
    return mostDamPlayer
end

function getDamTypeStr(object)
    if type(object) == "string" then return object:upper() end
    if type(object) == "number" then return getEleTypeByEnum(object) end
end

function getEleTypeByEnum(enum)
    if enum == 1    then return "PHYSICAL" end
    if enum == 2    then return "ENERGY" end
    if enum == 4    then return "EARTH" end
    if enum == 8    then return "FIRE" end
    if enum == 16   then return "LD" end
    if enum == 32   then return "LD" end
    if enum == 512  then return "ICE" end
    if enum == 1024 then return "HOLY" end
    if enum == 2048 then return "DEATH" end
    print("missing ["..enum.."] IN getEleTypeByEnum()")
    return 1
end

function getEffectByType(eleType)
    if type(eleType) == "string" then eleType = getEleTypeEnum(eleType) end
    if eleType == FIRE      then return 16 end
    if eleType == ICE       then return 12 end
    if eleType == DEATH     then return 18 end
    if eleType == ENERGY    then return 12 end
    if eleType == EARTH     then return 21 end
    if eleType == LD        then return 5 end
    if eleType == PHYSICAL  then return 0 end
    print("missing ["..eleType.."] IN getEffectByType()")
    return 3
end

function getEleTypeEnum(eleType)
    eleType = eleType:upper()
    if eleType == "PHYSICAL" then return 1 end
    if eleType == "ENERGY"  then return 2 end
    if eleType == "EARTH"   then return 4 end
    if eleType == "FIRE"    then return 8 end
    if eleType == "LD"      then return 32 end
    if eleType == "ICE"     then return 512 end
    if eleType == "HOLY"    then return 1024 end
    if eleType == "DEATH"   then return 2048 end
    if eleType == "UNDEAD"  then return 0 end
    if eleType == "STUN"    then return 0 end
    if eleType == "SLOW"    then return 0 end
    if eleType == "BEAST"   then return 0 end
    if eleType == "WATER"   then return 0 end
    if eleType == "PVP"     then return 0 end
    if eleType == "DRAGON"  then return 0 end
    if eleType == "SILENCE" then return 0 end
    if eleType == "HUMAN"   then return 0 end
    if eleType == "ELEMENT"   then return 0 end
    print("missing ["..eleType.."] IN getEleTypeEnum()")
    return 1
end

function convertOrigin(origin)
    if origin >= 100 then origin = O_player_spells end
    if origin == O_monster_procs_player then origin = O_monster_procs end
    if origin == O_environment_player then origin = O_environment end
    if origin == O_environment_monster then origin = O_environment end
    return origin
end

function isWeaponOrigin(origin)
    if not origin then return end
    if origin == O_player_weapons then return true end
    if origin == O_player_weapons_range then return true end
    if origin == O_player_weapons_melee then return true end
    if origin == O_player_weapons_mage then return true end
end

function unFocus(creatureID) -- enemies who target monster loose the focus | everyone who target this player loose focus
    local creature = Creature(creatureID)

    if not creature then return end
    creatureID = creature:getId()

    if creature:isPlayer() then
        print("unFocusing will be more complicated. prolly need to check entire screen for creatures.. Maybe actaully disableeing PVP for a sec helps :D?")
        print("second option is to browse trough all online players and check are they in range! (i think its best) due to there is 14x12 squares, but maybe only 10+ ppl online")
    else
        local enemies = creature:getEnemies()
        
        for _, enemyID in pairs(enemies) do
            local enemy = Creature(enemyID)
            local target = enemy:getTarget()
            
            if target and target:getId() == creatureID then target:sendCancelTarget() end
        end
    end
end

function Creature.sendCancelTarget(creature)
    if creature:isMonster() then return creature:removeTarget(creature:getTarget()) end
    local msg = NetworkMessage()

    msg:addByte(0xA3)
    msg:addU32(0x00)
    msg:sendToPlayer(creature)
    msg:delete()
end

function sortCreatureListByDistance(startPos, creatureList, distance)
    local newList = {}
    clean_cidList(creatureList)
    if not distance then return creatureList end
    
    for _, creatureID in pairs(creatureList) do
        if getDistanceBetween(startPos, Creature(creatureID):getPosition()) <= distance then table.insert(newList, creatureID) end
    end
    return newList
end

function getDamageType(object)
    if not object then return "physical" end
    
    if object:isPlayer() then
        local weapon = object:getSlotItem(SLOT_LEFT)
        if not weapon then return "physical" end
        object = weapon
    end
    
    local weaponT = getWeaponT(object)
    return weaponT and weaponT.damType and getDamTypeStr(weaponT.damType) or "physical"
end

function addTempResistance(playerID, amount, damType, msDuration)
    local player = Player(playerID)
    if not player then return end
    local tempResSVT = {
        physical = SV.tempPhysicalResistance,
        fire = SV.tempFireResistance,
        ice = SV.tempIceResistance,
        energy = SV.tempEnergyResistance,
        earth = SV.tempEarthResistance,
        death = SV.tempDeathResistance,
    }
    local sv = tempResSVT[damType]
    if not sv then return print("ERROR - missing tempResSV in addTempResistance() for damType: "..tostring(damType)) end

    addSV(player, sv, amount)
    if msDuration and msDuration > 0 then addEvent(addTempResistance, msDuration, player:getId(), -amount, damType) end
end

function addExtraEleDamage(playerID, amount, damType, msDuration)
    local player = Player(playerID)
    if not player then return end
    local tempDamSVT = {
        fire = SV.extraFireDamage,
        ice = SV.extraIceDamage,
        energy = SV.extraEnergyDamage,
        earth = SV.extraEarthDamage,
        death = SV.extraDeathDamage,
    }
    local sv = tempDamSVT[damType]
    if not sv then return print("ERROR - missing tempDamSV in addExtraEleDamage() for damType: "..tostring(damType)) end

    addSV(player, sv, amount)
    if msDuration and msDuration > 0 then addEvent(addExtraEleDamage, msDuration, player:getId(), -amount, damType) end
end

--[[    onHitDebuff_damageT
    [INT] = {               debuffID
        startTime = INT     os.time()
        duration = INT      duration in seconds
        damage = INT         
        creatureID = INT    
        reqTypeT = {ENUM}   damage types which will proc damage modifier
        damType = ENUM      which type of damage it will deal
        name = INT/STR      if should be unique
        effect = ENUM       
        origin = INT        
    }
]]
onHitDebuff_damageT = {}
function onHitDebuff_registerDamage(creature, reqTypeT, damType, damage, duration, effect, origin, name)
    local creature = Creature(creature)
    if not creature then return end
    local creatureID = creature:getId()

    local function getDebuffID(name)
        if not name then
            local debuffID = 1
            while onHitDebuff_damageT[debuffID] do debuffID = debuffID + 1 end
            return debuffID
        end

        for debuffID, debuffT in pairs(onHitDebuff_damageT) do
            if debuffT.name and creatureID == debuffT.creatureID and debuffT.name == name then return debuffID end
        end
        return getDebuffID()
    end

    local debuffID = getDebuffID(name)
    if type(reqTypeT) ~= "table" then reqTypeT = {reqTypeT} end
    onHitDebuff_damageT[debuffID] = {startTime = os.time(), duration = duration, damage = damage,
        creatureID = creatureID, reqTypeT = reqTypeT, damType = damType, name = name, effect = effect, origin = origin}
    return debuffID
end

function onHitDebuff_damage(creature, damage, damType, origin)
    if origin == O_player_proc then return end
    if origin == O_monster_procs then return end
    local creatureID = creature:getId()
    local removeBuffs = {}
    local time = os.time()

    local function dealDamage(t, debuffID)
        if t.duration and t.duration > 0 and time > t.duration + t.startTime then return table.insert(removeBuffs, debuffID) end
        if t.creatureID ~= creatureID then return end
        if not isInArray(t.reqTypeT, damType) then return end
        doDamage(creatureID, t.damType, t.damage, t.effect, t.origin)
    end

    for debuffID, debuffT in pairs(onHitDebuff_damageT) do dealDamage(debuffT, debuffID) end
    for _, debuffID in ipairs(removeBuffs) do onHitDebuff_damageT[debuffID] = nil end
end

--[[    onHitDebuff_damNerfT
    [INT] = {               debuffID
        startTime = INT     os.time()
        duration = INT      duration in seconds
        amount = INT        percent amount of reduced damage
        creatureID = INT    
        damTypeT = {ENUM}   which types of damages it will nerf
        name = INT/STR      if should be unique
    }
]]
onHitDebuff_damNerfT = {}
function onHitDebuff_registerDamageNerfPercent(creature, damTypeT, amount, duration, name)
    local creatureID = creature:getId()

    local function getDebuffID(name)
        if not name then
            local debuffID = 1
            while onHitDebuff_damNerfT[debuffID] do debuffID = debuffID + 1 end
            return debuffID
        end

        for debuffID, debuffT in pairs(onHitDebuff_damNerfT) do
            if debuffT.name and creatureID == debuffT.creatureID and debuffT.name == name then return debuffID end
        end
        return getDebuffID()
    end

    local debuffID = getDebuffID(name)
    if type(damTypeT) ~= "table" then damTypeT = {damTypeT} end
    onHitDebuff_damNerfT[debuffID] = {startTime = os.time(), duration = duration, amount = amount, creatureID = creatureID, damTypeT = damTypeT, name = name}
    return debuffID
end

function onHitDebuff_damageReduction(creature, damage, damType)
    if not creature then return 0 end
    local creatureID = creature:getId()
    local removeBuffs = {}
    local time = os.time()
    local reduceDamageAmount = 0

    local function reduceDamage(t, debuffID)
        if t.duration and t.duration > 0 and time > t.duration + t.startTime then return table.insert(removeBuffs, debuffID) end
        if t.creatureID ~= creatureID then return end
        if not isInArray(t.damTypeT, damType) then return end
        reduceDamageAmount = reduceDamageAmount + percentage(damage, t.amount)
    end

    for debuffID, debuffT in pairs(onHitDebuff_damNerfT) do reduceDamage(debuffT, debuffID) end
    for _, debuffID in ipairs(removeBuffs) do onHitDebuff_damNerfT[debuffID] = nil end
    return reduceDamageAmount
end