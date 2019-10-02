-- !NB all normal doors need AID.other.door = 2204
badDoors = {
    1210, 1213, 5138, 5141, 1232, 1235, 1250, 1253, 3536, 3544, 4913, 5098, 5107, 5116, 5125, 5134, 5143, 5278, 5281, 5732, 5735, 6192, 6195, 6249, 6252, 6799,
    6800, 6801, 6802, 6891, 6900, 7033, 7042, 8541, 8544, 9165, 9168, 9267, 9270, 10268, 10271, 10468, 10477, 10776, 10784, 11475, 11477, 12092, 12099, 12188,
    12197, 14633, 14640, 17237, 19840, 19849, 19980, 20273, 20282,
}

doors = { -- [closed door] = open door
    [1209] = 1211,    [1212] = 1214,    [1219] = 1220,    [1221] = 1222,    [1223] = 1224,    [1225] = 1226,    [1227] = 1228,    [1229] = 1230,    [1231] = 1233,
    [1234] = 1236,    [1237] = 1238,    [1239] = 1240,    [1241] = 1242,    [1243] = 1244,    [1245] = 1246,    [1247] = 1248,    [1249] = 1251,    [1252] = 1254,
    [1255] = 1256,    [1257] = 1258,    [1259] = 1260,    [1261] = 1262,    [1539] = 1540,    [1541] = 1542,    [3535] = 3537,    [3538] = 3539,    [3540] = 3541,
    [3542] = 3543,    [3545] = 3546,    [3547] = 3548,    [3549] = 3550,    [3551] = 3552,    [4914] = 4915,    [4917] = 4918,    [5082] = 5083,    [5084] = 5085,
    [5099] = 5100,    [5101] = 5102,    [5103] = 5104,    [5105] = 5106,    [5108] = 5109,    [5110] = 5111,    [5112] = 5113,    [5114] = 5115,    [5117] = 5118,
    [5119] = 5120,    [5121] = 5122,    [5123] = 5124,    [5126] = 5127,    [5128] = 5129,    [5130] = 5131,    [5132] = 5133,    [5135] = 5136,    [5137] = 5139,
    [5140] = 5142,    [5144] = 5145,    [5279] = 5280,    [5282] = 5283,    [5284] = 5285,    [5286] = 5287,    [5288] = 5289,    [5290] = 5291,    [5292] = 5293,
    [5294] = 5295,    [5515] = 5516,    [5517] = 5518,    [5733] = 5734,    [5736] = 5737,    [5745] = 5746,    [5748] = 5749,    [6193] = 6194,    [6196] = 6197,
    [6198] = 6199,    [6200] = 6201,    [6202] = 6203,    [6204] = 6205,    [6206] = 6207,    [6208] = 6209,    [6250] = 6251,    [6253] = 6254,    [6255] = 6256,
    [6257] = 6258,    [6259] = 6260,    [6261] = 6262,    [6263] = 6264,    [6265] = 6266,    [6795] = 6796,    [6797] = 6798,    [6892] = 6893,    [6894] = 6895,
    [6896] = 6897,    [6898] = 6899,    [6901] = 6902,    [6903] = 6904,    [6905] = 6906,    [6907] = 6908,    [7034] = 7035,    [7036] = 7037,    [7038] = 7039,
    [7040] = 7041,    [7043] = 7044,    [7045] = 7046,    [7047] = 7048,    [7049] = 7050,    [7054] = 7055,    [7056] = 7057,    [8542] = 8543,    [8545] = 8546,
    [8547] = 8548,    [8549] = 8550,    [8551] = 8552,    [8553] = 8554,    [8555] = 8556,    [8557] = 8558,    [9166] = 9167,    [9169] = 9170,    [9171] = 9172,
    [9173] = 9174,    [9175] = 9176,    [9177] = 9178,    [9179] = 9180,    [9181] = 9182,    [9268] = 9269,    [9271] = 9272,    [9273] = 9274,    [9275] = 9276,
    [9277] = 9278,    [9279] = 9280,    [9281] = 9282,    [9283] = 9284,    [10269] = 10270,  [10272] = 10273,  [10274] = 10275,  [10276] = 10277,  [10278] = 10279,
    [10280] = 10281,  [10282] = 10283,  [10284] = 10285,  [10469] = 10470,  [10471] = 10472,  [10473] = 10474,  [10475] = 10476,  [10478] = 10479,  [10480] = 10481,
    [10482] = 10483,  [10484] = 10485,  [11477] = 10485,  [10776] = 10777,  [10780] = 10781,  [10782] = 10783,  [10785] = 10786,  [10789] = 10790,  [10791] = 10792,
    [12093] = 12094,  [12095] = 12096,  [12097] = 12098,  [12100] = 12101,  [12102] = 12103,  [12104] = 12105,  [12189] = 12190,  [12191] = 12192,  [12193] = 12194,
    [12195] = 12196,  [12198] = 12199,  [12202] = 12203,  [12204] = 12205,  [12692] = 12693,  [12692] = 12695,  [12701] = 12703,  [13020] = 13021,  [13022] = 13023,
    [14634] = 14635,  [14640] = 17238,  [17235] = 17236,  [18208] = 18209,  [19841] = 19842,  [19843] = 19844,  [19845] = 19846,  [19847] = 19848,  [19850] = 19851,
    [19852] = 19853,  [19854] = 19855,  [19856] = 19857,  [19981] = 19982,  [19983] = 19984,  [19985] = 19986,  [19987] = 19988,  [19981] = 19982,  [19983] = 19984,
    [19985] = 19986,  [19987] = 19988,  [19989] = 19991,  [19990] = 19991,  [19992] = 19993,  [19994] = 19995,  [19996] = 19997,  [20274] = 20275,  [20276] = 20277,
    [20278] = 20279,  [20280] = 20281,  [20283] = 20284,  [20285] = 20286,  [20287] = 20288,  [20289] = 20290,
}

