-- automatically register npcPos
local AIDT = AID.quests.tutorial
local trackerSV = SV.tutorialTracker
local questSV = SV.tutorial
local confT = {
    tutorialExitPos = {x = 554, y = 705, z = 8},
    waitingPos = {x = 525, y = 736, z = 8},
    rooms = {
        ["walkRoom"] = {
            stages = {0, 1, 2},
            corners = {{upCorner = {x = 458, y = 760, z = 8}, downCorner = {x = 466, y = 770, z = 8}}},
            npcDir = "N",
            texts = {
                [0] = {
                    "Hello (name), welcome to Whi World.",
                    "I am an NPC, which stands for non-player character. I'm not very smart, but I will do my best to help you through this tutorial!",
                    "First of all let me explain one important thing. This client you are using is NOT designed for Whi World, it has many flaws and it's quite clunky, but for now it's either this or nothing.",
                    "Ok, now that we got that out of the way... Lets start with the tutorial, shall we?",
                    "You see that blue tile over there?",
                    "The blue tile is the goal for each tutorial room. You have to step on it to advance to the next room.",
                    "In this room, all you have to do is walk there. The trick is, after I move away, you can click on the blue tile and the game will find the shortest way to it for you.",
                    "Also, keep in mind that the further you click, the faster you reach your goal, because this client gives a one second delay on each first step, this is useful for diagonal turns where you couldn't walk normally.",
                    "Give it a try.",
                },
                [1] = {
                    "I brought you back here because it took you TOO long to reach the blue tile.",
                    "Like I said before, the further ahead you plan your movement, the faster you get there, especially if there are a lot of twists and turns along the way.",
                    "It's very important that you know this, because it's the best way to escape enemies you may not be ready to face yet.",
                    "Try again, click on the blue tile and let the game do the walking.",
                },
                [2] = {
                    ":/",
                    "I will show you where to click.",
                    "Once I move out of the way, click on the blue tile and let the game take you there. When you reach the tile, this part of the tutorial will be done and you will be able to proceed.",
                },
            }
        },
        ["lookRoom"] = {
            stages = {3, 4, 5},
            corners = {{upCorner = {x = 469, y = 760, z = 8}, downCorner = {x = 475, y = 770, z = 8}}},
            npcDir = "N",
            texts = {
                [3] = {
                    "Nice, nice. Now lets talk about looking at objects.",
                    "Obviously, you can see that I am not a chair or lamp, however not all things in this game are what they seem to be.",
                    "To get more details and information about an object or item you need to LOOK at it.",
                    "Let's start with me.",
                    "HOLD down the SHIFT key and CLICK on ME.",
                },
            }
        },
        ["climbRoom"] = {
            stages = {6, 7, 8, 9, 10, 11, 12},
            corners = {
                {upCorner = {x = 479, y = 760, z = 8}, downCorner = {x = 485, y = 770, z = 8}},
                {upCorner = {x = 479, y = 763, z = 9}, downCorner = {x = 485, y = 766, z = 9}},
            },
            npcDir = "N",
            texts = {
                [6] = {
                    "Now we are going to learn about climbing and using objects.",
                    "In this game, you have to type in commands to cast spells or perform specific actions.",
                    "ALL commands start with an exclamation symbol [!].",
                    "We will get back to spell commands later in the tutorial.",
                    "Right now, do what I do.",
                },
                [7] = {
                    "In order to climb up or down, you have to face the direction where you want to try climbing.",
                    "To turn without moving, HOLD down the CTRL key and press the ARROW keys on your keyboard.)",
                },
                [8] = {
                    "Now if I'm looking in the correct direction and if there is an edge front of me, and as you can see there is, I should be able to do something.",
                    "I will use the command '!climb down' to climb down this edge.",
                    "Like this.",
                    "(orange)!climb down",
                },
                [10] = {
                    [6000] = "(orange)!climb up",
                },
            }
        },
        ["dragRoom"] = {
            stages = {13, 14, 15},
            corners = {{upCorner = {x = 489, y = 760, z = 8}, downCorner = {x = 495, y = 770, z = 8}}},
            npcDir = "N",
            texts = {
                [13] = {
                    "Now we're going to learn how to move objects.",
                    "Most of the time you can push objects out of the way and see what is under them.",
                    "The heavier an object is, the shorter the distance you can move it at once is.",
                    "To move an item, you need to HOLD down the CLICK and DRAG the object or item from one place to another.",
                    "In this tutorial, you need to place statues on the pressure plates or 'button tiles'.",
                    "Let me move the first statue to help you out.",
                    "I move my cursor to the statue, I CLICK on it and HOLD down the click, then I move the cursor to a new position and RELEASE the click.",
                },
                [14] = {
                    "Start moving the statues and figure out the puzzle.",
                    "Good luck!",
                },
                [15] = {
                    "Oh, come on! What did you have to go ahead and do that for???",
                    "You just messed up the tutorial!!!",
                    "It would be too troublesome for me to reset the room now...",
                    "I will take you to the next room and fix this one by myself, before you break anything else...",
                }
            }
        },
        ["doorRoom"] = {
            stages = {16, 17, 18, 19, 20, 21},
            corners = {{upCorner = {x = 499, y = 760, z = 8}, downCorner = {x = 505, y = 770, z = 8}}},
            npcDir = "N",
            texts = {
                [16] = {
                    "In this room you will learn how to USE objects.",
                    "To pass through doors you need to HOLD down the CTRL key and click on the door.",
                    "Sometimes you need to do something before you're allowed to pass through doors.",
                    "Go ahead and try to get to the blue tile, If you encounter any problems, come talk to me.",
                },
            }
        },
        ["bagRoom"] = {
            stages = {22, 23, 24, 25},
            corners = {{upCorner = {x = 510, y = 761, z = 8}, downCorner = {x = 514, y = 769, z = 8}}},
            npcDir = "W",
            texts = {
                [22] = {
                    "If you haven't noticed yet, your character is actually naked.",
                    "On the right side panel there are grayed out slots for your equipment: amulet, helmet, weapon, bag, etc.",
                    "Below the item slots panel there is a window that displays your character's carrying capacity (Cap).",
                    "This means that you can pick up as many items as long as their total weight is less than 'Cap'.",
                    "Your most important item is the bag. Because with a bag you can carry around other items.",
                    "If you LOOK at items that you can pick up, it will usually display how much they weigh.",
                    "In this tutorial you simply need to take all the items from this room into your inventory and carry on.",
                    "You can turn token bags to bags by browsing field on them while they on ground and vice versa.",
                },
                [23] = {
                    "You haven't equipped a bag.",
                    "Choose one from the counter and DRAG it into the bag slot in your character equipment inventory on the right hand side of the screen.",
                },
                [24] = {
                    "You don't have all the valuables from this room.",
                    "To put an item inside a bag, DRAG it into the equipped bag or into the bag slot (if you opened the bag).",
                },
                [25] = {
                    "You are missing the other bags.",
                    "To put bags into bags you need to convert the bag into a 'token bag' first.",
                    "To convert a bag into a 'token bag', right click on it and choose the 'Browse field' command.",
                },
            }
        },
        ["potionRoom"] = {
            stages = {26, 27, 28},
            corners = {{upCorner = {x = 519, y = 760, z = 8}, downCorner = {x = 526, y = 770, z = 8}}},
            npcDir = "E",
            texts = {
                [26] = {
                    "You have done well so far.",
                    "This time you need to combine items in order to make an antidote potion.",
                    "If you don't have an antidote potion when passing through a poison field, you will die.",
                    "You can get the powder for an antidote potion from the flower and the mushroom.",
                    "You can get an empty vial from me.",
                },
                [27] = {"GOOD GAME!!! You're dead now. xD"},
                [28] = {"Don't forget to USE the antidote potion!"},
            }
        },
        ["staffRoom"] = {
            stages = {29, 30, 31, 32},
            corners = {{upCorner = {x = 529, y = 760, z = 8}, downCorner = {x = 536, y = 770, z = 8}}},
            npcDir = "N",
            texts = {
                [29] = {
                    "There are more ways in which items may interact with each other.",
                    "If you drop certain items on top of one another, something might happen.",
                    "In this tutorial, you have to create a staff and shoot the strut that holds the bridge up on the other side of river.",
                },
                [30] = {
                    "Nicely done. Now, there are 2 ways to target monsters.",
                    "The first is to HOLD down the ALT key and click on the target.",
                    "This selects the entity as a target and whenever you can attack or cast a spell (which does something to the target), it will automatically do it.",
                    "The red square under the target means that this is your current target.",
                    "The second way to target an entity is to click on it in the battle list.",
                    "To open the battle list, click on the battle button near your character equipment inventory on the right side of client, otherwise, press CTRL+B.",
                    "The white square that appears below the selected target shows what creature you are about to target.",
                },
                [31] = {
                    "Place the staff on the basin and pull the lever to create the end tile which will take you to the next tutorial room.",
                },
            }
        },
        ["wallRoom"] = {
            stages = {33, 34, 35, 36},
            corners = {{upCorner = {x = 539, y = 761, z = 8}, downCorner = {x = 544, y = 770, z = 8}}},
            npcDir = "W",
            texts = {
                [33] = {
                    "I see you've already tried using a staff (a magical weapon).",
                    "Now let's try a sword (a melee weapon).",
                    "Use the sword to break through that moss wall..",
                    "Ask me for a sword if when you are ready.",
                },
                [34] = {
                    "That was an easy one. The next 2 walls are a little trickier. They are completely immune to physical damage and damage from their own elemental type attacks.",
                    "Luckily we have some magic imbued stones here from which you can scrape off some magical dust to improve your weapon.",
                    "Get the dust and enchant your weapon, use the enchanted weapon to destroy the last 2 walls.",
                },
                [36] = {
                    "Seems you are getting the hang of different weapons and their possibilities.",
                    "There is one last type of weapon, ranged weapons: spears, bows and knives..",
                    "To lift the last wall, you need to destroy the orb.",
                    "Know that you need to look towards the target before automatically shoots it.",
                    "Manually dragging the spear to the target will result in it being dropped and wasted.",
                    "You can get the spears from me.",
                    "You can quick equip ranged weapons by using them.",
                },
            }
        },
        ["spellRoom"] = {
            stages = {37},
            corners = {{upCorner = {x = 458, y = 777, z = 8}, downCorner = {x = 466, y = 787, z = 8}}},
            npcDir = "W",
            texts = {
                [37] = {
                    "Let's come back to the spell commands now.",
                    "In this room you will have and use 3 different spells.",
                    "To see your spells, LOOK at your own character and select 'spellbook'.",
                    "You can and should put your spells under hotkeys, the F1-F12 keys.",
                    "In your 'spellbook', choose a spell and click ENTER or the 'print' button to print the choice to your console (local chat).",
                    "This way you dont have to memorize the spellword to write it in the hotkeys.",
                    "When you have all the different 'spellwords' in your console, close the spellbook and open hotkeys.",
                    "To open hotkeys, hold down the CTRL key and press K.",
                    "A panel will pop up.",
                    "Highlight the first available hotkey and, under the edit hotkey text box, type in the spell word you found in your spellbook.",
                    "Also tick the box: Send automatically.",
                    "After you have written all your spells under different hotkey selections, press OK.",
                    "If you have all the spells under hotkeys, you will be able to finish this tutorial in time quite easily.",
                    "To complete this room, all pillars must be charged at the same time.",
                },
            }
        },
        ["prepRoom"] = {
            stages = {38, 39, 40, 41},
            corners = {{upCorner = {x = 469, y = 777, z = 8}, downCorner = {x = 475, y = 786, z = 8}}},
            multibleAllowed = true,
            npcDir = "E",
            texts = {
                [38] = {
                    "You have grasped almost everything you need to know for now.",
                    "In this room, you can start with using the monument.",
                    "These are like checkpoints in this game. If you USE them, the next time you die, you will respawn near it.",
                    "Now learn all the spells in this room by using the 'spellscrolls' and make a few vials of water.",
                },
                [39] = {
                    "You NEED to set your checkpoint to this room. Else if you die, you will have to do the tutorial all over again.",
                },
                [40] = {
                    "Gather some vials of water for the next room, these will regenerate some mana for you.",
                },
                [41] = {
                    "Spells not learned! Learn all the spells, you will need them!"
                },
            }
        },
        ["lootRoom"] = {
            stages = {42, 43},
            corners = {{upCorner = {x = 480, y = 777, z = 8}, downCorner = {x = 486, y = 787, z = 8}}},
            npcDir = "N",
            texts = {
                [42] = {
                    "Be careful now.",
                    "Use your spells wisely to pass these poles.",
                    "When you destroy them, be aware that most monsters respawn back in the game eventually.",
                    "Also, dont forget to LOOT their remains after you destroy them.",
                    "To loot monsters, simply USE their corpse and drag items out of the body into the bag or open bag slot.",
                    "You can pass this room after you have bought a leather armor from me.",
                },
                [43] = {
                    "About shops, the item prices and items themselves are not static.",
                    "If you help NPCs or make progress ingame, NPC shops can change.",
                    "For example, right now I felt like lowering leather armor, just because you managed to destroy a pole!",
                }
            },
        },
        ["resRoom"] = {
            stages = {44, 45, 46},
            corners = {{upCorner = {x = 491, y = 778, z = 8}, downCorner = {x = 495, y = 786, z = 8}}},
            multibleAllowed = true,
            npcDir = "E",
            texts = {
                [44] = {
                    "In case you haven't noticed, the leather armor you have gives you armor value.",
                    "The armor stat has a 75% chance to make you take 1 less PHYSICAL damage for EACH armor value you have. 10 armor means you are likely to take 7-8 less damage per hit.",
                    "PHYSICAL damage is usually displayed as a a red number above your character.",
                    "In this room, I will give you 2 different hammers that will change your armor's RESISTANCE if you use them on your armor.",
                    "RESISTANCE blocks a % amount of that ELEMENTAL TYPE damage.",
                    "To see your character's full stats, LOOK at yourself and select stats or type in the command !stats.",
                    "To pass this room, get your fire resistance to 48-55%.",
                },
                [45] = {
                    "You need to get your fire resistance up to 48-55%.",
                    "To see your stats, LOOK at yourself or type in the command !stats.",
                },
                [46] = {
                    "Your fire resistance is higher than 55%.",
                    "You need to get your fire resistance between 48 and 55%.",
                    "To see your stats, LOOK at yourself or type in the !stats command.",
                },
            },
        },
        ["fieldRoom"] = {
            stages = {47},
            corners = {{upCorner = {x = 501, y = 778, z = 8}, downCorner = {x = 505, y = 786, z = 8}}},
            npcDir = "S",
            texts = {
                [47] = {
                    "STAAAHP MOOVING!!",
                    "Fields in this game can be quite dangerous, you should move around them if possible.",
                    "They deal elemental damage and can last a while.",
                },
            },
        },
        ["skillRoom"] = {
            stages = {48, 49},
            corners = {{upCorner = {x = 510, y = 777, z = 8}, downCorner = {x = 516, y = 787, z = 8}}},
            multibleAllowed = true,
            npcDir = "W",
            texts = {
                [48] = {"You have almost finished the entire tutorial (name)!"},
            },
        },
        ["skipRoom"] = {
            stages = {50},
            corners = {{upCorner = {x = 546, y = 735, z = 8}, downCorner = {x = 553, y = 739, z = 8}}},
            multibleAllowed = true,
            npcDir = "W",
            texts = {
                [50] = {
                    "In this room, we remind ourselves of what we have learned so far.",
                    "See if you can figure out how to get to the boss room on your own.",
                    "Some secrets, treasures and paths will be left for you to find or figure out on your own.",
                },
            },
        },
    },
}

