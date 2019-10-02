--[[ config guide
    [INT] = {                   actionID of tile
        name = STR              area name
        SV = INT                storage value to see if area is found
        rewardSP = INT          amount of skillpoints rewarded for finding the area
    }
]]
areaDiscover = {} -- need to register AID manually if you add discover tile here

function discoverTile(player, item)
    if not player:isPlayer() then return end
    local discoverT = areaDiscover[item:getActionId()]
    if discoverT.name:lower() == "bandit mountain" then setSV(player, SV.findPeeterTracker, 1) end
    if getSV(player, discoverT.SV) == 1 then return end

    local skillpoints = discoverT.rewardSP
    local playerPos = player:getPosition()
    local area = getAreaAround(playerPos, 2)

    addSV(player, SV.skillpoints, skillpoints)
    setSV(player, discoverT.SV, 1)
    for _, pos in pairs(area) do doSendDistanceEffect(pos, playerPos, 11) end
    doSendMagicEffect(playerPos, 29)
    player:sendTextMessage(GREEN, "You found "..discoverT.name)
    player:sendTextMessage(ORANGE, "You found "..discoverT.name)
    player:sendTextMessage(ORANGE, "you earned "..plural("skillpoint", skillpoints))
end

function central_register_discover(discoverT)
    if not discoverT then return end

    for AID, t in pairs(discoverT) do
        areaDiscover[AID] = t
        AIDTiles_stepIn[AID] = {funcSTR = "discoverTile"}
    end
end