--[[ modalWindows config guide | function params: player, param1, param2 | functions can be Str
    [INT] = {                       modal window ID
        name = STR                  modal window Name or function what returns name
        title = STR                 modal window title or function what returns name
        
        choices = {                 can be function what creates the table
            [INT] = STR             choiceID = option what players will see
        }    
        buttons = {                 can be function and if its returns false then buttons wont appear
            [INT] = STR             buttonID = buttonName
        }
        say = STR                   what player says when open the window
        save = STR                  modalWindow_savedDataByPid[playerID] = _G[save](...) | "choiceT" saves choiceT | "saveParams" saves param or {params}
        spamDelaySec = INT          time in seconds before this modal window can be executed again
        enterButton = INT or 100    buttonID when ENTER pressed
        escButton = INT or 101      buttonID when ESC pressed
    }
]]
modalWindow_savedDataByPid = {} -- [playerID] = value

modalWindows = {
    [MW.shop_sell] = {
        name = "shopSystem_sell_name",
        title = "choose how many items you want to sell",
        choices = {
            [1] = "sell 1 item",
            [2] = "sell 3 items",
            [3] = "sell 5 items",
            [4] = "sell 10 items",
            [5] = "sell 20 items",
            [6] = "sell 40 items",
        },
        buttons = {
            [100] = "sell",
            [101] = "back",
            [102] = "sell all",
        },
        func = "shopSystem_sellMW",
        save = "shopSystem_sell_save",
    },
    [MW.shop_buy] = {
        name = "shopSystem_buy_name",
        title = "choose how many items you want to buy",
        choices = {
            [1] = "buy 1 item",
            [2] = "buy 3 items",
            [3] = "buy 5 items",
            [4] = "buy 10 items",
            [5] = "buy 20 items",
            [6] = "buy 40 items",
        },
        buttons = {
            [100] = "buy",
            [101] = "back",
        },
        func = "shopSystem_buyMW",
        save = "shopSystem_buy_save",
    },
    [MW.shop] = {
        name = "choose item to buy or sell",
        title = "item name: price | sell value | stock",
        choices = "shopSystem_createChoices",
        buttons = {
            [100] = "buy",
            [101] = "sell",
            [102] = "close",
            [103] = "look",
        },
        func = "shopSystem_shopMW",
        save = "shopSystem_saveNpcName"
    },
    [MW.npc] = {
        name = "npcChat_getNpcName",
        title = "Choose what to ask/say",
        choices = "npcChat_createChoices",
        buttons = "npcChat_createButtons",
        save = "npcChat_saveMWParam",
        func = "npcChat_chatMW",
    },
    [MW.bossHighscores] = {
        name = "bossRoomMW_createName",
        title = "Choose category",
        spamDelaySec = 1,
        choices = {
            [1] = "Overall highscores",
            [2] = "Druid highscores",
            [3] = "Knight highscores",
            [4] = "Mage highscores",
            [5] = "Hunter highscores",
        },
        buttons = {
            [100] = "Choose",
            [101] = "Close",
        },
        say = "**checking highscore board**",
        func = "bossRoomMW_showHighscores",
    },
    [MW.npc_tonkaHerbs] = {
        name = "Tonka herb information",
        title = "Choose powder you want to show tonka",
        choices = "tonkaHerbs_createChoices",
        buttons = {
            [100] = "Show",
            [101] = "Close",
            [102] = "tonkaHerbs_herbButton",
        },
        func = "tonkaHerbsMW",
    },
    [MW.npc_tonkaHerbList] = {
        name = "Tonka herb wiki",
        title = "Choose herb name you want to know about",
        choices = "tonkaHerbs_createHerbList",
        buttons = {
            [100] = "Ask",
            [101] = "Close",
        },
        func = "tonkaHerbListMW",
    },
    [MW.reputation] = {
        name = "Reputation",
        title = "Choose npc", 
        choices = "reputation_createChoices",
        buttons = {
            [100] = "Show",
            [101] = "Close",
        },
        say = "checking reputation",
        func = "reputationMW",
    },
}
print("modalWindows loaded..")