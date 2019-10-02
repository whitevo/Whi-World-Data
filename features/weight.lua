function recalulateCap(player)
    player:setCapacity(100000)
    if getSV(player, SV.zvoidTurban) > 0 then player:setCapacity(player:getCapacity() + getSV(player, SV.zvoidTurban)) end
    if getSV(player, SV.weapon_scabbard) > 0 then weapon_scabbard_addCap(player) end
    recalculateContainerWeight(player, player:getBag())
    recalculateContainerWeight(player, player:getItem(lootBagConf.itemID))
    recalculateContainerWeight(player, player:getItem(mineralBagConf.itemID))
end

function recalculateContainerWeight(player, container)
    if not container then return end
    for x=0, container:getSize() do
        local item = container:getItem(x)
        if not item then return end
        recalculateItemWeight(player, item)
    end
end

function recalculateItemWeight(player, item)
    if not item:hasCustomWeight() then return end
local customWeight = item:getCustomWeight()
local originalWeight = item:getWeight()
local weight = customWeight - originalWeight
    
    player:changeWeight(-weight)
end

function Item.hasCustomWeight(item) return item:getCustomWeight(item) ~= item:getWeight() end
function Item.getCustomWeight(item) return item:getText("weight") or item:getWeight() end
function Item.setCustomWeight(item, amount) return item:setText("weight", amount) end

function Player.changeWeight(player, weight) return player:setCapacity(player:getCapacity() + weight) end

function Player.addCap(player, amount, SV, msDuration)
    if SV and getSV(player, ID) == 1 then return end
    if SV then setSV(player, ID, 1) end
    player:changeWeight(player, amount*100)
    if not msDuration or msDuration < 1 then return end
    if SV then addEvent(removeSV, msDuration, player:getId(), SV) end
    addEvent(capRemove, msDuration, player:getId(), amount)
end