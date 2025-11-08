local players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local espEnabled = false
local localPlayer = players.LocalPlayer

-- Tabla para almacenar los highlights
local highlights = {}

-- CREACI脫N DEL GUI ESTILO PET SIMULATOR X
-- ============================================

local function createGUI()
    local playerGui = localPlayer:WaitForChild("PlayerGui")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPController"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = playerGui
    
    -- Bot贸n principal estilo Pet Simulator X
    local MainButton = Instance.new("TextButton")
    MainButton.Name = "MainButton"
    MainButton.Size = UDim2.new(0, 180, 0, 70)
    MainButton.Position = UDim2.new(1, -200, 0, 20) -- Esquina superior derecha
    MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45) -- Gris oscuro por defecto
    MainButton.BackgroundTransparency = 0.3
    MainButton.BorderSizePixel = 0
    MainButton.Text = ""
    MainButton.AutoButtonColor = false
    MainButton.Parent = ScreenGui
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 16)
    ButtonCorner.Parent = MainButton
    
    -- Contorno animado (gradiente rotatorio)
    local AnimatedStroke = Instance.new("UIStroke")
    AnimatedStroke.Name = "AnimatedStroke"
    AnimatedStroke.Color = Color3.fromRGB(100, 100, 120)
    AnimatedStroke.Thickness = 3
    AnimatedStroke.Transparency = 0.3
    AnimatedStroke.Parent = MainButton
    
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
    }
    StrokeGradient.Rotation = 0
    StrokeGradient.Parent = AnimatedStroke
    
    -- Animaci贸n continua del contorno
    task.spawn(function()
        while MainButton and MainButton.Parent do
            local rotateTween = TweenService:Create(StrokeGradient,
                TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                {Rotation = 360}
            )
            rotateTween:Play()
            task.wait(100)
        end
    end)
    
    -- Gradiente de fondo
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
    }
    BackgroundGradient.Rotation = 90
    BackgroundGradient.Parent = MainButton
    
    -- Efecto de brillo interno
    local InnerGlow = Instance.new("Frame")
    InnerGlow.Name = "InnerGlow"
    InnerGlow.Size = UDim2.new(1, -8, 1, -8)
    InnerGlow.Position = UDim2.new(0, 4, 0, 4)
    InnerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerGlow.BackgroundTransparency = 0.95
    InnerGlow.BorderSizePixel = 0
    InnerGlow.Parent = MainButton
    
    local InnerGlowCorner = Instance.new("UICorner")
    InnerGlowCorner.CornerRadius = UDim.new(0, 13)
    InnerGlowCorner.Parent = InnerGlow
    
    -- Icono/Emoji (cambiado a 馃懁)
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "IconLabel"
    IconLabel.Size = UDim2.new(0, 35, 0, 35)
    IconLabel.Position = UDim2.new(0, 12, 0.5, -17)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "馃懁"
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 28
    IconLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    IconLabel.Parent = MainButton
    
    -- Texto principal (cambiado a ESP)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.Size = UDim2.new(1, -55, 0, 25)
    TextLabel.Position = UDim2.new(0, 50, 0, 12)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "ESP"
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 16
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = MainButton
    
    -- Estado
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -55, 0, 18)
    StatusLabel.Position = UDim2.new(0, 50, 0, 38)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Desactivado"
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainButton
    
    -- Efecto de part铆culas/brillo cuando est谩 activo
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Name = "ParticleContainer"
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.ClipsDescendants = true
    ParticleContainer.Parent = MainButton
    
    local ParticleCorner = Instance.new("UICorner")
    ParticleCorner.CornerRadius = UDim.new(0, 16)
    ParticleCorner.Parent = ParticleContainer
    
    return {
        ScreenGui = ScreenGui,
        MainButton = MainButton,
        StatusLabel = StatusLabel,
        IconLabel = IconLabel,
        TextLabel = TextLabel,
        AnimatedStroke = AnimatedStroke,
        StrokeGradient = StrokeGradient,
        BackgroundGradient = BackgroundGradient,
        InnerGlow = InnerGlow,
        ParticleContainer = ParticleContainer
    }
end

-- Crear el GUI
local gui = createGUI()

-- Funci贸n para determinar el color seg煤n el team
local function getESPColor(player)
    if localPlayer.Team and player.Team then
        if player == localPlayer then
            return Color3.fromRGB(200, 100, 255) -- Morado para el jugador local con equipos
        end
        
        if localPlayer.Team == player.Team then
            return Color3.fromRGB(70, 130, 255) -- Azul para aliados
        else
            return Color3.fromRGB(255, 70, 70) -- Rojo para enemigos
        end
    end
    
    if player == localPlayer then
        return Color3.fromRGB(70, 130, 255) -- Azul para el jugador local sin equipos
    end
    
    return Color3.fromRGB(150, 150, 150) -- Gris para otros jugadores sin sistema de equipos
end

-- Funci贸n para animar el highlight con efecto de aparici贸n suave
local function animateHighlightAppearance(highlight, isAppearing)
    if isAppearing then
        -- Empezar completamente transparente
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 1
        
        -- Animar a la transparencia normal
        local fillTween = TweenService:Create(highlight,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {FillTransparency = 0.5}
        )
        
        local outlineTween = TweenService:Create(highlight,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {OutlineTransparency = 0.3}
        )
        
        fillTween:Play()
        outlineTween:Play()
    else
        -- Desaparecer suavemente
        local fillTween = TweenService:Create(highlight,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {FillTransparency = 1}
        )
        
        local outlineTween = TweenService:Create(highlight,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {OutlineTransparency = 1}
        )
        
        fillTween:Play()
        outlineTween:Play()
    end
end

-- Funci贸n para crear efecto de pulso suave en el highlight
local function createPulseEffect(highlight)
    if not highlight or not highlight.Parent then return end
    
    task.spawn(function()
        while highlight and highlight.Parent and highlight.Enabled do
            -- Pulso sutil de brillo
            local pulseTween = TweenService:Create(highlight,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {FillTransparency = 0.4}
            )
            pulseTween:Play()
            pulseTween.Completed:Wait()
            
            if not highlight or not highlight.Parent or not highlight.Enabled then break end
            
            local returnTween = TweenService:Create(highlight,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {FillTransparency = 0.5}
            )
            returnTween:Play()
            returnTween.Completed:Wait()
        end
    end)
end

