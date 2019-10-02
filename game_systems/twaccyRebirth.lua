-- 30.09.2018 - time spent 1h
-- 07.10.2018 - 6:30 - 8:40


--[[
rebirthConf = {
    storageValues = {                       list of all storage values used for this feature
        rebirthLevel = INT                  storage value which will hold rebirth level
        maxLevel = INT                      storage value which will hold player maximum level
    },  
    broadCastMsg = STR                      PLAYER_NAME = player:getName()
                                            PLAYER_LEVEL = player:getLevel()
                                            PLAYER_REBIRTH = player:getRebirthLevel()

    attributeConditionID = INT              unique ID for attribute conditions

    rebirthVocations = {                    list of vocation names who can rebirth
        [1] = STR                           vocationName - player:getVocation():getName()
    }   
    vocationRewards = {                     list of vocations who can rebirth
        [STR] = {                           vocationName - player:getVocation():getName()
            mL = INT or 0                   adds extra magic level INT*rebirth level
            dL = INT or 0                   adds extra distance level INT*rebirth level
            sL = INT or 0                   adds extra sword level INT*rebirth level
            cL = INT or 0                   adds extra club level INT*rebirth level
            aL = INT or 0                   adds extra axe level INT*rebirth level
            maxHP = INT or 0                adds extra health INT*rebirth level
            maxMP = INT or 0                adds extra mana INT*rebirth level
        }   
    },  

    promotions = {  
        [INT] = {                           rebirth level
            requirements = {    
                level = 100,    
                items = {   
                    [1] = { 
                        itemID = INT,       itemID of that item
                        itemAID = INT,      optional feature if itemID should have itemAID
                        count = INT or 0    how many items required
                    }
                },
            },
            rewards = {
                mL = INT or 0               adds extra magic level INT*rebirth level
                dL = INT or 0               adds extra distance level INT*rebirth level
                sL = INT or 0               adds extra sword level INT*rebirth level
                cL = INT or 0               adds extra club level INT*rebirth level
                aL = INT or 0               adds extra axe level INT*rebirth level
                maxHP = INT or 0            adds extra health INT*rebirth level
                maxMP = INT or 0            adds extra mana INT*rebirth level
            }
        }
    }
}
]]

rebirthConf = {
    storageValues = {
        rebirthLevel = 40000,
        maxLevel = 40001,
    },
    broadCastMsg = "PLAYER_NAME(PLAYER_LEVEL) is now on PLAYER_REBIRTH rebirth level"
    attributeConditionID = 200,
    rebirthVocations = {
        "hunter",
    },
    vocationRewards = {
        ["hunter"] = {
            mL = 1,
            dL = 3,
        }
    },
    
    promotions = {
        [1] = {
            requirements = {
                level = 5,
                items = {
                    [1] = {
                        itemID = 2148,
                        count = 3,
                    }
                },
                
            },
            rewards = {
                mL = 3,
            }
        },
        [2] = {
            requirements = {
                level = 3,
                items = {
                    [1] = {itemAID = 2091, count = 3},
                    [2] = {itemID = 2148, count = 3}
                },
            },
            rewards = {mL = 5}
        }
    }
}

function rebirth_onLook(player)
    if not player:isPlayer() then return end
    return player:sendTextMessage(GREEN, "You see " .. thing:getDescription().. " rebirth: "..rebirth_getRebirthLevel(player))
end

local attributeCondition = Condition(ATTRIBUTES, rebirthConf.attributeConditionID)
attributeCondition:setTicks(-1)

function rebirth_rebirth(player)
    if not rebirth_canRebirth(player) then return end
    
    local playerReLevel = rebirth_getRebirthLevel(player)
    local nextReLevel = playerReLevel + 1
    local rebirthT = rebirthConf.promotions[nextReLevel]
    local requirmentT = rebirthT.requirements
    local maxLevel = player:getStorageValue(rebirthConf.storageValues.maxLevel)
    local playerLevel = player:getLevel()
    local newMaxLevel = maxLevel + playerLevel
    local broadCastMsg = rebirthConf.broadCastMsg
    
    for _, itemT in pairs(requirmentT.items) do
        player.removeItem(itemT.itemID, itemT.count, itemT.itemAID, nil, true)
    end
    
    broadCastMsg = broadCastMsg:gsub("PLAYER_NAME", player:getName())
    broadCastMsg = broadCastMsg:gsub("PLAYER_LEVEL", playerLevel)
    broadCastMsg = broadCastMsg:gsub("PLAYER_REBIRTH", nextReLevel)

    Vprint(broadCastMsg, "broadCastMsg")
    Vprint(newMaxLevel, "newMaxLevel")
    Vprint(playerLevel*100, "removeExpPercent")

    player:setStorageValue(rebirthConf.storageValues.maxLevel, newMaxLevel)
    player.removeExpPercent(playerLevel*100)
    broadcast(broadCastMsg)
    rebirth_updateConditions(player)