tutorial = {
    startUpFunc = "tutorial_startUp",
  
    area = {
        areaCorners = {
            {upCorner = {x = 456, y = 759, z = 8}, downCorner = {x = 545, y = 787, z = 8}},
            {upCorner = {x = 478, y = 762, z = 9}, downCorner = {x = 486, y = 767, z = 9}},
        },
    },
    questlog = {
        name = "Tutorial",
        questSV = questSV,
        trackerSV = trackerSV,
        log = {
            [0] = "Step on the blue tile.",
            [1] = "Step on the blue tile.",
            [2] = "Step on the blue tile.",
            [3] = "Listen to NPC.",
            [4] = "Talk to NPC by LOOK-ing at him.",
            [5] = "Solve the puzzle by LOOK-ing at the stones in the correct order.",
            [6] = "Listen to NPC.",
            [7] = "You can turn your character without moving by holding down the CTRL key and pressing the ARROW keys on your keyboard.",
            [8] = "Climb down the edge with the '!climb down' command (don't forget to face the edge).",
            [9] = "Climb down the edge with the '!climb down' command and talk to NPC.",
            [10] = "Climb up the edge with the '!climb up' command",
            [11] = "Climb up the edge with the '!climb up' command",
            [12] = "Step on the blue tile.",
            [13] = "Climb your way to the blue tile.",
            [14] = "Place the statues on the buttons to open the passage to the blue tile.",
            [15] = "Place the statues on the buttons to open the passage to the blue tile.",
            [16] = "Listen to NPC!",
            [17] = "You can open the door now.",
            [18] = "Throw the mango to the hungry monster to open the door.",
            [19] = "Find a key in the sand.",
            [20] = "Use the key on yourself to pick it up.",
            [21] = "Step on the blue tile.",
            [22] = "Pick up all the items from this room and then step on the blue tile.",
            [23] = "Equip a bag, put all the items from this room inside it and step on the blue tile.",
            [24] = "Put all of the valuables in your bag and step on the blue tile!",
            [25] = "Turn other bags into token bags by RIGHT clicking them and selecting the 'browse field' command to put them into your equipped bag and then step on the blue tile.",
            [26] = "Make yourself an antidote potion, pass through the poison and quickly use the potion on yourself.",
            [27] = "Step on the blue tile to continue the tutorial.",
            [28] = "Step on the blue tile to continue the tutorial.",
            [29] = "Create a staff by stacking the staff pieces on top of each other and equip it into your weapon slot.",
            [30] = "Destroy the 'strut' by attacking it.",
            [31] = "Destroy your wand on the basin to summon the blue tile.",
            [32] = "Step on the blue tile.",
            [33] = "Destroy the first wall with your sword.",
            [34] = "Destroy the ice wall with your fire-enchanted sword.",
            [35] = "Destroy the fire wall with your ice-enchanted sword.",
            [36] = "Destroy the orb with spears.",
            [37] = "Charge the pillars by attacking them with your spells, if all pillars are charged at the same times, the blue tile will appear.",
            [38] = "Prepare yourself for the next room.",
            [39] = "Make sure you have taken the checkpoint.",
            [40] = "Make sure you have some vials of water.",
            [41] = "Make sure you have learned all the spells.",
            [42] = "Sell collectables to NPC and buy yourself a leather armor.",
            [43] = "Sell collectables to NPC and buy yourself a leather armor.",
            [44] = "Listen to NPC!",
            [45] = "Upgrade your character's fire resistance to 48-55%.",
            [46] = "Upgrade your character's fire resistance to 48-55%.",
            [47] = "Upgrade your resistances as instructed and advance to the blue tile.",
            [48] = "Talk to NPC to get a weapon and some skillpoints.",
            [49] = "Find the right skill from your skilltree and destroy the orb!",
            [50] = "Find your way to the boss room.",
            [51] = "Choose a class and climb over the rail.",
            [52] = "Kill the tutorial boss!",
        },
        hintLog = {
            [1] = {[SV.tutorial_hint_click] = "Click on the the blue tile to automatically walk to it as fast as possible."},
            [2] = {[SV.tutorial_hint_click] = "Click on the the blue tile to automatically walk to it as fast as possible."},
        },
    },
    --npcChat = {} -- in npc > npcs > tutorial npc.lua
    keys = {
        ["Tutorial Key 1"] = {
            itemAID = AIDT.doorRoomKey,
            removeKey = true,
            keyID = SV.tutorial_doorRoomKey,
            keyFrom = "Dug out of sand in the tutorial.",
            keyWhere = "Used to unlock a door in the tutorial room.",
        },
        ["Tutorial Key 2"] = {
            itemAID = AIDT.dummyKey,
            removeKey = true,
            keyID = SV.dummyKey,
            keyFrom = "Looted from a skeleton",
            keyWhere = "Used for opening a tutorial room",
        },
    },
    AIDItems_onLook = {
        [AIDT.lookRoomStone] = {funcSTR = "tutorial_lookRoom_stone"},
        [AIDT.climbRoomNote] = {text = {msg = "USE this note see what's written on it. To USE items, HOLD down the CTRL key and CLICK on the item."}},
        [AIDT.doorRoomKey] = {text = {msg = "Use keys on yourself to pick them up permanently."}},
        [AIDT.doorRoomNote] = {text = {msg = "USE this scroll to see what's written on it."}},
        [AIDT.eaplebrond] = {text = {msg = "Eaplebrond herb - USE herbs to pick them up."}},
        [AIDT.mobberel] = {text = {msg = "Mobberel herb - USE this mushroom to collect the herb from it."}},
        [AIDT.redPillar] = {text = {msg = "Use this pillar to get magical dust which can be used to enhance your weapon."}},
        [AIDT.bluePillar] = {text = {msg = "Use this pillar to get magical dust which can be used to enhance your weapon."}},
        [AIDT.brokenPole] = {text = {msg = "You see a broken pole."}},
        [AIDT.iceField] = {text = {msg = "You see a fire, but it feels very, very cold."}},
        [AIDT.skipRoom_sand] = {text = {msg = "You can try digging this sand."}},
        [AIDT.skipRoom_sandHole] = {text = {msg = "You can try digging this sand."}},
    },
    AIDItems = {
        [AIDT.torch] = {},
        [AIDT.yellowDoor] = {
            bigSV = {[trackerSV] = 17},
            setSV = {[trackerSV] = 18},
            funcSTR = "automaticDoor",
            textF = {msg = "You need to wait until NPC is finished."},
        },
        [AIDT.keyDoor] = {
            bigSV = {[SV.tutorial_doorRoomKey] = 0},
            setSV = {[SV.tutorial_doorRoomKey] = 1},
            funcSTR = "automaticDoor",
            textF = {msg = "This door needs key and you don't have it."},
        },
        [AIDT.mangoTree] = {
            returnFalse = true,
            funcSTR = "tutorial_doorRoom_tree",
        },
        [AIDT.mangoDoor] = {funcSTR = "tutorial_doorRoom_mangoDoor"},
        [AIDT.sand] = {funcSTR = "tutorial_doorRoom_digSand"},
        [AIDT.keyInSand] = {funcSTR = "tutorial_doorRoom_digSand"},
        [AIDT.eaplebrond] = {funcSTR = "tutorial_potionRoom_eaplebrond"},
        [AIDT.mobberel] = {funcSTR = "tutorial_potionRoom_mobberel"},
        [AIDT.lever] = {funcSTR = "tutorial_staffRoom_lever"},
        [AIDT.redPillar] = {
            timers = {time = 10, showTime = true},
            rewardItems = {{itemID = 6550}},
        },
        [AIDT.bluePillar] = {
            timers = {time = 10, showTime = true},
            rewardItems = {{itemID = 6551}},
        },
        [AIDT.prepRoom_checkPoint] = {
            setSV = {[SV.checkPoint] = 1},
            ME = {pos = "playerPos", effects = 22},
            mana = 1000,
            health = 1000,
        },
        [AIDT.fireHammer] = {funcSTR = "tutorial_resRoom_hammer"},
        [AIDT.iceHammer] = {funcSTR = "tutorial_resRoom_hammer"},
        [AIDT.resRoom_checkPoint] = {
            setSV = {[SV.checkPoint] = 2},
            ME = {pos = "playerPos", effects = 22},
            mana = 1000,
            health = 1000,
        },
        [AIDT.bossRoom_checkPoint] = {
            setSV = {[SV.checkPoint] = 3},
            ME = {pos = "playerPos", effects = 22},
            mana = 1000,
            health = 1000,
        },
        [AIDT.bossRoom_rail] = {funcSTR = "tutorial_bossRoom_rail"},
        [AIDT.skipRoom_sand] = {text = {text = {msg = "*scratch*"}}},
        [AIDT.skipRoom_sandHole] = {
            transform = {itemID = 5731, itemAID = 1064, returnDelay = 5000},
            text = {text = {msg = "*swush*"}},
        },
    },
    AIDTiles_stepIn = {
        [AIDT.continueTutorial] = {funcSTR = "tutorial_continue"},
        [AIDT.mango] = {funcSTR = "tutorial_doorRoom_mango"},
        [AIDT.poisonField] = {funcSTR = "tutorial_potionRoom_poisonField"},
        [AIDT.fireField] = {funcSTR = "tutorial_fieldRoom_fireField"},
        [AIDT.iceField] = {funcSTR = "tutorial_fieldRoom_iceField"},
        [AIDT.bossRoom_stairs] = {funcSTR = "tutorial_bossRoom_stairs"},
        [AIDT.bossRoom_fireField] = {funcSTR = "tutorial_bossRoom_fireField"},
        [AIDT.skipRoom_fail] = {funcSTR = "tutorial_skipRoom_fail"},
        [AIDT.skipRoom_complete] = {funcSTR = "tutorial_skipRoom_complete"},
        [AID.other.doNothing] = {funcSTR = "teleportBack"},
    },
    AIDTiles_stepOut = {
        [AIDT.walkRoomTimerTile] = {funcSTR = "tutorial_walkRoom_startTimer"},
    },
    registerEvent = {
        onDeath = {
            ["strut"] = {"tutorial_staffRoom_strut"},
            ["earth wall"] = {"tutorial_wallRoom_wall"},
            ["ice wall"] = {"tutorial_wallRoom_wall"},
            ["fire wall"] = {"tutorial_wallRoom_wall"},
            ["tutorial orb"] = {"tutorial_wallRoom_orb"},
            ["tutorial pole"] = {"tutorial_lootRoom_destroyPole"},
            ["tutorial tp orb"] = {"tutorial_skillRoom_orb"},
        },
        onHealthChange = {
            ["earth wall"] = {"tutorial_wallRoom_wallDamage"},
            ["ice wall"] = {"tutorial_wallRoom_wallDamage"},
            ["fire wall"] = {"tutorial_wallRoom_wallDamage"},
            ["tutorial tp orb"] = {"tutorial_skillRoom_orbDamage"},
            ["strut"] = {"damageSystem_onHealthChange"},
            ["tutorial pole"] = {"damageSystem_onHealthChange"},
            ["tutorial orb"] = {"damageSystem_onHealthChange"},
        },
        onThink = {
            ["tutorial pole"] = {"AI_onThink"},

        }
    },
    items = {
        ["weapon"] = {
            [12327] = {
                equipFunc = "tutorial_staffRoom_staff",
                weight = 10000,
                minDam = 100*5,
                maxDam = 180*5,
                weaponSpeed = 3000,
                isWand = true,
            },
            [7857] = { -- tutorial earth sword
                weight = 15000,
                minDam = 101,
                maxDam = 101,
                weaponSpeed = 1000,
                damType = EARTH,
            },
            [7744] = {-- tutorial fire sword
                weight = 5000,
                minDam = 250,
                maxDam = 250,
                weaponSpeed = 3000,
                damType = FIRE,
            },
            [7763] = { -- tutorial ice sword
                weight = 5000,
                minDam = 250,
                maxDam = 250,
                weaponSpeed = 3000,
                damType = ICE,
            },
        },
    },
    bossRoom = {
        highscoreAID = AIDT.dummyHighscores,
        bossName = "dummy",
        killSV = SV.dummyKill,
        rewardSkillPoint = 1,
    },
    monsters = {
        ["dummy"] = {
            name = "Dummy",
            race = "undead",
            bossRoomAID = AIDT.dummyHighscores,
            spawnEvents = defaultBossSpawnEvents,
            killActions = {{
                setSV = {[trackerSV] = -1, [SV.dummyNerf] = -1, [questSV] = 1, [SV.checkPoint] = 4},
            }}
        },
    },
    monsterLoot = {
        ["dummy"] = {
            storage = SV.dummy,
            items = {
                [2643] = {chance = 100, bigSV = {[SV.dummyRewards] = 1}, itemText = "speed(25)"},
                [2461] = {chance = 100, bigSV = {[SV.dummyRewards] = 0}},
                [2092] = {chance = 100, itemAID = AIDT.dummyKey},
                [2649] = {chance = 100},
                [1] = {itemID = 5958, itemAID = AID.spells.strike, knight = 100},
                [2] = {itemID = 5958, itemAID = AID.spells.heat, druid = 100},
                [3] = {itemID = 5958, itemAID = AID.spells.barrier, mage = 100},
                [4] = {itemID = 5958, itemAID = AID.spells.poison, hunter = 100},
            },
        },
    },
    monsterResistance = {
        ["dummy"] = {
            PHYSICAL = -65,
            ICE = 100,
            FIRE = 30,
            ENERGY = -150,
            DEATH = 100,
        },
    },
    monsterSpells = {
        ["dummy"] = {"damage: cd=400, d=55-100"},
        ["tutorial pole"] = {"damage: cd=2000, d=40-90"},
    },
}
centralSystem_registerTable(tutorial)