-- Funci贸n para crear ESP con efectos mejorados
local function createESP(player)
    if not player.Character then return end
    
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = getESPColor(player)
    highlight.FillTransparency = 1 -- Empezar invisible
    highlight.OutlineTransparency = 1 -- Empezar invisible
    highlight.Parent = player.Character
    highlight.Enabled = espEnabled
    
    highlights[player] = highlight
    
    -- Si el ESP est谩 activado, animar la aparici贸n
    if espEnabled then
        animateHighlightAppearance(highlight, true)
        task.delay(0.8, function()
            createPulseEffect(highlight)
        end)
    end
end

-- Funci贸n para remover ESP
local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

-- Funci贸n para actualizar el color del ESP cuando cambia de equipo con transici贸n
local function updateESPColor(player)
    if highlights[player] and highlights[player].Parent then
        local newColor = getESPColor(player)
        
        -- Transici贸n suave de color
        local colorTween = TweenService:Create(highlights[player],
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {FillColor = newColor}
        )
        colorTween:Play()
    end
end

-- Funci贸n para actualizar todos los ESP con animaciones
local function updateAllESP()
    for player, highlight in pairs(highlights) do
        if highlight and highlight.Parent then
            if espEnabled then
                -- Activar con animaci贸n suave
                highlight.Enabled = true
                animateHighlightAppearance(highlight, true)
                task.delay(0.8, function()
                    createPulseEffect(highlight)
                end)
            else
                -- Desactivar con animaci贸n suave
                animateHighlightAppearance(highlight, false)
                task.delay(0.6, function()
                    if highlight and highlight.Parent then
                        highlight.Enabled = false
                    end
                end)
            end
        end
    end
end

-- Funci贸n para crear efecto de onda al activar/desactivar
local function createRippleEffect(isOn)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = isOn and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(150, 150, 160)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 5
    ripple.Parent = gui.ParticleContainer
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    local expandTween = TweenService:Create(ripple, 
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(1.5, 0, 1.5, 0),
            BackgroundTransparency = 1
        }
    )
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Funci贸n para crear part铆culas flotantes
local function createFloatingParticles(isOn)
    if not isOn then return end
    
    for i = 1, 6 do
        task.delay(i * 0.08, function()
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
            particle.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
            particle.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
            particle.BackgroundTransparency = 0.3
            particle.BorderSizePixel = 0
            particle.ZIndex = 4
            particle.Parent = gui.ParticleContainer
            
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            
            local floatTween = TweenService:Create(particle,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {
                    Position = UDim2.new(particle.Position.X.Scale, 0, -0.2, 0),
                    BackgroundTransparency = 1
                }
            )
            
            floatTween:Play()
            floatTween.Completed:Connect(function()
                particle:Destroy()
            end)
        end)
    end
end

-- Funci贸n para pulsar el icono
local function pulseIcon(isOn)
    local pulseTween = TweenService:Create(gui.IconLabel,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {TextSize = isOn and 32 or 28}
    )
    
    pulseTween:Play()
    pulseTween.Completed:Connect(function()
        local returnTween = TweenService:Create(gui.IconLabel,
            TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {TextSize = 28}
        )
        returnTween:Play()
    end)
end

-- Funci贸n para animar el brillo interno
local function animateInnerGlow(isOn)
    local glowTween = TweenService:Create(gui.InnerGlow,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = isOn and 0.85 or 0.95}
    )
    glowTween:Play()
end

-- Animaci贸n del bot贸n mejorada con efectos visuales
local function animateButton(isOn)
    local targetColor = isOn and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(40, 40, 45)
    local targetStrokeColor = isOn and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(100, 100, 120)
    local targetText = isOn and "Activado" or "Desactivado"
    
    -- Efecto de rebote suave al cambiar de estado
    local bounceTween = TweenService:Create(gui.MainButton,
        TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 185, 0, 73)}
    )
    bounceTween:Play()
    
    bounceTween.Completed:Connect(function()
        local returnTween = TweenService:Create(gui.MainButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 180, 0, 70)}
        )
        returnTween:Play()
    end)
    
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Animar el fondo del bot贸n
    local buttonTween = TweenService:Create(gui.MainButton, tweenInfo, {
        BackgroundColor3 = targetColor
    })
    
    -- Animar el contorno con efecto m谩s pronunciado
    local strokeTween = TweenService:Create(gui.AnimatedStroke, tweenInfo, {
        Color = targetStrokeColor,
        Transparency = isOn and 0.05 or 0.3,
        Thickness = isOn and 4 or 3
    })
    
    -- Animar el gradiente del contorno
    if isOn then
        gui.StrokeGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 130, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 200, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 130, 255))
        }
    else
        gui.StrokeGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
        }
    end
    
    -- Animar el gradiente del fondo
    local gradientTween = TweenService:Create(gui.BackgroundGradient, tweenInfo, {
        Rotation = isOn and 45 or 90
    })
    
    -- Ejecutar las animaciones principales
    buttonTween:Play()
    strokeTween:Play()
    gradientTween:Play()
    
    -- Efectos visuales adicionales
    createRippleEffect(isOn)
    pulseIcon(isOn)
    animateInnerGlow(isOn)
    createFloatingParticles(isOn)
    
    -- Animar el texto del estado con fade
    gui.StatusLabel.TextTransparency = 1
    gui.StatusLabel.Text = targetText
    
    local textFadeTween = TweenService:Create(gui.StatusLabel,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
            TextColor3 = isOn and Color3.fromRGB(150, 200, 255) or Color3.fromRGB(150, 150, 160)
        }
    )
    textFadeTween:Play()
end

-- Evento del bot贸n
gui.MainButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    animateButton(espEnabled)
    updateAllESP()
end)

-- Evento cuando se agrega un jugador
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        wait(0.1)
        createESP(player)
    end)
    
    if player.Character then
        createESP(player)
    end
    
    player:GetPropertyChangedSignal("Team"):Connect(function()
        updateESPColor(player)
        for otherPlayer, _ in pairs(highlights) do
            if otherPlayer ~= player then
                updateESPColor(otherPlayer)
            end
        end
    end)
end

-- Evento cuando se remueve un jugador
local function onPlayerRemoving(player)
    removeESP(player)
end

-- Escuchamos cambios de equipo del jugador local
localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    for player, _ in pairs(highlights) do
        updateESPColor(player)
    end
end)

