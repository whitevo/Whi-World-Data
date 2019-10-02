local houseList = {
    [1] = {
        upCorner = {x = 550, y = 648, z = 7},
        downCorner = {x = 562, y = 657, z = 7},
        -- kickPos = POS or player:homePos()
        -- ownerNames = {STR}
        
        --[[ automatic 
            totalCost = INT         full price for house
            weeklyCost = INT        weekly price for house
            miniHousePos = POS
            houseID = INT           same with table key
        ]]
    },
    [2] = {upCorner = {x = 550, y = 636, z = 7}, downCorner = {x = 562, y = 646, z = 7}},
    [3] = {upCorner = {x = 553, y = 624, z = 7}, downCorner = {x = 566, y = 634, z = 7}},
    [4] = {upCorner = {x = 540, y = 629, z = 7}, downCorner = {x = 549, y = 640, z = 7}},
    [5] = {upCorner = {x = 530, y = 632, z = 7}, downCorner = {x = 538, y = 645, z = 7}},
    [6] = {upCorner = {x = 540, y = 644, z = 7}, downCorner = {x = 547, y = 653, z = 7}},
    [7] = {upCorner = {x = 523, y = 648, z = 7}, downCorner = {x = 538, y = 653, z = 7}},
    [8] = {upCorner = {x = 529, y = 655, z = 7}, downCorner = {x = 537, y = 666, z = 7}},
    [9] = {upCorner = {x = 540, y = 656, z = 7}, downCorner = {x = 548, y = 667, z = 7}},
    [11] = {upCorner = {x = 516, y = 655, z = 7}, downCorner = {x = 526, y = 664, z = 7}},
    [12] = {upCorner = {x = 550, y = 660, z = 7}, downCorner = {x = 556, y = 667, z = 7}},
    [13] = {upCorner = {x = 552, y = 671, z = 7}, downCorner = {x = 563, y = 681, z = 7}},
    [14] = {upCorner = {x = 540, y = 670, z = 7}, downCorner = {x = 550, y = 682, z = 7}},
    [15] = {upCorner = {x = 531, y = 668, z = 7}, downCorner = {x = 537, y = 674, z = 7}},
    [16] = {upCorner = {x = 514, y = 667, z = 7}, downCorner = {x = 528, y = 675, z = 7}},
    [17] = {upCorner = {x = 509, y = 678, z = 7}, downCorner = {x = 523, y = 689, z = 7}},
    [18] = {upCorner = {x = 526, y = 679, z = 7}, downCorner = {x = 538, y = 686, z = 7}},
    [19] = {upCorner = {x = 528, y = 689, z = 7}, downCorner = {x = 537, y = 696, z = 7}},
    [20] = {upCorner = {x = 541, y = 685, z = 7}, downCorner = {x = 552, y = 693, z = 7}},
}

local AIDT = AID.building

building_conf = {
    miniHouseID = 16619,
    houseBuyAID = AIDT.miniHouseAID,
    houseCostPerTile = 2,
    houseWeeklyPaymentPerTile = 1,
    rentDurationInHours = 168,  -- duration how long player will own house for each payment | 168 == 1 week
    
    professionT = { -- to registeer building to professions
        professionStr = "building",
        expSV = SV.building_exp,
        levelSV = SV.building_level,
        mwID = MW.houseMW,
    },
    
    tutorialRooms = {
        [1] = {
            upCorner = {x = 702, y = 661, z = 7},
            downCorner = {x = 706, y = 665, z = 7}, -- also used as an enterPos
            -- playerID = playerID,     when player enters the tutorial his registered so that only 1 person at the time can do it.
        },
        [2] = {upCorner = {x = 709, y = 661, z = 7}, downCorner = {x = 713, y = 665, z = 7}},
        [3] = {upCorner = {x = 702, y = 668, z = 7}, downCorner =  {x = 706, y = 672, z = 7}},
        [4] = {upCorner = {x = 709, y = 668, z = 7}, downCorner = {x = 713, y = 672, z = 7}},
    },
    tutorialTeleportAID = AIDT.tutorialTeleportAID,
    tutorial = {
        [1] = {
            stageMsg = "tutorial stage 1: How to build walls",
            tipMsg = "use the hammer on a blue tile to build a wall that requires no materials.",
            targetTileAID = AIDT.tutorialBlueTile,
            itemList = {
                {itemID = 1025, itemAID = AIDT.tutorialWall, req = {itemID = 13866, count = 4}},
                {itemID = 1049, itemAID = AIDT.tutorialWall, req = {itemID = 13866, count = 4}},
                {itemID = 1100, itemAID = AIDT.tutorialWall, req = {itemID = 13862, count = 4}},
                {itemID = 1111, itemAID = AIDT.tutorialWall},
                {itemID = 5261, itemAID = AIDT.tutorialWall, req = {{itemID = ITEMID.materials.log, count = 4}, {itemID = 8309, count = 4}}},
            },
        },
        [2] = {
            stageMsg = "tutorial stage 2: How to build floors",
            tipMsg = "use the hammer on a brown tile to build a ground tile that requires no materials.",
            targetTileAID = AIDT.tutorialBrownTile,
            itemList = {
                {itemID = 280,  req = {itemID = 2005, type = 19}},
                {itemID = 405,  req = {itemID = ITEMID.materials.log, count = 2}},
                {itemID = 4695, req = {itemID = 2005, type = 4}},
                {itemID = 406},
            },
        },
        [3] = {
            stageMsg = "tutorial stage 3: How to build items",
            tipMsg = "use the hammer on a red tile to build an item that requires no materials.",
            targetTileAID = AIDT.tutorialRedTile,
            itemList = {
                {itemID = 1666, itemAID = AIDT.tutorialDestroyItem, req = {{itemID = ITEMID.materials.log, count = 2}, {itemID = 5911, count = 2}}},
                {itemID = 1616, itemAID = AIDT.tutorialDestroyItem, req = {itemID = ITEMID.materials.log, count = 2}},
                {itemID = 7447, itemAID = AIDT.tutorialDestroyItem},
            },
        },
        [4] = {
            stageMsg = "tutorial stage 4: How to build window",
            tipMsg = "use the hammer on a wall to build a window that requires no materials.",
            targetTileAID = AIDT.tutorialWall,
            itemList = {
                {itemID = 9723, req = {itemID = 13866, count = 2}},
                {itemID = 9724, req = {itemID = 13866, count = 2}},
                {itemID = 9725, req = {itemID = 13866, count = 2}},
                {itemID = 1270, req = {itemID = 13866, count = 2}},
                {itemID = 5304},
            },
        },
        [5] = {
            stageMsg = "tutorial stage 5: How to remove objects",
            tipMsg = "use the hammer on an item you created and remove object on that tile.",
            targetTileAID = AIDT.tutorialDestroyItem,
        },
        [6] = {
            stageMsg = "tutorial stage 6: How to grow plants",
            tipMsg = "use the hammer on a dirt ground to plant what you can.",
            targetTileAID = AIDT.tutorialDirtTile,
            itemList = {
                {itemID = 2753},
                {itemID = 2768, req = {{itemID = 2157, itemAID = AIDT.smallFirTreeSeed}, {itemID = 2005, type = 1}}},
                {itemID = 2771, req = {{itemID = 2157, itemAID = AIDT.mireSproutSeed}, {itemID = 2005, type = 1}}},
            },
        },
    },
    houseOffers = {},   --[houseID] = sellPrice
    levelUpInfoT = {},  --[level] = {itemName or semigroup} (semigroup is an building theme)
}

