--[[ config guide
    [areaName] = {
        name = STR or areaName
        amount = INT                    How many monster can spawn in this area
        spawnTime = INT                 time in milliseconds
        
        monsterT = {                    monsters who will be spawned to area
            [monsterName] = {
                amount = INT or "unlimited" only that amount of monster can be in this area
                hpPercet = INT or 10        how many percent the monster HP can vary (+,-)
                spawnLockDuration = INT     time in seconds how many seconds later monster can be spawned after killed.
                
                --AUTOMATIC
                spawnLockTime = INT     os.time() when monster can be spawned.
                midT = {}               holds list of monsterID's with that name on this area.
            }
        }
        areaCorners = {{                list of squares used to create entire area
            upCorner = POS
            downCorner = POS
        }}
        spawnPoints = {POS}             list of positions where monsters will be spawned
        ignoreAreas = {{                list of squares where monsters will not be spawned
            upCorner = POS,
            downCorner = POS,
        }}

        --AUTOMATIC
        spawnPosByMid = {[mid] = POS}   position where monster will spawn if the specific monster dies (comes with spawnPoints)
        areaPosT = {}                   made with areaCorners
    }
]]
--[[ missing features
    1. amount limit automatically increases by the amount of players in server and/or how fast the spawns are cleared from area.
]]
spawns = {}

local monsterSpawnSystem = {
    startUpFunc = "monsterSpawns_startUp",
}

centralSystem_registerTable(monsterSpawnSystem)
print("monsterSpawnSystem loaded..")