-- Inicializamos el ESP para todos los jugadores existentes
for _, player in ipairs(players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Conectar eventos para nuevos jugadores
players.PlayerAdded:Connect(onPlayerAdded)
players.PlayerRemoving:Connect(onPlayerRemoving)

-- Sistema de Telekinesis/Grip + Script Externo Permanente
-- Compatible con R6/R15 y PC/Mobile
-- Ejecutar en executor

-- ==========================================
-- CARGAR SCRIPT EXTERNO
-- ==========================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty1.lua"))()

-- ==========================================
-- SISTEMA DE GRIP PERMANENTE
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Variables principales
local gripModeActive = false
local isHoldingObject = false
local currentObject = nil
local currentHighlight = nil
local bodyPosition = nil
local bodyGyro = nil
local updateFriend = nil
local screenGui = nil
local gui = {}
local savedCollisionStates = {}

-- Configuraci贸n
local GRIP_OFFSET = Vector3.new(0, 1.2, 0)
local MAX_DETECTION_DISTANCE = 500
local HIGHLIGHT_COLOR = Color3.fromRGB(100, 200, 255)

-- Funci贸n para obtener la cabeza del personaje (R6/R15)
local function getCharacterHead()
    local character = player.Character
    if not character then return nil end
    return character:FindFirstChild("Head")
end

-- Funci贸n para obtener HumanoidRootPart
local function getHumanoidRootPart()
    local character = player.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

-- CREACI脫N DEL GUI ESTILO PET SIMULATOR X
local function createUI()
    -- Eliminar UI anterior si existe
    if screenGui then
        screenGui:Destroy()
    end
    
    -- Crear ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GripSystemUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    
    -- Proteger contra eliminaci贸n
    local success = pcall(function()
        if gethui then
            screenGui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(screenGui)
            screenGui.Parent = game:GetService("CoreGui")
        else
            screenGui.Parent = player:WaitForChild("PlayerGui")
        end
    end)
    
    if not success then
        screenGui.Parent = player:WaitForChild("PlayerGui")
    end
    
    -- Bot贸n principal estilo Pet Simulator X
    local MainButton = Instance.new("TextButton")
    MainButton.Name = "MainButton"
    MainButton.Size = UDim2.new(0, 180, 0, 70)
    MainButton.Position = UDim2.new(1, -200, 1, -90) -- Esquina inferior derecha
    MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45) -- Gris oscuro por defecto
    MainButton.BackgroundTransparency = 0.3
    MainButton.BorderSizePixel = 0
    MainButton.Text = ""
    MainButton.AutoButtonColor = false
    MainButton.Parent = screenGui
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 16)
    ButtonCorner.Parent = MainButton
    
    -- Contorno animado (gradiente rotatorio)
    local AnimatedStroke = Instance.new("UIStroke")
    AnimatedStroke.Name = "AnimatedStroke"
    AnimatedStroke.Color = Color3.fromRGB(100, 100, 120)
    AnimatedStroke.Thickness = 3
    AnimatedStroke.Transparency = 0.3
    AnimatedStroke.Parent = MainButton
    
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
    }
    StrokeGradient.Rotation = 0
    StrokeGradient.Parent = AnimatedStroke
    
    -- Animaci贸n continua del contorno
    task.spawn(function()
        while MainButton and MainButton.Parent do
            local rotateTween = TweenService:Create(StrokeGradient,
                TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                {Rotation = 360}
            )
            rotateTween:Play()
            task.wait(100)
        end
    end)
    
    -- Gradiente de fondo
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
    }
    BackgroundGradient.Rotation = 90
    BackgroundGradient.Parent = MainButton
    
    -- Efecto de brillo interno
    local InnerGlow = Instance.new("Frame")
    InnerGlow.Name = "InnerGlow"
    InnerGlow.Size = UDim2.new(1, -8, 1, -8)
    InnerGlow.Position = UDim2.new(0, 4, 0, 4)
    InnerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerGlow.BackgroundTransparency = 0.95
    InnerGlow.BorderSizePixel = 0
    InnerGlow.Parent = MainButton
    
    local InnerGlowCorner = Instance.new("UICorner")
    InnerGlowCorner.CornerRadius = UDim.new(0, 13)
    InnerGlowCorner.Parent = InnerGlow
    
    -- Icono/Emoji (馃枑锔� cuando est谩 desactivado, 鉁� cuando est谩 activado)
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "IconLabel"
    IconLabel.Size = UDim2.new(0, 35, 0, 35)
    IconLabel.Position = UDim2.new(0, 12, 0.5, -17)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "馃枑锔�"
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 28
    IconLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    IconLabel.Parent = MainButton
    
    -- Texto principal
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.Size = UDim2.new(1, -55, 0, 25)
    TextLabel.Position = UDim2.new(0, 50, 0, 12)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "GRIP"
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 16
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = MainButton
    
    -- Estado
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -55, 0, 18)
    StatusLabel.Position = UDim2.new(0, 50, 0, 38)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Desactivado"
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainButton
    
    -- Efecto de part铆culas/brillo cuando est谩 activo
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Name = "ParticleContainer"
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.ClipsDescendants = true
    ParticleContainer.Parent = MainButton
    
    local ParticleCorner = Instance.new("UICorner")
    ParticleCorner.CornerRadius = UDim.new(0, 16)
    ParticleCorner.Parent = ParticleContainer
    
    -- Conectar evento del bot贸n
    MainButton.Activated:Connect(toggleGripMode)
    
    -- Guardar referencias
    gui = {
        ScreenGui = screenGui,
        MainButton = MainButton,
        StatusLabel = StatusLabel,
        IconLabel = IconLabel,
        TextLabel = TextLabel,
        AnimatedStroke = AnimatedStroke,
        StrokeGradient = StrokeGradient,
        BackgroundGradient = BackgroundGradient,
        InnerGlow = InnerGlow,
        ParticleContainer = ParticleContainer
    }
end

