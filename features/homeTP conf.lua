--[[ config guide
    [INT] = {               pillar actionID
        pillarAID = INT     gives teleport charge onUse
        chargeName = STR    charge name to distinguish
        SV = INT            storage value 1 == has charge

        AUTOMATIC
        choiceID = INT      for modal window
    }
]]

homeTP_conf = homeTP_conf or {
    teleports = {},
}

local feature_homeTP = {
    startUpFunc = "homeTP_startUp",

    modalWindows = {
        [MW.homeTP] = {
            name = "Teleport home",
            title = "Choose a charge",
            choices = "homeTP_MWChoices",
            buttons = {[100] = "Teleport", [101] = "Close"},
            say = "Preparing to teleport home",
            func = "homeTP_handleMW",
        },
    },
    AIDItems_onLook = {
        [AID.other.homeTPTile] = {text = {msg = "On this tile you can teleport without loosing a charge"}},
    }
}
centralSystem_registerTable(feature_homeTP)