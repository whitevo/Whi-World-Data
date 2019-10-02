--[[ itemTable config guide
    [INT] = {                       item AID/ID
        allowFarUse = BOOL or false
        blockWalls = BOOL or true
        checkFloor = BOOL or true
        
        onlyPlayer = BOOL or true   if true then if the action activator is not a player then RETURNS nil
        
        timers = {
            time = INT              Item will trigger once every INT seconds globally.
            guidTime = INT          Item will trigger once every INT seconds for the player guid.
            text = INT              Item text what comes up when can't use yet
            showTime = BOOL         true - shows time remaining before can be clicked again.
                                    NB! must be used along with text, becase all it does it adds timeText as last part of string.
        },
        
        mana = INT                  gives INT amount of MP to player
        health = INT                gives INT amount of HP to player
        exp = INT                   gives INT amount of experience
        
        text = { or textF           textF = message when action system didn't activate
            useOnFail = false       if true then same text will be used when conditions have failed  (in others words its used as textF)
            type = ENUM or GREEN    ORANGE, GREEN, RED, WHITE, BLUE
            msg = {STR}             if table used, then splits them up in different sentences.
            text = {                text what appers on spefic location
                msg = STR       
                position = POS or itemPos    postion where text is put
            }
            svText = {
                [{INT, INT}] = {    first INT is storage value | second INT what storage value must be
                    msg = STR
                    type = ENUM or GREEN
                }
            }
        },
        
        rewardItems = {{            player gets items in this table
            itemID = INT or {}      if itemID is table then choose 1 id randomly from table.
            count = INT or 1        amount of items
            itemAID = INT or {}     if itemAID is table then choose 1 aid randomly from table.
            type = INT              if used then sets item type
            itemText = STR          if item should have TEXT -- itemTextMOD(creature, item, text)
                                    "randomStats" > items_randomiseStats(item)
                                    "playerName" > creature:getName()
                                    "accountID" > creature:getAccountId()
            itemName = STR or item:getName()
        }},
        
        hasItems or hasItemsF = {{  hasItemsF is true when player doesn't have the items
            itemID = INT,
            count = INT or 1,
            itemAID = INT,
            fluidType = INT,
        }},
        takeItems = {{
            itemID = INT,
            count = INT or 1,
            itemAID = INT,
            fluidType = INT,
        }},
        
        allSV = {[SV] = V}          If all of these storage values match, then action triggers
        setSV  = {[SV] = V}         player:setStorageValue(K, V)
        bigSV  = {[SV] = V}         storage values have to same or bigger
        addSV  = {[SV] = V}
        anySV  = {[SV] = {V}}       if any of these storage values match, then action triggers
                                    put values in table if there are several "ok" values in 1 SV
        
        ME = {                      Magic effect maker
            pos = POS or itemPos    POS = location for the magic effect to appear | STR = position is generated on action >> itemPos = item:getPosition()
            effects = INT or {}     Effects what are done in secuence 
            interval = INT or 0     the time between effects in milliseconds
        },
        
        transform = {
            itemID = INT or item:getId()            change into INT item. | if INT == 0 then removes item
            itemAID = INT or item:getActionId()     if INT < 100 then removes itemAID
            returnDelay = INT                       in milliseconds when item turns back
        },
        
        createMonster = {{
            name = STR              name of the monster
            pos = POS or itemPos    position for monster
            count = INT or 1        how many monsters
        }}
        
        createItems = {{
            itemID = INT or item:getId()
            itemAID = INT           if not itemID then DEFAULT item:getActionId()
            type = INT
            count = INT or 1
            pos = POS or itemPos
            delay = MSec            how many milliseconds later item is created
        }}
        
        removeItems = {{
            itemID = INT or item:getId()
            count = INT or 1
            pos = POS or itemPos
            delay = MSec        
        }}
        
        teleport or teleportF = POS     teleports to position
                                        "itemPos" = item:getPosition()
                                        "homePos" = player:homePos()
        
        funcSTR = STR           executes a function where parameters are (creature, item, itemEx, fromPos, toPos, fromObject, toObject)
                                if function returns true the actionSystem RETURNS false
                                MODIFICATIONS for 3rd parameter:
                                STR(fromPos) = 3rd parameter is position where player came from
                                
        returnFalse = BOOL      if true then returns false
    }
]]