-- Funci贸n para crear efecto de onda al activar/desactivar
local function createRippleEffect(isOn)
    if not gui.ParticleContainer then return end
    
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = isOn and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(150, 150, 160)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 5
    ripple.Parent = gui.ParticleContainer
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    local expandTween = TweenService:Create(ripple, 
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(1.5, 0, 1.5, 0),
            BackgroundTransparency = 1
        }
    )
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Funci贸n para crear part铆culas flotantes
local function createFloatingParticles(isOn)
    if not isOn or not gui.ParticleContainer then return end
    
    for i = 1, 6 do
        task.delay(i * 0.08, function()
            if not gui.ParticleContainer then return end
            
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
            particle.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
            particle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            particle.BackgroundTransparency = 0.3
            particle.BorderSizePixel = 0
            particle.ZIndex = 4
            particle.Parent = gui.ParticleContainer
            
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            
            local floatTween = TweenService:Create(particle,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {
                    Position = UDim2.new(particle.Position.X.Scale, 0, -0.2, 0),
                    BackgroundTransparency = 1
                }
            )
            
            floatTween:Play()
            floatTween.Completed:Connect(function()
                particle:Destroy()
            end)
        end)
    end
end

-- Funci贸n para pulsar el icono
local function pulseIcon(isOn)
    if not gui.IconLabel then return end
    
    local pulseTween = TweenService:Create(gui.IconLabel,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {TextSize = isOn and 32 or 28}
    )
    
    pulseTween:Play()
    pulseTween.Completed:Connect(function()
        local returnTween = TweenService:Create(gui.IconLabel,
            TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {TextSize = 28}
        )
        returnTween:Play()
    end)
end

-- Funci贸n para animar el brillo interno
local function animateInnerGlow(isOn)
    if not gui.InnerGlow then return end
    
    local glowTween = TweenService:Create(gui.InnerGlow,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = isOn and 0.85 or 0.95}
    )
    glowTween:Play()
end

-- Animaci贸n del bot贸n mejorada con efectos visuales
local function animateButton(isOn)
    if not gui.MainButton then return end
    
    local targetColor = isOn and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(40, 40, 45) -- Celeste cuando est谩 ON
    local targetStrokeColor = isOn and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(100, 100, 120)
    local targetText = isOn and "Activado" or "Desactivado"
    local targetIcon = isOn and "鉁�" or "馃枑锔�"
    
    -- Efecto de rebote suave al cambiar de estado
    local bounceTween = TweenService:Create(gui.MainButton,
        TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 185, 0, 73)}
    )
    bounceTween:Play()
    
    bounceTween.Completed:Connect(function()
        local returnTween = TweenService:Create(gui.MainButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 180, 0, 70)}
        )
        returnTween:Play()
    end)
    
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Animar el fondo del bot贸n
    local buttonTween = TweenService:Create(gui.MainButton, tweenInfo, {
        BackgroundColor3 = targetColor
    })
    
    -- Animar el contorno con efecto m谩s pronunciado
    local strokeTween = TweenService:Create(gui.AnimatedStroke, tweenInfo, {
        Color = targetStrokeColor,
        Transparency = isOn and 0.05 or 0.3,
        Thickness = isOn and 4 or 3
    })
    
    -- Animar el gradiente del contorno
    if isOn then
        gui.StrokeGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
        }
    else
        gui.StrokeGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
        }
    end
    
    -- Animar el gradiente del fondo
    local gradientTween = TweenService:Create(gui.BackgroundGradient, tweenInfo, {
        Rotation = isOn and 45 or 90
    })
    
    -- Ejecutar las animaciones principales
    buttonTween:Play()
    strokeTween:Play()
    gradientTween:Play()
    
    -- Cambiar icono
    gui.IconLabel.Text = targetIcon
    
    -- Efectos visuales adicionales
    createRippleEffect(isOn)
    pulseIcon(isOn)
    animateInnerGlow(isOn)
    createFloatingParticles(isOn)
    
    -- Animar el texto del estado con fade
    gui.StatusLabel.TextTransparency = 1
    gui.StatusLabel.Text = targetText
    
    local textFadeTween = TweenService:Create(gui.StatusLabel,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextTransparency = 0,
            TextColor3 = isOn and Color3.fromRGB(150, 230, 255) or Color3.fromRGB(150, 150, 160)
        }
    )
    textFadeTween:Play()
end

-- Funci贸n para animar el highlight con efecto de aparici贸n suave
local function animateHighlightAppearance(highlight, isAppearing)
    if isAppearing then
        -- Empezar completamente transparente
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 1
        
        -- Animar a la transparencia normal
        local fillTween = TweenService:Create(highlight,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {FillTransparency = 0.3}
        )
        
        local outlineTween = TweenService:Create(highlight,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {OutlineTransparency = 0.1}
        )
        
        fillTween:Play()
        outlineTween:Play()
        
        -- Efecto de pulso suave al agarrar
        task.delay(0.8, function()
            if highlight and highlight.Parent then
                local pulseTween = TweenService:Create(highlight,
                    TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {FillTransparency = 0.2}
                )
                pulseTween:Play()
            end
        end)
    else
        -- Desaparecer suavemente
        local fillTween = TweenService:Create(highlight,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {FillTransparency = 1}
        )
        
        local outlineTween = TweenService:Create(highlight,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {OutlineTransparency = 1}
        )
        
        fillTween:Play()
        outlineTween:Play()
    end
end

-- Funci贸n para crear highlight mejorado
local function createHighlight(part)
    if currentHighlight then
        currentHighlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = part
    highlight.FillColor = HIGHLIGHT_COLOR
    highlight.FillTransparency = 1 -- Empezar invisible
    highlight.OutlineColor = Color3.fromRGB(80, 180, 255)
    highlight.OutlineTransparency = 1 -- Empezar invisible
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = part
    
    currentHighlight = highlight
    
    -- Animar aparici贸n
    animateHighlightAppearance(highlight, true)
    
    return highlight
end

-- Funci贸n para remover highlight con animaci贸n
local function removeHighlight()
    if currentHighlight then
        animateHighlightAppearance(currentHighlight, false)
        task.delay(0.6, function()
            if currentHighlight then
                currentHighlight:Destroy()
                currentHighlight = nil
            end
        end)
    end
end

-- Funci贸n para detectar objeto bajo el cursor/toque
local function detectObjectAtPosition(screenPosition)
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local unitRay = camera:ViewportPointToRay(screenPosition.X, screenPosition.Y, 0)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterList = {player.Character}
    
    if screenGui then
        table.insert(filterList, screenGui)
    end
    
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.IgnoreWater = true
    
    local rayResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * MAX_DETECTION_DISTANCE, raycastParams)
    
    if rayResult and rayResult.Instance then
        local hitPart = rayResult.Instance
        
        if hitPart:IsA("BasePart") then
            if not hitPart.Anchored then
                return hitPart
            end
            
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model and model ~= player.Character then
                if model.PrimaryPart and not model.PrimaryPart.Anchored then
                    return model.PrimaryPart
                end
                
                for _, descendant in pairs(model:GetDescendants()) do
                    if descendant:IsA("BasePart") and not descendant.Anchored then
                        return descendant
                    end
                end
            end
        end
    end
    
    return nil
