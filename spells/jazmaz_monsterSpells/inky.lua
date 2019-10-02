monsterSpells["inky"] = {
    "inky bomb",
    "heal: cd=6000 p=4",
    "damage: cd=2000 d=20-30 t=DEATH e=3",
}

customSpells["inky bomb"] = {
    cooldown = 6000,
    targetConfig = {"enemy"},
    position = {
        startPosT = {startPoint = "caster"},
        endPosT = {
            endPoint = "enemy",
            checkPath = "solid",
        },
    },
    changeEnvironment = {
        items = {12595},
        removeItems = {12595},
		itemAID = AID.jazmaz.monsters.inky_bombRune,
        
        changeEnvironment = {
            delay = 4000,
            removeItems = {12595},
            recastPerPos = true,
            passRecastPos = true,
            
            damage = {
                position = {
                    startPosT = {startPoint = "endPos"},
                    endPosT = {
                        endPoint = "endPos",
                        areaConfig = {area = areas["outwards_explosion_3x3_1"]},
                    },
                },
                hook = true,
                interval = 150,
                minDam = 50,
                maxDam = 50,
                damType = DEATH,
                effect = 3,
                effectOnHit = 18,
            }
        }
    },
    flyingEffect = {effect = 11},
    magicEffect = {
        effect = {39,17},
        effectInterval = 400,
    },
}

function inky_bombRune_onUse(player, item)
local itemPos = item:getPosition()
local area = getAreaAround(itemPos)
    
    if tableCount(findFromPos(12568, area)) > 0 then return player:sendTextMessage(GREEN, "Cant remove this rune when protection rune is nearby") end
    doSendMagicEffect(itemPos, {1, 14}, 200)
    player:addMana(-10)
    return item:remove()
end