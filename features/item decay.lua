--[[ config guide for decayT
    [INT] = {                 order of item decay
        itemID = INT        which itemID to find
        toItemID = INT      into which item it turns
        toItemAID = INT     if the item also has AID
        duration = INT      in seconds
        offset = INT        + - INT amount of secodnds for duration
    },
]]
fireFieldDecayT = {
    [1] = {
        itemID = 1492,
        toItemID = 1493,
        duration = 60,
        offset = 10,
    },
    [2] = {
        itemID = 1493,
        toItemID = 1494,
        duration = 80,
        offset = 10,
    },
    [3] = {
        itemID = 1494,
        duration = 100,
        offset = 10,
    },
}

function decay(pos, decayT, start) -- decay Config in compat
    for orderID, t in ipairs(decayT) do
        local item = Tile(pos):getItemById(t.itemID)
        
        if item then
            local duration = t.duration*1000
            
            if t.offset then duration = duration + math.random(-t.offset, t.offset)*1000 end
            if start then return addEvent(decay, duration, pos, decayT) end
            item:remove()
            if not t.toItemID then return end
            createItem(t.toItemID, pos, 1, t.toItemAID)
            addEvent(decay, duration, pos, decayT)
            return true
        end
    end
end

function getDecayT(item)
local itemID = item:getId()

    for _, decayT in ipairs(fireFieldDecayT) do
        if decayT.itemID == itemID then return decayT end
    end
end