end

-- Variables para AlignPosition y AlignOrientation
local alignPosition = nil
local alignOrientation = nil
local attachment0 = nil
local attachment1 = nil

-- Funci贸n para soltar objeto
local function releaseObject()
    if updateFriend then
        updateFriend:Disconnect()
        updateFriend = nil
    end
    
    if alignPosition then
        alignPosition:Destroy()
        alignPosition = nil
    end
    
    if alignOrientation then
        alignOrientation:Destroy()
        alignOrientation = nil
    end
    
    if attachment0 then
        attachment0:Destroy()
        attachment0 = nil
    end
    
    if attachment1 then
        attachment1:Destroy()
        attachment1 = nil
    end
    
    if bodyPosition then
        bodyPosition:Destroy()
        bodyPosition = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- Restaurar colisiones originales
    if currentObject then
        for part, originalState in pairs(savedCollisionStates) do
            if part and part.Parent then
                part.CanCollide = originalState
            end
        end
        savedCollisionStates = {}
        currentObject = nil
    end
    
    removeHighlight()
    isHoldingObject = false
end

-- Funci贸n para agarrar objeto
local function grabObject(object)
    if not object or isHoldingObject then return end
    
    local head = getCharacterHead()
    if not head then return end
    
    currentObject = object
    isHoldingObject = true
    
    -- Guardar y desactivar colisi贸n del objeto principal
    savedCollisionStates[object] = object.CanCollide
    object.CanCollide = false
    
    -- Guardar y desactivar colisi贸n de todas las partes conectadas si es un modelo
    local model = object:FindFirstAncestorOfClass("Model")
    if model then
        for _, part in pairs(model:GetDescendants()) do
            if part:IsA("BasePart") and part ~= object then
                savedCollisionStates[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end
    
    createHighlight(object)
    
    -- Crear Attachment en la cabeza
    attachment0 = Instance.new("Attachment")
    attachment0.Name = "GripAttachment0"
    attachment0.Position = GRIP_OFFSET
    attachment0.Parent = head
    
    -- Crear Attachment en el objeto
    attachment1 = Instance.new("Attachment")
    attachment1.Name = "GripAttachment1"
    attachment1.Parent = object
    
    -- Crear AlignPosition para posici贸n perfecta
    alignPosition = Instance.new("AlignPosition")
    alignPosition.Attachment0 = attachment1
    alignPosition.Attachment1 = attachment0
    alignPosition.MaxForce = 9e9
    alignPosition.MaxVelocity = math.huge
    alignPosition.Responsiveness = 200
    alignPosition.ApplyAtCenterOfMass = true
    alignPosition.RigidityEnabled = true
    alignPosition.Parent = object
    
    -- Crear AlignOrientation para orientaci贸n perfecta
    alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Attachment0 = attachment1
    alignOrientation.Attachment1 = attachment0
    alignOrientation.MaxTorque = 9e9
    alignOrientation.MaxAngularVelocity = math.huge
    alignOrientation.Responsiveness = 200
    alignOrientation.RigidityEnabled = true
    alignOrientation.Parent = object
    
    -- Monitoreo para verificar integridad
    updateFriend = RunService.Heartbeat:Connect(function()
        if not currentObject or not currentObject.Parent then
            releaseObject()
            return
        end
        
        local currentHead = getCharacterHead()
        if not currentHead then
            releaseObject()
            return
        end
        
        -- Verificar que los constraints existen
        if not alignPosition or not alignPosition.Parent or not alignOrientation or not alignOrientation.Parent then
            releaseObject()
            return
        end
    end)
end

-- Manejador de input t谩ctil/click
local function handleInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if not gripModeActive or isHoldingObject then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        
        if gui.MainButton then
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = gui.MainButton.AbsolutePosition
            local buttonSize = gui.MainButton.AbsoluteSize
            
            if mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
               mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y then
                return
            end
        end
        
        local inputPosition = input.Position
        local detectedObject = detectObjectAtPosition(inputPosition)
        
        if detectedObject then
            grabObject(detectedObject)
        end
    end
end

-- Toggle del modo Grip
function toggleGripMode()
    if isHoldingObject then
        releaseObject()
    end
    
    gripModeActive = not gripModeActive
    animateButton(gripModeActive)
end

-- Eventos de input
UserInputService.InputBegan:Connect(handleInputBegan)

-- Limpiar y recrear al cambiar de personaje
player.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    
    -- Soltar objeto si est谩 sosteniendo uno
    if isHoldingObject then
        releaseObject()
    end
    
    -- Recrear UI manteniendo el estado
    createUI()
    
    -- Recargar script externo para persistencia
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty1.lua"))()
    end)
end)

-- Inicializar UI
createUI()

print("鉁� Sistema de Grip Permanente cargado correctamente")
print("鉁� Script externo cargado y persistente")
print("馃摫 Compatible con R6/R15 y PC/Mobile")
print("鈾撅笍 Funciona despu茅s de respawn/muerte")

-- God Mode Ultra: Sistema Completo de Protección y Eliminación
-- Colocar en: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Configuración del Sistema
local CONFIG = {
	ENABLED = false,
	PROTECTION_RADIUS = 85,
	INNER_RADIUS = 15,
	BARRIER_SCAN_RADIUS = 200,
	HEALTH_AMOUNT = math.huge,
	SCAN_INVISIBLE_PARTS = true,
	ELIMINATE_BARRIERS = true,
	NPC_IMMUNITY = true
}

-- Variables del Sistema
local connections = {}
local modifiedParts = {}
local eliminatedParts = {}
local npcProtections = {}
local eliminationLoop = nil
local currentCharacter = nil
local gui = {}

