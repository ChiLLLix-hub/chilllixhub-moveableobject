# Installation & Quick Start Guide

## Quick Installation Steps

1. **Download the Script**
   - Clone or download this repository
   - Place in your FiveM server's `resources` folder

2. **Add to server.cfg**
   ```cfg
   ensure qb-core
   ensure chilllixhub-moveableobject
   ```

3. **Configure Your First Object**
   - Open `config.lua`
   - Modify the example objects or add your own

4. **Restart Server**
   ```bash
   restart chilllixhub-moveableobject
   ```

## Finding Coordinates

To find coordinates for your objects in-game:

1. Go to the location where you want to place the object
2. Use a coordinate script or use F8 console command:
   ```
   /getcoords
   ```
3. Copy the coordinates (x, y, z) and heading

## Example Configurations

### Vertical Moving Gate
```lua
{
    name = 'police_garage_gate',
    label = 'Police Garage Gate',
    object = 'prop_facgate_07_l',
    coords = vector3(442.37, -1020.15, 28.48),
    heading = 90.0,
    
    movementType = 'vertical',
    distance = 4.5,  -- Moves up 4.5 units
    speed = 0.05,
    
    defaultState = 'closed',
    requiresJob = {'police'},  -- Only police can open
    
    renderDistance = 50.0,
}
```

### Horizontal Sliding Door
```lua
{
    name = 'warehouse_door',
    label = 'Warehouse Sliding Door',
    object = 'prop_sm1_11_garaged',
    coords = vector3(-1088.49, -2725.67, 13.5),
    heading = 0.0,
    
    movementType = 'horizontal',
    distance = 5.0,  -- Slides 5 units forward
    speed = 0.06,
    
    defaultState = 'closed',
    requiresItem = 'warehouse_key',  -- Needs key item
    
    renderDistance = 50.0,
}
```

### Public Access Gate
```lua
{
    name = 'public_gate',
    label = 'Public Gate',
    object = 'prop_gate_bridge_01',
    coords = vector3(1212.46, -3008.27, 5.87),
    heading = 180.0,
    
    movementType = 'vertical',
    distance = 6.0,
    speed = 0.04,  -- Slower movement
    
    defaultState = 'closed',
    requiresJob = false,   -- No job required
    requiresItem = false,  -- No item required
    
    renderDistance = 75.0,
}
```

## Common Object Models

Here are some commonly used object models for gates/doors:

- `prop_gate_airport_01` - Large airport-style gate
- `prop_facgate_07_l` - Facility gate
- `prop_gate_bridge_01` - Bridge gate
- `prop_sm1_11_garaged` - Garage door
- `prop_gate_prison_01` - Prison gate
- `prop_fnccorgm_06a` - Chain link fence gate
- `prop_fnclink_06a` - Security fence
- `prop_container_door` - Container door

## Testing Your Configuration

1. Start your server
2. Join the game
3. Go to the coordinates you configured
4. Look for the 3D text prompt or use qb-target
5. Press E (or click with target) to interact
6. The object should move smoothly

## Troubleshooting

### Object Not Spawning
- Check if coordinates are correct
- Verify object model name exists in GTA V
- Check server console for errors

### Object Not Moving
- Verify movement type (vertical/horizontal)
- Check distance value (make sure it's not 0)
- Look for errors in F8 console

### Access Denied
- Check job requirements in config
- Verify item requirements
- Make sure player has required job/item

### Performance Issues
- Reduce number of objects
- Increase render distance
- Lower movement steps in config

## Advanced Features

### Job Restrictions
```lua
requiresJob = {'police', 'ambulance', 'mechanic'}
```

### Item Requirements
```lua
requiresItem = 'keycard_red'
```

### Speed & Distance
- `speed`: 0.01 (very slow) to 0.1 (very fast)
- `distance`: Units to move (typically 2-10)
- `MovementSteps`: Higher = smoother (50-100 recommended)

### qb-target Integration
Set in main config:
```lua
Config.UseTarget = true
```

## Support

For help or issues:
1. Check this guide
2. Review the main README.md
3. Open an issue on GitHub
4. Join our Discord support server
