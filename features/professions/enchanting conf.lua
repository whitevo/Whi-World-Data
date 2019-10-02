--[[    enchantingConf guide
    defaults = {                        table where any key can have default value
        count = INT
        exp = INT
    },
    
    spellScrolls = {
        [STR] = {
            reqT = {{
                itemID = INT,           
                itemAID = INT,          
                count = INT or 1,       
                fluidType = INT,        
            }},
            exp = INT or 0              how much experience crafting gives
            enchantinglevel = INT or 0  required enchanting level to craft 
            --name = STR                same with table key
            --itemAID = INT             AID.spells[name]
            --choiceID = INT            choiceID for crafting spells
        }
    }
    
    other = {
        [STR] = {                       craftName
            reqT = {{
                itemID = INT,
                itemAID = INT,
                count = INT or 1,
                fluidType = INT,
            }},
            exp = INT or 0              enchanting experience
            allSV = {[SV] = v},
            enchantinglevel = INT or 0  required enchanting level to craft 
            bigSV = {[SV] = v},
            itemID = INT,
            itemAID = INT,
            itemText = STR,             "randomStats" rolls random stats to item
            fluidType = INT,
            count = INT or 1
            itemName = STR or item:getName()
            gems2_Info = true           gems2_getLookText(itemID, "gemLook")

            --
            ID = INT                    choiceID for modal windows
            craftName = STR             key of the table
        }
    },
    
    magicDustItems = {{                 order is so itemAID items are executed first with ipairs (to make sure there is no conflicts)
        itemID = INT,                   
        itemAID = INT,                  
        magicDust = INT or 1,           how much dust you get for burning the item
        chance = INT or 100,            % chance to get the dustAmount per item
    }},
    
    professionT = {
        professionStr = STR
        expSV = INT
        levelSV = INT
        mwID = INT
    },
    
    -- automatic
    levelUpMessages = {             generated based of spellScrolls enchantinglevel
        [INT] = {STR},              INT = level which was achieved. STR = messages they will receive
    }
]]

local AIDT = AID.enchanting
local tier1ReqT = {{itemID = 5905, count = 5}, {itemID = 2600}, {itemID = 4842}}
local tier2ReqT = {{itemID = 5905, count = 15}, {itemID = 2600}, {itemID = 4842}}
local tier3ReqT = {{itemID = 5905, count = 25}, {itemID = 2600}, {itemID = 4842}}

enchantingConf = {
    defaults = {
        count = 1,
        exp = 10,
    },
    spellScrolls = {
        ["spark"]       = {exp = 40, reqT = tier1ReqT},
        ["heal"]        = {exp = 40, reqT = tier1ReqT},
        ["armorup"]     = {exp = 40, reqT = tier1ReqT},
        ["trap"]        = {exp = 40, reqT = tier1ReqT},
        ["barrier"]     = {exp = 70, enchantinglevel = 1, reqT = tier2ReqT},
        ["heat"]        = {exp = 70, enchantinglevel = 1, reqT = tier2ReqT},
        ["strike"]      = {exp = 70, enchantinglevel = 1, reqT = tier2ReqT},
        ["poison"]      = {exp = 70, enchantinglevel = 1, reqT = tier2ReqT},
        ["transform"]   = {exp = 100, enchantinglevel = 2, reqT = tier3ReqT},
        ["voltage"]     = {exp = 100, enchantinglevel = 2, reqT = tier3ReqT},
        ["tumble"]      = {exp = 100, enchantinglevel = 2, reqT = tier3ReqT},
        ["veteran"]     = {exp = 100, enchantinglevel = 2, reqT = tier3ReqT},
    },
    magicDustItems = {
        {itemID = 5925, chance = 40},
        {itemID = 11136, chance = 40},
        {itemID = 11208, chance = 40},
        {itemID = 2183, magicDust = 10},
        {itemID = 2190, magicDust = 10},
        {itemID = 13760, magicDust = 30},
        {itemID = 15400, magicDust = 30},
    },
    other = {
        ["fertilizer"] = {
            reqT = {itemID = ITEMID.materials.sand, itemAID = AID.other.buildingSand},
            exp = 10,
            itemID = 13196,
        },
        ["health gem"] = {
            reqT = {
                {itemID = 2147, count = 10},
                {itemID = 5905, count = 2},
            },
            exp = 25,
            itemID = 2156,
            itemName = "health gem",
            gems2_Info = true,
        },
        ["mana gem"] = {
            reqT = {
                {itemID = 2146, count = 10},
                {itemID = 5905, count = 2},
            },
            exp = 25,
            itemID = 2158,
            itemName = "mana gem",
            gems2_Info = true,
        },
        ["resistance gem"] = {
            reqT = {
                {itemID = 2150, count = 10},
                {itemID = 5905, count = 2},
            },
            exp = 25,
            itemID = 2153,
            itemName = "resistance gem",
            gems2_Info = true,
        },
        ["cooldown gem"] = {
            reqT = {
                {itemID = 2149, count = 10},
                {itemID = 5905, count = 2},
            },
            exp = 25,
            itemID = 2155,
            itemName = "cooldown gem",
            gems2_Info = true,
        },
        ["loot gem"] = {
            reqT = {
                {itemID = 9979, count = 10},
                {itemID = 5905, count = 2},
            },
            exp = 25,
            itemID = 2154,
            itemName = "loot gem",
            gems2_Info = true,
        },
    },
    professionT = {
        professionStr = "enchanting",
        expSV = SV.enchantingExp,
        levelSV = SV.enchantingLevel,
        mwID = MW.enchanting,
    }
}

