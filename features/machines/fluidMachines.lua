function wineMachineInForest(player, item)
    local testTubePos = {x = 692, y = 553, z = 7}
    local potionStandPos = {x = 689, y = 553, z = 7}
    local potionStand = findItem(7935, potionStandPos)
    local testTube = findItem(7934, testTubePos)
    
    if not potionStand or not testTube then return print("wineMachineInForest() doesn't work anymore") end

    local machinePosT = {{x = 691, y = 553, z = 7}, {x = 690, y = 553, z = 7}}
    local itemText = testTube:getAttribute(TEXT)
    local testTubeMaterial = getFromText("material", itemText)
    local potionID = potionStand:getId()
    
    for _, pos in pairs(machinePosT) do doSendMagicEffect(pos, {12, 31}) end
    testTube:transform(testTube:getId(), 0)
    
    if not testTubeMaterial then return end
    testTube:setText("material")
    
    if testTubeMaterial == "blueberry" then
        potionStand:transform(potionID, FLUID_WINE)
        createItem(2016, potionStandPos, 1, nil, FLUID_WINE):decay()
    else
        potionStand:transform(potionID, FLUID_FRUIT)
        createItem(2016, potionStandPos, 1, nil, FLUID_FRUIT):decay()
    end
end

function beerMachineInForest(player, item)
    local testTubePos = {x = 689, y = 555, z = 7}
    local potionStandPos = {x = 689, y = 553, z = 7}
    local potionStand = findItem(7935, potionStandPos)
    local testTube = findItem(7934, testTubePos)
    
    if not potionStand or not testTube then return print("beerMachineInForest() doesn't work anymore") end

    local machinePos = {x = 689, y = 554, z = 7}
    local itemText = testTube:getAttribute(TEXT)
    local testTubeMaterial = getFromText("material", itemText)
    local potionID = potionStand:getId()
    
    doSendMagicEffect(machinePos, {12, 31})
    testTube:transform(testTube:getId(), 0)
    
    if not testTubeMaterial then return end
    testTube:setText("material")
    
    if testTubeMaterial == "apple" then
        potionStand:transform(potionID, FLUID_BEER)
        createItem(2016, potionStandPos, 1, nil, FLUID_BEER):decay()
    else
        potionStand:transform(potionID, FLUID_FRUIT)
        createItem(2016, potionStandPos, 1, nil, FLUID_FRUIT):decay()
    end
end

function potionStand(player, item, itemEx)
    if not itemEx then return end
    if itemEx:isPlayer() then return player:sendTextMessage(GREEN, "Put it in vial first") end
    local fluidType = item:getFluidType()
    if fluidType == 0 then return end
    local itemExID = itemEx:getId()

    item:transform(item:getId(), 0)
    if itemExID ~= 2006 then return createItem(2016, itemEx:getPosition(), 1, nil, fluidType):decay() end
    itemEx:transform(itemExID, fluidType)
end

function testTube(player, item, itemEx)
    if not itemEx or itemEx:isPlayer() then return end
    local materialName = itemEx:getName():lower()
    local fluid = 0

    if materialName == "blueberry" then
        fluid = FLUID_WATER
    elseif materialName == "apple" then
        fluid = FLUID_BLOOD
    elseif materialName == "carrot" then
        fluid = FLUID_FRUIT
        player:sendTextMessage(GREEN, "Secret formula found, but not yet used anywhere in game")
    end
    
    if fluid < 1 then return end
    item:setText("material", materialName)
    item:transform(item:getId(), fluid)
    itemEx:remove(1)
end