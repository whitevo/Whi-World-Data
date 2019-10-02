monsterSpells["shark"] = {
    "shark attack",
    "damage: cd=2000, d=20-30, r=5, fe=5",
}

customSpells["shark attack"] = {
    cooldown = 3000,
    targetConfig = {["cTarget"] = {range = 1}},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "cTarget",
            range = 1,
        },
    },
    damage = {
        onTargets = true,
        minDam = 10,
        damType = PHYSICAL,
		recastPerPos = true, 
        
        conditions = {
            onTargets = true,
            hook = true,
            conditionT = {
                ["physical"] = {
                    paramT = {dam = 4},
                    duration = 4000,
                    maxStack = 20,
                }
            },
        }
    }
}