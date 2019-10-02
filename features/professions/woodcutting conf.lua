--[[    woodCuttingConf guide
    defaults = {                            table where any key can have default value
        stumpID = INT,
        growTime = INT,
        materialID = INT,
        exp = INT,
        takeCharge = INT,
    },
    
    trees = {
        [treeID] = {
            stumpID = INT or defaults       
            growTime = INT or defaults      time in milliseconds | how long it takes to grow back for tree
            materialID = INT or defaults    what you get from cutting down
            exp = INT or defaults           how much experience cutting down tree gives
            takeCharge = INT or defaults    how many tool charges it takes to cut
            --itemID = treeID               ordered by how many charges they take
        }
    },
    
    levelChances = {                        how many materials player can get per cut
        [woodCutting level INT] = {
            [amount] = chance
        }
        formulas = {                        for each level player is higher, formulas is recalculated
            [INT] = {                       the base table to add those formulas. INT is the key for levelChances[INT]
                [amount] = INT              modifier for the log amount.
            }
        }
    },
    
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    }
]]

woodCuttingConf = {
    defaults = {
        stumpID = 8786,
        growTime = 60*10*1000,
        materialID = ITEMID.materials.log,
        exp = 1,
        takeCharge = 1,
    },
    
    trees = {
        [2700] = {exp = 10},
        [2701] = {exp = 14, takeCharge = 2},
        [2704] = {exp = 21, takeCharge = 4},
        [2706] = {exp = 21, takeCharge = 4},
        [2712] = {exp = 37, takeCharge = 5},
        [7024] = {exp = 37, takeCharge = 5},
        [2705] = {exp = 52, takeCharge = 6},
        [2705] = {exp = 52, takeCharge = 6},
        [2703] = {exp = 90, takeCharge = 7},
        [2708] = {exp = 143, takeCharge = 8},
        [2707] = {exp = 176, takeCharge = 9},
        [2702] = {exp = 194, takeCharge = 10},
        [2711] = {exp = 228, takeCharge = 11},
    },
    
    levelChances = {
        [0] = {[1] = 100},
        [1] = {
            [0] = 20,
            [1] = 80,
            [2] = 20,
            [3] = 5,
        },
        formulas = {
            [1] = {
                [0] = -2,
                [1] = -5,
                [2] = 5,
                [3] = 2,
            }
        },
    },
    
    professionT = {
        professionStr = "woodCutting",
        expSV = SV.woodCuttingExp,
        levelSV = SV.woodCuttingLevel,
        mwID = MW.woodCutting,
    }
}

local feature_woodCutting = {
    startUpFunc = "woodCutting_startUp",
    modalWindows = {
        [MW.woodCutting] = {
            name = "woodcutting profession",
            title = "woodCuttingMW_title",
            choices = {
                [1] = "log amount chances",
                [2] = "how many charges each tree takes"
            },
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "woodCuttingMW",
            say = "*checking woodcutting profession*",
        },
        [MW.treeCharges] = {
            name = "woodcutting profession",
            title = "List of trees you can chop down",
            choices = "woodCutting_treeChargesMW_choices",
            buttons = {
                [100] = "show tree",
                [101] = "back",
            },
            func = "woodCutting_treeChargesMW",
        }
    }
}

centralSystem_registerTable(feature_woodCutting)

function woodCutting_startUp()
local treesByCharge = {}

    for treeID, treeT in pairs(woodCuttingConf.trees) do
        if not treeT.stumpID and woodCuttingConf.defaults.stumpID then treeT.stumpID = woodCuttingConf.defaults.stumpID end
        if not treeT.materialID and woodCuttingConf.defaults.materialID then treeT.materialID = woodCuttingConf.defaults.materialID end
        if not treeT.growTime and woodCuttingConf.defaults.growTime then treeT.growTime = woodCuttingConf.defaults.growTime end
        if not treeT.exp and woodCuttingConf.defaults.exp then treeT.exp = woodCuttingConf.defaults.exp end
        if not treeT.takeCharge and woodCuttingConf.defaults.takeCharge then treeT.takeCharge = woodCuttingConf.defaults.takeCharge end
        treesByCharge[treeID] = {treeID = treeID, charge = treeT.takeCharge}
        treeT.itemID = treeID
    end
    
    treesByCharge = sortByTableValue(treesByCharge, "low", "charge")
    for i, t in ipairs(treesByCharge) do woodCuttingConf.trees[t.treeID].ID = i end
    addProfession(woodCuttingConf.professionT)
end