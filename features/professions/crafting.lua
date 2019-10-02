function crafting_useHammer(player, item, itemEx)
    if not itemEx:isItem() then return end
local craftingName = craftingConf.quickCraft[itemEx:getId()]
    if not craftingName then return end
local craftT = craftingConf.craftingMaterials[craftingName]
local quickCraft = cracting_quickCraft(player, item, itemEx, craftT)
local buttonID = quickCraft and 102 or 100

    crafting_craftMW(player, MW.crafting, buttonID, craftT.ID, quickCraft)
    return true
end

function craftingMW_title(player) return "Your crafting level is: "..player:getCraftingLevel().." ["..player:getCraftingExp().."/"..player:getCraftingTotalExp().."]" end

function craftingMW(player, mwID, buttonID, choiceID)
    if buttonID == 101 then return player:createMW(MW.professions) end
    if choiceID == 1 then return player:createMW(MW.crafting_equipment) end
    if choiceID == 2 then return player:createMW(MW.crafting_materials) end
    if choiceID == 3 then return player:createMW(MW.crafting_other) end
end

function crafting_canCraft(player, craftT, group) return smithing_canCraft(player, craftT, false, group) end
function crafting_createChoiceStr(player, craftT, canCraft) return smithing_createChoiceStr(player, craftT, canCraft) end

local function createChoiceT(player, group)
local choiceT = {}
    
    for craftName, craftT in pairs(craftingConf.craftingMaterials) do
        local canCraft, dontShow = crafting_canCraft(player, craftT, group)
        if not dontShow then choiceT[craftT.ID] = crafting_createChoiceStr(player, craftT, canCraft) end
    end
    return choiceT
end

function cracting_quickCraft(player, item, itemEx, craftT)
    if not compareSV(player, craftT.allSV, "==") then return end
    if not compareSV(player, craftT.bigSV, ">=") then return end
    if craftT.takeCharges and tools_getCharges(item) < craftT.takeCharges then return end
    
    if craftT.reqT then
        local itemID = itemEx:getId()
        local itemT = itemList_getItemT(craftT.reqT, itemID)
        local itemList = craftT.reqT
        local itemCount = itemEx:getCount()
        
        if itemT then itemList = itemList_merge(itemList, {itemID = itemID, itemAID = itemEx:getActionId(), count = -itemCount}) end
        if not player:hasItems(itemList) then return end
        player:removeItemList(itemList)
        local removeCount = itemT.count
        if itemCount < removeCount then removeCount = itemCount end
        itemEx:remove(removeCount)
    end
    if craftT.takeCharges then tools_addCharges(player, item, -craftT.takeCharges) end
    return true
end

function crafting_otherMW_choices(player) return createChoiceT(player, "other") end
function crafting_equipmentMW_choices(player) return createChoiceT(player, "equipment") end
function crafting_materialsMW_choices(player) return createChoiceT(player, "materials") end

function crafting_craftMW(player, mwID, buttonID, choiceID, quickCraft)
    if buttonID == 101 then return player:createMW(MW.crafting) end
    if choiceID == 255 then return player:createMW(mwID) end
    local craftT = crafting_getCraftT(choiceID)
        
    if buttonID == 100 then
        local text = craftT.craftName.."\n"
        local takeChargesStr = craftT.takeCharges and craftT.takeCharges > 0 and plural("charge", craftT.takeCharges).." on your crafting hammer\n" or ""
        
        text = text.."Requires:\n"..takeChargesStr
        text = text..itemRequirementStr(craftT.reqT).."\n"
        text = text.."Gives "..craftT.exp.." crafting experience for crafting.\n\n"
        text = text.."You get "..plural(ItemType(craftT.itemID):getName(), craftT.count)
        
        player:showTextDialog(craftT.itemID, text)
        return player:createMW(mwID)
    end
    
    if not quickCraft then
        if not crafting_canCraft(player, craftT) then
            player:sendTextMessage(GREEN, "You are missing something to craft "..craftT.craftName)
            return player:createMW(mwID)
        else
            player:removeItemList(craftT.reqT)
        end
    end
    
    if craftT.itemID == 2422 then -- iron hammer
        player:sendTextMessage(ORANGE, "1 charge added to iron hammer")
    else
        if not player:rewardItems(craftT, false, "You don't have enough cap to create this item") then return player:createMW(mwID) end
        if getSV(player, SV.craftSpearMissionTracker) == 1 then setSV(player, SV.craftSpearMissionTracker, 2) end
        
        if craftT.takeCharges and not quickCraft then tools_addHammerCharges(player, -craftT.takeCharges) end
    end
    player:addCraftingExp(craftT.exp)
end

-- get functions and is functions
function crafting_getCraftT(choiceID)
    for craftName, craftT in pairs(craftingConf.craftingMaterials) do
        if craftT.ID == choiceID then return craftT end
    end
end

function Player.addCraftingExp(player, amount)
local newLevel = professions_addExp(player, amount, craftingConf.professionT.professionStr)

    if not newLevel then return end
local msgT = craftingConf.levelUpMessages[newLevel] or {}

    player:sendTextMessage(GREEN, "Your crafting skill is now level "..newLevel.."!")
    for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
end

function Player.getCraftingExp(player) return professions_getExp(player, craftingConf.professionT.professionStr) end
function Player.getCraftingLevel(player) return professions_getLevel(player, craftingConf.professionT.professionStr) end
function Player.getCraftingTotalExp(player) return professions_getTotalExpNeeded(player, craftingConf.professionT.professionStr) end

-- other functions
function buildingSand_onLook(player, item)
    if not item or item:getId() ~= ITEMID.materials.sand then return end
local desc = "You see building sand\nWeight: "..item:getWeight()/100

    if getSV(player, SV.extraInfo) == -1 then desc = desc.."\nUse it near liquid fire to turn it into glass powder" end
    return player:sendTextMessage(GREEN, desc)
end

function buildingSand_onUse(player, item)
local areaAround = getAreaAround(player:getPosition())
    
    for _, pos in ipairs(areaAround) do
        if findItem(8645, pos) then
            item:remove()
            return player:giveItem(13215, 1)
        end
        if findItem(8643, pos) then
            item:remove()
            return player:giveItem(13215, 1)
        end
    end
    return player:sendTextMessage(GREEN, "There is no conviently useable liquid fire near you")
end

outfits_male = {151, 152, 153, 154, 251, 268, 273, 278, 289, 325, 328, 335, 367, 430, 432, 463, 465, 472, 512, 516, 541, 574, 577, 619, 633, 634, 637, 665, 667, 684, 695, 697, 699}
outfits_female = {155, 156, 157, 158, 252, 269, 270, 279, 288, 324, 329, 336, 431, 433, 464, 466, 471, 514, 542, 575, 578, 620, 632, 635, 636, 664, 666, 683, 694, 696, 698}
function mirror_onUse(player, item)
local outfitT = {}

    if player:getSex() == 1 then outfitT = outfits_male end
    if player:getSex() == 0 then outfitT = outfits_female end
    for _, looktype in ipairs(outfitT) do player:addOutfit(looktype) end
    player:sendOutfitWindow()
    addEvent(mirror_removeOutfits, 5*60*1000, player:getId())
end

function mirror_removeOutfits(playerID)
local player = Player(playerID)
local outfitT = {}
    
    if not player then return end
    if player:getSex() == 1 then outfitT = outfits_male end
    if player:getSex() == 0 then outfitT = outfits_female end
    for _, looktype in ipairs(outfitT) do player:removeOutfit(looktype) end
end