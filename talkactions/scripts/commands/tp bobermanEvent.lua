function onSay(player, words, param)
    if player:getSV(SV.tutorial) == 1 then return bomberman_enter(player) end
    player:sendTextMessage(GREEN, "You can enter bomberman event by using a sign in forgotten village")
end