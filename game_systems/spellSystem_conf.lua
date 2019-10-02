local spellSystem = {
    modalWindows = {
        [MW.createSpell] = {
            name = "spells",
            title = "Choose a spell to create",
            choices = "spellSystem_MWchoices",
            buttons = {[100] = "Choose", [101] = "Close"},
            say = "creating spell scrolls",
            func = "spellSystem_handleMW",
        },
    }
}
centralSystem_registerTable(spellSystem)
dofile('data/spells/spellAreas.lua')
dofile('data/spells/spellBuffs.lua')
dofile('data/spells/playerSpells_conf.lua')
dofile('data/spells/monsterSpells_conf.lua')
dofile('data/spells/spellCreatingSystem.lua')
print("spellSystem loaded..")

function spellSystem_MWchoices(player)
    local choiceT = {}
    for spellName, t in pairs(spells) do
        if t.actionID then choiceT[t.spellID] = spellName end
    end
    return choiceT
end

function spellSystem_handleMW(player, mwID, buttonID, choiceID)
    if buttonId == 101 then return end
    local spellT = spells_getSpellT(choiceID)
    player:giveItem(5958, 1, spellT.actionID)
end