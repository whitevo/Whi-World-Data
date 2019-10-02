local monsterFriendList = {}
function Monster.getFriends(monster, distance) 
    local monsterID = monster:getId()
    local friendList = monsterFriendList[monsterID] or {}
    local master = monster:getMaster()
    local pos = monster:getPosition()
        
    if tableCount(friendList) > 0 then
        clean_cidList(friendList)
        friendList = sortCreatureListByDistance(pos, friendList, distance)
        if tableCount(friendList) > 0 then return friendList end
        monsterFriendList[monsterID] = nil
        return {}
    elseif master and master:isPlayer() then
        local partyMembers = master:getPartyMembers(distance)
        for _, playerID in pairs(partyMembers) do table.insert(friendList, playerID) end
        for _, creature in pairs(master:getSummons()) do table.insert(friendList, creature:getId()) end
    else
        local monsters = Game.getMonsters()
        monsters = sortCreatureListByDistance(pos, monsters, (distance or 10))
        for _, creature in pairs(monsters) do table.insert(friendList, creature:getId()) end
    end
    
    monsterFriendList[monsterID] = friendList
    addEvent(setTableVariable, 4000, monsterFriendList, monsterID, nil)
    return friendList
end

creatureEnemies = {}
tauntedCreatures = {} -- {creatureID = targetID}
function Monster.getEnemies(monster, distance)
    local monsterID = monster:getId()
    local enemyList = creatureEnemies[monsterID]
    local master = monster:getMaster()
    local monsterName = monster:getName():lower()
    local pos = monster:getPosition()
        
    if tauntedCreatures[monsterID] then
        return {tauntedCreatures[monsterID]}
    elseif enemyList then
        clean_cidList(enemyList)
        enemyList = sortCreatureListByDistance(pos, enemyList, distance)
        return enemyList
    elseif master and master:isPlayer() then
        local enemy = master:getTarget()
        if enemy then return {enemy:getId()} else return {} end
    else
        local enemyList = {}
        local friendList = monster:getFriendList()
        local targetList = monster:getTargetList()
        
        for _, creatureID in pairs(targetList) do
            local creature = Creature(creatureID) 
            
            if creature then
                local summons = creature:getSummons() or {}
                for _, summon in pairs(summons) do table.insert(enemyList, summon:getId()) end
                
                if creature:isPlayer() then
                    local impID = getImpByPid(creatureID)
                    if impID then table.insert(enemyList, impID) end
                    
                    if getSV(creature, SV.playerIsDead) ~= 1 or getSV(creature, SV.fakedeathOutfit) ~= 1 then
                        table.insert(enemyList, creatureID)
                    end
                end
            end
        end
        
        for _, creatureID in pairs(friendList) do
            local creature = Creature(creatureID) 
            
            if creature and creature:isPlayer() then
                print(monsterName.." has "..creature:getName().." in his friendList?")
            end
        end
        
        creatureEnemies[monsterID] = enemyList
        addEvent(setTableVariable, 4000, creatureEnemies, monsterID, nil)
        enemyList = sortCreatureListByDistance(pos, enemyList, distance)
        return enemyList
    end
end

function Monster.findTarget(monster, distance)
    local enemies = monster:getEnemies(distance)
    local creatureID = randomValueFromTable(enemies)
    return creatureID and Creature(creatureID)
end

function monsterSpecificAI_stopsOnThink(monster)
    return bandidEscapes(monster) or madDeerAI(monster) or skeletonWarriorAI(monster) or ghostRoom_ghostAI(monster)
end

