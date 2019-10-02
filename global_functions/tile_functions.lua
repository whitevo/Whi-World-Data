function Tile.getItemList(tile)
local tileItems = tile:getItems()
local itemList = {}

    for i, item in ipairs(tileItems) do
        local itemAID = item:getActionId()
        local itemText = item:getAttribute(TEXT)
        local fluidType
        
        if itemAID < 100 then itemAID = nil end
        if itemText == "" then itemText = nil end
        if item:isFluidContainer() then fluidType = item:getFluidType() end
        local itemT = {itemID = item:getId(), itemAID = itemAID, itemText = itemText, count = item:getCount(), type = fluidType}
        itemList[i] = itemT
    end
    return itemList
end

function Tile.isCreature() return false end
function Tile.isPlayer() return false end
function Tile.isItem() return false end
function Tile.isTile() return true end
function Tile.isPzLocked(tile) return tile:hasProperty(TILESTATE_PROTECTIONZONE) or tile:hasProperty(TILESTATE_NOPVPZONE) end --  or tile:isPz()  some servers have isPz method
function Tile.isContainer() return false end
function Tile.isSpecialBag() return false end
function Tile.getActionId(tile) return tile:getGround() and tile:getGround():getActionId() or 0 end