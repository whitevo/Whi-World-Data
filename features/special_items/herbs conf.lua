--[[ herbs guide
    [INT] =  {                      itemAID of herb what turns into powder
        name = STR      
        itemID = INT                itemID for unmoveable herb (the one what grows)
        location = STR              where these herbs generally are found
        toolEleType = STR           if requires enchanted tool to pick it up (STR = gem elemental types)
        powderColor = INT           itemID of the powder
        powderAID = INT             itemAID of the powder
        seedAID = INT               itemAID of the herb seed
        failedToPickUpMsg = STR     error msg for player when he doesnt have enough charges or wrong enchant type on herb knife
        respawnSeconds = INT        in how many seconds herb spawns back
        effectsOnHerbRemove = INT   ENUM of magic effect
        growBack = BOOL             instead of removing item, uses os.time() on item
        speedBallPoints = INT       How many Speedball minigame points it costs to get one
        allSV = {[SV] = INT}        storages values required to know and do something with the herb
        learnedSV = INT             -1 = doesnt know about herb, 0 = has taken herb to tonka, 1 = about to turn herb info to tonka, 2 = herb learned
        rep = {                     for priest reputation
            repSV = INT             storage value what keeps track how many herbs given
            bulk = INT              How many herbs to give at once to increase rep
            maxRep = INT            How many reputation gets per bulk
            reduce = INT            How much reputation reduces every time bulk is given
        },
        hintInfo = STR              Tonka hint where the information can be found
        hintItemAID = INT           itemAID of item which would learn the hint
        herbHint = STR              MSG you get from finding the hint
        instaAnswer = STR           tells you about the herb instantly STR is the message what he says (sets learnedSV to 2)
        tonkaAnswer = STR           Answer you get after you found information to Tonka
        tonkaHerbs = STR            Information written in tonka modal window after herb is learned
        
        -- automatic
        herbAID = INT               itemAID of herb what turns into powder
        tonkaID = INT               choice id for tonka modal windows
        chanceToGet = INT           comes with farming feature
    }
]]

local AIDT = AID.herbs
local powderColor = {red=8299, green=8298, yellow=8301, blue=8302} -- powder itemID

