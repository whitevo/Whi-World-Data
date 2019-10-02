monsterSpells["big slime"] = {
    "big slime summon all",
    "big slime summon",
    "big slime teleport",
    "damage: cd=2000 d=10-30 r=5 t=EARTH fe=30",
}

local tpArea = {
    {n, 1, 1, 1, 1, 1, n},
    {1, 1, n, n, n, 1, 1},
    {1, n, n, n, n, n, 1},
    {1, n, n, 0, n, n, 1},
    {1, n, n, n, n, n, 1},
    {1, 1, n, n, n, 1, 1},
    {n, 1, 1, 1, 1, 1, n},
}

local teleportEffects = {
    {n, n,     1, n, n},
    {n, 1,     2, 1, n},
    {1, 2, {0,3}, 2, 1},
    {n, 1,     2, 1, n},
    {n, n,     1, n, n},
}

customSpells["big slime teleport"] = {
    cooldown = 8000,
    changeTarget = true,
    targetConfig = {"caster"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "caster",
            areaConfig = {area = teleportEffects},
        },
    },
    magicEffect = {
        effect = {12,19},
        effectInterval = 200,
		waveInterval = 200,
    },
    flyingEffect = {effect = 39},
    teleport = {
        position = {
            startPosT = {startPoint = "caster"},
            endPosT = {
                endPoint = "caster",
                areaConfig = {area = tpArea},
                checkPath = "solid",
                blockObjects = "solid",
                randomPos = 1,
            },
        },
        onTargets = true,
        delay = 700,
        effectOnCast = 25,
        effectOnPos = 23,
        unFocus = true,
    }
}

local min3 = 3*60*1000
local min2_sec45 = 2*60*1000 + 45*1000
customSpells["big slime summon all"] = {
    cooldown = min3,
    firstCastCD = -min2_sec45,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        onTargets = true,
        summons = {
			["yellow slime"] = {amount = 2},
			["grey slime"] = {amount = 2},
			["green slime"] = {amount = 1},
		},
        summonAmount = 5,
		maxSummons = 10,
    },
    say = {
        onTargets = true,
        msg = "*blub blub blub*",
        msgType = ORANGE,
    },
}

customSpells["big slime summon"] = {
    cooldown = 15000,
    cooldown = 30000,
    targetConfig = {"caster"},
    position = {startPosT = {startPoint = "caster"}},
    summon = {
        onTargets = true,
        summons = {
			["green slime"] = {amount = 1},
			["yellow slime"] = {amount = 1},
			["grey slime"] = {amount = 1},
		},
        summonAmount = 3,
		maxSummons = 10,
    },
    say = {
        onTargets = true,
        msg = "*blub*",
        msgType = ORANGE,
    },
}