local tempFinalNpcPos = {x = 533, y = 734, z = 9}
function tutorial_startUp()
  --  if "" then return print("tutorial_startUp() has been disabled") end
    for z=9, 15 do
        tempFinalNpcPos.z = z
        createNpc({name = "npc", npcPos = tempFinalNpcPos})
    end
    
    tutorial_bossRoom_startUp()
    for roomName, roomT in pairs(confT.rooms) do
        local startUpFunc = _G["tutorial_"..roomName.."_startUp"]
        roomT.resetF = "tutorial_"..roomName.."_reset"
        roomT.stageFunc = "tutorial_"..roomName.."_stageFunc"
        roomT.name = roomName
        
        local function registerStartPos(pos)
            if roomT.startPos then return end
            if findItem(5582, pos) then roomT.startPos = pos end
        end
        local function registerEndPos(pos)
            if roomT.endPos then return end
            local blueTile = findItem(5573, pos)
            if not blueTile then return end
            local aid = blueTile:getActionId()
            roomT.blueTileAID = aid
            roomT.endPos = pos
            AIDTiles_stepIn[aid] = {funcSTR = "tutorial_"..roomName.."_complete"}
        end
        local function registerNpcPos(pos)
            if not removeItemFromPos(4398, pos) then return true end
            
            local npc = createNpc({name = "npc", npcPos = pos})
            if not npc then return print("tutorial_startUp() has been disabled") end

            local npcID = npc:getId()
            
            if roomT.npcDir then doTurn(npcID, roomT.npcDir) end
            roomT.npcID = npcID
            roomT.npcPos = pos
            return true
        end
        
        for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
            registerStartPos(pos) 
            registerEndPos(pos)
            if not registerNpcPos(pos) then return end
        end
        
        if startUpFunc then startUpFunc(roomT) end
        for stage, t in pairs(roomT.texts) do roomT.texts[stage] = addMsgDelayToMsgT(t) end
    end
end

function tutorial_continue(player)
    if getSV(player, questSV) == 1 then return teleport(player, {x = 554, y = 705, z = 8}) end
    local stage =  tutorial_getStage(player)
    if getSV(player, SV.tutorialBossRoomFloor) > 0 and stage == 51 or stage == 52 then return teleport(player, {x = 533, y = 739, z = getSV(player, SV.tutorialBossRoomFloor)}) end
    local roomT = tutorial_getRoomByStage(stage)
    
    if not roomT then
        local setSVTo0 = {questSV, trackerSV, SV.tutorial_fireRes, SV.tutorial_iceRes, SV.dummyNerf}
        local setSVTo1 = {SV.npcLookDisabled, SV.lookDisabled}
        local removeSVT = {SV.tutorial_doorRoomKey, SV.tutorialNPC1, SV.tutorialNPC2, SV.tutorial_shop, SV.tutorial_escapeButton, SV.dummyKey, SV.dummyKill, SV.tutorialBossRoomFloor}
        
        setSV(player, setSVTo0, 0)
        setSV(player, setSVTo1, 1)
        removeSV(player, removeSVT)
        player:giveItem(2051, 1, AIDT.torch)
        roomT = tutorial_getRoomByStage(0)
    end
    tutorial_enterRoom(player, roomT.name)
end

function tutorial_enterRoom(player, roomName)
    local roomT = tutorial_getRoomByName(roomName)

    if not tutorial_canEnterRoom(player, roomT) then return end
    if roomT.resetF then activateFunctionStr(roomT.resetF, player) end
    setSV(player, trackerSV, roomT.stages[1])
    teleport(player, roomT.startPos)
    tutorial_activate(player)
    return true
end

function tutorial_canEnterRoom(player, roomT)
    if roomT.multibleAllowed then return true end
    if tableCount(findFromPos("player", createAreaOfSquares(roomT.corners))) == 0 then return true end
    teleport(player, confT.waitingPos)
    player:sendTextMessage(GREEN, "Sorry, currently this tutorial is designed so that only 1 player can do it at once. You need to wait until they done.")
end

function tutorial_activate(cid)
local player = Player(cid)

    if not player then return end
local pid = player:getId()
local stage = tutorial_getStage(player)
local roomT = tutorial_getRoomByStage(stage)
local npcID = roomT.npcID
    
    tutorial_npcChat(player, npcID, roomT)
    if roomT.stageFunc then _G[roomT.stageFunc](player, roomT) end
end

