--[[ config guide
    [_] = {
        regions = {STR}             global centralT table names which generate areaCorners
        areaCorners = {             to create all the positions for setActionID
            [INT] = {
                upCorner = POS      
                downCorner = POS    
                allZPos = false     if true then checks all map layers
            }
        }
        setActionID = {             gives actionID to all items
            [INT] = INT             first INT = itemID | seconds INT = actionID it will get
        }
        blockObjects = {INT}        itemID's of items which on found will not activate setActionId
    }
]]

function onStartup()
    deleteUselessCharacters()
    bossRoom_clearHighscores()
	db.query("TRUNCATE TABLE `players_online`")
	db.query("DELETE FROM `guild_wars` WHERE `status` = 0")
	db.query("DELETE FROM `players` WHERE `deletion` != 0 AND `deletion` < " .. os.time())
	db.query("DELETE FROM `ip_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. os.time())
	db.query("DELETE FROM `market_history` WHERE `inserted` <= " .. (os.time() - configManager.getNumber(configKeys.MARKET_OFFER_DURATION)))
    global_startUp(true)
end

function global_startUp(dontBroadcast)
    if not dontBroadcast then broadcast("Server was restarted. Probably improved or added something") end
    central_registerAll()
    
    activateGlobalAreas()
    executeStartUpT()
    
    createConditions()
    spellCreatingSystem_checkConfig()

    npcSystem_loadMissions()
    itemRespawns_spawnItems()
    spellCreatingSystem_startUp()
end

function executeStartUpT()
    local maxPriorityLevel = 0

    for funcStr, priority in pairs(startUpT) do
        if priority > maxPriorityLevel then maxPriorityLevel = priority end
        if priority == 0 then _G[funcStr]() end
    end

    for prioritySequence=1, maxPriorityLevel do
        for funcStr, priority in pairs(startUpT) do
            if priority == prioritySequence then _G[funcStr]() end
        end
    end
end

function activateGlobalAreas()
    for _, areaT in pairs(globalAreas) do
        local setAIDT = areaT.setActionID
        local cornerT = areaT.areaCorners
        local positions = createAreaOfSquares(cornerT)
        
        if setAIDT then
            if not cornerT then return print("ERROR in activateGlobalAreas() - missing areaCorners from areaT") end
            local ignoreObjects = areaT.blockObjects or {}
            
            for _, pos in pairs(positions) do
                removeItemFromPos(1435, pos)
                
                if not isInArray(ignoreObjects) then
                    for itemID, newAID in pairs(setAIDT) do
                        local item = findItem(itemID, pos)
                        if item and item:getActionId() == 0 then
                            item:setActionId(newAID)
                            break
                        end
                    end
                end
            end
        elseif positions then
            for _, pos in pairs(positions) do
                removeItemFromPos(1435, pos)
            end
        end
    end
end

function deleteUselessCharacters() return db.query("DELETE FROM `players` WHERE `level` < 2 AND `lastlogin` + 7*24*60*60 < "..os.time()) end