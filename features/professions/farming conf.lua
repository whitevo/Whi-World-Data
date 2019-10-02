--[[ farmingConf guide
    seedID = INT                                itemID for seed
    findSeedLevelMultiplier = INT               findSeedLevelMultiplier * player:getFarmingLevel()
    growLevelMultiplier = INT                   failChance = failChance - farmingLevel * growLevelMultiplier
    grassTileGrowBonus = INT                    if its grown on grass then failChance = failChance - grassTileGrowBonus 
    herbRespawnChance = INT                     chance for herb to spawn back if its taken from house
    treeRespawnChance = INT                     chance for tree to spawn back if its chopped from house
    treeSeedRespawnMin = INT                    when you can try to find new seed from tree again.
    
    nurture = {                                 itemTexts what decrease failChance
        [STR] = INT,                            STR = itemText key | INT = amount which is removed
    },
    
    mudTiles = {INT},                           itemID for all mud tiles
    grassTiles = {INT},                         itemID for all grass tiles
    growingPlants = {INT},                      all plants what are at growing stage and can be watered
    
    growT = {
        [INT] = {                               seedAID
            plantID = {INT} or "herbID"         "herbID" == herbs_getHerbT(seedAID).herbID
            backUpAID = INT,                    actionID what is placed on houseTileFloors when herb/tree is taken/chopped. To let ppl know what spawns back there
            chanceToGet = INT or 50
            isTree = false                      as default all considered as herbs
            floorID = {INT} or {mud-, grass-}   required floorID to grow the plant
            farmingExp = INT or 0                
            shovelCharges = INT or 1            if needs shovel to make create plants
            allSV = {[SV] = INT},
            bigSV = {[SV] = INT},
            
            stages = {                          stages to fully grow to plant
                [INT] = {                       stageID in ipairs
                    growTimeMin = INT or 10     how long it takes from seed or previous stage to get grow up
                    itemID = {INT} or plantID   what is the itemID of new plant | (itemText = seedAID(INT))
                    itemAID = INT               if plantID == "herbID" then INT = herbs_getHerbT(seedAID).herbAID
                    failID = {INT},             if plant fails to grow up
                    failChance = INT or 20      default failChance
                    --nextStageID = INT         if not itemID used manually then doesn't create nextStageID
                    --stageID = INT             table key
                },
            },
            
            --seedAID = INT
            --name = STR                        ItemType(treeID):getName() or herbName
            --choiceID = INT                    unique ID for each growT for modalWindow use
            --reqT = {{itemID = 13196}, {itemID = farmingConf.itemID, itemAID = seedAID}}
        }
    },
    
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    },
    
    levelUpMessages = {             generated based of craftingMaterials bigSV[SV.craftingLevel]
        [INT] = {STR},              INT = level which was achieved. STR = messages they will receive
    },
]]
local AIDT = AID.potions
local farmingAID = AID.farming
local firTreeStages = {
    [1] = {growTimeMin = 20, failID = 11439, itemID = 11045},
    [2] = {growTimeMin = 60, failID = 2770, itemID = 2768},
    [3] = {growTimeMin = 120, failID = 2710},
}
local hardWoodStages = {
    [1] = {growTimeMin = 20, failID = 11439, itemID = 11045},
    [2] = {growTimeMin = 60, failID = 11565, itemID = 2779},
    [3] = {growTimeMin = 120, failID = 2709},
}
local hardWoodStages2 = {
    [1] = {growTimeMin = 20, failID = 11439, itemID = 11045},
    [2] = {growTimeMin = 60, failID = 11565, itemID = 2779},
    [3] = {growTimeMin = 120, failID = 2720},
}
local smallHerbStages = {
    [1] = {growTimeMin = 10, failID = 11566, itemID = {21190, 21191}, failChance = 20},
    [2] = {growTimeMin = 30, failID = 11566, failChance = 30},
}
local bigHerbStages = {
    [1] = {growTimeMin = 10, failID = 11566, itemID = {21190, 21191}, failChance = 20},
    [2] = {growTimeMin = 30, failID = 2784, failChance = 30},
}