-- Sistema de Eliminación de Barreras Invisibles y Rojas
local function eliminateInvisibleBarriers(position)
	if not CONFIG.ELIMINATE_BARRIERS then return end
	
	local barrierParts = workspace:GetPartBoundsInRadius(position, CONFIG.BARRIER_SCAN_RADIUS)
	
	for _, part in ipairs(barrierParts) do
		if part:IsA("BasePart") and part.Parent ~= currentCharacter then
			local isInvisibleBarrier = part.Transparency >= 0.95
			local hasBarrierName = part.Name:lower():match("barrier") or 
			                       part.Name:lower():match("wall") or 
			                       part.Name:lower():match("kill") or
			                       part.Name:lower():match("border") or 
			                       part.Name:lower():match("limit")
			
			local isRedBarrier = false
			if part.Color then
				local r, g, b = part.Color.R, part.Color.G, part.Color.B
				isRedBarrier = (r > 0.8 and g < 0.3 and b < 0.3) and (part.Transparency == 0 or isInvisibleBarrier)
			end
			
			local isBarrier = isInvisibleBarrier or hasBarrierName or isRedBarrier
			
			if isBarrier and not eliminatedParts[part] then
				pcall(function()
					if not modifiedParts[part] then
						modifiedParts[part] = {
							CanTouch = part.CanTouch,
							CanCollide = part.CanCollide,
							Transparency = part.Transparency
						}
					end
					part.CanTouch = false
					part.CanCollide = false
					eliminatedParts[part] = true
				end)
			end
		end
	end
end

-- Sistema de Inmunidad contra NPCs
local function applyNPCImmunity(character)
	if not CONFIG.NPC_IMMUNITY then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("Humanoid") then
			local isNPC = not Players:GetPlayerFromCharacter(obj)
			
			if isNPC then
				pcall(function()
					for _, npcPart in pairs(obj:GetDescendants()) do
						if npcPart:IsA("BasePart") then
							if not npcProtections[npcPart] then
								local noCollision = Instance.new("NoCollisionConstraint")
								noCollision.Part0 = rootPart
								noCollision.Part1 = npcPart
								noCollision.Parent = character
								npcProtections[npcPart] = noCollision
							end
							
							npcPart.CanTouch = false
						end
					end
					
					local npcHumanoid = obj:FindFirstChild("Humanoid")
					if npcHumanoid then
						for _, connection in pairs(getconnections(npcHumanoid.Touched)) do
							if not connection.Disabled then
								connection:Disable()
							end
						end
					end
				end)
			end
		end
	end
end

-- Sistema de Eliminación Continua Principal
local function startContinuousElimination(character)
	if eliminationLoop then
		task.cancel(eliminationLoop)
	end
	
	eliminationLoop = task.spawn(function()
		while CONFIG.ENABLED and character and character.Parent do
			pcall(function()
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if not rootPart then return end
				
				local position = rootPart.Position
				
				-- Eliminación ultra agresiva en radio interno
				local innerParts = workspace:GetPartBoundsInRadius(position, CONFIG.INNER_RADIUS)
				for _, part in ipairs(innerParts) do
					if part:IsA("BasePart") and part ~= rootPart and part.Parent ~= character then
						pcall(function()
							if not modifiedParts[part] then
								modifiedParts[part] = {CanTouch = part.CanTouch, CanCollide = part.CanCollide}
							end
							part.CanTouch = false
							
							if CONFIG.SCAN_INVISIBLE_PARTS and part.Transparency >= 0.8 then
								part.CanCollide = false
							end
						end)
					end
				end
				
				-- Protección en radio externo
				local outerParts = workspace:GetPartBoundsInRadius(position, CONFIG.PROTECTION_RADIUS)
				for _, part in ipairs(outerParts) do
					if part:IsA("BasePart") and part ~= rootPart and part.Parent ~= character then
						pcall(function()
							if not modifiedParts[part] then
								modifiedParts[part] = {CanTouch = part.CanTouch}
							end
							part.CanTouch = false
						end)
					end
				end
			end)
			
			task.wait()
		end
	end)
end

-- CREACIÓN DEL GUI ESTILO PET SIMULATOR X
local function createUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GodModeUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = player:WaitForChild("PlayerGui")
	
	-- Botón principal estilo Pet Simulator X
	local MainButton = Instance.new("TextButton")
	MainButton.Name = "MainButton"
	MainButton.Size = UDim2.new(0, 180, 0, 70)
	MainButton.Position = UDim2.new(0.5, -90, 0, 20) -- Centrado arriba
	MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45) -- Gris oscuro por defecto
	MainButton.BackgroundTransparency = 0.3
	MainButton.BorderSizePixel = 0
	MainButton.Text = ""
	MainButton.AutoButtonColor = false
	MainButton.Active = true
	MainButton.Draggable = true
	MainButton.Parent = ScreenGui
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 16)
	ButtonCorner.Parent = MainButton
	
	-- Contorno animado (gradiente rotatorio)
	local AnimatedStroke = Instance.new("UIStroke")
	AnimatedStroke.Name = "AnimatedStroke"
	AnimatedStroke.Color = Color3.fromRGB(100, 100, 120)
	AnimatedStroke.Thickness = 3
	AnimatedStroke.Transparency = 0.3
	AnimatedStroke.Parent = MainButton
	
	local StrokeGradient = Instance.new("UIGradient")
	StrokeGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
	}
	StrokeGradient.Rotation = 0
	StrokeGradient.Parent = AnimatedStroke
	
	-- Animación continua del contorno
	task.spawn(function()
		while MainButton and MainButton.Parent do
			local rotateTween = TweenService:Create(StrokeGradient,
				TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
				{Rotation = 360}
			)
			rotateTween:Play()
			task.wait(100)
		end
	end)
	
	-- Gradiente de fondo
	local BackgroundGradient = Instance.new("UIGradient")
	BackgroundGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
	}
	BackgroundGradient.Rotation = 90
	BackgroundGradient.Parent = MainButton
	
	-- Efecto de brillo interno
	local InnerGlow = Instance.new("Frame")
	InnerGlow.Name = "InnerGlow"
	InnerGlow.Size = UDim2.new(1, -8, 1, -8)
	InnerGlow.Position = UDim2.new(0, 4, 0, 4)
	InnerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InnerGlow.BackgroundTransparency = 0.95
	InnerGlow.BorderSizePixel = 0
	InnerGlow.Parent = MainButton
	
	local InnerGlowCorner = Instance.new("UICorner")
	InnerGlowCorner.CornerRadius = UDim.new(0, 13)
	InnerGlowCorner.Parent = InnerGlow
	
	-- Icono/Emoji
	local IconLabel = Instance.new("TextLabel")
	IconLabel.Name = "IconLabel"
	IconLabel.Size = UDim2.new(0, 35, 0, 35)
	IconLabel.Position = UDim2.new(0, 12, 0.5, -17)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text = "💪"
	IconLabel.Font = Enum.Font.GothamBold
	IconLabel.TextSize = 28
	IconLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
	IconLabel.Parent = MainButton
	
	-- Texto principal
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "TextLabel"
	TextLabel.Size = UDim2.new(1, -55, 0, 25)
	TextLabel.Position = UDim2.new(0, 50, 0, 12)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "GOD MODE"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 16
	TextLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = MainButton
	
	-- Estado
	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Name = "StatusLabel"
	StatusLabel.Size = UDim2.new(1, -55, 0, 18)
	StatusLabel.Position = UDim2.new(0, 50, 0, 38)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = "Desactivado"
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.TextSize = 12
	StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
	StatusLabel.Parent = MainButton
	
	-- Efecto de partículas/brillo cuando está activo
	local ParticleContainer = Instance.new("Frame")
	ParticleContainer.Name = "ParticleContainer"
	ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
	ParticleContainer.BackgroundTransparency = 1
	ParticleContainer.ClipsDescendants = true
	ParticleContainer.Parent = MainButton
	
	local ParticleCorner = Instance.new("UICorner")
	ParticleCorner.CornerRadius = UDim.new(0, 16)
	ParticleCorner.Parent = ParticleContainer
	
	return {
		ScreenGui = ScreenGui,
		MainButton = MainButton,
		StatusLabel = StatusLabel,
		IconLabel = IconLabel,
		TextLabel = TextLabel,
		AnimatedStroke = AnimatedStroke,
		StrokeGradient = StrokeGradient,
		BackgroundGradient = BackgroundGradient,
		InnerGlow = InnerGlow,
		ParticleContainer = ParticleContainer
	}