function tutorial_npcChat(player, npcID, roomT)
local stage = tutorial_getStage(player)
local msgT = roomT.texts[stage]
    if not msgT then return end
local eventID = "npcID"..npcID
    
    stopAddEvent(eventID, nil, true)
    
    for delay, text in pairs(msgT) do
        local mod = text:match("%b()")
        local msgType
        local eventKey = "say"..delay
        
        if mod then
            if mod:match("name") then
                text = text:gsub("%b()", player:getName())
            elseif mod:match("orange") then
                msgType = ORANGE
                text = text:gsub("%b()", "")
            end
        end
        
        registerAddEvent(eventID, eventKey, delay, {creatureSay, npcID, text, msgType})
    end
end

function tutorial_removeBlueTile(roomT) removeItemFromPos(5573, roomT.endPos) end
function tutorial_createBlueTile(roomT) createItem(5573, roomT.endPos, 1, roomT.blueTileAID) end
function tutorial_death(player) return tutorial_logOut(player) end

function tutorial_logOut(player)
local roomT = tutorial_getRoomByPlayer(player)
    
    if not roomT then return end
    tutorial_kickFromRoom(player)
    if roomT.resetF then _G[roomT.resetF](player) end
    Vprint(player:getName(), " logged/died in "..roomT.name)
end

function tutorial_kickFromRoom(player)
    if getSV(player, SV.tutorial) ~= 1 then return teleport(player, {x = 524, y = 737, z = 8}) end
end

function tutorial_completedTP(player)
    if getSV(player, questSV) == 1 then return player:teleportTo({x = 554, y = 705, z = 8}) end
end

-- get functions
function tutorial_getRoomByPlayer(player) return tutorial_getRoomByStage(tutorial_getStage(player)) end
function tutorial_getStage(player) return getSV(player, trackerSV) end

function tutorial_getRoomByStage(stage)
    for roomName, roomT in pairs(confT.rooms) do
        if matchTableValue(roomT.stages, stage) then return roomT end
    end
end

function tutorial_getRoomByName(name)
    for roomName, roomT in pairs(confT.rooms) do
        if roomName == name then return roomT end
    end
end

-- room functions
---------------
-- walk room --
---------------
function tutorial_walkRoom_startTimer(player)
    if not player:isPlayer() then return end
local cid = player:getId()

    stopAddEvent(cid, "tutorial")
    registerAddEvent(cid, "tutorial", 23000, {tutorial_walkRoom_restart, cid})
end

function tutorial_walkRoom_complete(player, item)
    stopAddEvent(player:getId(), "tutorial")
    tutorial_enterRoom(player, "lookRoom")
end

function tutorial_walkRoom_reset(player)
local roomT = tutorial_getRoomByName("walkRoom")

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    teleport(roomT.npcID, roomT.npcPos, false, roomT.npcDir)
end

function tutorial_walkRoom_restart(player)
    player = Player(player)
    tutorial_walkRoom_reset()
    if not player then return end
local stage = tutorial_getStage(player)
local roomT = tutorial_getRoomByStage(stage)

    if stage ~= 2 then addSV(player, trackerSV, 1) end
    setSV(player, SV.tutorial_hint_click, 1)
    teleport(player, roomT.startPos)
    addEvent(tutorial_activate, 1000, player:getId())
end

function tutorial_walkRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
local npcID = roomT.npcID
local tpData1 = {teleport, npcID, {x = 459, y = 762, z = 8}}
local tpData2 = {teleport, npcID, {x = 458, y = 762, z = 8}}
local eventID = "npcID"..npcID

    if stage == 0 then
        registerAddEvent(eventID, "effects", 38000, {doSendMagicEffect, roomT.endPos, {57, 57, 57}, 2000})
        registerAddEvent(eventID, "tp1", 79000, tpData1)
        registerAddEvent(eventID, "tp2", 81000, tpData2)
    elseif stage == 1 then
        registerAddEvent(eventID, "tp1", 31000, tpData1)
        registerAddEvent(eventID, "tp2", 33000, tpData2)
    elseif stage == 2 then
        registerAddEvent(eventID, "effects", 2000, {doSendMagicEffect, roomT.endPos, {56,56,56}, 2500})
        registerAddEvent(eventID, "tp1", 6000, tpData1)
        registerAddEvent(eventID, "tp2", 8000, tpData2)
    end
end

---------------
-- look room --
---------------
local lookRoom_stonePosT = {} -- in sequence
function tutorial_lookRoom_startUp(roomT)
local availableIDT = {1,2,3,4,5}

    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        local stone = findItem(1285, pos)
        
        if stone then
            local randomID = randomValueFromTable(availableIDT)
            availableIDT = removeFromTable(availableIDT, randomID)
            stone:setText("orderID", randomID)
            lookRoom_stonePosT[randomID] = pos
        end
    end
end

function tutorial_lookRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
    if stage ~= 3 then return end
local delay = 25000
local pid = player:getId()

    addEvent(setSV, delay, pid, trackerSV, 4)
    addEvent(removeSV, delay, pid, SV.npcLookDisabled)
end

local function getNextOrderID()
    for ID, pos in ipairs(lookRoom_stonePosT) do
        if findItem(1285, pos) then return ID end
    end
end

function tutorial_lookRoom_stone(player, item)
local nextID = getNextOrderID()
    if not nextID then return end
local itemOrderID = getFromText("orderID", item:getAttribute(TEXT))
local roomT = tutorial_getRoomByName("lookRoom")
local npcID = roomT.npcID
local pid = player:getId()
    
    if itemOrderID == nextID then
        item:transform(3332)
        
        if itemOrderID == 1 then
            local itemPos = item:getPosition()
            local eventData = {tutorial_lookRoom_reset, true}
            
            registerAddEvent("tutorialStone", "walkRoomStone", 4000, eventData)
            
            for e=0, 3 do
                local duration = e*1000
                local eventData = {text, 4-e, itemPos}
                
                registerAddEvent("tutorialStone", "walkRoomStone"..e, duration, eventData)
            end
        elseif itemOrderID == 5 then
            stopAddEvent("tutorialStone", nil, true)
            createItem(5573, roomT.endPos, 1, AIDT.lookRoomComplete)
            creatureSay(npcID, "Gratz brah! You did it!")
        end
    elseif itemOrderID == nextID - 1 then
        if antiSpam(pid, 1, 2000) then creatureSay(npcID, "that magic stone is already activated, find next one before time runs out") end
    else
        tutorial_lookRoom_reset()
        
        if itemOrderID < nextID then
            if antiSpam(pid, 1, 2000) then creatureSay(npcID, "Don't look activated stones or it will reset them all") end
        else
            if antiSpam(pid, 2, 2000) then creatureSay(npcID, "Sorry that was incorrect sequence.") end
        end
    end
end

function tutorial_lookRoom_reset(npcTalks)
local stoneRemoved = false
local roomT = tutorial_getRoomByName("lookRoom")
local npcID = roomT.npcID

    stopAddEvent("npcID"..npcID, nil, true)
    stopAddEvent("tutorialStone", nil, true)
    addEvent(removeItemFromPos, 1000, 5573, {x = 472, y = 767, z = 8})
    
    for ID, pos in pairs(lookRoom_stonePosT) do
        if doTransform(3332, pos, 1285, true) then stoneRemoved = true end
    end
    
    if not npcTalks then return end
    if not stoneRemoved then return end
    creatureSay(npcID, "You have to be faster to look the stones in correct order. HOLD down SHIFT and click stones in correct order.")
end

function tutorial_lookRoom_complete(player, item)
    tutorial_enterRoom(player, "climbRoom")
    removeItemFromPos(5573, item:getPosition())
end

----------------
-- climb room --
----------------
function tutorial_climbRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
local npcID = roomT.npcID
local eventID = "npcID"..npcID
local pid = player:getId()

    if stage == 6 then
        registerAddEvent(eventID, "sv", 30000, {addSV, pid, trackerSV, 1})
        registerAddEvent(eventID, "tp", 33000, {teleport, npcID, {x = 479, y = 762, z = 8}})
        registerAddEvent(eventID, "activate", 36000, {tutorial_activate, pid})
    elseif stage == 7 then
        registerAddEvent(eventID, "sv", 20000, {addSV, pid, trackerSV, 1})
        registerAddEvent(eventID, "turn", 21000, {doTurn, npcID, "S"})
        registerAddEvent(eventID, "activate", 21001, {tutorial_activate, pid})
    elseif stage == 8 then
        addSV(player, trackerSV, 1)
        registerAddEvent(eventID, "tp", 22000, {teleport, npcID, {x = 479, y = 766, z = 9}, false, "N"})
    elseif stage == 10 then
        addSV(player, trackerSV, 1)
        registerAddEvent(eventID, "turn", 5000, {doTurn, npcID, "S"})
        registerAddEvent(eventID, "tp", 7000, {teleport, npcID, {x = 480, y = 767, z = 8}, false, "W"})
    elseif stage == 12 then
        addSV(player, trackerSV, 1)
        registerAddEvent(eventID, "tp1", 5000, {teleport, npcID, {x = 481, y = 768, z = 8}})
        registerAddEvent(eventID, "tp2", 7000, {teleport, npcID, {x = 481, y = 769, z = 8}})
        registerAddEvent(eventID, "tp3", 8000, {teleport, npcID, {x = 482, y = 770, z = 8}})
        registerAddEvent(eventID, "tp4", 9000, {teleport, npcID, {x = 483, y = 769, z = 8}})
        registerAddEvent(eventID, "tp5", 10000, {teleport, npcID, {x = 483, y = 768, z = 8}})
        registerAddEvent(eventID, "tp6", 11000, {teleport, npcID, {x = 484, y = 767, z = 8}})
        registerAddEvent(eventID, "tp7", 12000, {teleport, npcID, {x = 485, y = 768, z = 8}})
        registerAddEvent(eventID, "turn", 13000, {doTurn, npcID, "N"})
    end
end

function tutorial_climbRoom_complete(player, item)
    tutorial_climbRoom_reset()
    tutorial_enterRoom(player, "dragRoom")
end

function tutorial_climbRoom_reset()
local roomT = tutorial_getRoomByName("climbRoom")
local npcID = roomT.npcID
    
    stopAddEvent("npcID"..npcID, nil, true)
    teleport(npcID, roomT.npcPos, nil, roomT.npcDir)
end

---------------
-- drag room --
---------------
local function tutorial_dragRoom_getStatue(pos)
    local statues = {1476, 1477, 1447, 1442}
        
    for _, itemID in pairs(statues) do
        local item = findItem(itemID, pos)
        if item then return item end
    end
end

local function tutorial_dragRoom_removeStatue(pos)
    local item = tutorial_dragRoom_getStatue(pos)
    if item then return item:remove() end
end

