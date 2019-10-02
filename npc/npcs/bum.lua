npcConf_bum = {
    name = "bum",
    npcPos = {x = 575, y = 668, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    startUpFunc = "bum_loadGemHints",
    npcShop = {
        {
            npcName = "bum",
            items = {
                {itemID = 2050, cost = 1, oneAtTheTime = true},
                {itemID = 11214, sell = 1, maxStock = 10},
                {itemID = 2389, cost = 8, baseStock = 10, genStockSecTime = 2*60},
                {itemID = toolsConf.hammers[1], itemAID = AID.other.tool, cost = 40, itemText = "charges(5)", oneAtTheTime = true},
                {itemID = toolsConf.shovels[1], itemAID = AID.other.tool, cost = 50, itemText = "charges(5)", oneAtTheTime = true},
            },
        },
        {
            npcName = "bum",
            allSV = {[SV.archanosKill] = 1},
            items = {itemID = toolsConf.saws[1], itemAID = AID.other.tool, cost = 40, itemText = "charges(5)", oneAtTheTime = true},
        },
        {
            npcName = "bum",
            allSV = {[SV.bigDaddyKill] = 1},
            items = {itemID = toolsConf.pickaxes[1], itemAID = AID.other.tool, cost = 40, itemText = "charges(5)", oneAtTheTime = true},
        },
    },
    npcChat = {
        ["bum"] = {
            {
                question = "Who are you?",
                allSV = {[SV.smith1] = -1},
                setSV = {[SV.smith1] = 1},
                answer = "I'm Bum, the smith.",
            },
            {
                question = "What do you do?",
                allSV = {[SV.smith1] = 1, [SV.smith2] = -1},
                setSV = {[SV.smith2] = 1},
                answer = "I craft or forge weapons and tools.",
            },
            {
                question = "Can I get any weapons or tools?",
                allSV = {[SV.smith2] = 1, [SV.smith3] = -1},
                setSV = {[SV.smith3] = 1},
                answer = "Well, I could show you what I offer, if you help me first.",
            },
            {
                question = "What is this place?",
                allSV = {[SV.smith3] = 1, [SV.smith5] = -1},
                setSV = {[SV.smith5] = 1},
                answer = "This is the Forgotten Village.",
            },
            {
                question = "What happened here?",
                allSV = {[SV.cook5] = 1, [SV.cook6] = -1},
                setSV = {[SV.cook6] = 1},
                answer = "My master Dide created an undead army when he went mad, and destroyed the capital, Naaru.",
            },
            -- OTHER --
            {
                question = "You like my gem bag?",
                moreItems = {{itemID = gemBagConf.itemID, count = 1}},
                answer = {
                    "Yep, quite cool.",
                    "If you want more information about a gem, take it out of your gem bag and show it to me.",
                },
            },
            {
                question = "What do you know about gems?",
                allSV = {[SV.BanditMountain] = 1, [SV.smith9] = -1},
                setSV = {[SV.smith9] = 1},
                answer = {
                    "As it happens, I'm quite the expert in gemology, if I do say so myself.",
                    "Show me a gem if you want to know more about it.",
                },
            },
            {
                question = "How do I build a bridge?",
                allSV = {[SV.bridgeHints] = 1, [SV.hehemiQuest] = -1},
                answer = {
                    "You need logs and nails.",
                    "You can get logs by cutting down trees and nails are crafted by using a hammer on steel.",
                    "When you have the materials, go to the bridge and use the empty tile where you can build.",
                    "And voila! The first tile has been created!",
                    "If you complete constructions, they last longer.",
                    "You can get steel bars by hammering down metal objects like screws or metal statues on an anvil.",
                    "The only anvil I know of is in Big Daddy's room."
                },
            },
            {
                msg = "Btw, I can tell you a secret how to auto loot gold for 100 gold coins :P",
                anySV = {[SV.autoLoot_howTo] = {-1, 0}},
                setSV = {[SV.autoLoot_howTo] = 0},
                level = 5,
                secTime = 60*60*4,
            },
            {
                question = "Teach me how to auto loot gold coins for 100 gold!",
                allSV = {[SV.autoLoot_howTo] = 0},
                setSV = {[SV.autoLoot_howTo] = 1},
                moreItems = {itemID = ITEMID.other.coin, count = 100},
                answer = {"USE gold coin when its the only 1 in the stack"},
            },
        }
    },
}
centralSystem_registerTable(npcConf_bum)

function bum_loadGemHints()
    local allNpcT = {bum = {}}
    local loopID = 0

    for gemID, gemT in pairs(gems) do
        local npcT = allNpcT.bum
        loopID = loopID + 1
        npcT[loopID] = {
            question = "What you can tell about "..gemT.eleType.." gem?",
            answer = gemT.npcHint,
            moreItems = {{itemID = gemID}},
        }
    end
    central_register_npcChat(allNpcT)
end