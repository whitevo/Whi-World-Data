--[[ Spell Config Guide
spellSystem = {
    ["spellName"] = {
        spellSV = INT,                  storage value for spell, 1 == spell learned
        cooldownSV = INT                storage value to keep track of spell cooldown, os.mtime() when spell was casted
        spellWord = STR                 what player has to say in order to cast spell
        
        cooldown = INT or 0             spell cooldown in millseconds
        level = INT or 1                Minimum level to be able to cast the spell
        mL = INT or 0                   Minimum magic level to be able to cast the spell
        manaCost = INT/STR or 0         Amount of mana that the spell costs (INT for amount of mana, STRING for % of mana) 
        vocation = {STR} or "all"       lower case name of the vocation who can use spell
        targetRequired = BOOL or false  if player has to have target in order to cast the spell
        targetRange = INT or 7          used with targetRequired, distance has to be less or equal with targetRange
        canShootTroughWalls = BOOL or false      if target is required then checks if there is any solid big obstacles in the way

        block = BOOL or false           when spell activated player takes no damage
        blockDuration = INT or 5000     how many milliseconds player does not take damage
        parry = BOOL or false           when spell activated any incoming damage is sent back to source
        parryTime = INT or 1500         how many milliseconds dmg is sent back
        
        areaConfig = {
            area = areaT                    check areaT guide
            repeatTimes = INT or 1          how many times this area level is executed
            repeatInterval = INT or 1000    how many milliseconds before the repeat starts
            sequenceInterval = INT or 0     supportT.waitTime = (sequenceID - 1) * sequenceInterval
            startFromTarget = BOOL or false.Area starts from target position (only works with targetRequired)
        },

        singleTarget = {                effects done to selected target (only works with targetRequired)
            push = INT or 0             pushes target INT amount of squares or until hits solid object

            !! includes all the same parameters which can be used in supportT !! (expect waitTime and distanceWaitTime)
        },
        
        supportT = {
            [INT] = {                           sequenceID (area sequence number)
                minDam = STR/INT                if damage is done to the position, INT for flat value
                maxDam = STR/INT or minDam      L = player level
                                                mL = magic level
                                                sL = shielding level
                                                dL = distance level
                                                wL = sword level
                                                aL = axe level
                                                cL = club level
                                STR EXAMPLE:    "L*10 + mL*10 + 50 / sL*2*dL"

                waitTime = INT or 0             how many milliseconds later this position is activated
                damType = ENUM or PHYSICAL      what kind of elemental damage it does
                spellEffect = {ENUM}            animation effect on the position
                spellEffectInterval = INT or 0  interval milliseconds between each spellEffect (if multible used)
                hitEffect = {ENUM} or 1         animation effect when target was hit
                missEffect = {ENUM}             animation effect when position doesn't have a target
                missEffectInterval = INT or 0   interval milliseconds between each missEffect (if multible used)
                        
                stun = BOOL or false            target can't move
                stunTime = INT or 5000          how many milliseconds stun lasts
                freeze = BOOL or false          player can't heal (I can not disable attacking unless a custom attackSystem, which require huge reworks)
                freezeTime = INT or 3000        how many milliseconds freeze lasts
                
                distanceEffect = ENUM           flying animation effect FROM player position
                distanceWaitTime = INT or 0     how many milliseconds later animation effect is triggered
            },
        }

        AUTOMATIC
        spellName = "spellName"         table key
    }
}
]]

--[[ areaT guide
    0 is area starting position, but does not execute any effects in it.
    if 0 is not used 1 is starting position, it does execute effect in it.

    the numbers represent the sequence in which order position effects trigger
    area = {
        {1,2,3},    
        {0,1,2},
    }
    
    to have multible effects on same position, put them in the table
    (I suggest to think about spacing them)
    area = {
        {{1,4}, {2,5},   3  },    
        {{0,3}, {1,4}, {2,5}},
    }
]]

spell2sT = {
    minDam = 70,
    maxDam = 140,
    damType = FIRE,
    missEffect = 7,
    hitEffect = 16,
}
star_0_5x5 = {
    {n,n,2,n,n},
    {n,2,1,2,n},
    {2,1,0,1,2},
    {n,2,1,2,n},
    {n,n,2,n,n},
}

