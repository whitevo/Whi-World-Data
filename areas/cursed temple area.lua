local AIDT = AID.areas.cursedTemple

cursedTempleArea = {
    area = {
        areaCorners = {
            [1] = {upCorner = {x = 692, y = 582, z = 7}, downCorner = {x = 717, y = 607, z = 7}},
            [2] = {upCorner = {x = 733, y = 584, z = 7}, downCorner = {x = 763, y = 607, z = 7}},
            [3] = {upCorner = {x = 733, y = 584, z = 6}, downCorner = {x = 763, y = 607, z = 6}},
            [4] = {upCorner = {x = 733, y = 584, z = 5}, downCorner = {x = 763, y = 607, z = 5}},
            [5] = {upCorner = {x = 738, y = 593, z = 4}, downCorner = {x = 755, y = 600, z = 4}},
            [6] = {upCorner = {x = 742, y = 595, z = 3}, downCorner = {x = 743, y = 595, z = 3}},
            [7] = {upCorner = {x = 697, y = 583, z = 6}, downCorner = {x = 720, y = 606, z = 6}},
        }
    },
    itemRespawns = {
        {pos = {x = 755, y = 604, z = 7}, itemID = 8309, spawnTime = 20},
        {pos = {x = 756, y = 587, z = 7}, itemID = 8309, spawnTime = 20},
        {pos = {x = 736, y = 596, z = 5}, itemID = ITEMID.materials.log, spawnTime = 20},
        {pos = {x = 742, y = 592, z = 5}, itemID = ITEMID.materials.log, spawnTime = 20},
    },
    AIDItems = {
        [AIDT.escapeLadder] = {teleport = {x = 703, y = 605, z = 7}},
        [AIDT.waterfall] = {
            allSV = {[SV.nami_bootsFromPool] = -1},
            setSV = {[SV.nami_bootsFromPool] = 1},
            rewardItems = {{itemID = 18406, itemText = "randomStats"}},
            funcSTR = "namiBootsDissapear",
            textF = {msg = "You have already found the boots from here"},
        },
    },
    AIDItems_onLook = {
        [AIDT.namiBoots_behindBars] = {
            allSV = {[SV.nami_bootsFromPool] = -1},
            text = {msg = "There seems to be something good stuck behind bars"},
            textF = {msg = "You have already taken boots from there"},
        }
    },
    homeTP = {
        pillarAID = AIDT.HC_pillar,
        chargeName = "Waterfall Cave",
        SV = SV.WC_teleportCharge,
    },
}
centralSystem_registerTable(cursedTempleArea)

function namiBootsDissapear(player, item)
local itemPos = {x = 745, y = 598, z = 5}
local gateID = 9486
local gateAID = AIDT.namiBoots_behindBars
local itemID = 18406
local boots = findItem(itemID, itemPos)
    
    if not boots then return end
    boots:remove()
    addEvent(function()
        findItem(gateID, itemPos):remove()
        createItem(itemID, itemPos)
        createItem(gateID, itemPos, 1, gateAID)
    end, 60*1000)
end