farmingConf = {
    seedID = 2157,
    findSeedLevelMultiplier = 4,
    growLevelMultiplier = 2,
    grassTileGrowBonus = 5,
    herbRespawnChance = 90,
    treeRespawnChance = 90,
    treeSeedRespawnMin = 15,
    
    nurture = {
        watered = 5,
    },
    mudTiles = {11146},
    grassTiles = {4527},
    growingPlants = {11045, 2768, 21190, 21191, 17746, 17752, 17743, 17741, 17742},
    
    growT = {
        [farmingAID.firTree_seed] = {
            plantID = 2700,
            backUpAID = farmingAID.firTree_backUp,
            farmingExp = 10,
            isTree = true,
            stages = firTreeStages
        },
        [farmingAID.sycamoreTree_seed] = {
            plantID = 2701,
            backUpAID = farmingAID.sycamoreTree_backUp,
            farmingExp = 10,
            isTree = true,
            stages = hardWoodStages,
        },
        [farmingAID.redMapleTree_seed] = {
            plantID = 2704,
            backUpAID = farmingAID.redMapleTree_backUp,
            bigSV = {[SV.farmingLevel] = 1},
            farmingExp = 15,
            isTree = true,
            stages = hardWoodStages,
        },
        [farmingAID.yellowMapleTree_seed] = {
            plantID = 2706,
            backUpAID = farmingAID.yellowMapleTree_backUp,
            bigSV = {[SV.farmingLevel] = 2},
            farmingExp = 15,
            isTree = true,
            stages = hardWoodStages,
        },
        [farmingAID.pineTree_seed] = {
            plantID = {2712, 7024},
            backUpAID = farmingAID.pineTree_backUp,
            bigSV = {[SV.farmingLevel] = 2},
            farmingExp = 25,
            chanceToGet = 20,
            isTree = true,
            stages = hardWoodStages,
        },
        [farmingAID.pearTree_seed] = {
            plantID = 2705,
            backUpAID = farmingAID.pearTree_backUp,
            bigSV = {[SV.farmingLevel] = 2},
            farmingExp = 25,
            isTree = true,
            stages = hardWoodStages,
        },
        [farmingAID.plumTree_seed] = {
            plantID = 2703,
            backUpAID = farmingAID.plumTree_backUp,
            bigSV = {[SV.farmingLevel] = 3},
            farmingExp = 40,
            isTree = true,
            stages = hardWoodStages2,
        },
        [farmingAID.beechTree_seed] = {
            plantID = 2707,
            backUpAID = farmingAID.beechTree_backUp,
            bigSV = {[SV.farmingLevel] = 3},
            farmingExp = 40,
            isTree = true,
            stages = firTreeStages,
        },
        [farmingAID.poplarTree_seed] = {
            plantID = 2708,
            backUpAID = farmingAID.poplarTree_backUp,
            bigSV = {[SV.farmingLevel] = 3},
            farmingExp = 40,
            chanceToGet = 40,
            isTree = true,
            stages = firTreeStages,
        },
        [farmingAID.willowTree_seed] = {
            plantID = 2702,
            backUpAID = farmingAID.willowTree_backUp,
            bigSV = {[SV.farmingLevel] = 4},
            farmingExp = 80,
            chanceToGet = 30,
            isTree = true,
            stages = hardWoodStages2,
        },
        [farmingAID.dwarfTree_seed] = {
            plantID = 2711,
            backUpAID = farmingAID.dwarfTree_backUp,
            bigSV = {[SV.farmingLevel] = 5},
            farmingExp = 190,
            chanceToGet = 20,
            isTree = true,
            stages = hardWoodStages2,
        },
        [AID.herbs.flysh_seed] = {
            backUpAID = AID.herbs.flysh_backUp,
            chanceToGet = 30,
            floorID = 4695,
            farmingExp = 80,
            bigSV = {[SV.farmingLevel] = 3},
            stages = {
                [1] = {itemID = 17746, failID = {17934, 17935, 17937, 17938}, failChance = 20},
                [2] = {failID = {17934, 17935, 17937, 17938}, failChance = 30},
            },
        },
        [AID.herbs.shadily_gloomy_shroom_seed] = {
            backUpAID = AID.herbs.shadily_gloomy_shroom_backUp,
            chanceToGet = 30,
            floorID = 4695,
            farmingExp = 80,
            bigSV = {[SV.farmingLevel] = 3},
            stages = {
                [1] = {itemID = {17752, 17743}, failID = {17934, 17935, 17937, 17938}, failChance = 20},
                [2] = {failID = {17934, 17935, 17937, 17938}, failChance = 30},
            },
        },
        [AID.herbs.xuppeofron_seed] = {
            backUpAID = AID.herbs.xuppeofron_backUp,
            chanceToGet = 70,
            farmingExp = 80,
            bigSV = {[SV.farmingLevel] = 3},
            stages = hardWoodStages,
        },
        [AID.herbs.mobberel_seed] = {
            backUpAID = AID.herbs.mobberel_backUp,
            farmingExp = 70,
            bigSV = {[SV.farmingLevel] = 2},
            stages = smallHerbStages,
        },
        [AID.herbs.iddunel_seed] = {
            backUpAID = AID.herbs.iddunel_backUp,
            farmingExp = 70,
            bigSV = {[SV.farmingLevel] = 2},
            stages = smallHerbStages,
        },
        [AID.herbs.urreanel_seed] = {
            backUpAID = AID.herbs.urreanel_backUp,
            farmingExp = 70,
            bigSV = {[SV.farmingLevel] = 2},
            stages = smallHerbStages,
        },
        [AID.herbs.ozeogon_seed] = {
            backUpAID = AID.herbs.ozeogon_backUp,
            farmingExp = 70,
            bigSV = {[SV.farmingLevel] = 2},
            stages = smallHerbStages,
        },
        [AID.herbs.dagosil_seed] = {
            backUpAID = AID.herbs.dagosil_backUp,
            chanceToGet = 60,
            farmingExp = 30,
            bigSV = {[SV.farmingLevel] = 1},
            stages = smallHerbStages,
        },
        [AID.herbs.brirella_seed] = {
            backUpAID = AID.herbs.brirella_backUp,
            chanceToGet = 60,
            farmingExp = 20,
            bigSV = {[SV.farmingLevel] = 1},
            stages = smallHerbStages,
        },
        [AID.herbs.eaplebrond_seed] = {
            backUpAID = AID.herbs.eaplebrond_backUp,
            chanceToGet = 80,
            farmingExp = 10,
            stages = smallHerbStages,
        },
        [AID.herbs.golden_spearmint_seed] = {
            backUpAID = AID.herbs.golden_spearmint_backUp,
            chanceToGet = 80,
            farmingExp = 10,
            stages = smallHerbStages,
        },
        [AID.herbs.jesh_mint_seed] = {
            backUpAID = AID.herbs.jesh_mint_backUp,
            chanceToGet = 50,
            farmingExp = 40,
            bigSV = {[SV.farmingLevel] = 2},
            stages = bigHerbStages,
        },
        [AID.herbs.eaddow_seed] = {
            backUpAID = AID.herbs.eaddow_backUp,
            chanceToGet = 50,
            farmingExp = 40,
            bigSV = {[SV.farmingLevel] = 2},
            stages = {
                [1] = {itemID = {17741, 17742}, failID = {17934, 17935, 17937, 17938}, failChance = 20},
                [2] = {failID = {17934, 17935, 17937, 17938}, failChance = 30},
            },
        },
        [AID.herbs.oawildory_seed] = {
            backUpAID = AID.herbs.oawildory_backUp,
            chanceToGet = 50,
            farmingExp = 40,
            bigSV = {[SV.farmingLevel] = 2},
            stages = smallHerbStages,
        },
        [AID.herbs.stranth_seed] = {
            backUpAID = AID.herbs.stranth_backUp,
            chanceToGet = 50,
            farmingExp = 40,
            bigSV = {[SV.farmingLevel] = 2},
            stages = bigHerbStages,
        },
    },
    
    professionT = {
        professionStr = "farming",
        expSV = SV.farmingExp,
        levelSV = SV.farmingLevel,
        mwID = MW.farming,
    }
}
local feature_farming = {
    startUpFunc = "farming_startUp",
    startUpPriority = 1,
    IDItems_onMove = {
        [13196] = {funcStr = "farming_fertilizeMud"},
    },
    modalWindows = {
        [MW.farming] = {
            name = "farming profession",
            title = "farmingMW_title",
            choices = {
                [1] = "herbs",
                [2] = "trees",
            },
            buttons = {
                [100] = "show",
                [101] = "close",
            },
            func = "farmingMW",
            say = "*checking farming profession*",
        },
        [MW.farming_herbs] = {
            name = "farming herbs",
            title = "farmingMW_title",
            choices = "farming_herbsMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "farming_herbsMW",
        },
        [MW.farming_trees] = {
            name = "farming trees",
            title = "farmingMW_title",
            choices = "farming_treesMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "farming_treesMW",
        },
        
    }
}