end

-- Función para crear efecto de onda al activar/desactivar
local function createRippleEffect(isOn)
	if not gui.ParticleContainer then return end
	
	local ripple = Instance.new("Frame")
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BackgroundColor3 = isOn and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(150, 150, 160)
	ripple.BackgroundTransparency = 0.5
	ripple.BorderSizePixel = 0
	ripple.ZIndex = 5
	ripple.Parent = gui.ParticleContainer
	
	local rippleCorner = Instance.new("UICorner")
	rippleCorner.CornerRadius = UDim.new(1, 0)
	rippleCorner.Parent = ripple
	
	local expandTween = TweenService:Create(ripple, 
		TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(1.5, 0, 1.5, 0),
			BackgroundTransparency = 1
		}
	)
	
	expandTween:Play()
	expandTween.Completed:Connect(function()
		ripple:Destroy()
	end)
end

-- Función para crear partículas flotantes
local function createFloatingParticles(isOn)
	if not isOn or not gui.ParticleContainer then return end
	
	for i = 1, 6 do
		task.delay(i * 0.08, function()
			if not gui.ParticleContainer then return end
			
			local particle = Instance.new("Frame")
			particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
			particle.Position = UDim2.new(math.random(0, 100) / 100, 0, 1, 0)
			particle.BackgroundColor3 = Color3.fromRGB(100, 220, 120)
			particle.BackgroundTransparency = 0.3
			particle.BorderSizePixel = 0
			particle.ZIndex = 4
			particle.Parent = gui.ParticleContainer
			
			local particleCorner = Instance.new("UICorner")
			particleCorner.CornerRadius = UDim.new(1, 0)
			particleCorner.Parent = particle
			
			local floatTween = TweenService:Create(particle,
				TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{
					Position = UDim2.new(particle.Position.X.Scale, 0, -0.2, 0),
					BackgroundTransparency = 1
				}
			)
			
			floatTween:Play()
			floatTween.Completed:Connect(function()
				particle:Destroy()
			end)
		end)
	end
end

-- Función para pulsar el icono
local function pulseIcon(isOn)
	if not gui.IconLabel then return end
	
	local pulseTween = TweenService:Create(gui.IconLabel,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{TextSize = isOn and 32 or 28}
	)
	
	pulseTween:Play()
	pulseTween.Completed:Connect(function()
		local returnTween = TweenService:Create(gui.IconLabel,
			TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
			{TextSize = 28}
		)
		returnTween:Play()
	end)
end

-- Función para animar el brillo interno
local function animateInnerGlow(isOn)
	if not gui.InnerGlow then return end
	
	local glowTween = TweenService:Create(gui.InnerGlow,
		TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = isOn and 0.85 or 0.95}
	)
	glowTween:Play()
end

-- Animación del botón mejorada con efectos visuales
local function animateButton(isOn)
	if not gui.MainButton then return end
	
	local targetColor = isOn and Color3.fromRGB(100, 220, 120) or Color3.fromRGB(40, 40, 45) -- Verde claro cuando está ON
	local targetStrokeColor = isOn and Color3.fromRGB(120, 240, 140) or Color3.fromRGB(100, 100, 120)
	local targetText = isOn and "Activado" or "Desactivado"
	
	-- Efecto de rebote suave al cambiar de estado
	local bounceTween = TweenService:Create(gui.MainButton,
		TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 185, 0, 73)}
	)
	bounceTween:Play()
	
	bounceTween.Completed:Connect(function()
		local returnTween = TweenService:Create(gui.MainButton,
			TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 180, 0, 70)}
		)
		returnTween:Play()
	end)
	
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	-- Animar el fondo del botón
	local buttonTween = TweenService:Create(gui.MainButton, tweenInfo, {
		BackgroundColor3 = targetColor
	})
	
	-- Animar el contorno con efecto más pronunciado
	local strokeTween = TweenService:Create(gui.AnimatedStroke, tweenInfo, {
		Color = targetStrokeColor,
		Transparency = isOn and 0.05 or 0.3,
		Thickness = isOn and 4 or 3
	})
	
	-- Animar el gradiente del contorno
	if isOn then
		gui.StrokeGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 220, 120)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 255, 170)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 220, 120))
		}
	else
		gui.StrokeGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 180)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 100))
		}
	end
	
	-- Animar el gradiente del fondo
	local gradientTween = TweenService:Create(gui.BackgroundGradient, tweenInfo, {
		Rotation = isOn and 45 or 90
	})
	
	-- Ejecutar las animaciones principales
	buttonTween:Play()
	strokeTween:Play()
	gradientTween:Play()
	
	-- Efectos visuales adicionales
	createRippleEffect(isOn)
	pulseIcon(isOn)
	animateInnerGlow(isOn)
	createFloatingParticles(isOn)
	
	-- Animar el texto del estado con fade
	gui.StatusLabel.TextTransparency = 1
	gui.StatusLabel.Text = targetText
	
	local textFadeTween = TweenService:Create(gui.StatusLabel,
		TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			TextTransparency = 0,
			TextColor3 = isOn and Color3.fromRGB(150, 255, 170) or Color3.fromRGB(150, 150, 160)
		}
	)
	textFadeTween:Play()
