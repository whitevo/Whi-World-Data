-- io.popen has do be done differently for linux and windows

local function dofile_folder(path, folderNames)
    if testServer() then
        if folderNames then
            for _, folderName in ipairs(folderNames) do
                local path = path.."/"..folderName
                dofile_folder(path)
            end
        end
        
        for fileName in io.popen([[dir "./data/]]..path..[[" /b /aa]]):lines() do dofile("data/"..path.."/"..fileName) end
    else
        if folderNames then
            for _, folderName in ipairs(folderNames) do
                local path = path.."/"..folderName
                for fileName in io.popen([[ls ./data/]]..path):lines() do dofile("data/"..path.."/"..fileName) end
            end

            for fileName in io.popen([[ls ./data/]]..path):lines() do
                if not isInArray(folderNames, fileName) then dofile("data/"..path.."/"..fileName) end
            end
        else
            for fileName in io.popen([[ls ./data/]]..path):lines() do dofile("data/"..path.."/"..fileName) end
        end
    end
end

dofile_folder("global_functions")
dofile('data/register_storageValues.lua')
dofile('data/register_itemID.lua')
dofile('data/register_itemAID.lua')
print("global loaded..")

dofile('data/centralSystem.lua')
dofile('data/items/itemSystem_conf.lua')
dofile_folder("game_systems")
dofile('data/monster/monsters_conf.lua')
dofile('data/npc/npcSystem_conf.lua')

local spellFolders = {"hunter", "druid", "knight", "mage", "talents", "jazmaz_monsterSpells"}
for _, folderName in ipairs(spellFolders) do dofile_folder("spells/"..folderName) end

featureFolders = {"other", "special_items", "jazMazFeatures", "containers", "professions", "upgrades", "environment", "machines"}
dofile_folder("features", featureFolders)
print("features loaded..")
dofile_folder("npc/npcs")
dofile_folder("areas", {"regions"})
dofile_folder("missions")
dofile_folder("Quests")
dofile_folder("games")

dofile_folder("monster/monsters", {"bosses"})
print("-- LOADING COMPLETE --")
dofile('data/creaturescripts/scripts/HISTORY.lua')