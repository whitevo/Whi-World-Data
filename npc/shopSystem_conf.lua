--[[ npc_conf.allShopT guide
    [_] = {                                 
        npcName = {STR},                    name of NPC's who has this shopT
        allSV = {[SV] = INT},
        bigSV = {[SV] = INT},
        bigSVF = {[SV] = INT},
        anySV = {[SV] = INT},
        anySVF = {[SV] = INT},

        items = {{
            itemID = INT, 
            itemAID = INT,
            fluidType = INT,
            itemText = STR,
            oneAtTheTime = false            if true then skips the amount choosing MW and sells 1
            cost = INT                      how much 1 item costs
            sell = INT                      how much for npc costs it for
            maxStock = INT                  how many of these items npc can cost
            baseStock = INT or 0            how many items npc will generate if its under baseStock
            genStockSecTime = INT or 10     in how many seconds the stock values goes towards the baseStock
            genStockAmount = INT or 1       how many items will generated/removed from stock each interval
        }},
    }
]]