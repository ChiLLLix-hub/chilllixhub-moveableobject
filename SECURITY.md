# Security Features & Considerations

## Built-in Security Features

### 1. Server-Side Validation
All movement requests are validated on the server before execution:
- Object existence verification
- Permission checks (jobs and items)
- State validation (already moving check)
- Lock mechanism to prevent concurrent modifications

### 2. Access Control
Multiple layers of access control:
- **Job Requirements**: Restrict objects to specific jobs
- **Item Requirements**: Require specific items in inventory
- **ACE Permissions**: Admin commands require ACE permissions
- **Server Authority**: Client cannot force movement without server approval

### 3. Input Validation
```lua
-- All inputs are validated
if not ObjectStates[objectName] then
    -- Invalid object name rejection
    return
end

if ObjectLocks[objectName] then
    -- Prevent race conditions
    return
end
```

### 4. State Synchronization
- Server maintains single source of truth
- All state changes broadcast to clients
- Periodic state sync (every 30 seconds)
- Client state reconciliation on connect

### 5. Thread Safety
- Movement locking prevents concurrent operations
- Atomic state updates
- Proper cleanup on resource stop

## Security Best Practices

### Configuration Security

1. **Restrict Sensitive Objects**
```lua
{
    name = 'vault_door',
    -- ...
    requiresJob = {'police', 'admin'},  -- Multiple job options
    requiresItem = 'special_keycard',    -- Additional layer
}
```

2. **Use ACE Permissions**
- Configure server.cfg with proper ACE permissions
- Don't rely solely on job checks
- Example ACE configuration:
```cfg
add_ace group.admin command.resetobjects allow
add_principal identifier.steam:110000xxxxxxxx group.admin
```

### Server Configuration

1. **Rate Limiting** (Optional Enhancement)
Consider adding rate limiting for interactions:
```lua
-- Track last interaction time per player
local lastInteraction = {}

-- In requestMove event:
local currentTime = os.time()
if lastInteraction[src] and (currentTime - lastInteraction[src]) < 2 then
    -- Player is spamming, reject
    return
end
lastInteraction[src] = currentTime
```

2. **Logging** (Optional Enhancement)
Add logging for security-sensitive operations:
```lua
print(string.format('[MoveableObject] Player %d moved %s to state %s', 
    src, objectName, newState))
```

## Known Security Considerations

### 1. Client-Side Object Spawning
- Objects are spawned client-side for performance
- Coordinates are from config (trusted source)
- Objects are frozen and mission entities

**Risk**: Low - Config is server-controlled

### 2. Network Events
All network events use server validation:
- `moveable-object:server:requestMove` - Server validates all requests
- `moveable-object:client:syncMove` - Server-to-client only (broadcast)

**Risk**: Low - Proper client-server architecture

### 3. QBCore Dependency
Script depends on QBCore:
- Player object retrieval
- Job checking
- Item verification
- Notification system

**Risk**: Medium - Ensure QBCore is up-to-date and properly configured

### 4. Admin Commands
Reset command uses ACE permissions:
```lua
if IsPlayerAceAllowed(source, 'command.resetobjects') or 
   IsPlayerAceAllowed(source, 'command') then
    -- Allow reset
end
```

**Risk**: Low - Requires explicit ACE permission grant

## Potential Vulnerabilities & Mitigations

### 1. SQL Injection
**Status**: Not Applicable
- Script doesn't use database queries
- All data is in-memory or config-based

### 2. XSS/Code Injection
**Status**: Not Applicable
- Lua doesn't execute HTML/JS
- No user input directly executed

### 3. Denial of Service (DoS)
**Potential Risk**: Object spam
**Mitigation**: 
- Movement locking prevents rapid-fire
- Server-side validation
- Optional: Add rate limiting (see above)

### 4. Permission Bypass
**Risk**: Low
**Mitigation**:
- All checks on server
- Multiple validation layers
- ACE permission system

### 5. State Desynchronization
**Risk**: Low
**Mitigation**:
- Server is source of truth
- Periodic state sync
- Movement locking
- Client reconciliation on join

## Security Checklist

Before deployment, ensure:

- [ ] Review all configured objects and their restrictions
- [ ] Set up proper ACE permissions for admin commands
- [ ] Test job restrictions work as expected
- [ ] Test item restrictions work as expected
- [ ] Verify objects spawn at correct locations
- [ ] Test that non-authorized players cannot move restricted objects
- [ ] Verify state synchronization works with multiple players
- [ ] Test resource restart doesn't break object states
- [ ] Review server console for any errors
- [ ] Monitor server performance with objects active

## Reporting Security Issues

If you discover a security vulnerability:

1. Do NOT open a public issue
2. Contact the repository owner directly
3. Provide detailed reproduction steps
4. Wait for confirmation before disclosure

## Security Updates

Stay updated:
- Watch the repository for security patches
- Keep QBCore framework updated
- Review changelogs for security fixes
- Test updates in development environment first

## Compliance

This script:
- ✅ Follows FiveM server security best practices
- ✅ Uses server-authoritative architecture
- ✅ Validates all user inputs
- ✅ Implements proper access control
- ✅ Maintains audit trail capability (with optional logging)
- ✅ Prevents common exploits (duping, unauthorized access)

## Summary

**Overall Security Rating**: Good

The script implements proper security measures for a FiveM resource:
- Server-side validation and authority
- Multi-layer access control
- Thread-safe operations
- State synchronization
- No obvious vulnerabilities

**Recommendation**: Safe for production use with proper configuration and ACE permissions.