feature_building = {
    startUpFunc = "house_startUp",
    startUpPriority = 2,
    area = {areaCorners = houseList},
    AIDItems = {
        [building_conf.houseBuyAID] = {funcSTR = "house_miniHouse_onUse"},
        [AIDT.door] = {funcSTR = "house_door_onUse"},
        [AIDT.tutorialHammer] = {funcSTR = "building_tutorial_useHammer"},
    },
    AIDItems_onLook = {
        [AIDT.tutorialHammer] = {funcSTR = "building_tutorial_lookHammer"},
    },
    AIDTiles_stepIn = {
        [building_conf.tutorialTeleportAID] = {funcSTR = "building_tutorial_leaveArea"},
    },
   
    modalWindows = {
        [MW.house_owners] = {
            name = "house owner list",
            title = "currently house can only have 1 owner",
            choices = "house_ownersMW_choices",
            buttons = {
                [100] = "leave house",
                [101] = "back",
            },
            enterButton = 101,
            func = "house_ownersMW",
        },
        [MW.house_sellOptions] = {
            name = "sell your house options",
            title = "choose a way to sell your house",
            choices = "house_sellOptionsMW_choices",
            buttons = {
                [100] = "choose",
                [101] = "back",
            },
            func = "house_sellOptionsMW",
        },
        [MW.houseBuy] = {
            name = "house buying window",
            title = "choose an option below",
            choices = "house_houseBuyMW_choices",
            buttons = {
                [100] = "choose",
                [101] = "back",
            },
            save = "house_houseBuyMW_save",
            func = "house_houseBuyMW",
        },
        [MW.building_itemList] = {
            name = "building list",
            title = "object name (extra info)",
            choices = "building_itemListMW_choices",
            buttons = {
                [100] = "check",
                [101] = "close",
                [102] = "build",
            },
            save = "building_itemListMW_save",
            func = "building_itemListMW",
        },
        [MW.building_tutorial_itemGroup] = {
            name = "building panel",
            title = "choose an action group",
            choices = "building_itemGroupMW_choices",
            buttons = {
                [100] = "open",
                [101] = "close",
            },
            save = "building_itemGroupMW_save",
            func = "building_tutorial_itemGroupMW",
        },
        [MW.building_itemGroup] = {
            name = "building panel",
            title = "choose an action group",
            choices = "building_itemGroupMW_choices",
            buttons = {
                [100] = "open",
                [101] = "close",
            },
            save = "building_itemGroupMW_save",
            func = "building_itemGroupMW",
        },
        [MW.building_destroyList] = {
            name = "destroy object",
            title = "choose item to remove",
            choices = "building_destroyListMW_choices",
            buttons = {
                [100] = "look",
                [101] = "back",
                [102] = "destroy",
            },
            save = "building_itemGroupMW_save",
            func = "building_destroyListMW",
        },
        [MW.houseMW] = {
            name = "!house",
            title = "house_houseMW_title",
            choices = "house_houseMW_choices",
            buttons = {
                [100] = "choose",
                [101] = "close",
            },
            func = "house_houseMW",
        },
        [MW.houseOffers] = {
            name = "house offers",
            title = "choose what to do with house",
            choices = "house_houseOffersMW_choices",
            buttons = {
                [100] = "show size",
                [101] = "close",
                [102] = "decline",
                [103] = "buy",
            },
            func = "house_houseOffersMW",
        },
        [MW.building_wallGroups] = {
            name = "wall themes",
            title = "choose a theme",
            choices = "building_itemList_wallGroup_choices",
            buttons = {
                [100] = "choose",
                [101] = "back",
            },
            save = "building_itemGroupMW_save",
            func = "building_itemList_wallGroup",
        },
    }
}

centralSystem_registerTable(feature_building)

function house_startUp()
local loadBaseHousesToDB = false

    local function register_house(pos, houseT)
        if houseT.miniHousePos then return end
        local house = findItem(building_conf.miniHouseID, pos)
        
        if not house then return end
        house:setActionId(building_conf.houseBuyAID)
        house:setText("houseID", houseT.houseID)
        houseT.miniHousePos = pos
    end
    
    loadBuildingCatalog()
    addProfession(building_conf.professionT)
    
    if not db.query("SELECT * FROM `houseitems_containers` WHERE 1") then
        db.query("CREATE TABLE `houseitems_containers` ( `id` INT NOT NULL AUTO_INCREMENT, `containerID` INT(5) NOT NULL, `itemID` INT(5) NOT NULL, `itemAID` INT(5), `itemText` TEXT NOT NULL, `fluidType` INT(2), `count` INT(3) NOT NULL, `posx` INT(5) NOT NULL, `posy` INT(5) NOT NULL, `posz` INT(2) NOT NULL, PRIMARY KEY (`id`)) ENGINE = InnoDB;")
    end
    
    if not db.query("SELECT * FROM `houseitems` WHERE 1") then
        db.query("CREATE TABLE `houseitems` ( `id` INT NOT NULL AUTO_INCREMENT, `itemID` INT(5) NOT NULL, `itemAID` INT(5), `itemText` TEXT NOT NULL, `fluidType` INT(2), `count` INT(3) NOT NULL, `posx` INT(5) NOT NULL, `posy` INT(5) NOT NULL, `posz` INT(2) NOT NULL, PRIMARY KEY (`id`)) ENGINE = InnoDB;")
        loadBaseHousesToDB = true
    else
        building_loadHouseTiles()
    end
    
    if not db.query("SELECT * FROM `houseFloors` WHERE 1") then
        db.query("CREATE TABLE `houseFloors` ( `id` INT NOT NULL AUTO_INCREMENT, `itemID` INT(5) NOT NULL, `itemAID` INT(5), `posx` INT(5) NOT NULL, `posy` INT(5) NOT NULL, `posz` INT(2) NOT NULL, PRIMARY KEY (`id`)) ENGINE = InnoDB;")
    else
        local houseFloorData = db.storeQuery("SELECT * FROM `houseFloors` WHERE 1")
        
        repeat
            local itemID = DBNumberResultReader(houseFloorData, "itemID")
            if itemID then
                local itemAID = DBNumberResultReader(houseFloorData, "itemAID")
                local posx = DBNumberResultReader(houseFloorData, "posx")
                local posy = DBNumberResultReader(houseFloorData, "posy")
                local posz = DBNumberResultReader(houseFloorData, "posz")
                local pos = {x=posx, y=posy, z=posz}
                
                if itemAID and itemAID > 0 then
                    if not farming_loadPlant(pos, itemAID) then farming_startGrowing(pos, itemAID) end
                end
                createItem(itemID, pos, 1, itemAID)
            end
        until not result.next(houseFloorData)
        result.free(houseFloorData)
    end
    
    for houseID, houseT in pairs(houseList) do
        local houseTilePositions = createSquare(houseT.upCorner, houseT.downCorner)
        local houseRegistered = false
        local miniHouseRegistered = false
        
        if not houseT.houseID then houseT.houseID = houseID end
        for _, pos in pairs(houseTilePositions) do
            register_house(pos, houseT)
            if loadBaseHousesToDB then building_registerHouseTileSave(pos) end
        end
        
        houseT.totalCost = building_conf.houseCostPerTile * tableCount(houseTilePositions)
        houseT.weeklyCost = building_conf.houseWeeklyPaymentPerTile * tableCount(houseTilePositions)
        houseT.ownerNames = {}
    end
    building_saveHouseTiles()
