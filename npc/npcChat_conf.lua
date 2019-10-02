--[[ npc chat guide
    [STR] = {                           npcName
        [INT] = {                       chatID (automatically set by central system)
            toDelete = false            after message is said its deleted
            msg = {STR}                 npc says this message as soon as you talk to them
            question = STR              the question/message you say to npc
            action = STR				action description on modal window
            doAction = {STR}			action message on local chat
            answer = {STR}              response message to question
            actionAnswer = {STR}        response message to action
            
            secTime = INT or 30			when same question can be asked or msg is said again
            anySV = {[K]={V}}           if any of these storage values match, player can ask the question
            anySVF = {[K]={V}}          if any of these storage values match, player can't ask the question
            allSV = {[K]=V}             if all of these storage values match, player can ask the question
            bigSV = {[K]=V}             if all of these storage values are equal or bigger, player can ask the question
            bigSVF = {[K]=V}            if any of these storage values are equal or bigger, player can't ask the question
            level = INT                 minimum level to ask this question
            checkFunc = STR             function must return true then player can ask the question | STR(player)
            moreItems = {{              player:getItemCount(itemID, itemAID, fluidType, dontCheckPlayer) >= count then it passes.
                itemID = {INT}          if itemID is table then needs to match only of the item itemID's with count
                itemAID = INT
                count = INT or 1
                fluidType = INT
                dontCheckPlayer = BOOL
            }}
            moreItemsF = {{             player:getItemCount(itemID, itemAID, fluidType, dontCheckPlayer) >= count then it fails.
                itemID = {INT}          if itemID is table then needs to match only of the item itemID's with count
                itemAID = INT
                count = INT or 1
                fluidType = INT
                dontCheckPlayer = BOOL
            }}
            
            removeItems = {{            removes all these items
                itemID = {INT}			if itemID is table then removes only 1 itemID from list
                itemAID = INT
                count = INT or 1
                fluidType = INT
                dontCheckPlayer = BOOL
            }}
            removeOnly1 = true          removes only of the items in removeItems table
            
            rewardItems = {{            
                itemID = {INT}          if itemID is table then choose 1 random ID from table.
                count = INT or 1
                itemAID = INT
                fluidType = INT
            }}
            setSV = {[K]=V}             setSV(player, K, V)
            addSV = {[K]=V}             addSV(player, K, V) | if sv value < 0 then sv value = 0
            teleport = {POS}            teleports player to this position.
            addRep = {[STR] = INT}      addRep(player, INT, STR)
            rewardExp = INT             player:addExpPercent(INT)
            addProfessionExp = {
                {[STR] = INT}           professions_addExp(player, INT, STR) | STR = professionStr | INT = amount
            }
            closeWindow = BOOL          true = closes window after chat
            funcSTR = STR               activates custom function STR(player, npc)
            
            -- automatic
            chatID = INT                unique value for each npc chatT
        }
    }
]]

--[[ nnpcConv_conf guide
    chatGroups = {                  conversations between different npc's
        [_] = {
            participants = {STR}    npc names who have the convos
            chatCD = INT or 180     seconds between npc convos when they meet
            convos = {              
                [INT] = {           convoID
                    STR             What npc says | chat is made back and forth
                }
            }
            AUTOMATIC
            nextChatTime = INT      os.time() when this group can talk again
            talkedConvoIDT = {}     list of convoID's which participants have said already
        }
    }
]]

npcConv_conf = {
    chatGroups = {
        ["town"] = {
            participants = {"alice", "niine", "bum", "dundee", "eather"},
            convos = {
                [2] = {
                    "'Robinggwp' is a true explorer!",
                    "why you say that?",
                    "Well he has explored entire Continent after all :D",
                    "Woah, that must took some time :o",
                },
                [3] = {
                    "Who was the strongest player in Patch 0.1.2?",
                    "'MissCeline'",
                    "But in Patch 0.1.3?",
                    "'Healer' :P",
                },
                [4] = {
                    "Ice has been training to be hunter.",
                    "oh, I wonder will he be stick around to be the best :D",
                    "Sure hope so, Dundee is only hunter we have right now",
                },
                [5] = {
                    "hi hi hi",
                    "mh?",
                    "The mage 'DeadFlow' had unlimited barrier xD",
                    ":o",
                },
                [6] = {
                    "Do you need some luck?",
                    "Little luck always helpful, but what you mean xD?",
                    "'Valerq' has pleased some RNG gods, his luck is off the roof! I'm sure he has plenty to spare",
                },
                [7] = {
                    "If you say 'free itens plx' to 'Cezar', you might get some :D",
                    "Oh, ok although I don't need items xD",
                },
                [8] = {
                    "Finally there is knight who can solo Big Daddy",
                    "You 'cerial'! Who?",
                    "'Dnekker'",
                },
                [9] = {
                    "'PEMUS' might have some alcohol issues.",
                    "Hum, why you claim that?",
                    "He stole bottle of rum from bar.",
                },
                [10] = {
                    "Woo lets party! 'Hager' completed Patch 0.1.5",
                    "No time for party, we need to stay alert just incase undeads come",
                    "but..but",
                    "No buts, situation is critical.",
                },
                [12] = {
                    "Everyone beware!",
                    "what's going on?",
                    "There is grammar natzi in town!",
                    "You mean 'Antapa'? His alright, he helps us out at least.",
                },
            }
        }
    }
}