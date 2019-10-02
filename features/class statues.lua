local AIDT = AID.other

if not classStatuesConf then
classStatuesConf = {
    [AIDT.statue_knight] = {spellSV = SV.armorup, vocation = "knight"},
    [AIDT.statue_hunter] = {spellSV = SV.trap, vocation = "hunter"},
    [AIDT.statue_mage] = {spellSV = SV.spark, vocation = "mage"},
    [AIDT.statue_druid] = {spellSV = SV.heal, vocation = "druid"},
}

feature_classStatues = {
    AIDItems = {
        [AIDT.statue_knight] = {funcSTR = "classStatues_changeClass"},
        [AIDT.statue_hunter] = {funcSTR = "classStatues_changeClass"},
        [AIDT.statue_mage] = {funcSTR = "classStatues_changeClass"},
        [AIDT.statue_druid] = {funcSTR = "classStatues_changeClass"},
    },
    AIDItems_onLook = {
        [AIDT.statue_knight] = {funcSTR = "classStatues_onLook"},
        [AIDT.statue_mage] = {funcSTR = "classStatues_onLook"},
        [AIDT.statue_hunter] = {funcSTR = "classStatues_onLook"},
        [AIDT.statue_druid] = {funcSTR = "classStatues_onLook"},
    },
}

centralSystem_registerTable(feature_classStatues)
end

local requiredLevel = 4
function classStatues_changeClass(player, item)
local vocationT = classStatuesConf[item:getActionId()]
    if not vocationT then return error("changeVocation() missing vocationT") end
local newVoc = vocationT.vocation

    if player:getVocation():getName():lower() == newVoc then return player:sendTextMessage(GREEN, "you are already "..newVoc) end
local playerLevel = player:getLevel()

    if not player:isGod() then
        if playerLevel < requiredLevel then
            for itemAID, vocationT in pairs(classStatuesConf) do removeSV(player, vocationT.spellSV) end
            setSV(player, vocationT.spellSV, 1)
        elseif playerLevel > 2 then
            if getSV(player, vocationT.spellSV) ~= 1 then
                local spellT = spells_getSpellT(vocationT.spellSV)
                return player:sendTextMessage(GREEN, "You need to learn "..spellT.spellName.." spell first. You can craft that spell with enchanting profession")
            end
            local requiredAmount = playerLevel - requiredLevel
            if requiredAmount > 0 and not player:removeItem(5905, requiredAmount) then return player:sendTextMessage(GREEN, "You need "..requiredAmount.." magic dust to change class") end
        end
    end
    
    player:setVocation(Vocation(newVoc))
    player:sendTextMessage(GREEN, "you are now "..newVoc)
    player:sendTextMessage(ORANGE, "The higher level you are the more magic powder it costs to change class")
    doSendMagicEffect(player:getPosition(), 5)
end

function classStatues_onLook(player, item)
local vocationT = classStatuesConf[item:getActionId()]
    if not vocationT then return error("changeVocation() missing vocationT") end
local playerLevel = player:getLevel()
local requiredAmount = playerLevel - requiredLevel
local changeCostStr = ""
    
    if requiredAmount > 0 then changeCostStr = " for "..requiredAmount.." magic dust" end
    if playerLevel > 1 then changeCostStr = changeCostStr.."\nAfter level "..requiredLevel.." you need to enchant yourself level 1 spell first to change class" end
    player:sendTextMessage(GREEN, "Use this statue to change your class into "..vocationT.vocation..changeCostStr)
end