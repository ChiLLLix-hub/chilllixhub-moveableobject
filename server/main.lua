local QBCore = exports['qb-core']:GetCoreObject()

-- Store object states
local ObjectStates = {}
local ObjectLocks = {} -- Prevent simultaneous movements

-- Initialize object states on resource start
CreateThread(function()
    for i, object in ipairs(Config.Objects) do
        ObjectStates[object.name] = {
            state = object.defaultState or 'closed',
            isMoving = false,
            lastUpdate = 0
        }
        ObjectLocks[object.name] = false
    end
end)

-- Get current state of an object
QBCore.Functions.CreateCallback('moveable-object:server:getState', function(source, cb, objectName)
    if ObjectStates[objectName] then
        cb(ObjectStates[objectName])
    else
        cb(nil)
    end
end)

-- Get all object states (for client initialization)
QBCore.Functions.CreateCallback('moveable-object:server:getAllStates', function(source, cb)
    cb(ObjectStates)
end)

-- Request to move object
RegisterNetEvent('moveable-object:server:requestMove', function(objectName)
    local src = source
    
    -- Validate object exists
    if not ObjectStates[objectName] then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid object', 'error')
        return
    end
    
    -- Check if object is already moving or locked
    if ObjectLocks[objectName] then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.already_moving'), 'error')
        return
    end
    
    -- Find object config
    local objectConfig = nil
    for _, obj in ipairs(Config.Objects) do
        if obj.name == objectName then
            objectConfig = obj
            break
        end
    end
    
    if not objectConfig then
        return
    end
    
    -- Check job requirements
    if objectConfig.requiresJob then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            local hasJob = false
            for _, job in ipairs(objectConfig.requiresJob) do
                if Player.PlayerData.job.name == job then
                    hasJob = true
                    break
                end
            end
            if not hasJob then
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_access'), 'error')
                return
            end
        end
    end
    
    -- Check item requirements
    if objectConfig.requiresItem then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            local hasItem = Player.Functions.GetItemByName(objectConfig.requiresItem)
            if not hasItem then
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.missing_item', {item = objectConfig.requiresItem}), 'error')
                return
            end
        end
    end
    
    -- Lock the object
    ObjectLocks[objectName] = true
    ObjectStates[objectName].isMoving = true
    
    -- Toggle state
    local newState = ObjectStates[objectName].state == 'open' and 'closed' or 'open'
    ObjectStates[objectName].state = newState
    ObjectStates[objectName].lastUpdate = os.time()
    
    -- Sync to all clients
    TriggerClientEvent('moveable-object:client:syncMove', -1, objectName, newState)
    
    -- Unlock after movement duration (calculated based on distance and speed)
    local movementDuration = math.ceil((objectConfig.distance / objectConfig.speed) * Config.MovementSteps * 0.001) + 1
    SetTimeout(movementDuration * 1000, function()
        ObjectLocks[objectName] = false
        ObjectStates[objectName].isMoving = false
    end)
end)

-- Admin command to reset object states
QBCore.Commands.Add('resetobjects', 'Reset all moveable objects (Admin Only)', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'admin' or IsPlayerAceAllowed(source, 'command') then
        for _, object in ipairs(Config.Objects) do
            ObjectStates[object.name] = {
                state = object.defaultState or 'closed',
                isMoving = false,
                lastUpdate = 0
            }
            ObjectLocks[object.name] = false
        end
        TriggerClientEvent('moveable-object:client:resetAll', -1)
        TriggerClientEvent('QBCore:Notify', source, 'All objects reset', 'success')
    else
        TriggerClientEvent('QBCore:Notify', source, 'No permission', 'error')
    end
end)

-- Periodic state sync (every 30 seconds as backup)
CreateThread(function()
    while true do
        Wait(30000)
        TriggerClientEvent('moveable-object:client:syncAllStates', -1, ObjectStates)
    end
end)

print('^2[Moveable Objects]^7 Server initialized with ' .. #Config.Objects .. ' objects')
