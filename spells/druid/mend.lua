local mendRune = {
    AIDItems = {
        [AID.other.mendRune] = {funcStr = "mendRune_onUse"},
    },
    AIDItems_onMove = {
        [AID.other.mendRune] = {funcStr = "discardItem"},
    }
}
centralSystem_registerTable(mendRune)

function mendSpell(playerID)
    local player = Player(playerID)
    if not player then return end
    if player:getEmptySlots() == 0 then return player:sendTextMessage(GREEN, "Not enough room for rune*") end
    if player:getItemCount(2282) > 0 then return player:sendTextMessage(GREEN, "You already have this rune*") end
    return player:giveItem(2282):setActionId(AID.other.mendRune)
end

function mendRune_onUse(player, item, itemEx, fromPos, toPos)
    if not spells_canCast(player) then return end
    local playerPos = player:getPosition()
    if samePositions(toPos, playerPos) then return player:sendTextMessage(GREEN, "Can't target yourself") end

    local spellT = spells_getSpellT("mend")
    if not spells_canCast(player, spellT, true) then return end

    spells_afterCanCast(player, spellT)
    local healAmount = spells_getFormulas(player, spellT)
    if healAmount < 1 then return player:sendTextMessage(GREEN, "The heal amount is less than 1") end

    local direction = getDirection(playerPos, toPos)
    local areaIncrease = countMendIncrease(player)
    local positions = mendArea(toPos, direction, areaIncrease)

    playerPos:sendDistanceEffect(toPos, 36)
    
    for i, posT in pairs(positions) do
        for _, pos in pairs(posT) do
            local creature = findCreature("creature", pos)
            
            doSendMagicEffect(pos, {15,29})
            
            if creature then
                if creature:isPlayer() then
                    spells_healing(player, creature, healAmount)
                elseif not yashinuken(player) then
                    creature:addHealth(healAmount)
                end
            end
        end
    end
end

function countMendIncrease(player)
    local areaIncrease = 0

    areaIncrease = areaIncrease + yashinuken_area(player)
    areaIncrease = areaIncrease + yashiteki_area(player)
    areaIncrease = areaIncrease + yashimaki_area(player)
    return areaIncrease
end

function mendArea(toPos, direction, areaIncrease)
    local area
    local removeValuesAbove = 1 + areaIncrease

    if isInArray(compass1, direction) then
        area = {
            {4, 2, 4},
            {1, 0, 1},
            {n, 3, n},
        }
    elseif isInArray(compass2, direction) then
        local direction = dirToStr(direction)
        
        if areaIncrease >= 2 then
            area = {
                {n, 1, 4},
                {3, 0, 1},
                {n, 2, n},
            }
        else
            area = {
                {n, 1, 2},
                {n, 0, 1},
                {n, n, n},
            }
        end
    end
    
    for _, areaT in pairs(area) do
        for i, v in pairs(areaT) do
            if v > removeValuesAbove then areaT[i] = -1 end
        end
    end
    return getAreaPos(toPos, area, direction)
end