function tutorial_dragRoom_stageFunc(player, roomT)
    local stage = tutorial_getStage(player)
    local npcID = roomT.npcID
    local eventID = "npcID"..npcID
    local pid = player:getId()
        
    if stage == 13 then
        local posT = {{x = 489, y = 760, z = 8}, {x = 489, y = 762, z = 8}, {x = 489, y = 764, z = 8}}
        for _, pos in pairs(posT) do
            registerAddEvent(eventID, "effects", 32000, {doSendMagicEffect, pos, {57, 57, 57}, 2000})
        end
        setSV(player, trackerSV, 14)
        registerAddEvent(eventID, "statue1", 57000, {tutorial_dragRoom_removeStatue, {x = 493, y = 763, z = 8}})
        registerAddEvent(eventID, "removeStatu1", 57100, {createItem, 1476, {x = 490, y = 762, z = 8}})
        registerAddEvent(eventID, "tp1", 58000, {teleport, npcID, {x = 491, y = 763, z = 8}})
        registerAddEvent(eventID, "statue2", 59000, {tutorial_dragRoom_removeStatue, {x = 490, y = 762, z = 8}})
        registerAddEvent(eventID, "removeStatu2", 59100, {createItem, 1476, {x = 490, y = 761, z = 8}})
        registerAddEvent(eventID, "tp2", 60000, {teleport, npcID, {x = 491, y = 762, z = 8}})
        registerAddEvent(eventID, "statue3", 61000, {tutorial_dragRoom_removeStatue, {x = 490, y = 761, z = 8}})
        registerAddEvent(eventID, "removeStatu3", 61100, {createItem, 1476, {x = 489, y = 760, z = 8}})
        registerAddEvent(eventID, "text", 61200, {text, "*click*", {x = 489, y = 760, z = 8}})
        registerAddEvent(eventID, "button", 61300, {doTransform, 426, {x = 489, y = 760, z = 8}, 425})
        registerAddEvent(eventID, "crystal", 61300, {removeItemFromPos, 8639, {x = 492, y = 761, z = 8}})
        registerAddEvent(eventID, "turn", 62000, {doTurn, npcID, "S"})
        registerAddEvent(eventID, "activate", 62100, {tutorial_activate, pid})
    elseif stage == 14 then
        setSV(player, trackerSV, 15)
    elseif stage == 15 then
        registerAddEvent(eventID, "complete", 20000, {tutorial_dragRoom_complete, pid})
    end
end

local tutorial_dragRoom_statuePosT = {{x = 495, y = 762, z = 8}, {x = 495, y = 764, z = 8}, {x = 495, y = 766, z = 8}, {x = 495, y = 768, z = 8}}
local function tutorial_dragRoom_statuesFuckUp2(player)
    setSV(player, trackerSV, 15)
    tutorial_activate(player)
end

local function tutorial_dragRoom_statuesFuckUp(player)
    for _, pos in pairs(tutorial_dragRoom_statuePosT) do
        if not tutorial_dragRoom_getStatue(pos) then return end
    end
    tutorial_dragRoom_statuesFuckUp2(player)
end

local buttonCrystalPos = { -- buttonPos = crystalPos
    [{x = 489, y = 760, z = 8}] = {x = 492, y = 761, z = 8},
    [{x = 489, y = 762, z = 8}] = {x = 494, y = 762, z = 8},
    [{x = 489, y = 764, z = 8}] = {x = 494, y = 764, z = 8},
    [{x = 489, y = 766, z = 8}] = {x = 494, y = 766, z = 8},
    [{x = 489, y = 768, z = 8}] = {x = 494, y = 768, z = 8},
}

local function tutorial_dragRoom_getCrystalPos(pos)
    for buttonPos, crystalPos in pairs(buttonCrystalPos) do
        if samePositions(buttonPos, pos) then return crystalPos end
    end
end

function tutorial_dragRoom_checkPuzzle()
    local crystalPos = {x = 494, y = 770, z = 8}

    for buttonPos, _ in pairs(buttonCrystalPos) do
        if findItem(426, buttonPos) then
            if not findItem(8639, crystalPos) then createItem(8639, crystalPos) end
            return
        end
    end
    removeItemFromPos(8639, crystalPos)
end

function tutorial_dragRoom_moveStatue(player, fromPos, toPos)
    if getSV(player, questSV) == 1 then return end
    local roomT = tutorial_getRoomByName("dragRoom")

    if not isInArray(roomT.stages, tutorial_getStage(player)) then return end
    if getDistanceBetween(fromPos, toPos, true) > 2 then return player:sendTextMessage(GREEN, "Too heavy for you to move such a distance at once.") end
    if Tile(toPos):hasProperty(CONST_PROP_BLOCKSOLID) then return player:sendTextMessage(GREEN, "Sometimes we can't put big objects on top of eachother") end
    if samePositions(roomT.startPos, toPos) then return tutorial_dragRoom_statuesFuckUp(player) end
    if samePositions(roomT.endPos, toPos) then return tutorial_dragRoom_statuesFuckUp2(player) end
    
    if doTransform(426, toPos, 425) then
        local crystalPos = tutorial_dragRoom_getCrystalPos(toPos)
        removeItemFromPos(8639, crystalPos)
        text("*click*", toPos)
    end
    
    if doTransform(425, fromPos, 426) then
        local crystalPos = tutorial_dragRoom_getCrystalPos(fromPos)
        if not findItem(8639, crystalPos) then createItem(8639, crystalPos) end
    end
    
    tutorial_dragRoom_checkPuzzle()
end

function tutorial_dragRoom_complete(player)
    player = Player(player)
    if not player then return end
    tutorial_enterRoom(player, "doorRoom")
end

function tutorial_dragRoom_reset()
local roomT = tutorial_getRoomByName("dragRoom")
local npcID = roomT.npcID

    stopAddEvent("npcID"..npcID, nil, true)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do tutorial_dragRoom_removeStatue(pos) end

    for buttonPos, crystalPos in pairs(buttonCrystalPos) do
        if doTransform(425, buttonPos, 426) then
            if not findItem(8639, crystalPos) then createItem(8639, crystalPos) end
        end
    end
    
    for _, pos in pairs(tutorial_dragRoom_statuePosT) do createItem(1476, pos) end
    createItem(1476, {x = 493, y = 763, z = 8})
    tutorial_dragRoom_checkPuzzle()
    teleport(npcID, roomT.npcPos, nil, roomT.npcDir)
end

---------------
-- door room --
---------------
function tutorial_doorRoom_startUp()
local treeID = 5157
local treePos = {x = 499, y = 766, z = 8}
local tree = findItem(treeID, treePos)

    if not tree then return end
    tree:remove()
    Game.createContainer(treeID, 3, treePos):setActionId(AIDT.mangoTree)
end

function tutorial_doorRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
local npcID = roomT.npcID
local eventID = "npcID"..npcID
local pid = player:getId()
    
    if stage == 16 then registerAddEvent(eventID, "addSV", 33000, {addSV, pid, trackerSV, 1}) end
end

function tutorial_doorRoom_tree(player, item)
    if item:getItemCountById(5097) == 0 then item:addItem(5097, 1):setActionId(AIDT.mango) end
end

local tutorial_canPassMangoDoor = false
function tutorial_doorRoom_mango(monster, item)
    if not monster:isMonster() then return end
    text("*chomp-chomp*", item:getPosition())
    text("*click*", {x = 502, y = 768, z = 8})
    item:remove()
    tutorial_canPassMangoDoor = true
end

function tutorial_doorRoom_mangoDoor(player, item)
    if not tutorial_canPassMangoDoor then return player:sendTextMessage(GREEN, "You need to do something before you can open this door") end
    automaticDoor(player, item)
    tutorial_canPassMangoDoor = false
    setSV(player, trackerSV, 19)
end

function tutorial_doorRoom_digSand(player, item)
    item:transform(8323)
    if item:getActionId() == AIDT.keyInSand then createItem(2089, item:getPosition(), 1, AIDT.doorRoomKey) end
end


function tutorial_doorRoom_complete(player)
    tutorial_enterRoom(player, "bagRoom")
end

function tutorial_doorRoom_reset()
local roomT = tutorial_getRoomByName("doorRoom")

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    removeItemFromPos(2089, {x = 505, y = 768, z = 8})
    
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        removeItemFromPos(5097, pos)
        doTransform(8323, pos, 231, true)
    end
end

-------------
-- bag room --
-------------
local tutorial_bagHint = false
function tutorial_bagRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
    
    if stage == 22 then
        tutorial_bagHint = true
        addEvent(function() tutorial_bagHint = false end, 55000)
    elseif stage > 22 and stage < 26 then
        addEvent(function() tutorial_bagHint = false end, 20000)
    end
end

function tutorial_bagRoom_complete(player, item)
    local function defaultFail()
        if tutorial_bagHint then return player:sendTextMessage(GREEN, "If you don't know what to do talk to NPC, maybe he knows how to help.") end
        tutorial_bagHint = true
    end
    
    if not player:getBag() then
        if defaultFail() then return end
        setSV(player, trackerSV, 23)
        return tutorial_activate(player)
    end
    
local valueItems = {7369, 7371, 7370, 2322}
    for _, itemID in pairs(valueItems) do
        if player:getItemCount(itemID) == 0 then
            if defaultFail() then return end
            setSV(player, trackerSV, 24)
            return tutorial_activate(player)
        end
    end
    
    if player:getItemCount(9076) ~= 2 then
        if defaultFail() then return end
        setSV(player, trackerSV, 25)
        return tutorial_activate(player)
    end
    
    tutorial_enterRoom(player, "potionRoom")
    tutorial_bagRoom_reset(player)
    player:giveItem(15645, 1, AIDT.bag)
end

function tutorial_bagRoom_reset(player)
local roomT = tutorial_getRoomByName("bagRoom")
local itemList = {
    [10518] = {x = 510, y = 761, z = 8},
    [5801] = {x = 510, y = 762, z = 8},
    [15645] = {x = 510, y = 763, z = 8},
    [7369] = {x = 510, y = 765, z = 8},
    [7370] = {x = 510, y = 766, z = 8},
    [7371] = {x = 510, y = 767, z = 8},
    [2322] = {x = 510, y = 768, z = 8},
}
    tutorial_bagHint = false
    stopAddEvent("npcID"..roomT.npcID, nil, true)
    if player then
        local bag = player:getBag()
        if bag then bag:remove() end
    end
    
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        massRemove(pos, 9076)
        for itemID, _ in pairs(itemList) do
            massRemove(pos, itemID)
        end
    end
    
    for itemID, pos in pairs(itemList) do createItem(itemID, pos) end
end

----------------
-- potion room --
----------------
function tutorial_potionRoom_stageFunc(player, roomT) end

function tutorial_potionRoom_mobberel(player, item)
    local itemID = item:getId()
    local itemPos = item:getPosition()
    
    player:sendTextMessage(GREEN, "After you take herb from object, it will take some time before you can take it again.")
    herbs_createHerbPowder(player, herbs_getHerbT("mobberel"), 1)
    addEvent(doTransform, 10000, 4175, itemPos, itemID, item:getActionId())
    doTransform(itemID, itemPos, 4175)
end

function tutorial_potionRoom_eaplebrond(player, item)
    player:sendTextMessage(GREEN, "After you pick up herb, it will take time before it respawns back.")
    herbs_createHerbPowder(player, herbs_getHerbT("eaplebrond"), 1)
    addEvent(createItem, 10000, item:getId(), item:getPosition(), 1, item:getActionId())
    item:remove()
end

function tutorial_potionRoom_poisonField(player, item)
    if player:getItemCount(7477) > 0 then
        setSV(player, trackerSV, 28)
    else
        setSV(player, trackerSV, 27)
    end
    tutorial_activate(player)
    bindCondition(player:getId(), "earth", 10000, {dam = 150, interval = 500})
end

function tutorial_potionRoom_complete(player, item)
    player:addHealth(1000)
    player:removePotion("antidote potion")
    tutorial_enterRoom(player, "staffRoom")