AIDItems = {
    [AID.other.wineMachine] = {funcSTR = "wineMachineInForest"},
    [AID.other.beerMachine] = {funcSTR = "beerMachineInForest"},
    [AID.other.lockedDoor] = {text = {msg = "this door is locked"}},
    [AID.other.door] = {funcSTR = "openDoor"},
    [AID.other.cyclopsDebris] = {
        transform = {itemID = 0},
        text = {text = {msg = "*sweep*"}},
    },
    
    [AID.jazmaz.monsters.seaAbomination_damageRune] = {funcSTR = "seaAbomination_rune_onUse"},
    [AID.jazmaz.monsters.seaAbomination_summonRune] = {funcSTR = "seaAbomination_rune_onUse"},
    [AID.jazmaz.monsters.seaAbomination_bombRune]   = {funcSTR = "seaAbomination_rune_onUse"},
    [AID.jazmaz.monsters.seaAbomination_poisonRune] = {funcSTR = "seaAbomination_rune_onUse"},
    [AID.jazmaz.monsters.seaAbomination_protectRune]= {funcSTR = "seaAbomination_protectRune_onUse"},
    [AID.jazmaz.monsters.inky_bombRune] = {funcSTR = "inky_bombRune_onUse"},
}

AIDItems_onLook = {
    [1106] = {text = {msg = "entrance to Empire Event"}}, -- temp

    [AID.other.wineRecipe]      = {text = {msg = "Use test tube on blueberry and activate wine machine machine to make wine"}},
    [AID.other.beerRecipe]      = {text = {msg = "Use test tube on apple and activate beer machine to make beer"}},
    [AID.other.wineMachine]     = {text = {msg = "wine machine"}},
    [AID.other.beerMachine]     = {text = {msg = "beer machine"}},
    [AID.other.cyclopsStone]    = {text = {msg = "Cyclops stone, these stones fall on cyclops body when they have picked up stone and die before throwing them."}},
    [AID.other.cyclopsDebris]   = {text = {msg = "stone rubble"}},
    [AID.other.survivalDoor]     = {text = {msg = "Hardcore door \nPayers who have not died in past 2 hours can pass this door."}},
    
    [AID.jazmaz.monsters.seaAbomination_damageRune] = {text = {msg = "sea abomination magic stone - fire"}},
    [AID.jazmaz.monsters.seaAbomination_summonRune] = {text = {msg = "sea abomination magic stone - summon"}},
    [AID.jazmaz.monsters.seaAbomination_bombRune] = {text = {msg = "sea abomination magic stone - bomb"}},
    [AID.jazmaz.monsters.seaAbomination_poisonRune] = {text = {msg = "sea abomination magic stone - poison"}},
    [AID.jazmaz.monsters.seaAbomination_protectRune] = {text = {msg = "sea abomination magic stone - protection"}},
}

AIDItems_onMove = {}
IDItems_onMove = {}

IDItems = {
    [430] = {funcStr = "teleportBelow"},
    [2785] = {funcStr = "food_useBerryBush"},
    [1386] = {funcSTR = "ladderUp"},
    [3678] = {funcSTR = "ladderUp"},
    [5543] = {funcSTR = "ladderUp"},
    [1634] = {transform = {itemID = 1635}},
    [1635] = {transform = {itemID = 1634}},
    [1636] = {transform = {itemID = 1637}},
    [1637] = {transform = {itemID = 1636}},
    [7934] = {funcSTR = "testTube"},
    [7935] = {funcSTR = "potionStand"},
    [3871] = {
        createItems = {{delay = 10*60*1000}},
        removeItems = {{}},
        rewardItems = {{itemID = ITEMID.materials.log}},
    },
    [22124] = {funcStr = "climbOn"},
    [21874] = {funcStr = "climbOn"},
    [1591] = {funcStr = "climbOn"},
    [1590] = {funcStr = "climbOn"},
    [1590] = {funcStr = "climbOn"},
    [8786] = {funcStr = "climbOn"},
    [7059] = {transform = {itemID = 7058}},-- skeleton pillar
    [7058] = {transform = {itemID = 7059}},-- skeleton pillar
    [2050] = {transform = {itemID = 2051}},-- torch
    [2051] = {transform = {itemID = 2050}},-- torch
    
    [2005] = {funcSTR = "fluidContainer_onUse"},
    [2006] = {funcSTR = "fluidContainer_onUse"},
    [2012] = {funcSTR = "fluidContainer_onUse"},
    [2013] = {funcSTR = "fluidContainer_onUse"},
    [2014] = {funcSTR = "fluidContainer_onUse"},
    
    [5779] = {funcSTR = "stuckArrowSouth_onUse"},
    [5780] = {funcSTR = "stuckArrowSouth_onUse"},
    [5781] = {funcSTR = "stuckArrowSouth_onUse"},
    [5782] = {funcSTR = "stuckArrowWest_onUse"},
    [5783] = {funcSTR = "stuckArrowWest_onUse"},
    [5784] = {funcSTR = "stuckArrowWest_onUse"},
    [5789] = {funcSTR = "stuckAxe_onUse"},
    [5790] = {funcSTR = "stuckAxe_onUse"},
    
    [7696] = {funcStr = "oldSpellScroll_onUse"},
}