end

function loadBuildingCatalog()
    local function error_missing(itemID, missingAttribute) return print("ERROR - missing "..missingAttribute.." in building_catalog["..itemID.."] = {}") end
    local function error_wrongValue(itemID, badValue, attribute) return print("ERROR - wrong value in building_catalog["..itemID.."] = {["..attribute.."] = "..badValue.."}") end
    
    local function registerToGroup(itemID, itemT)
        local attribute = "group"
        local groupName = itemT[attribute]
        if not groupName then return error_missing(itemID, attribute) end
        local groupT = building_groups[groupName]
        if not groupT then return error_wrongValue(itemID, groupName, attribute) end
        
        if groupName == "windows" or groupName == "doors" or groupName == "wall decorations" then
            local underItemID = itemT.underItemID
            if not underItemID then return error_missing(itemID, "underItemID") end
            if not groupT[underItemID] then groupT[underItemID] = {itemID} return end
            if not isInArray(groupT[underItemID], itemID) then table.insert(groupT[underItemID], itemID) end
        elseif groupName == "walls" then
            local semigroup = itemT.semigroup
            if not semigroup then return error_missing(itemID, "semigroup") end
            if not groupT[semigroup] then groupT[semigroup] = {itemID} return end
            if not isInArray(groupT[semigroup], itemID) then table.insert(groupT[semigroup], itemID) end
        elseif groupName ~= "plants" then
            if not isInArray(groupT, itemID) then table.insert(groupT, itemID) end
        end
    end
    
    local function registerLevelUpInfo(itemID, itemT)
        if not itemT.bigSV then return end
        local levelRequired = itemT.bigSV[SV.building_level]
        if not levelRequired then return end
        if itemT.group ~= "walls" and itemT.group ~= "items" and itemT.group ~= "floors" then return end
        local levelUpInfoT = building_conf.levelUpInfoT
        if not levelUpInfoT[levelRequired] then levelUpInfoT[levelRequired] = {} end
        local levelUpT = levelUpInfoT[levelRequired]
        local updateName = itemT.semigroup or ItemType(itemID):getName()
        
        if not isInArray(levelUpT, updateName) then table.insert(levelUpT, updateName) end
    end
    
    for itemID, itemT in pairs(building_catalog) do
        if itemT.req and itemT.req.itemID then itemT.req = {itemT.req} end
        if not itemT.failChance then itemT.failChance = 10 end
        if not itemT.itemID then itemT.itemID = itemID end
        registerLevelUpInfo(itemID, itemT)
        registerToGroup(itemID, itemT)
    end
end

function house_addHour()
local accountList = {} -- [accountID] = {playerList = {playerGUID}, houseID = INT, playerID = playerID}
local playerData = db.storeQuery("SELECT player_id, value FROM player_storage WHERE `key` = "..SV.player_houseID.." AND `value` > 0")

    for _, player in ipairs(Game:getPlayers()) do
        local houseID = getSV(player, SV.player_houseID)
        local accountID = player:getAccountId()
        
        if houseID > 0 then accountList[accountID] = {playerID = player:getId(), houseID = houseID} end
    end
    
    if playerData then
        repeat
            local playerGuid = result.getNumber(playerData, "player_id")
            local accountID = getAccountIDByGuid(playerGuid)
            
            if not accountList[accountID] then
                local houseID = result.getNumber(playerData, "value")
                accountList[accountID] = {playerList = {playerGuid}, houseID = houseID}
            elseif not accountList[accountID].playerID then
                if not accountList[accountID].playeList then accountList[accountID].playeList = {} end
                table.insert(accountList[accountID].playeList, playerGuid)
            end
        until not result.next(playerData)
        result.free(playerData)
    end
    
    for accountID, t in pairs(accountList) do
        local currentTime = getAccountSVT(accountID, SV.rentDuration, true)
        local newTime = currentTime - 3600
        local hoursLeft = math.ceil(newTime/3600)
        
        if hoursLeft > 0 and hoursLeft < 4 then
            if t.playerID then
                house_payRentMsg(t.playerID , hoursLeft, true)
            else
                for _, playerGuid in pairs(t.playerList) do house_payRentMsg(getPlayerNameByGUID(playerGuid), hoursLeft, true) end
            end
        elseif newTime < 1 then
            newTime = -1
            house_unregister(t.houseID)
        end
        setAccountSV(accountID, SV.rentDuration, newTime)
    end
    return true
end

function house_openPanel(player)
    if player:hasHouse() then return false, player:createMW(MW.houseMW) end
    if not house_openOffersMW(player) then player:sendTextMessage(GREEN, "You don't own a house and nobody is selling it to you either") end
end

function house_houseMW_title(player)
    local rentDuration = getSV(player, SV.rentDuration)
    local hoursLeft = math.ceil(rentDuration/3600)
    local hourStr = plural("hour", hoursLeft)
    local msg = "You have "..hourStr.." left to pay for your house rent"

    if hoursLeft < 24 then msg = "You have less than "..hourStr.." left to pay for your house rent or you will loose your house" end
    return msg
end

function house_houseMW_choices(player)
local houseID = building_getHouseID(player)
    if not houseID then return end
local choiceT = {}
local rentDuration = getSV(player, SV.rentDuration)
local hoursLeft = math.ceil(rentDuration/3600)
local addedRentDuration = building_conf.rentDurationInHours

    if hoursLeft < addedRentDuration * 3 then
        choiceT[1] = "pay "..building_getWeeklyCost(houseID).." coins for house rent to increase house owning duraion by "..addedRentDuration.." hours"
    end
    choiceT[2] = "house owners"
    choiceT[3] = "quest list"
    choiceT[4] = "sell house options"
    choiceT[5] = "show house size"
    choiceT[6] = "your house building level: "..player:getBuildingLevel()
    choiceT[7] = "your current house building experience ["..player:getBuildingExp().."/"..player:getBuildingTotalExpForLevel().."]"
    return choiceT
end

function house_houseMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    if choiceID == 7 or choiceID == 6 then return player:createMW(MW.houseMW) end
    if choiceID == 2 then return player:createMW(MW.house_owners) end
    if choiceID == 3 then return player:sendTextMessage(GREEN, "In current house feature can't allow friends to join house") end --player:createMW(MW.house_questList)
    if choiceID == 4 then return player:createMW(MW.house_sellOptions) end
    if choiceID == 5 then return house_showSize(building_getHouseID(player)) end
    if choiceID ~= 1 then return end
    
    if not player:removeMoney(building_getWeeklyCost(player)) then
        player:sendTextMessage(GREEN, "You don't have enough money with you to pay for the rent")
    else
        local addedRentDuration = building_conf.rentDurationInHours*3600
        addSV(player, SV.rentDuration, addedRentDuration)
    end
    player:createMW(mwID)
end

function house_ownersMW_choices(player)
local choiceT = {player:getName()}
    -- later it will check for more owners from database | actaully kinda did it already in house_getOwners() function
    return choiceT
end

function house_ownersMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.houseMW) end
    if choiceID == 255 then return end
local houseOwners = house_ownersMW_choices(player)
    
    if tableCount(houseOwners) > 1 then return house_unregister(player) end
    player:sendTextMessage(GREEN, "Can't leave house ownership if you are last person to own it. Choose a sell option instead")
    player:createMW(MW.house_sellOptions)
