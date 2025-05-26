local function copyToClipboard(data)
    lib.setClipboard(data)
    exports['wix_core']:Notify(Config.Locales.Copied, data .. ' ' .. Config.Locales.Description, 'info')
end

local function getPlayerCoords()
    local ped = PlayerPedId()
    return GetEntityCoords(ped)
end

local function getHeading()
    return GetEntityHeading(PlayerPedId())
end

local isActive = false

local function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x
        , destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

local function toggle3DCoords()
    isActive = not isActive
    
    if isActive then
        exports['wix_core']:Notify(Config.Locales.ThreeDCoords, Config.Locales.ThreeDCoordsActivated, 'success')
    else
        exports['wix_core']:Notify(Config.Locales.ThreeDCoords, Config.Locales.ThreeDCoordsDeactivated, 'error')
    end
    
    CreateThread(function()
        while isActive do
            local plyCoords = GetEntityCoords(PlayerPedId())
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            if hit then
                DrawLine(plyCoords.x, plyCoords.y, plyCoords.z, coords.x, coords.y, coords.z, 0, 255, 0, 100)
                DrawSphere(coords.x, coords.y, coords.z, 0.2, 0, 255, 0, 0.8)
            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                DrawLine(plyCoords.x, plyCoords.y, plyCoords.z, coords.x, coords.y, coords.z, 0, 255, 0, 100)
                DrawSphere(coords.x, coords.y, coords.z, 0.2, 0, 255, 0, 0.8)
            end
            if IsControlJustPressed(0, Config.Copy3DControl) then
                data = string.format('%.3f, %.3f, %.3f', coords.x, coords.y, coords.z)
                lib.setClipboard(data)
                exports['wix_core']:Notify(Config.Locales.ThreeDCoords, data .. ' ' .. Config.Locales.Description, 'info')
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent('wix_coords_menu:copy', function(data)
    local coords = getPlayerCoords()
    local heading = getHeading()

    if data.type == 'vector3' then
        copyToClipboard(string.format('vector3(%.3f, %.3f, %.3f)', coords.x, coords.y, coords.z))
    elseif data.type == 'vector4' then
        copyToClipboard(string.format('vector4(%.3f, %.3f, %.3f, %.3f)', coords.x, coords.y, coords.z, heading))
    elseif data.type == 'xyz' then
        copyToClipboard(string.format('%.3f, %.3f, %.3f', coords.x, coords.y, coords.z))
    elseif data.type == 'xyz_table' then
        copyToClipboard(string.format('{ x = %.3f, y = %.3f, z = %.3f }', coords.x, coords.y, coords.z))
    elseif data.type == 'heading' then
        copyToClipboard(string.format('%.3f', heading))
    end
end)

lib.registerContext({
    id = 'wix_coords_menu',
    title = Config.Locales.Title,
    options = {
        {
            title = Config.Locales.Vector3,
            description = Config.Locales.Vector3,
            event = 'wix_coords_menu:copy',
            args = { type = 'vector3' },
            icon = 'location-dot'
        },
        {
            title = Config.Locales.Vector4,
            description = Config.Locales.Vector4,
            event = 'wix_coords_menu:copy',
            args = { type = 'vector4' },
            icon = 'location-dot'
        },
        {
            title = Config.Locales.XYZ,
            description = Config.Locales.XYZ,
            event = 'wix_coords_menu:copy',
            args = { type = 'xyz' },
            icon = 'location-dot'
        },
        {
            title = Config.Locales.XYZTable,
            description = Config.Locales.XYZTable,
            event = 'wix_coords_menu:copy',
            args = { type = 'xyz_table' },
            icon = 'location-dot'
        },
        {
            title = Config.Locales.Heading,
            description = Config.Locales.Heading,
            event = 'wix_coords_menu:copy',
            args = { type = 'heading' },
            icon = 'location-dot'
        },
        {
            title = Config.Locales.ThreeDCoords,
            description = Config.Locales.ThreeDCoordsDesc,
            icon = 'crosshairs',
            onSelect = function()
                toggle3DCoords()
                lib.hideContext()
            end,
            metadata = {
                {label = 'Usage', value = Config.Locales.ThreeDCoordsUsage}
            }
        }
    }
})

if Config.Command then
    RegisterCommand(Config.Command, function()
        lib.showContext('wix_coords_menu')
    end)
end

if Config.Keybind then
    lib.addKeybind({
        name = 'wix_coords_menu_open',
        description = 'Open Coords Menu',
        defaultKey = Config.Keybind,
        onPressed = function()
            lib.showContext('wix_coords_menu')
        end
    })
end