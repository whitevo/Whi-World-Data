--[[ toolsConf guide
    saws = {INT},           list of tools mainly used to chop/saw trees
    hammers = {INT},        list of tools mainly used for crafting and building
    herbknives = {INT},     list of tools mainly used for gathering herbs
    pickaxes = {INT},       list of tools mainly used to destroy stones and gather minerals
]]
if not toolsConf then
toolsConf = {
    saws = {2558, 2386},
    hammers = {2422},
    herbknives = {13828},
    pickaxes = {2553},
    shovels = {5710},
}

local feature_tools = {
    AIDItems = {
        [AID.other.tool] = {funcSTR = "tools_useTool"}
    },
    IDItems_onLook = {
        [2005] = {funcSTR = "cactusMilkBucket_onLook"},
        [2016] = {funcSTR = "cactusMilkPool_onLook"},
        [2017] = {funcSTR = "cactusMilkPool_onLook"},
        [2018] = {funcSTR = "cactusMilkPool_onLook"},
    }
}

    centralSystem_registerTable(feature_tools)
end

function tools_useTool(player, item, itemEx)
    if not itemEx then return end
    if not item:isTool() then return end
    if tools_combine(player, item, itemEx) then return end
    if tools_split(player, item, itemEx) then return end
    
    if item:isSaw() then
        if cutHehemiBranch(player, item, itemEx) then return end
        if banditMountain_chopBigTree(player, item, itemEx) then return end
        if woodCutting_useSaw(player, item, itemEx) then return end
    elseif item:isHammer() then
        if gems_removeGem(itemEx, 10, player) then return end
        if gems2_removeGem(itemEx, player) then return end
        if borthonosMachine_usedOn(player, item, itemEx) then return end
        if equipmentTokens_createToken(player, item, itemEx) then return end
        if smithing_useHammer(player, item, itemEx) then return end
        if crafting_useHammer(player, item, itemEx) then return end
        if breakItems(player, item, itemEx) then return end
        if building_useHammer(player, item, itemEx) then return end
    elseif item:isHerbknife() then
        if cutCactus(player, item, itemEx) then return end
        if cutHerb(player, item, itemEx) then return end
    elseif item:isPickaxe() then
        if cyclops_destroyCorpseStone(player, item, itemEx) then return end
        if mining_destroyStone(player, item, itemEx) then return end
        if mining_mineOre(player, item, itemEx) then return end
    elseif item:isShovel() then
        if farming_useShovel(player, item, itemEx) then return end
    end
    player:sendTextMessage(GREEN, item:getName().." has no effect on "..itemEx:getName())
end

function tools_combine(player, item, itemEx)
    if not itemEx:isTool() then return end
    if item:getUniqueId() == itemEx:getUniqueId() then return end
    if item:getId() ~= itemEx:getId() then return end
local itemAID = item:getActionId()
local itemExAID = itemEx:getActionId()
    
    if itemAID == AID.areas.forgottenVillage.smith_hammer then return player:sendTextMessage(GREEN, "How about no stealing?") end
    if itemAID == AID.building.tutorialHammer then return player:sendTextMessage(GREEN, "Worth a try. Right?") end
    if itemExAID == AID.areas.forgottenVillage.smith_hammer then return player:sendTextMessage(GREEN, "Bum's hammer doesn't need charges") end
    if itemExAID == AID.building.tutorialHammer then return player:sendTextMessage(GREEN, "this tutorial hammer doesn't need charges") end
local itemCharges = tools_getCharges(item)
local maxCharges = itemEx:getText("maxCharges")

    if not maxCharges then
        tools_addCharges(player, itemEx, itemCharges)
        return item:remove()
    end
local itemExCharges = tools_getCharges(itemEx)
local newAmount = itemCharges + itemExCharges
    
    if itemExCharges == maxCharges then return player:sendTextMessage(GREEN, "This tool can only hold up to maximum "..maxCharges.." charges") end
    
    if newAmount == maxCharges then
        tools_setCharges(player, itemEx, maxCharges)
        return item:remove()
    end
    
    if newAmount > maxCharges then
        tools_setCharges(player, itemEx, maxCharges)
        tools_addCharges(player, item, -(itemCharges-(newAmount - maxCharges)))
    else
        tools_addCharges(player, itemEx, itemCharges)
        item:remove()
    end
    return true
end

function tools_split(player, item, itemEx)
    if not itemEx:isTool() then return end
    if item:getUniqueId() ~= itemEx:getUniqueId() then return end
    if item:getActionId() == AID.areas.forgottenVillage.smith_hammer then return player:sendTextMessage(GREEN, "You can't split Bum's hammer") end
local charges = tools_getCharges(item)
    if charges < 2 then return player:sendTextMessage(GREEN, "you can't split tool if it has less than 2 uses left") end
local newStackSize = 5

    if charges < 6 then newStackSize = 1 end
    player:giveItem(item:getId(), 1, AID.other.tool, nil, "charges("..newStackSize..")")
    tools_setCharges(player, item, charges-newStackSize)
end

function tools_onLook(player, item, desc, realDesc)
    if desc then return desc end
    if not item:isTool() then return desc end
    if item:isHerbknife() then return herbKnife_onLook(item) end
