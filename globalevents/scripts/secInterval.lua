local seconds_passed = 0

function onThink()
    seconds_passed = seconds_passed + 1
    if seconds_passed == 61 then seconds_passed = 1 end

    challengeEvent_spawnAllChallengeItems(seconds_passed)
    challengeEvent_allTowersShoot(seconds_passed)
    global_mapEffects(seconds_passed)
    return true
end
