--[[ Config table guide
    defaults = {
        duration = 10,
        hp = 0,
        mp = 0,
        word = "nom",
    },
    
    foodVocationModifier = {
        [STR] = {                   vocation name
            extraHP = INT or 1      extra HP what will be gained when eating food per second
            extraMP = INT or 1      extra MP what will be gained when eating food per second
            speed = INT or 0        how much faster the the food tick interval in milliseconds.
        }
    }
    
    food = {
        [itemID/itemName] = {
            itemID = INT or itemID              the itemID for the food
            duration = INT or defaults          in seconds how long it will last
            word = STR or defaults              what player will say if item is eaten
            hp = INT or defaults                the amount of hp (INT+vocation modifier+extra modifier) eater will get per second
            mp = INT or defaults                the amount of mp (INT+vocation modifier+extra modifier) eater will get per second
            maxRep = INT                        If food gives reputation towards Cook then what is the max (each time it brings it npc the rep amount will reduce by 1)
            repSV = INT                         Storage value what keep track how many food has brought to cook
            cookingExp = INT                    how much experience gained when spiced or cooked
            fluidType = INT                     if its a container iwth liquid
            
            spice = {                           if item can be spiced up then what each invidual herb powder will do to the food
                [INT] = {                       INT = herb powder AID
                    [INT] = {                   INT = What happens with food when spiced INT times.
                        extraHP = INT           increases extra HP modifier for INT amount in food ticks
                        extraMP = INT           increases extra MP modifier for INT amount in food ticks
                        extraDuration = INT     increases food duration.
                        eleDamEnergy = INT      increases energy damage for + INT amount in damage system
                        eleDamFire = INT        increases fire damage for + INT amount in damage system
                        eleDamEarth = INT       increases earth damage for + INT amount in damage system
                        eleDamDeath = INT       increases death damage for + INT amount in damage system
                        eleDamIce = INT         increases ice damage for + INT amount in damage system
                        resPhysical = INT       increases physical resistance by INT %
                        resFire = INT           increases fire resistance by INT %
                        resEnergy = INT         increases energy resistance by INT %
                        resIce = INT            increases ice resistance by INT %
                        resDeath = INT          increases death resistance by INT %
                        resEarth = INT          increases earth resistance by INT %
                        armor = INT             increases player armor by INT amount
                        speed = INT             increases player speed by INT amount
                    }
                }
            }
            
            ingredients = {STR}                 food name of what it was made of
            recipeStorage = INT,                Storage Value if recipe is learned or not
            
            effect = {                          what kind of effect player will get if eats the food
                armor = {}                      gives extra armor to eater
                cap = {}                        gives extra cap to eater
                maxMP = {}                      gives extra maximum Mana points to player
                duration = INT,                 how long effect lasts in milliseconds
                value = INT                     how much it gives
                ID = INT                        SUB ID for condition or SV for something else
                startTimeSec = INT              storage value for os.time() when effect was applied
            }
            
            -- automatic
            foodName = STR                      if table key is itemName then uses that else ItemType(itemID):getName()
            foodID = INT                        combination of the ingrediend ID's
        }
    }
]]
allTheFood = {} -- {[_] = itemID}
onThinkFood = {} -- {timer = INT, duration = INT} | timer is the seconds what onthink counts, duration is when it checks if more food added or all over
registratedFood = {} --[[  {[playerID] = {["hp"] = {[foodHP] = {duration = duration, startTime = currentTime}},
                                          ["mp"] = {[foodMP] = {duration = duration, startTime = currentTime}},} ]]

foodConf = {
    defaults = {
        duration = 10,
        hp = 0,
        mp = 0,
        word = "nom",
    },
    
    foodVocationModifier = {
        ["mage"] = {extraHP = 2, extraMP = 5},
        ["knight"] = {extraHP = 5, extraMP = 2, speed = 200},
        ["hunter"] = {extraHP = 3, extraMP = 2, speed = 100},
        ["druid"] = {extraHP = 1, extraMP = 3},
    },

    food = {
        [2684] = { -- carrot
            duration = 10, 
            word = "Crunch",
            hp = 1,
            mp = 1,
            maxRep = 15,
            repSV = SV.carrot,
        },
        [2666] = { -- meat
            duration = 50, 
            word = "Munch",
            hp = 2,
            mp = 1,
            maxRep = 10,
            repSV = SV.meat,
            cookingExp = 5,
            spice = {
                [AID.herbs.brirella_powder] = {
                    [1] = {extraDuration = 35},
                    [2] = {extraDuration = 45},
                    [3] = {eleDamDeath = 20},
                    [4] = {eleDamDeath = 10},
                    [5] = {extraHP = 1},
                }
            }
        },
        [2671] = { -- ham
            duration = 60, 
            word = "Chomp",
            hp = 3,
            mp = 2,
            maxRep = 10,
            repSV = SV.ham,
            cookingExp = 5,
            spice = {
                [AID.herbs.urreanel_powder] = {
                    [1] = {extraDuration = 40},
                    [2] = {extraDuration = 55},
                    [3] = {armor = 5},
                    [4] = {armor = 10},
                    [5] = {resPhysical = 5},
                }
            }
        },
        [2674] = { -- red apple
            duration = 25,
            word = "Yum",
            hp = 1,
            mp = 2,
            maxRep = 10,
            repSV = SV.apple,
            cookingExp = 5,
            spice = {
                [AID.herbs.ozeogon_powder] = {
                    [1] = {extraDuration = 20},
                    [2] = {extraDuration = 20},
                    [3] = {speed = 15},
                    [4] = {speed = 15},
                    [5] = {extraHP = 1},
                }
            }
        },
        [2677] = { -- blueberry
            duration = 1,
            word = "Yum",
            hp = 0,
            mp = 1,
            maxRep = 15,
            repSV = SV.blueberry,
        },
        [2006] = { -- water
            foodName = "Vial of water",
            duration = 30,
            word = "Gulp",
            hp = 0,
            mp = 3,
            fluidType = 1,
        },
        ["dumplings"] = {
            ingredients = {"meat", "carrot"},
            itemID = 9995,
            duration = 70,
            hp = 3,
            mp = 2,
            word = "omnom nom",
            recipeStorage = SV.dumplings,
            cookingExp = 20,
            effect = {
                armor = {
                    duration = 60*60*1000,
                    value = 5,
                    ID = SV.dumplingsArmor,
                    startTimeSec = SV.dumplingsTime,
                }
            }
        },
        ["easter ham"] = {
            ingredients = {"ham", "carrot"},
            itemID = 12540,
            duration = 90,
            hp = 4,
            mp = 1,
            word = "omnom onom",
            recipeStorage = SV.easterHam,
            cookingExp = 30,
            effect = {
                cap = {
                    duration = 60*60*1000,
                    value = 20,
                    ID = SV.easterHamCap,
                    startTimeSec = SV.easterHamTime,
                }
            }
        },
        ["delight juice"] = {
            ingredients = {"apple", "blueberry"}, -- need 10 blueberries (hardcoded)
            itemID = 9996,
            duration = 50,
            hp = 1,
            mp = 5,
            word = "slurp",
            recipeStorage = SV.delightJuice,
            cookingExp = 70,
            effect = {
                maxMP = {
                    duration = 60*60*1000,
                    value = 100,
                    ID = SUB.ATTRIBUTES.attributes.delightJuice,
                    startTimeSec = SV.delightJuiceTime,
                }
            }
        },
    }
}

local feature_food = {
    startUpFunc = "food_startUp",
    AIDItems = {
        [AID.other.food] = {funcStr = "food_onUse"},
    },
}

centralSystem_registerTable(feature_food)

function food_startUp()
local loopID = 0

    local function getFoodIdByIngredients(ingredients)
        if not ingredients then return end
        local IDT = {}
        local foodID = ""
        
        for _, foodName in pairs(ingredients) do table.insert(IDT, ItemType(foodName):getId()) end
        for _, id in ipairs(sortByValue(IDT, "low")) do foodID = foodID..id end
        return tonumber(foodID)
    end

    for itemID, foodT in pairs(foodConf.food) do
        loopID = loopID + 1
        if not foodT.duration then foodT.duration = foodConf.defaults.duration end
        if not foodT.hp then foodT.hp = foodConf.defaults.hp  end
        if not foodT.mp then foodT.mp = foodConf.defaults.mp  end
        if not foodT.word then foodT.word = foodConf.defaults.word  end
        if not foodT.itemID then foodT.itemID = itemID end
        foodT.foodID = getFoodIdByIngredients(foodT.ingredients)
        allTheFood[loopID] = foodT.itemID
        if not foodT.foodName then
            if type(itemID) == "string" then foodT.foodName = itemID else foodT.foodName = ItemType(itemID):getName() end
        end
    end
end