end

function tutorial_potionRoom_reset(player)
local roomT = tutorial_getRoomByName("potionRoom")
local itemList = {13881, 2006, 8299, 8301, 10031, 7477}
    
    stopAddEvent("npcID"..roomT.npcID, nil, true)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        for _, itemID in pairs(itemList) do
            massRemove(pos, itemID)
        end
    end
    
    if not player then return end
local bag = player:getBag()
    if not bag then return end
local bagID = bag:getId()
    
    bag:remove()
    player:giveItem(bagID, 1, AIDT.bag)
end

----------------
-- staff room --
----------------
function tutorial_staffRoom_startUp(roomT)
local bridgeT = {}
local staffT = {[12327] = "noPos"}
local bridgeParts = {18902, 18765, 18906}
local staffParts = {12324, 12325, 12326}
local bridgeUpID = 12694
local bridgeUpPos

    local function registerBridgePart(pos)
        for _, itemID in pairs(bridgeParts) do
            if findItem(itemID, pos) then return table.insert(bridgeT[itemID], pos) end
        end
    end
    local function registerStaffPart(pos)
        for _, itemID in pairs(staffParts) do
            if not staffT[itemID] then
                if findItem(itemID, pos) then
                    staffT[itemID] = pos
                    return
                end
            end
        end
    end
    local function findBridgeUp(pos)
        if bridgeUpPos then return end
        local bridgeUp = findItem(bridgeUpID, pos)
        
        if bridgeUp then
            bridgeUpPos = pos
            bridgeUp:setText("itemDescription", "You see bridge standing on strut.")
        end
    end
    
    for _, itemID in pairs(bridgeParts) do bridgeT[itemID] = {} end
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        registerBridgePart(pos)
        registerStaffPart(pos)
        findBridgeUp(pos)
    end
    
    roomT.bridgeT = bridgeT
    roomT.bridgeUpID = bridgeUpID
    roomT.bridgeUpPos = bridgeUpPos
    roomT.staffT = staffT
    roomT.strutPos = {x = 535, y = 766, z = 8}
end

function tutorial_staffRoom_stageFunc(player, roomT) end

function tutorial_staffRoom_createStaff(player, item, toPos)
local staffParts = {12324, 12325, 12326}
local itemID = item:getId()
    if not isInArray(staffParts, itemID) then return end
    if not Tile(toPos) then return true end
local partsFound = 1

    for _, itemID in pairs(staffParts) do
        if findItem(itemID, toPos) then partsFound = partsFound + 1 end
    end
    
    if partsFound ~= tableCount(staffParts) then return end
    for _, itemID in pairs(staffParts) do removeItemFromPos(itemID, toPos) end
    createItem(12327, toPos)
    return item:remove()
end

local staffReEquipDelay = false
function tutorial_staffRoom_staff(player)
    if staffReEquipDelay then return end
    setSV(player, trackerSV, 30)
    tutorial_activate(player)
    staffReEquipDelay = true
    addEvent(function() staffReEquipDelay = false end, 60000)
end

function tutorial_staffRoom_strut(monster)
local player = getHighestDamageDealerFromDamageT(monster:getDamageMap())
local roomT = tutorial_getRoomByName("staffRoom")
    
    removeItemFromPos(roomT.bridgeUpID, roomT.bridgeUpPos)
    for itemID, posT in pairs(roomT.bridgeT) do
        for _, pos in pairs(posT) do createItem(itemID, pos) end
    end
    setSV(player, trackerSV, 31)
    tutorial_activate(player)
end

function tutorial_staffRoom_lever(player, item)
local altarPos = {x = 532, y = 770, z = 8}

    changeLever(item)
    if not removeItemFromPos(12327, altarPos) then return end
    tutorial_createBlueTile(tutorial_getRoomByName("staffRoom"))
    setSV(player, trackerSV, 32)
    doSendMagicEffect(altarPos, 6)
end

function tutorial_staffRoom_complete(player, item)
    tutorial_enterRoom(player, "wallRoom")
end

function tutorial_staffRoom_reset(player)
local roomT = tutorial_getRoomByName("staffRoom")
local staffRoom = createAreaOfSquares(roomT.corners)
local staffT = roomT.staffT

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    tutorial_removeBlueTile(roomT)
    staffReEquipDelay = false
    
    for itemID, pos in pairs(staffT) do
        if not player or not player:removeItem(itemID) then
            for _, pos in pairs(staffRoom) do
                if removeItemFromPos(itemID, pos) then break end
            end
        end
    end
    
    for itemID, posT in pairs(roomT.bridgeT) do
        for _, pos in pairs(posT) do
            doSendMagicEffect(pos, 3)
            local item = findItem(itemID, pos)
            
            if item then
                if pos.y == 764 then
                    item:transform(4634)
                elseif pos.y == 765 then
                    item:transform(4612)
                elseif pos.y == 766 then
                    item:transform(4632)
                end
            end
        end
    end
    
    for itemID, pos in pairs(staffT) do
        if type(pos) == "table" then createItem(itemID, pos) end
    end

    local bridgeUpID = roomT.bridgeUpID
    local bridgeUpPos = roomT.bridgeUpPos
    if not findItem(bridgeUpID, bridgeUpPos) then
        createItem(bridgeUpID, bridgeUpPos, 1, AID.other.doNothing, n, "itemDescription(You see bridge standing on strut.)")
    end
    
    local strutPos = roomT.strutPos
    local strut = findByName(strutPos, "strut")
    if strut then strut:remove() end
    createMonster("strut", strutPos)
end
---------------
-- wall room --
---------------
function tutorial_wallRoom_stageFunc(player, roomT)
local stage = tutorial_getStage(player)
local npcID = roomT.npcID
local eventID = "npcID"..npcID
    
    if stage == 33 then
        registerAddEvent(eventID, "effects", 13000, {doSendMagicEffect, {x = 541, y = 765, z = 8}, {57, 57, 57}, 2000})
    elseif stage == 34 then
        registerAddEvent(eventID, "effects1", 11000, {doSendMagicEffect, {x = 539, y = 761, z = 8}, {57, 57, 57}, 2000})
        registerAddEvent(eventID, "effects2", 11000, {doSendMagicEffect, {x = 543, y = 761, z = 8}, {57, 57, 57}, 2000})
    elseif stage == 36 then
        registerAddEvent(eventID, "effects", 20000, {doSendMagicEffect, {x = 544, y = 768, z = 8}, {57, 57, 57}, 2000})
    end
end

function tutorial_wallRoom_upgradeDust(player, item, toPos)
    if not Tile(toPos) then return end
    local itemID = item:getId()
    if itemID ~= 6551 and itemID ~= 6550 then return end
    local possibleSwords = {2376, 7744, 7763}
    local toItemID = 7744

    if itemID == 6551 then toItemID = 7763 end
    for _, itemID in pairs(possibleSwords) do
        if doTransform(itemID, toPos, toItemID) then
            item:remove(1)
            doSendMagicEffect(toPos, 23)
            return true
        end
    end
end

function tutorial_wallRoom_orb(creature, corpse) removeItemFromPos(9381, {x = 541, y = 769, z = 8}) end

function tutorial_wallRoom_wall(creature, corpse)
local player = getHighestDamageDealerFromDamageT(creature:getDamageMap())
    
    addSV(player, trackerSV, 1)
    tutorial_activate(player)
end

local wallConfT = {
    ["fire wall"] = {
        takeDamageType = FIRE,
        requiredWeapon = 7763,
        failWeapon = 7744,
        effect = 44,
    },
    ["ice wall"] = {
        takeDamageType = ICE,
        requiredWeapon = 7744,
        failWeapon = 7763,
    },
    ["earth wall"] = {
        takeDamageType = EARTH,
        requiredWeapon = 2376,
        effect = 17,
    },
}

function tutorial_wallRoom_wallDamage(creature, attacker, damage, damType)
local confT = wallConfT[creature:getRealName()]
    
    if not confT then return error("missing confT") end
    if attacker and attacker:isPlayer() then
        if not attacker:getSlotItem(SLOT_LEFT) then
            damage = 0
        elseif attacker:getItemCount(confT.requiredWeapon) > 0 then
            if confT.effect then doSendMagicEffect(creature:getPosition(), confT.effect) end
            damage = -250
            damType = confT.takeDamageType
        elseif confT.failWeapon and attacker:getItemCount(confT.failWeapon) > 0 then
            attacker:say(getEleTypeByEnum(confT.takeDamageType).." damage doesn't seem to work on this wall.", ORANGE)
            damage = 0
        elseif damType == PHYSICAL then
            attacker:say("Physical damage doesn't seem to work on this wall.", ORANGE)
            damage = 0
        end
    end
    return damage, damType
end

function tutorial_wallRoom_complete(player, item)
    tutorial_wallRoom_reset(player)
    tutorial_enterRoom(player, "spellRoom")
end

function tutorial_wallRoom_reset(player)
    local config = {
        ["earth wall"] = {x = 541, y = 765, z = 8},
        ["ice wall"] = {x = 541, y = 766, z = 8},
        ["fire wall"] = {x = 541, y = 767, z = 8},
        ["tutorial orb"] = {x = 544, y = 768, z = 8},
    }
    local roomT = tutorial_getRoomByName("wallRoom")
    local itemList = {2389, 2376, 7763, 7744, 6551, 6550}

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    
    if player then        
        for _, itemID in pairs(itemList) do
            player:removeItem(itemID, player:getItemCount(itemID))
        end
    end
    
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, itemList) end
    
    for monsterName, pos in pairs(config) do
        if not findByName(pos, monsterName) then createMonster(monsterName, pos) end
    end

local wallPos = {x = 541, y = 769, z = 8}
    if not findItem(9381, wallPos) then createItem(9381, wallPos) end
end

----------------
-- spell room --
----------------
function tutorial_spellRoom_startUp(roomT)
local unchargedPillarID = 1353
local pillarPosT = {}

    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        if findItem(unchargedPillarID, pos) then table.insert(pillarPosT, pos) end
    end
    roomT.chargedPillarID = 1354
    roomT.unchargedPillarID = unchargedPillarID
    roomT.pillarPosT = pillarPosT
    roomT.roomSpells = {SV.tutorialSpell1, SV.tutorialSpell2, SV.tutorialSpell3}
end

function tutorial_spellRoom_stageFunc(player, roomT)
    if tutorial_getStage(player) ~= 37 then return end
    setSV(player, roomT.roomSpells, 1)
end
 
function tutorial_spellRoom_chargePillar(pos)
local roomT = tutorial_getRoomByName("spellRoom")
local pillar = findItem(roomT.unchargedPillarID, pos)

    if pillar then
        local eventData = {text, 30, pos}
        local eventData2 = {text, 20, pos}
        local eventData3 = {text, 10, pos}
        local eventData4 = {tutorial_spellRoom_unchargePillar, pos}
        local eventData5 = {text, 35, pos}
        
        pillar:transform(roomT.chargedPillarID)
        registerAddEvent("tutorialPillar"..pos.x, 35, 0, eventData5)
        registerAddEvent("tutorialPillar"..pos.x, 30, 5000, eventData)
        registerAddEvent("tutorialPillar"..pos.x, 20, 15000, eventData2)
        registerAddEvent("tutorialPillar"..pos.x, 10, 25000, eventData3)
        registerAddEvent("tutorialPillar"..pos.x, 36, 35000, eventData4)
        
        for e=0, 4 do
            local eventData = {text, 5-e, pos}
            local delay = e*1000+30000
            
            registerAddEvent("tutorialPillar"..pos.x, e, delay, eventData)
        end
    end
    
    for _, pos in pairs(roomT.pillarPosT) do
        if findItem(roomT.unchargedPillarID, pos) then return end
    end
    tutorial_createBlueTile(roomT)