end

function house_sellOptionsMW_choices(player)
local choiceT = {}

    choiceT[1] = "sell house to specific person with command !houseSell 'playername', price (costs 10 coins)"
    choiceT[2] = "auction off your house on global market"
    choiceT[3] = "sell your house for "..building_getWeeklyCost(player).." coins"
    return choiceT
end

function house_sellOptionsMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.houseMW) end
    if choiceID == 255 then return end
    if choiceID == 1 then
        player:sendTextMessage(ORANGE, "Example how to sell the house: !houseSell "..player:getName()..", 400")
        return player:sendTextMessage(ORANGE, "You need 10 coins in your bag to use this command")
    end
   
    if choiceID == 2 then
        player:sendTextMessage(GREEN, "currently house auction is disabled")
        return player:createMW(mwID)
    end
    
    if choiceID == 3 then
        player:addMoney(building_getWeeklyCost(player))
        return house_unregister(player)
    end
end

-- housing functions
function house_miniHouse_onUse(player, item) return player:createMW(MW.houseBuy, building_getHouseID(item)) end

function house_buyHouse(player, houseID)
local houseT = building_getHouseT(houseID)

    if player:hasHouse() then return player:sendTextMessage(GREEN, "You already own a house") end
    if not player:removeMoney(houseT.totalCost) then return player:sendTextMessage(GREEN, "You don't have enough money to buy this house") end
    if not house_isBuyable(houseID) then return player:sendTextMessage(GREEN, "You were too late to buy this house") end
    house_register(player, houseID)
end

function house_register(player, houseID)
local rentDuration = (building_conf.rentDurationInHours + 1) * 60 * 60
local accountID = player:getAccountId()
local houseT = building_getHouseT(houseID)
    
    setAccountSV(accountID, SV.player_houseID, houseID)
    setAccountSV(accountID, SV.rentDuration, rentDuration)
    player:sendTextMessage(GREEN, "You successfully bough the house")
    houseT.ownerNames[1] = player:getName()
    removeItemFromPos(building_conf.miniHouseID, houseT.miniHousePos)
    building_registerHouseTileSave(houseT.miniHousePos)
end

function house_unregister(houseID)
    if type(houseID) == "userdata" then
        local player = houseID
        houseID = building_getHouseID(houseID)
        player:sendTextMessage(GREEN, "You no longer own a house")
        house_kickPlayer(player, player)
    end
local houseOwners = house_getOwners(houseID)
local houseT = building_getHouseT(houseID)
    
    houseT.ownerNames[1] = nil
    house_unregisterOffer(nil, houseID)
    for accountID, playerName in pairs(houseOwners) do
        local player = Player(playerName)
        if player then player:sendTextMessage(GREEN, "You no longer own a house") end
        setAccountSV(accountID, SV.player_houseID, -1)
        setAccountSV(accountID, SV.rentDuration, -1)
    end
    createItem(building_conf.miniHouseID, houseT.miniHousePos, 1, building_conf.houseBuyAID, nil, "houseID("..houseID..")")
end

function house_houseBuyMW_save(player, houseID) return houseID end

function house_houseBuyMW_choices(player, houseID)
local choiceT = {}

    choiceT[1] = "show house size"
    choiceT[2] = "housing tutorial"
    if getSV(player, SV.houseTutorialCompleted) == 1 then choiceT[3] = "buy house for "..building_getHouseCost(houseID).." coins" end
    return choiceT
end