function Monster.updateIgnoreList(monster)
    for _, creatureID in pairs(monster:getFriendList()) do
        local creature = Creature(creatureID)
        if not creature then monster:removeFriend(creatureID) end
    end

    local function tryRemoveTarget(creatureID)
        local creature = Creature(creatureID)
        if not creature then return true end
       -- if creature:isGod() then return true end
        if creature:isDead() then return true end
    end

    for _, creatureID in pairs(monster:getTargetList()) do 
        if tryRemoveTarget(creatureID) then monster:removeTarget(creatureID) end
    end

    local function tryAddTarget(creatureID)
        local creature = Creature(creatureID)
        if not creature then return true end
     --   if creature:isGod() then return end
        local summons = creature:getSummons() or {}
        
        if creature:isPlayer() then
            local impID = getImpByPid(creatureID) -- test what happens if pushing nil or random INT to .addTarget
            
            if impID then monster:addTarget(impID) end
            if not creature:isDead() then monster:addTarget(creatureID) end

            for _, summon in pairs(summons) do monster:addTarget(summon:getId()) end
        else    
            local master = creature:getMaster()

            if master and master:isPlayer() then
                monster:addTarget(creatureID)
            else
                monster:addFriend(creatureID)
            end
        end
        return true
    end

    if tableCount(monster:getIgnoreList()) == 0 then return end
    
    for _, creatureID in pairs(monster:getIgnoreList()) do
        if tryAddTarget(creatureID) then monster:removeIgnore(creatureID) end
    end
end

--testinSpellName = "bandit mage magic wall"

function AI_onThink(monster)
    if monsterAIGotError then return print("monsterAI is disabled - check startUp errors") end
    if not monster:isMonster() then return end
    
   
    --if monster:getRealName() ~= "bandit mage" then return end -- for testing

    monster:updateIgnoreList()
    if monsterSpecificAI_stopsOnThink(monster) then return end
    
    local spellT = AI_getSpellT(monster)
    if not spellT then return end

    for spellName, globalCdT in pairs(spellT) do
        AI_reverseCooldown(monster, spellName)

        if testinSpellName == nil or spellName == testinSpellName then -- for testing
            
            
            if type(globalCdT) == "table" then
                cdT = globalCdT[monster:getId()]

                if spellName:match("damage:") then
                    if AI_cooldownCheck(AI_getMsCooldown(spellName), cdT) then AI_attack(monster, spellName, cdT) end
                elseif spellName:match("heal:") then
                    if AI_cooldownCheck(AI_getMsCooldown(spellName), cdT) then AI_heal(monster, spellName, cdT) end
                elseif AI_spellUnderCD(spellName, cdT) then
                    AI_customSpell(monster, spellName, cdT)
                end
            end
        end
    end
end

function AI_reverseCooldown(monster, spellName)
    if spellName == "finalDamage" then return end
    local spellCastT = AI_getSpellCastT(monster, spellName)

    if spellName == testinSpellName then Uprint(spellCastT, "spellCastT;" ..spellName) end
    spellCastT.cooldown = spellCastT.cooldown + 1000
end

function AI_getMsCooldown(spellName)
    local tempCD = spellName:match("cd=%d+") or "1000"
    return tonumber(tempCD:match("%d+"))
end

function AI_cooldownCheck(spellCD, monsterCDT)
    if monsterCDT.spellLock then return end
    if monsterCDT.silenced then return end
    if monsterCDT.firstCastCD ~= 0 then spellCD = spellCD + monsterCDT.firstCastCD end
    if monsterCDT.cooldown > spellCD then
        monsterCDT.firstCastCD = 0
        return true
    end
end

function AI_spellUnderCD(spellName, cdT)
    local spellT = customSpells[spellName]
    if not spellT then return end
    return AI_cooldownCheck(spellT.cooldown, cdT)
end

local function AI_attack_getEleType(spellName)
    local tempType = spellName:match("t=%u+") or "PHYSICAL"
    return tempType:match("%u+") 
end

local function AI_attack_getDamage(spellName)
    local tempDam = spellName:match(" d=%d+-%d+")

    if not tempDam then 
        local damageStr = spellName:match(" d=%d+")
        return tonumber(damageStr:match("%d+"))
    end
    local minDam = tonumber(tempDam:match("%d+"))
    local maxDam = tonumber(tempDam:match("-%d+")) or minDam
    local damage = math.random(minDam, -maxDam)
    return damage
end

