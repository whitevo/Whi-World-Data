function brewing_startUp()
    local function getPotionIdByIngredients(ingredients)
        local AIDT = {}
        
        for _, herbName in pairs(ingredients) do
            local herbT = herbs_getHerbT(herbName)
            table.insert(AIDT, herbT.powderAID)
        end
        local sortedKeys = sortByValue(AIDT, "low")
        local potionID = ""
        
        for _, aid in ipairs(sortedKeys) do potionID = potionID..aid end
        return tonumber(potionID)
    end
    
    addProfession(brewingConf.professionT)

    for potionName, potT in pairs(potions) do
        if potT.storage then potT.storageReset = {} end
        if potT.event then potT.eventReset = {} end
        if not potT.duration then potT.duration = 10 end
        potT.potionID = getPotionIdByIngredients(potT.ingredients)
        potT.name = potionName
        central_register_actionEvent({[potT.itemAID] = {funcSTR = "potions_onUse"}}, "AIDItems")
        AIDItems_onLook[potT.itemAID] = {funcSTR = "potions_onLook"}
    end
end

function brewing_createUnfinishedPotion(player, item, itemEx)
    if itemEx:getId() ~= 2006 then return end
    if itemEx:getFluidType() ~= 1 then return player:sendTextMessage(GREEN, "currently potions can only be created with vial of water") end
    local powderAID = item:getActionId()
    if powderAID == AID.herbs.golden_spearmint_powder then return makeSpeedPotion(player, item, itemEx) end 
    local unfinishedPotion = player:giveItem(10031)

    unfinishedPotion:setText("powderAID", powderAID)
    item:remove(1)
    itemEx:remove(1)
    return doSendMagicEffect(player:getPosition(), 28)
end

function brewing_mixPowders(player, item, itemEx)
    if itemEx:getId() ~= 10031 then return end
    if item:getActionId() == AID.herbs.golden_spearmint_powder and player:getSV(SV.speedPotionRecipe) == 2 then
        return player:sendTextMessage(GREEN, "Golden Spearmint already creates speed potion with water")
    end
    local mixID = brewing_getPotionMixID(item, itemEx)
    local potionT = brewing_getPotionT(mixID)

    item:remove(1)
    itemEx:remove(1)
    if not potionT then return false, player:sendTextMessage(GREEN, "These herbs didn't work together.") end
    vocationPotionMission_createdPot(player, potionT.itemAID)
    setSV(player, potionT.recipeSV, 2)
    brewing_createPotion(player, potionT)
    if player:getSV(questSV) == 1 then player:addBrewingExp(potionT.brewingExp) else player:say("0 exp from tutorial", ORANGE) end
    return true
end

function brewing_createPotion(player, potionT)
    player:giveItem(potionT.itemID, 1, potionT.itemAID)
    player:sendTextMessage(GREEN, "You created "..potionT.name.." !!")
    player:say("** created "..potionT.name.." **", ORANGE)
    doSendMagicEffect(player:getPosition(), 28)
end

function makeSpeedPotion(player, item, itemEx)
    local potionT = brewing_getPotionT(AID.potions.speed)

    item:remove(1)
    itemEx:remove(1)
    vocationPotionMission_createdPot(player, potionT.itemAID)
    setSV(player, potionT.recipeSV, 2)
    brewing_createPotion(player, potionT)
    player:addBrewingExp(potionT.brewingExp)
    return true
end

-- get functions
function brewing_getPotionMixID(item, itemEx)
    local AID1 = itemEx:getText("powderAID")
    local AID2 = item:getActionId()
    if AID1 > AID2 then return tonumber(AID2..AID1) else return tonumber(AID1..AID2) end
end

function brewing_getPotionT(object)
    if type(object) == "number" then
        for potionName, potionT in pairs(potions) do
            if potionT.potionID == object or potionT.itemAID == object then return potionT end
        end
    end
end

function Item.isPotion(item)
    return item:getId() == 10031 or brewing_getPotionT(item:getActionId())
end

function Player.addBrewingExp(player, amount)
    local newLevel = professions_addExp(player, amount, brewingConf.professionT.professionStr)
    if not newLevel then return end
    player:sendTextMessage(GREEN, "Your brewing skill is now level "..newLevel.."!")
    player:sendTextMessage(ORANGE, "potion effects on you are now more powerful")
end

function Player.getBrewingExp(player) return professions_getExp(player, brewingConf.professionT.professionStr) end
function Player.getBrewingTotalExp(player) return professions_getTotalExpNeeded(player, brewingConf.professionT.professionStr) end
function Player.getBrewingLevel(player) return professions_getLevel(player, brewingConf.professionT.professionStr) end
