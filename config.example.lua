-- Example Configuration File
-- Copy examples from here to your config.lua

Config.Objects = {
    -- ====================
    -- VERTICAL MOVEMENTS
    -- ====================
    
    -- Example 1: Basic vertical gate (no restrictions)
    {
        name = 'public_barrier',
        label = 'Public Barrier',
        object = 'prop_gate_airport_01',
        coords = vector3(100.0, 200.0, 30.0),
        heading = 0.0,
        
        movementType = 'vertical',
        distance = 5.0,
        speed = 0.05,
        
        defaultState = 'closed',
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 50.0,
    },
    
    -- Example 2: Police-restricted garage gate
    {
        name = 'police_garage',
        label = 'Police Garage Gate',
        object = 'prop_facgate_07_l',
        coords = vector3(442.37, -1020.15, 28.48),
        heading = 90.0,
        
        movementType = 'vertical',
        distance = 4.5,
        speed = 0.04,
        
        defaultState = 'closed',
        requiresJob = {'police'},
        requiresItem = false,
        
        renderDistance = 50.0,
    },
    
    -- Example 3: Fast-moving vertical gate
    {
        name = 'fast_barrier',
        label = 'Fast Barrier',
        object = 'prop_gate_bridge_01',
        coords = vector3(150.0, 250.0, 30.0),
        heading = 180.0,
        
        movementType = 'vertical',
        distance = 6.0,
        speed = 0.08,  -- Faster movement
        
        defaultState = 'closed',
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 60.0,
    },
    
    -- ====================
    -- HORIZONTAL MOVEMENTS
    -- ====================
    
    -- Example 4: Sliding warehouse door
    {
        name = 'warehouse_door',
        label = 'Warehouse Sliding Door',
        object = 'prop_sm1_11_garaged',
        coords = vector3(-1088.49, -2725.67, 13.5),
        heading = 0.0,  -- Slides along heading direction
        
        movementType = 'horizontal',
        distance = 5.0,
        speed = 0.06,
        
        defaultState = 'closed',
        requiresJob = false,
        requiresItem = 'warehouse_key',  -- Requires key
        
        renderDistance = 50.0,
    },
    
    -- Example 5: Prison gate (horizontal slide)
    {
        name = 'prison_gate',
        label = 'Prison Gate',
        object = 'prop_gate_prison_01',
        coords = vector3(1846.0, 2586.0, 45.6),
        heading = 90.0,
        
        movementType = 'horizontal',
        distance = 8.0,  -- Longer slide distance
        speed = 0.05,
        
        defaultState = 'closed',
        requiresJob = {'police', 'corrections'},
        requiresItem = false,
        
        renderDistance = 75.0,
    },
    
    -- Example 6: Mechanic shop door
    {
        name = 'mechanic_door',
        label = 'Mechanic Shop Door',
        object = 'prop_container_door',
        coords = vector3(-350.0, -130.0, 39.0),
        heading = 70.0,
        
        movementType = 'horizontal',
        distance = 4.0,
        speed = 0.07,
        
        defaultState = 'closed',
        requiresJob = {'mechanic'},
        requiresItem = false,
        
        renderDistance = 40.0,
    },
    
    -- ====================
    -- SPECIAL CASES
    -- ====================
    
    -- Example 7: Slow-moving secure gate
    {
        name = 'secure_vault_door',
        label = 'Vault Security Gate',
        object = 'prop_facgate_07_l',
        coords = vector3(255.0, 225.0, 101.8),
        heading = 160.0,
        
        movementType = 'vertical',
        distance = 3.5,
        speed = 0.02,  -- Very slow for dramatic effect
        
        defaultState = 'closed',
        requiresJob = {'police', 'admin'},
        requiresItem = 'vault_keycard',
        
        renderDistance = 30.0,
    },
    
    -- Example 8: Multi-restriction gate
    {
        name = 'military_gate',
        label = 'Military Checkpoint Gate',
        object = 'prop_gate_airport_01',
        coords = vector3(-2360.0, 3249.0, 32.8),
        heading = 150.0,
        
        movementType = 'vertical',
        distance = 7.0,
        speed = 0.04,
        
        defaultState = 'closed',
        requiresJob = {'police', 'army'},  -- Multiple job options
        requiresItem = 'military_id',
        
        renderDistance = 80.0,
    },
    
    -- Example 9: Default open gate
    {
        name = 'park_gate',
        label = 'Park Gate',
        object = 'prop_fnccorgm_06a',
        coords = vector3(-500.0, -800.0, 30.5),
        heading = 0.0,
        
        movementType = 'vertical',
        distance = 4.0,
        speed = 0.05,
        
        defaultState = 'open',  -- Starts in open position
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 50.0,
    },
    
    -- ====================
    -- NON-DOOR OBJECTS WITH CUSTOM LABELS
    -- ====================
    
    -- Example 10: Elevator Platform (uses custom state labels)
    {
        name = 'warehouse_elevator',
        label = 'Elevator Platform',
        object = 'prop_container_01a',
        coords = vector3(200.0, 300.0, 20.0),
        heading = 0.0,
        
        movementType = 'vertical',
        distance = 10.0,  -- Elevator travels 10 units up/down
        speed = 0.03,
        
        defaultState = 'closed',  -- 'closed' = ground floor, 'open' = upper floor
        
        -- Custom labels for states (not "open/close")
        stateLabels = {
            closed = 'Lower',  -- Action to lower the elevator
            open = 'Raise'     -- Action to raise the elevator
        },
        
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 60.0,
    },
    
    -- Example 11: Cargo Crane (custom labels)
    {
        name = 'dock_crane',
        label = 'Cargo Crane',
        object = 'prop_contyard_hook_01',
        coords = vector3(-100.0, -500.0, 35.0),
        heading = 0.0,
        
        movementType = 'vertical',
        distance = 15.0,
        speed = 0.04,
        
        defaultState = 'closed',
        
        -- Crane-specific labels
        stateLabels = {
            closed = 'Lift Up',
            open = 'Lower Down'
        },
        
        requiresJob = {'dock_worker'},
        requiresItem = false,
        
        renderDistance = 80.0,
    },
    
    -- Example 12: Conveyor Belt (horizontal movement with custom labels)
    {
        name = 'factory_conveyor',
        label = 'Conveyor Belt',
        object = 'prop_boxpile_02b',
        coords = vector3(50.0, 150.0, 25.0),
        heading = 90.0,
        
        movementType = 'horizontal',
        distance = 8.0,
        speed = 0.06,
        
        defaultState = 'closed',
        
        -- Conveyor-specific labels
        stateLabels = {
            closed = 'Move Forward',
            open = 'Move Back'
        },
        
        requiresJob = false,
        requiresItem = false,
        
        renderDistance = 50.0,
    },
    
    -- Example 13: Retractable Bridge (horizontal with custom labels)
    {
        name = 'castle_bridge',
        label = 'Castle Bridge',
        object = 'prop_drawbridge_01',
        coords = vector3(400.0, 600.0, 15.0),
        heading = 0.0,
        
        movementType = 'horizontal',
        distance = 6.0,
        speed = 0.03,
        
        defaultState = 'closed',
        
        -- Bridge-specific labels
        stateLabels = {
            closed = 'Extend',
            open = 'Retract'
        },
        
        requiresJob = false,
        requiresItem = 'castle_key',
        
        renderDistance = 70.0,
    },
    
    -- Example 14: Moving Platform (vertical with custom labels)
    {
        name = 'loading_platform',
        label = 'Loading Platform',
        object = 'prop_container_flat',
        coords = vector3(-200.0, 400.0, 18.0),
        heading = 0.0,
        
        movementType = 'vertical',
        distance = 5.0,
        speed = 0.05,
        
        defaultState = 'closed',
        
        -- Platform-specific labels
        stateLabels = {
            closed = 'Raise Platform',
            open = 'Lower Platform'
        },
        
        requiresJob = {'warehouse'},
        requiresItem = false,
        
        renderDistance = 50.0,
    },
}
