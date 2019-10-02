--[[ constructions config table guide
    [AID] = {                       actionID which of the items what can be constructed.
        name = STR                  name of the object
        transform = INT             change the construction site into this itemID.
        items = {itemID = INT}      items needed, INT = count
        repair = {itemID = INT}     if construction is ready the repairing will cost that much.
        duration = INT              how long the part will last in minutes.
        completeDuration = INT      how long the entire construction lasts when all done in minutes.
        brokenTransform = INT       itemID of the tile when half of the duration is passed before crumbling is passed.
        parts = INT                 amount of parts need to be constructed to build full object
        destroyPos = {POS}          position where creatures will be teleported if they stand on bridge while it breaks
        
        -- come later
        positionT = {pos}           generated when part used.
        constructed = true          if construction is ready.
        state = INT                 how many parts constructed.
        time = INT                  how many seconds it is suppose from os.time()+duration
    }
    
]]

constructions = {}