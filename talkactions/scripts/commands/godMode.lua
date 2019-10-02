local modAccountIDT = {2}
local modNames = {"gerh"}
function onSay(player, words, param)
    local accID = player:getAccountId()
    local name = player:getRealName()

    if isInArray(modAccountIDT, accID) or isInArray(modNames, name) then
        local godMode = getSV(player, SV.isGod) == 1 and -1 or 1
        local state = godMode == -1 and "OFF" or "ON"
        setSV(player, SV.isGod, godMode)
        player:say("**! turned "..state.." godmode", ORANGE)
    end
end