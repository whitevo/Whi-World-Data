local minutes_passed = 0

function onThink()
    minutes_passed = minutes_passed + 1
    if minutes_passed == 61 then minutes_passed = 1 end

    itemRespawns_spawnItems()
    skeletonWarriorRoom_spawn(minutes_passed)
    global_playerSave(minutes_passed)
    return true
end
