--[[ regular attack guide
    "cd=INT"        cooldown in milliseconds 
                    DEFAULT = 1000
    "d=INT-INT"     damage, minDam-maxDam or heal, minHeal-maxHeal
                    DEFAULT = 1
    "c=INT"         % chance to attack/heal
                    DEFAULT = 100

    "heal:"         a default healing spell 
    "p=INT"         percent amount of HP
    
    "damage:"       a default attack spell
    "t=STR"         STRING enum for damage type
                    DEFAULT = "PHYSICAL"
    "r=INT"         range for spell
                    DEFAULT = 1
    "fe=INT"        enum for flyingEffect
    "e=INT"         enum for magicEffect
]]

--[[ spellCreating config guide
	firstCastCD = INT or 1000			how many milliseconds has to wait before can cast the first spell
	cooldown = INT or 1000 				time in milliseconds
	locked = BOOL						if true then this spell cant be casted until something else unlocks it
    lockedForSummon = BOOL              if true then summoned creatures starts with the spell locked
    changeTarget = BOOL,        		Caster searches new target after spell activation
	
	targetConfig = {					generates targetList with configurations | {targetID = {POS}}
		-- objects
		itemID 							adds itemID to targetList (used in environmental changes) | positions takn with areaAround(range)
		"caster" 						adds spell caster to targetList
		"enemy"							adds players around caster to targetList    || if confT not used then obstacles = {"solid"}
		"friend"						adds monsters around caster to targetList
		"target"						adds previous target to targetList
		"cTarget"						adds current caster target to targetList    || if confT not used then obstacles = {"solid"}
		
		[objects] = {					config to each object. | if not table used then creates it with default values
										object can also be objectTable EX: [{INT, INT, "caster"}] = {config}
										if value is not table then table is automatically generated with default values
			range = INT	or 10			if object too far then its not added to targetList
            amount = INT                limit how many targets will be chosen
			requiredID = INT or 1		every object with this ID will be counted towards this ID requirement | default numbere starts with 1 and adds 1 for each unique object
			findWay = false             it will use full getPath with obstacles to see if he finds target, else it tries it in the linear way.
            getPath = BOOL				automatically true if obstacles used
			obstacles = {STR}			if getPath() then target added to targetList
										"noTile"    - if Tile(pos)
										"noGround"  - if not tile:getGround()
										"solid"     - if tile:hasProperty(CONST_PROP_BLOCKSOLID)
										"creature"  - if tile:getTopCreaure()
										"blockThrow"- if tile:hasProperty(CONST_PROP_BLOCKPROJECTILE)
										itemID      - if findItem(itemID, pos)
			usePosTConfig = BOOL		-- instead should simply use position configuration here too
		}
		
		
		requiredT = {					how many objects need to be found for each requirement | missing table default = amount of 1 for each required ID
			[requiredID] = INT			INT amount of objects needs to be found
		}
	},
	
	position = {
		endPosT = {						generates all the end positions, when missing then uses startPositons
			startPoint = startPosT		hardcoded !NB can only use endPoint for endPosT
		}
		startPosT = {					generates all the start positions (same configs apply to both)
			range = INT or 10			compares startPoint with endPoint
			
			startPoint = { 				objects are read in order.
				"caster"				caster:getPosition()
				"enemy"					targetList (NB! caster can be enemy)
				"friend"				monster:getFriends() - and takes each position
				"cTarget"				current caster target position
				itemID					finds this item position near caster
				"endPos"				previous endPositions   | if used for endPoint then copies the startPoint values | NB cast "endPos" to endPoint too if you dont want to square it?
				"startPos"				previous startPositions
			},
			endPoint = {}				same config as startPoint
			
			singlePosPoint = BOOL		if true then first position what passes all parameters is taken (used in getPointPosT)
			singlePosT = BOOL           if true then doesnt make endPos for each startPos

			pointPosFunc = STR			_G[STR](posConfT, startPointPosT, endPointPosT) -- rewrites default createPosPointT function
										"pointPosFunc_far" - from given positions, finds pos which is furthest away from STARTPOINT (getPath goes as far as 7)
										"pointPosFunc_near" - from given positions, finds pos which is closest to STARTPOINT
			checkPath = {STR}			list of obstacles (this parameter only used for pointPosFunc)
			
			
			areaConfig = {				compares STARTPOSITIONS and ENDPOSITIONS STARTPOINT
				area = areaT			single area from areas table
				relativeArea = areaT	secondary area table for relative directions (if not used then randomly casts either to x axis or y axis)
				useStartPos	= BOOL		if true then creates the area to startPos instead of endPos
                randomPos = INT         picks randomly INT amount of positions from area
			},
			
			getPath = {
				obstacles = {STRING}    "noTile"    - if Tile(pos)
										"noGround"  - if not tile:getGround()
										"solid"     - if tile:hasProperty(CONST_PROP_BLOCKSOLID)
										"creature"  - if tile:getTopCreaure()
										"blockThrow"- if tile:hasProperty(CONST_PROP_BLOCKPROJECTILE)
										itemID      - if findItem(itemID, pos)
										
				stopOnPath = {STR},    	objects are read in order.
										"caster" - stops on caster
										"solid" - stops before solid tile
										"enemy" - stops before enemy
										"friend" - stops before friend
										itemID - stops before item
										
			}
			
			posTFunc = STR				_G[STR](caster, targetList, pointPosT, previousTargetList, previousEndPosT, previousStartPosT)
			
			blockObjects = {STRING/INT}	removes some postions from startPosT - clearPositions()
										"solid" 	- CONST_PROP_IMMOVABLEBLOCKSOLID
										"caster" 	- removes position when there is caster
										"enemy" 	- removes position when there exist enemy userdata
										"friend" 	- removes position when there exist friend userdata
										itemID 		- removes position when there exist itemType(itemID)
                                        "startPos"  - removes startPositions from endPosT
										
			onlyItemPos = {INT},		ONLY collects positions where are these itemID's
			
			randomPos = INT,            Picks randomly INT amount of positions from final result
			randomPerLayer = BOOL       if true then picks randomPos amount of positions on each layer

            npcFollow = false           starts to follow target from targetlist as soon its found
		}
	},

	-- variables what work on all features
	onTargets = BOOL					if true then instead of using created positions it directly does something to targetlist cid(in case of items uses targetList position)
	delay = INT                 		ms time before feature is activated
	hook = BOOL 						if true then executes this feature if hook was true | only checked onrecast
	oppoHook = BOOL 					if true then executes this feature if hook was false | only checked onrecast
	
	-- recast works on features: damage, changeEnvironment, summon, heal
	recastPerPos = BOOL					if true then recasts this table for each position (doesnt recast on repeats)
	
	stunOnHook = BOOL 					if true then only stuns when feature hook is true
	stunDuration = INT					time in milliseconds (stuns position)
	stunL = INT	or 0					level of stun
    
	bindOnHook = BOOL 					if true then only binds when feature hook is true
	bindMsDuration = INT				(stuns position)
    
	rootOnHook = BOOL 					if true then only roots when feature hook is true
	rootMsDuration = INT				(stuns position)
	
	-- features
	damage = {							hooks activate onHit | hook is nil if recastPerPos not used
		interval = INT or 0				milliseconds betweeen area index positions (only for positions)
		sequenceInterval = INT or 0		ms time to between positions(only for positions)
        cid = INT or cid            	cid = caster:getId()
		origin = INT or 14				14 = O_monster_spells, 16 = O_environment
        minDam = INT                	minimum damage
        maxDam = INT or minDam      	maximum damage
        formulaFunc = STR           	returns minDam and maxDam _G[STR](caster, target, targetPos)
        minScale = INT              	extra damage scalingSystemValue * INT
        maxScale = INT              
		race = {						other friendly monsters increase heal amount
			[STR] = INT					STR = race 		("undead", "human", "element", "beast")
										INT = amount for each monster
		}
        damType = ENUM,             	combat damage Type
		distanceEffect = ENUM			animation effect from startPositions to end positions
        distanceEffectLastPos = false   if true the distance effect is only made for last given position
        effect = ENUM,              	animation effect on the position
        effectOnHit = ENUM,         	animation effect when player gets hit
        effectOnMiss = ENUM,        	animation effect when nobody gets hit, used if not DIRECT DAMAGE
        executeAmount = INT or 1        Repeats same damage INT amount of times.
        repeatInterval = INT or 0       how often the damage feature table repeats
    },
	
	heal = {
		interval = INT or 0				milliseconds betweeen area index positions (only for positions)
		effect = {INT}			       	send this magic effect on the healed target pos.
        minHeal = INT	           		lowest heal value
        maxHeal = INT or minHeal		highest heal value
        percentAmount = INT	    		Heals from caster by maxHP INT%
		minScale = INT or 0
		maxScale = INT or 0
		healTarget = STR or "creature"	"monster" = only monsters, "player" = only players
        race = {						other friendly monsters increase heal amount
			[STR] = INT					STR = race 		("undead", "human", "element", "beast")
										INT = amount for each monster
		}
        maxHPMultiplier = INT         	if heal gives more health than monster has max health it will increase monster max health by amount*INT
										if INT is negative then increases max health by amount/-INT
        maxHPLimit = INT or 5000  		How far can max hp get
        executeAmount = INT or 1        Repeats same damage INT amount of times.
		repeatInterval = INT or 0   	how often the heal feature table repeats
	},
	
	changeEnvironment = {				hooks activate on item remove
        items = {INT},      			list of items what are created to positions
		itemAID = INT					all created items will get this itemAID
		interval = INT or 0				ms time to between positions using position index
        randomised = BOOL,           	if true then only one of the items is created to positions
		removeItems = {INT},   			List of items what are removed from position if they exist there
        removeTime = INT,            	ms time created item is removed
		spawnTime = INT,				ms time when removed item spawns back
        itemDelay = INT,           		ms time between creating the items
        blockObjects = {STRING/INT}		removes postions from given endPosT - clearPositions() | doesnt afftect removeeItem positions
										"solid" 	- CONST_PROP_IMMOVABLEBLOCKSOLID
										"caster" 	- removes position when there is caster
										"enemy" 	- removes position when there exist enemy userdata
										"friend" 	- removes position when there exist friend userdata
										itemID 		- removes position when there exist itemType(itemID)
		customFunc = STR	            _G[STR](cid, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
		customFuncOnRemove = STR	    _G[STR](cid, itemID, pos, currentItemRemoved, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
		sequenceInterval = INT or 0		ms time to between positions(only for positions)
		passRecastPos = BOOL            if true then changes the endPosT into position what activated recast
    },
	
	builder = {							crates specific items on positions
		STR =  {						STR = direction (N,S,W,E,NW,NE,SW,SE)
			{INT}						areaT where INT is the item, 0 means startPos
		}
		removeTime = INT,            	ms time created item is removed
		startPoint = STR				"caster" = direction startPos is caster (only used with onTargets)
	},
	
	say = {								if targets not used then ORANGE text comes to pos
		msg = {STR} or {[delay] = STR}	if not delay used then delay is automatically generated with addMsgDelayToMsgT()
        msgFunc = STR                   _G[msgFunc](casterID) | RETURNS str
		msgType = INT or YELLOW			type of msg (if targets used)
        onlyOnce = false                says message only once if not onTargets used
    }
	
	spellLock = {
		lockSpells = {STR}				list of spells what cant be used anymore (spell still needs to be registered to monster)
		unlockSpells = {STR}			list of spells what can be used (spell still needs to be registered to monster)
	},
	spellLockCD = {
		[INT] = {STR}					INT = ms cooldown what is added
										STR = spellName
	},
	
	event = {
		duration = INT					sec time before registered event is removed
        register = {                    
            onThink = {STR},            list of functions which will be activated
            onHealthChange = {STR},
            onDeath = {STR},
        },
        unregister = {
            onThink = {STR},
            onHealthChange = {STR},
            onDeath = {STR},
        }
	},
	
	teleport = {
        effectOnCast = {INT},      		Effect before teleporting
        effectOnPos = {INT},       		Effect after teleport
		effectInterval = INT,			ms time between the effects on position
		walkSpeed = INT,				if monster speed is slower than walkSpeed then it gets temporarily the walkSpeed
		teleportInterval = INT or 0		ms time from teleporting from pos to next pos
        unFocus = BOOL                  if true then everyone who target teleporter loose focus from him.
    },
	
	magicEffect = { or magicEffect2
        effect = {INT},          		effect type what will appear in position
        effectInterval = INT,     		ms time between the effects on position
		waveInterval = INT or 0		    ms time for area effects
		sequenceInterval = INT or 0		ms time to between positions(only for positions)
    },
	
	flyingEffect = {    
        effect = INT                    Animation effect
        sequenceInterval = INT or 0
    },
	
	resistance = {						adds or removes resistance for certain duration
		[INT] = INT,					key INT is ENUM for damType (PHYSICAL, ICE, FIRE, ENERGY, DEATH, EARTH, HOLY, LD)
										value INT is the change for resistance
		duration = INT					ms time when same amount of resistances are changed back
	},
	
	conditions = {
		conditionT = {
			[STR] = {					conditionKeys are located in SUB table (in storageValues.lua file)
				paramT = {
					[STR] = INT			STR = param for condition, INT = value for param
										{"dam", "interval", "regen", "maxMP", "maxHP", "speed", "gainHP", "gainMP", "HPinterval", "MPinterval", "sL", "wL", "dL", "sLf", "mL"}
				}
				duration = INT			ms time how long the condition lasts
				maxStack = INT			how many times the spell can be stacked
			}
		},
        noMonsters = BOOL               if true then condition dont work on monsters
		duration = INT or 1000			default duration if duration is not set in conditionT
		maxStack = INT or 1				default maxStack
        repeatAmount = INT or 1      	how many times condition is applied.
        interval = INT or 0   			ms time between repeat
	},
	
	summon = {							if summond on area positions then simply random positions taken from the area
		summons = {
			[STR] = {					monster Name
				amount = INT or 1		amount of summons per cast
				monsterHP = INT			repaced monster max HP
		}
		summonAmount = INT				goes over summons table until summon amount is reached or max summons is achieved
		maxSummons = INT or 1          	maximum amount of summons that can be made per summoner
	},
	
	customFeature = {					--regadless is it onTargets or positions, same func executes
		func = STR						_G[STR](casterID, featureT, targetList, endPosT, startPosT, previousTargetList, previousEndPosT, previousStartPosT)
	},
    
    stun = {
        msDuration = INT or 1000
        stunL = INT	or 0			    level of stun
    },
    bind = {msDuration = INT or 1000},
    root = {msDuration = INT or 1000},
]]

monsterAIGotError = true
local function missingError(errorStr, missingParameter) return print("ERROR - missing "..missingParameter.." in "..errorStr) end

local function badParameter(confT, parameters, errorStr)
    local defaultParamaters = {"targetConfig", "position", "damage", "changeEnvironment", "teleport", "event", "spellLock", "spellLockCD", "say", "flyingEffect", "magicEffect", "magicEffect2", "builder", "resistance", "conditions", "summon", "heal", "customFeature", "onTargets", "delay", "hook", "oppoHook", "recastPerPos", "stunOnHook", "stunDuration", "stunL", "bind", "stun", "root", "bindOnHook", "bindMsDuration", "rootOnHook", "rootMsDuration"}

    for parameter, v in pairs(confT) do
        if not isInArray(parameters, parameter) and not isInArray(defaultParamaters, parameter) then return true, print("ERROR - bad parameter in "..errorStr.." || ["..parameter.."]") end
    end
end

local function checkPosT(posT, errorStr)
    local parameters = {"range", "startPoint", "endPoint", "singlePosPoint" , "singlePosT", "pointPosFunc", "checkPath", "areaConfig", "getPath", "posTFunc", "blockObjects", "onlyItemPos", "randomPos", "randomPerLayer"}
        
    if badParameter(posT, parameters, errorStr) then return end
    if not posT.range then posT.range = 10 end
    if type(posT.startPoint) ~= "table" then posT.startPoint = {posT.startPoint} end
    if posT.onlyItemPos and type(posT.onlyItemPos) ~= "table" then posT.onlyItemPos = {posT.onlyItemPos} end
    if posT.endPoint and type(posT.endPoint) ~= "table" then posT.endPoint = {posT.endPoint} end
    if posT.blockObjects and type(posT.blockObjects) ~= "table" then posT.blockObjects = {posT.blockObjects} end
    if posT.checkPath and type(posT.checkPath) ~= "table" then posT.checkPath = {posT.checkPath} end
    return true
end

local function checkPositionPassed(spellT, errorStr)
local positionConfig = spellT.position

    if not positionConfig then return true end
    errorStr = errorStr.."position."
    if not positionConfig.startPosT.startPoint then return missingError(errorStr, "startPosT.startPoint") end
    if not checkPosT(positionConfig.startPosT, errorStr.."startPosT.") then return end
    if not positionConfig.endPosT then return true end
    if tableCount(positionConfig.endPosT.startPoint) > 0 then return print("ERROR - can't have startPoint for endPosT | "..errorStr) end
    if not positionConfig.endPosT.endPoint then return missingError(errorStr, "endPosT.endPoint") end
    if not checkPosT(positionConfig.endPosT, errorStr.."endPosT.") then return end
    return true
end

local function checkTargetConfigPassed(spellT, errorStr)
    local targetConfig = spellT.targetConfig
    if not targetConfig then return true end
    local validKeys = {"caster", "enemy", "friend", "target", "cTarget"}
    local objectExists = false
    local defaultRequiredID = 0
    local requireT = targetConfig.requiredT
    local requireIDList = {}
    
    errorStr = errorStr.."targetConfig"
    
    local function checkConfT(confT, targetKey)
        local confTExist = confT
        objectExists = true
        confT = confT or {}
        if not confT.range then confT.range = 10 end
        if not confT.requiredID then
            defaultRequiredID = defaultRequiredID + 1
            confT.requiredID = defaultRequiredID
            table.insert(requireIDList, defaultRequiredID)
        else
            table.insert(requireIDList, confT.requiredID)
        end
        if targetKey == "enemy" or targetKey == "cTarget" then
            if not confTExist then confT.obstacles = {"solid"} end
        end
        if confT.obstacles then
            confT.getPath = true
            if type(confT.obstacles) ~= "table" then confT.obstacles = {confT.obstacles} end
        end
        return confT
    end
    
    local function checkTargetConfigKey(k, confT)
        local errorStr = errorStr.."["..tostring(k).."]."
        
        if tonumber(k) then
            if k < 100 then return print("ERROR - unknown key in "..errorStr) end
            return checkConfT(confT)
        elseif isInArray(validKeys, k) then
            return checkConfT(confT, k)
        elseif "requiredT" ~= k then
            return print("ERROR - unknown key in "..errorStr)
        end
        return true
    end
    
    for k, confT in pairs(targetConfig) do
        if type(k) == "table" then
            for _, key in ipairs(k) do
                local updatedConfT = checkTargetConfigKey(key, confT)
                if not updatedConfT then return end
                targetConfig[k] = updatedConfT
                break
            end
        elseif tonumber(k) and k < 100 then
            local updatedConfT = checkTargetConfigKey(confT)
            if not updatedConfT then return end
            targetConfig[confT] = updatedConfT
        elseif k ~= "requiredT" then
            local updatedConfT = checkTargetConfigKey(k, confT)
            if not updatedConfT then return end
            targetConfig[k] = updatedConfT
        end
    end
    
    if not objectExists then return missingError(errorStr, "[object]") end
    
    if not requireT then
        targetConfig.requiredT = {}
        for _, requireID in ipairs(requireIDList) do targetConfig.requiredT[requireID] = 1 end
    end
    return true
end

local function checkRace(featureT)
    if not featureT.race then return end
    for race, amount in pairs(featureT.race) do
        if not isInArray(allMonsterRacesT, race) then print("OOPZ! - race:["..race.."] does not yet exist in the game") end
    end
end

local function checkFeature_changeEnvironment(spellT, errorStr)
local environmentConfig = spellT.changeEnvironment

    if not environmentConfig then return true end
local parameters = {"passRecastPos", "items", "itemAID", "randomised", "removeItems", "removeTime", "spawnTime", "itemDelay", "blockObjects", "customFunc", "customFuncOnRemove","sequenceInterval", "interval"}

    errorStr = errorStr.."changeEnvironment."
    if badParameter(environmentConfig, parameters, errorStr) then return end
    
    if environmentConfig.items then
        if type(environmentConfig.items) ~= "table" then environmentConfig.items = {environmentConfig.items} end
    elseif environmentConfig.randomised or environmentConfig.orderChanger then
        return missingError(errorStr, "items")
    end
    
    if environmentConfig.removeItems then
        if type(environmentConfig.removeItems) ~= "table" then environmentConfig.removeItems = {environmentConfig.removeItems} end
    elseif environmentConfig.customFuncOnRemove or environmentConfig.spawnTime then
        return missingError(errorStr, "removeItems")
    end
    
    if environmentConfig.blockObjects and type(environmentConfig.blockObjects) ~= "table" then environmentConfig.blockObjects = {environmentConfig.blockObjects} end
    if not environmentConfig.sequenceInterval then environmentConfig.sequenceInterval = 0 end
    if not environmentConfig.interval then environmentConfig.interval = 0 end
    return monsterAI_checkConfigurations(environmentConfig, errorStr)
end

local function checkFeature_spellLockCD(spellT, errorStr)
local spellLockCDConfig = spellT.spellLockCD

    if not spellLockCDConfig then return true end
    errorStr = errorStr.."spellLockCD."
    
    for CD, spellNames in pairs(spellLockCDConfig) do
        if tonumber(CD) and type(spellNames) ~= "table" then spellLockCDConfig[CD] = {spellNames} end
    end
    return monsterAI_checkConfigurations(spellLockCDConfig, errorStr)
end

local function checkFeature_spellLock(spellT, errorStr)
local spellLockConfig = spellT.spellLock

    if not spellLockConfig then return true end
local parameters = {"lockSpells", "unlockSpells"}

    errorStr = errorStr.."spellLock."
    if badParameter(spellLockConfig, parameters, errorStr) then return end
    if not spellLockConfig.lockSpells then spellLockConfig.lockSpells = {} end
    if type(spellLockConfig.lockSpells) ~= "table" then spellLockConfig.lockSpells = {spellLockConfig.lockSpells} end
    if not spellLockConfig.unlockSpells then spellLockConfig.unlockSpells = {} end
    if type(spellLockConfig.unlockSpells) ~= "table" then spellLockConfig.unlockSpells = {spellLockConfig.unlockSpells} end
    return monsterAI_checkConfigurations(spellLockConfig, errorStr)
end

local function checkFeature_say(spellT, errorStr)
local sayConfig = spellT.say

    if not sayConfig then return true end
local msgT = sayConfig.msg
local parameters = {"msg", "msgType", "msgFunc", "onlyOnce"}

    errorStr = errorStr.."say."
    if badParameter(sayConfig, parameters, errorStr) then return end
    if not sayConfig.msgFunc then
        if type(msgT) ~= "table" then msgT = {msgT} end
        msgT = addMsgDelayToMsgT(msgT)
        sayConfig.msg = msgT
    end
    return monsterAI_checkConfigurations(sayConfig, errorStr)
end

local function checkFeature_event(spellT, errorStr)
    local eventConfig = spellT.event
    if not eventConfig then return true end
    local parameters = {"duration", "register", "unregister"}

    errorStr = errorStr.."event."
    if badParameter(eventConfig, parameters, errorStr) then return end
    if not eventConfig.register then eventConfig.register = {onThink = {}, onDeath = {}, onHealthChange = {}} end
    if not eventConfig.unregister then eventConfig.unregister = {onThink = {}, onDeath = {}, onHealthChange = {}} end
    
    local function checkEventT(regType, event)
        if type(eventConfig[regType][event]) ~= "table" then eventConfig[regType][event] = {eventConfig[regType][event]} end
    end
    checkEventT("register", "onThink")
    checkEventT("register", "onDeath")
    checkEventT("register", "onHealthChange")
    checkEventT("unregister", "onThink")
    checkEventT("unregister", "onDeath")
    checkEventT("unregister", "onHealthChange")
    return monsterAI_checkConfigurations(eventConfig, errorStr)
end

local function checkFeature_damage(spellT, errorStr)
    local damageConfig = spellT.damage
    if not damageConfig then return true end
    local parameters = {"interval", "sequenceInterval", "cid", "origin", "minDam", "maxDam", "race", "formulaFunc", "minScale", "maxScale", "damType", "distanceEffect", "effect", "effectOnHit", "effectOnMiss", "executeAmount", "repeatInterval", "distanceEffectLastPos"}

    errorStr = errorStr.."damage."
    if badParameter(damageConfig, parameters, errorStr) then return end
    checkRace(damageConfig)
    if not damageConfig.origin then damageConfig.origin = O_monster_spells end
    if not damageConfig.damType then return missingError(errorStr, "damType") end
    if not damageConfig.sequenceInterval then damageConfig.sequenceInterval = 0 end
    if not damageConfig.executeAmount then damageConfig.executeAmount = 1 end
    if not damageConfig.repeatInterval then damageConfig.repeatInterval = 0 end
    if testServer() and not damageConfig.effectOnHit then damageConfig.effectOnHit = 1 end
    return monsterAI_checkConfigurations(damageConfig, errorStr)
end

local function checkFeature_flyingEffect(spellT, errorStr)
    local featureT = spellT.flyingEffect
    if not featureT then return true end
    local parameters = {"effect", "sequenceInterval"}

    errorStr = errorStr.."flyingEffect."
    if badParameter(featureT, parameters, errorStr) then return end
    if not featureT.sequenceInterval then featureT.sequenceInterval = 0 end
    return monsterAI_checkConfigurations(featureT, errorStr)
end

local function magicEffecCheck(magicConfig, errorStr)
local parameters = {"effect", "effectInterval", "waveInterval", "sequenceInterval"}

    if badParameter(magicConfig, parameters, errorStr) then return end
    if not magicConfig.onTargets and not magicConfig.waveInterval then magicConfig.waveInterval = 0 end
    if not magicConfig.onTargets and not magicConfig.sequenceInterval then magicConfig.sequenceInterval = 0 end
    return monsterAI_checkConfigurations(magicConfig, errorStr)
end

local function checkFeature_magicEffect2(spellT, errorStr)
    if not spellT.magicEffect2 then return true end
    errorStr = errorStr.."magicEffect2."
    return magicEffecCheck(spellT.magicEffect2, errorStr)
end

local function checkFeature_magicEffect(spellT, errorStr)
    if not spellT.magicEffect then return true end
    errorStr = errorStr.."magicEffect."
    return magicEffecCheck(spellT.magicEffect, errorStr)
end

local function checkFeature_teleport(spellT, errorStr)
    if not spellT.teleport then return true end
local parameters = {"effectOnCast", "effectOnPos", "effectInterval", "walkSpeed", "teleportInterval", "unFocus"}

    errorStr = errorStr.."teleport."
    if badParameter(spellT.teleport, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.teleport, errorStr)
end

local function checkFeature_builder(spellT, errorStr)
    if not spellT.builder then return true end
local parameters = {"N", "S", "W", "E", "NW", "NE", "SW", "SE", "removeTime", "startPoint"}

    errorStr = errorStr.."builder."
    if badParameter(spellT.builder, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.builder, errorStr)
end

local function checkFeature_resistance(spellT, errorStr)
    if not spellT.resistance then return true end
local parameters = {PHYSICAL, ICE, FIRE, ENERGY, DEATH, EARTH, HOLY, LD, "duration"}

    errorStr = errorStr.."resistance."
    if badParameter(spellT.resistance, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.resistance, errorStr)
end

local validParamaters = {"dam", "interval", "regen", "maxMP", "maxHP", "speed", "gainHP", "gainMP", "HPinterval", "MPinterval", "sL", "wL", "dL", "sLf", "mL"}
local function checkFeature_conditions(spellT, errorStr)
local conditionsT = spellT.conditions
    if not conditionsT then return true end
local parameters = {"conditionT", "maxStack", "repeatAmount", "interval", "duration", "noMonsters"}
local defaultDuration = conditionsT.duration or 1000
local defaultMaxStack = conditionsT.maxStack or 1

    errorStr = errorStr.."conditions."
    if badParameter(conditionsT, parameters, errorStr) then return end
    for conditionKey, t in pairs(conditionsT.conditionT) do
        if not conditions[conditionKey] then return print("ERROR - conditionKey["..conditionKey.."] is missing from conditions = {} | "..errorStr) end
        if not t.paramT then t.paramT = {} end
        for param, value in pairs(t.paramT) do
            if not isInArray(validParamaters, param) then return print("ERROR - this param does not exist ["..param.."] | "..errorStr) end
        end
        if not t.duration then t.duration = defaultDuration end
        if not t.maxStack then t.maxStack = defaultMaxStack end
    end
    
    if not conditionsT.repeatAmount then conditionsT.repeatAmount = 1 end
    if not conditionsT.interval then conditionsT.interval = 0 end
    return monsterAI_checkConfigurations(conditionsT, errorStr)
end

local function checkFeature_summon(spellT, errorStr)
local summonT = spellT.summon
    if not summonT then return true end
local parameters = {"summons", "maxSummons", "summonAmount"}
local newSummonT = {}
    
    errorStr = errorStr.."summon."
    if badParameter(summonT, parameters, errorStr) then return end

    for monsterName, t in pairs(summonT.summons) do
        if tonumber(monsterName) then
            newSummonT[t] = {amount = 1}
        else
            if not t.amount then t.amount = 1 end
            newSummonT[monsterName] = t
        end
    end
    if not summonT.maxSummons then summonT.maxSummons = 1 end
    summonT.summons = newSummonT
    return monsterAI_checkConfigurations(summonT, errorStr)
end

local function checkFeature_heal(spellT, errorStr)
local healT = spellT.heal

    if not healT then return true end
local parameters = {"interval", "effect", "minHeal", "maxHeal", "percentAmount", "minScale", "maxScale", "race", "maxHPMultiplier", "maxHPLimit", "healTarget", "executeAmount", "repeatInterval"}

    errorStr = errorStr.."heal."
    if badParameter(healT, parameters, errorStr) then return end
    if not healT.percentAmount then
        if not healT.minHeal then return missingError(errorStr, "minHeal") end
        if not healT.maxHeal then healT.maxHeal = healT.minHeal end
    end
    if healT.healTarget then
        if not isInArray({"monster", "player"}, healT.healTarget) then return print("ERROR - wrong value in "..errorStr..".healTarget") end
    end
    
    if not healT.executeAmount then healT.executeAmount = 1 end
    if not healT.repeatInterval then healT.repeatInterval = 0 end
    if not healT.minScale then healT.minScale = 0 end
    if not healT.maxScale then healT.maxScale = 0 end
    if not healT.maxHPLimit then healT.maxHPLimit = 5000 end
    checkRace(healT)
    return monsterAI_checkConfigurations(healT, errorStr)
end

local function checkFeature_stun(spellT, errorStr)
    if not spellT.stun then return true end
local parameters = {"msDuration", "stunL"}
    
    errorStr = errorStr.."stun."
    if not spellT.stunL then spellT.stunL = 0 end
    if not spellT.msDuration then spellT.msDuration = 1000 end
    if badParameter(spellT.stun, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.stun, errorStr)
end

local function checkFeature_bind(spellT, errorStr)
    if not spellT.bind then return true end
local parameters = {"msDuration"}

    errorStr = errorStr.."bind."
    if not spellT.msDuration then spellT.msDuration = 1000 end
    if badParameter(spellT.bind, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.bind, errorStr)
end

local function checkFeature_root(spellT, errorStr)
    if not spellT.root then return true end
    local parameters = {"msDuration"}

    errorStr = errorStr.."root."
    if not spellT.msDuration then spellT.msDuration = 1000 end
    if badParameter(spellT.root, parameters, errorStr) then return end
    return monsterAI_checkConfigurations(spellT.root, errorStr)
end

function monsterAI_checkConfigurations(spellT, errorStr)
    if not checkTargetConfigPassed(spellT, errorStr) then return end
    if not checkPositionPassed(spellT, errorStr) then return end
    if not checkFeature_damage(spellT, errorStr) then return end
    if not checkFeature_changeEnvironment(spellT, errorStr) then return end
    if not checkFeature_event(spellT, errorStr) then return end
    if not checkFeature_say(spellT, errorStr) then return end
    if not checkFeature_spellLock(spellT, errorStr) then return end
    if not checkFeature_spellLockCD(spellT, errorStr) then return end
    if not checkFeature_flyingEffect(spellT, errorStr) then return end
    if not checkFeature_magicEffect(spellT, errorStr) then return end
    if not checkFeature_magicEffect2(spellT, errorStr) then return end
    if not checkFeature_teleport(spellT, errorStr) then return end
    if not checkFeature_builder(spellT, errorStr) then return end
    if not checkFeature_resistance(spellT, errorStr) then return end
    if not checkFeature_conditions(spellT, errorStr) then return end
    if not checkFeature_summon(spellT, errorStr) then return end
    if not checkFeature_heal(spellT, errorStr) then return end
    if not checkFeature_stun(spellT, errorStr) then return end
    if not checkFeature_bind(spellT, errorStr) then return end
    if not checkFeature_root(spellT, errorStr) then return end
    return true
end

function spellCreatingSystem_checkConfig()
    for spellName, spellT in pairs(customSpells) do
        local errorStr = "confT["..spellName.."]."
        
        if not spellT.cooldown then spellT.cooldown = 1000 end
        if not spellT.targetConfig then return missingError(errorStr, "targetConfig") end
        if not spellT.position then return missingError(errorStr, "position") end
        if badParameter(spellT, {"firstCastCD", "cooldown", "locked", "changeTarget", "lockedForSummon"}, errorStr) then return end
        if not monsterAI_checkConfigurations(spellT, errorStr) then return end
    end
end

function spellCreatingSystem_convertspellT(spellT, monsterName)
    local newSpellT = {}
        
    for i, v in pairs(spellT) do
        if tonumber(i) then
            newSpellT[v] = {}
        else
            newSpellT[i] = v
        end
    end
    monsterSpells[monsterName] = newSpellT
end

function spellCreatingSystem_startUp()
    for monsterName, spellT in pairs(monsterSpells) do
        spellCreatingSystem_convertspellT(spellT, monsterName)
    end
end
monsterAIGotError = false