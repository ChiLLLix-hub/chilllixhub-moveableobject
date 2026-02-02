# Contributing to ChilLLLix Hub Moveable Object Script

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

- Be respectful and constructive
- Help maintain a welcoming environment
- Focus on what is best for the community
- Show empathy towards other community members

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:

1. **Clear title** - Describe the issue briefly
2. **Description** - Detailed explanation of the bug
3. **Steps to reproduce** - How to trigger the bug
4. **Expected behavior** - What should happen
5. **Actual behavior** - What actually happens
6. **Environment** - FiveM version, QBCore version, etc.
7. **Screenshots/Logs** - If applicable

Example:
```
Title: Object not spawning at correct coordinates

Description: When I configure an object with coords vector3(100, 200, 30), 
it spawns at a different location.

Steps to reproduce:
1. Add object to config.lua with coords vector3(100, 200, 30)
2. Start resource
3. Go to coordinates
4. Object is not there

Expected: Object spawns at specified coordinates
Actual: Object spawns elsewhere or not at all

Environment:
- FiveM: Build 5848
- QBCore: Latest from master
- Server: Windows/Linux
```

### Suggesting Features

Feature requests are welcome! Please open an issue with:

1. **Feature title** - Clear, concise name
2. **Problem statement** - What problem does this solve?
3. **Proposed solution** - How should it work?
4. **Alternatives** - Other solutions you considered
5. **Use cases** - Real-world scenarios

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch** - `git checkout -b feature/your-feature-name`
3. **Make your changes** - Follow coding standards below
4. **Test thoroughly** - Ensure nothing breaks
5. **Commit with clear messages** - Describe what and why
6. **Push to your fork** - `git push origin feature/your-feature-name`
7. **Open a Pull Request** - Describe your changes

#### Pull Request Guidelines

- One feature/fix per PR
- Update documentation if needed
- Add examples if adding features
- Test with multiple scenarios
- Ensure no performance regressions
- Follow existing code style

## Coding Standards

### Lua Style Guide

1. **Indentation**: 4 spaces (no tabs)
2. **Naming**:
   - Variables: `camelCase` (e.g., `objectData`, `playerCoords`)
   - Constants: `PascalCase` (e.g., `Config`, `ObjectStates`)
   - Functions: `PascalCase` for globals, `camelCase` for local
3. **Comments**: 
   - Use `--` for single-line comments
   - Add comments for complex logic
   - Document function parameters and returns
4. **Functions**: Keep functions small and focused
5. **Error Handling**: Always validate inputs

#### Example Code Style

```lua
-- Good
local function MoveObject(objectName, objectData, targetState)
    if not objectName or not objectData then
        return false
    end
    
    local obj = SpawnedObjects[objectName]
    if not obj or not DoesEntityExist(obj) then
        return false
    end
    
    -- Calculate target position
    local targetCoords = CalculateTarget(objectData, targetState)
    
    return true
end

-- Bad
local function move_object(n,d,s)
if n==nil then return end
local o=SpawnedObjects[n]
if not o then return end
-- no comments, hard to read
end
```

### Performance Guidelines

1. **Avoid tight loops** - Use proper Wait() calls
2. **Distance checks** - Only process nearby entities
3. **Event handlers** - Keep them lightweight
4. **Memory management** - Clean up properly
5. **Network traffic** - Minimize unnecessary syncs

### Security Guidelines

1. **Server validation** - Always validate on server
2. **Input sanitization** - Check all inputs
3. **Permission checks** - Verify access before actions
4. **No trust client** - Client sends requests, server decides
5. **Logging** - Log security-sensitive operations

## Development Setup

1. **Clone repository**
   ```bash
   git clone https://github.com/ChiLLLix-hub/chilllixhub-moveableobject.git
   ```

2. **Set up test server**
   - Install FiveM server
   - Install QBCore framework
   - Add this resource to resources folder
   - Configure test objects in config.lua

3. **Testing**
   - Test with single player
   - Test with multiple players
   - Test all movement types
   - Test all restrictions
   - Test edge cases

## Areas for Contribution

We welcome contributions in these areas:

### High Priority
- Additional movement types (rotation, diagonal)
- Performance optimizations
- Bug fixes
- Documentation improvements
- Translation to other languages

### Medium Priority
- Sound effects system
- Animation improvements
- UI/UX enhancements
- Integration with other scripts
- Example configurations

### Low Priority
- Visual debug tools
- Configuration GUI
- Analytics/monitoring
- Advanced features

## Testing Checklist

Before submitting a PR, ensure:

- [ ] Code follows style guidelines
- [ ] No console errors
- [ ] Works with multiple players
- [ ] Tested vertical movement
- [ ] Tested horizontal movement
- [ ] Tested job restrictions
- [ ] Tested item restrictions
- [ ] No performance regression
- [ ] Documentation updated
- [ ] Examples updated if needed

## Documentation

When adding features, update:

- `README.md` - Main documentation
- `INSTALL.md` - If affecting installation
- `CHANGELOG.md` - Note your changes
- `config.example.lua` - If adding config options
- Code comments - Explain complex logic

## Community

- **Discord**: [Link if available]
- **Issues**: Use GitHub Issues
- **Discussions**: Use GitHub Discussions
- **Updates**: Watch the repository

## Questions?

If you have questions:

1. Check existing documentation
2. Search closed issues
3. Ask in GitHub Discussions
4. Open a new issue

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Recognition

Contributors will be:
- Listed in CHANGELOG.md
- Mentioned in release notes
- Credited in commit messages

Thank you for contributing! 🎉
