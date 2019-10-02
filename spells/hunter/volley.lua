local area = {
    {3, 3, 3, 3, 3},
    {n, 2, 2, 2, n},
    {n, 1, 1, 1, n},
    {n, n, n, n, n},
    {n, n, 0, n, n},
}

function volleySpell(playerID, spellT)
    local player = Player(playerID)
    if not player then return end

    local playerPos = player:getPosition()
    local dir = getDirectionStrFromCreature(player)
    local area = getAreaPos(playerPos, area, dir)
    local positions = {}
    local obstacleT = limitArea(playerPos, area, "solid", dir)
    playerID = player:getId()
    
    for x=1, 10 do
        local pos = randomPos(area, 1)[1]
        local registerPos = true
        
        for _, t in pairs(positions) do
            if samePositions(t.pos, pos) then
                registerPos = false
                t.times = t.times + 1
                break
            end
        end
        if registerPos then
            if not positions[x] then positions[x] = {} end
            positions[x].times = 1
            positions[x].pos = pos
        end
    end
    
    for _, t in pairs(positions) do
        local pos = t.pos
        
        if obstacleT then
            if obstacleT.x then
                pos = obstacleT
            else
                for _, t in pairs(obstacleT) do
                    if comparePositionT(t.blockedPosT, pos) then
                        pos = t.rootPos
                        break
                    end
                end
            end
        end
        
        local function volley_arrow(pos, delay)
            local tile = Tile(pos)
            if not tile then return end
            local creature = tile:getBottomCreature()
            
            if namiBoots_equipped(player) and getDistanceBetween(playerPos, pos) >= 4 then                
                local path = getPath(playerPos, pos)
                
                for i, pos in ipairs(path) do
                    if i > 1 and i < 4 then -- avoid dmg to start and endPos
                        arrowCombat(player, findCreature("creature", pos), true)
                    end
                end
            end
            
            if creature and creature:isMonster() then
                addEvent(arrowCombat, delay, playerID, creature:getId())
            else
                addEvent(sendArrow, delay, playerID, pos)
            end
        end
        
        for x=1, t.times do volley_arrow(pos, 250*(x-1)) end
    end
end

function arrowCombat(player, target, namiBootsDmg)
    local player = Player(player)
    local target = Creature(target)
    if not player or not target then return end

    local ammo = player:getSlotItem(SLOT_AMMO)
    if not ammo then return end

    local damage = getWeaponBaseDamage(player)
    local ammoT = getAmmoT(ammo)
    local fe = hunterPoison(player, target) and 6 or ammoT.fe
    local targetPos = target:getPosition()
    local damType = PHYSICAL

    damage = damage + sharpening_projectile(player, damage)
    damage = damage + snaipaHelmet(player, damage)
    potions_silence(player, target)
    mummyDollHit(player, target)
    vampireDollHit(player, target)
    if not namiBootsDmg then shootArrow(player, targetPos, ammo, ammoT, 10) end
    fireQuiverDamage(player, target, damage)
    dealDamage(player, target, damType, damage, ammoT.me, O_player_weapons_range, false, fe)
end

function sendArrow(cid, pos)
    local player = Player(cid)
    if not player then return end
    
    local ammo = player:getSlotItem(SLOT_AMMO)
    if not ammo then return end

    local arrowT = getAmmoT(ammo)
    if not arrowT then return end
    
    local fe = hunterPoison(player) and 6 or arrowT.fe

    shootArrow(player, pos, ammo, arrowT)
    doSendDistanceEffect(player:getPosition(), pos, fe)
end