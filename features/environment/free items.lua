local function yankOut(player, item)
    local spawnTimeMin = math.random(20,40)
    addEvent(createItem, spawnTimeMin*60*1000, item:getId(), item:getPosition())
    item:remove()
    if chanceSuccess(50) then return true end
    player:sendTextMessage(GREEN, "You broke "..item:getName().." by trying to pull it out")
end

local function stuckArrow_onUse(player, item, axis)
    if player:getPosition()[axis] < item:getPosition()[axis] then return player:sendTextMessage(GREEN, "get closer to "..item:getName().." to yank it") end
    return yankOut(player, item) and player:rewardItems({itemID = 2544}, true)
end

function stuckArrowSouth_onUse(player, item) return stuckArrow_onUse(player, item, "y") end
function stuckArrowWest_onUse(player, item) return stuckArrow_onUse(player, item, "x") end
function stuckAxe_onUse(player, item)
    return yankOut(player, item) and player:rewardItems({itemID = 2386, itemAID = 2053, itemText = "charges("..math.random(1,2)..") maxCharges(3)"}, true)
end