end

function rebirth_updateConditions(player)
    local playerVocation = player:getVocation()
    local vocationName = playerVocation:getName()
    local vocationHP = playerVocation:getHealthGainAmount()
    local vocationMP = playerVocation:getManaGainAmount()
    local playerReLevel = rebirth_getRebirthLevel(player)
    local nextReLevel = playerReLevel + 1
    local skillList = {mL = 0, dL = 0, sL = 0, aL = 0, cL = 0, maxHP = 0, maxMP = 0}
    local maxLevel = player:getStorageValue(rebirthConf.storageValues.maxLevel)

    local function updateSkills(skillT)
        for skillName, amount in pairs(skillList) do
            if skillT[skillName] then skillList[skillName] = amount + skillT[skillName] end
        end
    end

    for rebirthLevel, rebirthT in rebirthConf.promotions do
        if nextReLevel <= rebirthLevel then updateSkills(rebirthT.rewards) end
    end
    
    for i=1, nextReLevel do updateSkills(rebirthConf.vocationRewards[playerVocationName]) end

    skillList[maxHP] = maxLevel*vocationHP
    skillList[maxMP] = maxLevel*vocationMP
    Uprint(skillList) -- for testing

    for skillName, amount in pairs(skillList) do
        if skillName == "mL" then attributeCondition:setParameter(MAGIC_LEVEL, amount) end
        if skillName == "aL" then attributeCondition:setParameter(P_SKILL_AXE, amount) end
        if skillName == "cL" then attributeCondition:setParameter(P_SKILL_CLUB, amount) end
        if skillName == "dL" then attributeCondition:setParameter(P_SKILL_DISTANCE, amount) end
        if skillName == "sL" then attributeCondition:setParameter(P_SKILL_SWORD, amount) end
        if skillName == "maxHP" then attributeCondition:setParameter(MAXHEALTHPOINTS, amount) end
        if skillName == "maxMP" then attributeCondition:setParameter(MAXMANAPOINTS, amount) end
    end
    
    player:addCondition(attributeCondition)
end

function rebirth_canRebirth(player)
    local playerVocationName = player:getVocation:getName()
    
    if not isInArray(rebirthConf.rebirthVocations, playerVocationName) then
        return player:sendTextMessage(GREEN, playerVocationName.." can not rebirth, you need to get better promotion.")
    end

    local playerReLevel = rebirth_getRebirthLevel(player)
    local nextReLevel = playerReLevel + 1
    local rebirthT = rebirthConf.promotions[nextReLevel]

    if not rebirthT then return player:sendTextMessage(GREEN, "There is no more rebirth levels for now.") end

    local requirmentT = rebirthT.requirements
    local playerLevel = player:getLevel()

    if playerLevel < requirmentT.level then return player:sendTextMessage(GREEN, "you need to get minimum level "..requirmentT.level.." before you can rebirth") end

    for _, itemT in pairs(requirmentT.items) do
        if not player.getItem(itemT.itemID, itemT.itemAID, true, false) then return player:sendTextMessage(GREEN, "You need more "..itemType(itemT.itemID):getName()) end    
    end
    return true
end

function rebirth_onLogin(player)
    local playerReLevel = rebirth_getRebirthLevel(player)
    local nextReLevel = playerReLevel + 1
    local rebirthT = rebirthConf.promotions[nextReLevel]

    if not rebirthT then return end
    
    player:sendTextMessage(ORANGE, "You can rebirth once you get level "..rebirthT.requirements.level)
    
    if playerReLevel < 1 then return end
    
    rebirth_updateConditions(player)
end

function rebirth_talkaction(player, words, param)
    return rebirth_rebirth(player)
end

function rebirth_getRebirthLevel(player)
    local level = player:getStorageValue(rebirthConf.storageValues.rebirthLevel)
    return level > 0 and level or 0
end