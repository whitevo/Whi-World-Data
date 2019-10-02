monsterSpells["green slime"] = {
    "heal: cd=2000 p=10",
    "damage: cd=1500 d=10-30 r=4 t=EARTH",
}

function greenSlimeAI(creature)
local friendList = creature:getFriends(5)
    
    for _, creatureID in pairs(friendList) do
        local friend = Creature(creatureID)
        if friend:getRealName() == "big slime" then return walkTo(creature, friend:getPosition(), {"creature", "solid"}, 400, true) end
    end
end