function getTimeText(seconds, isMilliseconds)
    local milliseconds = 0
    if isMilliseconds then
        milliseconds = seconds%1000
        seconds = seconds/1000
    end

    local seconds = math.floor(seconds)
    if seconds < 1 then return (0).." sec" end
    local str = ""

    if seconds > 86400 then
        local days = math.floor(seconds/86400)
        str = plural("day", days)
        seconds = seconds%86400
    end
    local hour = math.floor(seconds/3600)
    seconds = seconds%3600
    local min = math.floor(seconds/60)
    local sec = seconds%60
    
    if hour >= 1 then str = str.." "..plural("hour", hour) end
    if min >= 1 then str = str.." "..plural("minute", min) end
    str = str.." "..sec.." sec"
    if milliseconds > 0 then str = str.." "..milliseconds.." millisec" end
    return str
end

function getMonthString(month)
    if month == 1 then return "January" end
    if month == 2 then return "Februar" end
    if month == 3 then return "March" end
    if month == 4 then return "April" end
    if month == 5 then return "May" end
    if month == 6 then return "June" end
    if month == 7 then return "July" end
    if month == 8 then return "August" end
    if month == 9 then return "September" end
    if month == 10 then return "October" end
    if month == 11 then return "November" end
    if month == 12 then return "December" end
end

function getCurrentMonthNumber(modifier)
	if not testServer() then return 0, print("ERROR - getCurrentDay() requires update for differnet lua version") end
    local date = os.date()
    local month = date:getINT()
    if not modifier then return month end
    local totalValue = month + modifier

    if totalValue > 12 then
        month = totalValue - 12
    elseif totalValue < 0 then
        month = 12 + totalValue
    else
        month = totalValue
    end
    return month
end

function getCurrentMonth(modifier) return getMonthString(getCurrentMonthNumber(modifier)) end

function getCurrentDay(modifier)
	if not testServer() then return 0, print("ERROR - getCurrentDay() requires update for differnet lua version") end
    local date = os.date()
    local split = date:split("/")
    local day = tonumber(split[2])

    if modifier then
        local month = tonumber(split[1])
        local year = tonumber((20)..split[3]:getINT())
        local maxDays = get_days_in_month(month, year)
        local totalValue = day + modifier
        
        if totalValue > maxDays then
            day = totalValue - maxDays
        elseif totalValue < 1 then
            month = month-1
            if month == 0 then month = 12 end
            maxDays = get_days_in_month(month, year)
            day = maxDays + totalValue
        else
            day = totalValue
        end
    end
    return day
end

function getCurrentHour(modifier)
    local timeStamp = os.date():match("% %d+%:%d+%:%d+")
    local split = timeStamp:split(":")
    local hour = tonumber(split[1])+1

    if modifier then return hour end
    local totalValue = hour + modifier

    if totalValue > 23 then
        hour = totalValue - 24
    elseif totalValue < 0 then
        hour = 24 + totalValue
    else
        hour = totalValue
    end
    return hour
end

function getCurrentTime() return os.date():match("%d+%:%d+") end

function turnToHour(seconds)
    local minutes = math.floor(seconds/60)
    if minutes < 60 then return "00:"..minutes end
    local minutesLeft = minutes%60
    local hours = math.floor(minutes/60)

    return hours..":"..minutesLeft
end

function getDayString(day)
    if day == 1 or day == 21 or day == 31 then return day.."st" end
    if day == 2 or day == 22 then return day.."nd" end
    if day == 3 or day == 23 then return day.."rd" end
    return day.."th"
end

function getWeekDay()
	if not testServer() then return 0, print("ERROR - getCurrentDay() requires update for differnet lua version") end
    return os.date("%A"):lower()
end

function get_days_in_month(month, year)
    local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }   
    local d = days_in_month[month]

    if month ~= 2 then return d end
    if math.mod(year, 4) ~= 0 then return d end
    if math.mod(year, 100) ~= 0 then return 29 end
    if math.mod(year, 400) == 0 then return 29 end
    return d
end