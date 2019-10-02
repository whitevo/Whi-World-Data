local trackerSV = SV.tutorialTracker

npcConf_tutorialNpc = {
    name = "npc",
    npcShop = {
        [1] = {
            npcName = "npc",
            bigSV = {[SV.tutorialTracker] = 42},
            bigSVF = {[SV.tutorialTracker] = 44},
            items = {
                {itemID = 2006, cost = 2, fluidType = 0},
                {itemID = 2671, itemAID = AID.other.food, cost = 4},
                {itemID = 2242, sell = 7},
            }
        },
        [2] = {
            npcName = "npc",
            allSV = {[SV.tutorial_shop] = -1},
            bigSV = {[SV.tutorialTracker] = 42},
            bigSVF = {[SV.tutorialTracker] = 44},
            items = {itemID = 2467, cost = 100},
        },
        [3] = {
            npcName = "npc",
            allSV = {[SV.tutorial_shop] = 0},
            items = {itemID = 2467, cost = 80}
        },
        [4] = {
            npcName = "npc",
            allSV = {[SV.tutorial_shop] = 1},
            items = {itemID = 2467, cost = 60}
        },
        [5] = {
            npcName = "npc",
            allSV = {[SV.tutorial_shop] = 2},
            items = {itemID = 2467, cost = 40}
        },
        [6] = {
            npcName = "npc",
            bigSV = {[SV.tutorial_shop] = 3},
            items = {itemID = 2467, cost = 20}
        },
    },
    npcChat = {
        ["npc"] = {
            [139] = {
                question = "These choices are usually questions or conversation pieces you can say or use to get information from an NPC, press ENTER once you've selected your choice.",
                allSV = {[SV.tutorialNPC1] = -1},
                bigSV = {[trackerSV] = 3},
                bigSVF = {[trackerSV] = 6},
                setSV = {[SV.tutorialNPC1] = 1},
                answer = {"As you can see, the texts appear in the local chat.","This is how talking with NPCs works.", "Try talking to the NPC again."},
                closeWindow = true,
            },
            [140] = {
                question = "I'm ready to continue.",
                allSV = {[SV.tutorialNPC1] = 1, [SV.tutorialNPC2] = -1},
                setSV = {[SV.tutorialNPC2] = 1},
                answer = {
                    "This conversation with NPCs will be generated for you depending on your character progression.",
                    "This is an RPG game, so keep in touch with NPCs regularly if you find new things or mysteries.",
                    "Most of the time they will help you solve them!",
                },
            },
            [141] = {
                question = "How do I pass this tutorial room?",
                allSV = {[SV.tutorialNPC2] = 1},
                bigSV = {[trackerSV] = 3},
                bigSVF = {[trackerSV] = 6},
                setSV = {[SV.lookDisabled] = -1, [trackerSV] = 5},
                answer = {
                    "You have to LOOK at the stones in the correct sequence in under 5 seconds.",
                    "If all the stones are activated in time, a blue tile will appear.",
                    "Looking at the stones in the incorrect sequence or being too slow deactivates the magic stones, and you will have to try again.",
                    "Don't forget that the shortcut for LOOK is holding down the SHIFT key and clicking on the object."
                },
            },
            [142] = {
                question = "What next?",
                allSV = {[trackerSV] = 9},
                setSV = {[trackerSV] = 10},
                funcSTR = "tutorial_activate",
                answer = {
                    "To climb up you have face the direction or place which you want to try climbing and if there is an edge on the above level in front of you, you will be able to clim up.",
                    "Like in the old 'Prince of Persia', but in top-down camera mode! :D",
                },
                closeWindow = true,
            },
            [143] = {
                question = "How to climb over rails?",
                allSV = {[trackerSV] = 11},
                setSV = {[trackerSV] = 12},
                funcSTR = "tutorial_activate",
                answer = {
                    "To climb rails you need to USE them.",
                    "To USE items, hold down CTRL and click (left mouse button) on the rail.",
                },
                closeWindow = true,
            },
            [144] = {
                question = "What now?",
                allSV = {[trackerSV] = 13},
                answer = {"You have learned all you needed to in this room.", "Step on the blue tile to proceed to the next tutorial room."},
                closeWindow = true,
            },
            [145] = {
                question = "What do I do now?",
                allSV = {[trackerSV] = 14},
                answer = {
                    "Place the statues on the pressure plates, or buttons, and try clearing the way to the other statues.",
                    "Once there is a statue placed on each button, the way to the blue tile will open.",
                },
            },
            [146] = {
                question = "How do I pass the door with a red knob?",
                allSV = {[trackerSV] = 18},
                answer = {
                    "USE the tree to get its fruit. Like you did in the previous room, you can DRAG the fruit out of the tree.",
                    "DRAG the mango to the position of the hungry worm and DROP it there.",
                    "After the worm has eaten the mango, you will be given permission to open the door.",
                },
            },
            [147] = {
                question = "Where do I find the key for the locked door?",
                allSV = {[trackerSV] = 19},
                answer = {"You can USE sand tiles to dig them up. When you find the key, USE it on yourself to put it in your keychain."},
            },
            [148] = {
                question = "How do I collect keys?",
                allSV = {[trackerSV] = 20},
                answer = {
                    "LOOK at the key!!!",
                    "Always LOOK at items you haven't seen before, this can provide you with important information about the item.",
                },
            },
            [149] = {
                question = "How do I open the bag?",
                bigSV = {[trackerSV] = 22},
                bigSVF = {[trackerSV] = 25},
                answer = {"Hold down the CTRL key and click on the bag to open it. Holding down the CTRL key and clicking on the container will OPEN it."},
            },
            [150] = {
                question = "Can I place containers inside other containers?",
                bigSV = {[trackerSV] = 22},
                bigSVF = {[trackerSV] = 25},
                answer = {
                    "Of course, first you need to place the bag on the floor.",
                    "Now right-click on it and choose the 'Browse field' command.",
                    "The bag will turn into a token bag. Token bags can be placed into containers and are much lighter than the normal bags.",
                    "If you are wondering why it's called 'Browse field'; then like I said before, this client was not made for my game. xD",
                },
            },
            [151] = {
                question = "How do I equip a bag?",
                bigSV = {[trackerSV] = 22},
                bigSVF = {[trackerSV] = 25},
                answer = {
                    "DRAG your bag to the gray bag slot, located on the right side of your screen.",
                    "To remove or unequip the bag, just DRAG it out of the bag slot and drop it somewhere else.",
                },
            },
            [152] = {
                question = "How do I put items into my bag?",
                bigSV = {[trackerSV] = 22},
                bigSVF = {[trackerSV] = 25},
                answer = {
                    "When you OPEN a bag, a new window will appear below your character inventory.",
                    "If you DRAG an item to one of the empty slots it will go into the container.",
                },
            },
            [153] = {
                question = "Where do I get a vial?",
                bigSV = {[trackerSV] = 26},
                bigSVF = {[trackerSV] = 28},
                rewardItems = {{itemID = 2006, fluidType = 0}},
                answer = {"There you go."},
            },
            [154] = {
                question = "Where do I get the potion powder?",
                bigSV = {[trackerSV] = 26},
                bigSVF = {[trackerSV] = 28},
                answer = {"LOOK around at plants and nature to see if they offer anything useful or special."},
            },
            [155] = {
                question = "What do I do with the vial?",
                bigSV = {[trackerSV] = 26},
                bigSVF = {[trackerSV] = 28},
                moreItems = {{itemID = 2006, fluidType = 0}},
                answer = {"USE the vial on some water and that will fill it up."},
            },
            [156] = {
                question = "How do I make a potion?",
                bigSV = {[trackerSV] = 26},
                bigSVF = {[trackerSV] = 28},
                moreItems = {{itemID = 2006, fluidType = 1}},
                answer = {
                    "USE the 'powder' on the 'Vial of water' to get an 'Unfinished potion'.",
                    "USE the 'Unfinished potion' with another 'powder' to finish your potion.",
                    "There are different kinds of potions you can make with different ingredients, but in this case, with the ingredients you have, it will be an 'Antidote potion'.",
                },
            },
            [157] = {
                question = "How do I make a staff?",
                allSV = {[trackerSV] = 29},
                answer = {"Place all of the staff pieces on top of each other."},
            },
            [158] = {
                question = "I think I lost a piece of the staff, could you reset the room?",
                bigSV = {[trackerSV] = 29},
                bigSVF = {[trackerSV] = 32},
                setSV = {[trackerSV] = 29},
                teleport = {x = 532, y = 760, z = 8},
                funcSTR = "tutorial_staffRoom_reset",
                answer = "Done.",
            },
            [159] = {
                question = "How do I get across this stream?",
                allSV = {[trackerSV] = 30},
                answer = {
                    "You need to destroy the 'strut' so you can use it as a bridge when it falls down.",
                    "HOLD down the ALT key and click on the 'strut'.",
                    "This action will select the thing you clicked as a target and when you are near enough to your target you will shoot it with the staff.",
                },
            },
            [160] = {
                question = "Where do I go now?",
                allSV = {[trackerSV] = 31},
                answer = {"Place the staff on the basin and pull the lever to create a teleporter which will take you to the next room."},
            },
            [161] = {
                question = "Can I get a sword?",
                bigSV = {[trackerSV] = 33},
                bigSVF = {[trackerSV] = 36},
                moreItemsF = {{itemID = 2376, count = 1}},
                answer = {"Here you go."},
                rewardItems = {{itemID = 2376}},
            },
            [162] = {
                question = "How do I enchant my sword?",
                allSV = {[trackerSV] = 34},
                answer = {"Drop your sword to the ground and place the dust on top of it."},
            },
            [163] = {
                question = "Can I get some spears to destroy the orb?",
                allSV = {[trackerSV] = 36},
                moreItemsF = {{itemID = 2389, count = 3}},
                rewardItems = {{itemID = 2389, count = 10}},
                answer = {"Here you go."},
            },
            [164] = {
                question = "How do I change my direction again?",
                allSV = {[trackerSV] = 36},
                answer = {"HOLD down the CTRL key and PRESS the ARROW keys on your keyboard."},
            },
            [165] = {
                question = "Where can I see my spell commands again?",
                allSV = {[trackerSV] = 37},
                answer = {
                    "LOOK at your own character, select 'spellbook' and open it.",
                    "There will be list of spells your character has learned.",
                    "You can see the spell words you need to type in to cast these spells in the spell details.",
                    "You can also print out the spell word to your console from the spell information.",
                },
            },
            [166] = {
                question = "How do I set up hotkeys again?",
                allSV = {[trackerSV] = 37},
                answer = {
                    "Hold down the CTRL key and press K.",
                    "Highlight an available hotkey and write the spell word into the hotkey edit box.",
                    "Also tick the box: Send automatically.",
                    "After you have written all your spells under different hotkey selections, press OK.",
                },
            },
            [167] = {
                question = "What do I need to do in this room?",
                allSV = {[trackerSV] = 37},
                answer = {
                    "Use your spells to 'attack' the pillars and turn them blue (charged state).",
                    "To pass, you have to have all the pillars in a charged state at the same time.",
                },
            },
            [168] = {
                question = "How do I create a vial of water here?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                answer = {"USE the empty vial on the well to fill it up."},
            },
            [169] = {
                question = "I need more vials, can I get some?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                rewardItems = {{itemID = 2006, type = 0}},
                answer = {"No problemo."},
            },
            [170] = {
                question = "How can I learn a spell?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                answer = {"USE the 'Spellscroll'."},
            },
            [171] = {
                question = "Why do I need to USE the checkpoint?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                answer = {"This is like setting your progression point, whenever you die or use something that teleports you 'home', it will teleport you to that checkpoint."},
            },
            [172] = {
                question = "How can I set a checkpoint?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                answer = {"USE the monument."},
            },
            [173] = {
                question = "Could you reload the spells in this room?",
                bigSV = {[trackerSV] = 38},
                bigSVF = {[trackerSV] = 42},
                funcSTR = "tutorial_prepRoom_spellSpawn",
                answer = {"Sure thing."},
            },
          
            [174] = {
                question = "How do I regenerate mana?",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                answer = {
                    "USE a vial of water on yourself to regenerate MP (manapoints).",
                    "You can also eat food to regenerate mana (for example, I sell ham).",
                },
            },
            [175] = {
                question = "I want to return to preparation room!",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                setSV = {[SV.tutorial_escapeButton] = 1},
                answer = {
                    "Sure, but I will have to take all your money.",
                    "To return to the preparation room, press the ESCAPE button in the NPC chat panel (the one you already have open here).",
                },
            },
            [176] = {
                question = "How do I trade with you?",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                answer = {"Press the TRADE button in NPC panel."},
            },
            [177] = {
                question = "How do I BUY and SELL items?",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                answer = {
                    "To open up the 'trade' window, press the TRADE button in NPC chat (not all NPCs have this option).",
                    "You will then see a list of items with the following item information: 'item name', 'item cost', 'item sell value' and 'how many items' you have the option to buy.",
                    "To interact with an item, select it from the trade list and click either BUY, SELL or LOOK to interact with it.",
                },
            },
            [178] = {
                question = "The poles are too strong, I can't fight them for long.",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                answer = {
                    "Cast the !armorup spell. While this spell is active you will suffer no 'damage points' from the poles!!!",
                    "Cast the !heal spell to get some HP (hitpoints) back."
                },
            },
            [179] = {
                question = "How can I destroy the poles?",
                bigSV = {[trackerSV] = 42},
                bigSVF = {[trackerSV] = 44},
                answer = {
                    "Cast your spells! Use the !spark spell to deal damage to anything in front of you.",
                    "USE a vial of water on yourself to regenerate MP (manapoints).",
                },
            },
            [180] = {
                question = "Can I get the resistance hammers?",
                bigSV = {[trackerSV] = 44},
                bigSVF = {[trackerSV] = 48},
                moreItemsF = {{itemID = 7450, count = 1}, {itemID = 2421, count = 1}},
                rewardItems = {{itemID = 7450, itemAID = AID.quests.tutorial.iceHammer}, {itemID = 2421, itemAID = AID.quests.tutorial.fireHammer}},
                answer = {"Yes, no problem, there you go!"},
            },
            [192] = {
                question = "How do I increase armor resistance values?",
                bigSV = {[trackerSV] = 44},
                bigSVF = {[trackerSV] = 48},
                moreItems = {{itemID = 7450, count = 1}},
                answer = {"USE the hammer on your leather armor."},
            },
            [181] = {
                question = "How do I get across safely?",
                allSV = {[trackerSV] = 47},
                answer = {"Sometimes there is no safe route.", "All you can do here is put as big a resistance on your armor that you can and run through."},
            },
            [182] = {
                question = "What are we going to learn in this room?",
                bigSV = {[trackerSV] = 48},
                bigSVF = {[trackerSV] = 49},
                setSV = {[SV.skillpoints] = 5, [trackerSV] = 49},
                answer = {
                    "In this room we're going to learn about your 'Skilltree'.",
                    "This is an extra feature which you can use to add perks to your character to increase your resistance or abilities.",
                    "As usual, all player personal data can be found by LOOKing at your character.",
                    "When you open your 'Skilltree' and browse through the skills, click the description button to see what they do.",
                    "Hint: One of these talents will double your earth damage. :P",
                },
            },
            [183] = {
                question = "Can I get a weapon?",
                bigSV = {[trackerSV] = 48},
                bigSVF = {[trackerSV] = 50},
                moreItemsF = {{itemID = 7857, count = 1}},
                rewardItems = {{itemID = 7857}},
                answer = {
                    "Yep, here you go.",
                    "This sword deals 100 EARTH damage on every hit.",
                    "However the orb you must destroy absorbs 99 EARTH damage each hit!!!",
                    "You need to find a way to deal more damage!",
                },
            },
            [184] = {
                question = "I think I spent my points on wrong talent, can I get more points?",
                allSV = {[SV.skillpoints] = 0, [trackerSV] = 49},
                answer = {
                    "I wont give you any new points, but you can get the points back by pressing the 'reset' button in your 'Skilltree'.",
                    "The reset button will reset the points in the highlighted 'Skilltree'/'branch'.",
                },
            },
            [185] = {
                question = "I'm stuck! What do I do, where do I go!?",
                allSV = {[trackerSV] = 50},
                answer = {
                    "Remind yourself of what you have learned so far.",
                    "You can USE objects, and you can LOOK at objects.",
                    "By objects, I mean even the floor you are walking on!",
                    "Also, when a tile looks like it may be an edge, you can try climbing up or down facing forward in the right direction!",
                },
            },
            [186] = {
                question = "Where am I now?",
                allSV = {[trackerSV] = 51},
                answer = {
                    "This is the final tutorial room.",
                    "Beyond this rail you have to fight against 'Dummy' - the tutorial boss.",
                    "As you can see, on the left side of the room are 4 statues. USE one of the statues to select the class it represents.",
                    "You can switch classes by using any of the other statues, but only in this tutorial room.",
                    "Once you complete the tutorial, you will NOT be able to change your class again, so choose wisely!",
                },
            },
            [187] = {
                question = "What can a druid do?",
                allSV = {[trackerSV] = 51},
                answer = {
                    "The first spell a Druid has is !heal.",
                    "Its the same !heal spell you had in this tutorial, it simply gives you some health back.",
                    "The second spell you get, upon completing this tutorial, is the !heat spell.",
                    "The !heat spell inflicts fire damage on your target!",
                    "Druids primarily use magical weapons and fight at a distance.",
                },
            },
            [188] = {
                question = "What can a knight do?",
                allSV = {[trackerSV] = 51},
                answer = {
                    "The first spell a Knight has is !armorup.",
                    "It's the same !armorup spell you had in this tutorial, it gives a temporary armor bonus and movement speed on breakdown.",
                    "The second spell you get, upon completing  the tutorial, is the !strike spell.",
                    "The !strike spell deals physical damage to nearby enemies.",
                    "Knights mainly use melee weapons and fight in close combat.",
                },
            },
            [189] = {
                question = "What can a mage do?",
                allSV = {[trackerSV] = 51},
                answer = {
                    "The first spell a Mage has is the !spark spell.",
                    "It's the same !spark spell you had in this tutorial, it deals energy damage to the enemy in front of you.",
                    "The second spell you get as a mage, upon completing this tutorial, is the !barrier spell.",
                    "It gives extra HP on top of your orginal hitpoints, the effect lasts forever or until you take more damage than the barrier can withstand.",
                    "Mages primarily use magical weapons and strike from a distance.",
                },
            },
            [190] = {
                question = "What can a hunter do?",
                allSV = {[trackerSV] = 51},
                answer = {
                    "The first spell a Hunter has is the !trap spell.",
                    "It's the same !trap spell you used in this tutorial, it deals physical damage to enemies who step on it and slows them down.",
                    "The second spell you get as a hunter, upon completing the tutorial, is the !poison spell.",
                    "The !poison spell imbues your projectiles with poison damage, dealing enemies extra poison damage upon impact.",
                    "Hunters mainly use ranged weapons and fight from a distance.",
                },
            },
            [191] = {
                question = "Any last tips?",
                allSV = {[trackerSV] = 52},
                answer = {"Whi World is a difficult game, but if you stay patient and learn to play properly, it's sure to be an amazing experience!"},
            },
        },
    }
}
centralSystem_registerTable(npcConf_tutorialNpc)

function tonka_minigameButton(player, npcName) return player:teleportTo({x = 667, y = 600, z = 8}, true) end
