monsterSpells["big water element"] = {
    "big water element summon",
    "heal: cd=6000 p=4",
    "damage: cd=2000 d=30-50 r=4 t=ICE fe=37",
}

customSpells["big water element summon"] = {
    cooldown = 10000,
    firstCastCD = -5000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        onTargets = true,
        summons = {
			["water element"] = {amount = 2},
		},
		maxSummons = 4,
    },
    say = {
        onTargets = true,
        msg = "*glug glug*",
        msgType = ORANGE,
    },
}

function bigWaterElement_onDeath(creature, corpse)
local creaturePos = creature:getPosition()
    for x=1, 4 do createMonster("water element", creaturePos) end
end