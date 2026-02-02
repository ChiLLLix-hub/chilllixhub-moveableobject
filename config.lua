Config = {}

-- General Settings
Config.Locale = 'en'
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Enable qb-target support
Config.InteractionDistance = 2.0 -- Distance to interact with objects
Config.DrawTextDistance = 3.0 -- Distance to show interaction text

-- Movement Settings
Config.MovementSpeed = 0.05 -- Base movement speed (can be overridden per object)
Config.SyncInterval = 100 -- State sync interval in milliseconds
Config.MovementSteps = 50 -- Number of steps for smooth movement

-- Object Configurations
-- Define your moveable objects here
Config.Objects = {
    -- Example: Vertical moving gate
    {
        name = 'warehouse_gate',
        label = 'Warehouse Gate',
        object = 'prop_gate_airport_01', -- Object model
        coords = vector3(-1088.49, -2725.67, 13.5), -- Object spawn location
        heading = 270.0,
        
        -- Movement settings
        movementType = 'vertical', -- 'vertical' or 'horizontal'
        distance = 5.0, -- How far to move in units
        speed = 0.05, -- Movement speed (units per step)
        
        -- Initial state
        defaultState = 'closed', -- 'closed' or 'open'
        
        -- Optional: Custom state labels (for objects that aren't doors/barriers)
        -- stateLabels = {closed = 'Lowered', open = 'Raised'},
        
        -- Optional: Restricted access
        requiresJob = false, -- Set to table of job names to restrict, e.g., {'police', 'ambulance'}
        requiresItem = false, -- Set to item name to require item in inventory
        
        -- Optimization
        renderDistance = 50.0, -- Distance at which object is rendered/active
    },
    
    -- Example: Horizontal sliding door
    {
        name = 'warehouse_door',
        label = 'Warehouse Door',
        object = 'prop_gate_bridge_01',
        coords = vector3(-1095.23, -2725.67, 13.5),
        heading = 0.0,
        
        movementType = 'horizontal',
        distance = 4.0,
        speed = 0.06,
        
        defaultState = 'closed',
        
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 50.0,
    },
    
    -- Add more objects as needed
}
