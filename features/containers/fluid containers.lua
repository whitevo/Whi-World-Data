function fluidContainer_onUse(player, item, itemEx)
    if not itemEx then return end
    if itemEx:isCreature() then return food_drinkWater(player, item, itemEx) end
    if useContainerOnWaterElementalBody(player, item, itemEx) then return end
    if not item:getType():isFluidContainer() then return end
local toPos = getParentPos(itemEx)
local fluidType = item:getFluidType()
local exFluidType = itemEx:getFluidType()
local itemID = item:getId()
local itemExID = itemEx:getId()
    
    if forestSpiritsQuest_pourBlood(player, item, itemEx) then return end
    if cyclopsStashQuestShroom(toPos, fluidType) then return end
    if fluidContainer_rum(item, itemEx) then return end
    if farming_waterPlants(player, item, itemEx) then return end
    if extinguish_fire(player, item, itemEx) then return end
    
	if itemEx:getType() and itemEx:getType():isFluidContainer() then
		if exFluidType == 0 and fluidType ~= 0 then
			itemEx:transform(itemExID, fluidType)
			item:transform(itemID, 0)
		elseif exFluidType ~= 0 and fluidType == 0 then
            vialOfWaterMission_fillVial(player, exFluidType)
			itemEx:transform(itemExID, 0)
			item:transform(itemID, exFluidType)
		end
        return
	end
local fluidSource = itemEx:getType() and itemEx:getType():getFluidSource() or 0
    
    if fluidSource ~= 0 then
        vialOfWaterMission_fillVial(player, fluidSource)
        return item:transform(itemID, fluidSource)
    end
    if fluidType == 0 then return player:sendTextMessage(GREEN, "It is empty.") end
    campfireMission(player, item, itemEx)
    item:transform(itemID, 0)
    createItem(2016, toPos, 1, nil, fluidType):decay()
end

function extinguish_fire(player, item, itemEx)
local fluidType = item:getFluidType()
    if fluidType ~= 1 then return end
local decayT = getDecayT(itemEx)
    if not decayT then return end
local itemPos = itemEx:getPosition()

    item:transform(item:getId(), 0)
    doSendMagicEffect(itemPos, 3)
    return decayT.toItemID and itemEx:transform(decayT.toItemID) or itemEx:remove()
end

function useContainerOnWaterElementalBody(player, item, itemEx)
    if itemEx:getId() ~= 10499 then return end
    item:transform(item:getId(), 1)
    return itemEx:remove()
end

function fluidContainer_rum(item, itemEx)
if not itemEx or itemEx:isCreature() then return end
local itemExAID = itemEx:getActionId()
local itemID = item:getId()

    if item:getFluidType() ~= 0 then return end
    if itemExAID == AID.quests.sabotage.rumBarrel1 then return item:transform(itemID, 27) end
    if itemExAID == AID.quests.sabotage.rumBarrel2 then return item:transform(itemID, 27) end
end

function fluidContainer_empty(item)
    if not item:getType():isFluidContainer() then return end
    return item:transform(item:getId(), 0)
end