herbs = {
    [AIDT.flysh] = {
        name = "Flysh herb",
        itemID = 17751,
        location = "Herb usually found in Cyclops Dungeon.",
        powderColor = powderColor.yellow,
        powderAID = AIDT.flysh_powder,
        seedAID = AIDT.flysh_seed,
        toolEleType = "ice",
        failedToPickUpMsg = "Flysh herb crumbled into pieces",
        respawnSeconds = 20*60,
        effectsOnHerbRemove = 14,
        learnedSV = SV.flysh,
        rep = {
            repSV = SV.flyshRep,
            bulk = 5,
            maxRep = 11,
            reduce = 4,
        },
        hintInfo = "Borthonos should know the formula for Flysh herb",
        hintItemAID = AID.areas.borthonosRoom.scroll,
        herbHint = "Flysh is used for Flash Potion.",
        tonkaAnswer = "Ahh, I see! Dem Secrets! So enchated ice herb knife is required. Interesting.",
        tonkaHerbs = "Flysh can be obtained with ice enchanted herb knife and used for making Flash Potions.",
    },
    [AIDT.shadily_gloomy_shroom] = {
        name = "Shadily Gloomy Shroom herb",
        itemID = 17750,
        location = "Herb usually found in Cyclops Dungeon.",
        powderAID = AIDT.shadily_gloomy_shroom_powder,
        powderColor = powderColor.blue,
        seedAID = AIDT.shadily_gloomy_shroom_seed,
        toolEleType = "death",
        failedToPickUpMsg = "Shroom turned into smoke and dissapeared.",
        respawnSeconds = 20*60,
        effectsOnHerbRemove = 3,
        learnedSV = SV.shadilyGloomyShroom,
        rep = {
            repSV = SV.shadilyGloomyShroomRep,
            bulk = 5,
            maxRep = 11,
            reduce = 4,
        },
        hintInfo = "Check up on Peeter, he used to hand out spellcaster potions long time ago.",
        hintItemAID = AID.areas.northForest.lettersInMountain,
        herbHint = "You received wet papers, but you can still make few words out. 'death', 'knife', 'shroom'",
        tonkaAnswer = "Cool, so you had to use death enchanted herb knife. Figured (not rly)",
        tonkaHerbs = "Shadily gloomy shroom can be obtained with death enchanted herb knife and used for making Spellcaster Potions.",
    },
    [AIDT.xuppeofron] = {
        name = "Xuppeofron herb",
        itemID = 10912,
        location = "Herb usually found growing on Solstice trees.",
        powderAID = AIDT.xuppeofron_powder,
        seedAID = AIDT.xuppeofron_seed,
        powderColor = powderColor.yellow,
        toolEleType = "energy",
        growBack = true,
        failedToPickUpMsg = "Xuppeofron expanded and exploded.",
        respawnSeconds = 20*60,
        effectsOnHerbRemove = {11, 13},
        learnedSV = SV.xuppeofron,
        allSV = {[SV.xuppeofron] = 2},
        rep = {
            repSV = SV.xuppeofronRep,
            bulk = 5,
            maxRep = 11,
            reduce = 4,
        },
        hintInfo = "Sadly I think this information is lost, the secrets of xuppeofron was carried by old man who job was to document the secrets and take them to bandit mountains.",
        hintItemAID = AID.areas.forestDesertBorder.letterBody,
        herbHint = "word Xuppeofron is written near solstice tree and arrow points on leaves, there also seems to be energy symbol drawn corner of paper.",
        tonkaAnswer = "Wow you are doing us a great favor finding all the good secrets, keep it up!.",
        tonkaHerbs = "Xuppeofron can be on solstice trees and obtained with energy enchanted herb knife and used for making Silence Potions.",
    },
    [AIDT.stranth] = {
        name = "Stranth herb",
        itemID = 11813,
        location = "Herb usually bought from Speedball Minigame.",
        powderAID = AIDT.stranth_powder,
        seedAID = AIDT.stranth_seed,
        powderColor = powderColor.yellow,
        growBack = true,
        effectsOnHerbRemove = {17, 15},
        learnedSV = SV.stranth,
        respawnSeconds = 20*60,
        speedBallPoints = 50,
        hintInfo = "Find the green book in Forgotten Village. If I recall correctly, on page 83 the was something about Stranth",
        hintItemAID = AID.areas.forgottenVillage.greenBook,
        herbHint = "Stranth is used for Druid Potion.",
        tonkaAnswer = "Nice, you found the book and the information.",
        tonkaHerbs = "Stranth is obtainable from speedBall minigame and used for making Druid Potions.",
        
    },
    [AIDT.oawildory] = {
        name = "Oawildory herb",
        itemID = 11817,
        location = "Herb usually bought from Speedball Minigame.",
        powderAID = AIDT.oawildory_powder,
        seedAID = AIDT.oawildory_seed,
        powderColor = powderColor.red,
        learnedSV = SV.oawildory,
        houseSpawnSec = 20*60,
        speedBallPoints = 50,
        hintInfo = "Find the red book in Archanos Room in Bandit Mountains. On page 14 there was mentioned Oawildory.",
        hintItemAID = AID.areas.archanosRoom.redBook,
        herbHint = "Oawildory is used for Hunter Potion.",
        tonkaAnswer = "Cool, ty for finding that information.",
        tonkaHerbs = "Oawildory is obtainable from speedBall minigame and used for making Hunter Potions.",
        
    },
    [AIDT.eaddow] = {
        name = "Eaddow herb",
        itemID = 18391,
        location = "Herb usually bought from Speedball Minigame.",
        powderAID = AIDT.eaddow_powder,
        seedAID = AIDT.eaddow_seed,
        powderColor = powderColor.yellow,
        learnedSV = SV.eaddow,
        respawnSeconds = 20*60,
        speedBallPoints = 50,
        hintInfo = "Find the grey book in Cyclops Dungeons. There is information about Eaddow.",
        hintItemAID = AID.areas.cyclopsDungeon.greyBook,
        herbHint = "Eaddow is used for Mage Potion.",
        tonkaAnswer = "Cool you found the Grey book.",
        tonkaHerbs = "Eaddow is obtainable from speedBall minigame and used for making Mage Potions.",
        
        
    },
    [AIDT.jesh_mint] = {
        name = "Jesh Mint herb",
        itemID = 22440,
        location = "Herb usually bought from Speedball Minigame.",
        powderAID = AIDT.jesh_mint_powder,
        seedAID = AIDT.jesh_mint_seed,
        powderColor = powderColor.green,
        growBack = true,
        effectsOnHerbRemove = {5, 14},
        learnedSV = SV.jesh_mint,
        respawnSeconds = 20*60,
        speedBallPoints = 50,
        hintInfo = "I think Big Daddy has Jesh Mint information.",
        hintItemAID = AID.areas.bigDaddyRoom.bigDaddyNote,
        herbHint = "Jesh Mint is used for Knight Potion.",
        tonkaAnswer = "Wow you sure had some balls to ferret that information out.",
        tonkaHerbs = "Jesh Mint is obtainable from speedBall minigame and used for making Knight Potions.",
        
    },
    [AIDT.eaplebrond] = {
        name = "Eaplebrond herb",
        itemID = 2743,
        location = "Herb usually found in forest as red flowers.",
        powderAID = AIDT.eaplebrond_powder,
        seedAID = AIDT.eaplebrond_seed,
        powderColor = powderColor.red,
        learnedSV = SV.eaplebrond,
        respawnSeconds = 20*60,
        rep = {
            repSV = SV.eaplebrondRep,
            bulk = 5,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "Ask Niine about Eaplebrond, maybe she knows.",
        tonkaAnswer = "Niine is nice isn't she?.",
        tonkaHerbs = "Eaplebrond is obtainable from forest as red flowers and used for making Druid Potions.",
        
    },
    [AIDT.golden_spearmint] = { -- special case makes potion straight away
        name = "Golden Spearmint herb",
        itemID = 4152,
        location = "Herb usually found near forest mountains as yellow flowers.",
        powderAID = AIDT.golden_spearmint_powder,
        seedAID = AIDT.golden_spearmint_seed,
        powderColor = powderColor.yellow,
        learnedSV = SV.golden_spearmint,
        respawnSeconds = 20*60,
        rep = {
            repSV = SV.goldenSpearmintRep,
            bulk = 5,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "Ask Peeter about Golden Spearmint, perhaps he knows something.",
        tonkaAnswer = "Ok, cool seems I'm going to try new recipe today :D",
        tonkaHerbs = "Golden Spearmint is obtainable near forest mountains as yellow flowers and used for creating speed potions.",
        
    },
    [AIDT.brirella] = {
        name = "Brirella herb",
        itemID = 2742,
        location = "Herb usually found on Bandit Mountain as big white flowers.",
        powderAID = AIDT.brirella_powder,
        seedAID = AIDT.brirella_seed,
        powderColor = powderColor.green,
        learnedSV = SV.brirella,
        respawnSeconds = 20*60,
        rep = {
            repSV = SV.brirellaRep,
            bulk = 5,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "Come back to me later, I will try find out what is Brirella used for by then.",
        tonkaAnswer = "I'm going to write it down on my herb book so I find that info out faster next time.",
        tonkaHerbs = "Brirella is found on Bandit Mountain as a big white flower and used for spicing meat.",
    },
    [AIDT.dagosil] = {
        name = "Dagosil herb",
        itemID = 4155,
        location = "Herb usually found in Cyclops Dungeon under rocks.",
        powderAID = AIDT.dagosil_powder,
        seedAID = AIDT.dagosil_seed,
        powderColor = powderColor.red,
        learnedSV = SV.dagosil,
        houseSpawnSec = 20*60,
        rep = {
            repSV = SV.dagosilRep,
            bulk = 5,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "Ask Alice about Dagosil, perhaps she knows something.",
        tonkaAnswer = "Lovely, ty for the information.",
        tonkaHerbs = "Dagosil is found in Cyclops Dungeon as orange flowers and used for Hunter Potion.",
    },
    [AIDT.ozeogon] = {
        name = "Ozeogon herb",
        itemID = 2800,
        location = "Herb usually found from Cyclopses.",
        powderAID = AIDT.ozeogon_powder,
        seedAID = AIDT.ozeogon_seed,
        powderColor = powderColor.red,
        learnedSV = SV.ozeogon,
        houseSpawnSec = 20*60,
        rep = {
            repSV = SV.ozeogonRep,
            bulk = 3,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "Ask Bum about Ozeogon, perhaps he has some knowledge about that.",
        tonkaAnswer = "Seems like Bum sometimes do know his stuff..",
        tonkaHerbs = "Ozeogon is looted from Cyclopses and used for spicing apple.",
    },
    [AIDT.urreanel] = {
        name = "Urreanel herb",
        itemID = 2760,
        location = "Herb usually found from forest creatures.",
        powderAID = AIDT.urreanel_powder,
        seedAID = AIDT.urreanel_seed,
        powderColor = powderColor.yellow,
        learnedSV = SV.urreanel,
        houseSpawnSec = 15*60,
        rep = {
            repSV = SV.urreanelRep,
            bulk = 8,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "I heard that Urreanel hint has been ported to Forgotten Village somehow.",
        hintItemAID = AID.areas.forgottenVillage.wagon,
        herbHint = "Urreanel is used for Mage Potion and spicing hams.",
        tonkaAnswer = "Tt was hidden inside wagon? nice detective skills then.",
        tonkaHerbs = "Urreanel is looted from forest creatures and used for making Mage Potions and spicing hams.",
    },
    [AIDT.iddunel] = {
        name = "Iddunel herb",
        itemID = 2802,
        location = "Herb usually found from Bandits on the Bandit Mountain.",
        powderAID = AIDT.iddunel_powder,
        seedAID = AIDT.iddunel_seed,
        powderColor = powderColor.green,
        learnedSV = SV.iddunel,
        houseSpawnSec = 15*60,
        rep = {
            repSV = SV.iddunelRep,
            bulk = 5,
            maxRep = 5,
            reduce = 2,
        },
        hintInfo = "I lost a book in this forest, if you find it there is information about Iddunel",
        hintItemAID = AID.areas.eastForest.tornBook,
        herbHint = "Iddunel is used for Knight Potion.",
        tonkaAnswer = "You seriously went to go looking for a book in entire forest?! JESUS!.",
        tonkaHerbs = "Iddunel is looted from bandits in Bandit Mountain and used for making Knight Potions.",
    },
    [AIDT.mobberel] = {
        name = "Mobberel herb",
        itemID = 13881,
        location = "Herb usually found from Bandits in Hehemi.",
        powderAID = AIDT.mobberel_powder,
        seedAID = AIDT.mobberel_seed,
        powderColor = powderColor.yellow,
        learnedSV = SV.mobberel,
        houseSpawnSec = 15*60,
        rep = {
            repSV = SV.mobberelRep,
            bulk = 5,
            maxRep = 7,
            reduce = 2,
        },
        instaAnswer = "Mobberel is obtainable from Bandits in Hehemi and used for making Andidote Potions.",
        tonkaHerbs = "Mobberel is obtainable from Bandits in Hehemi and used for making Andidote Potions.",
    },
}

local npcNiiceAnswer_69 = {
    "Yea, you are getting quite useful and smart.",
    "You know how to take care of herbs and I like that about you.",
    "There are some special herbs out there in world like > flysh herb <,",
    "I myself don't exactly know how can it be obtained, but as I said:",
    "You are smart, I'm sure you can figure it out :D",
}
local npcNiiceAnswer_71 = {"Let me see..", "..hmm, do you know about > shadily gloomy shroom <?"}
local npcNiiceAnswer_73 = {
    "Great now that you asked :3",
    "Btw, I recently discovered there is new herb called > xuppeofron <",
    "perhaps you can find something out about that.",
}


local feature_herbs = {
    startUpFunc = "herbs_startUp",
    AIDItems = {
        [AID.areas.northForest.lettersInMountain] = {funcSTR = "herbs_discoverHint"},
    },
    AIDItems_onLook = {
        [AID.areas.northForest.lettersInMountain] = {
            allSV = {[SV.shadilyGloomyShroom] = 0},
            text = {msg = "You can see some wet letters in mountain crack."}
        },
    },
    npcChat = {
        ["niine"] = {
            [69] = {
                question = "Is there anything you need help with Niine?",
                allSV = {[SV.flysh] = -1, [SV.priestRepL] = 1, [SV.priest7] = -1},
                setSV = {[SV.flysh] = -2, [SV.priest7] = 1},
                answer = npcNiiceAnswer_69,
            },
            [70] = {
                question = "Is there anything you need help with Niine?", -- if player learns to use powder before hint is given
                allSV = {[SV.priest7] = -1},
                bigSV = {[SV.flysh] = 0, [SV.priestRepL] = 1},
                setSV = {[SV.priest7] = 1},
                answer = npcNiiceAnswer_69,
            },
            [71] = {
                question = "Any more of special herbs I should know about?",
                allSV = {[SV.shadilyGloomyShroom] = -1, [SV.priestRepL] = 2, [SV.priest8] = -1},
                bigSV = {[SV.priestRepL] = 2},
                setSV = {[SV.shadilyGloomyShroom] = -2, [SV.priest8] = 1},
                answer = npcNiiceAnswer_71,
            },
            [72] = {
                question = "Any more of special herbs I should know about?", -- if player learns to use powder before hint is given
                allSV = {[SV.priest8] = -1},
                bigSV = {[SV.shadilyGloomyShroom] = 0, [SV.priestRepL] = 2},
                setSV = {[SV.priest8] = 1},
                answer = npcNiiceAnswer_71,
            },
            [73] = {
                question = "How are you feeling today Niine?",
                allSV = {[SV.xuppeofron] = -1, [SV.priest9] = -1},
                bigSV = {[SV.priestRepL] = 3},
                setSV = {[SV.xuppeofron] = -2, [SV.priest9] = 1},
                answer = npcNiiceAnswer_73,
            },
            [74] = {
                question = "How are you feeling today Niine?", -- if player learns to use powder before hint is given
                allSV = {[SV.priest9] = -1},
                bigSV = {[SV.xuppeofron] = 0, [SV.priestRepL] = 3},
                setSV = {[SV.priest9] = 1},
                answer = npcNiiceAnswer_73,
            },
            [75] = {
                    question = "Do you know what for is Eaplebrond used?",
                    allSV = {[SV.eaplebrond] = 0},
                    setSV = {[SV.eaplebrond] = 1},
                    answer = "Eaplebrond is used for making Druid Potions.",
                },
        },
        ["peeter"] = {
            [112] = {
                question = "Do you know how to gather shadily gloomy shrooms?",
                allSV = {[SV.shadilyGloomyShroom] = 0},
                answer = {
                    "Well shit..",
                    "I knew it will come out one day...",
                    "I had it written down for me, but... umm well wind blew and shit and I lost the papers between that mountain crack right next to us.",
                    "No way to get them and don't think they are readable anymore.. sry.",
                },
            },
            [113] = {
                question = "Do you know what for is Golden Spearmint used?",
                allSV = {[SV.golden_spearmint] = 0},
                setSV = {[SV.golden_spearmint] = 1},
                answer = {"Golden Spearmint is used for spicing up ham."},
            },
        },
        ["tonka"] = {
            [138] = {
                question = "Do you know what for is Golden Spearmint used?",
                allSV = {[SV.brirella] = -2},
                setSV = {[SV.brirella] = 1},
                answer = "Brirella is used for spicing up meat.",
            },
        },
        ["alice"] = {
            [16] = {
                question = "Do you know what for is Dagosil used?",
                allSV = {[SV.dagosil] = 0},
                setSV = {[SV.dagosil] = 1},
                answer = "Dagosil is used for Hunter Potion.",
            },
        },
        ["bum"] = {
            [30] = {
                question = "Do you know what for is Ozeogon used?",
                allSV = {[SV.ozeogon] = 0},
                setSV = {[SV.ozeogon] = 1},
                answer = "Ozeogon is used for spicing up apple.",
            },
            [31] = {
                question = "You handle trades in Forgotten Village, have you gotten any recipe formulas?",
                allSV = {[SV.urreanel] = 0, [SV.smithUrranelInfo] = -1},
                setSV = {[SV.smithUrranelInfo] = 0},
                answer = {
                    "You talking about 'that' formula??",
                    "First off pay off the useless damages made by that..",
                    "It will cost you 3 coins.",
                },
            },
            [32] = {
                question = "I have the 12 coins for you damages",
                allSV = {[SV.urreanel] = 0, [SV.smithUrranelInfo] = 0},
                moreItems = {{itemID = ITEMID.other.coin, count = 3}},
                setSV = {[SV.smithUrranelInfo] = 1},
                removeItems = {{itemID = ITEMID.other.coin, count = 12}},
                answer = {
                    "Ty, next time, stop using my cart to carve message into it..",
                    "There are better ways to pass 'secret' information.",
                    "And that wasn't even hidden >.>",
                },
            },
            [33] = {
                question = "Where was the Urranel formula info carved again?",
                allSV = {[SV.urreanel] = 0, [SV.smithUrranelInfo] = 1},
                answer = "Inside my trading cart, next to depot house",
            },
        },
    },
}

centralSystem_registerTable(feature_herbs)

function herbs_startUp()
local choiceID = 0

    for herbAID, herbT in pairs(herbs) do
        choiceID = choiceID + 1
        herbT.tonkaID = choiceID
        herbT.herbAID = herbAID
        central_register_actionEvent({[herbT.powderAID] = {funcSTR = "herbs_usePowder"}}, "AIDItems")
        central_register_actionEvent({[herbAID] = {funcSTR = "herbs_pickUp"}}, "AIDItems")
        AIDItems_onLook[herbT.powderAID] = {funcSTR = "herbs_onLook"}
        AIDItems_onLook[herbAID] = {funcSTR = "herbs_onLook"}
        AIDItems_onLook[herbT.seedAID] = {funcSTR = "farming_herbSeedOnLook"}
    end
end