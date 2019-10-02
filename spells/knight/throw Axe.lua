local throwaxeItem = {
    AIDItems = {
        [AID.other.throwaxeItem] = {funcStr = "throwaxeItem_onUse"},
    },
    AIDItems_onMove = {
        [AID.other.throwaxeItem] = {funcStr = "discardItem"},
    }
}
centralSystem_registerTable(throwaxeItem)

function throwaxeSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    if player:getEmptySlots() == 0 then return player:sendTextMessage(GREEN, "Not enough room for axe*") end
    if player:getItemCount(7434) > 0 then return player:sendTextMessage(GREEN, "You already have this axe*") end
    return player:giveItem(7434):setActionId(AID.other.throwaxeItem)
end

function throwaxeItem_onUse(player, item, itemEx, fromPos, toPos)
    if not spells_canCast(player) then return end
    local spellT = spells_getSpellT("throwaxe")
    if not spells_canCast(player, spellT, true) then return end

    spells_afterCanCast(player, spellT)
    doSendDistanceEffect(player:getPosition(), toPos, 26)
    local target = findCreature("creature", toPos) 
    if not target then return doSendMagicEffect(toPos, 4) end

    local damage, slow = spells_getFormulas(player, spellT)
    local bounceTimes = leatherVest_extraThrowAxeBounces(player)
    local damType = getEleTypeEnum(spellT.spellType)

    potions_spellCaster_heal(player)
    bindCondition(target, "throwAxe", 5000, {speed = -slow})
    throwAxe_damage(player, target, damage, bounceTimes)
end

local function getTarget(player, area)
    local object = "monster"
        
    if getSV(player, SV.PVPEnabled) == 1 then object = "creature" end
    
    for _, posT in pairs(area) do
        for _, pos in pairs(posT) do
            local creatureID = findCreatureID(object, pos)
            if creatureID then
                if object == "monster" then return creatureID end
                local creature = Creature(creatureID)
                if creature:isMonster() then return creatureID end
                if PVP_allowed(player, creature) then return creatureID end
            end
        end
    end
end

function throwAxe_damage(playerID, creatureID, damage, bounceTimes)
    local creature = Creature(creatureID)
    local player = Creature(playerID)
    if not creature or not player then return end

    dealDamage(player, creature, PHYSICAL, damage, 1, O_player_weapons_range)
    if bounceTimes == 0 then return end
    local area = getAreaPos(creature:getPosition(), areas["6x6_0 circle"])
    local targetID = getTarget(player, area)
    if not targetID then return end
    
    bounceTimes = bounceTimes - 1
    addEvent(doSendDistanceEffect, 300, creature:getPosition(), Creature(targetID):getPosition(), 26)
    addEvent(throwAxe_damage, 300, player:getId(), targetID, damage, bounceTimes)
end