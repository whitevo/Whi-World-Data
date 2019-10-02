testServer()                                    -- RETURNS true if this function is executed on test server
-- command functions, god functions
"!dofile data/creaturescripts/scripts/fileName"
"!dofile fileName"                              -- fileName which end with "_" will get word "functons" added

-- game functions
Game.getPlayers()                               -- RETURNS {_ = player}
Game.getMonsters()                              -- RETURNS {_ = monster}
text(msg, position)                             -- RETURNS true / sends orange message to position
doSendMagicEffect(pos, effectT, interval)       -- RETURNS true, can send single effect or effectT (effecT and interval will put delay between each effect)
doSendDistanceEffect(startPos, endPos, effect)  -- sends distance effect
spiralEffect(pos, magicEffect, distanceEffect)  -- send effects in spiral
broadcast(message, messageType or RED)          -- sends a message to all online players
clean_cidList(table, keyIsCid)                  -- if Creature(cid) does not exist then deletes the value from table
Game.convertIpToString()                        -- RETURNS STR
removeItemFromGame(player, itemID)              -- removes item from player and depot
registerAddEvent(ID, key, duration, eventData)  -- ID == table key where to store the events| key = key for the table | eventData = {function, param, ...}
stopAddEvent(ID, key, entireTree)               -- stops addevent | entireTree stops all events under ID
updateAddEvent(ID, key, extratime)              -- adds time to current time left
getAddEvent(creatureID, key)                    -- RETURNS eventT or nil | eventT = {eventID = addEventNumber, regTime = os.time(), duration = msTime, eventData = T, timeLeft = :func()}
antiSpam(ID, tableKey or 0, time or 500)        -- RETURNS false if its a spam / antispamT[tableKey][ID] = boolean
deSpam(playerID)         -- so that equipments and some spam check buffs will trigger on rapid relog
weeklyTaskReset()                               -- weekly task reset
questSystem_startQuestEffect(player)            -- sends magic effects
questSystem_completeQuestEffect(startPos)       -- sends magic effects
centralSystem_registerTable(t)                  -- registers config table to central system
garbageCollection()                             -- RETURNS INT of how many entires were deleted
serverSave_start()                              -- saves server in 3 minutes
serverSave_stage1()                             -- saves server in 1 minute
serverSave_stage2(cleanMap or false)            -- saves server
dofile(path)                                    -- reloads script

-- direction functions
getDirection(startPos, endPos)                  -- RETURNS direction STR from startPos to endPos
getDirectionStrFromCreature(creature)           -- RETURNS direction STR
creature:leftDir()                              -- RETURNS direction STR
creature:rightDir()                             -- RETURNS direction STR
creature:getDirection()                         -- RETURNS direction INT
doTurn(cid, dir)                                -- changes creature direction
turnDirectionRight(dir)                         -- RETURNS direction STR
turnDirectionLeft(dir)                          -- RETURNS direction STR
getDirectionPos(position, direction, distance or 1)  -- RETURNS POS | towards compass direction
reverseDir(directionStr)                        -- RETURNS direction STR
dirToNumber(directionStr)                       -- RETURNS direction INT | E,S,W,N / compasses should be rethought
dirToStr(dir)                                   -- RETURNS direction STR
isDiagonal(fromPos, toPos)                      -- RETURNS true or false / isInArray(compass2, getDirection(pos, endPos))

