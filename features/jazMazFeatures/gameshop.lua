jazMazShop_conf = {
    items = {
        {itemID = 2173, cost = 10000},
        {itemID = 2193, cost = 10000},
    },
}

feature_jazMazShop = {
    npcShop = {
        npcName = "gameShop",
        items = jazMazShop_conf.items,
    }
}
centralSystem_registerTable(feature_jazMazShop)