end

function tutorial_spellRoom_unchargePillar(pos)
local roomT = tutorial_getRoomByName("spellRoom")
local pillar = findItem(roomT.chargedPillarID, pos)

    if pillar then pillar:transform(roomT.unchargedPillarID) end
end

function tutorial_spell1(cid)
local player = Player(cid)
local playerPos = player:getPosition()
local area = {
    {1,n,1},
    {n,0,n},
    {1,n,1},
}
local areaT = getAreaPos(playerPos, area)

    for _, posT in pairs(areaT) do
        for _, pos in pairs(posT) do
            doSendDistanceEffect(playerPos, pos, 5)
            doSendMagicEffect(pos, 38)
            tutorial_spellRoom_chargePillar(pos)
        end
    end
end

function tutorial_spell2(cid)
local player = Player(cid)
local playerPos = player:getPosition()
local area = {
    {n,n,3,n,n},
    {n,3,2,3,n},
    {n,n,{0,3},n,n},
    {1,n,n,n,1},
}
local areaT = getAreaPos(playerPos, area, getDirectionStrFromCreature(player))
local endPos

    for i, posT in pairs(areaT) do
        if endPos then break end
        for _, pos in pairs(posT) do
            if i == 2 then
                endPos = pos
                break
            end
        end
    end
    for i, posT in pairs(areaT) do
        for _, pos in pairs(posT) do
            if i == 1 then
                doSendDistanceEffect(pos, endPos, 38)
            elseif i == 3 then
                addEvent(doSendDistanceEffect, 450, endPos, pos, 31)
            elseif i == 2 then
                addEvent(doSendMagicEffect, 300, pos, 50)
                addEvent(tutorial_spellRoom_chargePillar, 300, pos)
            end
        end
    end
end

function tutorial_spell3(cid)
local player = Player(cid)
local playerPos = player:getPosition()
local area = {
    {n,n,3,n,n},
    {n,n,n,n,n},
    {n,n,n,n,n},
    {n,2,n,2,n},
    {n,n,0,n,n},
    {n,1,n,1,n},
}
local areaT = getAreaPos(playerPos, area, getDirectionStrFromCreature(player))
local endPosT = {}
local finalPos

    for i, posT in pairs(areaT) do
        if i == 2 then
            for _, pos in pairs(posT) do
                table.insert(endPosT, pos)
            end
        elseif i == 3 then
            for _, pos in pairs(posT) do
                finalPos = pos
            end
        end
    end
    for i, posT in pairs(areaT) do
        for _, pos in pairs(posT) do
            if i == 1 then
                for _, endPos in pairs(endPosT) do
                    doSendDistanceEffect(pos, endPos, 11)
                end
            elseif i == 2 then
                for _, endPos in pairs(endPosT) do
                    addEvent(doSendDistanceEffect, 300, endPos, finalPos, 11)
                end
            elseif i == 3 then
                addEvent(doSendMagicEffect, 500, pos, 18)
                addEvent(tutorial_spellRoom_chargePillar, 500, pos)
            end
        end
    end
end

function tutorial_spellRoom_complete(player, item)
local roomT = tutorial_getRoomByName("spellRoom")

    tutorial_spellRoom_reset(player)
    tutorial_enterRoom(player, "prepRoom")
end

function tutorial_spellRoom_reset(player)
local roomT = tutorial_getRoomByName("spellRoom")

    for _, pos in pairs(roomT.pillarPosT) do
        stopAddEvent("tutorialPillar"..pos.x, nil, true)
        doTransform(roomT.chargedPillarID, pos, roomT.unchargedPillarID)
    end
    stopAddEvent("npcID"..roomT.npcID, nil, true)
    removeSV(player, roomT.roomSpells)
    tutorial_removeBlueTile(roomT)
end

---------------
-- prep room --
---------------
function tutorial_prepRoom_startUp(roomT)
local spellT = {}
local vialPosT = {}
    
    local function registerSpell(pos)
        local spellScroll = findItem(5958, pos)
        if spellScroll then spellT[spellScroll:getActionId()] = pos end
    end
    
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        registerSpell(pos)
        if findItem(2006, pos) then table.insert(vialPosT, pos) end
    end
    
    roomT.spellT = spellT
    roomT.vialPosT = vialPosT
end

local tutorial_prepHint = false
function tutorial_prepRoom_stageFunc(player, roomT)
    tutorial_prepHint = true
    if tutorial_getStage(player) == 38 then
        registerAddEvent("npcID"..roomT.npcID, "effects", 15000, {doSendMagicEffect, {x = 469, y = 777, z = 8}, {57, 57, 57}, 2000})
        addEvent(function() tutorial_prepHint = false end, 10000)
    else
        addEvent(function() tutorial_prepHint = false end, 5000)
    end
end

function tutorial_prepRoom_spellSpawn()
local roomT = tutorial_getRoomByName("prepRoom")
local spellT = roomT.spellT

    for AID, pos in pairs(spellT) do
        createItem(5958, pos, 1, AID)
        doSendMagicEffect(pos, 40)
    end
end

function tutorial_prepRoom_complete(player, item)
    local function defaultFail()
        if tutorial_prepHint then return player:sendTextMessage(GREEN, "If you don't know what to do talk to NPC, maybe he knows how to help.") end
    end
    
    if player:getCheckPointID() ~= 1 then
        if defaultFail() then return end
        setSV(player, trackerSV, 39)
        return tutorial_activate(player)
    end
    
    if player:getItemCount(2006, nil, 1) == 0 then
        if defaultFail() then return end
        setSV(player, trackerSV, 40)
        return tutorial_activate(player)
    end
    
    local spellList = {SV.armorup, SV.heal, SV.spark, SV.trap}
    if not compareSV(player, spellList, "==", 1) then
        if defaultFail() then return end
        setSV(player, trackerSV, 41)
        return tutorial_activate(player)
    end
    
    tutorial_enterRoom(player, "lootRoom")
    tutorial_prepRoom_reset()
end

function tutorial_prepRoom_reset(player)
    local roomT = tutorial_getRoomByName("prepRoom")
    local deleteList = {5958, 2006}

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, deleteList) end
    
    if player then
        local svT = {
            [SV.checkPoint] = -1,
            [SV.trap] = -1,
            [SV.heal] = -1,
            [SV.spark] = -1,
            [SV.armorup] = -1,
        }
        
        for _, itemID in pairs(deleteList) do
            player:removeItem(itemID, player:getItemCount(itemID))
        end
        setSV(player, svT)
    end
    
    for AID, pos in pairs(roomT.spellT) do createItem(5958, pos, 1, AID) end
    for _, pos in pairs(roomT.vialPosT) do createItem(2006, pos, 1, nil, 0) end
    tutorial_prepHint = false
end
--------------
-- loot room --
--------------
function tutorial_lootRoom_startUp()
local roomT = tutorial_getRoomByName("lootRoom")
local rubbishID = 2242
local rubbishPosT = {}
    
    local function createPole(pos)
        local pole = findItem(5787, pos)
        if not pole then return end
        createMonster("tutorial pole", pos)
        pole:remove()
    end
    
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        if findItem(rubbishID, pos) then table.insert(rubbishPosT, pos) end
        createPole(pos)
    end
    
    roomT.rubbishID = rubbishID
    roomT.rubbishPosT = rubbishPosT
end

function tutorial_lootRoom_stageFunc(player, roomT)
    if tutorial_getStage(player) ~= 42 then return end
    local npcID = roomT.npcID
    local eventID = "npcID"..npcID

    registerAddEvent(eventID, "tp1", 26000, {teleport, npcID, {x = 482, y = 780, z = 8}})
    registerAddEvent(eventID, "tp2", 27000, {teleport, npcID, {x = 481, y = 780, z = 8}, false, "E"})
end

function tutorial_lootRoom_destroyPole(creature)
    local attackers = creature:getDamageMap()
    local pos = creature:getPosition()
    local brokenBottle = createItem(2024, pos)
    local corpse = Game.createContainer(3613, 1, pos)

    corpse:addItem(2242)
    corpse:setActionId(AIDT.brokenPole)
    addEvent(createMonster, 60000, "tutorial pole", pos)
    addEvent(removeItemFromPos, 50000, 2024, pos)
    addEvent(removeItemFromPos, 50000, 3613, pos)
    addEvent(doSendMagicEffect, 50000, pos, 3)
    for pid, t in pairs(attackers) do
        local player = Player(pid)
        
        if player and isInArray({42, 43}, tutorial_getStage(player)) then
            addSV(player, SV.tutorial_shop, 1)
            
            if getSV(player, SV.tutorial_shop) > 0 then
                setSV(player, trackerSV, 43)
                tutorial_activate(player)
            end
        end
    end
end

function tutorial_lootRoom_npcEscape(player)
local roomT = tutorial_getRoomByName("prepRoom")

    player:addHealth(1000)
    player:addMana(1000)
    tutorial_lootRoom_reset(player)
    setSV(player, trackerSV, roomT.stages[1])
    teleport(player, roomT.startPos)
end

function tutorial_lootRoom_complete(player)
    if player:getItemCount(2467) == 0 then return player:sendTextMessage(GREEN, "You need to buy and equip leather armor to complete this tutorial room") end    
    local svT = {SV.trap, SV.heal, SV.spark, SV.armorup}

    removeSV(player, svT)
    tutorial_enterRoom(player, "resRoom")
    player:removeItem(2006, player:getItemCount(2006))
    tutorial_lootRoom_reset(player)
end

function tutorial_lootRoom_reset(player)
    local roomT = tutorial_getRoomByName("lootRoom")
    local deleteList = {2242, ITEMID.other.coin, 2467, 2152, 2024, 2671}
    local npcID = roomT.npcID

    stopAddEvent("npcID"..npcID, nil, true)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, deleteList) end
    
    if player then
        local svT = {SV.tutorial_escapeButton, SV.tutorial_shop}
        removeSV(player, svT)
        for _, itemID in pairs(deleteList) do
            if itemID ~= 2467 then player:removeItem(itemID, player:getItemCount(itemID)) end
        end
    end
    
    for _, pos in pairs(roomT.rubbishPosT) do createItem(roomT.rubbishID, pos) end
    teleport(npcID, {x = 483, y = 781, z = 8}, false, "N")
end
---------------
--- res room --
---------------
function tutorial_resRoom_stageFunc(player, roomT)
    if tutorial_getStage(player) ~= 44 then return end
    registerAddEvent("npcID"..roomT.npcID, "addSV", 50000, {addSV, player:getId(), trackerSV, 1})
end

local function getRandomRes(player, itemEx)
    if not itemEx or not itemEx:isItem() then return end
    if itemEx:getId() ~= 2467 then return end
