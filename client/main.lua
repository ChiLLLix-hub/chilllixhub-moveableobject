local QBCore = exports['qb-core']:GetCoreObject()

-- Client-side object storage
local SpawnedObjects = {}
local ObjectStates = {}
local isMoving = {}

-- Optimized distance checking
local function IsPlayerNearObject(objectCoords, distance)
    local playerCoords = GetEntityCoords(PlayerPedId())
    return #(playerCoords - objectCoords) <= distance
end

-- Smooth movement function
local function MoveObject(objectName, objectData, targetState)
    if isMoving[objectName] then return end
    
    local obj = SpawnedObjects[objectName]
    if not obj or not DoesEntityExist(obj) then return end
    
    isMoving[objectName] = true
    
    local currentCoords = GetEntityCoords(obj)
    local movementType = objectData.movementType
    local distance = objectData.distance
    local speed = objectData.speed or Config.MovementSpeed
    
    -- Calculate target position
    local targetCoords = currentCoords
    local direction = (targetState == 'open') and 1 or -1
    
    if movementType == 'vertical' then
        targetCoords = vector3(currentCoords.x, currentCoords.y, currentCoords.z + (distance * direction))
    elseif movementType == 'horizontal' then
        local heading = objectData.heading
        local rad = math.rad(heading)
        targetCoords = vector3(
            currentCoords.x + (math.cos(rad) * distance * direction),
            currentCoords.y + (math.sin(rad) * distance * direction),
            currentCoords.z
        )
    end
    
    -- Smooth movement using steps
    local steps = Config.MovementSteps
    local stepX = (targetCoords.x - currentCoords.x) / steps
    local stepY = (targetCoords.y - currentCoords.y) / steps
    local stepZ = (targetCoords.z - currentCoords.z) / steps
    
    CreateThread(function()
        for i = 1, steps do
            if not DoesEntityExist(obj) then break end
            
            local newX = currentCoords.x + (stepX * i)
            local newY = currentCoords.y + (stepY * i)
            local newZ = currentCoords.z + (stepZ * i)
            
            SetEntityCoords(obj, newX, newY, newZ, false, false, false, false)
            Wait(speed * 100)
        end
        
        -- Ensure final position is exact
        if DoesEntityExist(obj) then
            SetEntityCoords(obj, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
        end
        
        isMoving[objectName] = false
    end)
end

-- Spawn all objects
local function SpawnObjects()
    for _, objectData in ipairs(Config.Objects) do
        local hash = GetHashKey(objectData.object)
        
        -- Request model
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(10)
        end
        
        -- Create object
        local obj = CreateObject(hash, objectData.coords.x, objectData.coords.y, objectData.coords.z, false, true, false)
        
        -- Set properties
        SetEntityHeading(obj, objectData.heading)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj, true, true)
        
        -- Store reference
        SpawnedObjects[objectData.name] = obj
        
        -- Initialize state
        ObjectStates[objectData.name] = objectData.defaultState or 'closed'
        isMoving[objectData.name] = false
        
        SetModelAsNoLongerNeeded(hash)
    end
    
    print('^2[Moveable Objects]^7 Client spawned ' .. #Config.Objects .. ' objects')
end

-- Delete all objects
local function DeleteObjects()
    for name, obj in pairs(SpawnedObjects) do
        if DoesEntityExist(obj) then
            DeleteObject(obj)
        end
    end
    SpawnedObjects = {}
    ObjectStates = {}
    isMoving = {}
end

-- Initialize on player loaded
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(1000)
    SpawnObjects()
    
    -- Get current states from server
    QBCore.Functions.TriggerCallback('moveable-object:server:getAllStates', function(states)
        if states then
            for name, state in pairs(states) do
                if ObjectStates[name] and state.state ~= ObjectStates[name] then
                    ObjectStates[name] = state.state
                    
                    -- Move to correct position
                    for _, objectData in ipairs(Config.Objects) do
                        if objectData.name == name then
                            if state.state == 'open' then
                                MoveObject(name, objectData, 'open')
                            end
                            break
                        end
                    end
                end
            end
        end
    end)
end)

-- Cleanup on player unload
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeleteObjects()
end)

