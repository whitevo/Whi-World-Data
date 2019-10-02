-- in future try to make it so that gold coinds can be stacked 10000 times! then remove all other gold
local feature_changeMoney = {
    IDItems = {
        [ITEMID.other.coin] = {funcStr = "coin_onUse"},
        [2152] = {funcStr = "coin_onUse"},
        [2160] = {funcStr = "coin_onUse"},
    }
}
centralSystem_registerTable(feature_changeMoney)

function coin_onUse(player, item)
    local itemID = item:getId()
    local itemCount = item:getCount()

	if itemID == ITEMID.other.coin then
        if itemCount == 100 then
            item:remove()
            player:giveItem(2152)
        elseif itemCount == 1 then
            if getSV(player, SV.autoLoot_gold) == -1 then
                player:sendTextMessage(BLUE, "Every time you step on gold or corpse you auto-loot gold")
                player:say("*auto-looting gold activated*", ORANGE)
                setSV(player, SV.autoLoot_gold, 1)
                setSV(player, SV.autoLoot_howTo, 1)
            else
                player:sendTextMessage(BLUE, "auto-looting gold deactivated")
                player:say("*auto-looting gold deactivated*", ORANGE)
                removeSV(player, SV.autoLoot_gold)
            end
        end
	elseif itemID == 2152 and itemCount == 100 then
		item:remove()
		player:giveItem(2160)
	elseif itemID == 2152 and itemCount < 100 then
		item:transform(itemID, itemCount - 1)
		player:giveItem(ITEMID.other.coin, 100)
	elseif itemID == 2160 then
		item:transform(itemID, itemCount - 1)
		player:giveItem(2152, 100)
	end
end
