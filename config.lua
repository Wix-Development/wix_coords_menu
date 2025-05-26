-- __          _________   __    _____                 _                                  _   
-- \ \        / /_   _\ \ / /   |  __ \               | |                                | |  
--  \ \  /\  / /  | |  \ V /    | |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
--   \ \/  \/ /   | |   > <     | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
--    \  /\  /   _| |_ / . \    | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
--     \/  \/   |_____/_/ \_\   |_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
--                                                            | |                             
--                                                            |_|                             
Config = {}

-- Set the command to open the coords menu or set to false to disable the command
Config.Command = 'coords'

-- Set the default key for the coords menu keybind or set to false to disable the keybind
-- See: https://docs.fivem.net/docs/game-references/controls/
Config.Keybind = 'F6'

-- Set the control used to copy 3D coordinates (default: 38 = E)
-- See: https://docs.fivem.net/docs/game-references/controls/
Config.Copy3DControl = 38

-- LOCALES
Config.Locales = {
    Title = 'Coords Menu',
    Vector3 = 'Copy the Vector3',
    Vector4 = 'Copy the Vector4',
    XYZ = 'Copy the XYZ',
    XYZTable = 'Copy the XYZ Table',
    Heading = 'Copy the Heading',
    Copied = 'Copied!',
    Description = 'has been copied to clipboard.',
    ThreeDCoords = '3D Coordinates',
    ThreeDCoordsDesc = 'Toggle 3D coordinates mode to get coordinates by looking at a specific point',
    ThreeDCoordsUsage = 'Press E to copy coordinates when looking at a point',
    ThreeDCoordsActivated = '3D coords activated. Press E to copy coordinates.',
    ThreeDCoordsDeactivated = '3D coords deactivated',
}