--[[ loot guide
    storage = INT                           firstTime special loot bonus
    
    bounty = {
        [INT] = {amount = STR}              itemID, STR = global variable INT amount
    },
    
    items = {
        [INT] = {                           itemID of item
            name = STR                      
            chance = {INT} or 0             % chance to drop [0.1-100] | if table used then repeats itemChance calculation, corresponds with count
                                            EXAMPLE: chance = {100, 50, 10}, count = {1,4,6}
            count = {INT} or 1              up to how many can drop.
            itemAID = {INT}                 puts one of the itemAID from the list to item
            itemText = STR                  item text added when item drops
            fluidType = INT                 type of item
            [vocation Name] = INT           % chance how much extra chance player gets
            firstTime = INT                 % chance how much extra chance player gets killing this monster first time
            partyBoost = true               increases drop cahcne by lootSystem_partyChance% for each extra player in party
            unique = false                  true if you dont want to allow this item stacking
            
            itemAID_chance = {              used if with sameID different AID's should be dropped
                [INT] = {                   itemAID
                    [vocation Name] = INT   % chance how much extra chance player gets
                    chance = INT or 0       % chance to drop [0.1-100]
                }
            }
            bigSV = {[SV] = INT}            if SV >= INT then passes
            allSV = {[SV] = INT}            if SV == INT then passes

            AUTOMATIC
            itemID = INT                    same with table key (or set manually)
        }
    }
]]
-- in future spellScroll STR should be actionID which also automatically sets the spellScroll AID on drop.

lootSystem_partyChance = 0.4       -- this is 40%
centralSystem_extraLootChance = {}  -- _ = funcStr
centralSystem_bonusLootChance = {}  -- _ = funcStr
loot = {}

local lootSystem = {
    startUpFunc = "lootSystem_startUp",
    AIDItems = {
        [AID.other.corpse] = {funcStr = "lootSystem_canOpenCorpse"}
    }
}
centralSystem_registerTable(lootSystem)
print("lootSystem loaded..")