centralSystem_registerTable(feature_farming)

function farming_startUp()
local levelUpMessages = {}
local defaultFloorIDT = {}
local choiceID = 0

    for _, floorID in ipairs(farmingConf.mudTiles) do table.insert(defaultFloorIDT, floorID) end
    for _, floorID in ipairs(farmingConf.grassTiles) do table.insert(defaultFloorIDT, floorID) end
    addProfession(farmingConf.professionT)
    
    for seedAID, growT in pairs(farmingConf.growT) do
        local isHerb = false
        if not growT.chanceToGet then growT.chanceToGet = 50 end
        if not growT.shovelCharges then growT.shovelCharges = 1 end
        if not growT.farmingExp then growT.farmingExp = 0 end
        if growT.isTree then AIDItems_onLook[seedAID] = {funcStr = "farming_treeSeedOnLook"} end
        if not growT.floorID then growT.floorID = defaultFloorIDT end
        if type(growT.floorID) ~= "table" then growT.floorID = {growT.floorID} end
        if type(growT.failID) ~= "table" then growT.failID = {growT.failID} end
        
        if not growT.plantID or type(growT.plantID) == "string" then
            local herbT = herbs_getHerbT(seedAID)
            isHerb = true
            growT.plantID = {herbT.itemID}
            herbT.chanceToGet = growT.chanceToGet
            growT.name = herbT.name
        elseif type(growT.plantID) ~= "table" then
            growT.plantID = {growT.plantID}
        end
        
        choiceID = choiceID + 1
        growT.seedAID = seedAID
        growT.choiceID = choiceID
        if not growT.name then growT.name = ItemType(growT.plantID[1]):getName() end
        growT.reqT = {{itemID = 13196}, {itemID = farmingConf.seedID, itemAID = seedAID}}
        
        for _, floorID in ipairs(growT.floorID) do
            if not building_groups.plants[floorID] then building_groups.plants[floorID] = {} end
            for _, plantID in ipairs(growT.plantID) do table.insert(building_groups.plants[floorID], plantID) end
            building_catalog[growT.plantID[1]] = {
                req = growT.reqT,
                exp = growT.farmingExp,
                allSV = growT.allSV,
                bigSV = growT.bigSV,
                itemID = floorID,
                itemAID = seedAID,
                itemName = growT.name,
                dialogItemID = growT.plantID[1],
                group = "plants",
                extraText = "farming",
                failChance = 0,
                shovelCharges = growT.shovelCharges,
            }
        end
        growT.stages = deepCopy(growT.stages)
        
        for stageID, stageT in ipairs(growT.stages) do
            if not stageT.growTimeMin then stageT.growTimeMin = 10 end
            if not stageT.failChance then stageT.failChance = 20 end
            stageT.stageID = stageID
            
            if not stageT.itemID then
                stageT.itemID = growT.plantID
                if isHerb then stageT.itemAID = herbs_getHerbT(seedAID).herbAID end
            else
                if type(stageT.itemID) ~= "table" then stageT.itemID = {stageT.itemID} end
                stageT.nextStageID = stageID + 1
            end
        end
        
        if growT.bigSV and growT.bigSV[SV.farmingLevel] then
            local farmingLevel = growT.bigSV[SV.farmingLevel]
            if not levelUpMessages[farmingLevel] then levelUpMessages[farmingLevel] = {} end
            table.insert(levelUpMessages[farmingLevel], "farming level up: You can now plant "..growT.name)
        end
    end
    farmingConf.levelUpMessages = levelUpMessages
end