--[[ royaleConf guide
    startTime = INT or 30                   how many seconds later game starts after minPlayers amount of players have qued
    minPlayers = INT or 5                   how many players are needed to que for Battle Royale, before startTime initiates
    canJoinEvent = false                    can players join the event
    pseudoItemLook = STR                    How item information is displayed. special keys:
                                            ITEM_NAME = string position where item name is written, in brackets itemCount if its bigger than 1
                                            STATS = string position where all stats are written
    startingItems = {{                      players get those items when the join event
        itemID = INT,
        itemAID = INT or itemTypeT.itemAID
    }}

    map = {
        upCorner = POS,                     most up left corner of map
        downCorner = POS,                   most down right corner of map
        waitingPos = POS                    position where players will be teleported when they que up for event | DEFUALT startingLocations[1]
        startingLocations = {POS}           one of the positions where player is teleported when joining event
        itemID = INT or 2599                on the map this itemID is replaced with randomItem or nothing.

        AUTOMATIC
        lastStartingLocationID = INT        position where last person started, so that players are kept apart from eachother when starting
        startingLocationAmount = INT        tableCount(startingLocations)
        allPositions = {POS}                createAreaOfSquares({{upCorner = mapConf.upCorner, downCorner = mapConf.downCorner, allZPos = true}})
    },

    statStrings = {
        [STR] = {                   itemStat | regMP, regHP, durationSec, etc
            sequenceID = INT        in which order stats will be shown
            funcStr = STR           RETURNS _[funcStr](itemT)
            fullStr = STR           how stat is written on item
                                    VALUE = stat value from items
                                    DAMTYPE = damType in string
                                    SECONDS = "second" or "seconds"
                                    PLUS = shows either negative or positive symbol front of number "+" or "-"
                                    %% = for "%" symbol
                                    ()  = numbers between brackets are calculated
        }
    },

    itemTypes = {                               list of all custom itemTypes with each of their custom configurations
        [STR] = {                               custom itemTypeT | all itemTypeT inherit these attributes
            findRate = INT or 10                % chance to find this type of items |100 - total findrate AND > 0 = chance to get nothing
            itemAID = INT                       itemAID for all the items for this itemType
            items = {
                [INT] = {                       itemID
                    findRate = INT or 0         chance to find this item
                    maxCount = INT or 1         math.random(maxCount) items will appear
                    secFindRate = INT or 0      % chance to find secItemID
                    secItemID = INT             itemID of secondary item
                    name = STR                  DEFAULT = item:getName()
                
                    AUTOMATIC
                    itemID = INT                table key
                    itemAID = INT               itemTypeT.itemAID
                }
            }

            AUTOMATIC
            choiceID = INT                      itemType_choiceID for modal window selection
            mwFunc = "royale_MW_"..STR.."_create"   execution params (player, STR) | STR = table key | function for selected choiceID
        },
        food = {
            items = {
                [INT] = {                       itemID
                    regMP = INT                 how much mana gives per intervalMP second
                    intervalMP = INT or 1       in seconds
                    regHP = INT                 how much health gives per intervalHP second
                    intervalHP = INT or 1       in seconds
                    durationSec = INT           how long food will last
                    eatMsg = STR                orange floating message when player eats food
                }
            },
        },
        equipment = {
            items = {
                [INT] = {                       itemID
                    armor = INT                 how much overall damage is protected
                    dodge = INT                 & chance to avoid physical damage all together
                    fireRes = INT               % amount of fire resistance
                    iceRes = INT                % amount of fire resistance
                    earthRes = INT              % amount of earth resistance
                    energyRes = INT             % amount of energy resistance
                    deathRes = INT              % amount of death resistance
                    holyRes = INT               % amount of holy resistance
                    physicalRes = INT           % amount of physical resistance
                    damage = INT                how much physical damage deals each hit
                    weaponSpeed = INT           time in milliseconds how often attacks again | DO NOT GO BELOW 200
                    range = INT or 1            how far you have to be from target, if range more than 1 then arrows needed
                }
            }
        },
        runes = {
            items = {
                [INT] = {                       itemID
                    damage = INT                how much damType damage deals each hit
                    damType = INT or FIRE       damage types: FIRE, ICE, EARTH, DEATH, ENERGY, PHYSICAL
                    effectOnHit = INT           DEFAULT = getEffectByType(damType) | when target gets hit
                    effectOnMiss = INT          if damage missed
                    de = INT                    distance effect

                    area = {                    position mapping area
                        {1,2,3},                numbers represent sequence (can have multible same numbers)
                        {7,n,4},                1 and 0 represent starting position
                        {7,6,5},                0 means starting position is not included.
                    }
                    interval_ms = INT or 150    milliseconds between sequence or before rune effects take place
                    slowAmount = INT
                    slowDuration_ms = INT       in milliseconds, how long slow will last | DEFAULT = 10000
                    createItemID = INT          itemID which will be created on positions.
                    createdItemName = STR       DEFAULT = createdItemName:getName()
                    addItemAID = INT            itemAID for created item
                    itemDuration_ms = INT       in milliseconds, how long item will last | DEFAULT = 10000
                    drunkStepAmount = INT       how many random steps player will take every 2 seconds
                }
            }
        },
        bags = {
            items = {
                [INT] = {                       itemID
                    AUTOMATIC
                    slotAmount = INT            ItemType(itemID):getSlotAmount()
                }
            }
        },
    }

    fire = {
        startingPositions = {POS}           list of positions where fire starts
        damage = INT or 100                 how much damage it does when player steps on/off/stands on fire
        spreadSpeed = INT or 1000           in milliseconds how fast fire field multiplies
        reDamTime = INT or 2000             in milliseconds when damage is dealt again, when player keeps standing on fire
        itemID = INT                        fire itemID
        itemAID = INT                       fire itemAID

        AUTOMATIC
        positions = {POS}                   positions where are all the fire fields
        spreadPositions = {POS}             positions where fire will spread next
    },

    environment = {                         all kinds of custom features on the map
        bushes = {                          each game generates random amount of berry bushes
            itemIDT = {INT},                list of itemID's what are considered bushes on map
            toID,                           turns all itemIDT itemID's into toID
            itemID = INT,                   berry ID
            itemAID = INT,                  berry AID
            berryChance = INT,              % chance to have berries on bush
            berryMaxAmount = INT,           math.random(berryMaxAmount) berries will appear on berryBushID
        }
    }

    fields = {
        [INT] = {                           itemAID
            damType = INT or FIRE           ENUM
            damage = INT or 1               how much damage deals each interval
            duration = INT or 1             how many seconds damage over time lasts
            interval = INT or 1000          how often deals damage
            effect = INT or getEffectByType(damType)
        }
    }

    AUTOMATIC
    sequenceID_amount = INT                 used to generate new sequenceID's for statStrings
    foodT = {                               list of all players who get health or mana over time
        [playerID] = {
            stackID = INT,                  latest stack ID
            completedStackID = INT          latet stack ID which was completed
            foodList = {
                HP = INT,                   how much health gives
                MP = INT,                   how much mana gives
                intervalHP = INT,           in seconds when gives health again
                intervalMP = INT,           in seconds when gives mana again
                duration = INT,             in seconds how long food lasts
            }
        }
    }

    itemSpawnT = {
        itemPosConf = {{                    list of positions where random items will be spawned
            pos = POS                       
            containerID = INT               if item is spawned in container
        }                 
        itemType_maxV = INT                 maximum value for random number
        itemTypes = {                       includes all different item types + chance to summon nothing
            [{min = INT, max=INT}] = {      random value space between
                items_maxV = INT            maximum value for random number
                items = {
                    [{min = INT, max=INT}] = {  random value space between
                        itemT values        itemID = INT, itemAID = INT, maxCount = INT, etc
                    }
                }
            }
        }
    }

    players = {
        [playerID] = {
            isInQue = BOOL                  if player is in the que
            isInGame = BOOL                 if player is currently playing
            isDead = BOOL                   if player has died in Battle Royale
        }
    }
]]

local backUpPositions = royaleConf and royaleConf.itemSpawnT.itemPosConf
if backUpPositions then 
    royale_clean()
    print("WARNING - royaleConf uses backUpPositions in royaleConf.itemSpawnT")
end

local backUp_allPositions = royaleConf and royaleConf.map.allPositions
if backUp_allPositions then print("WARNING - royaleConf uses backUp_allPositions in royaleConf.map.allPositions") end

local AIDT = AID.games.royale
local IDT = ITEMID.royale

tier1Area = {
    {n, 2, n},
    {2, 1, 2},
    {n, 2, n},
}
tier2Area = {
    {n, n, 3, n, n},
    {n, 2, 2, 2, n},
    {3, 2, 1, 2, 3},
    {n, 2, 2, 2, n},
    {n, n, 3, n, n},
}

royaleConf = {
    startTime = 60,
    minPlayers = 2,
    canJoinEvent = testServer(),
    pseudoItemLook = "You see ITEM_NAME\nSTATS",
    startingItems = {{itemID = IDT.bag_t0}, {itemID = IDT.sword_t0}},

    map = {
        upCorner = {x = 787, y = 731, z = 7},
        downCorner = {x = 916, y = 874, z = 7},
        itemID = 2599,
        waitingPos = {x = 886, y = 754, z = 8},
        startingLocations = {
            {x = 896, y = 864, z = 7},
            {x = 804, y = 823, z = 7},
            {x = 892, y = 762, z = 7},
            {x = 818, y = 749, z = 7},
            {x = 791, y = 804, z = 7},
            {x = 875, y = 818, z = 7},
            {x = 861, y = 839, z = 5},
            {x = 868, y = 812, z = 6},
            {x = 819, y = 803, z = 4},
        },
    },
    
    statStrings = {
        damage = {sequenceID = 1, fullStr = "DAMTYPE damage: VALUE"},
        weaponSpeed = {sequenceID = 2, fullStr = "weapon speed: VALUE milliseconds"},
        range =  {sequenceID = 3, fullStr = "weapon range: VALUE"},
        armor = {sequenceID = 4, fullStr = "armor: VALUE%%"},
        dodge = {sequenceID = 5, fullStr = "dodge: VALUE%%"},
        regHP = {sequenceID = 6, funcStr = "getItemStr_regHP"},
        regMP = {sequenceID = 7, funcStr = "getItemStr_regMP"},
        durationSec = {sequenceID = 8, fullStr = "Effect lasts VALUE SECONDS"},
        physicalRes = {fullStr = "physical resistance: VALUE%%"},
        fireRes = {fullStr = "fire resistance: VALUE%%"},
        iceRes = {fullStr = "ice resistance: VALUE%%"},
        earthRes = {fullStr = "earth resistance: VALUE%%"},
        energyRes = {fullStr = "energy resistance: VALUE%%"},
        deathRes = {fullStr = "death resistance: VALUE%%"},
        holyRes = {fullStr = "holy resistance: VALUE%%"},
        area = {fullStr = "affects multible positions"},
        slowAmount = {funcStr = "getRuneStr_slow"},
        createItemID = {funcStr = "getRuneStr_createItem"},
        drunkStepAmount = {fullStr = "drunkates target for (2*VALUE) seconds"},
        slotAmount = {fullStr = "bag size: VALUE"},
    },
    itemTypes = {
        food = {
            findRate = 10,
            itemAID = AIDT.food,
            items = {
                [ITEMID.food.fish] = {findRate = 3, maxCount = 2, regHP = 35, durationSec = 4, eatMsg = "munch.."},
                [ITEMID.food.meat] = {findRate = 2, maxCount = 2, regHP = 35, durationSec = 6, eatMsg = "munch.."},
                [ITEMID.food.ham] = {findRate = 1, maxCount = 2, regHP = 45, durationSec = 6, eatMsg = "munch.."},
                [ITEMID.food.blueberry] = {regHP = 5, eatMsg = "yum.."},
                --[[
                [ITEMID.food.shrimp] = {},
                [ITEMID.food.pear] = {},
                [ITEMID.food.apple] = {},
                [ITEMID.food.orange] = {},
                [ITEMID.food.banana] = {},
                [ITEMID.food.coconut] = {},
                [ITEMID.food.cherry] = {},
                [ITEMID.food.strawberry] = {},
                [ITEMID.food.carrot] = {},
                [ITEMID.food.cheese] = {},]]
            }
        },
        equipment = {
            findRate = 10,
            itemAID = AIDT.equipment,
            items = {
                [IDT.body_t1] = {findRate = 5, name = "Armor T1", armor = 3},
                [IDT.body_t2] = {findRate = 3, name = "Armor T2", armor = 5},
                [IDT.body_t3] = {findRate = 1, name = "Armor T3", armor = 7},
                [IDT.helmet_t1] = {findRate = 5, name = "Helmet T1", armor = 2},
                [IDT.helmet_t2] = {findRate = 3, name = "Helmet T2", armor = 4},
                [IDT.helmet_t3] = {findRate = 1, name = "Helmet T3", armor = 6},
                [IDT.legs_t1] = {findRate = 5, name = "Legs T1", armor = 2},
                [IDT.legs_t2] = {findRate = 3, name = "Legs T2", armor = 4},
                [IDT.legs_t3] = {findRate = 1, name = "Legs T3", armor = 6},
                [IDT.boots_t1] = {findRate = 5, name = "Boots T1", armor = 2},
                [IDT.boots_t2] = {findRate = 3, name = "Boots T2", armor = 4},
                [IDT.boots_t3] = {findRate = 1, name = "Boots T3", armor = 6},
                [IDT.shield_t1] = {findRate = 5, name = "Shield T1", armor = 3, dodge = 10},
                [IDT.shield_t2] = {findRate = 3, name = "Shield T2", armor = 5, dodge = 15},
                [IDT.shield_t3] = {findRate = 1, name = "Shield T3", armor = 8, dodge = 20},
                [IDT.sword_t0] = {findRate = 0, name = "Sword T0", damage = 50, weaponSpeed = 2000},
                [IDT.sword_t1] = {findRate = 5, name = "Sword T1", damage = 90, weaponSpeed = 2000},
                [IDT.sword_t2] = {findRate = 3, name = "Sword T2", damage = 125, weaponSpeed = 2000},
                [IDT.sword_t3] = {findRate = 1, name = "Sword T3", damage = 150, weaponSpeed = 2000},
                [IDT.arrow] = {findRate = 10, maxCount = 10},
                [IDT.bow_t1] = {findRate = 5, secFindRate = 80, secItemID = IDT.arrow, name = "Bow T1", damage = 50, weaponSpeed = 2000, range = 4},
                [IDT.bow_t2] = {findRate = 3, secFindRate = 80, secItemID = IDT.arrow, name = "Bow T2", damage = 100, weaponSpeed = 2000, range = 4},
                [IDT.bow_t3] = {findRate = 1, secFindRate = 80, secItemID = IDT.arrow, name = "Bow T3", damage = 150, weaponSpeed = 2000, range = 5},
                [IDT.ring_fire] = {findRate = 2, name = "Fire resistance ring", fireRes = 30},
                [IDT.ring_earth] = {findRate = 2, name = "Poison resistance ring", earthRes = 30},
                [IDT.ring_energy] = {findRate = 2, name = "Shock resistance ring", energyRes = 30},
                [IDT.necklace_fire] = {findRate = 2, name = "Fire resistance necklace", fireRes = 30},
                [IDT.necklace_earth] = {findRate = 2, name = "Poison resistance necklace", earthRes = 30},
                [IDT.necklace_energy] = {findRate = 2, name = "Shock resistance necklace", energyRes = 30},
            }
        },
        runes = {
            findRate = 10,
            itemAID = AIDT.runes,
            items = {
                [2303] = {findRate = 30, maxCount = 4, name = "Fire rune T1", damage = 100, damType = FIRE, effectOnMiss = {30,37}, de = 4},
                [2308] = {findRate = 20, maxCount = 4, name = "Fire rune T2", damage = 150, damType = FIRE, effectOnMiss = {30,37}, de = 4},
                [2275] = {findRate = 30, maxCount = 4, name = "Energy rune T1", damage = 100, damType = ENERGY, effectOnMiss = {31,48}, de = 36},
                [2276] = {findRate = 20, maxCount = 4, name = "Energy rune T2", damage = 150, damType = ENERGY, effectOnMiss = {31,48}, de = 36},
                [2287] = {findRate = 30, maxCount = 4, name = "Earth rune T1", damage = 100, damType = EARTH, effectOnMiss = 21, de = 39},
                [2288] = {findRate = 20, maxCount = 4, name = "Earth rune T2", damage = 150, damType = EARTH, effectOnMiss = 21, de = 39},
                [2302] = {findRate = 30, maxCount = 4, name = "Aoe fire rune T1", damage = 40, damType = FIRE, effectOnMiss = {30,37}, de = 4, area = tier1Area},
                [2304] = {findRate = 20, maxCount = 4, name = "Aoe fire rune T2", damage = 80, damType = FIRE, effectOnMiss = {30,37}, de = 4, area = tier2Area},
                [2270] = {findRate = 30, maxCount = 4, name = "Aoe Energy rune T1", damage = 40, damType = ENERGY, effectOnMiss = {31,48}, de = 36, area = tier1Area},
                [2274] = {findRate = 20, maxCount = 4, name = "Aoe Energy rune T2", damage = 80, damType = ENERGY, effectOnMiss = {31,48}, de = 36, area = tier2Area},
                [2291] = {findRate = 30, maxCount = 4, name = "Aoe Earth rune T1", damage = 40, de = 39, damType = EARTH, effectOnMiss = 21, area = tier1Area},
                [2292] = {findRate = 20, maxCount = 4, name = "Aoe Earth rune T2", damage = 80, de = 39, damType = EARTH, effectOnMiss = 21, area = tier2Area},
                [2268] = {findRate = 10, maxCount = 4, name = "Sudden death", damage = 250, damType = DEATH, effectOnMiss = 18, de = 11},
                [2293] = {findRate = 30, maxCount = 4, name = "Drunk rune T1", drunkStepAmount = 5, effectOnHit = 14, effectOnMiss = 23, de = 38},
                [2261] = {findRate = 20, maxCount = 4, name = "Drunk rune T2", drunkStepAmount = 8, effectOnMiss = 23, de = 38},
                [2296] = {findRate = 30, maxCount = 4, name = "Slow rune T1", slowAmount = 70, effectOnHit = 14, effectOnMiss = 14, de = 38},
                [2299] = {findRate = 20, maxCount = 4, name = "Slow rune T2", slowAmount = 140, effectOnHit = 14, effectOnMiss = 14, de = 38},
                [2314] = {findRate = 30, maxCount = 4, name = "Magic wall rune T1", de = 5, createItemID = ITEMID.environment.field_magic},
                [2315] = {findRate = 20, maxCount = 4, name = "Magic wall rune T2", de = 5, createItemID = ITEMID.environment.field_magic, itemDuration_ms = 15000},
                [2301] = {findRate = 30, maxCount = 4, name = "Fire field rune T1", de = 4, createItemID = ITEMID.environment.field_fire, addItemAID = AIDT.fireField},
                [2305] = {findRate = 15, maxCount = 4, name = "Fire field rune T2", de = 4, createItemID = ITEMID.environment.field_fire, addItemAID = AIDT.fireField, area = tier1Area},
                [2269] = {findRate = 30, maxCount = 4, name = "Energy field rune T1", de = 36, createItemID = ITEMID.environment.field_energy, addItemAID = AIDT.energyField},
                [2272] = {findRate = 15, maxCount = 4, name = "Energy field rune T2", de = 36, createItemID = ITEMID.environment.field_energy, addItemAID = AIDT.energyField, area = tier1Area},
                [2285] = {findRate = 30, maxCount = 4, name = "Poison field rune T1", de = 30, createItemID = ITEMID.environment.field_earth, addItemAID = AIDT.earthField},
                [2289] = {findRate = 15, maxCount = 4, name = "Poison field rune T2", de = 30, createItemID = ITEMID.environment.field_earth, addItemAID = AIDT.earthField, area = tier1Area},
            }
        },
        bags = {
            findRate = 6,
            itemAID = AIDT.bags,
            items = {
                [IDT.bag_t0] = {findRate = 0, name = "bag T0"},
                [IDT.bag_t1] = {findRate = 3, name = "bag T1"},
                [IDT.bag_t2] = {findRate = 2, name = "bag T2"},
                [IDT.bag_t3] = {findRate = 1, name = "bag T3"},
            }
        },
    },

    fire = {
        startingPositions = {
            {x = 886, y = 869, z = 4},
            {x = 815, y = 746, z = 7},
            {x = 799, y = 821, z = 7},
        },
        damage = 100,
        spreadSpeed = 4000,
        itemID = 1506,
        itemAID = AIDT.purpleFire,
    },
    
    environment = {
        bushes = {
            itemIDT = {2767, 2785},
            toID = 2767,
            itemID = ITEMID.food.blueberry,
            itemAID = AIDT.food,
            berryChance = 25,
            berryMaxAmount = 7,
        }
    },
    
    fields = {
        [AIDT.fireField] = {damType = FIRE, damage = 50, duration = 10, interval = 2000},
        [AIDT.energyField] = {damType = ENERGY, damage = 50, duration = 10, interval = 2000},
        [AIDT.earthField] = {damType = EARTH, damage = 50, duration = 10, interval = 2000},
    }
}

local royale_centralT = {
    startUpFunc = "royale_startUp",
    startUpPriority = 2,

    modalWindows = {
        [MW.royale_mainWindow] = {
            name = 'Battle Royale',
            title = 'royale_title',
            choices = 'royale_choices',
            buttons = {[100] = 'choose', [101] = 'close'},
            say = '*opened royale event panel*',
            func = 'royale_MW_main_handle',
        },
        [MW.royale_itemListWindow] = {
            name = 'Battle Royale itemlist',
            title = 'royale_title',
            choices = 'royale_MW_itemList_choices',
            buttons = {[100] = 'choose', [101] = 'back'},
            say = '*creating Royale items*',
            func = 'royale_MW_itemList_handle',
        },
        [MW.royale_runeWindow] = {
            name = 'Battle Royale runes',
            title = 'royale_title',
            choices = 'royale_MW_items_choices',
            buttons = {[100] = 'choose', [101] = 'back'},
            say = '*creating Royale items*',
            func = 'royale_MW_items_handle',
            save = "saveParams",
        },
        [MW.royale_foodWindow] = {
            name = 'Battle Royale food',
            title = 'royale_title',
            choices = 'royale_MW_items_choices',
            buttons = {[100] = 'choose', [101] = 'back'},
            say = '*creating Royale items*',
            func = 'royale_MW_items_handle',
            save = "saveParams",
        },
        [MW.royale_equipmentWindow] = {
            name = 'Battle Royale equipment',
            title = 'royale_title',
            choices = 'royale_MW_items_choices',
            buttons = {[100] = 'choose', [101] = 'back'},
            say = '*creating Royale items*',
            func = 'royale_MW_items_handle',
            save = "saveParams",
        },
        [MW.royale_bagsWindow] = {
            name = 'Battle Royale bags',
            title = 'royale_title',
            choices = 'royale_MW_items_choices',
            buttons = {[100] = 'choose', [101] = 'back'},
            say = '*creating Royale items*',
            func = 'royale_MW_items_handle',
            save = "saveParams",
        },
    },
    onLogout = {funcStr = "royale_logOut"},
    onMove = {{funcStr = "royale_onMove"}},
    AIDItems_onLook = {
        [AIDT.food] = {funcStr = "royale_onLook"},
        [AIDT.equipment] = {funcStr = "royale_onLook"},
        [AIDT.runes] = {funcStr = "royale_onLook"},
        [AIDT.bags] = {funcStr = "royale_onLook"},
    },
    AIDItems = {
        [AIDT.food] = {funcStr = "royale_food_onUse"},
        [AIDT.runes] = {funcStr = "royale_runes_onUse"},
    },
    AIDTiles_stepIn = {
        [AIDT.purpleFire] = {funcStr = "royale_fire_onStep"},
        [AIDT.fireField] = {funcStr = "royale_field_onStep"},
        [AIDT.energyField] = {funcStr = "royale_field_onStep"},
        [AIDT.earthField] = {funcStr = "royale_field_onStep"},
        [AIDT.portal] = {funcStr = "royale_que_register"},
    },
    mapEffects = {
        portalArrow = {pos = {x = 526, y = 735, z = 8}, me = CONST_ME_TUTORIALARROW}
    }
}
local mapConf = royaleConf.map
function royale_startUp()
    if not mapConf.startingLocations then return print("ERROR in royale_startUp() - missing mapConf.startingLocations") end
    mapConf.startingLocationAmount = tableCount(mapConf.startingLocations)
    mapConf.lastStartingLocationID = mapConf.startingLocationAmount
    mapConf.waitingPos = mapConf.waitingPos or mapConf.startingLocations[1]
    royaleConf.sequenceID_amount = tableCount(royaleConf.statStrings)
    royaleConf.foodT = {}
    royaleConf.players = {}
    royaleConf.corpsePosT = {}
    royaleConf.itemSpawnT = {itemPosConf = (backUpPositions or {})}
    local spawnT = royaleConf.itemSpawnT
    if not mapConf.itemID then mapConf.itemID = 2599 end
    if not royaleConf.startTime then royaleConf.startTime = 30 end
    if not royaleConf.minPlayers then royaleConf.minPlayers = 5 end

    if not backUpPositions then
        local loopID = 0
        local positions = createAreaOfSquares({{upCorner = mapConf.upCorner, downCorner = mapConf.downCorner, allZPos = true}})
        mapConf.allPositions = positions

        for _, pos in ipairs(positions) do
            if removeItemFromPos(mapConf.itemID, pos) then 
                local container = getTopContainer(pos)
                local containerID = container and container:getId()
                loopID = loopID + 1
                spawnT.itemPosConf[loopID] = {pos = pos, containerID = containerID}
            end
        end
    else
        mapConf.allPositions = backUp_allPositions
    end

    for statName, statT in pairs(royaleConf.statStrings) do
        if not statT.sequenceID then
            royaleConf.sequenceID_amount = royaleConf.sequenceID_amount + 1
            statT.sequenceID = royaleConf.sequenceID_amount
        end
    end

    local chanceT = {}
    local itemType_choiceID = 0

    for itemTypeStr, itemTypeT in pairs(royaleConf.itemTypes) do
        if not itemTypeT.findRate then itemTypeT.findRate = 10 end
        local itemChanceT = {}
        
        itemType_choiceID = itemType_choiceID + 1
        itemTypeT.choiceID = itemType_choiceID
        itemTypeT.mwFunc = "royale_MW_"..itemTypeStr.."_create"

        for itemID, itemT in pairs(itemTypeT.items) do
            if not itemT.maxCount then itemT.maxCount = 1 end
            if not itemT.name then itemT.name = ItemType(itemID):getName() end
            itemT.itemID = itemID
            itemT.itemAID = itemTypeT.itemAID
            itemChanceT[itemID] = {chance = (itemT.findRate or 0), itemT = itemT}
        end

        local chanceMap = {}
        local startChance = 1
        local loopID = 0

        for _, t in pairs(itemChanceT) do
            if t.chance > 0 then
                local nextChance = startChance + t.chance
                local upToChance = nextChance - 1
                loopID = loopID + 1
                chanceMap[{min = startChance, max = upToChance}] = t.itemT
                startChance = nextChance
            end
        end
        
        chanceT[itemType_choiceID] = {chance = itemTypeT.findRate, itemsT = {items_maxV = startChance - 1, items = chanceMap}}
    end

    local chanceMap = {}
    local startChance = 1

    for _, t in pairs(chanceT) do
        if t.chance > 0 then
            local nextChance = startChance + t.chance
            local upToChance = nextChance - 1
            chanceMap[{min = startChance, max = upToChance}] = t.itemsT
            startChance = nextChance
        end
    end

    local itemType_maxV = startChance - 1

    if itemType_maxV < 100 then
        chanceMap[{min = startChance, max = 100}] = "no item"
        itemType_maxV = 100
    end

    spawnT.itemType_maxV = itemType_maxV
    spawnT.itemTypes = chanceMap
    
    for foodID, itemT in pairs(royaleConf.itemTypes.food.items) do
        if not itemT.intervalMP then itemT.intervalMP = 1 end
        if not itemT.intervalHP then itemT.intervalHP = 1 end
    end

    for itemID, itemT in pairs(royaleConf.itemTypes.equipment.items) do
        if itemT.weaponSpeed and itemT.weaponSpeed < 200 then itemT.weaponSpeed = 200 end
        if itemT.damage then
            if not itemT.range then itemT.range = 1 end
            if not itemT.damType then itemT.damType = PHYSICAL end
        end
    end

    for itemID, itemT in pairs(royaleConf.itemTypes.runes.items) do
        if itemT.damage and not itemT.damType then itemT.damType = FIRE end
        if itemT.createItemID and not itemT.itemDuration_ms then itemT.itemDuration_ms = 10000 end
        if itemT.slowAmount and not itemT.slowDuration_ms then itemT.slowDuration_ms = 10000 end
        if not itemT.interval_ms then itemT.interval_ms = 150 end
        if itemT.createItemID and not itemT.createdItemName then itemT.createdItemName = ItemType(itemT.createItemID):getName() end
    end

    for itemID, itemT in pairs(royaleConf.itemTypes.bags.items) do
        itemT.slotAmount = getSlotAmount(itemID)
        if not itemT.slotAmount then print("ERROR in royale_startUp() - itemID: "..itemID.." is not container") end
    end

    local fireT = royaleConf.fire
    if not fireT.startingPositions then return print("ERROR in royale_startUp() - missing fireT.startingPositions") end
    if not fireT.itemID then return print("ERROR in royale_startUp() - missing fireT.itemID") end
    if not fireT.itemAID then return print("ERROR in royale_startUp() - missing fireT.itemAID") end
    if not fireT.damage then fireT.damage = 100 end
    if not fireT.spreadSpeed then fireT.spreadSpeed = 1000 end
    if not fireT.reDamTime then fireT.reDamTime = 2000 end
    fireT.positions = {}

    for _, fieldT in pairs(royaleConf.fields) do
        if not fieldT.damType then fieldT.damType = FIRE end
        if not fieldT.damage then fieldT.damage = 1 end
        if not fieldT.duration then fieldT.duration = 1 end
        if not fieldT.interval then fieldT.interval = 1000 end
        if not fieldT.effect then fieldT.effect = getEffectByType(fieldT.damType) end
    end

    if not royaleConf.startingItems then royaleConf.startingItems = {} end
    
    for _, itemT in pairs(royaleConf.startingItems) do
        local itemT2 = royale_get_itemT(itemT.itemID)
        if itemT2 then itemT.itemAID = itemT2.itemAID end
    end
end

centralSystem_registerTable(royale_centralT)

function royale_MW_main_create(player) return player:createMW(MW.royale_mainWindow) end

function royale_MW_main_handle(player, mwID, buttonID, choiceID, save)
    if buttonID == 101 then return end

    if choiceID == 1 then
        royaleConf.canJoinEvent = not royaleConf.canJoinEvent and true or false
        local playersT = royale_get_playersT()

        for playerID, playerT in pairs(playersT) do
            if playerT.isInQue then playersT[playerID] = nil end
        end
        return royale_MW_main_create(player)
    end
    if choiceID == 2 then return royale_MW_main_create(player) end
    if choiceID == 3 then return royale_que_register(player) end
    if choiceID == 4 then return royale_que_unRegister(player) end
    if choiceID == 5 then return royale_clean() end
    if choiceID == 6 then return royale_start(true) end
    if choiceID == 7 then return royale_end(true) end
    if choiceID == 8 then return royale_MW_itemList_create(player) end
end

function royale_MW_itemList_create(player, itemType) return player:createMW(MW.royale_itemListWindow, itemType) end
function royale_MW_runes_create(player, itemType) return player:createMW(MW.royale_runeWindow, itemType) end
function royale_MW_equipment_create(player, itemType) return player:createMW(MW.royale_equipmentWindow, itemType) end
function royale_MW_bags_create(player, itemType) return player:createMW(MW.royale_bagsWindow, itemType) end
function royale_MW_food_create(player, itemType) return player:createMW(MW.royale_foodWindow, itemType) end

function royale_MW_itemList_handle(player, mwID, buttonID, choiceID, save)
    if buttonID == 101 then return royale_MW_main_create(player) end
    for itemTypeStr, itemTypeT in pairs(royaleConf.itemTypes) do
        if itemTypeT.choiceID == choiceID then return _G[itemTypeT.mwFunc](player, itemTypeStr) end
    end
end

function royale_MW_itemList_choices(player)
    local choiceT = {}
    for itemTypeStr, itemTypeT in pairs(royaleConf.itemTypes) do choiceT[itemTypeT.choiceID] = itemTypeStr end
    return choiceT
end

function royale_MW_items_handle(player, mwID, buttonID, choiceID, save)
    if buttonID == 101 then return royale_MW_main_create(player) end
    local itemTypeT = royaleConf.itemTypes[save]
    local loopID = 0

    for _, itemT in pairs(itemTypeT.items) do
        loopID = loopID + 1
        if loopID == choiceID then return createItem(itemT.itemID, nil, itemT.maxCount, itemT.itemAID, nil, nil, player) end
    end
end

function royale_MW_items_choices(player, itemType)
    local itemTypeT = royaleConf.itemTypes[itemType]
    local choiceT = {}
    local loopID = 0

    for _, itemT in pairs(itemTypeT.items) do
        loopID = loopID + 1
        choiceT[loopID] = itemT.name
    end
    return choiceT
end

function royale_choices(player)
    local choiceT = {}

    if player:isGod() then
        choiceT[1] = royaleConf.canJoinEvent and "registration is open" or "registration is closed"
        choiceT[5] = "clean Royale map"
        choiceT[6] = "force start"
        choiceT[7] = "force end"
        choiceT[8] = "Create any Battle Royale item"
    end

    if not royale_isInQue(player) then
        if not player:isGod() and player:getLevel() > 2 and not isInArea(player, forgottenVillageArea.area) then
            choiceT[2] = "You need to be in Forgotten Village, in order to join Battle Royale event"
        else
            choiceT[3] = "que into Battle Royale"
        end
    else
        choiceT[4] = "unque from Battle Royale"
    end
    return choiceT
end

function royale_title(player) return "Currently there are "..royale_get_quePlayersAmount().." players waiting for Battle Royale start" end

function royale_que_register(player)
    if not royaleConf.canJoinEvent then return player:sendTextMessage(GREEN, "Battle Royale is currently disabled") end
    local playerID = player:getId()
    local playerGuid = player:getGuid()
    local playersT = royale_get_playersT()
    playersT[playerID] = {isInQue = true}
    player:sendTextMessage(GREEN, "You have queued yourself to Battle Royale event")
    player:sendTextMessage(ORANGE, "You have queued yourself to Battle Royale event")
    player:sendTextMessage(BLUE, "NB! Battle Royale event starts will cause few second lag spikes")
    teleport(player, mapConf.waitingPos)
    player:saveItems("whi world")
    player:loadItems(royaleConf.startingItems)
    player:addHealth(1000)

    local startTime = royaleConf.eventStartTime
    local currentTime = os.time()
    local quePlayersT = royale_get_quePlayers()

    if startTime and startTime >= currentTime then
        local msg = "Event starts in "..startTime - currentTime.." seconds"
        for playerID, playerT in pairs(quePlayersT) do doSendTextMessage(playerID, BLUE, msg, 2000) end
    else
        if royale_get_quePlayersAmount() >= royaleConf.minPlayers then
            local msg = "Event starts in "..royaleConf.startTime.." seconds"
            for playerID, playerT in pairs(quePlayersT) do doSendTextMessage(playerID, BLUE, msg, 2000) end
            royaleConf.eventStartTime = currentTime + royaleConf.startTime
            registerAddEvent("royale", "startEvent", royaleConf.startTime*1000, {royale_start})
        else
            local str1 = "Game starts "..royaleConf.startTime.." seconds after "..royaleConf.minPlayers.." players join the Battle Royale"
            local str2 = " or when moderator starts the event"
            player:sendTextMessage(BLUE, str1..str2)
        end
    end
end

function royale_que_unRegister(player)
    local player = Player(player)
    if not player then return end
    local playerID = player:getId()

    royaleConf.players[playerID] = nil
    addEvent(heal, 100, playerID, 1000)
    teleport(player, player:homePos())
    player:loadItems("whi world")
    player:sendTextMessage(GREEN, "You have been removed from Battle Royale event")
end

function royale_logOut(player)
    royaleConf.players[player:getId()] = nil
    if not isInRange(player:getPosition(), mapConf.upCorner, mapConf.downCorner, true) then return true end
    
    teleport(player, player:homePos())
    player:loadItems("whi world")
end

function royale_unregister()
    for playerID, playerT in pairs(royale_get_playersT()) do
        if not playerT.isInQue then royale_que_unRegister(playerID) end
    end
end

function royale_start(forceStart)
    local playersT = royale_get_quePlayers()
    local playerAmount = tableCount(playersT)
    local errorMsg
    local playersInGame = false
    
    for playerID, playerT in pairs(royale_get_playersT()) do
        if playerT.isInGame then
            if not forceStart then
                playersInGame = true
                errorMsg = "Battle Royale event can't be started when there are players currently playing it, trying again in "..royaleConf.startTime.." seconds"
                royaleConf.eventStartTime = os.time() + royaleConf.startTime
                registerAddEvent("royale", "startEvent", royaleConf.startTime*1000, {royale_start})
                break
            end
        end
    end

    if not forceStart then
        if not errorMsg and playerAmount < 2 then errorMsg = "Battle Royale event can't be started with less than 2 players !!!" end
        
        if errorMsg then
            for playerID, playerT in pairs(playersT) do doSendTextMessage(playerID, GREEN, errorMsg) end
            return
        end
    end

    if not playersInGame then
        royale_clean()
        royale_startFire()
        royale_spawnItems()
    end
    
    royaleConf.corpsePosT = {}

    for playerID, playerT in pairs(playersT) do
        teleport(playerID, royale_get_enterPos())
        doSendTextMessage(playerID, GREEN, "Battle Royale event has started with "..playerAmount.." players !!!")
        doSendTextMessage(playerID, BLUE, "Battle Royale event has started with "..playerAmount.." players !!!")
        doSendTextMessage(playerID, BLUE, "Find gear, kill other players and avoid purple fire !!")
        doSendTextMessage(playerID, ORANGE, "Good fucking luck!")
        playerT.isInQue = false
        playerT.isInGame = true  
    end
end

function royale_end(forceEnd)
    local playersT = royale_get_playersT()
    local aliveCount = 0

    if not forceEnd then    
        for playerID, playerT in pairs(playersT) do
            if playerT.isInGame then aliveCount = aliveCount + 1 end
        end

        if aliveCount > 1 then
            for playerID, playerT in pairs(playersT) do doSendTextMessage(playerID, BLUE, aliveCount.."players remain in Battle Royale!!") end
            return
        end
    
        for playerID, playerT in pairs(playersT) do
            if playerT.isInGame then royale_rewardWinner(playerID) break end
        end
    end
    royale_unregister()
end

function royale_onDeath(player)
    local playerID = player:getId()
    local playersT = royale_get_playersT()
    local playerT = playersT[playerID]
    if not playerT or not playerT.isInGame then return end

    local playerName = player:getName()
    local damageMap = player:getDamageMap()
    local killerName = getHighestDamageDealerFromDamageT(damageMap, 'player') or "environment"
    
	if type(killerName) == "userdata" then killerName = killerName:getName() end
    local killMsg = playerName.." was killed by "..killerName

    for playerID, playerT in pairs(playersT) do
        if playerT.isInGame then doSendTextMessage(playerID, ORANGE, killMsg) end
    end

    local playerPos = player:getPosition()
    local corpse = createItem(6022, playerPos)

    table.insert(royaleConf.corpsePosT, playerPos)
    for _, item in pairs(player:getItems()) do item:moveTo(corpse) end
    playerT.isInGame = false
    playerT.isDead = true
    player:addHealth(10000)
    teleport(player, player:homePos())
    player:loadItems("whi world")
    royale_end()
end

function royale_rewardWinner(playerID)
    doSendTextMessage(playerID, GREEN, "GZ you won Battle Royale event!")
    doSendTextMessage(playerID, BLUE, "yes. This is all you get right now.")
    doSendTextMessage(playerID, ORANGE, "GZ!")
end

function royale_onMove(player, item, itemEx, fromPos, toPos, fromObject, toObject)
    if not isInRange(player:getPosition(), mapConf.upCorner, mapConf.downCorner, true) then return end
    if not item:isContainer() then return end
    
    if testServer() then
        if toPos.x == CONTAINERPOS then toObject = player else toObject = Tile(toPos) end
        if fromPos.x ~= CONTAINERPOS then fromObject = Tile(fromPos) else fromObject = player:getPosition() end
    end

    if not toObject:isPlayer() then
        local parent = getParent(toObject)
		if toObject:isContainer() and parent and parent:isPlayer() then toObject = parent end
	end
    if not toObject:isPlayer() then return true end
    
    local bag = player:getBag()
    if not bag then return end
    if bag:getSlotAmount() >= item:getSlotAmount() then return player:sendTextMessage(GREEN, "Current bag is same or better") end
    
    local items = bag:getItems()
    for _, bagItem in ipairs(items) do bagItem:moveTo(item) end
    bag:moveTo(fromObject)
    item:moveTo(toObject)
    return true
end

function royale_attack(player, target)
    local playerPos = player:getPosition()
    if not royale_isInGame(player) then return end

    local weapon = player:getSlotItem(SLOT_LEFT)
    local weaponT = royale_get_itemT(weapon)
    if not weaponT then return print("ERROR - player using weapon what is not registered in Battle Royale: "..weapon:getId()) end
    
    local playerPos = player:getPosition()
    local targetPos = target:getPosition()
    local distance = getDistanceBetween(playerPos, targetPos)
    if distance > weaponT.range then return player:sendTextMessage(WHITE, "Get closer to target to shoot") end

    if weaponT.range > 1 then
        local ammo = player:getSlotItem(SLOT_AMMO)
        local ammoT = getAmmoT(ammo) -- using Whi World arrow ID's
        if not ammoT then return player:sendTextMessage(WHITE, "You are out of ammo") end
        doSendDistanceEffect(playerPos, targetPos, 3)
        ammo:remove(1)
    end
    
    addWeaponCooldown(player, weaponT)
    dealDamage(player, target, PHYSICAL, weaponT.damage, 1, O_royale)
    return true
end

function royale_onLook(player, item)
    if not item:isItem() then return end
    local playerPos = player:getPosition()
    if not isInRange(playerPos, mapConf.upCorner, mapConf.downCorner, true) then return end

    local itemT = royale_get_itemT(item)
    if not itemT then return end

    local itemPos = item:getPosition()
    if getDistanceBetween(playerPos, itemPos) > 1 then return player:sendTextMessage(GREEN, "Get closer to look item") end
    
    local desc = royaleConf.pseudoItemLook
    local itemCount = item:getCount()
    local countStr = itemCount > 1 and " ("..itemCount..")" or ""
    desc = desc:gsub("ITEM_NAME", itemT.name..countStr)

    if desc:match("STATS") then
        local stringT = royale_get_statStrT(itemT)
        local fullStr = ""
        
        if tableCount(stringT) > 0 then
            for i, itemStr in ipairs(stringT) do fullStr = fullStr..itemStr.."\n" end
        end
        desc = desc:gsub("STATS", fullStr)
    end
    return player:sendTextMessage(GREEN, desc)
end

function royale_runes_onUse(player, item, _, fromPos, toPos)
    local itemT = royale_get_itemT(item)
    doSendDistanceEffect(fromPos, toPos, itemT.de)
    
    local function activateEffects(playerID, pos)
        if itemT.damage then
            local effectOnHit = itemT.effectOnHit or getEffectByType(itemT.damType)
            dealDamagePos(playerID, pos, itemT.damType, itemT.damage, effectOnHit, O_royale, nil, itemT.effectOnMiss)
        end
        
        if itemT.createItemID then
            local item = createItem(itemT.createItemID, pos, 1, itemT.addItemAID)
            addEvent(removeItemFromPos, itemT.itemDuration_ms, itemT.createItemID, pos)
        end

        local creatureID = findCreatureID("player", pos)
        if not creatureID then return end

        if itemT.slowAmount then bindCondition(creatureID, "royale_slow", itemT.slowDuration_ms, {speed = -itemT.slowAmount}) end
        
        if itemT.drunkStepAmount then
            registerEvent(creatureID, "onThink", "royale_onThink_drunk")
            stopAddEvent(creatureID, "royale_drunk")
            local eventData = {unregisterEvent, creatureID, "onThink", "royale_onThink_drunk"}
            registerAddEvent(creatureID, "royale_drunk", itemT.drunkStepAmount*2000, eventData)
        end
    end

    local interval = itemT.interval_ms or 150
    local playerID = player:getId()

    item:remove(1)
    if not itemT.area then return addEvent(activateEffects, interval, playerID, toPos) end

    local positionT = getAreaPos(toPos, itemT.area, player:getDirection())
    for i, posT in pairs(positionT) do
        for _, pos in pairs(posT) do addEvent(activateEffects, i*interval, playerID, pos) end
    end
end

local drunk_CDT = {}
function royale_onThink_drunk(player)
    local playerID = player:getId()
    local cd = drunk_CDT[playerID] or 1

    if cd == 2 then
        drunk_CDT[playerID] = 1
        local exludeNumberT = {}
        local playerPos = player:getPosition()

        while tableCount(exludeNumberT) ~= 4 do
            local randomDir = getRandomNumber(0, 3, exludeNumberT)
            local position = getDirectionPos(playerPos, randomDir)
            
            table.insert(exludeNumberT, randomDir)
            player:say("*hic*", ORANGE)
            if not hasObstacle(position, "solid") then return teleport(player, position, true) end
        end
    else
        drunk_CDT[playerID] = 2
    end
end

function royale_food_onUse(player, item)
    local itemT = royale_get_itemT(item)

    if itemT.durationSec then
        local playerID = player:getId()
        local foodT = royaleConf.foodT[playerID] or {stackID = 0, completedStackID = 0, foodList = {}}
        local newStackID = foodT.stackID + 1
        
        foodT.foodList[newStackID] = {
            HP = itemT.regHP,
            MP = itemT.regMP,
            intervalHP = itemT.intervalHP,
            intervalMP = itemT.intervalMP,
            duration = itemT.durationSec,
            secondsPassed_HP = 0,
            secondsPassed_MP = 0,
        }
        
        foodT.stackID = newStackID
        royaleConf.foodT[playerID] = foodT
        registerEvent(player, "onThink", "royale_food_onThink")
    else
        if itemT.regHP then player:addHealth(itemT.regHP) end
        if itemT.regMP then player:addMana(itemT.regMP) end
    end

    if itemT.eatMsg then player:say(itemT.eatMsg, ORANGE) end
    item:remove(1)
end

function royale_food_unregister(player)
    local playerID = player:getId()
    if royaleConf.foodT[playerID] then royaleConf.foodT[playerID] = nil end
    unregisterEvent(player, "onThink", "royale_food_onThink")
end

function royale_food_onThink(player)
    local foodT = royaleConf.foodT[player:getId()]
    if not foodT then return royale_food_unregister(player) end
    local nextFoodID = foodT.completedStackID + 1
    local stackT = foodT.foodList[nextFoodID]
    local secondsPassed_HP = stackT.secondsPassed_HP + 1
    local secondsPassed_MP = stackT.secondsPassed_MP + 1

    if stackT.HP and secondsPassed_HP == stackT.intervalHP then
        player:addHealth(stackT.HP)
        stackT.secondsPassed_HP = 0
    elseif stackT.HP then
        stackT.secondsPassed_HP = secondsPassed_HP
    end

    if stackT.MP and secondsPassed_MP == stackT.intervalMP then
        player:addMana(stackT.MP)
        stackT.secondsPassed_MP = 0
    elseif stackT.MP then
        stackT.secondsPassed_MP = secondsPassed_MP
    end

    stackT.duration = stackT.duration - 1

    if stackT.duration == 0 then
        if nextFoodID == foodT.stackID then return royale_food_unregister(player) end
        foodT.foodList[nextFoodID] = nil
        foodT.completedStackID = nextFoodID
    end
end

function royale_startFire()
    local fireT = royaleConf.fire
    local newPositions = {}
    local loopID = 0

    local function putDownFire(pos)
        local tile = Tile(pos)
        if not tile then return end
        if findItem(fireT.itemID, pos) then return end
        
        local function registerFire(pos)
            if not Tile(pos):hasStairsUp() then
                createItem(fireT.itemID, pos, 1, fireT.itemAID)
                table.insert(fireT.positions, pos)
                royale_fire_onStep(findCreature("player", pos), true)
            end
            loopID = loopID + 1
            newPositions[loopID] = pos
        end

        local newPos = getGotoPos(pos)
        if newPos then
            if not tile:hasHole() then registerFire(pos) end
            if getGotoPos(newPos) then putDownFire(newPos) end
            pos = newPos
        elseif not Tile(pos):hasDoor() and hasObstacle(pos, {"noGround", "solid"}) then
            return
        end

        registerFire(pos)
    end

    local function spreadFire(pos, ID)
        if type(pos) == "number" then return end

        for _, direction in pairs(compass1) do
            local newPos = getDirectionPos(pos, direction)
            putDownFire(newPos)
        end
    end
    
    if tableCount(fireT.spreadPositions) == 0 then
        for _, pos in ipairs(fireT.startingPositions) do putDownFire(pos) end
    else
        for ID, pos in pairs(fireT.spreadPositions) do spreadFire(pos, ID) end
    end

    fireT.spreadPositions = newPositions
    if tableCount(newPositions) == 0 then return end
    registerAddEvent("royale", "purpleFire", fireT.spreadSpeed, {royale_startFire})
end

function royale_fire_onStep(player, item, _, fromPos)
    local player = Player(player)
    if not player then return end
    
    local playerPos = player:getPosition()
    if not item and not samePositions(playerPos, fromPos) then return end
    
    local fireT = royaleConf.fire
    local playerID = player:getId()
    dealDamage(0, player, FIRE, fireT.damage, getEffectByType(FIRE), O_royale)
    addEvent(royale_fire_onStep, fireT.reDamTime, playerID, nil, _, playerPos)
end

function royale_field_onStep(player, item, _, fromPos)
    local fieldT = royale_get_fieldT(item)

    damageOverTime(player, fieldT.damage, fieldT.damType, fieldT.interval, fieldT.effect, nil, O_royale, fieldT.duration*1000)
end

function royale_removeFire()
    local fireT = royaleConf.fire
    stopAddEvent("royale", "purpleFire")
    for _, pos in ipairs(fireT.positions) do removeItemFromPos(fireT.itemID, pos) end
    fireT.positions = {}
    fireT.spreadPositions = {}
end

function royale_spawnItems()
    local itemSpawnT = royaleConf.itemSpawnT

    local function spawnItem(itemT, pos, containerID)
        if not itemT.maxCount then Uprint(itemT, "broken itemT") end
        local count = getRandomNumber(1, itemT.maxCount)
        if not containerID then return createItem(itemT.itemID, pos, count, itemT.itemAID) end
        local container = findItem(containerID, pos)
        createItem(itemT.itemID, nil, count, itemT.itemAID, nil, nil, container)
    end

    local function getValueFromChanceMap(tableWithChanceT, maxValue)
        local n = getRandomNumber(1, maxValue)
    
        for chanceT, t in pairs(tableWithChanceT) do
            if n >= chanceT.min and n <= chanceT.max then return t end
        end
    end

    local function trySpawnItem(pos, containerID)
        local itemTypeT = getValueFromChanceMap(itemSpawnT.itemTypes, itemSpawnT.itemType_maxV)
        if type(itemTypeT) == "string" then return end

        local itemT = getValueFromChanceMap(itemTypeT.items, itemTypeT.items_maxV)
        spawnItem(itemT, pos, containerID)
        if not chanceSuccess(itemT.secFindRate) then return end

        local secItemT = royale_get_itemT(itemT.secItemID)
        if not secItemT then return end
        spawnItem(secItemT, pos, containerID)
    end

    for _, posConfT in pairs(itemSpawnT.itemPosConf) do trySpawnItem(posConfT.pos, posConfT.containerID) end
end

function royale_clean()
    royale_removeFire()

    for _, pos in ipairs(mapConf.allPositions) do
        for itemTypeStr, itemTypeT in pairs(royaleConf.itemTypes) do
            local item = findItem(nil, pos, itemTypeT.itemAID)
            if item then item:remove() end
        end
    end

    for _, confT in pairs(royaleConf.itemSpawnT.itemPosConf) do
        if confT.containerID then
            local container = findItem(confT.containerID, confT.pos)
            container:clearContainer()
        end
    end

	local corpseList = {6022, 3059, 3058, 3059, 3060}
	for _, pos in pairs(royaleConf.corpsePosT) do
		for _, itemID in ipairs(corpseList) do removeItemFromPos(itemID, pos) end
	end
end

function royale_onHealthChange(player, damage, damType)
    local playerT = royale_get_playersT()[player:getId()]
    if not playerT or not playerT.isInGame then return 0, damType end
    if damType == COMBAT_HEALING then return damage, damType end
    if damType == DEATH then return damage, damType end
    
    local damage = damage > 0 and damage or -damage
	local dodgePercent = 0
	local armorPercent = 0
    local resistance = 0

    local function changeDamage(slotID)
        local item = player:getSlotItem(slotID)
        if not item then return end
        local itemT = royale_get_itemT(item)
        if not itemT then return end

        if itemT.armor then armorPercent = armorPercent + itemT.armor end
        
        local function addRes(amount) resistance = resistance + (amount or 0) end

        if damType == PHYSICAL then
			if itemT.dodge then dodgePercent = dodgePercent + itemT.dodge end
			return addRes(itemT.physicalRes)
		end
        if damType == ICE then return addRes(itemT.iceRes) end
        if damType == FIRE then return addRes(itemT.fireRes) end
        if damType == ENERGY then return addRes(itemT.energyRes) end
        if damType == DEATH then return addRes(itemT.deathRes) end
        if damType == EARTH then return addRes(itemT.earthRes) end
        if damType == HOLY then return addRes(itemT.holyRes) end
    end
    
    for slotID=0, 13 do changeDamage(slotID) end
    if damage < 1 then return 0, damType end

    if chanceSuccess(dodgePercent) then
        player:say("*dodge*", ORANGE)
        damage = 0
    else
        damage = damage - percentage(damage, armorPercent)
        damage = damage - percentage(damage, resistance)
    end
	return damage, damType
end

-- get functions
function royale_get_quePlayersAmount() return tableCount(royale_get_quePlayers()) end

function royale_get_playersT()
    if not royaleConf.players then return {} end
    for playerID, t in pairs(royaleConf.players) do
        if not Player(playerID) then royaleConf.players[playerID] = nil end
    end
    return royaleConf.players
end

function royale_get_quePlayers()
    local playersT = {}

    for playerID, t in pairs(royale_get_playersT()) do
        if t.isInQue then playersT[playerID] = t end
    end
    return playersT
end

function royale_get_itemT(object)
    if type(object) == "userdata" then object = object:getId() end

    for itemTypeStr, itemTypeT in pairs(royaleConf.itemTypes) do
        for itemID, itemT in pairs(itemTypeT.items) do
            if itemID == object then return itemT end
        end
    end
end

function royale_get_fieldT(object)
    if type(object) == "userdata" then object = object:getActionId() end

    for fieldAID, fieldT in pairs(royaleConf.fields) do
        if fieldAID == object then return fieldT end
    end
end

function royale_parseValue(text, value, damType)
    if type(value) == "number" then
        local numberSymbol = value < 0 and "-" or "+"
        text = text:gsub("SECONDS", (value > 1 and "seconds" or "second"))
        text = text:gsub("PLUS", numberSymbol)
        text = text:gsub("VALUE", value)
    end
    
    if text:match("%b()") then text = text:gsub("%b()", calculate(nil, text:match("%b()"))) end
    if text:match("DAMTYPE") then text = text:gsub("DAMTYPE", getEleTypeByEnum(damType):lower()) end
    return text
end

function royale_get_statStrT(itemT)
    local statT = {}

    local function insertStat(t, itemStat)
        if not itemT[itemStat] then return end
        local statStr = t.funcStr and _G[t.funcStr](itemT) or t.fullStr or "broken stat str"
        
        statStr = royale_parseValue(statStr, itemT[itemStat], itemT.damType)
        statT[t.sequenceID] = statStr
    end

    for itemStat, t in pairs(royaleConf.statStrings) do insertStat(t, itemStat) end
    
    local sortedKeyT = sorting(statT, "low")
    local newStat = {}
    for key, value in ipairs(sortedKeyT) do newStat[key] = statT[value] end
    return newStat
end

function royale_isInQue(player) return royale_get_quePlayers()[player:getId()] end

function royale_isInGame(player)
    local playerT = royale_get_playersT()[player:getId()]
    return playerT and playerT.isInGame
end

function getItemStr_regHP(itemT) return "Regenerates "..itemT.regHP.." health per "..plural("second", itemT.intervalHP) end
function getItemStr_regMP(itemT) return "Regenerates "..itemT.regMP.." mana per "..plural("second", itemT.intervalMP) end
function getRuneStr_slow(itemT) return "Slows target by "..itemT.slowAmount.." for "..getTimeText(itemT.slowDuration_ms, true) end
function getRuneStr_createItem(itemT) return "Creates "..itemT.createdItemName.." for "..getTimeText(itemT.itemDuration_ms, true) end

function royale_get_enterPos()
    local nextPosID = mapConf.lastStartingLocationID + 1
    if nextPosID > mapConf.startingLocationAmount then nextPosID = 1 end
    mapConf.lastStartingLocationID = nextPosID
    return mapConf.startingLocations[nextPosID]
end