IDItems_onLook = {
    [17566] = {text = {msg = "Use this crystal to teleport out of the closed room."}},
}

AIDTiles_stepIn = {
    [1106] = {text = {msg = "Empire Event is currently disabled"}}, -- temp

    [AID.other.fireDOT100] = {funcSTR = "fireDOT100"},
    [AID.other.field_earth] = {funcSTR = "fieldDOT_earth"},
    [AID.other.field_energy] = {funcSTR = "fieldDOT_energy"},
    [AID.other.field_fire] = {funcSTR = "fieldDOT_fire"},
    [AID.other.hunterTrap] = {funcSTR = "hunterTrap"},
    [AID.other.corpse] = {funcSTR = "autoLoot_corpse"},
    [AID.other.survivalDoor] = {funcSTR = "survivalDoor"},

    [AID.jazmaz.monsters.mantaRay_splash] = {funcSTR = "mantaRay_splash"},
    [AID.jazmaz.monsters.seaDragon_healItem] = {funcSTR = "seaDragon_healItem"},
    [AID.jazmaz.monsters.seaDragon_poisonField] = {funcSTR = "seaDragon_poisonField_stepIn"},
    [AID.jazmaz.monsters.seaAbomination_poisonRune] = {funcSTR = "seaAbomination_poisonRune"},
}

AIDTiles_stepOut = {
    [AID.other.closeDoor] = {funcSTR = "closeDoor"},
    [AID.other.stun] = {funcSTR = "teleportBack"},
    [AID.other.root] = {funcSTR = "teleportBack"},
    [AID.other.bind] = {funcSTR = "teleportBack"},
    [AID.other.fakeDeathMoveCheck] = {funcSTR = "removeFakeDeath"},
    [AID.jazmaz.monsters.seaDragon_holdTile] = {funcSTR = "teleportBack"},
    [AID.jazmaz.monsters.seaAbomination_poisonRune] = {funcSTR = "seaAbomination_poisonRune"},
    [AID.jazmaz.monsters.seaAbomination_protectRune] = {funcSTR = "seaAbomination_protectRune_stepOut"},
}

IDTiles_stepIn = {
    [9825] = {funcSTR = "teleportBack"},
    [9826] = {funcSTR = "teleportBack"},
    [1945] = {funcSTR = "teleportBack"},
    [1946] = {funcSTR = "teleportBack"},
    [1423] = {funcSTR = "fireDOT100"},
    [460] = {funcStr = "tile460_teleportBack"},
    [459] = {funcStr = "walkDown"}, -- stairDown | stair down
    [ITEMID.other.coin] = {funcSTR = "autoLoot_gold"},
    [426] = {transform = {itemID = 425}},
    [446] = {transform = {itemID = 447}},
    [3216] = {transform = {itemID = 3217}},
}

IDTiles_stepOut = {
    [425] = {transform = {itemID = 426}},
    [447] = {transform = {itemID = 446}},
    [3217] = {transform = {itemID = 3216}},
}

onMoveT = {
    [1] = {funcStr = "moveContainer"},
}
onMoveT2 = {}

startUpT["actionSystem_startUp"] = 1
print("actionSystem loaded..")