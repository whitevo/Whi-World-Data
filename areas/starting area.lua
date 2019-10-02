local AIDT = AID.areas.startingPlace
local confT = {
    areaCorners = {{upCorner = {x = 529, y = 699, z = 8}, downCorner = {x = 555, y = 742, z = 8}}},
}
startingArea = {
    startUpFunc = "startingArea_startUp",
    area = {areaCorners = confT.areaCorners},
    AIDItems = {
        [AIDT.lootBagMonument] = {
            allSV = {[SV.lootBagFromTutorialMonument] = -1},
            setSV = {[SV.lootBagFromTutorialMonument] = 1},
            rewardItems = {{itemID = 2553, itemAID = AID.other.tool, itemText = "charges(20)"}},
            text = {msg = "You can now carry 1 extra item with lootbag"},
            textF = {msg = "You have already found loot bag upgrade from here."},
        },
        [AIDT.door] = {
            bigSV = {[SV.tutorial] = 1},
            funcSTR = "automaticDoor",
            setSV = {[SV.dummyKey] = 1},
            textF = {msg = "Key for this door is inside the Dummy body."},
        },
    },
}
centralSystem_registerTable(startingArea)

function startingArea_startUp()
--[[    local area = createAreaOfSquares(confT.areaCorners)

    
    local function registerObject(pos)
    
    end
    
    for _, pos in pairs(area) do registerObject(pos) end
]]
end