whiSpells = {
    ["spell 1"] = {
        spellSV = 2500,
        cooldownSV = 2501,
        spellWord = "!s1",

        cooldown = 1550,
        --level = 20,
        manaCost = 4,
        --manaCost = "4",
        vocation = "druid",

        areaConfig = {
            area = {
                {4,4,4},
                {3,2,3},
                {2,1,2},
                {1,0,1},
            },
           -- repeatTimes = 2,
           -- repeatInterval = 2000,
        },

        supportT = {
            [1] = {minDam = 50,  maxDam = 100, damType = FIRE, missEffect = 7,  hitEffect = 16},
            [2] = {minDam = 100, maxDam = 200, damType = ICE,  missEffect = 42, hitEffect = 43, waitTime = 300},
            [3] = {
                minDam = 70,
                maxDam = 140,
                damType = FIRE,
                missEffect = 7,
                hitEffect = 16,
                waitTime = 500,
            },
            [4] = {
                minDam = 70,
                maxDam = 140,
                damType = FIRE,
                missEffect = 7,
                hitEffect = 16,
                distanceEffect = 31,
                waitTime = 750,
                stun = true,
                stunTime = 1200,
            },
        }
    },
    ["spell 2"] = {
        spellSV = 2500,
        cooldownSV = 2501,
        spellWord = "!s2",
        
        areaConfig = {
            area = star_0_5x5,
            repeatTimes = 4,
            repeatInterval = 800,
            sequenceInterval = 350,
        },
        supportT = {spell2sT, spell2sT}
    },

    ["spell 3"] = {
        spellSV = 2500,
        cooldownSV = 2501,
        spellWord = "!s3",
        targetRequired = true,
        singleTarget = {push = 2}
    },
}

