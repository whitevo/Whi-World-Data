--[[
    maxDeathRegisters = INT,        how many deaths will be saved to database
    ignoreItemsOnLoss = {INT}       list of itemID's not placed on players body
    deathAreas = {                  linked to central system
        upCorner = POS
        downCorner = POS
        func = STR
    }
]]

death_conf = {
    maxDeathRegisters = 5,
    ignoreItemsOnLoss = {},
    deathAreas = {},
}
print("deathSystem loaded..")