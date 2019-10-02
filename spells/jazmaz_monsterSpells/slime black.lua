monsterSpells["black slime"] = {
    "black slime heal",
    "damage: cd=2500 d=30 r=3 t=DEATH fe=11 e=1",
}

customSpells["black slime heal"] = {
    cooldown = 2000,
    targetConfig = {"friend"},
    position = {
        startPosT = {startPoint = "caster"},
    },
    customFeature = {
        func = "blackSlime_heal",
        healAmount = 100,
        distanceEffect = 32,
        effect = {4, 18},
    }
}

function blackSlime_heal(cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
local caster = Creature(cid)
    if not caster then return end
local friendList = caster:getFriends(5)
local tempTargets = {}
local loopID = 0

    for _, creatureID in pairs(friendList) do
        local friend = Creature(creatureID)
        if friend:getRealName() == "sea abomination" then
            doSendDistanceEffect(caster:getPosition(), friend:getPosition(), featureT.distanceEffect)
            return heal(friend, featureT.healAmount, featureT.effect)
        end
        loopID = loopID + 1
        tempTargets[loopID] = creatureID
    end
local randomTargetID = randomValueFromTable(tempTargets)
local target = Creature(randomTargetID)

    if not target then return end
    doSendDistanceEffect(caster:getPosition(), target:getPosition(), featureT.distanceEffect)
    heal(randomTargetID, featureT.healAmount, featureT.effect)
end