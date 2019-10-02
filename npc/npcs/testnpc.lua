--[[
npcConf_testnpc = {
    name = "testnpc",
    npcPos = {x = 572, y = 664, z = 7},
    npcArea = {upCorner = {x = 560, y = 656, z = 7}, downCorner = {x = 588, y = 672, z = 7}},
    npcShop = {
        [24] = {
            npcName = "testnpc",
            bigSV = {[SV.priestRepL] = 1},
            items = {itemID = 13828, cost = 20},
        },
    },
    npcChat = {
        ["testnpc"] = {
            [192] = {
                question = "test 1",
                moreItems = {
                    itemID = {ITEMID.other.coin, 2152},
                },
                moreItemsF = {
                    itemID = {ITEMID.other.coin, 2152},
                    count = 3,
                },
                removeItems = {
                    {itemID = ITEMID.other.coin}, -- one of them
                    {itemID = 2152}, -- one of them
                },
                removeOnly1 = true,
                rewardItems = {
                    itemID = {2160, 2544} ,-- one of them
                },
            },
        }
    }
}
centralSystem_registerTable(npcConf_testnpc)
]]