function onSay(player, words, param)
    if inJazMazOT(player) then
        player:sendTextMessage(ORANGE, "!online     = Shows all players who are currently online.")
        player:sendTextMessage(ORANGE, "!ww         = activates whi world scripts and disables jazmaz OT scripts")
        player:sendTextMessage(ORANGE, "!buy        = opens up spcial shop")
        return
    end
    
    player:sendTextMessage(ORANGE, "!up         = teleports up.")
    player:sendTextMessage(ORANGE, "!down       = teleports down.")
    player:sendTextMessage(ORANGE, "!godmode    = enables/disables godmode.")
    player:sendTextMessage(ORANGE, "!online     = Shows all players who are currently online.")
    
    if not player:isGod() then return player:sendTextMessage(GREEN, "only god can see all commands") end
    player:sendTextMessage(ORANGE, "!t param    = teleports creature to you.")
    player:sendTextMessage(ORANGE, "!goto param = teleports to creauture or place or open teleport panel.")
    player:sendTextMessage(ORANGE, "!pos POS    = teleports to position.")
    player:sendTextMessage(ORANGE, "!r INT      = removes thing. INT = amount")
    player:sendTextMessage(ORANGE, "!b          = broadcasts.")
    player:sendTextMessage(ORANGE, "!m param, INT   = creates monster. INT = amount")
    player:sendTextMessage(ORANGE, "!i          = creates item. [name/ID, count, AID, fluidType] or open equipment or food item window")
    player:sendTextMessage(ORANGE, "!spells     = opens spell creating winow")
    player:sendTextMessage(ORANGE, "!herb       = opens herb creating window")
    player:sendTextMessage(ORANGE, "!tools      = opens tool creating window")
    player:sendTextMessage(ORANGE, "!pot        = opens pot creating window")
    player:sendTextMessage(ORANGE, "!gems       = opens gem creating window")
    player:sendTextMessage(ORANGE, "!stones     = opens stone creating window")
    player:sendTextMessage(ORANGE, "!s param    = summons monster.")
    player:sendTextMessage(ORANGE, "!g          = ghost mode ON/OFF.")
    player:sendTextMessage(ORANGE, "!clean      = clears map.")
    player:sendTextMessage(ORANGE, "!getPSV     = show player Storage value EX: noob, 13040 or _G[SV]param.")
    player:sendTextMessage(ORANGE, "!setPSV     = changes player Storage value EX: noob, 13040 or _G[SV]param, 4..")
    player:sendTextMessage(ORANGE, "!dofile     = reloads a file from features folder EX: !dofile cooking  | EX2: !dofile crafting")
end

function inJazMazOT(player) return getSV(player, SV.jazMazOT) == 1 end