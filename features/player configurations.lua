local features_configurations = {
    modalWindows = {
        [MW.playerConfig] = {
            name = "Player Config",
            title = "turn something ON/OFF",
            choices = {
                [1] = "playerConfig_equipmentInfo",
            },
            buttons = {
                [100] = "Switch",
                [101] = "Close",
            },
            say = "Checking player config",
            func = "player_configMW",
        },
    },
}
centralSystem_registerTable(features_configurations)

function playerConfig_equipmentInfo(player) return "["..getButtonState(player, SV.extraInfo).."] equipment tutorial'ish extra infomation" end

function player_configMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    
    if choiceID == 1 then
        toggleSV(player, SV.extraInfo)
    elseif choiceID == 2 then
    
    end
    return player:createMW(MW.playerConfig)
end

function config_createMW(player) return player and player:createMW(MW.playerConfig) end