end

-- Limpieza del Sistema
local function cleanup()
	if eliminationLoop then task.cancel(eliminationLoop) end
	for _, conn in pairs(connections) do
		if conn.Connected then conn:Disconnect() end
	end
	for _, constraint in pairs(npcProtections) do
		if constraint then constraint:Destroy() end
	end
	connections = {}
	npcProtections = {}
end

-- Restaurar Estado Original
local function restore()
	for part, state in pairs(modifiedParts) do
		if part and part.Parent then
			pcall(function()
				part.CanTouch = state.CanTouch
				if state.CanCollide then part.CanCollide = state.CanCollide end
			end)
		end
	end
	modifiedParts = {}
	eliminatedParts = {}
end

-- Protección del Personaje
local function protectCharacter(character)
	if not character or not CONFIG.ENABLED then return end
	
	currentCharacter = character
	local humanoid = character:WaitForChild("Humanoid", 10)
	local rootPart = character:WaitForChild("HumanoidRootPart", 10)
	
	if not humanoid or not rootPart then return end
	
	humanoid.MaxHealth = CONFIG.HEALTH_AMOUNT
	humanoid.Health = CONFIG.HEALTH_AMOUNT
	
	table.insert(connections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if CONFIG.ENABLED and humanoid.Health < CONFIG.HEALTH_AMOUNT then
			humanoid.Health = CONFIG.HEALTH_AMOUNT
		end
	end))
	
	table.insert(connections, humanoid.Died:Connect(function()
		if CONFIG.ENABLED then
			task.wait()
			humanoid.Health = CONFIG.HEALTH_AMOUNT
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end))
	
	table.insert(connections, RunService.Heartbeat:Connect(function()
		if CONFIG.ENABLED and humanoid and humanoid.Parent then
			if humanoid.Health ~= CONFIG.HEALTH_AMOUNT then
				humanoid.Health = CONFIG.HEALTH_AMOUNT
			end
			if humanoid:GetState() == Enum.HumanoidStateType.Dead then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end))
	
	startContinuousElimination(character)
	
	task.spawn(function()
		task.wait(0.5)
		if CONFIG.ENABLED then
			eliminateInvisibleBarriers(rootPart.Position)
			applyNPCImmunity(character)
		end
	end)
	
	table.insert(connections, workspace.DescendantAdded:Connect(function(desc)
		if CONFIG.ENABLED and desc:IsA("Model") and desc:FindFirstChild("Humanoid") then
			task.wait(0.5)
			applyNPCImmunity(character)
		end
	end))
	
	print("[God Mode] Sistema activado: Radio " .. CONFIG.PROTECTION_RADIUS .. " studs")
end

-- Activar Sistema
local function enable()
	CONFIG.ENABLED = true
	cleanup()
	if player.Character then protectCharacter(player.Character) end
	print("[God Mode] ACTIVADO - Inmunidad total contra NPCs y barreras")
end

-- Desactivar Sistema
local function disable()
	CONFIG.ENABLED = false
	cleanup()
	restore()
	if currentCharacter then
		local hum = currentCharacter:FindFirstChild("Humanoid")
		if hum then hum.MaxHealth = 100 hum.Health = 100 end
	end
	print("[God Mode] DESACTIVADO")
end

-- Inicialización
gui = createUI()

gui.MainButton.MouseButton1Click:Connect(function()
	if CONFIG.ENABLED then
		disable()
		animateButton(false)
	else
		enable()
		animateButton(true)
	end
end)

gui.MainButton.MouseEnter:Connect(function()
	TweenService:Create(gui.MainButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 185, 0, 72)}):Play()
	TweenService:Create(gui.AnimatedStroke, TweenInfo.new(0.2), {Thickness = 4}):Play()
end)

gui.MainButton.MouseLeave:Connect(function()
	TweenService:Create(gui.MainButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 180, 0, 70)}):Play()
	TweenService:Create(gui.AnimatedStroke, TweenInfo.new(0.2), {Thickness = 3}):Play()
end)

player.CharacterAdded:Connect(function(char)
	currentCharacter = char
	if CONFIG.ENABLED then
		task.wait(0.1)
		cleanup()
		protectCharacter(char)
	end
end)

print("=== GOD MODE ULTRA CARGADO ===")
print("✓ Eliminación de barreras invisibles")
print("✓ Inmunidad total contra NPCs")
print("✓ Radio protección: 85 studs")
print("✓ Radio barreras: 200 studs")
print("===============================")

-- Script Universal para R6 y R15
-- Coloca este script en StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Esperar a que el personaje est茅 listo
local character = player.Character or player.CharacterAdded:Wait()

-- Funci贸n para detectar el tipo de rig
local function detectRigType()
    -- Esperar a que el Humanoid est茅 disponible
    local humanoid = character:WaitForChild("Humanoid", 10)
    
    if not humanoid then
        warn("No se encontr贸 el Humanoid")
        return nil
    end
    
    -- Verificar el RigType
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        return "R6"
    elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
        return "R15"
    end
    
    return nil
end

-- Ejecutar el script correspondiente
local rigType = detectRigType()

if rigType == "R6" then
    -- Script para R6
    print("Detectado rig R6 - Ejecutando script...")
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/c4556d/FlyInvencibleR6Script/e5056f1402a67db54d1fd4313897b86e9180a152/InvencibleFly.lua")))()
    
elseif rigType == "R15" then
    -- Script para R15 (con detecci贸n de m贸vil)
    print("Detectado rig R15 - Ejecutando script...")
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    if isMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua"))()
    end
else
    warn("No se pudo detectar el tipo de rig")
end

loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

-- https://scriptblox.com/script/Universal-Script-Nameless-admin-REWORKED-43502

--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