local feature_enchanting = {
    startUpFunc = "enchanting_startUp",
    AIDItems_onLook = {
        [AIDT.enchantingAltarSign] = {
            allSV = {[SV.enchantingAltarHint] = -1},
            setSV = {[SV.enchantingAltarHint] = 0},
            text = {msg = "disintegrate magic"},
            textF = {msg = "disintegrate magic"},
        },
        [AIDT.purpleFire] = {
            text = {
                svText = {
                    [{SV.enchantingAltarHint, -1}] = {msg = "You see purple fire.\nMaybe something is written about this on the tablet on this wall"},
                    [{SV.enchantingAltarHint, 0}] = {msg = "You see purple fire.\nMaybe it has something to do with magic.\nI should talk to Niine about this"},
                    [{SV.enchantingAltarHint, 1}] = {msg = "You see purple fire.\nThrow spell scrolls into it to get magic dust"},
                }
            }
        },
        [AID.spells.transform] = {text = {msg = "tier 5 spell.\nTransforms you into Bear.\nSpell not yet usable in game"}},
        [AID.spells.voltage] = {text = {msg = "tier 5 spell.\nImproves next energy spell you cast.\nSpell not yet usable in game"}},
        [AID.spells.tumble] = {text = {msg = "tier 5 spell.\nJumps you back into position you were 2 seconds ago.\nSpell not yet usable in game"}},
        [AID.spells.veteran] = {text = {msg = "tier 5 spell.\nPassive ability to increase player stats when fighting\nSpell not yet usable in game"}},
    },
    AIDItems = {
        [AID.spells.transform] = {text = {msg = "Spell not yet usable in game"}},
        [AID.spells.voltage] = {text = {msg = "Spell not yet usable in game"}},
        [AID.spells.tumble] = {text = {msg = "Spell not yet usable in game"}},
        [AID.spells.veteran] = {text = {msg = "Spell not yet usable in game"}},
    },
    npcChat = {
        ["niine"] = {
            [1] = {
                question = "Do you know anything about the purple fire in Rooted Catacombs?",
                allSV = {[SV.enchantingAltarHint] = 0},
                setSV = {[SV.enchantingAltarHint] = 1},
                answer = {
                    "You mean the magic altar fire?",
                    "Well yeah, you can throw items that are created with strong magic into the fire.",
                    "if item has excess magic power you might get some magic dust from it",
                    "When I was learning enchanting, I used to throw spell scrolls I didnt need, back to the purple fire.",
                },
            },
            [2] = {
                question = "Can you tell me more about magic?",
                allSV = {[SV.enchantingAltarHint] = 1, [SV.priest10] = -1},
                setSV = {[SV.priest10] = 1},
                answer = {
                    "With my pleasure,",
                    "as you already know this world has several types of magic: fire, ice, energy, holy, earth and death.",
                    "But what you might not know is that magic is divided into 2 categories: light magic and dark magic",
                    "dark magic isn't necessarily evil, but it is quite dangerous to use it and harmful to cast",
                    "death magic usually requires souls or life force to cast therefor its dark magic.",
                    "earth magic also usually requires life force to cast hence its under dark magic too.",
                    "fire, ice and energy magic however is light magic, because it uses only the air around us.",
                    "holy magic doesn't consume soul nor spirit, but rather exhausts them, therefor its also a light magic.",
                    "Now if you understand that, you should be more intelligible towards people who distrust or dislike mages and hunters.",
                    "After all this war and missfortune is because of mage named Dide Freu'el .. :c",
                },
            },
        },
    },
    npcShop = {
        npcName = "niine",
        items = {itemID = 2600, cost = 5},
    },
    modalWindows = {
        [MW.enchanting] = {
            name = "enchanting profession",
            title = "enchantingMW_title",
            choices = {
                [1] = "create spell scrolls",
                [2] = "enchant other things",
            },
            buttons = {
                [100] = "show",
                [101] = "back",
            },
            func = "enchantingMW",
            say = "*checking enchanting profession*",
        },
        [MW.enchanting_spellScrolls] = {
            name = "craft spell scrolls",
            title = "enchantingMW_title",
            choices = "enchanting_spellScrollsMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "create",
            },
            func = "enchanting_spellScrollsMW",
        },
        [MW.enchanting_other] = {
            name = "enchant things*",
            title = "enchantingMW_title",
            choices = "enchanting_otherMW_choices",
            buttons = {
                [100] = "show",
                [101] = "back",
                [102] = "enchant",
            },
            func = "enchanting_otherMW",
        },
        
    },
}
centralSystem_registerTable(feature_enchanting)