-- position functions
compass1 = {"E","S","W","N"}
compass2 = {"NW","NE","SW","SE"}
compass3 = {"N","NE","E","SE","S","SW","W","NW"}
--Position(x,y,z) or Position(x=i,y=i,z=i)
--[[ obstacleTable
"hasTile"   - if Tile(pos)
"noTile"    - if Tile(pos) / something weird here, but everything works on this logic
"noGround"  - if not tile:getGround()
"solid"     - if tile:hasProperty(CONST_PROP_BLOCKSOLID)
"creature"  - if tile:getTopCreature()
"player"    - if tile:getTopCreature()
"monster"   - if tile:getTopCreature()
"blockThrow"- if tile:hasProperty(CONST_PROP_BLOCKPROJECTILE)
itemID      - if findItem(itemID, pos)
]]
-- pos = {x=INT, y=INT, z=INT}
generatePositionTable(positions)                    -- RETURNS {pos} out of any position table
removePositions(posT, obstacleTable)                -- RETURNS posT or {}
randomPos(posTable, count or 1, dontExeed, layered) -- RETURNS {{pos1}, {pos2}} | dontExeed = wont give out more positions than there exists in table
getAreaPos(startPos, area, direction)               -- RETURNS {[i] = {pos}} / i = sequence
getTilePath(startPos, tileID)                       -- RETURNS {pos} / starts with startPos and tries to find tileID next to the currentPos expect the old one
frontPos(pos, dir, yards)                           -- RETURNS pos
getAreaAround(pos, distance or 1, cutCornerDistance or 0) -- RETURNS {i, pos} (if distance == 1 then keys are in circle sequence) | cutCornerDistance will remove corner positions
getClosestFreePosition(startPos, distance)          -- RETURNS pos or nil
createSquare(upCorner, downCorner)                  -- RETURNS {_, pos}
createAreaOfSquares(squares)                        -- RETURNS single position table combined with all the squares (doesn't overlap) | if t.allZPos then does all 15 layers
filterArea(filterArea, area, improvement)           -- RETURNS area, only uses positions where improvement is >= of filterArea value in same position compared to area.
limitArea(startPos, area, object, blockDir)         -- RETURNS area, where positions behind object are turned into rootPosition instead. rootPos is usually object position.
blockArea(startPos, area, object, blockDir)         -- RETURNS area, but without the positions what were blocked
getCenterPos(startPos, endPos)         -- RETURNS pos
getPosCorners(pos, distance or 1)      -- RETURNS pos, pos / upCorner, downCorner / distance is radius from pos
getParentPos(object, noPlayer or false)-- RETURNS pos or nil | tile position if its container or player | if noPlayer and parentPos is player then RETURNS nil
getDistanceBetween(fromPos, toPos, ignoreFloors or true)    -- RETURNS INT | distance between positions, z diffrence adds +100
findFromPos(object, positions)         -- RETURNS {cid or item} / objects: "creature", "monster", "player", "npc", itemID, creatureID, creature
findItem(itemID, pos, itemAID)         -- RETURNS item   | needs either itemID or AID
findItems(itemID, pos, itemAID)        -- RETURNS {item} | needs either itemID or AID
findCreature(object, pos)              -- RETURNS creature or nil  | object: cid, "player", "monster", "creature", "npc"
findCreatureID(object, pos)            -- RETURNS creatureID or nil| object: cid, "player", "monster", "creature", "npc"
findByName(positions, name)            -- RETURNS creature
getPath(startPos, endPos, obstacleTable, onlyCheck)         -- RETURNS path = {i, pos} or nil
createPath(startPos, endPos, area, blockedPosT, onlyCheck)  -- RETURNS path = {i, pos} or nil
createObstaclePosT(area, obstacleTable, startPos, endPos)   -- RETURNS blockedPosT = {{[pos.x] = pos},} or nil
pathIsOpen(startPos, endPos, obstacleTable)                 -- RETURNS true if nothing is between startPos and endPos
addIndexPos(t, pos)                     -- RETURNS given table where new position is added if it didn't exist before t = {{[pos.x] = pos},}
testPositions(posT, effect or 20)       -- sends magic effects to all those positions
testPosObstacles(pos)                   -- Uprints ([obstacle] = bool)
hasObstacle(pos, obstacleTable)         -- RETURNS true if positions has this obstacle
comparePositionT(t, pos)                -- RETURNS true if pos is also in the table
samePositions(startPos, endPos)         -- RETURNS true if same positions
isInRange(pos, upCorner, downCorner, allFloors) -- RETURNS true if player is in this position square
removeFromPositions(posT, objectT)      -- massRemove(pos, objectT)
massRemove(pos, objectT)                -- RETURNS true if something was removed / objectT = {"creature", "monster", "player", itemID}

-- database functions | db functions
createQueryStr(tableName, command, queryT)   -- RETURNS STR or nil | commands: 'INSERT', 'CREATE'
DBNumberResultReader(data, keyword, deleteQuery) -- RETURNS number value from given db.storeQuery
getPlayerNameByGUID(guid)           -- RETURNS player name by its character ID
getPlayerVocByGUID(guid)            -- RETURNS player vocation by its character ID
getPlayerLevelByGUID(guid)          -- RETURNS player level by its character ID
getPlayerMagicLevelByGUID(guid)     -- RETURNS player magic level by its character ID
getPlayerShieldLevelByGUID(guid)    -- RETURNS player shielding skill by its character ID
getPlayerSwordLevelByGUID(guid)     -- RETURNS player sword skill by its character ID
getPlayerDistanceLevelByGUID(guid)  -- RETURNS player distance skill by its character ID
getPlayerFistLevelByGUID(guid)      -- RETURNS player fist fighting skill by its character ID
getPlayerClubLevelByGUID(guid)      -- RETURNS player club figting skill by its character ID
getPlayerAxeLevelByGUID(guid)       -- RETURNS player axe fighting skill by its character ID
getPlayerMaxHPByGUID(guid)          -- RETURNS player maxHP by its character ID
getPlayerMaxMPByGUID(guid)          -- RETURNS player maxMP by its character ID
getPlayerDeathTimeByGUID(guid)      -- RETURNS death time name by its character ID
getGuidTByAccID()                   -- RETURNS {_, guid}
getAccountIDByGuid(guid)            -- RETURNS accountID
getGuildIdByName(guildName)         -- RETURNS INT or nil
getGuildLeaderByName(guildName)     -- RETURNS STR or nil
getHigestLevelChar(player)          -- RETURN INT

-- time functions and date functions
getTimeText(seconds, isMilliseconds)    -- RETURNS STR / "INT day(s) INT hour(s) INT minute(s) INT sec"" | if seconds are in milliseconds, put isMilliseconds true
getMonthString(month)           -- RETURNS STR / 1 = "January", 2 = "Februar", etc
getCurrentMonthNumber(modifier) -- RETURNS INT / modifier adds to month
getCurrentMonth(modifier)       -- RETURNS STR / casts number to > getMonthString(month) / modifier adds to month
getCurrentDay(modifier)         -- RETURNS INT / modifier adds to days
getCurrentHour(modifier)        -- RETURNS INT / modifier adds to hours
getCurrentTime()                -- RETURNS os.date():match("%d+%:%d+")
turnToHour(seconds)             -- RETURNS STR / "00:00"
getDayString(day)               -- RETURNS STR / "1st", "2nd", "3rd", "4th", etc
getWeekDay()                    -- RETURNS os.date("%A"):lower()
get_days_in_month(month, year)  -- RETURNS INT

-- table functions
Uprint(t, printName)                        -- prints table keys and values
Vprint(variable, variableName, player)      -- prints variable | if player given then send message to player too
Aprint(t, printName)                        -- prints table keys and values in short form
Tprint(title)                               -- noticeable print
compare(v1, v2)                             -- RETURNS true if either v1 or v2 is false/nil or v1 == v2
getSameTableValue(t1, t2)                   -- RETURNS value | if t1 and t2 has 1 matching value
tableCount(t)                               -- RETURNS amount of keys in table or 0
deepCopy(table)                             -- RETURNS exact copy of table
isInArray(t, value)                         -- RETURNS true or nil | ipairs table
matchTableValue(t, value)                   -- RETURNS true or nil | pairs table
matchTableKey(t, key)                       -- RETURNS true or nil
sortIpairsT(ipairsT, string)                -- RETURNS {_, v}   | "high" [1]=highest value  | "low" = [1]=lowest value
sorting(t, string)                          -- RETURNS {_, k}   | "high" [1]=highest key    | "low" = [1]=lowest key
sortByValue(t, string)                      -- RETURNS {_, v}   | "high" [1]=highest value  | "low" = [1]=lowest value
sortByTableValue(t, string, key)            -- RETURNS {_, {...}} | "high" t[k]=highest value | "low" = t[k]=lowest value
reverseTable(t)                             -- RETURNS {_, v}   | only reverses ipairs tables
isMatrix(t)                                 -- RETURNS the dimensional layer(length)
removeFromTable(t, valueT, maxAmount or 1)  -- RETURNS table || removes values from table || doesnt change the table itself
randomKeyFromTable(t, ignoreList)           -- RETURNS random key from table or nil || with ignoreList you can ignore the keys
randomValueFromTable(t)                     -- RETURNS INT or nil | can be nil or empty table
setTableVariable(t, key, v)                 -- t[key] = v

-- number functions
getRandomNumber(startV, endV, exludeNumberT)    -- RETURNS INT or nil
chanceSuccess(percent)                          -- RETURNS boolean | negative value RETURNS false
percentage(value, percent, ceil)                -- RETURNS INT or 0 [math.floor(damage*percent/100)] | math.ceil if ceil is true | minimum percent = 0
calculate(player, formula)                      -- RETURNS INT value from Whi World formulas
converFormulaToNumbers(player, formula)         -- RETURNS INT / changes keywords to numbers / "mL;sL;dL", etc
round(num, commaPlaces)                         -- RETURNS INT

-- string functions
textToLineT(text)
string:match("%b()")                            -- gets everything between brackets + brackets
stringToLetterT(str)                            -- RETURNS {i, letter}
chooseString(stringT, key or 1)                 -- RETURNS string[key] or "" / converts string to {string}
stringIfMore(string, INT, needINT or 1)         -- RETURNS string if INT is more than needINT
plural(string, amount)                          -- RETURNS string and adds "s" if plural
tableToStr(t, betweenText or ", ", iPairs_or_false)-- RETURNS string | between each value betweenText is used
getMSGDelay(msg)                                -- RETURNS INT | milliseconds how long the message would stay on screen.
addMsgDelayToMsgT(tempMsgT)                     -- RETURNS {[delay] = msg} / delay in milliseconds
string.split(seperator)                         -- RETURNS {_ = str} / table of strings split between each seperator
string.trim()                                   -- ??
string.getINT(sequence or 1)                    -- RETURNS INT / finds numbers from string
string.removeSpaces(fromStart or true, fromEnd or true, all or false)   -- RETURNS str without spaces
MWTitle(str)                                    -- RETURNS str for modal window title / stretches window to maximum
removeBrackets(str)                             -- RETURNS str / without "(" and ")" symbols
activateFunctionStr(str, ...)                   -- can use table of functionStrings
createSpaces(str, stringDistance)               -- RETURNS string with spaces | spaces out string to to line them up.

--[[    combat functions
    damageT = {         table if its passed as damage information
        origin = INT,
        damType = INT,
        damage = INT,
        creatureID = INT,
    }
]]

damageOverTime(creature, damage, damType, interval, effect, formula or "d/2", origin or O_environment, duration) -- formula == STR where "d" represents damage input
removeDOT(creatureID, damType or all)           -- stops dot addevents
doTargetCombatHealth(attacker, target, type, min, max, effect, origin)
doDamage(creatureID, damType, damage, effectOnHit, origin)  -- doTargetCombatHealth(0, creatureID, damType, damage, damage, effectOnHit, origin)
dealDamage(attacker, targetID, damType, damage, effectOnHit, origin, maxRange or 10, flyingEffect) -- origin = O_monster_spells or O_player_spells
dealDamagePos(attacker, pos, damType, damage, effectOnHit, origin or O_environment, spellEffect, effectOnMiss)
heal(creature, amount, effect or nil)           -- RETURNS true if health was added
healPosition(position, amount, effect)          -- RETURNS true if health was added or effect made
criticalHeal(player, amount, onlyCheck)         -- RETURNS amount if critHeal succeeds or 0 | RETURNS crit % if onlyCheck
criticalHit(player, damage, origin, targetPos)  -- RETURNS damage if critical hit succeeds or 0
critBlock(player, def)                          -- RETURNS def if critical block succeeds or 0
root(creatureID, duration or 1000)              -- creature wont be able to move
bind(creatureID, duration or 1000)              -- creature wont be able to move and attack
stun(creatureID, duration or 1000, stunL or 1)  -- creature wont be able to move, attack and cast spells
silence(creatureID, duration or 1000)           -- creature wont be able to cast spells
stunPos(position, duration, stunL or 1)         -- stuns creatures on the position
bindPos(position, duration)                     -- binds creatures on the position
rootPos(position, duration)                     -- roots creatures on the position
removeStun(position)                            -- RETURNS true if removed
removeRoot(position)                            -- RETURNS true if removed
removeBind(position)                            -- RETURNS true if removed
removeSilence(creatureID)                       -- creature will be able to cast spells again
PVP_allowed(player, target)                    -- RETURNS true or nil
isPvpOrigin(origin)                            -- RETURNS true or nil
bindCondition(creature, conditionKey, msDuration, t)    -- conditionKey == STR(the last key in SUB table) | t == {param = INT} | param is string in lower letters
bindConditionTable(creature, conditionT)                -- conditionT == {{ID, duration, attributeT}}
removeCondition(creature, conditionT)                   -- conditionT == {{STR(the last key in SUB table)}} | no need to insert tables
onHitDebuff_registerDamage(creature, reqTypeT, damType, damage, duration, effect, origin, name)
onHitDebuff_registerDamageNerfPercent(creature, damTypeT, amount, duration, name)
getHighestDamageDealerFromDamageT(damageT, object or "player") -- RETURNS highest damage dealer userdata / objects "player", "creature", "monster" / damageT = {[creatureID] = {total = INT}}
getDamTypeStr(object)                           -- RETURNS str:upper()  | can be string or enum damType
getEleTypeByEnum(ENUM)                          -- RETURNS eleType in STRING (upper)
getEffectByType(eleType)                        -- RETURNS magic effect enum
getEleTypeEnum(eleType)                         -- RETURNS combat enum
convertOrigin(origin)                           -- changes special origins to basic ones
isWeaponOrigin(origin)                          -- RETURNS bool
unFocus(creatureID)                             -- enemies who target creature loose the focus | everyone who target this player loose focus
Creature.sendCancelTarget()                     -- removes current target from focus
getDamageType(object)                           -- RETURNS STR or "physical" | creature or item
sortCreatureListByDistance(startPos, targetList, distance)    -- RETURNS new targetList
addTempResistance(playerID, amount, damType, msDuration)    -- adds storage value by amount | damType = damTypeStr
addExtraEleDamage(playerID, amount, damType, msDuration)    -- adds storage value by amount | damType = damTypeStr

-- tile functions
-- Tile(position)
tile.getTopVisibleThing()   -- RETURNS item userdata or nil
tile.getGround()            -- RETURNS groundItem userdata or nil
tile.getItems()             -- RETURNS {_, itemUserdata}
tile.getCreatures()         -- RETURNS {_, creatureUserdata}
tile.getItemById(itemID)    -- RETURNS item userdata or nil
tile.getBottomCreature()    -- RETURNS creature or nil
tile.hasProperty(ENUM)      -- RETURNS true or false
tile.getActionId()          -- RETURNS INT or 0 | tile ground AID

tile.getItemList()          -- RETURNS {{itemID = INT, itemAID = INT, itemText = STR, count = INT, fluidType = INT}}
tile.isCreature()           -- RETURNS false
tile.isPlayer()             -- RETURNS false
tile.isItem()               -- RETURNS false
tile.isTile()               -- RETURNS true
tile.isPzLocked()           -- RETURNS bool
tile.isContainer()          -- RETURNS false
tile.isSpecialBag()         -- RETURNS false
tile.hasHole()              -- RETURNS true if tile has hole / holes: 383, 5731

-- item functions
-- Item(UID)
-- items.lua custom itemSystem functions
item:getItemT()                         -- returns itemT = {count = INT, itemID = INT, itemAID = INT, itemText = STR, itemPos = POS}
items_startUp()                         -- improves and register items
items_onLook(player, item)              -- RETURNS STR | with item information
items_parseStatT(itemStatT)             -- RETURNS STR | converts itemStatT into basic item information string
items_randomiseStats(item)              -- gives all default stats a bonus stat
item.setBonusStat(stat, amount)         -- sets a bonus stat to item | amount or items_getDefaultRandomStatAmount(stat)
items_getDefaultRandomStatAmount(stat)  -- RETURNS INT or 0 | based on itemsConf_itemStatT
items_mergeStatT(itemStatT, itemStatT2) -- RETURNS merged itemStatT | several keys are left out
items_equipItem(player, item)           -- sets and activates item effects
items_deEquipItem(player, item)         -- removes and disables item effects
items_setDSV(player, item, dSVT)        -- sets storage values from item
items_removeDSV(player, item, dSVT)     -- basically removeSV
items_equipSetItem(player, item)        -- items_activateSetEffects
items_deEquipSetItem(player, item)      -- items_activateSetEffects
items_activateSetEffects(player, setName, setPieceCount)    -- sets conditions and storage values
createSetStatT(setName, setPieceCount)  -- RETURNS itemStatT | total value of set bonuses
items_createConditionT(itemT)           -- RETURNS conditionT | {{conditionKey, duration, paramT}}
items_getSetItemT(setName)              -- RETURNS setItemTable[setName]
item.getSetItemT()                      -- RETURNS setItemTable[setName]
player.getSetStatT(item)                -- RETURNS createSetStatT(setName, setPieceCount)
items_getEquippedSetPieceT(player, setName)     -- RETURN itemIDT | {itemID = slotStr}
items_getStatInfo(attribute, itemStatT, extraInfo, fullInfo, dontUseN)  -- RETURNS STR | specific attribute from itemStatT
items_getOtherStatInfo(itemStatT, extraInfo, fullInfo)  -- RETURNS STR | turns entire itemStatT into 1 string expect few exlusion hardcoded in function in
items_getStatDescInfo(itemT, item, fullInfo)    -- RETURNS STR | converts storageValus written on item to numbers
items_getItemSV(item, sv, modT)         -- RETURNS INT | if no storage values set, its sets new ones randomly
item.getStats()                         -- RETURNS itemStatT | items_getStats(item) + stats from itemText
items_getStats(itemID)                  -- RETURNS itemT | itemTable[slot][itemID]
player.getStats()                       -- RETURNS playerStatT
item.getStat(stat)                      -- RETURNS INT | original + bonus
player.getStatFromItems(stat)           -- RETURNS INT | item:getStat(stat) from all equipped items combined
player.getSetItemsStats(stat)           -- RETURNS INT | total value from all sets combined
item.isEquipment()                      -- RETURNS bool | items_getStats(itemID)
isEquipmentItem(itemID)                 -- RETURNS bool | items_getStats(itemID)
item.hasMaxStats()                      -- RETURNS bool | are all default and SV stats maxed out
getSlotStr(object)                      -- RETURNS STR, itemT | "head", "legs", etc / objects: item, itemID, slotEnum
getItemFromTracker(itemID, AID)         -- RETURNS item or nil
tracking(item, pos)                     -- registers item movement if its in tracking table
checkForItemEx(itemEx, pos)             -- RETURNS itemEx or nil | if itemEx doesnt exist takes top item from pos

createItem(itemID or itemT, pos, count, itemAID, fluidType, itemText, object)   -- RETURNS item
item.transform(itemID, fluidType)           -- RETURNS boolean | changes item to different item
doTransform(itemID, pos, toItemID, toAID)   -- RETURNS item | if toAID = true then keep original AID | keeps itemText
item.remove(amount or all)                  -- removes items from stack
item.tempRemove(amount or all, msTime)      -- removed items, but puts them back afterwards. (spawns on tilePos)
massTeleport(fromPos, toPos, objectT)       -- objectT = {"monster", "player", "creature", itemID}
getItemType(item)                           -- RETURNS STR or nil | "armor", "shield" or "weapon"
item.setText(key, newText)                  -- RETURNS true | replaces or adds to item:getAttribute(TEXT) | if not newText then removes the key from itemText
getFromText(string, itemText)               -- RETURNS V / INT, STR or {} / finds "string"(V)  (system mainly used for itemTexts)
item.getText(key)                           -- RETURNS getFromText(key, item:getAttribute(TEXT))
itemTextToT(string)                         -- RETURNS {key = v} | mainly used for item stats
changeLever(item or position)               -- changes lever if it exists
findItem(itemID, pos, itemAID)              -- RETURNS item   | needs either itemID or AID
findItems(itemID, pos, itemAID)             -- RETURNS {item} | needs either itemID or AID
removeItemFromPos(itemID, position, count or 1, itemAID) -- RETURNS true if item removed || count = "all" = item:getCount()
item.getBaseWeight()                        -- RETURNS INT | original single item weight
getSlotEnum(object)                         -- RETURNS INT (slotEnum) | SLOT_LEFT, SLOT_HEAD, etc / objects: item, itemID, slotEnum
getParent(item)                             -- RETURNS nil or player userdata
item.getTilePos()                           -- RETURNS itemPos or parentPos
stackCheck(itemID)                          -- RETURNS bool can item be stacked or not
burnItemOnFire(player, item, firePos, count)-- contains list of burnanle items
itemList_merge(itemList, itemList2)         -- puts itemsLists together
itemList_getItemT(itemList, itemID)         -- RETURNS itemT
discardItem(player, item, itemEx, fromPos, toPos, fromObject, toObject)   -- removes item if its moved away from player

item.isItem()                               -- RETURNS bool
item.isTile()                               -- RETURNS false
item.isNpc()                                -- RETURNS false
item.isCreature()                           -- RETURNS false
item.isPlayer()                             -- RETURNS false
item.isContainer(ignoreSpecialBags)         -- RETURNS bool
item.isSpecialBag()                         -- RETURNS bool
item.isBag()                                -- RETURNS bool
item.isFluidContainer()                     -- RETURNS bool
item.isStackable()                          -- RETURNS bool
item.isWeapon()                             -- RETURNS bool
item.isRangeWeapon()                        -- RETURNS true if item has range more than 1
item.isProjectile()                         -- RETURNS true if item has breakChance
item.isShield()                             -- RETURNS bool
item.isBow()                                -- RETURNS bool
item.isWand()                               -- RETURNS bool
item.isArmor()                              -- RETURNS bool
item.isBoots()                              -- RETURNS bool
item.isLegs()                               -- RETURNS bool
item.isBody()                               -- RETURNS bool
item.isHead()                               -- RETURNS bool
item.isKey()                                -- RETURNS bool / allKeys = {2086, 2088, 2089, 2091, 2092}
isWeaponRack(itemID)                        -- RETURNS bool
isArmorRack(itemID)                         -- RETURNS bool
isWardrobe(itemID)                          -- RETURNS bool
isCoffin(itemID)                            -- RETURNS bool
isShelf(itemID)                             -- RETURNS bool
item.getName()                              -- RETURNS STR
item.getDescription()                       -- RETURNS STR
item.getId()                                -- RETURNS INT
item.getActionId()                          -- RETURNS INT
item.getUniqueId()                          -- RETURNS INT
item.setActionId(INT)                       -- changes item actionID | less than 100 removes actionID
item.getCount()                             -- RETURNS INT or 1
item.getWeight()                            -- RETURNS oz | (1 cap = 100'oz)
item.getPosition()                          -- RETURNS tilePos or containerPos
item.getType()                              -- RETURNS INT
item.getFluidType()                         -- RETURNS INT or 0
item.getTile()                              -- RETURNS tile
item.getAttribute()                         -- RETURNS attribute | attributes: TEXT
item.setAttribute(ENUM, "STR" or INT)       -- changes item attribute
item.moveTo(POS or container)               -- moves item to new cycliner or position
item.decay()                                -- activates decay timer which is set in items.xml | try use decay() instead
item.hasProperty(ENUM)                      -- RETURNS bool
item.clone()                                -- RETURNS copy of this item
item.getParent()                            -- RETURNS itemowner or cycliner or tilePos
-- feature folders
decay(pos, itemT, start)                    -- starts decaying the items in order and in specific intervals
getDecayT(item)                             -- RETURNS decayT
-- weight feature functions
item.hasCustomWeight()                      -- RETRUNS getFromText("weight", self:getAttribute(TEXT))
item.getCustomWeight()                      -- RETURNS custom weight (or original weight if custom doesnt exist)
item.setCustomWeight(amount)                -- sets custom weight to item
player.changeWeight(weight)                 -- adds weight to player
player.addCap(amount, SV, msDuration)       -- adds amount*100 to player | if SV then continues if getSV(ID) ~= 1 | if msDuration then removes sv and cap later

-- Container functions
getTopContainer(pos)                        -- RETURNS item or nil
Container.isContainer(ignoreSpecialBags)    -- RETURNS bool
isContainerPos(pos)                         -- RETURNS true or false
Container.getItemHoldingCount()             -- RETURNS how many items in bag | use Container:getItemCount() instead
Container.getItemCountById(itemID)          -- RETURNS count or 0 (counts all the stacks and seperate piles)
Container.getItemCount(perItem or false)    -- RETURNS total amount of items in container | perItem only counts amount of different items
getSocketAmount(itemID, amount)             -- RETURNS INT of how many cyclinder positions it takes from container
Container.getEmptySlots(false)              -- RETURNS INT amount of empty slots the specific container has | if true then includes the total amount of all containers empty slots
Container.clearContainer()                  -- deletes all items in conatainer
Container.getItems(itemID, itemAID)         -- RETURNS {_, item} | itemID and itemAID can be used to find only spefici items
Container.getSize()                         -- RETURNS how many items take up a slot
Container.getSlotAmount()                   -- RETURNS how many slots bag has
Container.getItem(index)                    -- RETURNS item or nil | index = slotPos (starts with 0)
Container.hasItem(item)                     -- RETURNS true if the item is in container
Container.addItem(itemID, count)            -- RETURNS added item | creates item inside container
Container.addItemEx(item)                   -- moves item into container
Container.getCapacity()                     -- RETURNS INT | total weight of bag with the items
notEnoughCap(player, weight, pos)           -- RETURNS true and send message to player if player doesn't have enough cap
targetContainer(player, toObject, toPos)    -- RETURNS container or toObject | tries find container from toPos

-- creature functions
-- Creature(name) or Creature(ID)
bindCondition(creatureID, conditionKey, msDuration, t)  -- conditionKey == STR(the last key in SUB table) | t == {param = INT} | param is string in lower letters
bindConditionTable(creatureID, conditionT)              -- conditionT == {{ID, duration, attributeT}}
removeCondition(creatureID, conditionT)                 -- conditionT == {{STR(the last key in SUB table)}} | no need to insert tables
root(creatureID, duration or 1000)              -- creature wont be able to move
bind(creatureID, duration or 1000)              -- creature wont be able to move and attack
stun(creatureID, duration or 1000, stunL or 1)  -- creature wont be able to move, attack and cast spells
silence(creatureID, duration or 1000)           -- creature wont be able to cast spells
registerEvent(creature, event, eventName)       --[[ eventName = _G[eventName]() | events: (no .xml needed)
                                    "onThink"(creature),
                                    "onDeath"(creature, killer),
                                    "onHealthChange"(creature, attacker, damage, damType, origin)]]
unregisterEvent(creature, event, eventName)     -- removes event
creature.registerEvent("STR")                   -- register event on creature
eventRemove(creatureID, name)                   -- Creature.unregisterEvent("STR")
targetIsCorrect(creature, object, ignoreDead or true, ignoreGod or true) -- RETURNS true if creature matches object / objects: "monster", "player", "creature", "npc"
massTeleport(fromPos, toPos, objectT)           -- objectT = {"monster", "player", "creature", itemID}
climbOn(creature, item)                         -- teleports creature on the item
teleport(creature, pos, walk or false, dir)     -- RETURNS true if teleported |dir = INT or "N;S;W;E") | removes all binds
teleportBack(creature, item, _, fromPos)        -- teleports to fromPos | used for actionSystem
creature.teleportTo(POS)                        -- RETURNS true | tries to move creature to new pos
creature.getOutfit()                            -- RETURNS {lookFeet = INT, lookLegs = INT, lookMount = INT, lookHead = INT, lookBody = INT, lookAddons = INT, lookType = INT, lookTypeEx = INT}
creature.setOutfit(table)                       -- RETURNS true | changes creature outfit
doSetOutfit(creatureID, outfit)                 -- RETURNS bool | changes creature outfit
removeCreature(creatureID or "name")            -- removes creature from game.
creature.remove()                               -- removes creature from game.
walkTo(creatureID, targetPos, obstacles, interval, dontStepFinalPos)   --  RETURNS false or duration when walkin is done (and moves creature there)
creature.say("STR", colorType)                  -- RETURNS true | colorTypes: ORANGE, YELLOW
creatureSay(creatureID, text, msgType or YELLOW)-- RETURNS true if creature exists
creature.getClosestFreePosition(distance)       -- RETURNS getClosestFreePosition() | if god then returns creaturePos
creature.setHiddenHealth(false)                 -- if true then removes creature from target selection and cant be targeted
getFurthestTargetID(targetPos, targetList)      -- RETURNS targetID, closestDistance
getClosestTargetID(targetPos, targetList)       -- RETURNS targetID, closestDistance
Creature.sendCancelTarget()                     -- removes current target from focus
creature.getName()                      -- RETURNS STR
creature.getRealName()                  -- RETURNS STR:lower() or monsterT.name
creature.getId()                        -- RETURNS INT
creature.getTarget()                    -- RETURNS creature or nil
creature.setTarget(creature)            -- RETURNS true | sets new target for creature
creature.getFollowCreature()            -- RETURNS creature or nil
creature.setFollowCreature(creature)    -- NB!! BUGGED IN DEFAULT TFS
creature.getMaster()                    -- RETURNS master creature if creature is summon
creature.setMaster(creature)            -- RETURNS true | turns creature into summon and sets master
creature.getSummons()                   -- RETURNS {monster} or {} | creature summonList
creature.getSpeed()                     -- RETURNS INT | with conditions
creature.getBaseSpeed()                 -- RETURNS INT | without condtions
creature.getPosition()                  -- RETURNS pos
getPosition(objectID)					-- RETURNS creature position
creature.getHealth()                    -- RETURNS INT
creature.addHealth(INT)                 -- RETURNS true | increases health but not more than maxHealth
creature.getMaxHealth()                 -- RETURNS INT
creature.setMaxHealth(INT)              -- RETURNS true | changes maxHealth, does not heal
creature.getMana()                      -- RETURNS INT
creature.addMana(INT)                   -- RETURNS true | increases mana but not more than maxMnana
creature.getMaxMana()                   -- RETURNS INT
creature.setMaxMana()                   -- RETURNS true | changes maxMana, does give manal
creature.getSkull()                     -- RETURNS INT | skull enums: 
creature.setSkull(ENUM)                 -- RETURNS true | puts skull on creature
creature.addCondition(condition)        -- RETURNS true | >> USE bindCondition() << | activates condition
creature.removeCondition(ENUM, ID)      -- returns true | >> USE removeCondition() << | removes condition
creature.getDamageMap()                 -- RETURNS damageT | {[creatureID] = {ticks = msTime_whenLastHit, total = totalDamage}} 
creature.getDescription()               -- RETURNS creature:getName()
creature.getTile()                      -- RETURNS tile | tile of which creature is standing on
creature.getParent()                    -- RETURNS creature,, container or position
creature.getPathTo()                    -- RETURNS {[distance-1] = INT} | confusing as fuck DONT USE
creature.canSee(pos)                    -- RETURNS bool | 10 tiles away in axis or 9 tiles away in y axis
creature.canSeeCreature(creature)       -- RETURNS true if creature is not hidden    
creature.isDead()                       -- RETURNS bool | checks SV.playerIsDead and SV.fakedeathOutfit
creature.isGod()                        -- RETURNS bool | can use god commands
creature.isMage()                       -- RETURNS bool | class check
creature.isDruid()                      -- RETURNS bool | class check
creature.isKnight()                     -- RETURNS bool | class check
creature.isHunter()                     -- RETURNS bool | class check
creature.isCreature()                   -- RETURNS true
creature.isInGhostMode()                -- RETURNS bool
creature.isHealthHidden()               -- RETURNS bool
creature.isSpecialBag()                 -- RETURNS false
creature.isContainer()                  -- RETURNS false
creature.isItem()                       -- RETURNS false
creature.isMonster()                    -- RETURNS true
creature.isNpc()                        -- RETURNS getNpcT(creature)
creature.isPlayer()                     -- RETURNS true
creature.isTile()                       -- RETURNS false
creature.isStunned()                    -- RETURNS true if creature stands on itemID:11320 and itemAID: AID.other.stun
creature.isRooted()                     -- RETURNS true if creature stands on itemID:11320 and itemAID: AID.other.root
creature.isBinded()                     -- RETURNS true if creature stands on itemID:11320 and itemAID: AID.other.bind
creature.isWeakened()                   -- RETURNS true if creature stands on itemAID: AID.jazmaz.monsters.seaGuard_field

-- player functions
-- Player(name) or Player(ID)
-- svT = {[SV] = INT} or svT = {INT = SV} (INT must be smaller than 1000)
player.saveItems(ID)                            -- RETURNS itemsT | saves player equipped and bag items to database under ID
player.loadItems(itemsT_or_strID, playerGuid)   -- equips items by itemsT or loads them from database if ID used | DEFAULT playerGUID = player:getGuid()
player.getItems(ignoreSlots or nil)             -- RETURNS {[slotID] = item}
player.removeSV(sv or svT)                      -- sets storage values to -1 / removeSV(...)
player.setSV(sv or svT, v or nil)               -- RETURNS true or nil / setSV(...)
player.addSV(sv or svT, v or nil, limit)        -- if sv value < 0 then sv value = 0 | limit is the the number from which cant be added further / addSV(...)
player.getSV(sv, minAmount)                     -- RETURNS value or nil / getSV(...) | if minAmount used the sets the sotrage value to minAmount if its not that already
compareSV(player, sv or svT, operator, v)       -- RETURNS true or nil / "<",">","==",etc | v can be nil if svT used | RETURNS true if not svT
setAccountSV(accID, sv, v)                      -- sets all character storage values under that account to v
getAccountSVT(accountID or player, sv, onlyOne) -- RETURNS table of values from each character.  {_ = v} | if onlyOne then RETURNS biggest value
getButtonState(player, sv)                      -- RETURNS "ON" or "OFF" | value == 1
getAnswerState(player, sv)                      -- RETURNS "YES" or "NO" | value == 1
toggleSV(player, sv)                            -- RETURNS -1 or 1 | sets sv to -1 or 1
capRemove(player, amount)                       -- removes capacity from player
checkWeight(player, itemTable, weightErrorMsg)  -- RETURNS true if player has enough cap
player.checkWeight(weight, weightErrorMsg)      -- RETURNS true if player has enough cap
player.changeWeight(weight)                     -- adds/removes player cap 
player.getCapacity()                            -- RETURNS INT | maximum oz 
player.setCapacity(amount)                      -- RETURNS true | sets new cap amount
player.getFreeCapacity()                        -- RETURNS INT | current oz 
ownerIsPlayer(player, pos)                      -- RETURNS true if the pos location owner is a player
player.isOwner(item)                            -- RETURNS bool | "accountID" match on itemText
player.isEquipped(itemID, slot)                 -- RETURNS item (if not slot given then searches all slots)
player.isPartyLeader()                          -- RETURNS true if not in party or is party leader
player.isPlayer()                               -- RETURNS true
player.isPzLocked()                             -- RETURNS true if player is standing in the pz zone
player.isSilenced()                             -- RETURNS bool
player.isVocation(neededVocation)               -- RETURNS bool | must be string | neededVocation can be table
playerSave(playerID)                            -- if playerID not used then saves all players
player.save()                                   -- saves player state to database
player.hasBagRoom(amount or 1)                  -- RETURNS true if player has enough room in the bag
player.getEmptySlots(false)                     -- RETURNS INT or 0 | main bag slots | if true checks for containers inside a container too
doSendTextMessage(playerID, msgType or GREEN, msg, spamTime) -- spamTime = millisecond cooldown before player receives same msg
player.sendTextMessage(msgType, msg)            -- RETURNS true | sends message to player
player.frontPos(yards or 1)                     -- RETURNS pos | position towards current player direction
player.homePos()                                -- RETURNS pos | checkpoint
player.showTextDialog(itemID, text)             -- creates window with itemID picture and text dialog
player.createMW(mwID, param1, param2)           -- RETURNS true if MW was created.
player.hasFood()                                -- RETURNS bool
walkDown(player, _, toPos, fromPos)             -- tries to moves player z+1 towards fromPos
pickUpItem(player, item)                        -- equips or puts item into player bag

player.getLevel()                               -- RETURNS INT
player.getMagicLevel()                          -- RETURNS INT
player.getShieldingLevel()                      -- RETURNS INT
player.getDistanceLevel()                       -- RETURNS INT
player.getWeaponLevel()                         -- RETURNS INT
player.getHandcombatLevel()                     -- RETURNS INT
player.getArmor()                               -- RETURNS INT | total armor
player.getDefence()                             -- RETURNS INT | total defence
player.getBarrier()                             -- RETURNS INT | total barrier
player.getCriticalBlock()                       -- RETURNS INT | % chance to double defence
player.getCriticalHit()                         -- RETURNS INT | % chance to double damage
player.getCriticalHeal()                        -- RETURNS INT | % chance to double heal
player.getMissChance()                          -- RETURNS INT | % chance to miss projectile
player.getResistance(resType, printMode)        -- RETURNS INT | % 
player.getStunRes()                             -- RETURNS INT | %
player.getSlowRes()                             -- RETURNS INT | %
player.getSilenceRes()                          -- RETURNS INT | %
player.getExtraElementalDamage(damType, damage) -- RETURNS INT
player.getDamagePerSecond()                     -- RETURNS INT
Player.displayStats(targetPlayer or self, stat or nil)   -- sends message of targetPlayer stat or all stats
singleStatValue(player, stat, statTable)        -- 

Player.getFriends(distance)                     -- RETURNS {_, playerID}
player.getOnlineTime(update or false)           -- RETURNS INT | in seconds | if true the passes true for updateOnlineTime
updateOnlineTime(player, logOut or true)        -- updates online time
player.getPartyMembers(distance)                -- RETURNS {[guid] = playerID}
checkPartyDistanceFromPlayer(player, distance)  -- RETURNS missing party member names in 1 string OR nil
Player.canInviteToParty(player, target)         -- RETURNS bool | can you invite target to your party
Player.canJoinParty(player, target)             -- RETURNS bool | can you join targets party
inviteToParty(partyOwner, invitee)              -- adds invitee to partyOwner list | if partyOwner doesnt have party then creates it
addMemberToParty(partyOwner, invitee)           -- adds invitee to party
player.getGuid()                                -- RETURNS INT
player.getIp()                                  -- RETURNS ??
player.getAccountId()                           -- RETURNS INT
player.getVocation()                            -- RETURNS Vocation
player.setVocation(string or INT)               -- RETURNS true | string = vocationName | INT = vocationID
player.addOutfit(lookType)                      -- unlocks outfit in outfit window
player.addOutfitAddon(lookType, addon)          -- unlocks addon for lookType | addon = 1, 2 or 3(for both)
player.removeOutfit(lookType)                   -- removes outfit from outfit window
player.removeOutfitAddon(lookType, addon)       -- removes addon for lookType | addon = 1, 2 or 3(for both)
player.hasOutfit(lookType)                      -- RETURNS bool
player.sendOutfitWindow()                       -- RETURNS true
player.addMount(mountID)                        -- unlocks mount in outfit window
player.removeMount(mountID)                     -- removes mount from outfit window
player.hasMount(mountID)                        -- RETURNS bool
player.getSkullTime()                           -- RETURNS msTime | time when skull dissapears
player.setSkullTime(msTime)                     -- RETURNS true | sets time when skull dissapears
player.setGhostMode(bool)                       -- turns player invisible 
player.addExpPercent(amount)                    -- gives percent amount of exp
player.removeExpPercent(amount)                 -- removes percent amount of exp
player.getDepot()                               -- RETURNS depot or nil | depotID = 0
player.getBag()                                 -- RETURNS equipped bag or nil
-- itemList = {{itemID = {INT}, itemAID = {INT}, itemText = STR, count = INT or 1, fluidType = INT, itemName = STR or item:getName()}}
-- if itemID is table = 1 random ID (same with itemAID)
-- "randomStats" in itemText adds randomStats to equipmentItem
player.hasItems(itemList, need1)                -- RETURNS true if has all the items | if need1 then only need 1 item from list
player.getItem(itemID, itemAID, searchBag or true, searchPlayer or true)    -- RETURNS item or nil
player.getItemById(itemID, searchBag or false)  -- RETURNS item or nil
player.giveItem(itemID, count or 1, itemAID, fluidType, itemText)   -- RETURNS item
player.rewardItems(itemList, dontCheckWeight, weightErrorMsg)
player.getItemCount(itemID, itemAID, fluidType, dontCheckPlayer)    -- RETURNS INT
player.removeItem(itemID, count or 1, itemAID, fluidType, dontCheckPlayer)   -- RETURNS true if removed | if count == "all" then removes all
player.removeItemList(itemList, removeOnly1)    -- RETURNS true if executed properly | itemList = {{ itemID = INT or {INT}, itemAID = INT, count = INT or 1, fluidType = INT}}
player.addItem(itemID, count or 1)              -- RETURNS item
player.addItemEx(item, index)                   -- gives item to player (index is slot pos)
player.getSlotItem(index)                       -- RETURNS item | 0-13                      -- 
player.getMoney()                               -- RETURNS INT | amount gold on player
player.addMoney(INT)                            -- RETURNS true | gives gold
player.removeMoney()                            -- RETURNS true if money was removed

-- monster functions 
-- Monster(monsterID or monsterName)
createMonster(name, pos, autoRegisterEvents or true)-- RETURNS monster
getRace(monsterID)                                  -- RETURNS string or nil
monster.getFriends(distance or 1)                   -- RETURNS {_ = userdata}
monster.getEnemies(distance or 1)                   -- RETURNS {_ = creatureID}
monster.getTargetList()                             -- RETURNS {_ = creatureID}
monster.isMonster()                                 -- RETURNS true
monster.isBoss()                                    -- RETURNS bool if monster is a boss
monster.findTarget(distance or 10)                  -- RETURNS creature or nil | random target from targetlist
getMonsterT(creature)                               -- RETURNS monsterT 

-- vocation functions
Vocation.getId()
Vocation.getName()
player.isVocation(neededVocation)                   -- RETURNS bool | must be string | neededVocation can be table

-- Condition(ENUM, ID)
Condition.getId()
Condition.getSubId()
Condition.setTicks()
Condition.setParameter()

--Party functions
getPartyMembers(player, distance)                   -- RETURNS {[guid] = playerID}
checkPartyDistanceFromPlayer(player, distance)      -- RETURNS missing party member names in 1 string OR nil
Party.disband()                                     -- disbands party
Party.getLeader()                                   -- RETURNS player
Party.setLeader(player)                             -- sets new leader for party
Party.addInvite(player)                             -- send invitation to player
Party.removeInvite(player)                          -- removes invitation from player
Party.addMember(player)                             -- adds player to party
Party.removeMember(player)                          -- removes player from party

-- npc functions
getNpcT(monster)    -- returns npcT or nil
Npc.isNpc()


-- Other server functions I do and need documentation for (One day I could automate it :o hmm)
player.getSwordLevel()                      -- RETURNS INT
player.getClubLevel()                       -- RETURNS INT
player.getShieldingLevel()                  -- RETURNS INT
player.getAxeLevel()                        -- RETURNS INT