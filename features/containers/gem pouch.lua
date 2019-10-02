--[[ gemPouch config table
    [INT] = {                       tierlist
        minAmount = INT or 3        mimum amount of gems from pouch
        maxAmount = INT or 10       maximum amount of gems from pouch
        chance = INT or 50          chance to get the single gem
    }
]]

local gemPouch = {
    [1] = {minAmount = 1, maxAmount = 1},
    [2] = {minAmount = 1, maxAmount = 2},
    [3] = {minAmount = 1, maxAmount = 3},
    [4] = {minAmount = 1, maxAmount = 4},
    [5] = {minAmount = 1, maxAmount = 5},
    [6] = {minAmount = 1, maxAmount = 6},
    [7] = {minAmount = 2, maxAmount = 6},
    [8] = {minAmount = 3, maxAmount = 6},
    [9] = {minAmount = 3, maxAmount = 6, chance = 60},
    [10] = {minAmount = 3, maxAmount = 6, chance = 75},
    [11] = {minAmount = 3, maxAmount = 7, chance = 75},    
}

local feature_gemPouch = {
    AIDItems = {
        [AID.other.gem_pouch] = {funcStr = "gemPouch_onUse"},
    }
}
centralSystem_registerTable(feature_gemPouch)

function gemPouch_onUse(player, item)
    local tier = item:getText("tier") or 1
    local gemPouchT = gemPouch[tier] or gemPouch[#gemPouch]
    local minAmount = gemPouchT.minAmount or 3
    local maxAmount = gemPouchT.maxAmount or 10
    local chance = gemPouchT.chance or 50
    local gems = gems_getGemIDT()
    local freeGemCount = 0
    local freeGem = true
    
    for x=1, maxAmount do
        if freeGem then
            freeGemCount = freeGemCount + 1
            if freeGemCount >= minAmount then freeGem = false end
            player:giveItem(gems[math.random(1, #gems)], 1)
        elseif chanceSuccess(chance) then
            player:giveItem(gems[math.random(1, #gems)], 1)
        end
    end
    return item:remove()
end

function gemPouch_createToPlayer(player, tier)
    local gemPouch = player:giveItem(ITEMID.containers.gem_pouch)
    gemPouch:setText("tier", tier)
    gemPouch:addItem(11754, 1)
    gemPouch:setActionId(AID.other.gem_pouch)
end