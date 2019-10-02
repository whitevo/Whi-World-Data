BLUE = MESSAGE_STATUS_CONSOLE_BLUE

function onSay(player)
    local killsT = {}--player:getKills()
    local killed_today = 0
    local killed_week = 0
    local killed_month = 0
    local dayInSeconds = 86400
    local currentTime = os.time()

    for _, killT in ipairs(killsT) do
        if killT.time > currentTime - dayInSeconds then
            killed_today = killed_today + 1
        elseif killT.time > currentTime - dayInSeconds*7 then
            killed_week = killed_week + 1
        elseif killT.time > currentTime - dayInSeconds*30 then
            killed_month = killed_month + 1
        end
    end

    player:sendTextMessage(BLUE, "You currently have "..killed_today.." frags today "..killed_week.." frags this week "..killed_month.." frags this month.")

    local maxRedKills_perDay = configManager.getNumber(configKeys.DAY_KILLS_TO_RED)
    local maxRedKills_perWeek = configManager.getNumber(configKeys.WEEK_KILLS_TO_RED)
    local maxRedKills_perMonth = configManager.getNumber(configKeys.MONTH_KILLS_TO_RED)
    player:sendTextMessage(BLUE, "Frags for red skull per day "..maxRedKills_perDay..", Frags for red skull per week "..maxRedKills_perWeek..", Frags for red skull per month "..maxRedKills_perMonth..".")
    
    local maxBlackKills_perDay = configManager.getNumber(configKeys.DAY_KILLS_TO_BLACK)
    local maxBlackKills_perWeek = configManager.getNumber(configKeys.WEEK_KILLS_TO_BLACK)
    local maxBlackKills_perMonth = configManager.getNumber(configKeys.MONTH_KILLS_TO_BLACK)
    player:sendTextMessage(BLUE, "Frags for black skull per day "..maxBlackKills_perDay..", Frags for black skull per week "..maxBlackKills_perWeek..", Frags for black skull per month "..maxBlackKills_perMonth..".")

    local skullDuration = player:getSkullTime()
    if skullDuration > 0 then
        local skullID = player:getSkull()
        local skullName = skullID == SKULL_RED and "red skull" or skullID == SKULL_BLACK and "black skull"
        if not skullName then return end

        player:sendTextMessage(BLUE, "Your "..skullName.." will dissapear in "..getTimeText(skullDuration, true))
    end
end