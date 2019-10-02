function sparkSpell(playerID, spellT)
local player = Player(playerID)
    if not player then return end
    playerID = player:getId()
    if not spellT then spellT = spells_getSpellT("spark") end
local damage = spells_getFormulas(player, spellT)
local playerPos = player:getPosition()
local damType = ENERGY
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
                    addEvent(dealDamagePos, delay, playerID, pos2, damType, finalDam, effect, 101, effect) -- 101 is spell custom origin
                    previousPosT[k] = nil
                end
            end
            table.insert(newPreviousPosT, pos)
            addEvent(dealDamagePos, delay, playerID, pos, damType, finalDam, effect, 101, effect) -- 101 is spell custom origin
        end
        previousPosT = newPreviousPosT
    end
end

function spark_minDamage(amount) return amount < 160 and 160-amount or 0 end

function spells_sparkAndDeathDam(player, spellName, minAmount, maxAmount)
    if spellName ~= "spark" and spellName ~= "death" then return minAmount, maxAmount end
    local spellT = spells_getSpellT(spellName)
    local totalImprove = spellT.improvement + countMageImprovement(player, getEleTypeEnum(spellT.spellType))
    
    minAmount = minAmount + math.floor(minAmount*0.1)
    maxAmount = maxAmount + math.floor(maxAmount*0.1*totalImprove)
    return minAmount, maxAmount
end