local randomRes = math.random(5, 13)
local position = getParentPos(itemEx)

    itemEx:setAttribute(DESCRIPTION, "[In tutorial I will not show ice or fire resistance on item. Use either command !stats or look stats from player panel]")
    doSendMagicEffect(position, {40, 4})
    return position, randomRes
end

local function getResSV(itemAID)
    if itemAID == AIDT.fireHammer then return SV.tutorial_fireRes, SV.tutorial_iceRes, 37 end
    if itemAID == AIDT.iceHammer then return SV.tutorial_iceRes, SV.tutorial_fireRes, 42 end
end

function tutorial_resRoom_hammer(player, item, itemEx)
local pos, res = getRandomRes(player, itemEx)
    if not pos then return end
local resSV, resetSV, effect = getResSV(item:getActionId())

    setSV(player, resetSV, 0)
    doSendMagicEffect(pos, effect)
    addSV(player, resSV, res, 75)
end

function tutorial_resRoom_complete(player)
local fireRes = player:getResistance("fire")

    if getSV(player, SV.tutorial_fireRes) > 70 and fireRes < 70 then
        player:sendTextMessage(GREEN, "Sorry something must have bugged out, I will let you pass this tutorial room, automatic error detection ftw :D")
        player:sendTextMessage(BLUE, "Sorry something must have bugged out, I will let you pass this tutorial room, automatic error detection ftw :D")
        print("tutorial_resRoom_complete() sure bugged out again.")
        player:getResistance("fire", true)
    else
        if player:getItemCount(2467) == 0 then return player:sendTextMessage(GREEN, "don't forget to equip leather armor") end
        
        if fireRes < 48 then
            setSV(player, trackerSV, 45)
            return tutorial_activate(player)
        elseif fireRes > 55 then
            setSV(player, trackerSV, 46)
            return tutorial_activate(player)
        end
    end
    tutorial_enterRoom(player, "fieldRoom")
end

function tutorial_resRoom_reset(player)
local roomT = tutorial_getRoomByName("resRoom")
local deleteList = {7450, 2421}

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    setSV(player, SV.tutorial_fireRes, 0)
    setSV(player, SV.tutorial_iceRes, 0)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, deleteList) end    
end
----------------
-- field room --
----------------
function tutorial_fieldRoom_startUp(roomT)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do
        local fire = findItem(1492, pos)
        local ice = findItem(1397, pos)
        if fire then fire:setActionId(AIDT.fireField) end
        if ice then ice:setActionId(AIDT.iceField) end
    end
end

function tutorial_fieldRoom_stageFunc(player, roomT) end
function tutorial_fieldRoom_fireField(player, item) return damageOverTime(player, math.random(250, 300), FIRE, 3000, 16, "d/2") end
function tutorial_fieldRoom_iceField(player, item) return damageOverTime(player, math.random(250, 300), ICE, 3000, 38, "d/2") end

function tutorial_fieldRoom_complete(player)
    local roomT = tutorial_getRoomByName("fieldRoom")
    local deleteList = {7450, 2421}

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    if not player then return end
    removeSV(player, SV.tutorial_fireRes)
    removeSV(player, SV.tutorial_iceRes)
    player:addHealth(1000)
    for _, itemID in pairs(deleteList) do player:removeItem(itemID, player:getItemCount(itemID)) end
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, deleteList) end
    removeDOT(player)
    tutorial_enterRoom(player, "skillRoom")
end

function tutorial_fieldRoom_reset(player) end

--------------------
-- skill room --
--------------------
function tutorial_skillRoom_stageFunc(player, roomT) end

function tutorial_skillRoom_complete(player, dontReset)
    if not dontReset then tutorial_skillRoom_reset(player) end
    tutorial_enterRoom(player, "skipRoom")
end

function tutorial_skillRoom_reset(player)
local orbPos = {x = 512, y = 780, z = 8}
local roomT = tutorial_getRoomByName("skillRoom")
local deleteList = {7857, 2467}

    stopAddEvent("npcID"..roomT.npcID, nil, true)
    for _, pos in pairs(createAreaOfSquares(roomT.corners)) do massRemove(pos, deleteList) end
    if not findByName(orbPos, "tutorial tp orb") then createMonster("tutorial tp orb", orbPos) end
    if not player then return end
    for _, itemID in pairs(deleteList) do player:removeItem(itemID, player:getItemCount(itemID)) end
    skillTree_resetAll(player)
    setSV(player, SV.skillpoints, 0)
    player:giveItem(2467)
end

function tutorial_skillRoom_orb(monster)
    local player = getHighestDamageDealerFromDamageT(monster:getDamageMap())
    local pos = monster:getPosition()

    doSendMagicEffect(pos, 3)
    addEvent(doSendMagicEffect, 5000, pos, 5)
    addEvent(createMonster, 5000, "tutorial tp orb", pos)
    if not player then return end
    tutorial_skillRoom_complete(player)
end

function tutorial_skillRoom_orbDamage(player, attacker, damage, damType, origin)
    if not Player(attacker) then return 0, damType end
    local weapon = attacker:getSlotItem(SLOT_LEFT)
    if not weapon or weapon:getId() ~= 7857 then return 0, damType end
    
    doSendMagicEffect(player:getPosition(), 9)
    damage = 100
    damType = EARTH
    damage = damage + green_powderDamage(attacker, damage, damType)
    damage = damage - 99
    return damage, damType
end
---------------
-- boss room --
---------------
function tutorial_bossRoom_startUp()
    local upCorner = {x = 533, y = 699, z = 8}
    local downCorner = {x = 555, y = 731, z = 8}
    
    for z=8, 15 do
        local posT = createSquare({x = upCorner.x, y = upCorner.y, z=z}, {x = downCorner.x, y = downCorner.y, z=z})

        for _, pos in pairs(posT) do
            local fire = findItem(1492, pos)
            if fire then fire:setActionId(AIDT.bossRoom_fireField) end
        end
    end

    local confT = {
        checkPoint = {pos = {x = 536, y = 737, z = 9}, itemID = 1445, itemAID = AIDT.bossRoom_checkPoint},
        stairs = {pos = {x = 553, y = 701, z = 9}, itemID = 1385, itemAID = AIDT.bossRoom_stairs},
        rail = {pos = {x = 535, y = 733, z = 9}, itemID = 1590, itemAID = AIDT.bossRoom_rail},
    }
    

    for objectName, t in pairs(confT) do
        local pos = t.pos
        local itemID = t.itemID
        local newAID = t.itemAID
        
        for z=9, 15 do
            pos.z = z
            local item = findItem(itemID, pos)
            if not item then error("missing tutorial_bossRoom_"..objectName.." ["..itemID.."] in pos: ["..pos.x..", "..pos.y..", "..pos.z.."]") end
            item:setActionId(newAID)
        end
    end
end

local startingItems = {
    ["druid"]   = {bag = 1991, weapon = 2184}, -- wand
    ["knight"]  = {bag = 1996, weapon = 2376}, -- sword
    ["mage"]    = {bag = 1995, weapon = 2184}, -- wand
    ["hunter"]  = {bag = 1993, weapon = 7367}, -- regen spear
}
function tutorial_bossRoom_rail(player, item)
    if getSV(player, SV.checkPoint) ~= 3 then return player:sendTextMessage(GREEN, "Set checkpoint first!") end
    local vocation = player:getVocation():getName():lower()
    if vocation == "none" then return player:sendTextMessage(GREEN, "You need to choose a vocation") end
    local Z = player:getPosition().z

    local function removeDummy(posT)
        for _, pos in pairs(posT) do
            if massRemove(pos, "monster") then return true end
        end
    end

    local block1 = createSquare({x = 553, y = 707, z=Z}, {x = 554, y = 714, z=Z})
    if not removeDummy(block1) then
        local block2 = createSquare({x = 533, y = 715, z=Z}, {x = 554, y = 717, z=Z})
        if not removeDummy(block2) then
            local block3 = createSquare({x = 535, y = 718, z=Z}, {x = 536, y = 731, z=Z})
            removeDummy(block3)
        end
    end
    
    local torch = player:getSlotItem(SLOT_AMMO)
    local bag = player:getBag()
    local weapon = player:getSlotItem(SLOT_LEFT)
    local itemT = startingItems[vocation]
        
    if torch then
        teleport(player, getDirectionPos(item:getPosition(), "N", 2))
        torch:remove()
    else
        teleport(player, getDirectionPos(item:getPosition(), "N", 17))
    end
    
    if bag then bag:remove() end
    if weapon then weapon:remove() end
    player:sendTextMessage(ORANGE, "Don't forget to put your new spell into hotkeys. You will need to use it for this fight.")
    player:sendTextMessage(ORANGE, "Tip: Click further ahead to move there faster!!.")
    player:sendTextMessage(GREEN, "Don't forget to put your new spell into hotkeys. You will need to use it for this fight.")
    setSV(player, trackerSV, 51)
    player:giveItem(itemT.bag, 1)
    player:giveItem(itemT.weapon, 1)
    
    local dummy = createMonster("Dummy", {x=553, y=708, z=Z})
    local nerfV = getSV(player, SV.dummyNerf)
    if nerfV < 1 then return end
    if nerfV > 10 then nerfV = 10 end
    dummy:addHealth(-300*nerfV)
end

function tutorial_bossRoom_fireField(creature)
    if not creature:isPlayer() then return end
    damageOverTime(creature, 400, FIRE, 3000, 16)
end

function tutorial_bossRoom_stairs(player)
    teleport(player, {x = 553, y = 700, z = 7})
    setAccountSV(player:getAccountId(), SV.dummyRewards, getSV(player, SV.dummyRewards) + 1)
end

---------------
-- skip room --
---------------
function tutorial_skipRoom_stageFunc() end -- need to have function
function tutorial_skipRoom_reset() end -- need to have function

local floor = 9
function tutorial_skipRoom_complete(player, item)
local svT = {
    [trackerSV] = 51,
    [questSV] = 0,
    SV.tutorial_fireRes,
    SV.tutorial_iceRes,
    SV.dummyNerf,
    SV.npcLookDisabled,
    SV.lookDisabled,
    [SV.tutorialNPC1] = 1,
    [SV.tutorialNPC2] = 1,
    SV.tutorial_shop,
    SV.tutorial_escapeButton,
    SV.dummyKey,
    SV.dummyKill,
    SV.tutorial_doorRoomKey,
    [SV.tutorialBossRoomFloor] = floor,
}   
    setSV(player, svT, -1)
    player:teleportTo({x=533,y=739,z=floor})
    floor = floor + 1
    if floor == 16 then floor = 9 end
end

function tutorial_skipRoom_fail(player, item)
    teleport(player, {x = 523, y = 738, z = 8})
    player:sendTextMessage(GREEN, "not correct blue tile.")
    addSV(player, SV.skipRoomTpFail, 1, 4)
    if getSV(player, SV.skipRoomTpFail) == 1 then return player:sendTextMessage(BLUE, "Tip: don't forget that npc's can guide or give hints how to progress") end
    if getSV(player, SV.skipRoomTpFail) == 2 then return player:sendTextMessage(BLUE, "Tip: look all the things you can see in the 2 blue tile room") end
    if getSV(player, SV.skipRoomTpFail) == 3 then return player:sendTextMessage(BLUE, "Tip: LOOK sand tile in the 2 blue tile room") end
    player:sendTextMessage(BLUE, "Tip: USE sand tiles in the room where are two blue tiles to find a hole")
end