-- Sync movement from server
RegisterNetEvent('moveable-object:client:syncMove', function(objectName, newState)
    if ObjectStates[objectName] then
        ObjectStates[objectName] = newState
        
        -- Find object config and move
        for _, objectData in ipairs(Config.Objects) do
            if objectData.name == objectName then
                MoveObject(objectName, objectData, newState)
                
                -- Notify player
                if newState == 'open' then
                    QBCore.Functions.Notify(Lang:t('success.opened', {label = objectData.label}), 'success')
                else
                    QBCore.Functions.Notify(Lang:t('success.closed', {label = objectData.label}), 'success')
                end
                break
            end
        end
    end
end)

-- Sync all states from server
RegisterNetEvent('moveable-object:client:syncAllStates', function(states)
    for name, state in pairs(states) do
        if ObjectStates[name] and state.state ~= ObjectStates[name] then
            ObjectStates[name] = state.state
        end
    end
end)

-- Reset all objects
RegisterNetEvent('moveable-object:client:resetAll', function()
    DeleteObjects()
    Wait(500)
    SpawnObjects()
end)

-- Interaction system
if Config.UseTarget then
    -- qb-target implementation
    CreateThread(function()
        for _, objectData in ipairs(Config.Objects) do
            exports['qb-target']:AddBoxZone(
                'moveable_' .. objectData.name,
                objectData.coords,
                1.5, 1.5,
                {
                    name = 'moveable_' .. objectData.name,
                    heading = objectData.heading,
                    debugPoly = false,
                    minZ = objectData.coords.z - 1.0,
                    maxZ = objectData.coords.z + 3.0,
                },
                {
                    options = {
                        {
                            type = 'client',
                            event = 'moveable-object:client:interact',
                            icon = 'fas fa-hand-paper',
                            label = objectData.label,
                            objectName = objectData.name,
                        },
                    },
                    distance = Config.InteractionDistance
                }
            )
        end
    end)
else
    -- Standard DrawText3D interaction
    CreateThread(function()
        while true do
            local sleep = 1000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, objectData in ipairs(Config.Objects) do
                local distance = #(playerCoords - objectData.coords)
                
                if distance <= Config.DrawTextDistance then
                    sleep = 0
                    
                    local currentState = ObjectStates[objectData.name] or 'closed'
                    local text = currentState == 'closed' and Lang:t('interact.open', {label = objectData.label}) or Lang:t('interact.close', {label = objectData.label})
                    
                    if not isMoving[objectData.name] then
                        DrawText3D(objectData.coords.x, objectData.coords.y, objectData.coords.z + 1.0, text)
                        
                        if distance <= Config.InteractionDistance then
                            if IsControlJustReleased(0, 38) then -- E key
                                TriggerEvent('moveable-object:client:interact', {objectName = objectData.name})
                            end
                        end
                    else
                        DrawText3D(objectData.coords.x, objectData.coords.y, objectData.coords.z + 1.0, Lang:t('interact.moving'))
                    end
                end
            end
            
            Wait(sleep)
        end
    end)
end

-- Interaction event
RegisterNetEvent('moveable-object:client:interact', function(data)
    local objectName = data.objectName
    
    if isMoving[objectName] then
        QBCore.Functions.Notify(Lang:t('error.already_moving'), 'error')
        return
    end
    
    -- Request move from server
    TriggerServerEvent('moveable-object:server:requestMove', objectName)
end)

-- Draw 3D Text helper
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Resource start/stop handlers
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(1000)
        SpawnObjects()
        
        -- Get current states from server
        QBCore.Functions.TriggerCallback('moveable-object:server:getAllStates', function(states)
            if states then
                for name, state in pairs(states) do
                    if ObjectStates[name] and state.state ~= ObjectStates[name] then
                        ObjectStates[name] = state.state
                        
                        -- Move to correct position without animation
                        for _, objectData in ipairs(Config.Objects) do
                            if objectData.name == name and state.state == 'open' then
                                local obj = SpawnedObjects[name]
                                if obj and DoesEntityExist(obj) then
                                    local currentCoords = GetEntityCoords(obj)
                                    local targetCoords = currentCoords
                                    local direction = 1
                                    
                                    if objectData.movementType == 'vertical' then
                                        targetCoords = vector3(currentCoords.x, currentCoords.y, currentCoords.z + (objectData.distance * direction))
                                    elseif objectData.movementType == 'horizontal' then
                                        local rad = math.rad(objectData.heading)
                                        targetCoords = vector3(
                                            currentCoords.x + (math.cos(rad) * objectData.distance * direction),
                                            currentCoords.y + (math.sin(rad) * objectData.distance * direction),
                                            currentCoords.z
                                        )
                                    end
                                    
                                    SetEntityCoords(obj, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteObjects()
    end
end)
