local days_passed = 0

function onThink()
    days_passed = days_passed + 1
    if days_passed == 32 then days_passed = 1 end

    serverSave_start()
    weeklyTaskReset(days_passed)
    return true
end