function house_houseBuyMW(player, mwID, buttonID, choiceID, houseID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    if choiceID == 1 then return house_showSize(houseID) end
    if choiceID == 2 then return building_tutorial_enter(player) end
    if choiceID == 3 then return house_buyHouse(player, houseID) end
end

-- house selling feature
function house_openOffersMW(player)
local offerT = building_conf.houseOffers[player:getId()]
    if offerT then return true, player:createMW(MW.houseOffers) end
end

function house_houseOffersMW_choices(player)
local offerT = building_conf.houseOffers[player:getId()]
local choiceT = {}
local loopID = 0

    for houseID, t in pairs(offerT) do
        loopID = loopID + 1
        choiceT[loopID] = t.sellerName.." is selling house for "..t.sellPrice.." coins"
    end
    return choiceT
end

function house_houseOffersMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local offerT = building_conf.houseOffers[player:getId()]
local loopID = 0
local houseID
local sellPrice
local sellerName

    for houseID2, t in pairs(offerT) do
        loopID = loopID + 1
        if loopID == choiceID then
            houseID = houseID2
            sellPrice = t.sellPrice
            sellerName = t.sellerName
            break
        end
    end

    if buttonID == 100 then return house_showSize(houseID) end
    
    if buttonID == 102 then
        offerT[houseID] = nil
        doSendTextMessage(sellerName, GREEN, player:getName().." declined your offer to buy house for "..sellPrice.." coins")
        return player:createMW(MW.houseMW)
    end
    
    if buttonID == 103 then
        if not player:removeMoney(sellPrice) then return player:sendTextMessage(GREEN, "You dont have enough money to buy the house") end
        house_kickPlayer(sellerName, houseID)
        house_unregister(houseID)
        house_register(player, houseID)
        doSendTextMessage(sellerName, GREEN, "You sold your house for "..sellPrice.." coins")
    end
end

function house_sellHouse(player, param)
local split = param:split(",")
local targetName = split[1]
local sellPrice = tonumber(split[2])
local target = Player(targetName)
    
    if not target then return false, player:sendTextMessage(GREEN, targetName.." is not online") end
    if target:getId() == player:getId() then return false, player:sendTextMessage(GREEN, "Not sure what are your trying to do here...") end
    if target:hasHouse() then return false, player:sendTextMessage(GREEN, targetName.." already owns a house") end
    if not sellPrice or sellPrice < 1 then return false, player:sendTextMessage(GREEN, "ERROR - invalid sell price") end
    if not player:removeMoney(10) then return false, player:sendTextMessage(GREEN, "You missing 10 coins to send house selling information") end
    house_registerOffer(target, player, sellPrice)
end

function house_registerOffer(player, seller, sellPrice)
local playerID = player:getId()
    if not building_conf.houseOffers[playerID] then building_conf.houseOffers[playerID] = {} end
local offerT = building_conf.houseOffers[playerID]
local houseID = building_getHouseID(seller)
local sellerName = seller:getName()

    player:sendTextMessage(BLUE, sellerName.." is offering to sell a house to you for "..sellPrice.." coins")
    player:sendTextMessage(BLUE, "to see house offers use command: !house")
    player:sendTextMessage(BLUE, "offers can last up to 15 minutes")
    offerT[houseID] = {sellPrice = sellPrice, sellerName = sellerName}
    addEvent(house_unregisterOffer, 15*60*1000, playerID, houseID)
end

function house_unregisterOffer(playerID, houseID)
local offersT = building_conf.houseOffers

    if not playerID then
        for playerID, offerT in pairs(offersT) do
            for houseID2, t in pairs(offerT) do
                if houseID2 == houseID then building_conf.houseOffers[playerID][houseID] = nil end
            end
        end
    else
        local offerT = offersT[playerID]
        
        if not offerT then return end
        if houseID then offerT[houseID] = nil return end
        offersT[playerID] = nil
    end
end

-- extra house functions
function house_door_onUse(player, item)
local houseID = building_getHouseID(item:getPosition())

    if not player:hasHouse(player) or building_getHouseID(player) ~= houseID then
        local owners = house_getOwners(houseID)
        if tableCount(owners) > 0 then return player:sendTextMessage(GREEN, "You can't open this door. This house belongs to: "..tableToStr(owners, nil, true)) end
    end
    automaticDoor(player, item)
end

function house_kickPlayer(playerID, houseObject)
    local player = Player(playerID)
    if not player then return end
    local houseT = building_getHouseT(houseObject)
    if not houseT then return end
    if not isInRange(player:getPosition(), houseT.upCorner, houseT.downCorner) then return end

    local kickPos = houseT.kickPos or player:homePos()
    teleport(player, kickPos)
end

function house_checkRent(player)
    local currentTime = getSV(player, SV.rentDuration)
    local hoursLeft = math.ceil(currentTime/3600)

    if hoursLeft > 0 then house_payRentMsg(player:getId(), hoursLeft) end
end

function house_payRentMsg(playerID, hourLeft, urgent)
    local msg = "You have "..plural("hour", hourLeft).." left to pay for your house rent !"
    doSendTextMessage(playerID, GREEN, msg)
    if urgent then doSendTextMessage(playerID, BLUE, msg.."\n"..msg.."\n"..msg) end
end

function house_showSize(houseID)
    local houseT = building_getHouseT(houseID)
    local houseTilePositions = createSquare(houseT.upCorner, houseT.downCorner)

    for _, pos in ipairs(houseTilePositions) do
        if pos.x == houseT.upCorner.x or pos.y == houseT.upCorner.y or pos.x == houseT.downCorner.x or pos.y == houseT.downCorner.y then doSendMagicEffect(pos, {57, 57, 57}, 2000) end
    end
end

function house_kickOnLogin(player)
local playerPos = player:getPosition()
    
    for houseID, houseT in pairs(houseList) do
        if isInRange(playerPos, houseT.upCorner, houseT.downCorner) then
            if getSV(player, SV.player_houseID) == houseID then return true end
            local kickPos = houseT.kickPos or player:homePos()
            return teleport(player, kickPos)
        end
    end
end

-- building functions 
function building_useHammer(player, item, itemEx)
    if not player:hasHouse() then return end
local buildPos = itemEx:getPosition()
local houseT = building_getHouseT(player)

    if not isInRange(buildPos, houseT.upCorner, houseT.downCorner) then return end
    return player:createMW(MW.building_itemGroup, buildPos)
end

function Player.addBuildingExp(player, amount)
local newLevel = professions_addExp(player, amount, building_conf.professionT.professionStr)
    if not newLevel then return end
local updateT = building_conf.levelUpInfoT[newLevel] or {}
    
    for i, updateName in ipairs(updateT) do
        if i == 1 then player:sendTextMessage(BLUE, "you can now build new items:") end
        player:sendTextMessage(ORANGE, updateName)
    end
    player:sendTextMessage(GREEN, "Your building level increased!! Your house building level is now: "..newLevel)
end

local function createItemListByGroup(player, buildPos, groupT)
    local itemList = {}
    local loopID = 0
        
    local function checkItemT(itemT)
        if not itemT then return end
        if not compareSV(player, itemT.allSV, "==") then return end
        if not compareSV(player, itemT.bigSV, ">=") then return end
       -- if not player:hasHammerCharges(itemT.takeCharges) then return end
       -- if not player:hasShovelCharges(itemT.shovelCharges) then return end
        loopID = loopID + 1
        itemList[loopID] = itemT
    end
    
    for neededID, itemID in pairs(groupT) do
        if type(itemID) == "table" then
            if findItem(neededID, buildPos) then
                for _, itemID in pairs(itemID) do checkItemT(building_catalog[itemID]) end
            end
        else
            checkItemT(building_catalog[itemID])
        end
    end
    return itemList
end

function building_itemList_wallGroup_choices(player, buildPos)
    local choiceT = {}
    local loopID = 0

    local function canAddToChoiceT(itemID)
        local itemT = building_catalog[itemID]
        if not itemT then return end
        if not compareSV(player, itemT.allSV, "==") then return end
        if not compareSV(player, itemT.bigSV, ">=") then return end
        if not player:hasHammerCharges(itemT.takeCharges) then return end
        if not player:hasShovelCharges(itemT.shovelCharges) then return end
        return true
    end

    for groupName, idList in pairs(building_groups.walls) do
        for _, itemID in ipairs(idList) do
            if canAddToChoiceT(itemID) then
                loopID = loopID + 1
                choiceT[loopID] = groupName
                break
            end
        end
    end
    return choiceT
end

function building_itemList_wallGroup(player, mwID, buttonID, choiceID, buildPos)
    if buttonID == 101 then return player:createMW(MW.building_itemGroup, buildPos) end
    if choiceID == 255 then return end
    local choiceT = building_itemList_wallGroup_choices(player, buildPos)
    local groupName = choiceT[choiceID]
    local itemList = createItemListByGroup(player, buildPos, building_groups.walls[groupName])

    return player:createMW(MW.building_itemList, itemList, buildPos)
end

function building_itemListMW_choices(player, itemList)
    if not itemList then return end
    if itemList.itemID then itemList = {itemList} end
local choiceT = {}

    for ID, itemT in ipairs(itemList) do
        local itemName = itemT.itemName or ItemType(itemT.itemID):getName()
        local extraText = itemT.extraText
        
        if extraText then extraText = " ("..extraText..")" else extraText = "" end
        choiceT[ID] = itemName..extraText
    end
    return choiceT
end

function building_itemListMW_save(player, itemList, toPos) return {itemList = itemList, buildPos = toPos} end

function itemRequirementStrT(requirementsT)
    if not requirementsT then return {} end
    if requirementsT.itemID then requirementsT = {requirementsT} end
    local msgT = {}
    local loopID = 0

    for _, itemT in pairs(requirementsT) do
        local itemName = ItemType(itemT.itemID):getName()
        
        if itemT.itemID == farmingConf.seedID then itemName = farming_getSeedName(itemT.itemAID, itemName) end
        local extraText = ""
        
        if itemT.fluidType then
            if itemT.fluidType == 1 then extraText = " of water"
            elseif itemT.fluidType == 2 then extraText = " of blood"
            elseif itemT.fluidType == 4 then extraText = " of slime"
            elseif itemT.fluidType == 6 then extraText = " of cactus milk"
            elseif itemT.fluidType == 11 then extraText = " of oil"
            elseif itemT.fluidType == 19 then extraText = " of mud" end
        end
        
        local count = itemT.count or 1
        loopID = loopID + 1
        msgT[loopID] = plural(itemName, count)..extraText
    end
    return msgT
end

function itemRequirementStr(requirementsT)
    if not requirementsT then return "nothing" end
    if requirementsT.itemID then requirementsT = {requirementsT} end
local string = ""
local msgT = itemRequirementStrT(requirementsT)
    
    for _, msg in ipairs(msgT) do string = string..msg.."\n" end
    return string
end
    
local function createItemList(firstID, IDList)
local list = {firstID}

    for i, itemID in ipairs(IDList) do list[i+1] = itemID end
    return list
end

local function isWallWithDoor(itemID, noDoors)
    for wallID, doors in pairs(building_groups.doors) do
        if itemID == wallID then return createItemList(wallID, doors) end
        if not noDoors and isInArray(doors, itemID) then return createItemList(wallID, doors) end
    end
end

local function isWallWithWindow(itemID, noWindows)
    for wallID, windows in pairs(building_groups.windows) do
        if itemID == wallID then return createItemList(wallID, windows) end
        if not noWindows and isInArray(windows, itemID) then return createItemList(wallID, windows) end
    end
end

local function isWallWithDecoration(itemID, noDecos)
    for wallID, decos in pairs(building_groups["wall decorations"]) do
        if itemID == wallID then return createItemList(wallID, decos) end
        if not noDecos and isInArray(decos, itemID) then return createItemList(wallID, decos) end
    end
end

function building_itemListMW(player, mwID, buttonID, choiceID, saveT)
local buildPos = saveT.buildPos
    if buttonID == 101 then return getSV(player, SV.houseTutorialCompleted) == 1 and player:createMW(MW.building_itemGroup, buildPos) end
    if choiceID == 255 then return end
local itemList = saveT.itemList
local itemT = itemList[choiceID]
local requirementsT = itemT.req
local itemName = itemT.itemName or ItemType(itemT.itemID):getName()
    
    if requirementsT and requirementsT.itemID then requirementsT = {requirementsT} end

    if buttonID == 100 then
        local requirements = "List of items you need for "..itemName..":\n"
        local reqMsg = itemRequirementStr(requirementsT)
        local dialogItemID = itemT.dialogItemID or itemT.itemID
        
        if itemT.takeCharges and itemT.takeCharges > 0 then reqMsg = reqMsg.."\n+"..plural("charge", itemT.takeCharges).." from hammer" end
        if itemT.shovelCharges and itemT.shovelCharges > 0 then reqMsg = reqMsg.."\n+"..plural("charge", itemT.shovelCharges).." from shovel" end
        player:showTextDialog(dialogItemID, requirements..reqMsg)
        return player:createMW(mwID, itemList, buildPos)
    end
    
    if getSV(player, SV.building_noItemsNeeded) ~= 1 and not player:hasItems(requirementsT) then
        player:sendTextMessage(GREEN, "You don't have the required items in your bag")
        return player:createMW(mwID, itemList, buildPos)
    end
    
local wallList = isWallWithDoor(itemT.itemID)
    if not wallList then wallList = isWallWithWindow(itemT.itemID) end
    if not wallList then wallList = isWallWithDecoration(itemT.itemID) end
    
    if wallList then
        for _, itemID in ipairs(wallList) do
            if removeItemFromPos(itemID, buildPos, 1) then break end
        end
    end
    
    if getSV(player, SV.building_noItemsNeeded) ~= 1 then player:removeItemList(requirementsT) end
    doSendMagicEffect(buildPos, 27)
    
    if requirementsT then
        for _, itemT in pairs(requirementsT) do
            if itemT.itemID == 2005 then createItem(2005, player:getPosition(), itemT.count, nil, 0) end
        end
    end
    
    if getSV(player, SV.building_tutorialStage) > 0 then
        player:sendTextMessage(GREEN, "Look hammer to see what to do next")
        addSV(player, SV.building_tutorialStage, 1)
    elseif chanceSuccess(itemT.failChance) then
        player:sendTextMessage(GREEN, "You failed to create "..itemName)
        if not itemT.failID then return end
        return createItem(itemT.failID, buildPos, 1)
    end
    
    if itemT.extraText and itemT.extraText == "smithing" then
        player:addSmithingExp(itemT.exp)
    elseif itemT.extraText and itemT.extraText == "crafting" then
        player:addCraftingExp(itemT.exp)
    elseif itemT.extraText and itemT.extraText == "farming" then
        player:addFarmingExp(itemT.exp)
    else
        player:addBuildingExp(itemT.exp)
    end
    
    if itemT.group == "plants" then
        farming_startGrowing(buildPos, itemT.itemAID)
        createItem(Tile(buildPos):getGround():getId(), buildPos, 1, itemT.itemAID, nil, "farmingLevel("..player:getFarmingLevel()..")")
        building_registerFloor(itemT.itemID, itemT.itemAID, buildPos)
    else
        createItem(itemT.itemID, buildPos, 1, itemT.itemAID)
    end
    
    if itemT.group == "floors" then building_registerFloor(itemT.itemID, itemT.itemAID, buildPos) end        
local takeHammerCharges = itemT.takeCharges or 0
local takeShovelCharges = itemT.shovelCharges or 0

    tools_addHammerCharges(player, -takeHammerCharges)
    tools_addShovelCharges(player, -takeShovelCharges)
    building_registerHouseTileSave(buildPos)
end

function building_itemGroupMW_save(player, toPos) return toPos end

function building_itemGroupMW_choices(player, toPos)
local choiceT = {[8] = "remove something"} -- 1 = walls, 2 = window, 3 = door, 4 = items, 5 = floor, 6 = grow plants, 7 = wall decorations,
local tile = Tile(toPos)
local tileItems = tile:getItemList()
local ground = tile:getGround()
local canCreateWall = true
local canChangeFloor = true
local canCreateItems = true
local allowedFloorAIDT = {0, AID.other.closeDoor}

    if isInArray(allowedFloorAIDT, ground:getActionId()) then
        for _, itemID in ipairs(building_dontAllowWalls) do
            for _, itemT in ipairs(tileItems) do
                if itemT.itemID == itemID then canCreateWall = false break end
            end
            if not canCreateWall then break end
        end
        
        if canCreateWall then
            for _, itemT in ipairs(tileItems) do
                if isWallWithDoor(itemT.itemID, true) then choiceT[3] = "build door for wall" end
                if isWallWithWindow(itemT.itemID, true) then choiceT[2] = "build window for wall" end
                if isWallWithDecoration(itemT.itemID, true) then choiceT[7] = "wall decorations" end
                if isWallWithDoor(itemT.itemID) or isWallWithWindow(itemT.itemID) or isWallWithDecoration(itemT.itemID) then canCreateWall = false break end
            end
            
            if canCreateWall then
                for _, itemT in ipairs(tileItems) do
                    for groupName, idList in pairs(building_groups.walls) do
                        if isInArray(idList, itemT.itemID) then canCreateWall = false break end
                    end
                end
                if canCreateWall then choiceT[1] = "build walls" end
            end
        end
        
        for _, item in ipairs(tile:getItems()) do
            if item:isContainer() then canCreateItems = false break end
        end
        if canCreateItems then choiceT[4] = "build items" end
        if matchTableKey(building_groups.plants, ground:getId()) then choiceT[6] = "grow plants" end
    end
    
    if canChangeFloor then choiceT[5] = "change floor" end
    return choiceT
end

function building_itemGroupMW(player, mwID, buttonID, choiceID, buildPos)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
    if choiceID == 8 then return player:createMW(MW.building_destroyList, buildPos) end
local itemList

    if choiceID == 1 then return player:createMW(MW.building_wallGroups, buildPos)
    elseif choiceID == 2 then itemList = createItemListByGroup(player, buildPos, building_groups.windows)
    elseif choiceID == 3 then itemList = createItemListByGroup(player, buildPos, building_groups.doors)
    elseif choiceID == 4 then itemList = createItemListByGroup(player, buildPos, building_groups.items)
    elseif choiceID == 5 then itemList = createItemListByGroup(player, buildPos, building_groups.floors)
    elseif choiceID == 6 then itemList = createItemListByGroup(player, buildPos, building_groups.plants)
    elseif choiceID == 7 then itemList = createItemListByGroup(player, buildPos, building_groups["wall decorations"])  end
    return player:createMW(MW.building_itemList, itemList, buildPos)
end

local tempItemList = {}
function building_destroyListMW_choices(player, toPos)
local choiceT = {}
local tile = Tile(toPos)
local tileItems = tile:getItems()
local playerID = player:getId()
local floorID = tile:getGround():getId()
local tooManyChoices = false

    tempItemList[playerID] = {}
    for ID, item in ipairs(tileItems) do
        if ID > 243 then
            print("ERROR - tooManyChoices in building_destroyListMW_choices()")
            tooManyChoices = true
        else
            choiceT[ID] = "destroy one: "..item:getName()
            tempItemList[playerID][ID] = item:getId()
        end
    end
    
    if not tooManyChoices and isInArray(destroyableFloors, floorID) then
        tempItemList[playerID][244] = floorID
        choiceT[244] = "destroy floor"
    end
    return choiceT
end

function building_destroyListMW(player, mwID, buttonID, choiceID, buildPos)
local playerID = player:getId()
local itemID = tempItemList[playerID][choiceID]
    
    tempItemList[playerID] = nil
    if buttonID == 101 then return player:createMW(MW.building_itemGroup, buildPos) end
    if choiceID == 255 then return end
    if buttonID == 100 then
        player:showTextDialog(itemID, "no refunds")
        return player:createMW(mwID, buildPos)
    end
    if choiceID == 244 then
        doSendMagicEffect(buildPos, 27)
        createItem(231, buildPos, 1)
        building_registerFloor(231, 0, buildPos)
        return
    end
    if getSV(player, SV.building_tutorialStage) > 0 then addSV(player, SV.building_tutorialStage, 1) end
    doSendMagicEffect(buildPos, 27)
    removeItemFromPos(itemID, buildPos)
    building_registerHouseTileSave(buildPos)
end

function building_registerFloor(itemID, itemAID, buildPos)
    if not buildPos.x then return print("ERROR - position not given in building_registerFloor()") end
    local currentFloor = db.storeQuery("SELECT `id` FROM `houseFloors` WHERE `posx` = "..buildPos.x.." AND `posy` = "..buildPos.y.." AND `posz` = "..buildPos.z)
    itemAID = itemAID or 0

    if not currentFloor then
        db.query("INSERT INTO `houseFloors`(`itemID`, `itemAID`, `posx`, `posy`, `posz`) VALUES ("..itemID..", "..itemAID..", "..buildPos.x..", "..buildPos.y..", "..buildPos.z..")")
    else
        local id = DBNumberResultReader(currentFloor, "id")
        db.query("UPDATE `houseFloors` SET `itemID` = "..itemID..", `itemAID` = "..itemAID..", `posx` = "..buildPos.x..", `posy` = "..buildPos.y..", `posz` = "..buildPos.z.." WHERE `id` = "..id)
    end
end

function building_moveHouseItem(fromPos, toPos, fromObject, toObject)
    fromPos = getParentPos(fromObject, true)
    toPos = getParentPos(toObject, true)
    if building_getHouseID(fromPos) then building_registerHouseTileSave(fromPos) end
    if building_getHouseID(toPos) then building_registerHouseTileSave(toPos) end
end

local waitingForUpdateHouseTiles = {}
function building_registerHouseTileSave(position)
    if not comparePositionT(waitingForUpdateHouseTiles, position) then table.insert(waitingForUpdateHouseTiles, position) end
    stopAddEvent("houseTiles", "save")
    registerAddEvent("houseTiles", "save", 2*60*1000, {building_saveHouseTiles})
end

function building_saveHouseTiles()
    for _, pos in ipairs(waitingForUpdateHouseTiles) do building_saveHouseTile(pos) end
    waitingForUpdateHouseTiles = {}
end

function building_saveHouseTile(position)
local tileItems = Tile(position):getItems()
    
    building_clearHouseTileFromDB(position)
    for _, item in ipairs(tileItems) do building_saveHouseItemToDB(item) end
end

function building_clearHouseTileFromDB(position)
    db.query("DELETE FROM `houseitems` WHERE `posx` = "..position.x.." AND `posy` = "..position.y.." AND `posz` = "..position.z)
    db.query("DELETE FROM `houseitems_containers` WHERE `posx` = "..position.x.." AND `posy` = "..position.y.." AND `posz` = "..position.z)
end

function building_saveHouseItemToDB(item)
    if not item then return end
    local itemPos = item:getPosition()
    local itemText = item:getAttribute(TEXT)
    local itemID = item:getId()

    if item:isContainer(true) and itemID ~= 2591 then
        for x=0, item:getSize() do
            local item = item:getItem(x)
            if not item then break end
            
            db.query("INSERT INTO `houseitems_containers`(`containerID`, `itemID`, `itemAID`, `itemText`, `count`, `fluidType`, `posx`, `posy`, `posz`) VALUES ("..itemID..", "..item:getId()..", "..item:getActionId()..", '"..itemText.."', "..item:getCount()..", "..item:getFluidType()..", "..itemPos.x..", "..itemPos.y..", "..itemPos.z..")")
        end
    end
    db.query("INSERT INTO `houseitems`(`itemID`, `itemAID`, `itemText`, `count`, `fluidType`, `posx`, `posy`, `posz`) VALUES ("..itemID..", "..item:getActionId()..", '"..itemText.."', "..item:getCount()..", "..item:getFluidType()..", "..itemPos.x..", "..itemPos.y..", "..itemPos.z..")")
end

function building_loadHouseTiles()
    local houseItemData = db.storeQuery("SELECT * FROM `houseitems` WHERE 1")
    local houseContainerData = db.storeQuery("SELECT * FROM `houseitems_containers` WHERE 1")
        
    repeat
        local itemID = DBNumberResultReader(houseItemData, "itemID")
        if itemID and itemID ~= 0 then
            local posx = DBNumberResultReader(houseItemData, "posx")
            local posy = DBNumberResultReader(houseItemData, "posy")
            local posz = DBNumberResultReader(houseItemData, "posz")
            local itemAID = DBNumberResultReader(houseItemData, "itemAID")
            local fluidType = DBNumberResultReader(houseItemData, "fluidType")
            local count = DBNumberResultReader(houseItemData, "count")
            local itemText = result.getString(houseItemData, "itemText")
            createItem(itemID, {x=posx, y=posy, z=posz}, count, itemAID, fluidType, itemText)
        end
    until not result.next(houseItemData)
    result.free(houseItemData)
    
    repeat
        local containerID = DBNumberResultReader(houseContainerData, "containerID")
        
        if containerID and containerID ~= 0 then
            local posx = DBNumberResultReader(houseContainerData, "posx")
            local posy = DBNumberResultReader(houseContainerData, "posy")
            local posz = DBNumberResultReader(houseContainerData, "posz")
            local position = {x=posx, y=posy, z=posz}
            local container = findItem(containerID, position)
            
            if container then
                local itemID = DBNumberResultReader(houseContainerData, "itemID")
                local itemAID = DBNumberResultReader(houseContainerData, "itemAID")
                local fluidType = DBNumberResultReader(houseContainerData, "fluidType")
                local count = DBNumberResultReader(houseContainerData, "count")
                local itemText = result.getString(houseContainerData, "itemText")
                local item = createItem(itemID, position, count, itemAID, fluidType, itemText)
                item:moveTo(container)
            end
        end
    until not result.next(houseContainerData)
    result.free(houseContainerData)
end

-- get functions
function building_getHouseID(object)
    if not object then return end
    if type(object) == "number" then return object end
    if type(object) == "table" then
        if object.houseID then return object.houseID end
        if not object.x then return end
        for houseID, houseT in pairs(houseList) do
            if isInRange(object, houseT.upCorner, houseT.downCorner) then return houseT.houseID end
        end
        return
    end
    if type(object) ~= "userdata" then return end
    if object:isItem() then return getFromText("houseID", object:getAttribute(TEXT)) end
    if object:isPlayer() then 
        local houseID = getSV(object, SV.player_houseID)
        if houseID > 0 then return houseID end
    end
end

function building_getHouseT(object) return houseList[building_getHouseID(object)] end
function building_getHouseCost(object) return building_getHouseT(object).totalCost end
function building_getWeeklyCost(object) return building_getHouseT(object).weeklyCost end

function Item.isGround(item) return isInArray(building_groups.floors, item:getId()) end
function house_isBuyable(houseID) return findItem(building_conf.miniHouseID, building_getHouseT(houseID).miniHousePos) end

function Player.hasHouse(player, target)
    if not target then target = player end
    return getSV(target, SV.player_houseID) > 0
end

function house_getOwners(houseID)
    if not tonumber(houseID) then return end
    local playerData = db.storeQuery("SELECT `player_id` FROM `player_storage` WHERE `key` = "..SV.player_houseID.." AND `value` = "..houseID)
    local accountList = {} -- [accountID] = playerName
        
    if playerData then
        repeat
            local playerGuid = result.getNumber(playerData, "player_id")
            local accountID = getAccountIDByGuid(playerGuid)
            local playerName = getPlayerNameByGUID(playerGuid)
            
            if Player(playerName) then accountList[accountID] = playerName end
            if not accountList[accountID] then accountList[accountID] = playerName end
        until not result.next(playerData)
        result.free(playerData)
    end
    return accountList
end

function Player.getBuildingExp(player) return professions_getExp(player, building_conf.professionT.professionStr) end
function Player.getBuildingLevel(player) return professions_getLevel(player, building_conf.professionT.professionStr) end
function Player.getBuildingTotalExpForLevel(player) return professions_getTotalExpNeeded(player, building_conf.professionT.professionStr) end

-- building tutorial functions
function building_tutorial_reset(tutorialID)
local tutorialT = building_conf.tutorialRooms[tutorialID]
local upCorner = tutorialT.upCorner
local blueTilePos = {x = upCorner.x+1, y = upCorner.y+2, z = upCorner.z}
local brownTilePos = {x = upCorner.x+2, y = upCorner.y+1, z = upCorner.z}
local redTilePos = {x = upCorner.x+2, y = upCorner.y+3, z = upCorner.z}
local dirtTilePos = {x = upCorner.x+3, y = upCorner.y+2, z = upCorner.z}
    
    local function clearItems(pos)
        local tileItems = Tile(pos):getItems()
        for _, item in ipairs(tileItems) do item:remove() end
    end
    
    clearItems(blueTilePos)
    clearItems(brownTilePos)
    clearItems(redTilePos)
    clearItems(dirtTilePos)
    createItem(5573, blueTilePos, 1, AIDT.tutorialBlueTile)
    createItem(11145, brownTilePos, 1, AIDT.tutorialBrownTile)
    createItem(4398, redTilePos, 1, AIDT.tutorialRedTile)
end

function building_tutorial_enter(player)
    for tutorialID, t in ipairs(building_conf.tutorialRooms) do
        local tutorialPlayer = Player(t.playerID)
        
        if tutorialPlayer and getSV(t.playerID, SV.building_tutorialID) == -1 then tutorialPlayer = false end
        
        if not tutorialPlayer then
            building_tutorial_reset(tutorialID)
            t.playerID = player:getId()
            setSV(player, SV.building_tutorialID, tutorialID)
            setSV(player, SV.building_tutorialStage, 1)
            player:sendTextMessage(BLUE, "Welcome to housing tutorial")
            player:sendTextMessage(ORANGE, "In this small room you will learn how to build house and few general tips")
            player:sendTextMessage(ORANGE, "First of all, owning a house is very expensive so don't jump on it as fast as you can.")
            player:sendTextMessage(ORANGE, "After you buy house, every week you have to pay "..building_conf.houseWeeklyPaymentPerTile.." coin per house plot tile")
            player:sendTextMessage(ORANGE, "You can pay for the rent in house panel which opens with command !house")
            player:sendTextMessage(ORANGE, "If your house owning time runs out you loose the house.")
            player:sendTextMessage(ORANGE, "NB!! other players can take your things any time if they reach to them. So you need to create walls!")
            player:sendTextMessage(ORANGE, "To remind yourself what to do next, look Hammer")
            player:sendTextMessage(ORANGE, "TIP: ESC button closes item information, ENTER button opens item information")
            return teleport(player, t.downCorner)
        end
    end
    player:sendTextMessage(GREEN, "All tutorial rooms are in use, try again in few minutes")
end

function building_tutorial_leaveArea(player)
    if getSV(player, SV.building_tutorialID) < 1 then return end
    removeSV(player, SV.building_tutorialID)
    removeSV(player, SV.building_tutorialStage)
    return teleport(player, {x = 570, y = 657, z = 7})
end

function building_tutorial_lookHammer(player, item)
local stage = getSV(player, SV.building_tutorialStage)
local tutorialT = building_conf.tutorial[stage]
    
    if not tutorialT then
        setSV(player, SV.houseTutorialCompleted, 1)
        return player:sendTextMessage(GREEN, "housing tutorial completed. You can now buy yourself a house!")
    end
    player:sendTextMessage(BLUE, tutorialT.stageMsg)
    return player:sendTextMessage(ORANGE, tutorialT.tipMsg)
end

function building_tutorial_useHammer(player, item, itemEx)
    if itemEx:isCreature() then return end
local stage = getSV(player, SV.building_tutorialStage)
local tutorialT = building_conf.tutorial[stage]

    if not tutorialT then return player:sendTextMessage(GREEN, "housing tutorial completed") end
    if tutorialT.targetTileAID ~= itemEx:getActionId() then return player:sendTextMessage(GREEN, tutorialT.tipMsg) end
    if stage == 5 then return player:createMW(MW.building_tutorial_itemGroup, itemEx:getPosition()) end
    player:createMW(MW.building_itemList, tutorialT.itemList, itemEx:getPosition())
end

function building_tutorial_itemGroupMW(player, mwID, buttonID, choiceID, buildPos)
    if buttonID == 101 then return end
    if choiceID == 255 then return end
local stage = getSV(player, SV.building_tutorialStage)
local tutorialT = building_conf.tutorial[stage]

    if stage == 4 then
        if choiceID ~= 2 then return player:sendTextMessage(GREEN, "You were suppose to make window for wall") end
        return player:createMW(MW.building_itemList, tutorialT.itemList, buildPos)
    elseif stage == 5 then
        if choiceID == 8 then return player:createMW(MW.building_destroyList, buildPos) end
        return player:sendTextMessage(GREEN, "You were suppose to destroy an item")
    elseif stage == 6 then
        if choiceID ~= 6 then return player:sendTextMessage(GREEN, "You were suppose to grow a plant on the dirt") end
        return player:createMW(MW.building_itemList, tutorialT.itemList, buildPos)
    end
end