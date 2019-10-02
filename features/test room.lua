--[[ testRoomConf guide
    map = {
        upCorner = {POS},       upper-left position for test room
        downCorner = {POS},     down-right position for test room
    }
]]
local AIDT = AID.areas.testRoom

testRoomConf = {
    map = {
        upCorner = {x = 637, y = 661, z = 8},
        downCorner = {x = 666, y = 680, z = 8},
    }
}

feature_testRoom = {
    AIDTiles_stepIn = {
        [AIDT.enterTeleport] = {teleport = {x = 653, y = 670, z = 8}},
        [AIDT.leaveTeleport] = {teleport = "homePos"},
    },
    onMove = {
        {funcStr = "testRoom_onMove"},
    }
}
centralSystem_registerTable(feature_testRoom)
local mapConf = testRoomConf.map

function testRoom_onLook(player, item)
    if not item:isItem() then return end
    if not isInRange(player:getPosition(), mapConf.upCorner, mapConf.downCorner) then return end
    return player:sendTextMessage(GREEN, item:getId())
end

function testRoom_onMove(player, item)
    if not item:isItem() then return end
    if not isInRange(player:getPosition(), mapConf.upCorner, mapConf.downCorner) then return end
    return player:sendTextMessage(GREEN, "You are not allowed to move items in testRoom")
end