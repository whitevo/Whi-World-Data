mageSpellArea = {
    {n, n, 7, 7, 7, n, n},
    {n, 7, 6, 5, 6, 7, n},
    {7, 6, 5, 5, 5, 6, 7},
    {5, 4, 4, 3, 4, 4, 5},
    {n, 3, 2, 2, 2, 3, n},
    {n, n, n, 1, n, n, n},
    {n, 4, n, 0, n, 4, n},
    {n, n, 2, n, 2, n, n},
    {n, n, n, 6, n, n, n},
}
mageAreaFilter = {
    { n,  n, 12, 11, 12,  n,  n},
    { n, 11,  9,  7,  9, 11,  n},
    {11,  9,  7,  5,  7,  9, 11},
    {10,  6,  4,  3,  4,  6, 10},
    { n, 10,  5,  2,  5, 10,  n},
    { n,  n,  n,  1,  n,  n,  n},
    { n,  8,  n,  0,  n,  8,  n},
    { n,  n,  6,  n,  6,  n,  n},
    { n,  n,  n, 12,  n,  n,  n},
}

function deathSpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end
    playerID = player:getId()
    if not spellT then spellT = spells_getSpellT("death") end
    local damage = spells_getFormulas(player, spellT)
    local playerPos = player:getPosition()
    local damType = DEATH
    local effect = getEffectByType(damType)
    local improvement = 1 + countMageImprovement(player, damType)
    local areaT = filterArea(mageAreaFilter, mageSpellArea, improvement)
    local area = getAreaPos(playerPos, areaT, getDirectionStrFromCreature(player))
    local previousPosT = {}

    area = blockArea(playerPos, area, "solid", getDirectionStrFromCreature(player))
    
    for i, posT in pairs(area) do
        local newPreviousPosT = {}
        local delay = 200*(i-1)
        
        for _, pos in pairs(posT) do
            local extraDam = math.floor(damage * 0.1*i)
            local finalDam = damage+extraDam
            
            for k, pos2 in pairs(previousPosT) do
                if getDistanceBetween(pos, pos2, false) == 1 then
                    addEvent(dealDamagePos, delay, playerID, pos2, damType, finalDam, effect, 100, effect)
                    previousPosT[k] = nil
                end
            end
            table.insert(newPreviousPosT, pos)
            addEvent(dealDamagePos, delay, playerID, pos, damType, finalDam, effect, 100, effect) -- 100 is spell custom origin
        end
        previousPosT = newPreviousPosT
    end
end