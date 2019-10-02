function skillTree_startUp()
    local talentID = 0

    for skillConfigT, branchT in pairs(skillTreeTable) do
        local totalAmountOfTalentsInBranch = 0
        
        for tier, tierT in pairs(branchT) do
            for talentName, talenT in pairs(tierT) do
                talentID = talentID + 1
                totalAmountOfTalentsInBranch = totalAmountOfTalentsInBranch + 1
                talenT.talentID = talentID
                talenT.name = talentName
            end
        end
        skillConfigT.talentAmount = totalAmountOfTalentsInBranch
    end
end

function skillTreeMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return end
    if buttonID == 102 then return skillTree_resetBranchByMwID(player, mwID, choiceID) end
    local branchMwID = mwID + choiceID

    return player:createMW(branchMwID, branchMwID)
end

function skillTree_branchMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.skillTree) end
    if buttonID == 102 then
        skillTree_toggleShowTiers(player)
        return player:createMW(mwID, mwID)
    end
    if buttonID == 103 then return skillTree_tryResetTier(player, mwID, choiceID) end
    if choiceID == 255 then return player:createMW(MW.skillTree) end
    
    modalWindow_savedDataByPid[player:getId()] = {mwID = mwID, choiceID = choiceID}
    return player:createMW(MW.skillTree_talents, mwID, choiceID)
end

function skillTree_talentMW(player, mwID, buttonID, choiceID)
    local saveT = modalWindow_savedDataByPid[player:getId()]
    local branchMwID = saveT.mwID
    local tierID = saveT.choiceID

    if buttonID == 101 then return player:createMW(branchMwID, branchMwID) end
    if buttonID == 102 then
        skillTree_talentDescription(player, choiceID)
        return player:createMW(mwID, branchMwID, tierID)
    end
    if buttonID == 103 then return skillTree_tryRemoveTalent(player, mwID, choiceID) end
    if choiceID == 255 then return player:createMW(MW.skillTree) end
    skillTree_addSkillPoints(player, choiceID)
    return player:createMW(mwID, branchMwID, tierID)
end

function skillTree_talents_createChoices(player, branchID, tierID)
    local tierT = skillTree_getTier(branchID, tierID)
    local choiceT = {}

    for talentName, talentT in pairs(tierT) do
        local emptySpacesSTR = createSpaces(talentName, 30)
        local pointsSpent = getSV(player, talentT.storage)
        
        choiceT[talentT.talentID] = talentName..emptySpacesSTR.."points spent["..pointsSpent.."/"..talentT.maxStack.."]"
    end
return choiceT
end

function skillTree_branch_createChoices(player, mwID)
    local branchSV = skillTree_getBranchSVByID(mwID)
    local branchT = skillTree_getBranchByID(mwID)
    local branchPoints = getSV(player, branchSV)
    local showTiers = skillTree_showTiers(player)
    local choiceT = {}

    for tier, tierT in pairs(branchT) do
        local pointsRequired = skillTree_getTierPointsRequired(tier)
        local pointsSpent = skillTree_getTotalPointsSpentByTier(player, tierT)
        
        if getSV(player, SV.tutorial) == 0 and tier > 1 then
        else
            if branchPoints >= pointsRequired or showTiers then
                if branchPoints-pointsRequired >= 0 then
                    choiceT[tier] = "Tier "..tier.." powers      points Spent ["..pointsSpent.."]"
                else
                    choiceT[tier] = "Tier "..tier.." powers      points required ["..pointsRequired-branchPoints.."]"
                end
            end
        end
    end
    return choiceT
end

function skillTree_createButtons(player)
    return {[100] = "Open", [101] = "Back", [102] = skillTree_showPowersButton(player), [103] = "Reset"}
end

function skillTree_skillPointsLeftString(player) return "skillpoints left: "..getSV(player, SV.skillpoints) end
function skillTree_magicChoice(player)          return "Magic - bonus magic level: "..math.floor(getSV(player, SV.magicSkillpoints)/3) end
function skillTree_weaponChoice(player)         return "Weapon - bonus weapon level: "..math.floor(getSV(player, SV.weaponSkillpoints)/3) end
function skillTree_distanceChoice(player)       return "Distance - bonus distance level: "..math.floor(getSV(player, SV.distanceSkillpoints)/3) end
function skillTree_shieldingChoice(player)      return "Shielding - bonus shielding level: "..math.floor(getSV(player, SV.shieldingSkillpoints)/3) end
function skillTree_showPowersButton(player)     return skillTree_showTiers(player) and "hide all" or "show all" end

