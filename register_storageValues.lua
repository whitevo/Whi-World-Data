SV = {
--- RANDOM STUFF
default = 10000,                -- to get just value 1
startingItems = 10000,          -- 
--
tutorialKey = 10002,            -- key from sand digging room to open up the door there.
hardcoreLives = 10003,          -- stores player Hardcore Lives.
BanditMountain = 10004,         -- Has player found Bandit Mountain?
CyclopsDungeon = 10005,         -- Has player found Cyclops Dungeon?
missionsQuestlog = 10006,       -- Questlog category missions.
tasksQuestlog = 10007,          -- Questlog category tasks.
questsQuestlog = 10008,         -- Questlog category quests.
fireDam = 10009,                -- COMBAT_FIREDAMAGE
iceDam = 10010,                 -- COMBAT_ICEDAMAGE
deathDam = 10011,               -- COMBAT_DEATHDAMAGE
energyDam = 10012,              -- COMBAT_ENERGYDAMAGE
physicalDam = 10013,            -- COMBAT_PHYSICALDAMAGE
earthDam = 10014,               -- COMBAT_EARTHDAMAGE
speedBallPoints = 10015,        -- stores minigame SpeedBall points
speedBallArmor = 10016,         -- does player have speedBall Armor?
speedBallBonus = 10017,         -- does player have speedBall Bonus?
ArchanosRespawn = 10018,        -- Archanos Boss Room respawn
BigDaddyRespawn = 10019,        -- Big Daddy Boss Room respawn
BorthonosRespawn = 10020,       -- Borthonos Boss Room respawn
purifyingMallet_cd = 10021,     -- the base cooldown in seconds before item can be used again
purifyingMalletCD = 10022,      -- mallet cooldown
bossesQuestlog = 10023,         -- Questlog category bosses.
onceOnLogin = 10024,            -- to modify characters as they log in.
Hehemi = 10025,                 -- Has player found Bandit Mountain2? (Hehemi)
skillTreeShowTiers = 10026,     -- 1 == ON / -1 == OFF
weapon_scabbard_A = 10027,      -- 1 == ON / -1 == OFF checks if already active.
shadowRoomRespawn = 10028,      -- Shadow Boss Room respawn
kamikazePants_explosion = 10029,-- barrier explosion percent
bianhuren = 10030,              -- item equipped
tonkaHerbs = 10031,             -- value 1 == tonka herb info button.
liamDiary = 10032,              -- secret where players can trade diary to liam.
cyclopsStashQuestHint = 10033,  -- secret where players can trade diary to liam.
bridgeHints = 10034,            -- 1 == smith teaches how to build bridge.
showCompletedQuestlog = 10035,  -- 1 == does NOT show completed missions, quests, tasks.
taskerRep = 10039,              -- collects all the reputation earned towards task master
taskerRepL = 10040,             -- the level of tasker reputation
furBagBonus = 10041,            -- doubles the paw drop chance.
cookRep = 10042,                -- collects all the reputation earned towards cook
cookRepL = 10043,               -- the level of cook reputation
tannerRep = 10044,              -- collects all the reputation earned towards tanner
tannerRepL = 10045,             -- the level of tanner reputation
priestRep = 10046,              -- collects all the reputation earned towards priest
priestRepL = 10047,             -- the level of priest reputation
smithRep = 10048,               -- collects all the reputation earned towards smith
smithRepL = 10049,              -- the level of smith reputation
challengeID = 10050,            -- holds challengeID if player is in one
forestChallenge = 10051,        -- How many waves has player completed
dummyNerf = 10052,              -- When dieing to dummy who has less than 50% health dummyNerf will be increased by 1
extraInfo = 10054,              -- shows extra(tutorialish info about everything) if value is -1
banditChallenge = 10055,        -- How many waves has player completed
playerIsDead = 10056,           -- 1 == player takes no damage
silenced = 10057,               -- 1 == player cant cast spells
lootbagFromWagon = 10058,       -- 1 == player got loogbag from desert border inside wagon
heyHintTrigger = 10059,         -- 1 == peeter will say that hey burns :D
monsterHaste = 10060,           -- stacks the player speed if haste given by monsters
monsterSlow = 10061,            -- stacks the player speed if slow given by monsters
ghostTP = 10062,                -- if ghost teleport player then for short while his immune to it
fluteMissionHint = 10066,       -- 1 == smith tells you how to open flute chest
PVPEnabled = 10067,             -- 1 == enabled
oneVone = 10069,                -- 1v1 elo
arenaRegN = 10070,              -- positive numbers means that player is fighting in ranked arena and the number means the registration ID
arenaPoints = 10071,            -- arena points to buy PVP items
tutorial = 10072,               -- tutorial with stages. [stage guide in npc > scripts > tutorial.lua] [47 = completed]
lookDisabled = 10073,           -- 1 = custom look scripts wont activate
npcLookDisabled = 10075,        -- 1 = looking npc wont give MW
disableCombat = 10077,          -- 1 = cant target creatures
checkPoint = 10078,             -- each value represents position where player is spawned on death.
tutorial_shop = 10079,          -- changed leather armor cost value.
tutorial_escapeButton = 10080,  -- tutorial NPC will have extra button which returns player to prep room.
tutorial_iceRes = 10081,        -- ice resitance gained from tutorial ice hammer (used on leather armor)
tutorial_fireRes = 10082,       -- fire resitance gained from tutorial fire hammer (used on leather armor)
lastHit = 10083,                -- os.time() | if player deals dmg then he cant log off for x seconds
lastDmg = 10084,                -- os.time() | if player takes dmg then he cant log off for x seconds
tutorialBossRoomFloor = 10085,  -- the bossroom floor z index where player is teleported when enters bossRoom again.
recipeBookLearned = 10086,      -- 1 == can see reicpes by looking themself
dummyRewards = 10087,           -- -1 = leather legs, 0 = leather legs + leather cap, 1 = leather legs + leather cap + extra speed leather boots.
smithUrranelInfo = 10088,       -- 0 = not paid the fee, 1 = paid for damgeges
CD_teleportCharge = 10089,      -- 1 == has charge
BM_teleportCharge = 10090,      -- 1 == has charge
H_teleportCharge = 10091,       -- 1 == has charge
activityChart = 10092,          -- stores last logged in INT (per account)
nami_bootsFromPool = 10093,     -- in cursed bear quest
WC_teleportCharge = 10094,      -- 1 == has charge
cursedBearHint_bearKill = 10095,-- 1 == knows how to kill bear
lootBagFromTutorialMonument = 10096,-- 1 == found lootbag
deathProtection = 10097,        -- 1 == doesn't loose HC life
lastDeathTime = 10098,          -- os.time()
lastLogInTime = 11800,          -- os.time()
onlineTime = 11801,             -- in seconds
tradeWindowClosedTime = 11802,  -- os.time()
repellPillarHint = 11803,       -- 1 == "For short distance around this pillar, ghosts will ignore you."
rootedCatacombs = 11804,        -- Has player found Rooted Catacombs?
immortalKamikaze_explosion = 11805,-- barrier explosion deals x% of total barrier as death damage to surrounding creatures
tutorial_hint_click = 11806,    -- 1 == "Click on the the blue tile to automatically walk to it as fast as possible"
jazMazOT = 11807,               -- 1 == jazmaz OT scripts activatd instead of whi world ones
building_tutorialID = 11808,    -- in which tutorial room the player currently is in.
building_tutorialStage = 11809, -- in which tutorial stage the player currently is at.
player_houseID = 11810,         -- if player owns a house then it stores houseID
rentDuration = 11811,           -- how many seconds house is owned
building_noItemsNeeded = 11812, -- 1 == no items needed to build object for house
building_exp = 11813,           -- stores building experience
building_level = 11814,         -- stores building level (usaully gives access to better building items)
player_ignoreDamage = 11815,    -- 1 == player ignores all damages (removed on login)
skipRoomTpFail = 11816,         -- gives hints how to progress skip room
isGod = 11817,                  -- 1 == player:isGod() == true
houseTutorialCompleted = 11818, -- 1 == completed
woodCuttingExp = 11819,         -- stores woodcutting experience
woodCuttingLevel = 11820,       -- stores woodcutting level (increases chance to get more materials at once)
miningExp = 11821,              -- stores mining experience
miningLevel = 11822,            -- stores mining level (improves the chance to get mineral out of mineral rock)
smithingExp = 11823,            -- stores smithing experience
smithingLevel = 11824,          -- stores smithing level (adds more craftable items to crafting table)
recipe_warriorBoots = 11825,    -- 1 == learned
craftingExp = 11826,            -- stores crafting experience
craftingLevel = 11827,          -- stores crafting level (adds more craftable items to crafting table)
cookingExp = 11828,             -- stores cooking experience
cookingLevel = 11829,           -- stores cooking level
brewingExp = 11830,             -- stores brewing experience
brewingLevel = 11831,           -- stores brewing level
enchantingExp = 11832,          -- stores enchanting experience 
enchantingLevel = 11833,        -- stores enchanting level 
enchantingAltarHint = 11834,    -- information how to get magic power from spell scrolls
farmingExp = 11834,             -- stores farming experience 
farmingLevel = 11835,           -- stores farming level 
bomberman_mapID = 11836,        -- in which bomberman map player is playing on
bomberman_bombsLeft = 11837,    -- keeps track of how many bombs player can plant
bomberman_bombPower = 11838,    -- keeps track of how strong is bomb explosion radius
bomberman_speedStack = 11839,   -- keeps track of how many times player speed is stacked
autoLoot_gold = 11840,          -- 1 == every time you step on gold or container with gold, you loot it
autoLoot_howTo = 11841,         -- 1 == player knows how to turn in autoloot
goldBox_mysterArea = 11842,     -- 1 == player has taken lloot from golden box
undeadChallenge = 11843,        -- how far playerd reached with this challenge
demonSkeletonRespawn = 11844,   -- demon skeleton Boss Room respawn
healStealRuneHint = 11845,      -- demon skeleton heal steal rune hint | -1 and 0 is default , 1 is more info
empire_charID = 11846,          -- storage value for player to link them with empire character
empireTester = 11847,           -- 1 means entered empire map as tester
onLookTP = 11848,               -- 1 means you teleport where you look

--- TASKS
deerTask                = 10100,
wolfTask                = 10101,
boarTask                = 10102,
bearTask                = 10103,
banditDruidTask         = 10104,
banditMageTask          = 10105,
banditKnightTask        = 10106,
bandithunterTask        = 10107,
archanosTask            = 10108,
cyclopsTask             = 10109,
bigDaddyTask            = 10110,
whiteDeerTask           = 10111,
deerTaskOnce            = 10112,
wolfTaskOnce            = 10113,
boarTaskOnce            = 10114,
bearTaskOnce            = 10115,
banditDruidTaskOnce     = 10116,
banditMageTaskOnce      = 10117,
banditKnightTaskOnce    = 10118,
bandithunterTaskOnce    = 10119,
archanosTaskOnce        = 10120,
cyclopsTaskOnce         = 10121,
bigDaddyTaskOnce        = 10122,
whiteDeerTaskOnce       = 10123,
banditSorcererTask      = 10124,
banditSorcererTaskOnce  = 10125,
banditRogueTask         = 10126,
banditRogueTaskOnce     = 10127,
banditShamanTask        = 10128,
banditShamanTaskOnce    = 10129,
borthonosTask           = 10130,
borthonosTaskOnce       = 10131,
ghoulTask               = 10132,
ghoulTaskOnce           = 10133,
skeletonTask            = 10134,
skeletonTaskOnce        = 10135,
ghostTask               = 10136,
ghostTaskOnce           = 10137,
SW_task                 = 10138,
SW_taskOnce             = 10139,
mummyTask               = 10140,
mummyTaskOnce           = 10141,
rabbitTask              = 10142,
rabbitTaskOnce          = 10143,

--- MISSIONS
-- tracker starts from 0
wolfMission             = 10200,
boarMission             = 10201,
bearMission             = 10202,
liamMission             = 10203,
liamTracker             = 10204,
talkToPeeterMission     = 10205,
meatpieMission          = 10206,
hamAndSaladMission      = 10207,
furBagMission           = 10208,
furBackpackMission      = 10209,
spearMission            = 10210,
campfireMission         = 10211,
campfireTracker         = 10212,
blueClothMission        = 10213,
brownClothMission       = 10214,
redClothMission         = 10215,
whiteClothMission       = 10216,
vocationPotionMission   = 10217,
vocationPotionTracker   = 10218,
smallStonesMission      = 10219,
vialOfWaterMission      = 10220,
vialOfWaterTracker      = 10221,
yellowClothMission      = 10222,
greenClothMission       = 10223,
dumplingsMission        = 10224,
easterHamMission        = 10225,
delightJuiceMission     = 10226,
antidotePotionsMission  = 10227,
teamPreparationMission  = 10228,
hyperactiveMission      = 10229,
theElders               = 10230,
controllersMission      = 10231,
boneMission             = 10232,
ghoulMission            = 10233,
ghostPowderMission      = 10234,
fluteMission            = 10235,
craftSpearMission           = 10236,
craftSpearMissionTracker    = 10237,
banditMailMission           = 10238,
banditMailMissionTracker    = 10239,
banditMailMission_wagonID   = 10240,
banditMailMission_keyHint   = 10241,
banditMailMission_key       = 10242,
banditMailMission_openedLetter  = 10243, -- 1 == letter opened
banditMailMission_peeterTrust   = 10244, -- 1 == closed letter was brought to peeter
fluteMissionTracker     = 10245,
mummyMission            = 10246,
blessedIronHelmetMission = 10247,
blessedIronHelmetTracker = 10248,
findPeeterMission       = 10249,
findPeeterTracker       = 10250,
findPeeterHint1         = 10251,
findPeeterHint2         = 10252,
findTonkaMission        = 10253,
findTonkaTracker        = 10254,
findTonkaHint1          = 10255,
findTonkaHint2          = 10256,

--- REPEATABLE MISSIONS
-- 10300-10399 on patch 0.1.5


--- QUESTS
banditQuest                 = 10400,
banditQuestTracker          = 10401,
forestSpiritsQuest          = 10402,
forestSpiritsQuestTracker   = 10403,
cyclopsStashQuest           = 10404,
cyclopsStashQuestTracker    = 10405,
BMQuestKey                  = 10407,
archanosKill                = 10409,
bigDaddyKill                = 10410,
whiteDeerKill               = 10411,
borthonosKill               = 10412,
shadowKill                  = 10414,
shadowRoom                  = 10415,
hehemiQuest                 = 10416,
hehemiQuestTracker          = 10417,
banditQuestHint1            = 10418,
forestQuestHint1            = 10419,
forestQuestHint2            = 10420,
cyclopsSabotageQuest        = 10421,
cyclopsSabotageQuestTracker = 10422,
cyclopsSabotageQuestHint1   = 10423,
cyclopsSabotageQuestHint2   = 10424,
lookedCyclopsGate           = 10425,
tonkaQuestTeleport          = 10426,
cyclopsSabotageQuestHint3   = 10427,
cyclopsSabotageQuestHint4   = 10428,
deerSabotage                = 10429,
foodStorageSabotage         = 10430,
KILLEDBOSSTEMP              = 10432, -- BOSS SV xD
dummyKill                   = 10433,
BM_Quest_abducted           = 10434,
BM_Quest_abducted_tracker   = 10435,
cursedBearQuest             = 10437,
cursedBearQuestTracker      = 10438,
rootedCatacombs_questSV     = 10439,
rootedCatacombs_trackerSV   = 10440,
skeletonWarrior_questSV     = 10441,
skeletonWarrior_trackerSV   = 10442,
ghostBless_questSV          = 10443,
ghostBless_trackerSV        = 10444,
ghoulBless_questSV          = 10445,
ghoulBless_trackerSV        = 10446,
ghoulBless_hint             = 10447,
tutorialTracker             = 10448,
cyclopsStashQuestHint2      = 10449,
mummyBless_questSV          = 10450,
mummyBless_trackerSV        = 10451,
mummyBless_hintFromNote     = 10452,
mummyBless_hintFromTanner   = 10453,
treasureHunt_questSV        = 10454,
treasureHunt_trackerSV      = 10455,
treasureHunt_key            = 10456,
treasureHunt_hint1          = 10457,
treasureHunt_hint2          = 10458,
treasureHunt_hint3          = 10459,
treasureHunt_hint4          = 10460,
treasureHunt_hint5          = 10461,
treasureHunt_hint6          = 10462,
treasureHunt_hint7          = 10463,
treasureHunt_hint8          = 10464,
treasureHunt_hint9          = 10465,
treasureHunt_hintFail1      = 10466,
treasureHunt_hintFail2      = 10467,
treasureHunt_hintFail3      = 10468,
treasureHunt_hintFail4      = 10469,
treasureHunt_hintFail5      = 10470,
treasureHunt_hintFail6      = 10471,
treasureHunt_hintFail7      = 10472,
treasureHunt_hintFail8      = 10473,
treasureHunt_hintFail9      = 10474,
treasureHunt_hintFail10     = 10475,
rankedPVP_questSV           = 10476,
rankedPVP_trackerSV         = 10477,
demonSkeletonKill           = 10478,

--- SPELL EFFECTS
barrierSpell    = 10500,
armorUpSpell    = 10501,
rubyDefSpell    = 10502,
opalDefSpell    = 10503,
buffSpell       = 10504,
sapphdefSpell   = 10505,
poisonSpell     = 10506,
fakedeathOutfit = 10507,
onyxdefSpell    = 10509,
innervateSpell  = 10510,
impID           = 10511,
barrierDebuffPercent = 10512,       -- increase damage taken when barrier activated

--- EQUIPMENT ITEMS what buffs/nerfs players directly (or shield gems)
zvoidTurban             = 10611,    -- gives Cap when player has shield
speedzyLegs             = 10612,    -- gives speed when player gets healed
gensoFedo               = 10613,    -- heals players when no ele damage taken
furSet                  = 10614,    -- each value represents how many pieces are equipped (doesn't set value 1 or 0 though)
furSetAnimalLeather     = 10615,    -- adds 20% drop chance to animal leather
furSetFurItems          = 10616,    -- adds 20% drop chance to thick fur and wolf fur
furSetPawItems          = 10617,    -- adds 5% drop chance to 'paw' items
leatherSet              = 10618,    -- each value represents how many pieces are equipped (doesn't set value 1 or 0 though)
leatherSetAS            = 10619,    -- your attack speed is increased by the amount of movement speed you have
fireQuiverDamage        = 10620,    -- your arrows deal extra SV% fire damage
quiverBreakChance       = 10621,    -- ammo breaks SV% less often.
blessedIronHelmet       = 10622,    -- blessed iron helmet (every time you cast spell get 1 armor for 3 seconds. stacks up to 20 armor)
blessedTurban           = 10623,    -- blessed turban (every time you cast spell deal 1% more damage with spells for 3 seconds. stacks up to 20%)
blessedHood             = 10624,    -- blessed hood (every time you cast spell deal 1% more damage with weapons for 3 seconds. stacks up to 20%)
arcaneBoots_mana        = 10625,    -- arcane boots (if your char pays less than x mana then, next non magic weapon hit deals up to extra x energy damage)
zvoidBoots_mana         = 10626,    -- zvoid boots (if your char pays more than x mana then,  next non mage weapon hit up to x damage)
kakkiBoots              = 10627,    -- kakki boots (if your mana is below 25% then you take x% less damage from all sources)
chivitBoots             = 10628,    -- chivit Boots (if your hp is below 25% then you get x% critical hit chance for your weapon hits)
gribitLegs              = 10629,    -- gribit Legs (when gribit shield equipped, players 5 tiles away from you with !buff get 40% earth resistance)
chamakLegs              = 10630,    -- chamak Legs (taunted target deals x% less damage)
stoneLegs               = 10631,    -- stone Legs (While armorup active, you take x% less damage from all sources)
demonicLegs             = 10632,    -- demonic Legs (imp will have same resistance you had when spell was casted. Imp hp is increased x%.)
traptrixCoat            = 10633,    -- traptrix Coat (!trap spell places up to 2 additional traps, all traps damage you)
ghatitkArmor            = 10634,    -- Ghatitk Armor (gem*def heal spell is doubled)
phadraRobe              = 10635,    -- phadra Robe (you can cast innervate to another player)
demonicRobe             = 10637,    -- demonic Robe (while Imp is below 50%, you and imp will get x% damage reduction from all sources)
traptrixQuiver          = 10638,    -- traptrix Quiver (when someone gets caught in trap, refund x% of trap mana)
ghatitkShield           = 10639,    -- ghatitk Shield (while gem*def spell is activated you deal x% more damage with that elemental)
yashimaki_area          = 10640,    -- yashimaki (mend spell heals X extra area | healing adds extra armor for 10 seconds)
demonicShield           = 10641,    -- demonic Shield (Imp boosts your spell damage by additional x%)
warriorHelmet           = 10642,    -- warrior Helmet (strike spell cleaves)
pinpuaHood              = 10643,    -- pinpua Hood (Your critical heal chance is increased by x% of your current crit heal)
kamikazeMask            = 10644,    -- pinpua Hood (barrier explosion deals 100% of total barrier as death damage to surrounding creatures, 
                                    -- x% damage dealt with barrier goes to death resistance for 10 seconds)
snaipaHelmet            = 10645,    -- snaipa Helmet (!volley deals x% more damage)
chokkan                 = 10646,    -- shield (You no longer have to face monsters to shoot with range weapons)
supaky                  = 10647,    -- shield (all gem*def spells are executed at once with any gem*def spell activation)
akujaaku                = 10649,    -- shield (increases spark and death area by 2)
snaipaHelmet_breakChance= 10650,    -- snaipa Helmet (x amount of break chance to arrows)
kamikazeMantle_explosion= 10651,    -- kamikaze mantle (x% barrier explosion damage increase)
kamikazeMantle_damage   = 10652,    -- kamikaze mantle (x amount of damage added to next death spell damage) NB! if death spell doesnt have damage then proc is wasted!!
leatherVest             = 10653,    -- leather vest (gives x amount of bounces to throwaxe)
frizenKilt              = 10654,    -- frizen kilt (slows target based on target speed)
bloodyShirt             = 10655,    -- bloody shirt (regenerates hp while faking death)
goddessArmor            = 10656,    -- goddess armor (healing spells remove root and bind effects)
kamikazeShortPants      = 10657,    -- kamikaze short pants (increase barrier explosion area)
ghatitkLegs             = 10658,    -- ghatitk legs (each melee weapon hit increases you resistance of same type as your weapon deals. buff lasts 3 sec and stacks up to x%)
shimasuLegs             = 10659,    -- shimasu legs (resisted death damage is added to your barrier)
shimasuLegs_barrier     = 10660,    -- holds the barrier amount collected by procs
ghatitkLegs_regTime     = 10661,    -- os.time() when stack was registered
blessedTurban_stack     = 10662,    -- holds total % increase
blessedHood_stack       = 10663,    -- holds total % increase
blessedIronHelmet_armor = 10664,    -- holds total armor
kamikazeMask_explosionDam = 10665,  -- head, barrier explosion deals x% of total barrier as death damage to surrounding creatures
stoneShield_damageTaken = 10666,    -- amount of damage taken while armorup is active
kamikazeMantle_percent  = 10667,    -- kamikaze mantle (x% amount damage added to kamikazeMantle_damage)
speedzyLegs_duration    = 10668,    -- speedzy legs speed condition x second duration
intrinsicLegs           = 10669,    -- intrinsic Legs (every time you resist x% from elemental damage source, gain 1 mana)
zvoidBoots_proc         = 10670,    -- zvoid boots | if 1 then procs zvoidBootsDamage()
zvoidBoots_damage       = 10671,    -- zvoid boots (if your char pays more than x mana then, next non mage weapon hit up to x damage)
arcaneBoots_damage      = 10672,    -- arcane boots (if your char pays less than x mana then, next non magic weapon hit deals up to extra x energy damage)
arcaneBoots_proc        = 10673,    -- arcane boots | if 1 then procs arcaneBootsDamage()
atsuiKori_fire          = 10674,    -- heat spell will do additonal x% ICE damage and shiver spell will do additional x% FIRE damage
yashimakiArmor          = 10675,    -- healing spells give extra armor for 10 seconds

--- ITEMS what improve SPELLS  (pretty much same thing as equipment....)
kaijuWall               = 10700, -- kaiju wall (more barrier to barrier spell)
atsuiKori_ice           = 10701, -- heat spell will do additonal x% ICE damage and shiver spell will do additional x% FIRE damage
zvoidShield             = 10702, -- zvoid shield (increases resistance by x)
thunderBook             = 10703, -- thunder book (increases elemental damage x%)
arogjaHat               = 10704, -- arogja hat (barrier spell gives hp on break)
namiBoots               = 10705, -- the nami boots (some spells turn into waves, mana cost increased) [heat, shiver, sparks, deaths]
shikaraNankan           = 10706, -- shikara nankan (x% from barrier foes to armor)
precisionRobe           = 10707, -- precision robe (Your spell radius is increased by 1) [strike, shiver, heat]
stoneShield             = 10708, -- stone shield (While armorup is active and you take total x damage, refund !armorup manacost on breakdown)
stoneArmor              = 10709, -- stone armor (While armorup is active and you take physical damage, heal yourlself for shielding skill times 2)
yashinuken_area         = 10710, -- yashinuken (USE: If you have yashiteki equipped, you can Toggle OFF healing monsters with mend spell. mend spell heals 1 extra area)
yashiteki_area          = 10711, -- yashiteki  (mend spell heals 1 extra area)
yashinuken              = 10712, -- yashinuken (yashinuken combo trigger ON)
warriorBoots            = 10713, -- warrior boots (while !armorup is active, !strike costs x mana)
gribitShield            = 10714, -- gribit shield (!buff goes to all players around you)
bianhurenReflect        = 10715, -- bianhuren (Your next !buff spell will gain extra effect: reflects physical damage, but duration is reduced by 30 minutes)
amanitaHat              = 10716, -- amanita hat (death damage adds 5% life back from damage done)

--- STATS
armor                       = 10800,    -- player ARMOR from spells? (idk kinda already have it...)
skillpoints                 = 10801,    -- How many available skillpoints player has?
magicSkillpoints            = 10802,    -- how many points spent?
weaponSkillpoints           = 10803,    -- skillpoints spent on weapons tree
distanceSkillpoints         = 10804,    -- skillpoints spent on distance tree
shieldingSkillpoints        = 10805,    -- skillpoints spent on shielding tree
fistfightingSkillpoints     = 10806,    -- skillpoints spent on fistFighting tree
stunResistanse              = 10807,    -- ??
thunderstruck               = 10808,    -- talent
juicy_magic                 = 10809,    -- talent
measuring_mind              = 10810,    -- talent
measuring_soul              = 10811,    -- talent
accuracy                    = 10812,    -- talent
hit_and_run                 = 10813,    -- talent
power_of_love               = 10814,    -- talent
weapon_scabbard             = 10815,    -- talent
furbish_wand                = 10816,    -- talent
mental_power                = 10817,    -- talent
liquid_fire                 = 10818,    -- talent
green_powder                = 10819,    -- talent
sharpening_weapon           = 10820,    -- talent
crushing_strength           = 10821,    -- talent
tactical_strike             = 10822,    -- talent
bladed_shield               = 10823,    -- talent
bladed_armor                = 10824,    -- talent
mediation                   = 10825,    -- talent
spell_power                 = 10826,    -- talent
extraEnergyDamage           = 10827,    -- damage what is added on top energy damage made with spells (or energy hits)
extraFireDamage             = 10828,    -- damage what is added on top fire damage made with spells (or energy hits)
extraEarthDamage            = 10829,    -- damage what is added on top earth damage made with spells (or energy hits)
extraDeathDamage            = 10830,    -- damage what is added on top death damage made with spells (or energy hits)
extraIceDamage              = 10831,    -- damage what is added on top ice damage made with spells (or energy hits)
tempPhysicalResistance      = 10832,    -- resistance against physical damage
tempFireResistance          = 10833,    -- resistance against fire damage
tempIceResistance           = 10834,    -- resistance against ice damage
tempEnergyResistance        = 10835,    -- resistance against energy damage
tempDeathResistance         = 10836,    -- resistance against death damage
tempEarthResistance         = 10837,    -- resistance against earth damage
foodArmor                   = 10838,    -- gives temporar armor from food
extraPhysicalDamage         = 10839,    -- damage what is added on top physical damage made with spells (or energy hits)
kamikazeMaskResistance      = 10841,    -- death resistance from barrier explosion
wisdom                      = 10842,    -- talent
demon_master                = 10843,    -- talent
dark_powers                 = 10844,    -- NO LONGER IN USE (although cant remove beacuse some unlogged ppl might still have it)
elemental_strike            = 10845,    -- talent
lucky_strike                = 10846,    -- talent
undercut                    = 10847,    -- talent
power_throw                 = 10848,    -- talent
steel_jaws                  = 10849,    -- talent
sharpening_projectile       = 10850,    -- talent
wounding                    = 10851,    -- talent
archery                     = 10852,    -- talent
sharp_shooter               = 10853,    -- talent
skilled                     = 10854,    -- talent
momentum                    = 10855,    -- talent
lucky_strike_crit           = 10856,    -- talent activator
undercut_crit               = 10857,    -- talent activator
cursedBearQuest_undeadRes   = 10858,    -- undead resistance
elemental_powers            = 10859,    -- talent
crushing_strength_cd        = 10860,    -- stores cooldown time

--- SPELLS
armorup         = 10900,
strike          = 10901,
rubydef         = 10902,
heal            = 10903,
heat            = 10904,
shiver          = 10905,
spark           = 10906,
barrier         = 10907,
death           = 10908,
opaldef         = 10909,
trap            = 10910,
poison          = 10911,
buff            = 10912,
godhammer       = 10913,
fakedeath       = 10914,
volley          = 10915,
dispel          = 10916,
mend            = 10917,
sapphdef        = 10918,
throwaxe        = 10919,
taunt           = 10920,
onyxdef         = 10921,
innervate       = 10922,
imp             = 10923,
tutorialSpell1  = 10924,
tutorialSpell2  = 10925,
tutorialSpell3  = 10926,

--- CONSUME what buffs/nerfs players directly
druidPotion_buff        = 11000,    -- Your spells cost VALUE% less mana(rounded upwards)
hunterPotion_buff       = 11001,    -- Each physical hit will apply poison for 5sec and it deals VALUE earth damage per sec. Stacks 10 times.
hunterPotion_nerf       = 11002,    -- Each time you make physical damage, you loose VALUE speed for 10sec. Stacks 10 times.
magePotion_buff         = 11003,    -- Gain aura around you. Deals (VALUE + mL*6 + L*8) energy damage per second (distance 1 tile).
knightPotion_buff       = 11004,    -- Physical weapon damage deals VALUE fire damage on each hit.
knightPotion_nerf       = 11005,    -- You loose VALUE armor on each weapon hit for 8 seconds. Stacks Infinitely.
delightJuiceBuff        = 11007,    -- speed increase
mummyDollBuff           = 11009,    -- adds ice damage once to melee weapon hit
vampireDollBuff         = 11010,    -- adds fire damage once to melee weapon hit
antidotePotion_nerf     = 11011,    -- for next 20 seconds you take x% more elemental damage.
easterHamCap            = 11012,    -- adds extra cap to player after eating easter ham dish
dumplingsArmor          = 11013,    -- adds extra armor after eating dumplings dish
flashPotion_buff        = 11014,    -- adds extra speed to player after taking the potion.
knightPotion_armor      = 11015,    -- amount of how much armor is reduced
silencePotion_buff      = 11016,    -- x% chance to silence target for 1 second with weapon hit (except wands) 
spellcasterPotion_buff  = 11017,    -- every time your damage spell hits, heal yourself by x hp, 
spellcasterPotion_buffTime = 11018, -- os.time() when effect ends
silencePotion_buffTime  = 11019,    -- os.time() when effect ends
flashPotion_buffTime    = 11020,    -- os.time() when effect ends
druidPotion_buffTime    = 11021,    -- os.time() when effect ends
hunterPotion_buffTime   = 11022,    -- os.time() when effect ends
magePotion_buffTime     = 11023,    -- os.time() when effect ends
knightPotion_buffTime   = 11024,    -- os.time() when effect ends
antidotePotion_nerfTime = 11025,    -- os.time() when effect ends
spellcasterPotion_nerfTime = 11026, -- os.time() when effect ends
spellcasterPotion_nerf  = 11027,    -- your spells cost x% more mana (rounded upwards)
silencePotion_nerf      = 11028,    -- all elemental resitances are lowered by x%
silencePotion_nerfTime  = 11029,    -- os.time() when effect ends
druidPotion_nerf        = 11030,    -- VALUE% of spell cost is taken from health instead(rounded upwards).
druidPotion_nerfTime    = 11031,    -- os.time() when effect ends
hunterPotion_nerfTime   = 11032,    -- os.time() when effect ends
magePotion_nerf         = 11033,    -- loose VALUE% of your total mana pool.
magePotion_nerfTime     = 11034,    -- os.time() when effect ends
knightPotion_nerfTime   = 11035,    -- os.time() when effect ends
knightPotion_armor      = 11036,    -- total armor reduction
knightPotion_stacks     = 11037,    -- holds stack count
knightPotion_armorTime  = 11038,    -- when stack was last placed os.time()
flashPotion_nerfTime    = 11039,    -- os.time() when effect ends
hunterPotion_damageStack= 11040,    -- stack count
hunterPotion_damageTime = 11041,    -- os.time() when stack was registered
hunterPotion_slowStack  = 11042,    -- stack count
dumplingsTime           = 11043,    -- os.time() when food was eaten
easterHamTime           = 11044,    -- os.time() when food was eaten
delightJuiceTime        = 11045,    -- os.time() when food was eaten
speedPotion_buff        = 11046,    -- Your speed will be increased by VALUE
speedPotion_buffTime    = 11047,    -- os.time() when effect ends
speedPotion_nerf        = 11048,    -- You loose VALUE armor
speedPotion_nerfTime    = 11049,    -- os.time() when effect ends
flashPotion_nerf        = 11050,    -- reduces weapon maximum damage by VALUE

--- RECIPES     -- Value meaning: -1 = dont know recipe, 0 = first part hint, 1 = second part hint, 2 = recipe learned.
dumplings               = 11107,
easterHam               = 11108,
delightJuice            = 11109,
druidPotionRecipe       = 11110,    -- Stranth + Eaplebrond
hunterPotionRecipe      = 11111,    -- Oawildory + dagosil
magePotionRecipe        = 11112,    -- Eaddow + urreanel
knightPotionRecipe      = 11113,    -- Jesh Mint + iddunel
antidotePotionRecipe    = 11114,    -- Eaplebrond + Mobberel
flashPotionRecipe       = 11115,    -- flysh + iddunel
silencePotionRecipe     = 11116,    -- xuppeofron + eaplebrond
spellcasterPotionRecipe = 11117,    -- shadily gloomy shroom + urreanel
speedPotionRecipe       = 11118,

--- loot first time Storage
b_druid         = 11200,
b_hunter        = 11201,
wolf            = 11202,
b_mage          = 11203,
b_knight        = 11204,
rabbit          = 11205,
dummy           = 11206,
deer            = 11207,
boar            = 11208,
bear            = 11209,
b_rogue         = 11210,
b_shaman        = 11211,
b_sorcerer      = 11212,
cyclops         = 11213,
white_deer      = 11214,
archanos        = 11215,
borthonos       = 11216,
big_daddy       = 11217,
shadow          = 11218,
skeleton        = 11219,
ghoul           = 11220,
ghost           = 11221,
skeletonWarrior = 11222,
mummy           = 11223,
demonSkeleton   = 11224,

--- herb info knowledge [-1 dont know || 0 about to find out || 1 knows and about to tell tonka || 2 knows and registered info registrated]
stranth             = 11300,
oawildory           = 11301,
eaddow              = 11302,
jesh_mint           = 11303,
eaplebrond          = 11304,
golden_spearmint    = 11305,
brirella            = 11306,
dagosil             = 11307,
ozeogon             = 11308,
urreanel            = 11309,
iddunel             = 11310,
mobberel            = 11311,
xuppeofron          = 11312,
shadilyGloomyShroom = 11313,
flysh               = 11314,


--- KEYS         -- -1 == dont have key, 0 == has key but not used yet, 1 == key used for something successfully
dummyKey = 11400,               -- from dummy
banditQuestKey = 11401,         -- from bandit quest
cyclopsQuestKey = 11402,        -- key near cyclops dungeon
hehemiQuestKey = 11403,         -- Found on Hehemi Spiral Roof (top level of Hehemi Town)
shadowRoomKey = 11404,          -- Found in Forgotten Village
tutorial_doorRoomKey = 11405,   -- Found in tutorial

--- REP                (the value amount means the amount of times player has brought the item to npc for rep)
carrot = 11500,
meat = 11501,
ham = 11502,
apple = 11503,
blueberry = 11504,
animal_leather = 11505,
wolf_fur = 11506,
thick_fur = 11507,
bear_paw = 11508,
wolf_paw = 11509,
rabbit_foot = 11510,
eaplebrondRep = 11511,
goldenSpearmintRep = 11512,
brirellaRep = 11513,
dagosilRep = 11514,
ozeogonRep = 11515,
urreanelRep = 11516,
iddunelRep = 11517,
mobberelRep = 11518,
flyshRep = 11519,
shadilyGloomyShroomRep = 11520,
xuppeofronRep = 11520,

-- 11600 - 11700 are automaitcally generated with temporary PVP items.
-- 11800 - 11999 used by general things

--- NPC chat
task_master1 = 30000,   -- who are you?
task_master2 = 30001,   -- What do you do?
task_master3 = 30002,   -- Can I help you with something?
task_master4 = 30003,   -- What is this place?
task_master5 = 30004,   -- What happened here?
task_master6 = 30005,   -- What started in Forgotten Village 5 years ago? 
task_master7 = 30006,   -- What is Undead Army?
task_master8 = 30007,   -- Where is Undead Army?
tanner1 = 30008,        -- who are you?
tanner2 = 30009,        -- What do you do?
tanner3 = 30010,        -- Can I help you with something?
tanner4 = 30011,        -- What is this place?
tanner5 = 30012,        -- What happened here?
tanner6 = 30013,        -- Yes, I want to know your story, what happened in Forgotten Village
tanner7 = 30014,        -- What is the name of the Father?
priest1 = 30015,        -- who are you?
priest2 = 30016,        -- What do you do?
priest3 = 30017,        -- Can I help you with something?
priest4 = 30018,        -- What is this place?
priest5 = 30019,        -- What happened here?
priest6 = 30020,        -- What do you mean?
cook1 = 30021,          -- who are you?
cook2 = 30022,          -- What do you do?
cook3 = 30023,          -- Can I get some food?
cook4 = 30024,          -- What is this place?
cook5 = 30025,          -- Why its called Forgotten Village?
cook6 = 30026,          -- What happened here?
cook7 = 30027,          -- Can i get some food?
smith1 = 30028,         -- who are you?
smith2 = 30029,         -- What do you do?
smith3 = 30030,         -- Can I get some weapons or tools?
smith5 = 30033,         -- What is this place?
smith6 = 30034,         -- What happened here?
tonka1 = 30035,         -- who are you?
tonka2 = 30036,         -- You here alone?!
tonka3 = 30037,         -- Even still, need any help with something?
tonka4 = 30038,         -- What is this place?
tonka5 = 30039,         -- Does it mean cyclopses live on this mountain?
tonka6 = 30040,         -- Any clues how to fight cyclopses?
tonka7 = 30041,         -- What do you know about Forgotten Village?
peeter1 = 30042,        -- who are you?
peeter2 = 30043,        -- What do you do?
peeter3 = 30044,        -- Can I help you with that?
peeter4 = 30045,        -- What is this place?
peeter5 = 30046,        -- Why its called Bandit Mountain?
peeter6 = 30047,        -- Why are bandits here?
peeter7 = 30048,        -- What do you know about Forgotten Village?
liam1 = 30049,          -- Who are you?
liam2 = 30050,          -- What are you doing here?
liam4 = 30052,          -- What is this place?
liam5 = 30053,          -- What do you know about Hehem?
tonka8 = 30054,         -- Anything cool we can do around here?
tonka9 = 30055,         -- Can you help me to make a potion?
annoyingNPC1 = 30056,   -- hello
annoyingNPC2 = 30057,   -- Can you let me pass?
priest7 = 30058,        -- Is there anything you need help with Niine?
priest8 = 30059,        -- Any more of special herbs I should know about?
priest9 = 30060,        -- How are you feeling today Niine?
smith7 = 30061,         -- Do you have some kind of tools to open steel gates?
smith8 = 30062,         -- Well.. in Cyclops Dungeon there is pretty heavy Steel Bars and I kinda need to get to other side
peeter8 = 30063,        -- How is it going?
tutorialNPC1 = 30065,   -- This choice is usually a question or conversation you ask from NPC, press ENTER to choose it
tutorialNPC2 = 30066,   -- Look bottom of screen, the NPC talks back there! press ENTER AGAIN if you understand.
smith9 = 30067,         -- What you know about gems?
priest10 = 30068,       -- "Can you tell me more about magic?",

--- TNT SPELLS
cure = 31000,
greatCure = 31001,
prismStrike = 31002,
prismShot = 31003,
prismBeam = 31004,
regen = 31005,
scorch = 31006,
sear = 31007,
flare = 31008,
flamewalk = 31009,
fireball = 31010,
fierySpiral = 31011,
implosion = 31012,
incinerate = 31013,
inferno = 31014,
phoenix = 31015,
icicles = 31016,
chillsong = 31017,
iceWave = 31018,
frostbite = 31019,
freezingCone = 31020,
frigidFinale = 31021,
terabane = 31022,
ashBlast = 31023,
serenity = 31024,
envenom = 31025,
spiritualImbue = 31026,
shelter = 31027,
stonning = 31028,
groveShield = 31029,
pulverize = 31030,
wrath = 31031,
smite = 31032,
atonement = 31033,
tranquiling = 31034,
mendingTouch = 31035,
enthrall = 31036,
holyFire = 31037,
sanctuary = 31038,
purgatory = 31039,
rapture = 31040,
pain = 31041,
menace = 31042,
deathBeam = 31043,
wither = 31044,
curseOfBlood = 31045,
torment = 31046,
curseOfFilth = 31047,
impale = 31048,
vampiricTouch = 31049,
jolting = 31050,
lightningTouch = 31051,
lightningOrbs = 31052,
meteorShower = 31053,
unleash = 31054,
thunderstorm = 31055,
overload = 31056,
currentLightning = 31057,
shatteringArrow = 31058,
multishot = 31059,
piercingShot = 31060,
frostStrike = 31061,
rampage = 31062,
pointBlancShot = 31063,
barrage = 31064,
heatShot = 31065,
bombardement = 31066,
arrowFury = 31067,
berserk = 31068,
fierceBerserk = 31069,
groundshaker = 31070,
divineHealing = 31071,
holyStrikes = 31072,
etheralSwing = 31073,
giantEtheralSwing  = 31074,
}

-- conditions SUB ID's
-- NB!! these are not actually SUB ID's they are condition ID's
--[[ lets not debuff anything with SUBID less than 100
    ST_ == skill tree
    NB!! key for value must be UNIQUE
]]
SUB = {
    INVISIBLE = {
        invisible = {
            invisible = 1,
        }
    },
    
    HASTE = {
        speed = {
            legsHaste = 1,
            headHaste = 2,
            bootsHaste = 3,
            bodyHaste = 4,
            weaponHaste = 5,
            ["leather set"] = 6,
            speedStone = 7,
            tempSpeed = 8,
            bomberman_speed = 9,
            minigame = 100,
            monsterHaste = 101,
            ST_hit_and_run = 102,
            speedSpice = 103,
            speedzyLegs = 104,
            armorUp = 105,
            flashPotion = 106,
            speedPotion = 107,
        }
    },
    
    SLOW = {
        speed = {
            monsterSlow = 100,
            throwAxe = 101,
            hunterPotionSlow = 102,
            hunterTrap = 103,
            ST_wounding = 104,
            bearPuke = 105,
            frizenKilt = 106,
            royale_slow = 108,
        }
    },
    
    REGEN = {
        regen = {
            foodHP = 1,
            foodMP = 2,
        }
    },
    ATTRIBUTES = {
        attributes = {
            delightJuice = 110,
            magePotion_maxMP = 111,
            ST_juicy_magic = 29,
            gems2 = 30,
        },
        skills = {
            -- removeSkills = 1, start with no skills
            weaponSkill = 2,
            magicSkill = 3,
            shieldingSkill = 4,
            distanceSkill = 5,
            fistSkill = 6,
            shield = 10,
            legs = 11,
            head = 12,
            boots = 13,
            body = 14,
            weapon = 15,
            bagUpgrade = 16,
            quiver = 17,
            ST_wisdom = 27,
            ST_skilled = 28,
            seaCounselorMagic = 100,
        },
    },
    
    DOT_FIRE = {
        dot = {
            fire = 100,
        }
    },
    
    DOT_EARTH = {
        dot = {
            earth = 100,
            hunterPotionDamage = 101,
        }
    },
    DOT_PHYSICAL = {
        dot = {
            physical = 100,
        }
    },
    
    DOT_DEATH = {
        dot = {
            death = 100,
        }
    }
}

MW = {
    keyChain = 2000,
    spellBook = 2002,
    spellInfo = 2003,
    cookBook = 2005,
    skillTree = 2007,
    skillTree_magic = 2008,
    skillTree_weapon = 2009,
    skillTree_distance = 2010,
    skillTree_shielding = 2011,
    skillTree_talents = 2012,
    npc = 2016,
    npc_tonkaHerbs = 2018,
    npc_tonkaHerbList = 2019,
    progressLog = 2020,
    questlog = 2021,
    missionLog = 2022,
    bossLog = 2023,
    taskLog = 2024,
    tempSkills = 2026,
    reputation = 2033,
    challengeEvent = 2034,
    cookRep = 2035,
    tannerRep = 2036,
    tannerShop = 2037,
    playerConfig = 2038,
    god_createPotion = 2039,
    god_createHerb = 2040,
    priestRep = 2041,
    sabotageQuestMW = 2043,
    drinkingGame = 2044,
    drinkingGame_leastDrinks = 2045,
    drinkingGame_mostDrinks = 2046,
    drinkingGame_kick = 2049,
    playerPanel = 2050,
   -- rankedPVP = 2051, 
  --  tempPVP_window = 2052,
  --  tempPVP_items = 2053,
   -- tempPVP_equip = 2054,
    createSpell = 2055,
    spellFormulas = 2056,
    herbBag = 2057,
    gemBag = 2058,
    tempWindow1 = 2060,
    tempWindow2 = 2061,
    tempWindow3 = 2062,
    tempWindow4 = 2063,
    homeTP = 2064,
    durationBuffs = 2065,
    openItemList = 2066,
    headItems = 2067,
    shieldItems = 2068,
    bodyItems = 2069,
    legsItems = 2070,
    bootsItems = 2071,
    arrowsItems = 2072,
    weaponItems = 2073,
    bagItems = 2074,
    god_createStones = 2075,
    cyclopsSabotageQuest = 2076,
    bossHighscores = 2077,
    quiverItems = 2078,
    equipmentTokens = 2079,
    shop = 2080,
    shop_buy = 2081,
    shop_sell = 2082,
    houseBuy = 2083,
    building_itemList = 2084,
    building_itemGroup = 2085,
    building_tutorial_itemGroup = 2086,
    building_destroyList = 2087,
    houseMW = 2088,
    house_owners = 2089,
    house_sellOptions = 2090,
    houseOffers = 2091,
    building_wallGroups = 2092,
    god_createGems = 2093,
    god_createFood = 2094,
    god_teleport = 2095,
    god_teleport_toPlayer = 2059,
    god_teleport_toBoss = 2096,
    god_teleport_toNpc = 2097,
    woodCutting = 2098,
    treeCharges = 2099,
    professions = 2100,
    god_createTools = 2101,
    mining = 2102,
    smithing = 2103,
    smithing_other = 2104,
    smithing_equipment = 2105,
    smithing_materials = 2106,
    crafting = 2107,
    crafting_other = 2108,
    crafting_equipment = 2109,
    crafting_materials = 2110,
    enchanting = 2111,
    farming = 2112,
    farming_herbs = 2113,
    farming_trees = 2114,
    enchanting_spellScrolls = 2115,
    enchanting_other = 2116,
    seedBag = 2117,
    god_createSeed = 2118,
    empire_config = 2119,
    royale_mainWindow = 2220,
    royale_itemListWindow = 2221,
    royale_runeWindow = 2222,
    royale_equipmentWindow = 2223,
    royale_bagsWindow = 2224,
    royale_foodWindow = 2225,
    god_createEnvironment = 2226,
    userdataOperations_main = 2227,
    userdataOperations_creature = 2228,
    userdataOperations_item = 2229,
}