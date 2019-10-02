monsterSpells["manta ray"] = {
    "manta ray glide",
    "damage: cd=2000, d=20-30, r=5, t=ICE, fe=5",
}

customSpells["manta ray glide"] = {
    cooldown = 8000,
    firstCastCD = -4000,
    changeTarget = true,
    targetConfig = {
		["enemy"] = {
			findWay = true,
			obstacles = {"solid"},
		}
	},
    position = {
        startPosT = {
            startPoint = "caster",
        },
        endPosT = {
            endPoint = "enemy",
            pointPosFunc = "pointPosFunc_far",
            getPath = {obstacles = {"solid"}},
        }
    },
    changeEnvironment = {
        items = {2016},
		itemAID = AID.jazmaz.mantaRay_splash,
        removeTime = 6000,
		sequenceInterval = 200,
    },
    teleport = {
        targetConfig = {"caster"},
        onTargets = true,
        effectOnCast = 43,
		walkSpeed = 400,
		teleportInterval = 200,
    }
}

function mantaRay_splash(creature, item)
    if creature:isMonster() then
        bindCondition(creature, "monsterHaste", 4000, {speed = 100})
    elseif creature:isPlayer() then
        bindCondition(creature, "monsterSlow", 4000, {speed = -100})
    end
end