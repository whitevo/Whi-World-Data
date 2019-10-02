function teleportBelow(player, item)
    local itemPos = item:getPosition()
    local newPos = {x = itemPos.x, y = itemPos.y, z = itemPos.z + 1}
    return teleport(player, newPos)
end