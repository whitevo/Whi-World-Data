-- creaturescripts > monsters > imp

function impSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    local playerPos = player:getPosition()
    local imp = createMonster("imp", playerPos)
    local impID = imp:getId()

    registerEvent(imp, "onThink", "imp_onThink")
    kamikazeMantle_addDamage(player) -- to waste proc
    removeImp(player)
    demonicLegs(player, imp)
    imp:setFollowCreature(player)
    setSV(player, SV.impID, impID)
    impTarget[impID] = player:getId()
end

function removeImp(player) return removeCreature(getSV(player, SV.impID)) end

function clean_impResistance()
    local tablesDeleted = 0

    for cid, t in pairs(impResistance) do
        if not Monster(cid) then
            tablesDeleted = tablesDeleted + 1
            impResistance[cid] = nil
        end
    end
    return tablesDeleted
end

function clean_impTarget()
    local tablesDeleted = 0

    for impID, cid in pairs(impTarget) do
        local imp = Monster(impID)
        
        if not imp then
            tablesDeleted = tablesDeleted + 1
            impTarget[impID] = nil
        elseif not Player(cid) then
            tablesDeleted = tablesDeleted + 1
            impTarget[impID] = nil
            imp:remove()
        end
    end
    return tablesDeleted
end

function impBuff(player, damage)
    local impID = getSV(player, SV.impID)
    if impID < 1 then return 0 end

    if Monster(impID) then
        local percentIncrease = 10
        percentIncrease = percentIncrease + demonicShield(player)
        return percentage(damage, percentIncrease)
    end

    removeSV(player, SV.impID)
    impTarget[impID] = nil
    return 0
end

impTarget = {}
impHPLoss = {}

function imp_onThink(creature)
    local creatureID = creature:getId()
    local cid = impTarget[creatureID]
    local player = Player(cid)
    if not player then return creature:remove() end

    local playerPos = player:getPosition()
    local creaturePos = creature:getPosition()
    creature:addHealth(-3)
    if getDistanceBetween(playerPos, creaturePos) <= 4 then return end

    local takeHP = creature:getMaxHealth()-creature:getHealth()
    local imp = createMonster("imp", playerPos)
    if not imp then return player:sendTextMessage(GREEN, "Your imp left you") end

    local impID = imp:getId()
    registerEvent(imp, "onThink", "imp_onThink")
    impTarget[creatureID] = nil
    creature:remove()
    demonicLegs(player, imp)
    imp:addHealth(-takeHP)
    imp:setFollowCreature(player)
    setSV(player, SV.impID, impID)
    impTarget[impID] = cid
end

local impMap = {}
function imp_onLook(player, monster)
    if monster:isMonster() and monster:getName():lower() == "imp" then
        local playerID = player:getId()
        
        if impTarget[monster:getId()] == playerID and impMap[playerID] then
            monster:getPosition():sendMagicEffect(30)
            text("bye bye", monster:getPosition())
            monster:remove()
            return true
        else
            impMap[playerID] = true
            addEvent(setTableVariable, 2000, impMap, playerID, nil)
            player:sendTextMessage(BLUE, "Look Imp twice to banish it")
        end
    end
end

function getImpByPid(playerID)
    for mid, pid2 in pairs(impTarget) do
        if playerID == pid2 then return mid end
    end
end

function imp_ownerIsAttackingWithAoe(creature, attacker)
    if creature:getRealName() ~= "imp" then return end
    if not attacker or not attacker:isPlayer() then return end
    if attacker:getSV(SV.impID) ~= creature:getId() then return end
    if damType ~= ENERGY and damType ~= DEATH then return end
    return true
end