function skillTree_branch_MWName(player)        return skillTree_getBranchNameByID(modalWindow_savedDataByPid[player:getId()].mwID) end
function skillTree_showTiers(player)            return getSV(player, SV.skillTreeShowTiers) == 1 end
function skillTree_toggleShowTiers(player)      return toggleSV(player, SV.skillTreeShowTiers) end

function skillTree_talentDescription(player, talentID)
    local talentT = skillTree_getTalentByID(talentID)
    if not talentT then
        print("ERROR in skillTree_talentDescription() - "..talentID)
        return
    end
    player:sendTextMessage(ORANGE, ">>> talent - "..talentT.name.." <<<")
    
    for _, text in ipairs(talentT.description) do
        local formulaUsed = false
        local value = talentT.value
        local pointsSpent = getSV(player, talentT.storage)
        
        if text:match("value") then text = text:gsub("value", value) end
        
        local formulaStr = text:match("%b()")
        if formulaStr then
            formulaUsed = true
            
            for formula in text:gmatch("%b()") do
                if formula:match("x") then
                    formula = formula:gsub("x", pointsSpent)
                    formulaStr = formulaStr:gsub("x", "x*"..pointsSpent)
                end
                local total = calculate(player, formula)
                text = text:gsub("%b()", formulaStr.." = "..total, 1)
            end
        end
        
        if formulaUsed and getSV(player, SV.extraInfo) == -1 then
            player:sendTextMessage(BLUE, text.." (x = you current points spent amount)")
        else
            player:sendTextMessage(BLUE, text)
        end
    end
end

function skillTree_addSkillPoints(player, talentID)
    local skillPointSV = SV.skillpoints
    local skillPoints = getSV(player, skillPointSV)
    if skillPoints <= 0 then return skillTree_error_notEnoughSkillPoints(player) end

    local saveT = modalWindow_savedDataByPid[player:getId()]
    local branchMwID = saveT.mwID
    local tierID = saveT.choiceID
    local branchSV = skillTree_getBranchSVByID(branchMwID)
    local branchName = skillTree_getBranchNameByID(branchMwID)
    local pointsRequired = skillTree_getTierPointsRequired(tierID)
    if getSV(player, branchSV) - pointsRequired < 0 then return skillTree_error_tooHighTier(player, branchName) end

    local talentT = skillTree_getTalentByID(talentID)
    local talentSV = talentT.storage
    local talentName = talentT.name
    local pointsSpent = getSV(player, talentSV)
    if talentT.maxStack <= pointsSpent then return skillTree_error_maxedTalent(player, talentName) end
    if branchMwID == MW.skillTree_shielding and player:isEquipped(12434, 1) then return skillTree_error_unequipHoodOfNaturalTalent(player) end

    local amount = talentT.maxStack - pointsSpent
    if skillPoints < amount then amount = skillPoints end
    addSV(player, talentSV, amount)
    addSV(player, skillPointSV, -amount)
    addSV(player, branchSV, amount)
    if talentSV == SV.weapon_scabbard then weapon_scabbard_addCap(player) end
    addSkills(player)
end

function updateSkills(player)
    local pid = player:getId()

    for skillConfigT, branchT in pairs(skillTreeTable) do
        local totalPoints = getSV(player, skillConfigT.sv)
        local conditionT = skillConfigT.conditionT
        
        if totalPoints > 2 then
            local value = math.floor(totalPoints/3)
            bindCondition(pid, conditionT.name, -1, {[conditionT.attribute] = value})
        else
            player:removeCondition(ATTRIBUTES, conditionT.ID)
        end
    end
end

function skillTree_createMW(player) return player and player:createMW(MW.skillTree) end

-- get functions
function skillTree_getTalentValue(player, sv, branchID)
    local talentPoints = getSV(player, sv)
    if talentPoints < 1 then return 0 end
    local talenT = skillTree_getTalentBySV(sv, branchID)
    return math.floor(talentPoints * talenT.value)
end