local function AI_attack_getRange(spellName)
    local tempRange = spellName:match("r=%d+") or "1"
    return tonumber(tempRange:match("%d+"))
end

local function AI_attack_getChance(spellName)
    local tempChance = spellName:match("c=%d+") or "100"
    return tonumber(tempChance:match("%d+"))
end

local function AI_attack_getMagicEffect(spellName)
    local tempFe = spellName:match("e=%d+") or "nil"
    return tonumber(tempFe:match("%d+"))
end

local function AI_attack_getFlyingEffect(spellName)
    local tempFe = spellName:match("fe=%d+") or "nil"
    return tonumber(tempFe:match("%d+"))
end

local function AI_heal_getHealAmount(monster, spellName)
    local tempPercent = spellName:match("p=%d+")
    if not tempPercent then return AI_attack_getDamage(spellName) end
    local percent = tonumber(tempPercent:match("%d+"))
    local maxHP = monster:getMaxHealth()

    return maxHP*percent*0.01
end

local function hasMsCooldown(CDT, msCooldown)
    if msCooldown > 1000 then
        CDT.cooldown = CDT.cooldown%1000 + msCooldown%1000
        return true
    end
    
    CDT.cooldown = 0
end

function AI_heal(monster, spellName, cdT)
    local monsterID = monster:getId()
    local amount = AI_heal_getHealAmount(monster, spellName)
    local msCooldown = AI_getMsCooldown(spellName)
    local chance = AI_attack_getChance(spellName)

    if chanceSuccess(chance) then heal(monsterID, amount, 13) end
    if not hasMsCooldown(cdT, msCooldown) then return end
    
    for x=1, math.floor(1000/msCooldown)-1 do
        if chanceSuccess(chance) then
            amount = AI_heal_getHealAmount(monster, spellName)
            addEvent(heal, x*msCooldown, monsterID, amount, 13)
        end
    end
end

function Monster.setAttackTarget(monster, range)
    local target = monster:getTarget()
    if not target then return monster:findTarget(range) end
    if isInArray(monster:getEnemies(range), target:getId()) then return target end
    return monster:findTarget(range)
end

function AI_attack(monster, spellName, cdT)
    local range = AI_attack_getRange(spellName)
    local target = monster:setAttackTarget(range)
    
    if not target then return end
    local monsterID     = monster:getId()
    local targetID      = target:getId()
    local damType       = AI_attack_getEleType(spellName)
    local eoh           = AI_attack_getMagicEffect(spellName) or getEffectByType(damType)
          damType       = getEleTypeEnum(damType)
    local damage        = AI_attack_getDamage(spellName) or 1
    local msCooldown    = AI_getMsCooldown(spellName)
    local chance        = AI_attack_getChance(spellName) or 100
    local flyingEffect  = AI_attack_getFlyingEffect(spellName)
    
    if chanceSuccess(chance) then dealDamage(monsterID, targetID, damType, damage, eoh, O_monster_spells, range, flyingEffect) end
    if not hasMsCooldown(cdT, msCooldown) then return end
    
    for x=1, math.floor(1000/msCooldown)-1 do
        if chanceSuccess(chance) then
            damage = AI_attack_getDamage(spellName) or 1
            addEvent(dealDamage, x*msCooldown, monsterID, targetID, damType, damage, eoh, O_monster_spells, range, flyingEffect)
        end
    end
end

function AI_customSpell(monster, spellName, cdT)
--    if spellName ~= "bandit mage magic wall" then return end
    local spellT = customSpells[spellName]
    local canCastSpell = AI_canCastSpell(monster, spellT)

  --  Vprint(monsterID, monster:getName())
   -- Vprint(canCastSpell, "canCastSpell")

    if not canCastSpell then return end

    local monsterID = monster:getId()
    cdT.cooldown = cdT.cooldown%1000 + spellT.cooldown%1000

    --Uprint(cdT, "cdT")
    SPS_castSpell(monsterID, spellName)
end

