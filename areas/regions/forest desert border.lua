local AIDT = AID.areas.forestDesertBorder
forestDesertBorder = {
    area = {
        areaCorners = {{upCorner = {x = 481, y = 614, z = 7}, downCorner = {x = 640, y = 640, z = 7}}},
        blockObjects = {919, 4608},
        setActionID = {
            [10912] = AID.herbs.xuppeofron,
        },
    },
    AIDItems = {
        [AIDT.lootbag] = {
            allSV = {[SV.lootbagFromWagon] = -1},
            setSV = {[SV.lootbagFromWagon] = 1},
            text = {msg = "You can now carry 1 extra item with lootbag"},
            textF = {msg = "You have already found loot bag upgrade from here."},
        },
        [AIDT.letterBody] = {funcSTR = "herbs_discoverHint"}
    },
    AIDItems_onLook = {
        [AIDT.letterBody] = {text = {msg = "Skeleton holding a stack of letters, probably lost his mind because words have no meaning and tree is drawn on papers"}},
    },
}
centralSystem_registerTable(forestDesertBorder)