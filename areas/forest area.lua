local AIDT = AID.areas.forgottenVillage
local AID_randomLoot = AID.areas.forestDesertBorder.randomLoot
local function create_spawnT_axe(pos) return {pos = pos, itemID = 2386, itemAID = AID.other.tool, itemText = "charges(1) maxCharges(3)"} end

entireForest = {
    startUpFunc = "forest_startUp",
    area = {
        regions = {northDeepForest, forestDesertBorder, northForest, eastForest},
        blockObjects = {919, 4608},
        setActionID = {
            [4152] = AID.herbs.golden_spearmint,
            [2743] = AID.herbs.eaplebrond,
            [6281] = AID.herbs.eaplebrond,
        },
    },
    randomLoot = {
        [AID_randomLoot] = {
            firstTimeMSG = "*you can now open body*",
            CDmin = 40,
            CDmax = 80,
            items = {
                {chance = 250, itemID = ITEMID.other.coin},              -- gold coin
                {chance = 100, itemID = 2006, type = 0},    -- vial
                {chance = 100, itemID = 2386, itemAID = AID.other.tool, itemText = "charges(1) maxCharges(3)"},-- woodcutting axe
                {chance = 50, itemID = {2649, 2467, 2461}, rollStats = true},       -- leather items
                {chance = 30, itemID = 8301, itemAID = AID.herbs.eaddow_powder},
                {chance = 30, itemID = 8301, itemAID = AID.herbs.urreanel_powder},
                {chance = 30, itemID = 8301, itemAID = AID.herbs.stranth_powder},
                {chance = 30, itemID = 8299, itemAID = AID.herbs.eaplebrond_powder},
                {chance = 50, itemID = farmingConf.seedID, itemAID = AID.herbs.urreanel_seed},
                {chance = 50, itemID = farmingConf.seedID, itemAID = AID.herbs.ozeogon_seed},
            },
        },
    },
    itemRespawns = {
        ["hidden gold"] = {
            pos = {x = 590, y = 577, z = 7},
            maxAmount = 8,
            itemID = ITEMID.other.coin,
            count = 4,
            spawnTime = 30,
            aboveItems = 5503,
        },
        ["woodcutting axe 1"] = create_spawnT_axe({x = 594, y = 595, z = 7}),
        ["woodcutting axe 2"] = create_spawnT_axe({x = 574, y = 598, z = 7}),
        ["woodcutting axe 3"] = create_spawnT_axe({x = 588, y = 577, z = 7}),
        ["woodcutting axe 4"] = create_spawnT_axe({x = 542, y = 580, z = 7}),
        ["woodcutting axe 5"] = create_spawnT_axe({x = 513, y = 597, z = 7}),
    },
}
centralSystem_registerTable(entireForest)

local randomLootCorpses = {6082, 7908, 2843, 6524}
function forest_startUp()
    local positions = createAreaOfSquares(entireForest.area.areaCorners)

    for _, pos in pairs(positions) do
        local axe = findItem(2386, pos)
        
        if axe then
            axe:setActionId(AID.other.tool)
            axe:setText("charges", 1)
            axe:setText("maxCharges", 3)
        end
        
        for _, itemID in pairs(randomLootCorpses) do
            local corpse = findItem(itemID, pos)
            
            if corpse then
                if corpse:getActionId() == 0 then
                    if corpse:isContainer() then
                        corpse:setActionId(AID_randomLoot)
                    else
                        createItem(3656, pos, 1, AID_randomLoot)
                    end
                    break
                end
            end
        end
    end
end