function AI_canCastSpell(monster, spellT)
    local targetConfig = spellT.targetConfig
    local monsterPos = monster:getPosition()
    local requiredT = deepCopy(targetConfig.requiredT)
    
    if tableCount(requiredT) == 0 then return true end
    
    -- missing usePosTConfig
    local function pathRequirement(targetPos, t)
        local requiredID = t.requiredID
        
        if t.findWay then
            if getPath(monsterPos, targetPos, t.obstacles, true) then
                requiredT[requiredID] = requiredT[requiredID] - 1
            end
        elseif t.obstacles then
            if pathIsOpen(monsterPos, targetPos, t.obstacles) then
                requiredT[requiredID] = requiredT[requiredID] - 1
            end
        else
            requiredT[requiredID] = requiredT[requiredID] - 1
        end
    end
    
    local function stringObject(object, t)
        local requiredID = t.requiredID
        local range = t.range
            
        if object == "enemy" then
            local enemies = monster:getEnemies()
            local targetList = sortCreatureListByDistance(monsterPos, enemies, range)
            
            for _, creatureID in pairs(targetList) do
                if requiredT[requiredID] == 0 then return end
                pathRequirement(Creature(creatureID):getPosition(), t)
            end
        elseif object == "caster" then
            requiredT[requiredID] = requiredT[requiredID] - 1
        elseif object == "cTarget" then
            local target = monster:getTarget()
            if ghostTargets(monster, target) then return end
            if not target then return end
            local targetPos = target:getPosition()
            
            if getDistanceBetween(monsterPos, targetPos) <= range then pathRequirement(targetPos, t) end
        elseif object == "friend" then
            local friends = monster:getFriends(range)
            
            for _, creatureID in pairs(friends) do
                if requiredT[requiredID] == 0 then return end
                pathRequirement(Creature(creatureID):getPosition(), t)
            end
        else
            print("ERROR unknown object in AI_canCastSpell()")
        end
    end
    
    local function numberObject(object, t)
        local requiredID = t.requiredID
        local range = t.range
        local area = getAreaAround(monsterPos, range)
            
        table.insert(area, monsterPos)
        for _, pos in pairs(area) do
            if findItem(object, pos) then
                pathRequirement(pos, t)
                if requiredT[requiredID] == 0 then return end
            end
        end
    end
    
    local function handleObject(object, t)
        if requiredT[t.requiredID] > 0 then
            if type(object) == "string" then
                stringObject(object, t)
            elseif type(object) == "number" then
                numberObject(object, t)
            elseif type(object) == "table" then
                for _, object in pairs(object) do
                    handleObject(object, t)
                end
            end
        end
    end
    
    for object, t in pairs(targetConfig) do
        if t.requiredID then handleObject(object, t) end
    end
    
    for ID, amount in pairs(requiredT) do
        if amount > 0 then return end
    end
    return true
end

function AI_getSpellT(monster)
    local monsterName = monster:getRealName():lower()
    local spellT = monsterSpells[monsterName]

    if not spellT and getMonsterT(monster) then print("Spells are not registrated on "..monsterName.." IN monsterAI") end
    return spellT
end

function AI_getSpellCastT(monster, spellName)
    local spellT = AI_getSpellT(monster)
    local monsterID = monster:getId()
    local spellCastT = spellT[spellName][monsterID]
    if spellCastT then return spellCastT end

    spellT[spellName][monsterID] = {}
    spellCastT = spellT[spellName][monsterID]
    spellCastT.cooldown = 0
    spellCastT.firstCastCD = 1000
    spellCastT.silenced = false
    spellCastT.spellLock = false
    spellCastT.createCooldownT = nil

    local customSpellT = customSpells[spellName]
    if not customSpellT then return spellCastT end

    if customSpellT.firstCastCD then spellCastT.firstCastCD = customSpellT.firstCastCD end
    if customSpellT.locked then spellCastT.spellLock = true end
    if customSpellT.lockedForSummon and monster:getMaster() then spellCastT.spellLock = true end
    return spellCastT
end