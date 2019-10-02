local AIDT = AID.areas.rootedCatacombs

rootedCatacombsArea = {
    area = {
        regions = {rootedCatacombsDesert, rootedCatacombsSkeletonWarriorsRoom, rootedCatacombsGhostRoom}
    },
    discover = {
        [AIDT.discoverTile] = {
            rewardSP = 1,
            SV = SV.rootedCatacombs,
            name = "Rooted Catacombs",
        },
    },
    
}
centralSystem_registerTable(rootedCatacombsArea)