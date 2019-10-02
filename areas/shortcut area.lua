local AIDT = AID.areas.TProom

shortcutArea = {
    AIDItems = {
        [AIDT.banditMountain] = {
            allSV = {[SV.BanditMountain] = 1},
            teleport = {x = 501, y = 598, z = 6},
            textF = {msg = "You need to find Bandit Mountain first"}
        },
        [AIDT.cyclopsDungeon] = {
            allSV = {[SV.CyclopsDungeon] = 1},
            teleport = {x = 771, y = 575, z = 8},
            textF = {msg = "You need to find Cyclops Dungeon first"}
        },
    },
    AIDTiles_stepIn = {
        [AIDT.hehemi] = {
            allSV = {[SV.Hehemi] = 1},
            teleportF = {x = 535, y = 640, z = 8},
            teleport = {x = 446, y = 677, z = 9},
            textF = {msg = "You need to find Hehemi first"},
        },
        [AIDT.rootedCatacombs] = {
            allSV = {[SV.rootedCatacombs] = 1},
            teleportF = {x = 576, y = 646, z = 8},
            teleport = {x = 610, y = 753, z = 8},
            textF = {msg = "You need to find Rooted Catacombs first"},
            ME = {
                pos = {x = 610, y = 753, z = 8},
                effects = {13, 2, 31},
                interval = 200,
            },
        },
    },
    AIDItems_onLook = {
        [AIDT.hehemiBranch] = {text = {msg = "Huge Wooden Branch, you can saw it down."}}
    }
}
centralSystem_registerTable(shortcutArea)

function cutHehemiBranch(player, item, itemEx)
    if not itemEx:isItem() then return end
    if itemEx:getActionId() ~= AIDT.hehemiBranch then return end
local charges = tools_getCharges(item)
    if charges < 1 then return end
local itemPos = itemEx:getPosition()

    tools_setCharges(player, item, charges - 1)
    addEvent(createItem, 1000*60*1, 4061, itemPos)
    return itemEx:remove()
end