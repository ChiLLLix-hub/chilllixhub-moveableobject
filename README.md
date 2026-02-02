# ChilLLLix Hub - Moveable Object Script

A highly optimized FiveM script using the QBCore framework that allows props/objects to move vertically or horizontally with configurable speed and distance when players interact with them.

## Features

- ✅ **QBCore Framework Integration** - Fully compatible with QBCore
- ✅ **Synchronized Movement** - Server-side state management ensures all players see the same object positions
- ✅ **Vertical & Horizontal Movement** - Support for both movement types
- ✅ **Smooth Animations** - Configurable movement speed and steps for smooth transitions
- ✅ **Optimized Performance** - Efficient distance checking and thread management
- ✅ **Job & Item Restrictions** - Optional access control per object
- ✅ **qb-target Support** - Compatible with qb-target or standard interaction
- ✅ **Admin Commands** - Reset objects command for administrators
- ✅ **Safe Coding** - Thread-safe with proper locking mechanisms
- ✅ **Configurable** - Easy-to-use configuration file

## Installation

1. Download or clone this repository
2. Place the `chilllixhub-moveableobject` folder in your server's `resources` directory
3. Add `ensure chilllixhub-moveableobject` to your `server.cfg`
4. Configure your objects in `config.lua`
5. Restart your server

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core) (Required)
- [qb-target](https://github.com/qbcore-framework/qb-target) (Optional - if using target system)

## Configuration

Edit `config.lua` to configure your moveable objects. Example configuration:

```lua
Config.Objects = {
    {
        name = 'warehouse_gate',        -- Unique identifier
        label = 'Warehouse Gate',       -- Display name
        object = 'prop_gate_airport_01', -- Object model hash
        coords = vector3(-1088.49, -2725.67, 13.5), -- Spawn location
        heading = 270.0,                -- Object rotation
        
        movementType = 'vertical',      -- 'vertical' or 'horizontal'
        distance = 5.0,                 -- Movement distance in units
        speed = 0.05,                   -- Movement speed
        
        defaultState = 'closed',        -- Initial state: 'closed' or 'open'
        
        requiresJob = false,            -- Optional: {'police', 'ambulance'}
        requiresItem = false,           -- Optional: 'keycard'
        
        renderDistance = 50.0,          -- Optimization: render distance
    },
}
```

### Movement Types

- **vertical**: Moves object up/down on the Z axis
- **horizontal**: Moves object forward/backward based on heading angle

### Configuration Options

| Option | Type | Description |
|--------|------|-------------|
| `name` | string | Unique identifier for the object |
| `label` | string | Display name shown to players |
| `object` | string | GTA V object/prop model name |
| `coords` | vector3 | Spawn coordinates (x, y, z) |
| `heading` | number | Object rotation (0-360) |
| `movementType` | string | 'vertical' or 'horizontal' |
| `distance` | number | How far object moves (in units) |
| `speed` | number | Movement speed (lower = slower) |
| `defaultState` | string | Initial state: 'closed' or 'open' |
| `stateLabels` | table/boolean | Optional: Custom labels for states (e.g., `{closed = 'Lower', open = 'Raise'}`) |
| `requiresJob` | table/boolean | Job names required for access |
| `requiresItem` | string/boolean | Item name required for access |
| `renderDistance` | number | Distance for optimization |

### Custom State Labels

For objects that aren't doors or barriers (like elevators, platforms, cranes, conveyor belts), you can use custom state labels instead of "Open" and "Close":

```lua
{
    name = 'warehouse_elevator',
    label = 'Elevator Platform',
    -- ... other config ...
    
    -- Custom labels make more sense for non-door objects
    stateLabels = {
        closed = 'Lower',  -- What happens when moving from closed state
        open = 'Raise'     -- What happens when moving from open state
    },
}
```

**Examples of custom labels for different object types:**
- Elevator: `{closed = 'Lower', open = 'Raise'}`
- Crane: `{closed = 'Lift Up', open = 'Lower Down'}`
- Conveyor: `{closed = 'Move Forward', open = 'Move Back'}`
- Bridge: `{closed = 'Extend', open = 'Retract'}`
- Platform: `{closed = 'Raise Platform', open = 'Lower Platform'}`

If `stateLabels` is not provided, the script will default to using "Open" and "Close" terminology.

## Usage

### For Players

1. Approach any configured moveable object
2. When close enough, interaction text will appear
3. Press `E` (or use qb-target) to interact
4. Object will smoothly move to its alternate position
5. All nearby players will see synchronized movement

### Use Cases

This script is versatile and can be used for various types of moveable objects:

**Traditional Objects (using default "Open/Close"):**
- Gates and barriers
- Doors and sliding doors
- Vault doors
- Garage doors

**Non-Traditional Objects (using custom state labels):**
- Elevators and lifts (`Lower` / `Raise`)
- Cargo cranes (`Lift Up` / `Lower Down`)
- Conveyor belts (`Move Forward` / `Move Back`)
- Retractable bridges (`Extend` / `Retract`)
- Loading platforms (`Raise Platform` / `Lower Platform`)
- Moving walls and partitions
- Adjustable ramps
- Any object that moves but isn't a door

See `config.example.lua` for detailed examples of both traditional and non-traditional objects.

### For Administrators

- `/resetobjects` - Reset all moveable objects to their default states (requires admin permissions)

## Performance Optimization

This script includes several optimization features:

- **Distance-based checks** - Objects only process when players are nearby
- **Efficient threading** - Minimal resource usage with smart sleep times
- **Movement locking** - Prevents simultaneous movements causing conflicts
- **Server-side sync** - Single source of truth prevents desync issues
- **Render distance** - Objects can be optimized based on view distance

## Synchronization

The script uses a robust server-client architecture:

1. **Server maintains state** - Single source of truth for all object positions
2. **Client requests movement** - Players send interaction requests to server
3. **Server validates** - Checks permissions, job requirements, and locks
4. **Server broadcasts** - All clients receive synchronized movement commands
5. **Clients animate** - Each client smoothly moves the object locally

## Security Features

- Server-side validation for all movement requests
- Job and item requirement checks
- Movement locking to prevent exploits
- Access control per object
- Admin-only reset command

## Troubleshooting

### Objects not spawning
- Ensure QBCore is loaded before this script
- Check object model names are valid GTA V props
- Verify coordinates are correct

### Objects not synchronized
- Check server console for errors
- Ensure proper FiveM server configuration
- Verify all clients have the resource

### Performance issues
- Reduce `Config.DrawTextDistance` for fewer checks
- Increase `renderDistance` limits
- Adjust `MovementSteps` for smoother/faster movement

## Support

For issues, suggestions, or contributions, please open an issue on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

Created by ChiLLLix Hub for the QBCore framework community.