function skillTree_getTierPointsRequired(tierID) return (tierID-1) * 10 end

function skillTree_getTalentByID(talentID)
    local totalTalentAmount = 0

    for skillConfigT, branchT in pairs(skillTreeTable) do
        local talentAmount = skillConfigT.talentAmount + totalTalentAmount
        
        if talentAmount >= talentID then
            for tier, tierT in pairs(branchT) do
                for talentName, talenT in pairs(tierT) do
                    if talenT.talentID == talentID then return talenT end
                end
            end
        end
        totalTalentAmount = totalTalentAmount + talentAmount
    end
end

function skillTree_getTalentBySV(sv, branchID)
    for skillConfigT, branchT in pairs(skillTreeTable) do
        if not branchID or branchID == skillConfigT.mwID then
            for tier, tierT in pairs(branchT) do
                for talentName, talenT in pairs(tierT) do
                    if talenT.storage == sv then return talenT end
                end
            end
        end
    end
end

function skillTree_getTotalPointsSpentByTier(player, tierT)
    local pointsSpent = 0
    for talentName, t in pairs(tierT) do pointsSpent = pointsSpent + getSV(player, t.storage) end
    return pointsSpent
end

function skillTree_getBranchByID(mwID)
    for branchNameT, branchT in pairs(skillTreeTable) do
        if branchNameT.mwID == mwID then return branchT end
    end
end

function skillTree_getBranchNameByID(mwID)
    for branchNameT, branchT in pairs(skillTreeTable) do
        if branchNameT.mwID == mwID then return branchNameT.name end
    end
end

function skillTree_getBranchSVByID(mwID)
    for branchNameT, branchT in pairs(skillTreeTable) do
        if branchNameT.mwID == mwID then return branchNameT.sv end
    end
end

function skillTree_getTier(mwID, tierID)
    for tier, tierT in pairs(skillTree_getBranchByID(mwID)) do        
        if tier == tierID then return tierT end
    end 
end

-- resetting functions
function skillTree_resetAll(player)
    for skillT, branchT in pairs(skillTreeTable) do skillTree_resetBranch(player, branchT, skillT.sv) end
end

function skillTree_resetBranch(player, branchT, branchSV)
    for tier, tierT in pairs(branchT) do skillTree_resetTier(player, tierT, branchSV) end
end

function skillTree_resetTier(player, tierT, branchSV)
    for talentName, talentT in pairs(tierT) do skillTree_removeTalent(player, talentT, branchSV) end
end

function skillTree_removeTalent(player, talentT, branchSV, amount)
    local talentSV = talentT.storage
    local pointsSpent = getSV(player, talentSV)
    if pointsSpent <= 0 then return end

    if amount then pointsSpent = amount end
    if talentSV == SV.weapon_scabbard then removeScabbard(player) end
    addSV(player, SV.skillpoints, pointsSpent)
    addSV(player, branchSV, -pointsSpent)
    addSV(player, talentSV, -pointsSpent)
end

function skillTree_tryRemoveTalent(player, mwID, talentID)
    local saveT = modalWindow_savedDataByPid[player:getId()]
    local branchMwID = saveT.mwID
    local tierID = saveT.choiceID
    local talentT = skillTree_getTalentByID(talentID)
    local branchT = skillTree_getBranchByID(branchMwID)
    if skillTree_talentsUsedInUpperTier(player, branchT, tierID, 1) then return player:createMW(mwID, branchMwID, tierID) end

    local branchSV = skillTree_getBranchSVByID(branchMwID)
    skillTree_removeTalent(player, talentT, branchSV, 1)
    addSkills(player)
    return player:createMW(mwID, branchMwID, tierID)
end

function skillTree_resetBranchByMwID(player, mwID, choiceID)
    local branchMwID = mwID + choiceID
    local branchT = skillTree_getBranchByID(branchMwID)
    local branchSV = skillTree_getBranchSVByID(branchMwID)

    if not branchT then
        print("ERROR in skillTree_resetBranchByMwID()")
        Vprint(branchSV, "branchSV")
        Vprint(branchMwID, "branchMwID")
        Vprint(mwID, "mwID")
        Vprint(choiceID, "choiceID")
    end
    skillTree_resetBranch(player, branchT, branchSV)
    addSkills(player)
    return player:createMW(mwID, branchMwID)