local charges = tools_getCharges(item)
local newDesc = realDesc.."\n"..charges.." uses left."
    
    if getSV(player, SV.extraInfo) == -1 then
            newDesc = newDesc.."\nTools can be stacked by using them on eachother."
        if item:isPickaxe() then newDesc = newDesc.."\nCan be used to destroy stones or mine materials from mining ores" end
        if item:isSaw() then
            newDesc = newDesc.."\nCan be used to chop/saw down trees to get logs"
            if item:getId() == 2386 then newDesc = newDesc.."\nTo see more information about woodcutting open profession window trough player panel (look yourself)" end
        end
    end
    return newDesc
end

function herbKnife_onLook(knife)
    local desc = "Herb Knife"
    local charges = tools_getCharges(knife)

    if charges > 0 then
        local enchant = knife:getText("enchant")
        if enchant then desc = desc.."\nEnchanted with "..enchant.." and " end
        desc = desc.."\nhas "..plural("charge", charges).." left"
    end
    desc = desc.."\nWeight: "..(knife:getWeight()/100).." cap"
    return desc
end

-- get functions, set functions, is functions
local function searchTool(player, table)
    for _, itemID in ipairs(table) do
        local tool = player:getItem(itemID, AID.other.tool, true, false)
        if tool then return tool end
    end
end

function tools_getHammer(player) return searchTool(player, toolsConf.hammers) end
function tools_getSaw(player) return searchTool(player, toolsConf.saws) end
function tools_getHerbknife(player) return searchTool(player, toolsConf.herbknives) end
function tools_getPickaxe(player) return searchTool(player, toolsConf.pickaxes) end
function tools_getShovel(player) return searchTool(player, toolsConf.shovels) end

function tools_getCharges(item)
    if item:getActionId() == AID.areas.forgottenVillage.smith_hammer then return 100 end
local charges = item:getText("charges") or 0
    
    if charges > 0 then return charges end
    return 0
end

function tools_setCharges(player, item, newChargeAmount)
    if item:getActionId() ~= AID.other.tool then return end
    if newChargeAmount > 0 then return item:setText("charges", newChargeAmount) end
    player:sendTextMessage(GREEN, "you broke your "..item:getName().."!")
    item:remove()
end

function tools_addCharges(player, item, addAmount) return tools_setCharges(player, item, (item:getText("charges") or 0) + addAmount) end

function tools_addHammerCharges(player, amount)
    if not amount or amount == 0 then return end
    tools_addCharges(player, tools_getHammer(player), amount)
end

function Player.hasHammerCharges(player, amount)
    if not amount or amount == 0 then return true end
local hammer = tools_getHammer(player)
    if not hammer then return end
    if tools_getCharges(hammer) >= amount then return true end
end

function tools_addShovelCharges(player, amount)
    if not amount or amount == 0 then return end
    tools_addCharges(player, tools_getShovel(player), amount)
end

function Player.hasShovelCharges(player, amount)
    if not amount or amount == 0 then return true end
local shovel = tools_getShovel(player)
    if not shovel then return end
    if tools_getCharges(shovel) >= amount then return true end
end

function Item.isSaw(item) return isInArray(toolsConf.saws, item:getId()) end
function Item.isHammer(item) return isInArray(toolsConf.hammers, item:getId()) end
function Item.isHerbknife(item) return isInArray(toolsConf.herbknives, item:getId()) end
function Item.isPickaxe(item) return isInArray(toolsConf.pickaxes, item:getId()) end
function Item.isShovel(item) return isInArray(toolsConf.shovels, item:getId()) end
function Item.isTool(item) return item:getActionId() == AID.other.tool or item:isSaw() or item:isHammer() or item:isHerbknife() or item:isPickaxe() or item:isShovel() end
function Creature.isTool() return false end

-- other functions
local cactusList_big = {[2723] = 2729, [2724] = 2729, [2727] = 2732, [2734] = 2728, [2733] = 2729, [2735] = 2729} -- cactusID = smallCactusID
local cactusList_small = {2728, 2729, 2730, 2731, 2732, 2736}
function cutCactus(player, item, itemEx)
    if not itemEx:isItem() then return end
local itemExID = itemEx:getId()
    if isInArray(cactusList_small, itemExID) then return player:sendTextMessage(GREEN, "This cactus is too small to get milk from it") end
local smallCactusID = cactusList_big[itemExID]
    if not smallCactusID then return end
    if not player:removeItem(2005, 1, nil, 0) then return player:sendTextMessage(GREEN, "You don't have empty bucket with you to store cactus milk") end
local itemExPos = itemEx:getPosition()

    doTransform(itemExID, itemExPos, smallCactusID)
    addEvent(doTransform, 45*60*1000, smallCactusID, itemExPos, itemExID)
    player:giveItem(2005, 1, nil, 6)
    doSendMagicEffect(itemExPos, 17)
    createItem(2016, player:getPosition(), 1, nil, 6):decay()
end

local breakableItems = {9090}
function breakItems(player, item, itemEx)
    if not itemEx:isItem() then return end
local itemID = itemEx:getId()
    if not isInArray(breakableItems, itemID) then return end
    tools_addCharges(player, item, -1)
    addEvent(createItem, 1000*60*20, itemID, itemEx:getPosition())
    player:giveItem(5888)
    return itemEx:remove()
end

function cactusMilkBucket_onLook(player, item)
    if item:getFluidType() == 6 then return player:sendTextMessage(GREEN, "You see a bucket of cactus milk.\nIt weights 50.00oz.") end
end

function cactusMilkPool_onLook(player, item)
    if item:getFluidType() == 6 then return player:sendTextMessage(GREEN, "You see a pool of cactus milk.") end
end