function spellSystem_startUp()
    local configKeys = {"spellSV", "cooldownSV", "spellWord", "manaCost", "cooldown", "targetRequired", "targetRange",
    "level", "mL", "vocation", "bagItems", "supportT", "areaConfig", "block", "blockDuration", "parry", "parryTime", "singleTarget"}
    local areaKeys = {"area", "repeatTimes", "repeatInterval", "sequenceInterval", "startFromTarget"}
    local supportKeys = {"waitTime", "minDam", "maxDam", "damType", "spellEffect", "spellEffectInterval", "hitEffect",
    "missEffect", "missEffectInterval", "stun", "stunTime", "freeze", "freezeTime", "distanceEffect", "distanceWaitTime"}
    local singleTargetKeys = {"push", "minDam", "maxDam", "damType", "spellEffect", "spellEffectInterval", "hitEffect",
    "missEffect", "missEffectInterval", "stun", "stunTime", "freeze", "freezeTime", "distanceEffect", "distanceWaitTime"}
    local errorMsg = "whiSpells"
    
    local function missingError(missingKey, errorMsg) print("ERROR - missing value for "..errorMsg..missingKey) end

    for spellName, spellT in pairs(whiSpells) do
        local errorMsg = errorMsg.."["..spellName.."]."

        for key, v in pairs(spellT) do
            if not isInArray(configKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
        end

        if not spellT.cooldownSV then missingError("cooldownSV", errorMsg) end
        if not spellT.spellSV then missingError("spellSV", errorMsg) end
        if not spellT.spellWord then missingError("word", errorMsg) end
        if not spellT.level then spellT.level = 1 end
        if not spellT.mL then spellT.mL = 0 end
        if not spellT.cooldown then spellT.cooldown = 0 end
        if not spellT.manaCost then spellT.manaCost = 0 end
        if not spellT.blockDuration then spellT.blockDuration = 5000 end
        if not spellT.parryTime then spellT.parryTime = 1500 end
        if spellT.targetRequired and not spellT.targetRange then spellT.targetRange = 7 end
        if not spellT.vocation then spellT.vocation = "all" end
        spellT.spellName = spellName

        local targetConf = spellT.singleTarget
        if targetConf then
            local errorMsg = errorMsg.."singleTarget."

            if not spellT.targetRequired then print("ERROR - Target is required to use singleTarget in "..errorMsg) end

            for key, v in pairs(targetConf) do
                if not isInArray(singleTargetKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end

            if targetConf.minDam then
                if not targetConf.maxDam then targetConf.maxDam = targetConf.minDam end
                if not targetConf.damType then targetConf.damType = PHYSICAL end
                if not targetConf.hitEffect then targetConf.hitEffect = 1 end
                if not targetConf.missEffectInterval then targetConf.missEffectInterval = 0 end
            end
            
            if not targetConf.spellEffectInterval then targetConf.spellEffectInterval = 0 end
            if not targetConf.distanceWaitTime then targetConf.distanceWaitTime = 0 end
            if not targetConf.freezeTime then targetConf.freezeTime = 3000 end
            if not targetConf.stunTime then targetConf.stunTime = 5000 end
            if not targetConf.push then targetConf.push = 0 end
        end

        local areaConf = spellT.areaConfig
        if areaConf then
            if not spellT.supportT then missingError("supportT", errorMsg) end
            local errorMsg = errorMsg.."areaConfig."

            for key, v in pairs(areaConf) do
                if not isInArray(areaKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
            end

            if not areaConf.area then missingError("area", errorMsg) end
            if not areaConf.repeatTimes then areaConf.repeatTimes = 1 end
            if not areaConf.repeatInterval then areaConf.repeatInterval = 1000 end
            if areaConf.startFromTarget and not spellT.targetRequired then print("ERROR - Target is required to use startFromTarget in "..errorMsg) end
        end
        
        if spellT.supportT then
            local errorMsg = errorMsg.."supportT."

            for i, t in pairs(spellT.supportT) do
                local errorMsg = errorMsg.."supportT["..i.."]"

                for key, v in pairs(t) do
                    if not isInArray(supportKeys, key) then print("ERROR - unknown key ["..key.."] in "..errorMsg) end
                end

                if t.minDam then
                    if not t.maxDam then t.maxDam = t.minDam end
                    if not t.damType then t.damType = PHYSICAL end
                    if not t.hitEffect then t.hitEffect = 1 end
                    if not t.missEffectInterval then t.missEffectInterval = 0 end
                end
                
                if not t.spellEffectInterval then t.spellEffectInterval = 0 end
                if not t.distanceWaitTime then t.distanceWaitTime = 0 end
                if not t.freezeTime then t.freezeTime = 3000 end
                if not t.stunTime then t.stunTime = 5000 end

                if not t.waitTime or t.waitTime == 0 then
                    if areaConf.sequenceInterval then
                        t.waitTime = (i - 1) * areaConf.sequenceInterval
                    else
                        t.waitTime = 0
                    end
                end
                spellT.supportT[i] = deepCopy(t)
            end
        end
    end
end

function spellSystem_onSay(player, words, param)
    local spellT = spellSystem_getSpellT(words)
    if not spellSystem_canCast(player, spellT) then return end

    local nextCastTime = spellSystem_getCooldownInt() + spellT.cooldown
    player:setStorageValue(spellT.cooldownSV, nextCastTime)
    player:addMana(-spellSystem_getManaCost(player, spellT))
    player:say(spellT.spellName, ORANGE)
    spellSystem_executeSpell(player, spellT)
end

function spellSystem_executeSpell(playerID, spellT, repeatTime)
    local player = Player(playerID)
    if not player then return end
    local target = player:getTarget()
    local playerPos = player:getPosition()

    if spellT.block then spellSystem_registerEffect(player, "block", spellT.blockDuration) end
    if spellT.parry then spellSystem_registerEffect(player, "parry", spellT.parryTime) end

    repeatTime = repeatTime or 1
    local areaConf = spellT.areaConfig
    local supportT = spellT.supportT
    local targetConf = spellT.singleTarget

    if targetConf then
        if not target then return end
        local targetPos = target:getPosition()

        if targetConf.minDam then spellSystem_dealDamagePos(playerID, targetPos, spellT, targetConf) end
        if targetConf.spellEffect then doSendMagicEffect(targetPos, targetConf.spellEffect, supT.spellEffectInterval) end
        if targetConf.distanceEffect then doSendDistanceEffect(playerPos, targetPos, targetConf.distanceEffect) end
        
        if targetConf.push > 0 then
            local pushDirection = getDirection(playerPos, targetPos)
            local finalPos = targetPos

            for pushAmount = 1, targetConf.push do
                temp_finalPos = getDirectionPos(targetPos, pushDirection, pushAmount)
                local tile = Tile(temp_finalPos)
                if not tile then break end
                if tile:isPzLocked() then break end
                if tile:hasProperty(CONST_PROP_BLOCKSOLID) then break end
                finalPos = temp_finalPos
            end

            target:teleportTo(finalPos)
        end
    end

    if areaConf and supportT then
        local startPos = playerPos
        
        if areaConf.startFromTarget then
            if not target then return end
            startPos = target:getPosition()
        end

        local playerID = player:getId()
        local area = getAreaPos(startPos, areaConf.area, getDirectionStrFromCreature(player))
        
        for i, posT in pairs(area) do
            for _, pos in ipairs(posT) do
                local supT = supportT[i]
                
                if supT then
                    if supT.minDam then addEvent(spellSystem_dealDamagePos, supT.waitTime, playerID, pos, spellT, supT) end
                    if supT.spellEffect then addEvent(doSendMagicEffect, supT.waitTime, pos, supT.spellEffect, supT.spellEffectInterval) end
                    if supT.distanceEffect then addEvent(doSendDistanceEffect, supT.distanceWaitTime, playerPos, pos, supT.distanceEffect) end
                end
            end
        end
        
        if areaConf.repeatTimes > repeatTime then addEvent(spellSystem_executeSpell, areaConf.repeatInterval, playerID, spellT, (repeatTime+1)) end     
    end
    return true
end

function spellSystem_canCast(player, spellT)
    if not spellT then return end
    local playerPos = player:getPosition()
    
    if not spellT.canCastInPz and Tile(playerPos):isPzLocked() then return false, player:sendTextMessage(GREEN, "Can not cast spells in PZ zone.") end
    
    if spellT.targetRequired then
        local target = player:getTarget()
        if not target then return false, player:sendTextMessage(GREEN, "target required.") end
        local targetPos = target:getPosition()
        local distance = getDistanceBetween(playerPos, targetPos)

        if spellT.targetRange and distance > spellT.targetRange then return false, player:sendTextMessage(GREEN, "target too far.") end
        
        if not spellT.canShootTroughWalls then
            local tempPos = playerPos

            for i = 1, distance do
                local targetDirection = getDirection(tempPos, targetPos)
                tempPos = getDirectionPos(tempPos, targetDirection, 1)
                local tile = Tile(tempPos)
                
                if tile and tile:hasProperty(CONST_PROP_BLOCKPROJECTILE) then
                    return false, player:sendTextMessage(GREEN, "Can not shoot trough wall.")
                end
            end
        end
    end

    if player:isGod() then return true end
    if not player:isVocation(spellT.vocation) then return end
    if not spellSystem_spellIsLearned(player, spellT) then return false, player:sendTextMessage(GREEN, "You need to learn "..spellT.spellName.." first") end
    if player:getLevel() < spellT.level then return false, player:sendTextMessage(GREEN, "You need higher level to cast that spell.") end
    if spellT.mL > 0 and player:getMagicLevel() < spellT.mL then return false, player:sendTextMessage(GREEN, "You need higher magic level to cast that spell.") end
    if spellSystem_spellIsOnCooldown(player, spellT) then return end
    if player:getMana() < spellSystem_getManaCost(player, spellT) then return false, player:sendTextMessage(GREEN, "Not enough Mana.") end
    return true
end

function spellSystem_spellIsOnCooldown(player, spellT, dontSendMsg)
    local nextCastTime = player:getStorageValue(spellT.cooldownSV)
    local currentTime = spellSystem_getCooldownInt()
    
    if nextCastTime < currentTime then return end
    
    if not dontSendMsg and antiSpam(player:getId(), "spellSystem_timeLeftStr" or 0, 300) then
        local timeLeft = nextCastTime - currentTime
        local timeLeftSec = math.ceil(timeLeft/1000)
        if timeLeftSec > 60*2 then return print("ERROR in spellSystem_spellIsOnCooldown, how timeLeftSec is more than 60*2?: "..timeLeftSec) end
        local timeLeftStr = timeLeftSec > 3 and timeLeftSec.." seconds" or timeLeft.." millisec."
        
        doSendMagicEffect(player:getPosition(), 3)
        player:sendTextMessage(GREEN, "Spell under Cooldown. "..timeLeftStr)
    end
    return true
end

function spellSystem_onLogin(player)
    player:registerEvent("spellSystem_healtChange")
end

function spellSystem_onHealthChange(player, damage, damType, attacker)
    if damType == COMBAT_HEALING then return damage, damType end
    damage, damType = spellSystem_onManaChange(player, damage, damType, attacker)
	return damage, damType
end

function spellSystem_onManaChange(player, damage, damType, attacker)
    local playerID = player:getId()
    local effectT = whiEffects[playerID]
    if not effectT then return damage, damType end

    if damType == COMBAT_HEALING then
        local freezeTime = effectT.freeze or 0
        if freezeTime > os.mtime() then damage = 0 end
        return damage, damType
    end

    local parryTime = effectT.parry or 0
    local blockTime = effectT.block or 0
    if parryTime > os.mtime() and attacker then doTargetCombatHealth(player, attacker, damType, damage, damage, 1) end
    if blockTime > os.mtime() then damage = 0 end
    return damage, damType
end

whiEffects = {}
function spellSystem_registerEffect(playerID, effect, msTime)
    local player = Player(playerID)
    if not player then return end

    playerID = player:getId()
    if not whiEffects[playerID] then whiEffects[playerID] = {} end
    whiEffects[playerID][effect] = os.mtime() + msTime
end

function spellSystem_dealDamagePos(playerID, pos, spellT, supT)
    local tile = Tile(pos)
    if not tile then return end
    if tile:isPzLocked() then return end
    if tile:hasProperty(CONST_PROP_BLOCKSOLID) then return end

    local attacker = Creature(playerID)
    local attackerID = attacker and attacker:getId() or 0
    local target = tile:getBottomCreature()
    if not target then return false, doSendMagicEffect(pos, supT.missEffect, supT.missEffectInterval) end
    
    local targetID = target:getId()
    if targetID == attackerID then return end

    local minDam = calculate(Player(playerID), supT.minDam)
    local maxDam = calculate(Player(playerID), supT.maxDam)
    
    doTargetCombatHealth(attackerID, targetID, supT.damType, -minDam, -maxDam, supT.hitEffect)
    if supT.freeze then spellSystem_registerEffect(targetID, "freeze", supT.freezeTime) end
    if supT.stun then setStun(targetID, supT.stunTime) end
end

stunItemAID = 3003
function setStun(playerID, duration)
    local player = Player(playerID)
    if not player then return end

    local position = player:getPosition()
    duration = duration or 1000
    if duration < 350 then return end
    
    local item = Game.createItem(11320, 1, pos)
    item:setActionId(stunItemAID)
    player:sendTextMessage(ORANGE, "You are stunned for "..duration.." milliseconds")
    addEvent(removeStun, duration, position)
end

function removeStun(position)
    local tile = Tile(position)
    if not tile then return end
    local itemTable = tile:getItems() or {}
    
    for _, item in pairs(itemTable) do
        if item:getActionId() == stunItemAID then item:remove() end
    end
end

function stunTeleport(creature, item, _, fromPos)
    if creature:isPlayer() then creature:teleportTo(fromPos) end
end
-- get functions / set functions / is functions
function spellSystem_getSpellT(object)
    if type(object) == "number" then
        for spellName, spellT in pairs(whiSpells) do
            if spellT.spellSV == object or spellT.cooldownSV == object then return spellT end
        end
    elseif type(object) == "string" then
        for spellName, spellT in pairs(whiSpells) do
            if spellT.spellWord == object or spellName == object then return spellT end
        end
    end
end

function spellSystem_getManaCost(player, spellT)
    local manaCost = spellT.manaCost
    if type(manaCost) == "string" then manaCost = percentage(player:getMaxMana(), tonumber(manaCost:match("%d+")), true) end
    return manaCost < 0 and 0 or manaCost
end

function spellSystem_getCooldownInt()
    return os.mtime() % (10^8)
end

function spellSystem_spellIsLearned(player, spellT)
    return not spellT.spellSV or player:getStorageValue(spellT.spellSV) == 1
end

spellSystem_startUp()