end

function skillTree_tryResetTier(player, mwID, choiceID)
    local branchT = skillTree_getBranchByID(mwID)
    if skillTree_talentsUsedInUpperTier(player, branchT, choiceID) then return player:createMW(mwID, mwID) end

    local branchSV = skillTree_getBranchSVByID(mwID)
    local tierT = skillTree_getTier(mwID, choiceID)

    skillTree_resetTier(player, tierT, branchSV)
    addSkills(player)
    return player:createMW(mwID, mwID)
end

function skillTree_talentsUsedInUpperTier(player, branchT, tierID, removeAmount)
    local totalTierPointsAfterRemove = 0
    local pointsSpentOnHigherTier = false

    for tier, tierT in ipairs(branchT) do
        if tier < tierID then
            for _, t in pairs(tierT) do totalTierPointsAfterRemove = totalTierPointsAfterRemove + getSV(player, t.storage) end
        elseif tier == tierID and removeAmount then
            for _, t in pairs(tierT) do totalTierPointsAfterRemove = totalTierPointsAfterRemove + getSV(player, t.storage) end
            totalTierPointsAfterRemove = totalTierPointsAfterRemove - removeAmount
        elseif tier > tierID then
            local function getNextTier() return branchT[tier+1] end
            local pointsRequired = skillTree_getTierPointsRequired(tier)
            
            if removeAmount and getNextTier() then
                for _, t in pairs(tierT) do totalTierPointsAfterRemove = totalTierPointsAfterRemove + getSV(player, t.storage) end
            end
            
            for _, t in pairs(tierT) do
                if not pointsSpentOnHigherTier then
                    if getSV(player, t.storage) > 0 then pointsSpentOnHigherTier = true end
                end
                
                if pointsSpentOnHigherTier and pointsRequired > totalTierPointsAfterRemove then
                    return player:sendTextMessage(GREEN, "Can't remove points from lower tier if you have spent points in higher tier.")
                end
            end
        end
    end
end

-- error messages
function skillTree_error_notEnoughSkillPoints(player)
    player:sendTextMessage(GREEN, "You don't have any skillpoints left.")
    player:sendTextMessage(BLUE, "You don't have any skillpoints left.")
end

function skillTree_error_tooHighTier(player, branchName)
    player:sendTextMessage(GREEN, "You have to spend more "..branchName.." power on lower tiers before.")
    player:sendTextMessage(BLUE, "You have to spend more "..branchName.." power on lower tiers before.")
end

function skillTree_error_maxedTalent(player, talentName)
    player:sendTextMessage(GREEN, "Maximum talent points reached on talent - "..talentName)
    player:sendTextMessage(BLUE, "Maximum talent points reached on talent - "..talentName)
end

function skillTree_error_unequipHoodOfNaturalTalent(player)
    player:sendTextMessage(GREEN, "Unequip hood of natural talent first")
    player:sendTextMessage(BLUE, "Unequip hood of natural talent first")
end

-- other
startWithNoSkills = Condition(ATTRIBUTES, 1)
startWithNoSkills:setTicks(-1)
startWithNoSkills:setParameter(P_SKILL_SHIELD, -10)
startWithNoSkills:setParameter(P_SKILL_FIST, -10)
startWithNoSkills:setParameter(P_SKILL_CLUB, -10)
startWithNoSkills:setParameter(P_SKILL_SWORD, -10)
startWithNoSkills:setParameter(P_SKILL_AXE, -10)
startWithNoSkills:setParameter(P_SKILL_DISTANCE, -10)
startWithNoSkills:setParameter(P_SKILL_FISHING, -10)

function addSkills(player)
    local pid = player:getId()

    player:addCondition(startWithNoSkills)
    updateSkills(player)
    wisdom(player)
    skilled(player)
    addEvent(juicy_magicFunc, 1000, pid)
end

function skillTree_firstTimeOnLogin(player)
    setSV(player, SV.skillpoints, 0)
    
    for treeT, branchT in pairs(skillTreeTable) do
        setSV(player, treeT.sv, 0)
        
        for tier, tierT in pairs(branchT) do
            for talent, talentT in pairs(tierT) do setSV(player, talentT.storage, 0) end
        end
    end
end