function normalDoors_onLook(item, desc, realDesc)
    if desc then return desc end
    local itemID = item:getId()
    if doors[itemID] then return "closed door" end
    if matchTableValue(doors, itemID) then return "open door" end
end

function openDoor(player, item) return executeDoor(player, item) end

function automaticDoor(player, item)
    local tile = Tile(item:getPosition())
    if tile:getBottomCreature() then return false, player:sendTextMessage(GREEN, "There is creature in the way") end
    local floor = tile:getGround()
    
    floor:setActionId(AID.other.closeDoor)
    floor:setText("closedDoorID", item:getId())
    return executeDoor(player, item) 
end

local function getDoorID(item)
    local doorID = item:getText("closedDoorID")
    if doorID then return doors[doorID] end

    for closeDoorID, openDoorID in pairs(doors) do
        if findItem(openDoorID, item:getPosition()) then return openDoorID end
    end
end

function closeDoor(player, item)
    local door = findItem(getDoorID(item), item:getPosition())
    if not door then return item:setActionId() end
    return executeDoor(player, door)
end

function executeDoor(player, item)
    if not item then return end 
    local itemPos = item:getPosition()
    if Tile(itemPos):getBottomCreature() then return false, player:sendTextMessage(GREEN, "There is creature in the way") end
    local itemID = item:getId()
    
    for closeDoorID, openDoorID in pairs(doors) do
        if closeDoorID == itemID then
            player:teleportTo(itemPos, true)
            return item:transform(openDoorID)
        elseif openDoorID == itemID then
            return item:transform(closeDoorID)
        end
    end
    
    if isInArray(badDoors, itemID) then return print("BAD DOOR in position: ("..itemPos.x..", "..itemPos.y..", "..itemPos.z..")") end
    print("this is not a doorID: "..itemID)
    Uprint(item:getPosition(), "doorPos")
end

function survivalDoor(player, item, _, fromPos)
    if not player:isPlayer() then return end
    if getSV(player, SV.lastDeathTime) + 2*60*60 < os.time() then return end
    local itemPos = item:getPosition()

    player:sendTextMessage(GREEN, "Only players who have not died in past 2 hours can pass this door. (relog if you think its not working)")
    teleport(player, fromPos, true)
    
    for closeDoorID, openDoorID in pairs(doors) do
        if doTransform(openDoorID, itemPos, closeDoorID, true) then return text("*SLAM*", itemPos) end
    end
end

function Tile.hasDoor(tile)
    for closedDoor, openDoor in pairs(doors) do
        if tile:getItemById(closedDoor) then return true end
        if tile:getItemById(openDoor) then return true end
    end
end