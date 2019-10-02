function executeHistory(player)
    if onceOnLogin(player, 0) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.6.4")
        
        removeSV(player, SV.smithUrranelInfo)
    end
    
    if onceOnLogin(player, 1) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.6.5")
        player:sendTextMessage(BLUE, "I had calculation mistake with percent exp, your experience has been reset")
        
        player:removeExperience(player:getExperience())
        skillTree_resetAll(player)
        addSV(player, SV.skillpoints, -(player:getLevel()-1))
        removeSV(player, SV.antidotePotionsMission, -1)
        
        if getSV(player, SV.BM_Quest_abducted) == 1 then
            player:sendTextMessage(BLUE, "quest: abducted")
            player:addExpPercent(BM_Quest_abducted.rewardExp)
        end
        
        for _, t in pairs(npcMissions) do
            if t.collectingMissions then
                for missionName, t2 in pairs(t.collectingMissions) do
                    if getSV(player, t2.storageID) == 1 then
                        if t2.rewardExp then
                            player:sendTextMessage(BLUE, "mission: "..missionName)
                            player:addExpPercent(t2.rewardExp)
                        end
                    end
                end
            end
            if t.trackerMissions then
                for missionName, t2 in pairs(t.trackerMissions) do
                    if getSV(player, t2.storageID) == 1 then
                        if t2.rewardExp then
                            player:sendTextMessage(BLUE, "mission: "..missionName)
                            player:addExpPercent(t2.rewardExp)
                        end
                    end
                end
            end
        end
        
        if getSV(player, SV.archanosKill) == 1 then
            player:sendTextMessage(BLUE, "boss: archanos")
            player:addExpPercent(40)
        end
        
        if getSV(player, SV.whiteDeerKill) == 1 then
            player:sendTextMessage(BLUE, "boss: White Deer")
            player:addExpPercent(25)
        end
    end
    
    if onceOnLogin(player, 3) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.6.6")
        player:sendTextMessage(BLUE, "Improved skillTree")
        player:sendTextMessage(BLUE, "Mage death and spark spell costs more mana the further it reaches")
        
        local svT = {
            SV.wisdom,
            SV.demon_master,
            SV.dark_powers,
            SV.elemental_strike,
            SV.lucky_strike,
            SV.undercut,
            SV.power_throw,
            SV.steel_jaws,
            SV.sharpening_projectile,
            SV.wounding,
            SV.archery,
            SV.sharp_shooter,
            SV.skilled,
            SV.momentum,
            SV.distanceSkillpoints,
        }
        local svT2 = {
            SV.magicSkillpoints,
            SV.weaponSkillpoints,
            SV.distanceSkillpoints,
            SV.shieldingSkillpoints,
            SV.fistfightingSkillpoints,
        }
        
        setSV(player, svT, 0)
        skillTree_resetAll(player)
        setSV(player, svT2, 0)
        
        removeSV(player, SV.craftSpearMission, -1)
        removeSV(player, SV.craftSpearMissionTracker, -1)
        
        if player:getName():lower() == "dicemangs" then
            player:addExpPercent(30)
            player:sendTextMessage(ORANGE, "For completing the liam mission, but not getting the reward exp")
            player:addExpPercent(40)
            player:sendTextMessage(ORANGE, "Missing exp I forgot to add last update for completing tutorial")
        elseif player:getName():lower() == "mage" then
            player:addExpPercent(50)
            setSV(player, SV.lootbagFromWagon, -1)
            player:addMoney(25)
        elseif player:getName():lower() == "ice" then
            player:addMoney(51)
            local depot = player:getDepot()
            
            print("Ice depot was broken, why?")
            print("items in depot:")
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                
                if item then
                    print("itemName - "..item:getName().."  ["..item:getId().."]")
                    if item:isContainer() then
                        print("         Container items:")
                        for x=0, item:getSize() do
                            local item2 = item:getItem(x)
                            if item2 then
                                print("itemName - "..item2:getName().."  ["..item2:getId().."]")
                            else
                                break
                            end
                        end
                    end
                else
                    break
                end
            end
            print()
            
            if depot then
                local itemID = 1746
                local count = 3
                local itemsRemoved = 0
                local movedCylinder = 0
                
                for x=0, depot:getSize() do
                    local item = depot:getItem(x-movedCylinder)
                    
                    if itemsRemoved >= count then
                        if itemsRemoved > count then
                            local leftovers = itemsRemoved - count
                            self:giveItem(itemID, leftovers)
                        end
                        return true
                    end
                    
                    if item then
                        if compare(item:getId(), itemID) then
                            itemsRemoved = itemsRemoved + 1
                            movedCylinder = movedCylinder + 1
                            item:remove()
                        end
                    end
                end
            end
            player:sendTextMessage(BLUE, "I did reset your treasure chests, hopefully they work now.")
        elseif player:getName():lower() == "magma" then
            -- no exp
        elseif player:getLevel() > 1 then
            player:addExpPercent(100)
            player:sendTextMessage(ORANGE, "forgot to add exp what you got from completing tutorial boss.")
        end
        
        local function createBagInfo(item)
            local itemID = item:getId()
            if compare(itemID, gemBagConf.itemID) or compare(itemID, herbBagConf.itemID) or compare(itemID, lootBagConf.itemID) then item:setText("ownerName", player:getAccountId()) end
        end
        
        local depot = player:getDepot()
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                
                if item then
                    if item:isContainer() then
                        for x=0, item:getSize() do
                            local item2 = item:getItem(x)
                            
                            if item2 then
                                createBagInfo(item2)
                            else
                                break
                            end
                        end
                    end
                    createBagInfo(item)
                else
                    break
                end
            end
        end
        
        local bag = player:getBag()
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                
                if item then createBagInfo(item) else break end
            end
        end
    end
    
    if onceOnLogin(player, 4) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.6.7")
        player:sendTextMessage(BLUE, "Core function getPath() has been improved. Lets see did it fix the lag issues.")
        player:sendTextMessage(BLUE, "Go get new loot bag from the wagon xD, previous one was bugged. You will be now able to stack the lootbag you get from there")
        
        removeSV(player, SV.lootbagFromWagon)
    end
    
    if onceOnLogin(player, 5) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.6.8")
        player:sendTextMessage(BLUE, "Improved monster AI even more, gotta get this lag away")
        player:sendTextMessage(BLUE, "Added activity chart to website, hopefully no errors with that, else you wont be able to log in xD")
        player:sendTextMessage(BLUE, "removed teleport rune and instead added a that option to you player panel (when you get the charges)")
        player:sendTextMessage(BLUE, "improved cookbook. It will now tell what would the created product give")
    end
    
    if onceOnLogin(player, 6) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.6.9")
        player:sendTextMessage(BLUE, "New quest added to forest area: Cursed Bear")
        player:sendTextMessage(BLUE, "New questSystem added to game, Cursed Bear Quest is the only quest what uses that system right now")
        player:sendTextMessage(BLUE, "Hunter now has class passives")
        player:sendTextMessage(BLUE, "replaced talent [dark powers] with [elemental powers]")
        
        local svT = {
            SV.nami_bootsFromPool,
            SV.WC_teleportCharge,
            SV.cursedBearQuest,
            SV.cursedBearQuestTracker,
            SV.lootBagFromTutorialMonument,
            SV.cursedBearHint_bearKill,
            SV.lastDeathTime,
            SV.deathProtection,
        }
        
        removeSV(player, svT)
        setSV(player, SV.elemental_powers, getSV(player, SV.dark_powers)+1)
    end
    
    if onceOnLogin(player, 7) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.6.9 hotfix")
        player:sendTextMessage(BLUE, "Online time has been reset")
        player:sendTextMessage(BLUE, "duelling has been disabled")
        player:sendTextMessage(BLUE, "Several bugs got fixed")
        
        local svT = {
            SV.lastLogInTime,
            SV.onlineTime,
        }
        removeSV(player, svT)
    end
    
    if onceOnLogin(player, 8) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.7 ")
        player:sendTextMessage(BLUE, "online time has been reset again. something buggy was going on.")
        player:sendTextMessage(BLUE, "ranked PVP and PVP items have been disabled.")
        player:sendTextMessage(BLUE, "upgrade stones has been reworked, if you want to take out old stones from items then contact whitevo.")
        player:sendTextMessage(BLUE, "new mission added to bandit mountain: Bandit Mail Mission")
        player:sendTextMessage(BLUE, "new area added to map: mystery forest area")
        
        local svT = {
            SV.banditMailMission,
            SV.banditMailMissionTracker,
            SV.banditMailMission_wagonID,
            SV.banditMailMission_keyHint,
            SV.banditMailMission_key,
            SV.banditMailMission_openedLetter,
            SV.lastLogInTime,
            SV.onlineTime,
            SV.banditMailMission_peeterTrust,
        }
        removeSV(player, svT)
    end
    
    if onceOnLogin(player, 9) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.7.2")
        player:sendTextMessage(ORANGE, "ALL areas, quests, mission and minigames have been reorganized and refactored/improved")
        player:sendTextMessage(ORANGE, "token bag has been reworked, hopefully your token bags you own got automatically updated")
        player:sendTextMessage(ORANGE, "Bone Flute Mission has been reset")
        player:sendTextMessage(ORANGE, "lot of new quest added to questlog, aka the puzzles in rooted catacombs, if you do them again you wil get exp")
        
        local svT = {
            SV.rootedCatacombs_questSV,
            SV.rootedCatacombs_trackerSV,
            SV.skeletonWarrior_questSV,
            SV.skeletonWarrior_trackerSV,
            SV.fluteMissionTracker,
            SV.fluteMission,
            SV.fluteMissionHint,
            SV.ghostBless_trackerSV,
            SV.ghostBless_questSV,
            10408,
            10406,
            10413,
            SV.repellPillarHint,
            SV.ghoulBless_questSV,
            SV.ghoulBless_trackerSV,
            SV.ghoulBless_hint,
            SV.rootedCatacombs,
            SV.tutorialTracker,
            SV.tutorial_shop,
            SV.tutorial_escapeButton,
            SV.tutorial_fireRes,
            SV.tutorial_iceRes,
        }
        removeSV(player, svT)
        
        if getSV(player, SV.tutorial) > 43 then
            setSV(player, SV.tutorial, 1)
        else
            removeSV(SV.tutorial)
        end
        
        local depot = player:getDepot()
        local bag = player:getBag()
        local oldPotT = {
            ["druid potion"] = {itemID = 12468, itemAID = 100},
            ["hunter potion"]= {itemID = 7477,  itemAID = 101},
            ["mage potion"]  = {itemID = 7495,  itemAID = 102},
            ["knight potion"]= {itemID = 20135, itemAID = 103},
            ["antidote potion"]     = {itemID = 7477,  itemAID = 104},
            ["spellcaster potion"]  = {itemID = 13735, itemAID = 108},
            ["silence potion"]      = {itemID = 21403, itemAID = 107},
            ["flash potion"]        = {itemID = 12544, itemAID = 106},
        }
        
        local function changeItem(item)
        local itemID = item:getId()
        local aid = item:getActionId()
            
            if compare(itemID, 9076) then
                item:setText("tokenBag", aid)
                return item:setActionId(nil)
            elseif compare(itemID, 12429) or compare(itemID, 12434) then
                if aid > 999 then return item:setActionId(math.random(100, 999)) end
            end
            
           
            for potName, oldPotT in pairs(oldPotT) do
                if itemID == oldPotT.itemID and aid == oldPotT.itemAID then
                    local potT = potions[potName]
                    return item:setActionId(potT.itemAID)
                end
            end
        end
        
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                changeItem(item)
            end
        end
        
        for x=0, 13 do
            local item = player:getSlotItem(x)
            if item then changeItem(item) end
        end
        
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                
                if not item then break end
                if item:isContainer() then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        changeItem(item2)
                    end
                end
                changeItem(item)
            end
        end
    end
    
    
    if onceOnLogin(player, 10) then
        player:sendTextMessage(BLUE, "Patch  0.1.5.7.2 HOTFIXES")
        local msgT = {
            "new players no longer get patch notes of previous updates when they log in for first time.",
            "keys now can be collected again",
            "fixed bug when skipping some tutorial actions caused to put change your tutorial stage to 4",
            "Fixed modal windows teleporting bug, you no longer teleport to other players trough choosing values in MW",
            "Fixed bug killing orb in wall room didnt remove wall",
            "Fixed spellroom blue tile",
            "Fixed bug where players could not learn spellScrolls",
            "tutorial poles are now attacking",
            "tutorial npc now buy rubbish after you kill poles too..",
        }
        for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
        
        if player:getName():lower() == "red apple" then
            removeSV(player, SV.tutorial)
            removeSV(player, SV.tutorialTracker)
            teleport(player, {x = 525, y = 737, z = 8})
        end
        
        if player:getName():lower() == "soraice" then
            player:addItem(5958, 1):setActionId(AID.spells.poison)
            player:addItem(2389, 3)
            player:sendTextMessage(BLUE, "Whitevo: Sorry for rough start")
            player:sendTextMessage(BLUE, "Whitevo: I have fixed all the found bugs now")
            player:sendTextMessage(BLUE, "Whitevo: I gave you back the scroll and gave some spears for your patience (in shop these 10gp each)")
        end
    end
    
    if onceOnLogin(player, 11) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.3")
        local msgT = {
            "added new tutorial room to tutorial",
            "improved tutorial here and there in general",
            "fixed some more errors or bugs what appeared in tutorial",
            "craft spear mission added to missionLog",
            "priest reputation panel (brewing) will open now at level 4",
            "Hunters now don't have to face target in close combat",
            "when hunter poison spell wears off its more noticeable now",
            "hunter poison spell damage buffed",
        }
        for _, msg in ipairs(msgT) do player:sendTextMessage(ORANGE, msg) end
        
        local item = player:getSlotItem(SLOT_AMMO)
        if item and item:getId() == 2051 then item:setActionId(nil) end
    end
    
    if onceOnLogin(player, 12) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.3 part 2 xD")
        player:sendTextMessage(ORANGE, "hunter poison spell no longer procs when you dont have spell active (this also means other players cant proc it")
        player:sendTextMessage(ORANGE, "nerfed bandit regenerations and physical and poison resistance.")
        player:sendTextMessage(ORANGE, "fixed and improved bandit mail mission.")
        if getSV(player, SV.furBackpackMission) == 0 then removeSV(player, SV.furBackpackMission) end
    end
    
    if onceOnLogin(player, 13) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.4 ")
        player:sendTextMessage(ORANGE, "expanded cyclops stash quest")
        player:sendTextMessage(ORANGE, "increased arrow break chance from 10% to 15%")
        player:sendTextMessage(ORANGE, "you can now check 1 stat a the time with command !stats 'stat'")
        player:sendTextMessage(ORANGE, "accidently disable collecting missions in previous patch")
        player:sendTextMessage(ORANGE, "improved cyclops drops")
        player:sendTextMessage(ORANGE, "herb and gem bag have now option to print the count on your local chat")
        player:sendTextMessage(ORANGE, "tools can now be split up by using it on itself")
        
        removeSV(player, SV.cyclopsStashQuestHint2)
    end
    
    if onceOnLogin(player, 14) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.6 ")
        player:sendTextMessage(ORANGE, "reputation system was messed up, entire rep system has been reset")
        player:sendTextMessage(ORANGE, "fixed shortcut room teleports")
        player:sendTextMessage(ORANGE, "other than that seems that server is running smoothly, time to work on new system what will mess it all up :D")
        
        for _, repT in pairs(reputationT) do
            setSV(player, {repT.rep, repT.repL}, 0)
        end
    end
    
    if onceOnLogin(player, 15) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.7 ")
        player:sendTextMessage(ORANGE, "all monster have now new monster AI")
        player:sendTextMessage(ORANGE, "created new spellCreating system for Whi World")
        player:sendTextMessage(ORANGE, "all monster spells are converted to trough new spellCreating system")
        player:sendTextMessage(ORANGE, "most monster spells got more deails added to them and look better")
        player:sendTextMessage(ORANGE, "lets hope no crashes come and I lost the lag, which was the main reason to do that huge rework in first place")
    end
    
    if onceOnLogin(player, 16) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.8 ")
        player:sendTextMessage(ORANGE, "fixed few monster AI errors what popped up here or there")
        player:sendTextMessage(ORANGE, "added the player spell effects back what got lost last update")
        player:sendTextMessage(ORANGE, "increased meat and ham drop chances in forest a little")
        player:sendTextMessage(ORANGE, "while stunned you no longer can use weapons")
        player:sendTextMessage(ORANGE, "monster killing tasks what task master gives are fixed")
        player:sendTextMessage(ORANGE, "Cyclops stash quest reward is fixed")
        player:sendTextMessage(ORANGE, "some secrets are more noticeable (not rly, but still xD)")
        player:sendTextMessage(ORANGE, "stun resistance now showed on stats")
        player:sendTextMessage(ORANGE, "both torn book and the parchemnt has been fixed (tonka herb tasks)")
        player:sendTextMessage(ORANGE, "hunter spell !volley now deals arrow damage once again")
    end
    
    if onceOnLogin(player, 17) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.9 ")
        player:sendTextMessage(ORANGE, "fixed few map bugs")
        player:sendTextMessage(ORANGE, "added extra measures so that player speed won't go below 50 (your char will get stuck if it does)")
        player:sendTextMessage(ORANGE, "fixed some values and calculations made by spellbook.")
        player:sendTextMessage(ORANGE, "some items got changed")
        player:sendTextMessage(ORANGE, "fixed a priest missions")
        player:sendTextMessage(ORANGE, "buffed hunter trap and taunt spell, nerfed volley spell")
        player:sendTextMessage(ORANGE, "new feature: equipment tokens. You can now turn your useless items into tokens to use them for upgrading your best gear!")
    end
    
    if onceOnLogin(player, 18) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.9 hotfix")
        player:sendTextMessage(ORANGE, "You can now take gems out again from equipment when they are inside containers")
        player:sendTextMessage(ORANGE, "increased stone drop chance in rooted catacombs")
        player:sendTextMessage(ORANGE, "fixed bug where !trap spell had no cooldown")
        player:sendTextMessage(ORANGE, "fixed climb down spell, in some situations it allowed to climb down to bad places")
        player:sendTextMessage(ORANGE, "reduced tokens requirement to 3 instead of 4")
        player:sendTextMessage(ORANGE, "nerfed nami boots effect on volley spell")
        player:sendTextMessage(ORANGE, "nerfed snaipa helmet")
    end
    
    if onceOnLogin(player, 19) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.7.9 hotfix again xD")
        player:sendTextMessage(ORANGE, "fixed the cooldown issue with spells.")
        player:sendTextMessage(ORANGE, "Hehemi HC pillar what gives teleport charge now works.")
        player:sendTextMessage(ORANGE, "improved monster AI, which is nerf for them. Most monsters can no longer shoot trough walls.")
        player:sendTextMessage(ORANGE, "fixed shadow room entrance")
    end
    
    if onceOnLogin(player, 20) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8")
        player:sendTextMessage(ORANGE, "opened new content: mummy room in rooted catcombs")
        
        local svT = {
            SV.mummyBless_questSV,
            SV.mummyBless_trackerSV,
            SV.mummyBless_hintFromNote,
            SV.mummyBless_hintFromTanner,
            SV.mummyTask,
            SV.mummyTaskOnce,
            SV.mummy,
            SV.mummyMission,
            SV.kamikazeMantle_explosion,
            SV.kamikazeMantle_damage,
            SV.leatherVest,
            SV.frizenKilt,
            SV.bloodyShirt,
            SV.goddessArmor,
            SV.kamikazeShortPants,
            SV.ghatitkLegs,
            SV.shimasuLegs,
            SV.shimasuLegs_barrier,
        }
        
        for _, sv in ipairs(svT) do removeSV(player, sv) end
    end
    
    
    if onceOnLogin(player, 21) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.1")
        player:sendTextMessage(ORANGE, "all npc in th game has been reworked")
        player:sendTextMessage(ORANGE, "npc have now new shop window and new feature: item stocks")
        player:sendTextMessage(ORANGE, "spiced food duration are buffed")
        player:sendTextMessage(ORANGE, "buffed ghosts and mummies")
        player:sendTextMessage(ORANGE, "fixed and nerfed shadow boss")
        player:sendTextMessage(ORANGE, "fixed cyclops throw stone spell")
    end
    
    if onceOnLogin(player, 22) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.2")
        player:sendTextMessage(ORANGE, "fixed tutorial npcs and improved tutorial")
        player:sendTextMessage(ORANGE, "A bit of new north forest map is added")
        removeSV(player, 10050)
    end
    
    if onceOnLogin(player, 23) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.3")
        player:sendTextMessage(ORANGE, "new lootbag is added to you player, all the others are removed from game")
        player:sendTextMessage(ORANGE, "also did some bug fixes here and there")
        player:sendTextMessage(ORANGE, "now closing trade window twice with ESC button, will actaully close it!")
        
        removeItemFromGame(player, 21475)
        if player:getLevel() > 2 then
            player:rewardItems({{itemID = lootBagConf.itemID, itemAID = lootBagConf.itemAID}}, true)
        end
    end
    
    if onceOnLogin(player, 24) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.4")
        player:sendTextMessage(ORANGE, "House buildng feature is slowly being made")
        player:sendTextMessage(ORANGE, "for now you can do the tutorial for house building and build it yourself")
        player:sendTextMessage(ORANGE, "however next patch all houses will be reset and none of it will be saved")
        player:sendTextMessage(ORANGE, "in other words don't put your items in house")
        player:sendTextMessage(ORANGE, "buying and building house is free right now")
        
        setSV(player, SV.building_noItemsNeeded, 1)
        local svT = {
            SV.building_tutorialID,
            SV.building_tutorialStage,
            SV.player_houseID,
            SV.rentDuration,
            SV.building_exp,
            SV.building_level,
        }
        removeSV(player, svT)
    end
    
    if onceOnLogin(player, 26) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.5")
        player:sendTextMessage(ORANGE, "house building feature is now ready")
        player:sendTextMessage(ORANGE, "you can now own a house and build it.")
        player:sendTextMessage(ORANGE, "Your items will be safe in your house if you pay the rent and others can't reach your items")
        
        local svT = {
            SV.player_houseID,
            SV.rentDuration,
            SV.building_exp,
            SV.building_level,
            SV.player_ignoreDamage,
            SV.skipRoomTpFail,
            SV.isGod,
            SV.building_noItemsNeeded,
            SV.houseTutorialCompleted,
            SV.woodCuttingLevel,
            SV.woodCuttingExp,
        }
        removeSV(player, svT)
    end
    
    if onceOnLogin(player, 27) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.6")
        player:sendTextMessage(ORANGE, "Your depot has been rearranged, hopefully nothing was lost. If something did, then tough luck, items are forever gone")
        player:sendTextMessage(ORANGE, "New professions added to game: woodcutting, mining, smithing and crafting")
        player:sendTextMessage(ORANGE, "You can get closer look into professions trough player panel (look yourself)")
        player:sendTextMessage(ORANGE, "north early forest is now scripted")
        
        local depot = player:getDepotChest(2)
        local newDepot = player:getDepotChest(0, true)
        
        if depot and newDepot then
			local items = depot:getItems()
			for _, item in ipairs(items) do newDepot:addItemEx(item:clone()) end
        elseif not newDepot then
            print("depot transfer failed for "..player:getName().." | depot["..tostring(depot).."] | depot["..tostring(newDepot))
        end
        
        local svT = {
            SV.blessedIronHelmetMission,
            SV.blessedIronHelmetTracker,
            SV.miningExp,
            SV.miningLevel,
            SV.smithingExp,
            SV.smithingLevel,
            SV.recipe_warriorBoots,
            SV.craftingExp,
            SV.craftingLevel,
        }
        removeSV(player, svT)
    end
    
    if onceOnLogin(player, 28) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.7")
        player:sendTextMessage(ORANGE, "new proffesions added to game: farming, enchanting")
        player:sendTextMessage(ORANGE, "updated professions: woodcutting, cooking, brewing")
        player:sendTextMessage(ORANGE, "Your old tools are now up to date")
        player:sendTextMessage(ORANGE, "All food has been removed from game. You need to gather it again. Sorry for inconvenience")
        player:sendTextMessage(ORANGE, "All unfinished potions has been removed from game. You need to make them again. Sorry for inconvenience")
        player:sendTextMessage(ORANGE, "All vials have been removed from game. Sorry for inconvenience")
        player:sendTextMessage(ORANGE, "All old raw' minigame herbs have been removed from game")
        player:sendTextMessage(ORANGE, "Fixed bug where gems gave wrong upgrade to items. All your items are now 'fixed' and gems refunded")
        
        local depot = player:getDepot()
        local bag = player:getBag()
        local fakeGems = {}
        
        for _, foodT in pairs(foodConf.food) do removeItemFromGame(player, foodT.itemID) end
        removeItemFromGame(player, 10031)
        removeItemFromGame(player, 13758)
        removeItemFromGame(player, 13881)
        removeItemFromGame(player, 13919)
        removeItemFromGame(player, 13939)
        
        local function convertTool(item)
            local itemID = item:getId()
            local itemAID = item:getActionId()
            
            if itemAID >= 100 and itemAID < 500 then
                if isInArray(toolsConf.saws, itemID) or isInArray(toolsConf.hammers, itemID) or isInArray(toolsConf.herbknives, itemID) or isInArray(toolsConf.pickaxes, itemID) then
                    item:setText("charges", itemAID-100)
                    item:setActionId(AID.other.tool)
                end
            end
        end
        
        local function getFakeGem(item)
            if item:getId() == 13828 then return end
            local gemType = item:getText("enchant")
            if not gemType then return end
            local amount = item:getText("charges")
            if not amount then return end
            if not fakeGems[gemType] then fakeGems[gemType] = 0 end
            fakeGems[gemType] = fakeGems[gemType] + amount
            item:setText("enchant")
            item:setText("charges")
        end
        
        for x=1, 13 do
            local item = player:getSlotItem(x)
            if item then getFakeGem(item) end
        end
        
        for x=0, bag:getSize() do
            local item = bag:getItem(x)
            if not item then break end
            convertTool(item)
            getFakeGem(item)
        end
        
        for x=0, depot:getSize() do
            local item = depot:getItem(x)
            
            if not item then break end
            if item:isContainer() then
                local slotIndex = 0
                for x=0, item:getSize() do
                    local item2 = item:getItem(x)
                    if not item2 then break end
                    convertTool(item2)
                    getFakeGem(item)
                end
            end
            convertTool(item)
            getFakeGem(item)
        end
        
        for gemType, amount in pairs(fakeGems) do
            local gemT = gems_getGemT(gemType)
            player:addItem(gemT.itemID, amount)
        end
        
        local svT = {
            SV.cookingExp,
            SV.cookingLevel,
            SV.brewingExp,
            SV.brewingLevel,
            SV.enchantingExp,
            SV.enchantingLevel,
            SV.enchantingAltarHint,
            SV.farmingExp,
            SV.farmingLevel,
        }
        removeSV(player, svT)
    end

    if onceOnLogin(player, 29) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.8.9")
        player:sendTextMessage(ORANGE, "new minigame just for fun: bomberman. You can enter into this game from alice house by using sign")
        player:sendTextMessage(ORANGE, "nerfed hunter spell !poison")
        player:sendTextMessage(ORANGE, "nerfed zvoid boots")
        player:sendTextMessage(ORANGE, "bum now sells all tools")
    end
    
    if onceOnLogin(player, 30) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9")
        player:sendTextMessage(ORANGE, "fixed bug where you could not finish campfire mission if you put out too many campfires.")
        player:sendTextMessage(ORANGE, "Fixed bug where Archanos fire bombs dealt damage instantly")
        player:sendTextMessage(ORANGE, "+ several more bugs")
        player:sendTextMessage(ORANGE, "Questlog once again shows collecting missions")
        player:sendTextMessage(ORANGE, "changed the amount of food you can eat. If the food consumptions generates more hp or mana then you have max health or mana then you can't eat more.")
        player:sendTextMessage(ORANGE, "failing boss fight with boss protection only returns 200 hp and 200mp instead of full hp and full mp")
        player:sendTextMessage(ORANGE, "buff timer now shows timer when you can't enter hidden hardcore rooms")
        
        if player:getName():lower() == "bullshit" then player:giveItem(2422, 1, AID.other.tool, nil, "charges(12)") end
    end
    
    if onceOnLogin(player, 31) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.2")
        player:sendTextMessage(ORANGE, "New spell book! More accurate calculations and details about buffs what alter spells.")
        player:sendTextMessage(ORANGE, "2 new missions for early game")
        player:sendTextMessage(ORANGE, "NPC texts have been improved")
        player:sendTextMessage(ORANGE, "buffed all distance talents")
        player:sendTextMessage(ORANGE, "item effects are explained better")
        
        local SVT = {
            SV.findPeeterMission,
            SV.findPeeterTracker,
            SV.findPeeterHint1,
            SV.findPeeterHint2,
            SV.findTonkaMission,
            SV.findTonkaTracker,
            SV.findTonkaHint1,
            SV.findTonkaHint2,
        }
        removeSV(player, SVT)
    end
    
    if onceOnLogin(player, 32) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.3")
        player:sendTextMessage(ORANGE, "Hotfixed several problems:")
        player:sendTextMessage(ORANGE, "monster saw ppl double (making them scale up twice as more)")
        player:sendTextMessage(ORANGE, "couldn't shoot regenerative spear")
        player:sendTextMessage(ORANGE, "poison spell did damage even if missed arrow")
    end
    
    if onceOnLogin(player, 33) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.4")
        player:sendTextMessage(ORANGE, "Mineral bag added to game. This is reward from Cyclops Stash quest.")
        player:sendTextMessage(ORANGE, "If you have already completed the quest, you can buy the bag from Eather instead.")
        player:sendTextMessage(ORANGE, "Forest Spirits quest has been changed, if you were in middle of it, then you have to start over")
        player:sendTextMessage(ORANGE, "added rabbit task")
        player:sendTextMessage(ORANGE, "You can now change your class in town")
        
        if getSV(player, SV.forestSpiritsQuest) == 0 then removeSV(player, SV.forestSpiritsQuest) end
        
        local svt = {
            SV.rabbitTaskOnce,
            SV.rabbitTask,
        }
        removeSV(player, svt)
        
    end
    
    if onceOnLogin(player, 34) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.5")
        player:sendTextMessage(ORANGE, "new quest added to game: Treasure Hunt")
        player:sendTextMessage(ORANGE, "gems and herbs can be autolooted by stepping on corpse (if you have the special bag)")
        player:sendTextMessage(ORANGE, "new potion added to game: speed potion")
        player:sendTextMessage(ORANGE, "huge rework made how items are given, looted or added. Hopefully we see no errors")
        
        local svt = {
            SV.goldBox_mysterArea,
            SV.treasureHunt_questSV,
            SV.treasureHunt_trackerSV,
            SV.treasureHunt_key,
            SV.speedPotion_buff,
            SV.speedPotion_buffTime,
            SV.speedPotion_nerf,
            SV.speedPotion_nerfTime,
            SV.speedPotionRecipe,
        }
        removeSV(player, svt)
    end
    
    
    if onceOnLogin(player, 35) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.6")
        player:sendTextMessage(ORANGE, "Fixed lootbags")
        player:sendTextMessage(ORANGE, "Fixed weight of all items you have")
        player:sendTextMessage(ORANGE, "If you carried items inside loot bag or mineral bag, take them out and put them back in and relog to fix your weight problems.")
        
        if player:getSV(SV.treasureHunt_questSV) == 1 then
            removeItemFromGame(player, 8978)
            player:setSV(SV.treasureHunt_key, 1)
        end
        
        local bag = player:getBag()
        local depot = player:getDepot()
        
        local function fixWeight(item)
            if not item:hasCustomWeight() then return end
            item:setText("weight")
        end
        
        for x=1, 13 do
            local item = player:getSlotItem(x)
            if item then fixWeight(item) end
        end
        
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                fixWeight(item)
                
                if item:isContainer() then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixWeight(item2)
                        
                        if item2:isContainer() then
                            for x=0, item2:getSize() do
                                local item3 = item2:getItem(x)
                                if not item3 then break end
                                fixWeight(item3)
                            end
                        end
                    end
                end
            end
        end
        
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                if not item then break end
                fixWeight(item)
                
                if item:isContainer() then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixWeight(item2)
                    end
                end
            end
        end
    end
    
    if onceOnLogin(player, 36) then
        local bag = player:getBag()
        local depot = player:getDepot()
        local playerAccountID = player:getAccountId()
        
        player:setSV(SV.onceOnLogin, 37)
        local function fixOwnerName(item)
            if not item:isSpecialBag() then return end
            local accountID = item:getText("ownerName")
            if not accountID then return end
            item:setText("ownerName")
            item:setText("accountID", playerAccountID)
        end
        
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                fixOwnerName(item)
                
                if item:isContainer(true) then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixOwnerName(item2)
                        
                        if item2:isContainer(true) then
                            for x=0, item2:getSize() do
                                local item3 = item2:getItem(x)
                                if not item3 then break end
                                fixOwnerName(item3)
                            end
                        end
                    end
                end
            end
        end
        
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                if not item then break end
                fixOwnerName(item)
                
                if item:isContainer(true) then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixOwnerName(item2)
                    end
                end
            end
        end
    end
    
    if onceOnLogin(player, 37) then
        local bag = player:getBag()
        local depot = player:getDepot()
        local playerAccountID = player:getAccountId()
        
        local function fixOwnerName(item)
            if not item:isSpecialBag() then return end
            local accountID = item:getText("accountID")
            if not accountID then return end
            item:setText("accountID", playerAccountID)
        end
        
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                fixOwnerName(item)
                
                if item:isContainer() and not item:isSpecialBag() then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixOwnerName(item2)
                        
                        if item2:isContainer() and not item2:isSpecialBag() then
                            for x=0, item2:getSize() do
                                local item3 = item2:getItem(x)
                                if not item3 then break end
                                fixOwnerName(item3)
                            end
                        end
                    end
                end
            end
        end
        
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                if not item then break end
                fixOwnerName(item)
                
                if item:isContainer() then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        fixOwnerName(item2)
                    end
                end
            end
        end
    end
    
    if onceOnLogin(player, 38) then
        player:sendTextMessage(BLUE, "Patch 0.1.5.9.7")
        player:sendTextMessage(ORANGE, "lot of talents in skilltree got changed")
        player:sendTextMessage(ORANGE, "new event in challenge minigame - undead challenge")
        player:sendTextMessage(ORANGE, "bags now turn automatically into token bags when moved to container")
        player:removeSV(SV.undeadChallenge)
        
        if player:getName():lower() == "bamboo" then
            player:sendTextMessage(ORANGE, "I took away all your exessive spears, but I still lave you 10 of them, should be enuf for starters :D")
            removeItemFromGame(player, 2389)
            player:rewardItems({itemID = 2389, count = 10}, true)
        end
    end

    if onceOnLogin(player, 39) then
        if player:getName():lower() == "cezar" then
            player:sendTextMessage(BLUE, "updated game")
            player:sendTextMessage(ORANGE, "also gave you 100g so you can buy new lootbag and stuff")
            player:rewardItems({itemID = ITEMID.other.coin, count = 100}, true)
        end
    end
    
    if onceOnLogin(player, 40) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.0.1")
        player:sendTextMessage(ORANGE, "Lot of changes, just A lot, forgot to mentioned several patch notes in-game, but this current patch note brings:")
        player:sendTextMessage(ORANGE, "Changing class will let you keep your summons and buffs")
        player:sendTextMessage(ORANGE, "long spell effects are showin in player ongoing buff panel")
        player:sendTextMessage(ORANGE, "online time formula was bugged after you reached over 7 days online, fixed it")
        player:sendTextMessage(ORANGE, "Eather once again sells account bound special bags")
        player:sendTextMessage(ORANGE, "items can be directly moved on special bag icon")
        player:sendTextMessage(ORANGE, "in NPC shops lot of items can now only be bought and sold 1 at the time")
        player:sendTextMessage(ORANGE, "Fixed tutorial resistance room")
    end

    if onceOnLogin(player, 41) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.0.2")
        player:sendTextMessage(ORANGE, "Vial of water mission now gives experience again")
        if player:getSV(SV.vialOfWaterMission) == 1 then player:addExpPercent(20) end
        player:sendTextMessage(ORANGE, "reduced base miss chance with projectiles from 10% to 7%")
    end
    
    if onceOnLogin(player, 42) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.0.3")
        player:sendTextMessage(ORANGE, "Changed spell cooldowns from seconds to milliseconds")
        player:sendTextMessage(ORANGE, "Changed old gems, if you are lucky you got all your gems back")
        player:sendTextMessage(ORANGE, "added 5 new gems to game, they can be crafted trough enchanting profession")
        
        for spellName, spellT in pairs(spells) do player:setSV(spellT.spellSV+20000, -1) end

        local gemStrings = {[9970] = "iceGem", [2147] = "fireGem", [2149] = "earthGem", [2146] = "energyGem", [2150] = "deathGem", [8305] = "physicalGem"}
        local function takeOutGems(item)
            if not item then return end
            for gemID, k in pairs(gemStrings) do
                local value = item:getText(k)
                if value then
                    item:setText(k)
                    if value > 0 then return player:addItem(gemID, value) end
                end
            end
        end
        
        local searchSlots = {SLOT_HEAD, SLOT_ARMOR, SLOT_LEGS, SLOT_FEET, SLOT_LEFT, SLOT_RIGHT}
        for _, slot in pairs(searchSlots) do takeOutGems(player:getSlotItem(slot)) end
        
        local depot = player:getDepot()
        if depot then
            for x=0, depot:getSize() do
                local item = depot:getItem(x)
                
                if not item then break end
                if item:isContainer(true) then
                    for x=0, item:getSize() do
                        local item2 = item:getItem(x)
                        if not item2 then break end
                        takeOutGems(item2)
                    end
                end
                takeOutGems(item)
            end
        end
        
        local bag = player:getBag()
        if bag then
            for x=0, bag:getSize() do
                local item = bag:getItem(x)
                if not item then break end
                takeOutGems(item)
            end
        end
    end

    
    if onceOnLogin(player, 43) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.0.8")
        player:sendTextMessage(ORANGE, "npc now have spells and help you fight")
        player:sendTextMessage(ORANGE, "reworked stone upgrades, hopefully they still work")
    end

    if onceOnLogin(player, 44) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.0.9")
        player:sendTextMessage(ORANGE, "your depot extra chests have been updated")

        local depot = player:getDepot()
        if depot then
            local extraChests = depot:getItems(ITEMID.other.extra_depot_chest)
            local tokenBags = depot:getItems(ITEMID.containers.token_bag)
            local kamikazeWands = depot:getItems(13760)
            local mallets = depot:getItems(15647)
            local druidWands = depot:getItems(15400)
            for _, item in ipairs(extraChests) do item:setActionId(AID.other.extra_depot_chest) end
            for _, item in ipairs(tokenBags) do item:setActionId(AID.other.token_bag) end
            for _, item in ipairs(druidWands) do item:setActionId(AID.other.yashinuken) end
            for _, item in ipairs(mallets) do item:setActionId(AID.other.weapon_mallet) end
            for _, item in ipairs(kamikazeWands) do item:setActionId(AID.other.kamikaze_wand) end
        end

        local item = player:getItemById(2282, true)
        if item then item:remove() end

        local item = player:getItemById(2272, true)
        if item then item:remove() end

        local item = player:getItemById(7434, true)
        if item then item:remove() end
        
        local item = player:getItemById(15400, true)
        if item then item:setActionId(AID.other.yashinuken) end
        
        local item = player:getItemById(15647, true)
        if item then item:setActionId(AID.other.weapon_mallet) end
        
        local item = player:getItemById(13760, true)
        if item then item:setActionId(AID.other.kamikaze_wand) end
    end
    
    if onceOnLogin(player, 45) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.1")
        player:sendTextMessage(ORANGE, "Duelling enabled. Look other players if you want to PVP with them")
        removeSV(player, 10068) -- duelling SV removed
        removeSV(player, 10064) -- verified SV removed
    end
    
    
    if onceOnLogin(player, 46) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2")
        player:sendTextMessage(ORANGE, "Entire Whi World Engine is now sorted and organized")
        player:sendTextMessage(ORANGE, "Hopefully there won't be any huge errors what will affect your gameplay")
    end
    
    if onceOnLogin(player, 47) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.1")
        player:sendTextMessage(ORANGE, "Few bug fixes")
        player:sendTextMessage(ORANGE, "Items are no longer discarded when moved")

        if player:getName():lower() == "pemuski" then
            print("pemuski got his items!!")
            local itemList = {
                {itemID = 11304},
                {itemID = 10570},
                {itemID = 7463},
                {itemID = 7457},
                {itemID = 2190},
                {itemID = 2152, count = 2},
                {itemID = 5958, itemAID = 2214},
                {itemID = 2271, count = 3},
                {itemID = 2263, count = 3},
            }
            player:rewardItems(itemList, true)
        end
    end

    if onceOnLogin(player, 48) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.3")
        player:sendTextMessage(ORANGE, "added empire map. If want you can help me to improve the map with command !empire")
        player:sendTextMessage(ORANGE, "Fixed tutorial poles")
        player:removeSV(empireConf.empireCharIDSV)
    end

    
    if onceOnLogin(player, 49) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.4")
        player:sendTextMessage(ORANGE, "Improved empire event map")
        player:sendTextMessage(ORANGE, "Fixed more tutorial rooms...")
    end
    
    if onceOnLogin(player, 50) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.5")
        player:sendTextMessage(ORANGE, "Improved empire event map")
        player:sendTextMessage(ORANGE, "Added reward chests on the empire map")
    end
    
    if onceOnLogin(player, 51) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.6")
        player:sendTextMessage(ORANGE, "Improved empire event map")
        player:sendTextMessage(ORANGE, "Added Battle Royale map (only for testing, maybe in future it will be an event)")
    end

    if onceOnLogin(player, 52) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.7")
        player:sendTextMessage(ORANGE, "added over 1700 randomly generated monsters to Empire Event")
        player:sendTextMessage(ORANGE, "Improved Battle Royale system")
        player:sendTextMessage(ORANGE, "Reworked weapons")

        if player:getName():lower() == "gerh" then
            player:sendTextMessage(BLUE, "command !godmode annab sulle god powers")
            player:sendTextMessage(BLUE, "command !c viskab brief description millised commandid sul on")
        end
    end

    if onceOnLogin(player, 53) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.8")
        player:sendTextMessage(ORANGE, "Added equipment items to Battle Royale Event")
        player:sendTextMessage(ORANGE, "Improved Battle Royale Event map")
        player:sendTextMessage(ORANGE, "Fixed direct item receiving")
    end

    if onceOnLogin(player, 54) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.2.9")
        player:sendTextMessage(ORANGE, "npc shops now working")
        player:sendTextMessage(ORANGE, "fixed wand shot animations")
        player:sendTextMessage(ORANGE, "tutorial poles now attack")
        player:sendTextMessage(ORANGE, "created rune system for Battle Royale Event")
    end
    
    if onceOnLogin(player, 55) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.3")
        player:sendTextMessage(ORANGE, "Battle Royale is ready")
        
        player:removeSV(empireConf.empireCharIDSV)
        player:removeSV(SV.empireTester)
        player:removeSV(11849)
    end
    
    if onceOnLogin(player, 56) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.3.1")
        player:sendTextMessage(ORANGE, "Updated Battle Royale and fixed several bugs")
    end

    if onceOnLogin(player, 57) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.3.1.2")
        player:sendTextMessage(ORANGE, "silent update with few bug fixes")
    end

    if onceOnLogin(player, 58) then
        player:sendTextMessage(BLUE, "Patch 0.1.6.3.2")
        player:sendTextMessage(ORANGE, "fixed crashing bug for Battle Royale event")
        player:sendTextMessage(ORANGE, "So many fixes, starting from damage system ending with shop items")
        player:sendTextMessage(ORANGE, "look for patch notes on website if you want more details")
    end
end