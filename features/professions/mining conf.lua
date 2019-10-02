--[[    miningConf guide
    defaults = {                        table where any key can have default value
        exp = INT
    },
    
    brickStones = {INT}                 list of items what pickaxe can destroy for 1 charge and in return drop brick
    miningOres = {INT},                 list of items where you can get ores
    depletedOres = {INT},               list of items which miningOres can turn into
    oreSpawnTime = INT,                 in milliseconds how long depleted ore turns into mining ore
    
    gemChance = INT,                    % chance to get random gem
    gemChangePerLevel = INT,            % increased per mining level
    gems = {INT},                       list of gemID's | bonus items you can get from mining
    
    ores = {                            list of minerals you can get from mining ore
        [itemID] = {
            exp = INT or defaults       how much experience yields mining that ore
            -- automatic v
            itemID = INT,               same with tabe key
            ID = INT                    choiceID for modal window
        },
    },
    
    levelChances = {                     chance to get what ore
        [mining level INT] = {
            [itemID] = chance
        }
        formulas = {                     for each level player is higher, chance formula is recalculated
            [INT] = {                    the base table to add those formulas. INT is the key for levelChances[INT]
                [amount] = INT           modifier for the mineral/ore amount
            }
        }
    },
    
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    },
]]

miningConf = {
    defaults = {
        exp = 1,
    },
    
    brickStones = {3666, 3667, 3668, 1357, 3609, 3616, 3615, 3670, 3607},
    miningOres = {22142, 22143, 22144},
    depletedOres = {1356, 1357, 1358, 1359},
    oreSpawnTime = 15*60*1000,
    
    gemChance = 10,
    gemChangePerLevel = 2,
    gems = {2147, 9970, 2150, 2146, 2149, 8305},
    
    ores = {
        [5880] = {exp = 10},
        [5888] = {exp = 30},
        [5887] = {exp = 100},
        [13862] = {exp = 250},
    },
    
    levelChances = {
        [0] = {[5880] = 100},
        [1] = {
            [5880] = 80,
            [5888] = 20,
        },
        [2] = {
            [5880] = 70,
            [5888] = 20,
            [5887] = 10,
        },
        [3] = {
            [5880] = 60,
            [5888] = 15,
            [5887] = 10,
            [13862] = 5,
        },
        
        formulas = {
            [3] = {
                [5880] = 5,
                [5888] = 8,
                [5887] = 12,
                [13862] = 15,
            }
        },
    },
    
    professionT = {
        professionStr = "mining",
        expSV = SV.miningExp,
        levelSV = SV.miningLevel,
        mwID = MW.mining,
    }
}

local feature_mining = {
    startUpFunc = "mining_startUp",
    modalWindows = {
        [MW.mining] = {
            name = "mining profession",
            title = "miningMW_title",
            choices = {
                [1] = "minerals you can mine",
            },
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "miningMW",
            say = "*checking mining profession*",
        },
    }
}

centralSystem_registerTable(feature_mining)

function mining_startUp()
local loopID = 0

    for oreID, oreT in pairs(miningConf.ores) do
        if not oreT.exp and woodCuttingConf.defaults.exp then oreT.exp = miningConf.defaults.exp end
        loopID = loopID + 1
        oreT.ID = loopID
        oreT.itemID = oreID
    end
    addProfession(miningConf.professionT)
end