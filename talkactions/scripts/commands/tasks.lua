function onSay(player, words, param)
    return sayTasksInConsole(player)
end

function sayTasksInConsole(player)
    for monsterName, t in pairs(monsters) do
        local taskT = t.task
        if taskT then
            if player:getStorageValue(taskT.storageID) >= taskT.killsRequired then
                player:sendTextMessage(ORANGE, "you completed "  .. monsterName .." task")
            elseif player:getStorageValue(taskT.storageID) >= 0 then
                player:sendTextMessage(ORANGE, "For "..monsterName.." task: You need to kill "..taskT.killsRequired-player:getStorageValue(taskT.storageID).." more")
            end
        end
    end
end