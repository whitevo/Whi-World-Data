local AIDT = AID.areas.banditMountain

banditMountainNorth = {
    area = {
        areaCorners = {
            [1] = { -- west side
                upCorner = {x = 381, y = 562, z = 6},
                downCorner = {x = 419, y = 622, z = 6},
            },
            [2] = { -- boss passage
                upCorner = {x = 429, y = 549, z = 6},
                downCorner = {x = 445, y = 579, z = 6},
            },
            [3] = { -- middle + entrance
                upCorner = {x = 419, y = 579, z = 6},
                downCorner = {x = 509, y = 631, z = 6},
            },
            [4] = { -- north-east passage
                upCorner = {x = 487, y = 536, z = 6},
                downCorner = {x = 539, y = 578, z = 6},
            },
        },
        blockObjects = {919},
    },
    discover = {
        [AIDT.discoverTile] = {
            rewardSP = 1,
            SV = SV.BanditMountain,
            name = "Bandit Mountain",
        },
    },
    homeTP = {
        pillarAID = AIDT.HC_pillar,
        chargeName = "Bandit Mountain",
        SV = SV.BM_teleportCharge,
    },
    AIDItems = {
        [AIDT.HC_gemAltar] = {
            timers = {
                text = "New gem is reformed in ",
                guidTime = 4*60*60,
                showTime = true,
            },
            rewardItems = {{itemID = {2147, 9970, 2150, 2146, 2149}}},
            ME = {
                pos = "itemPos",
                effects = {29,23,14},
                interval = 400,
            }
        },
    },
}
centralSystem_registerTable(banditMountainNorth)