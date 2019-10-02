function onSay(player, words, param)
    local testNumber = tonumber(param) or 0
    dofile("data/testScripts.lua")
    testEnvironment(player, testNumber, luaItemUserData, luaCreatureUserData)
end