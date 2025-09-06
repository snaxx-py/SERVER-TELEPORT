-- // Script //

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local Button = Instance.new("TextButton", Frame)
local UICorner = Instance.new("UICorner", Button)

-- Estilo del Frame
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

-- Estilo del botón
Button.Size = UDim2.new(1, -20, 1, -20)
Button.Position = UDim2.new(0, 10, 0, 10)
Button.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
Button.Text = "Cambiar de server"
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.TextScaled = true
UICorner.CornerRadius = UDim.new(0, 12)

-- Función para cambiar de server
local function TeleportToServer()
    local servers = {}
    local cursor = ""

    local success, result = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor)
        )
    end)

    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], player)
    else
        warn("No hay servidores disponibles que no estén llenos.")
    end
end

-- Click del botón
Button.MouseButton1Click:Connect(TeleportToServer)
