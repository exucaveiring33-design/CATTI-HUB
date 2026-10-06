
print([[ 
 __   _____  ___     ___ ____    ____             _    
 \ \ / / __||_ _|   |_ _/ ___|  | __ )  __ _  ___| | __
  \ V / |    | |     | |\___ \  |  _ \ / _` |/ __| |/ /
   | || |___ | |     | | ___) | | |_) | (_| | (__|   < 
   |_| \____|___|   |___|____/  |____/ \__,_|\___|_|\_\
                   Cat Hub v1.0
]])
--[[ Cat Hub ]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LoadingConfig = {
    Duration = 8,
    FadeOutTime = 1.5,
    BarColor = Color3.fromRGB(255, 255, 255),
    BarGlow = Color3.fromRGB(200, 200, 200),
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    ParticleCount = 150,
    ParticleSpeed = 2,
    ParticleSize = 3,
    
    -- CONFIGURAÇÃO DE MÚSICA
    MusicID = 79120642849019,
    MusicVolume = 0.5,
    PlayMusic = true
}

local LoadingElements = {
    "Carregando o Cat Hub...",
    "Carregando interface...",
    "Por favor, aguarde...",
    "Inicializando o Cat Hub...",
    "Carregando módulos...",
    "Otimizando desempenho...",
    "Cat Hub carregado!",
    "Finalizando carregamento...",
    "Pronto!"
}

local Particles = {}
local AnimationConnections = {}
local LoadingMusic = nil

-- Função para criar e tocar a música
local function CreateLoadingMusic()
    if not LoadingConfig.PlayMusic then
        return nil
    end
    
    local sound = Instance.new("Sound")
    sound.Name = "LoadingMusic"
    sound.SoundId = "rbxassetid://" .. LoadingConfig.MusicID
    sound.Volume = LoadingConfig.MusicVolume
    sound.Looped = true
    sound.Parent = game:GetService("SoundService")
    
    sound:Play()
    LoadingMusic = sound
    
    return sound
end

-- Função para fazer fade out da música
local function FadeOutMusic(duration)
    if LoadingMusic then
        local fadeInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = TweenService:Create(LoadingMusic, fadeInfo, {Volume = 0})
        
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            if LoadingMusic then
                LoadingMusic:Stop()
                LoadingMusic:Destroy()
                LoadingMusic = nil
            end
        end)
    end
end

local function CreateStarParticle(parent, x, y)
    local star = Instance.new("Frame")
    star.Name = "StarParticle"
    star.Parent = parent
    star.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    star.BorderSizePixel = 0
    star.Size = UDim2.new(0, math.random(2, LoadingConfig.ParticleSize), 0, math.random(2, LoadingConfig.ParticleSize))
    star.Position = UDim2.new(0, x, 0, y)
    star.ZIndex = 8
    star.BackgroundTransparency = math.random(0, 50) / 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = star
    
    local gradient = Instance.new("UIGradient")
    gradient.Parent = star
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    
    local particle = {
        frame = star,
        speedX = (math.random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        speedY = (math.random(-100, 100) / 100) * LoadingConfig.ParticleSpeed,
        rotationSpeed = math.random(-5, 5),
        pulseSpeed = math.random(1, 3),
        opacity = math.random(30, 100) / 100
    }
    
    return particle
end

local function CreateParticleSystem(parent)
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    for i = 1, LoadingConfig.ParticleCount do
        local x = math.random(0, screenSize.X)
        local y = math.random(0, screenSize.Y)
        local particle = CreateStarParticle(parent, x, y)
        table.insert(Particles, particle)
    end
end

local function UpdateParticles(parentFrame)
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    for _, particle in pairs(Particles) do
        if particle.frame and particle.frame.Parent then
            local currentPos = particle.frame.Position
            local newX = currentPos.X.Offset + particle.speedX
            local newY = currentPos.Y.Offset + particle.speedY
            
            if newX < -10 then
                newX = screenSize.X + 10
            elseif newX > screenSize.X + 10 then
                newX = -10
            end
            
            if newY < -10 then
                newY = screenSize.Y + 10
            elseif newY > screenSize.Y + 10 then
                newY = -10
            end
            
            particle.frame.Position = UDim2.new(0, newX, 0, newY)
            particle.frame.Rotation = particle.frame.Rotation + particle.rotationSpeed
            
            local pulseValue = math.sin(tick() * particle.pulseSpeed) * 0.3 + 0.7
            particle.frame.BackgroundTransparency = 1 - (particle.opacity * pulseValue)
            
            local sizeMultiplier = 1 + (math.sin(tick() * particle.pulseSpeed * 0.5) * 0.2)
            particle.frame.Size = UDim2.new(0, LoadingConfig.ParticleSize * sizeMultiplier, 0, LoadingConfig.ParticleSize * sizeMultiplier)
        end
    end
end

local function CreateAdvancedBackground(parent)
    local bgFrame = Instance.new("Frame")
    bgFrame.Name = "AdvancedBackground"
    bgFrame.Parent = parent
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BorderSizePixel = 0
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.Position = UDim2.new(0, 0, 0, 0)
    bgFrame.ZIndex = 1
    
    local gradient1 = Instance.new("UIGradient")
    gradient1.Parent = bgFrame
    gradient1.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(15, 15, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    gradient1.Rotation = 45
    
    local animateGradient = TweenService:Create(
        gradient1,
        TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 225}
    )
    animateGradient:Play()
    table.insert(AnimationConnections, animateGradient)
    
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Parent = bgFrame
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.ZIndex = 2
    overlay.BackgroundTransparency = 0.3
    
    local overlayGradient = Instance.new("UIGradient")
    overlayGradient.Parent = overlay
    overlayGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    })
    overlayGradient.Rotation = -45
    
    local animateOverlay = TweenService:Create(
        overlayGradient,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 315}
    )
    animateOverlay:Play()
    table.insert(AnimationConnections, animateOverlay)
    
    return bgFrame
end

local function CreatePulsingCircles(parent)
    for i = 1, 5 do
        local circle = Instance.new("Frame")
        circle.Name = "PulsingCircle" .. i
        circle.Parent = parent
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        circle.Size = UDim2.new(0, 100 + (i * 50), 0, 100 + (i * 50))
        circle.Position = UDim2.new(0.5, -(50 + (i * 25)), 0.5, -(50 + (i * 25)))
        circle.ZIndex = 3
        circle.BackgroundTransparency = 0.9 + (i * 0.01)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = circle
        
        local pulseTween = TweenService:Create(
            circle,
            TweenInfo.new(2 + (i * 0.3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {
                Size = UDim2.new(0, 120 + (i * 60), 0, 120 + (i * 60)),
                Position = UDim2.new(0.5, -(60 + (i * 30)), 0.5, -(60 + (i * 30))),
                BackgroundTransparency = 0.97
            }
        )
        pulseTween:Play()
        table.insert(AnimationConnections, pulseTween)
    end
end

local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CatHubLoading"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.IgnoreGuiInset = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = LoadingConfig.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.Position = UDim2.new(0, 0, 0, 0)
    MainFrame.ZIndex = 10
    
    local advancedBg = CreateAdvancedBackground(MainFrame)
    CreatePulsingCircles(MainFrame)
    CreateParticleSystem(MainFrame)
    
    local CenterContainer = Instance.new("Frame")
    CenterContainer.Name = "CenterContainer"
    CenterContainer.Parent = MainFrame
    CenterContainer.BackgroundTransparency = 1
    CenterContainer.Size = UDim2.new(0, 600, 0, 400)
    CenterContainer.Position = UDim2.new(0.5, -300, 0.5, -200)
    CenterContainer.ZIndex = 11
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = CenterContainer
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 80)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.Text = "Cat Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.ZIndex = 12
    
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Parent = TitleLabel
    titleStroke.Color = Color3.fromRGB(200, 200, 200)
    titleStroke.Thickness = 2
    titleStroke.Transparency = 0.5
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Parent = TitleLabel
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    
    local titleAnimation = TweenService:Create(
        TitleGradient,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Offset = Vector2.new(2, 0)}
    )
    titleAnimation:Play()
    table.insert(AnimationConnections, titleAnimation)
    
    local glowTween = TweenService:Create(
        titleStroke,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    glowTween:Play()
    table.insert(AnimationConnections, glowTween)
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Parent = CenterContainer
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 40)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 90)
    SubtitleLabel.Text = "Cat Hub"
    SubtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubtitleLabel.TextScaled = true
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.ZIndex = 12
    
    local ProgressContainer = Instance.new("Frame")
    ProgressContainer.Name = "ProgressContainer"
    ProgressContainer.Parent = CenterContainer
    ProgressContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ProgressContainer.BorderSizePixel = 0
    ProgressContainer.Size = UDim2.new(1, 0, 0, 25)
    ProgressContainer.Position = UDim2.new(0, 0, 0, 160)
    ProgressContainer.ZIndex = 12
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 12)
    ProgressCorner.Parent = ProgressContainer
    
    local ProgressStroke = Instance.new("UIStroke")
    ProgressStroke.Parent = ProgressContainer
    ProgressStroke.Color = Color3.fromRGB(200, 200, 200)
    ProgressStroke.Thickness = 2
    ProgressStroke.Transparency = 0.3
    
    local strokePulse = TweenService:Create(
        ProgressStroke,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    strokePulse:Play()
    table.insert(AnimationConnections, strokePulse)
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = ProgressContainer
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    ProgressBar.ZIndex = 13
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 12)
    BarCorner.Parent = ProgressBar
    
    local BarGradient = Instance.new("UIGradient")
    BarGradient.Parent = ProgressBar
    BarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
    })
    
    local barGradientAnim = TweenService:Create(
        BarGradient,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Offset = Vector2.new(1, 0)}
    )
    barGradientAnim:Play()
    table.insert(AnimationConnections, barGradientAnim)
    
    local GlowEffect = Instance.new("Frame")
    GlowEffect.Name = "GlowEffect"
    GlowEffect.Parent = ProgressBar
    GlowEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlowEffect.BackgroundTransparency = 0.6
    GlowEffect.BorderSizePixel = 0
    GlowEffect.Size = UDim2.new(0, 60, 1, 0)
    GlowEffect.Position = UDim2.new(-0.2, 0, 0, 0)
    GlowEffect.ZIndex = 14
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 12)
    GlowCorner.Parent = GlowEffect
    
    local PercentageLabel = Instance.new("TextLabel")
    PercentageLabel.Name = "PercentageLabel"
    PercentageLabel.Parent = CenterContainer
    PercentageLabel.BackgroundTransparency = 1
    PercentageLabel.Size = UDim2.new(1, 0, 0, 40)
    PercentageLabel.Position = UDim2.new(0, 0, 0, 200)
    PercentageLabel.Text = "0%"
    PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PercentageLabel.TextScaled = true
    PercentageLabel.Font = Enum.Font.GothamBold
    PercentageLabel.ZIndex = 12
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = CenterContainer
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0, 250)
    StatusLabel.Text = "Carregando..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.ZIndex = 12
    
    local DotsLabel = Instance.new("TextLabel")
    DotsLabel.Name = "DotsLabel"
    DotsLabel.Parent = CenterContainer
    DotsLabel.BackgroundTransparency = 1
    DotsLabel.Size = UDim2.new(0, 60, 0, 30)
    DotsLabel.Position = UDim2.new(1, -60, 0, 250)
    DotsLabel.Text = ""
    DotsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DotsLabel.TextScaled = true
    DotsLabel.Font = Enum.Font.Gotham
    DotsLabel.ZIndex = 12
    
    return ScreenGui, ProgressBar, PercentageLabel, StatusLabel, DotsLabel, GlowEffect, MainFrame
end

local function AnimateDots(dotsLabel)
    local dots = ""
    local dotCount = 0
    
    spawn(function()
        while dotsLabel.Parent do
            dotCount = (dotCount + 1) % 4
            dots = string.rep(".", dotCount)
            dotsLabel.Text = dots
            wait(0.4)
        end
    end)
end

local function StartLoadingSequence()
    CreateLoadingMusic()
    
    local screenGui, progressBar, percentageLabel, statusLabel, dotsLabel, glowEffect, mainFrame = CreateLoadingScreen()
    
    AnimateDots(dotsLabel)
    
    local particleConnection = RunService.Heartbeat:Connect(function()
        UpdateParticles(mainFrame)
    end)
    table.insert(AnimationConnections, particleConnection)
    
    local glowTween = TweenService:Create(
        glowEffect,
        TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(1.3, 0, 0, 0)}
    )
    glowTween:Play()
    table.insert(AnimationConnections, glowTween)
    
    local startTime = tick()
    local currentElementIndex = 1
    local lastElementTime = startTime
    
    local function updateProgress()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / LoadingConfig.Duration, 1)
        local percentage = math.floor(progress * 100)
        
        local barTween = TweenService:Create(
            progressBar,
            TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(progress, 0, 1, 0)}
        )
        barTween:Play()
        
        local percentTween = TweenService:Create(
            percentageLabel,
            TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {TextColor3 = Color3.fromRGB(255, 255, 255)}
        )
        percentTween:Play()
        
        percentageLabel.Text = percentage .. "%"
        
        local elementTime = LoadingConfig.Duration / #LoadingElements
        if tick() - lastElementTime >= elementTime and currentElementIndex <= #LoadingElements then
            statusLabel.Text = LoadingElements[currentElementIndex]
            
            local statusTween = TweenService:Create(
                statusLabel,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {TextTransparency = 0}
            )
            statusTween:Play()
            
            currentElementIndex = currentElementIndex + 1
            lastElementTime = tick()
        end
        
        if progress >= 1 then
            wait(0.8)
            
            FadeOutMusic(LoadingConfig.FadeOutTime)
            
            for _, connection in pairs(AnimationConnections) do
                if typeof(connection) == "RBXScriptConnection" then
                    connection:Disconnect()
                elseif typeof(connection) == "Tween" then
                    connection:Cancel()
                end
            end
            
            for _, particle in pairs(Particles) do
                if particle.frame then
                    particle.frame:Destroy()
                end
            end
            
            local fadeOutTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(LoadingConfig.FadeOutTime, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1.5, 0, 1.5, 0),
                    Position = UDim2.new(-0.25, 0, -0.25, 0)
                }
            )
            
            local contentFadeTween = TweenService:Create(
                mainFrame.CenterContainer,
                TweenInfo.new(LoadingConfig.FadeOutTime * 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }
            )
            
            fadeOutTween:Play()
            contentFadeTween:Play()
            
            fadeOutTween.Completed:Connect(function()
                screenGui:Destroy()
            end)
            
            return
        end
        
        RunService.Heartbeat:Wait()
        updateProgress()
    end
    updateProgress()
end

StartLoadingSequence()

-- Cat Hub | Cat Hub
local redzlib = loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/F1lf0CdtoxElaSTp/raw"))()

workspace.FallenPartsDestroyHeight = -math.huge

local Window = redzlib:MakeWindow({
    Title = "Cat Hub | Brookhaven RP",
    SubTitle = "Cat Hub",
    SaveFolder = "CatHub"
  })

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://109154959629475", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

task.delay(1, function()
    Window:Dialog({
        Title = "Bem-vindo",
        Text = "Bem-vindo ao Cat Hub",
        Options = {
            {
                "Entrar",
                function()
                    redzlib:Notify({
                        Title = "Cat Hub",
                        Text = "Olá! Aproveite o script",
                        Duration = 5
                    })
                end
            }
        }
    })
end)

local Tab1 = Window:MakeTab({"Informações", "info"})
local Tab10 = Window:MakeTab({"Mapa Troll", "map"})
local Tab9 = Window:MakeTab({"Troll", "skull"})
local Tab4 = Window:MakeTab({"Casa", "Home"})
local Tab5 = Window:MakeTab({"Carro", "Car"})
local Tab3 = Window:MakeTab({"Personagem", "shirt"})
local Tab2 = Window:MakeTab({"Diversão", "fun"})
local Tab6 = Window:MakeTab({"RGB", "brush"})
local Tab7 = Window:MakeTab({"Música Global", "radio"})
local Tab8 = Window:MakeTab({"Música", "music"})
local Tab12 = Window:MakeTab({"Teleporte", "map-pin"})
local Tab13 = Window:MakeTab({"Proteção", "shield"})
local Tab11 = Window:MakeTab({"Scripts", "scroll"})





-- ===  1: Informações ===
Tab1:AddSection({ "Cat Hub" })
Tab1:AddParagraph({ "Nome do script", "Cat Hub" })
Tab1:AddParagraph({ "Criador", "Vinícius Gabriel" })
Tab1:AddParagraph({ "Tipo", "Cat Hub" })
Tab1:AddParagraph({ "Jogo", "Brookhaven RP" })

Tab1:AddSection({ "Informações" })
-- ============================
-- SCRIPT USAGE TIME (Cronômetro)
-- ============================

local tempoTrack = Tab1:AddParagraph({
    "Tempo de uso:",
    "00:00:00"
})

local tempoAtual = 0

task.spawn(function()
    while true do
        local horas = math.floor(tempoAtual / 3600)
        local minutos = math.floor((tempoAtual % 3600) / 60)
        local segundos = tempoAtual % 60

        local formatado = string.format("%02d:%02d:%02d", horas, minutos, segundos)
        tempoTrack:Set(formatado)

        tempoAtual += 1
        task.wait(1)
    end
end)

Tab1:AddParagraph({ "Idioma:", "Português" })

Tab1:AddParagraph({ "Jogo:", "Brookhaven RP" })

Tab1:AddParagraph({ "Script:", "Cat Hub" })

Tab1:AddParagraph({ "Versão:", "1.0" })

Tab1:AddSection({ "Outros" })

Tab1:AddButton({

    Name = "Reentrar",

    Callback = function()

        local TeleportService = game:GetService("TeleportService")

        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)

    end

})

 ---------------------------------------------------------------------------------------------------------------------------------
                                                   -- ===  2: Diversão === --
-----------------------------------------------------------------------------------------------------------------------------------



Tab2:AddSection({"Personagem"})


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local selectedPlayerName = nil
local headsitActive = false

local function headsitOnPlayer(targetPlayer)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        warn("Não     .")
        return false
    end
    local targetHead = targetPlayer.Character.Head
    local localRoot = character:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        warn(" Não  HumanoidRootPart.")
        return false
    end

    localRoot.CFrame = targetHead.CFrame * CFrame.new(0, 2.2, 0)

    for _, v in pairs(localRoot:GetChildren()) do
        if v:IsA("WeldConstraint") then
            v:Destroy()
        end
    end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = localRoot
    weld.Part1 = targetHead
    weld.Parent = localRoot

    if humanoid then
        humanoid.Sit = true
    end

    print(" Ativar HeadSit  " .. targetPlayer.Name)
    return true
end

local function removeHeadsit()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local localRoot = character:FindFirstChild("HumanoidRootPart")
    if localRoot then
        for _, v in pairs(localRoot:GetChildren()) do
            if v:IsA("WeldConstraint") then
                v:Destroy()
            end
        end
    end
    if humanoid then
        humanoid.Sit = false
    end

    print("  HeadSit.")
end

-- Função para encontrar jogador por nome parcial
local function findPlayerByPartialName(partial)
    partial = partial:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Name:lower():sub(1, #partial) == partial then
            return player
        end
    end
    return nil
end

-- Notificação com imagem do jogador
local function notifyPlayerSelected(player)
    local StarterGui = game:GetService("StarterGui")
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size100x100
    local content, _ = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)

    StarterGui:SetCore("SendNotification", {
        Title = "Jogador selecionado",
        Text = player.Name .. " selecionado!",
        Icon = content,
        Duration = 5
    })
end

-- TextBox para digitar nome do player
Tab2:AddTextBox({
    Name = "Nome do jogador",
    Description = "Digite parte do nome",
    PlaceholderText = ": Nome do jogador",
    Callback = function(Value)
        local foundPlayer = findPlayerByPartialName(Value)
        if foundPlayer then
            selectedPlayerName = foundPlayer.Name
            notifyPlayerSelected(foundPlayer)
        else
            warn("    Não  Não.")
        end
    end
})

-- Botão para ativar/desativar headsit
-- Botão para ativar/desativar headsit (versão simplificada)
Tab2:AddButton({"Ativar HeadSit", function()
    if not selectedPlayerName then
    
        return
    end

    if not headsitActive then
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and headsitOnPlayer(target) then
            headsitActive = true
        end
    else
        removeHeadsit()
        headsitActive = false
    end
end})




Tab2:AddSlider({
    Name = "Velocidade do personagem",
    Increase = 1,
    MinValue = 16,
    MaxValue = 888,
    Default = 16,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
 })
 
 Tab2:AddSlider({
    Name = "Força do pulo",
    Increase = 1,
    MinValue = 50,
    MaxValue = 500,
    Default = 50,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            humanoid.JumpPower = Value
        end
    end
 })
 
 Tab2:AddSlider({
    Name = "Gravidade",
    Increase = 1,
    MinValue = 0,
    MaxValue = 10000,
    Default = 196.2,
    Callback = function(Value)
        game.Workspace.Gravity = Value
    end
 })
 
 local InfiniteJumpAtivado = false
 
 game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpAtivado then
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
          character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
       end
    end
 end)

 Tab2:AddButton({
    Name = "Resetar velocidade/gravity/pulo ✅",
    Callback = function()
        -- Resetar Speed
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 --  Não
            humanoid.JumpPower = 50 --  Não
        end
        
        -- Resetar Gravity
        game.Workspace.Gravity = 196.2 --  Não
        
        -- Desativar Infinite Jump
        InfiniteJumpAtivado = false
    end
})
 
 Tab2:AddToggle({
    Name = "Pulo infinito",
    Default = false,
    Callback = function(Value)
       InfiniteJumpAtivado = Value
    end
 })

 local UltimateNoclip = {
    Ativado = false,
    Connections = {},
    SoccerBalls = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Função para controle de colisões do jogador
local function managePlayerCollisions(character)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not UltimateNoclip.Ativado
            part.Anchored = false
        end
    end
end

-- Sistema anti-void melhorado
local function voidProtection(rootPart)
    if rootPart.Position.Y < -500 then
        local safeCFrame = CFrame.new(0, 100, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        
        local result = Workspace:Raycast(rootPart.Position, Vector3.new(0, 500, 0), rayParams)
        rootPart.CFrame = result and CFrame.new(result.Position + Vector3.new(0, 5, 0)) or safeCFrame
    end
end

-- Controle das bolas de futebol
local function manageSoccerBalls()
    local soccerFolder = Workspace:FindFirstChild("Com", true)
                      and Workspace.Com:FindFirstChild("001_SoccerBalls")
    
    if soccerFolder then
        -- Atualiza bolas existentes
        for _, ball in ipairs(soccerFolder:GetChildren()) do
            if ball.Name:match("^Soccer") then
                pcall(function()
                    ball.CanCollide = not UltimateNoclip.Ativado
                    ball.Anchored = UltimateNoclip.Ativado
                end)
                UltimateNoclip.SoccerBalls[ball] = true
            end
        end
        
        -- Monitora novas bolas
        if not UltimateNoclip.Connections.BallAdded then
            UltimateNoclip.Connections.BallAdded = soccerFolder.ChildAdded:Connect(function(ball)
                if ball.Name:match("^Soccer") then
                    task.wait(0.3)
                    pcall(function()
                        ball.CanCollide = not UltimateNoclip.Ativado
                        ball.Anchored = UltimateNoclip.Ativado
                    end)
                end
            end)
        end
    end
end

-- Loop principal do sistema
local function mainLoop()
    UltimateNoclip.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        
        -- Controle do jogador
        if character then
            managePlayerCollisions(character)
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                voidProtection(rootPart)
            end
        end
        
        -- Atualiza bolas a cada 2 segundos
        if tick() % 2 < 0.1 then
            manageSoccerBalls()
        end
    end)
end

-- Configuração do toggle
local NoclipToggle = Tab2:AddToggle({
    Name = "Noclip",
    Description = "Ativar ou desativar o noclip",
    Default = false
})

NoclipToggle:Callback(function(state)
    UltimateNoclip.Ativado = state
    
    if state then
        -- Inicia sistemas
        mainLoop()
        manageSoccerBalls()
        
        -- Configura respawn
        UltimateNoclip.Connections.CharAdded = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            managePlayerCollisions(LocalPlayer.Character)
        end)
    else
        -- Desativa tudo
        for _, conn in pairs(UltimateNoclip.Connections) do
            conn:Disconnect()
        end
        
        -- Restaura colisões
        if LocalPlayer.Character then
            managePlayerCollisions(LocalPlayer.Character)
        end
        
        -- Restaura bolas
        for ball in pairs(UltimateNoclip.SoccerBalls) do
            if ball.Parent then
                pcall(function()
                    ball.CanCollide = true
                    ball.Anchored = false
                end)
            end
        end
    end
end)
-------------------------------------------------------------------------------
-- Toggle para Anti-Sit
local antiSitConnection = nil
local antiSitAtivado = false

Tab2:AddToggle({
    Name = "Anti-Sentar",
    Description = "Impede o personagem de sentar",
    Default = false,
    Callback = function(state)
        antiSitAtivado = state
        local LocalPlayer = game:GetService("Players").LocalPlayer

        if state then
            local function applyAntiSit(character)
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                    humanoid:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
                    if antiSitConnection then
                        antiSitConnection:Disconnect()
                    end
                    antiSitConnection = humanoid.Seated:Connect(function(isSeated)
                        if isSeated then
                            humanoid.Sit = false
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end
            end

            if LocalPlayer.Character then
                applyAntiSit(LocalPlayer.Character)
            end

            local characterAddedConnection
            characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
                if not antiSitAtivado then
                    characterAddedConnection:Disconnect()
                    return
                end
                local humanoid = character:WaitForChild("Humanoid", 5)
                if humanoid then
                    applyAntiSit(character)
                end
            end)
        else
            if antiSitConnection then
                antiSitConnection:Disconnect()
                antiSitConnection = nil
            end

            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                end
            end
        end
    end
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variáveis
local billboardGuis = {}
local connections = {}
local espAtivado = false
local selectedColor = "RGB"

-- Botão para Fly GUI
Tab2:AddButton({
    Name = "Abrir Fly GUI",
    Description = "Abrir a interface de voo",
    Callback = function()
        local success, _ = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-gui-v3-30439"))()
        end)

        game.StarterGui:SetCore("SendNotification", {
            Title = success and "" or "",
            Text = success and "   !" or " .",
            Duration = 5
        })
    end
})

Tab2:AddSection({"ESP"})


-- Dropdown de cor
Tab2:AddDropdown({
    Name = "Cor do ESP",
    Default = "RGB",
    Options = {
        "RGB", "Branco", "Preto", "Vermelho",
        "Verde", "Azul", "Amarelo", "Rosa", "Roxo"
    },
    Callback = function(value)
        selectedColor = value
    end
})

-- Função para obter a cor
local function getESPColor()
    if selectedColor == "RGB" then
        local h = (tick() % 5) / 5
        return Color3.fromHSV(h, 1, 1)
    elseif selectedColor == "Preto" then
        return Color3.fromRGB(0, 0, 0)
    elseif selectedColor == "Branco" then
        return Color3.fromRGB(255, 255, 255)
    elseif selectedColor == "Vermelho" then
        return Color3.fromRGB(255, 0, 0)
    elseif selectedColor == "Verde" then
        return Color3.fromRGB(0, 255, 0)
    elseif selectedColor == "Azul" then
        return Color3.fromRGB(0, 170, 255)
    elseif selectedColor == "Amarelo" then
        return Color3.fromRGB(255, 255, 0)
    elseif selectedColor == "Rosa" then
        return Color3.fromRGB(255, 105, 180)
    elseif selectedColor == "Roxo" then
        return Color3.fromRGB(128, 0, 128)
    end
    return Color3.new(1, 1, 1)
end

-- Função para criar o ESP
local function updateESP(player)
    if player == Players.LocalPlayer then return end
    if not espAtivado then return end

    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            if billboardGuis[player] then
                billboardGuis[player]:Destroy()
            end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_Billboard"
            billboard.Parent = head
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3.5, 0)
            billboard.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.Parent = billboard
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextStrokeTransparency = 0.5
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 14
            textLabel.Text = player.Name .. " | " .. player.AccountAge .. ""
            textLabel.TextColor3 = getESPColor()

            billboardGuis[player] = billboard
        end
    end
end

-- Função para remover o ESP
local function removeESP(player)
    if billboardGuis[player] then
        billboardGuis[player]:Destroy()
        billboardGuis[player] = nil
    end
end

-- Toggle de ativação do ESP
local Toggle1 = Tab2:AddToggle({
    Name = "Ativar ESP",
    Description = "Exibe os jogadores através das paredes",
    Default = false
})
Toggle1:Callback(function(value)
    espAtivado = value

    if espAtivado then
        for _, player in pairs(Players:GetPlayers()) do
            updateESP(player)
        end

        local updateConnection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                updateESP(player)
            end
            if selectedColor == "RGB" then
                for _, player in pairs(Players:GetPlayers()) do
                    local gui = billboardGuis[player]
                    if gui and gui:FindFirstChild("TextLabel") then
                        gui.TextLabel.TextColor3 = getESPColor()
                    end
                end
            end
        end)
        table.insert(connections, updateConnection)

        local playerAdded = Players.PlayerAdded:Connect(function(player)
            updateESP(player)
            local charConn = player.CharacterAdded:Connect(function()
                updateESP(player)
            end)
            table.insert(connections, charConn)
        end)
        table.insert(connections, playerAdded)

        local playerRemoving = Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
        table.insert(connections, playerRemoving)

    else
        for _, player in pairs(Players:GetPlayers()) do
            removeESP(player)
        end
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        connections = {}
        billboardGuis = {}
    end
end)

----------------------------------------------------------------------------------------------------------------------------------
                                                         --  3: Personagem
----------------------------------------------------------------------------------------------------------------------------------

Tab3:AddSection({"Copiar personagem"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local valor_do_nome_do_joagdor
local Target = nil

local function GetPlayerNames()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name ~= LocalPlayer.Name then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

local Dropdown = Tab3:AddDropdown({
    Name = "Lista de jogadores",
    Description = "Selecionar um jogador",
    Options = GetPlayerNames(),
    Default = "",
    Flag = "player list",
    Callback = function(playername)
        valor_do_nome_do_joagdor = playername
        Target = playername -- Conectar o dropdown ao Copy Avatar
    end
})

local function UptadePlayers()
    Dropdown:Set(GetPlayerNames())
end

UptadePlayers()

Tab3:AddButton({"Atualizar lista", function()
    UptadePlayers()
end})

Players.PlayerAdded:Connect(UptadePlayers)
Players.PlayerRemoving:Connect(UptadePlayers)

Tab3:AddButton({
    Name = "Copiar personagem",
    Callback = function()
        if not Target then return end

        local LP = Players.LocalPlayer
        local LChar = LP.Character
        local TPlayer = Players:FindFirstChild(Target)

        if TPlayer and TPlayer.Character then
            local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")

            if LHumanoid and THumanoid then
                -- RESETAR LOCALPLAYER
                local LDesc = LHumanoid:GetAppliedDescription()

                -- Remover acessórios, roupas e face atuais
                for _, acc in ipairs(LDesc:GetAccessories(true)) do
                    if acc.AssetId and tonumber(acc.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                        task.wait(0.2)
                    end
                end

                if tonumber(LDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                    task.wait(0.2)
                end

                if tonumber(LDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                    task.wait(0.2)
                end

                local PDesc = THumanoid:GetAppliedDescription()

                -- Enviar partes do corpo
                local argsBody = {
                    [1] = {
                        [1] = PDesc.Torso,
                        [2] = PDesc.RightArm,
                        [3] = PDesc.LeftArm,
                        [4] = PDesc.RightLeg,
                        [5] = PDesc.LeftLeg,
                        [6] = PDesc.Head
                    }
                }
                Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
                task.wait(0.5)

                if tonumber(PDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                    task.wait(0.3)
                end

                if tonumber(PDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                    task.wait(0.3)
                end

                for _, v in ipairs(PDesc:GetAccessories(true)) do
                    if v.AssetId and tonumber(v.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                        task.wait(0.3)
                    end
                end

                local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
                if SkinColor then
                    Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                    task.wait(0.3)
                end

                if tonumber(PDesc.IdleAnimation) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))
                    task.wait(0.3)
                end

                -- Nome, bio e cor
                local Bag = TPlayer:FindFirstChild("PlayersBag")
                if Bag then
                    if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPNameColor") then
                        Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBioColor") then
                        Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
})

------------------------------------------------------------------------------------------------------------------------------------
Tab3:AddSection({"Não Não "})


local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Namespace para evitar conflitos
local AvatarManager = {}
AvatarManager.ReplicatedStorage = ReplicatedStorage

-- Função para exibir notificação
function AvatarManager:MostrarNotificacao(mensagem)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Notificação",
            Text = mensagem,
            Duration = 5
        })
    end)
end

-- Tabela de avatares
AvatarManager.Avatares = {
    { Nome = "Gato de Manga", ID = 124948425515124 },
    { Nome = "Tung Saur", ID = 117098257036480 },
    { Nome = "Tralaleiro", ID = 99459753608381 },
    { Nome = "Monstro S.A", ID = 123609977175226 },
    { Nome = "Trenzinho", ID = 80468697076178 },
    { Nome = "Dino", ID = 11941741105 },
    { Nome = "Pou idoso", ID = 15742966010  },
    { Nome = "Coco/boxt@", ID = 77013984520332  },
    { Nome = "Coelho", ID = 71797333686800  },
    { Nome = "Hipopótamo", ID = 73215892129281 },
    { Nome = "Ratatui", ID = 108557570415453 },
    { Nome = "Galinha", ID = 71251793812515 },
    { Nome = "Pepa pig", ID = 92979204778377 },
    { Nome = "pinguin", ID = 94944293759578 },
    { Nome = "Sid", ID = 87442757321244 },
    { Nome = "puga grande", ID = 111436158728716 },
    { Nome = "SHREK AMALDIÇOADO", ID = 120960401202173 },
    { Nome = "mosquito grande", ID = 108052868536435 },
    { Nome = "Noob Invertido", ID = 106596990206151 },
    { Nome = "Pato(a)", ID = 135132836238349 },
    { Nome = "Cachorro Chihuahua", ID = 18656467256 },
    { Nome = "Gato sla", ID = 18994959003 },
    { Nome = "Gato fei ", ID = 77506186615650 },
    { Nome = "Inpostor", ID = 18234669337 },
    { Nome = "Simon amarelo", ID = 75183593514657 },
    { Nome = "Simon azul", ID = 76155710249925 }
    
}
-- Função para obter os nomes dos avatares para o dropdown
function AvatarManager:GetAvatarNames()
    local nomes = {}
    for _, avatar in ipairs(self.Avatares) do
        table.insert(nomes, avatar.Nome)
    end
    return nomes
end

-- Função para equipar o avatar
function AvatarManager:EquiparAvatar(avatarName)
    for _, avatar in ipairs(self.Avatares) do
        if avatar.Nome == avatarName then
            local args = { avatar.ID }
            local success, result = pcall(function()
                return self.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(unpack(args))
            end)
            if success then
                self:MostrarNotificacao("Avatar " .. avatarName .. " equipado com sucesso!")
            else
                self:MostrarNotificacao("Falha ao equipar o avatar " .. avatarName .. "!")
            end
            return
        end
    end
    self:MostrarNotificacao("Avatar " .. avatarName .. " não encontrado!")
end

-- Tab3: Opção de Avatar
-- Dropdown para avatares
local AvatarDropdown = Tab3:AddDropdown({
    Name = "Avatares 3D",
    Description = "Escolha para equipar",
    Default = nil,
    Options = AvatarManager:GetAvatarNames(),
    Callback = function(avatarSelecionado)
        _G.SelectedAvatar = avatarSelecionado
    end
})

-- Botão para equipar avatar
Tab3:AddButton({
    Name = "Equipar",
    Description = "Equipar selecionado",
    Callback = function()
        if not _G.SelectedAvatar or _G.SelectedAvatar == "" then
            AvatarManager:MostrarNotificacao("   !")
            return
        end
        AvatarManager:EquiparAvatar(_G.SelectedAvatar)
    end
})

-------------------------------------------------------------------------------------------------------------------------
Tab3:AddSection({"Editor de personagem"})
-- Botão para equipar partes do corpo

Tab3:AddParagraph({
    Title = "Editor de personagem",
    Content = ""
})

-- Cria um botão para equipar todas as partes do corpo
Tab3:AddButton({
    Name = "Mini REPO",
    Callback = function()
        local args = {
            {
                117101023704825, -- Perna Direita
                125767940563838,  -- Perna Esquerda
                137301494386930,  -- Braço Direito
                87357384184710,  -- Braço Esquerdo
                133391239416999, -- Torso
                111818794467824   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "mini garanhao",
    Callback = function()
        local args = {
            {
                124355047456535, -- Perna Direita
                120507500641962,  -- Perna Esquerda
                82273782655463,  -- Braço Direito
                113625313757230,  -- Braço Esquerdo
                109182039511426, -- Torso
                0   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "stick",
    Callback = function()
        local args = {
            {
                14731384498, -- Perna Direita
                14731377938,  -- Perna Esquerda
                14731377894,  -- Braço Direito
                14731377875,  -- Braço Esquerdo
                14731377941, -- Torso
                14731382899   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Chunky-Bug",
    Callback = function()
        local args = {
            {
                15527827600, -- Perna Direita
                15527827578,  -- Perna Esquerda
                15527831669,  -- Braço Direito
                15527836067,  -- Braço Esquerdo
                15527827184, -- Torso
                15527827599   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Cursed-Spider",
    Callback = function()
        local args = {
            {
                134555168634906, -- Perna Direita
                100269043793774,  -- Perna Esquerda
                125607053187319,  -- Braço Direito
                122504853343598,  -- Braço Esquerdo
                95907982259204, -- Torso
                91289185840375   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

---------------------------------------------------------------------------------------------------

Tab3:AddButton({
    Name = "Possessed-Horror",
    Callback = function()
        local args = {
            {
                122800511983371, -- Perna Direita
                132465361516275,  -- Perna Esquerda
                125155800236527,  -- Braço Direito
                83070163355072,  -- Braço Esquerdo
                102906187256945, -- Torso
                78311422507297   -- Cabeça
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("ChangeCharacterBody")
            :InvokeServer(unpack(args))
        print(" Equipar   !")
    end
})

Tab3:AddParagraph({
    Title = "Notificação",
    Content = ""
})

---------------------------------------------------------------------------------------------------------------------------------
                                          -- ===  4: Casa === --
---------------------------------------------------------------------------------------------------------------------------------

Tab4:AddSection({"Sua casa"})
local RunService = game:GetService("RunService")
local rgbHouse = false
local rgbConnection

Tab4:AddToggle({
    Name = "Cor da casa RGB",
    Default = false,
    Callback = function(value)
        rgbHouse = value

        if rgbHouse then
            rgbConnection = RunService.RenderStepped:Connect(function()
                local color = Color3.fromHSV(
                    math.random(),
                    1,
                    1
                )

                local args = {
                    "ColorPickHouse",
                    color
                }

                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1Player1sHous1e")
                    :FireServer(unpack(args))
            end)
        else
            if rgbConnection then
                rgbConnection:Disconnect()
                rgbConnection = nil
            end
        end
    end
})
local RunService = game:GetService("RunService")
local houseTextRgb = false
local houseTextConnection

Tab4:AddToggle({
    Name = "Texto da casa RGB",
    Default = false,
    Callback = function(value)
        houseTextRgb = value

        if houseTextRgb then
            houseTextConnection = RunService.RenderStepped:Connect(function()
                local color = Color3.fromHSV(
                    math.random(),
                    1,
                    1
                )

                local args = {
                    "PickingBusinessNameColor",
                    color
                }

                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1tColo1r")
                    :FireServer(unpack(args))
            end)
        else
            if houseTextConnection then
                houseTextConnection:Disconnect()
                houseTextConnection = nil
            end
        end
    end
})
Tab4:AddSection({"Texto personalizado da casa"})
local RunService = game:GetService("RunService")

local hackedHouseText = false
local hackedConnection
local lastUpdate = 0
local state = false

local texts = {
    "Cat Hub",
    "Cat Hub On Top",
    "!",
    "Cat Hub ",
    " Cat Hub",
    "Boom!!!"
}

Tab4:AddToggle({
    Name = "Ativar texto personalizado da casa",
    Default = false,
    Callback = function(value)
        hackedHouseText = value

        if hackedHouseText then
            hackedConnection = RunService.RenderStepped:Connect(function()
                if tick() - lastUpdate < 0.35 then return end
                lastUpdate = tick()

                state = not state

                -- Alterna cor (preto / verde)
                local color = state and Color3.new(0, 0, 0) or Color3.new(0, 1, 0)

                -- Texto aleatório estilizado
                local text = texts[math.random(1, #texts)]

                -- Aplica texto
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1t")
                    :FireServer("BusinessName", text)

                -- Aplica cor
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RE")
                    :WaitForChild("1RPHous1eEven1tColo1r")
                    :FireServer("PickingBusinessNameColor", color)
            end)
        else
            if hackedConnection then
                hackedConnection:Disconnect()
                hackedConnection = nil
            end
        end
    end
})
Tab4:AddSection({"Outras casas"})
Tab4:AddButton({
    Name = "Carregar outras casas",
    Description = "Carregar as casas disponíveis",
    Callback = function()
        local successCount = 0
        local failCount = 0
        for i = 1, 37 do
            local bannedBlockName = "BannedBlock" .. i
            local bannedBlock = Workspace:FindFirstChild(bannedBlockName, true)
            if bannedBlock then
                local success, _ = pcall(function()
                    bannedBlock:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        for _, house in pairs(Workspace:GetDescendants()) do
            if house.Name:match("BannedBlock") then
                local success, _ = pcall(function()
                    house:Destroy()
                end)
                if success then
                    successCount = successCount + 1
                else
                    failCount = failCount + 1
                end
            end
        end
        if successCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Notificação",
                Text = "" .. successCount .. " !",
                Duration = 5
            })
        end
        if failCount > 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Notificação",
                Text = "" .. failCount .. " .",
                Duration = 5
            })
        end
        if successCount == 0 and failCount == 0 then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Notificação",
                Text = "    .",
                Duration = 5
            })
        end
    end
})
Tab4:AddSection({" Casa"})
local player = game.Players.LocalPlayer

Tab4:AddToggle({
    Name = "Casa automática",
    Default = false,
    Callback = function(value)
        local args = { value } -- passa true ou false dependendo do toggle
        local success, err = pcall(function()
            workspace:WaitForChild("001_Lots")
                :WaitForChild(player.Name.."House")
                :WaitForChild("HousePickedByPlayer")
                :WaitForChild("HouseModel")
                :WaitForChild("Permissions:SetPropPlacementBlockedForOthers")
                :InvokeServer(unpack(args))
        end)
        if not success then
            warn("   :", err)
        end
    end
})
local player = game.Players.LocalPlayer

Tab4:AddButton({
    Name = "Selecionar casa atual",
    Callback = function()
        local success, err = pcall(function()
            workspace:WaitForChild("001_Lots")
                :WaitForChild(player.Name.."House")
                :WaitForChild("HousePickedByPlayer")
                :WaitForChild("HouseModel")
                :WaitForChild("Permissions:ClearProps")
                :InvokeServer()
        end)
        if not success then
            warn("  :", err)
        end
    end
})
Tab4:AddSection({""})
local loopGarage = false

Tab4:AddToggle({
    Name = "Loop da garagem",
    Default = false,
    Callback = function(value)
        loopGarage = value

        if loopGarage then
            task.spawn(function()
                while loopGarage do
                    local args = {
                        "GarageDoor"
                    }

                    game:GetService("ReplicatedStorage")
                        :WaitForChild("RE")
                        :WaitForChild("1Player1sHous1e")
                        :FireServer(unpack(args))

                    task.wait(7)
                end
            end)
        end
    end
})

---------------------------------------------------------------------------------------------------------------------------------
                                          -- ===  5: Carro === --
---------------------------------------------------------------------------------------------------------------------------------

Tab5:AddSection({""})

local speedValue = 200
local turboValue = 11.3

local function getAllCars()
    local cars = {}
    if workspace:FindFirstChild("Vehicles") then
        for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
            if vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat") then
                table.insert(cars, vehicle)
            end
        end
    end
    return cars
end

local function applyToAllCars(valueType, value)
    local cars = getAllCars()
    local carsModified = 0

    for _, car in pairs(cars) do
        local seat = car.Seats.VehicleSeat
        local target = seat:FindFirstChild(valueType)

        if target and target.Value ~= nil then
            target.Value = value
            carsModified += 1
        else
            pcall(function()
                seat[valueType] = value
                carsModified += 1
            end)
        end
    end

    newNotify("Cat Hub", "" .. carsModified .. "")
end

Tab5:AddTextBox({
    Title = "Velocidade do carro",
    Placeholder = "Example: 300",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            speedValue = num
            newNotify("Cat Hub", "  : " .. num)
        else
            newNotify("Cat Hub", "")
        end
    end
})

Tab5:AddTextBox({
    Title = "Potência do turbo",
    Placeholder = "Example: 15",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            turboValue = num
            newNotify("Cat Hub", "  : " .. num)
        else
            newNotify("Cat Hub", "")
        end
    end
})

Tab5:AddButton({
    Title = "Notificação",
    Callback = function()
        applyToAllCars("MaxSpeed", speedValue)
    end
})

Tab5:AddButton({
    Title = "Notificação",
    Callback = function()
        applyToAllCars("Turbo", turboValue)
    end
})

Tab5:AddSection({" Carro"})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Namespace para evitar conflitos
local TeleportCarro = {}
TeleportCarro.Players = Players
TeleportCarro.Workspace = Workspace
TeleportCarro.LocalPlayer = LocalPlayer
TeleportCarro.Camera = Camera

-- Função para exibir notificação
function TeleportCarro:MostrarNotificacao(mensagem)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Notificação",
            Text = mensagem,
            Duration = 5
        })
    end)
end

-- Função para desativar/ativar dano de queda
function TeleportCarro:ToggleFallDamage(disable)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return false end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if disable then
        humanoid:SetStateAtivado(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
        return true
    else
        humanoid:SetStateAtivado(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.Ragdoll, true)
        return false
    end
end

-- Função para teleportar o jogador para o assento do carro
function TeleportCarro:TeleportToSeat(seat, car)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then
        self:MostrarNotificacao("Personagem  !")
        return false
    end
    local humanoid = self.LocalPlayer.Character.Humanoid
    local rootPart = self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        self:MostrarNotificacao("   !")
        return false
    end

    humanoid.Sit = false
    task.wait(0.1)

    rootPart.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
    task.wait(0.1)

    seat:Sit(humanoid)
    task.wait(0.5)
    return humanoid.SeatPart == seat
end

-- Função para teleportar o carro para o void com delay
function TeleportCarro:TeleportToVoid(car)
    if not car then
        self:MostrarNotificacao("  !")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("    !")
            return
        end
    end
    local voidPosition = Vector3.new(0, -1000, 0)
    car:SetPrimaryPartCFrame(CFrame.new(voidPosition))
    task.wait(0.5)
end

-- Função para teleportar o carro para a posição do jogador com delay
function TeleportCarro:TeleportToPlayer(car, playerPos)
    if not car then
        self:MostrarNotificacao("  !")
        return
    end
    if not car.PrimaryPart then
        local body = car:FindFirstChild("Body", true) or car:FindFirstChild("Chassis", true)
        if body and body:IsA("BasePart") then
            car.PrimaryPart = body
        else
            self:MostrarNotificacao("    !")
            return
        end
    end
    local targetPos = playerPos + Vector3.new(5, 0, 5)
    car:SetPrimaryPartCFrame(CFrame.new(targetPos))
    task.wait(0.5)
end

-- Função para sair do carro e voltar à posição original
function TeleportCarro:ExitCarAndReturn(originalPos)
    if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    local humanoid = self.LocalPlayer.Character.Humanoid
    if humanoid.SeatPart then
        humanoid.Sit = false
    end
    task.wait(0.1)
    if originalPos then
        self.LocalPlayer.Character:PivotTo(CFrame.new(originalPos))
    end
end

-- Função para atualizar a lista de carros no dropdown
function TeleportCarro:AtualizarListaCarros()
    local pastaVeiculos = self.Workspace:FindFirstChild("Vehicles")
    local listaCarros = {}
    
    if pastaVeiculos then
        for _, carro in ipairs(pastaVeiculos:GetChildren()) do
            if carro.Name:match("Car$") then
                table.insert(listaCarros, carro.Name)
            end
        end
    end
    
    return listaCarros
end


-- Toggle para matar todos os carros
Tab5:AddToggle({
    Name = "    Void",
    Description = "   Void",
    Default = false,
    Callback = function(state)
        local originalPosition
        local teleportActive = state
        local fallDamageDesativado = false

        if state then
            if self.LocalPlayer.Character and self.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                originalPosition = self.LocalPlayer.Character.HumanoidRootPart.Position
            else
                TeleportCarro:MostrarNotificacao("Personagem  !")
                return
            end

            fallDamageDesativado = TeleportCarro:ToggleFallDamage(true)

            spawn(function()
                local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
                if not vehiclesFolder then
                    TeleportCarro:MostrarNotificacao("   !")
                    return
                end

                local cars = {}
                for _, car in ipairs(vehiclesFolder:GetChildren()) do
                    if car.Name:match("Car$") then
                        table.insert(cars, car)
                    end
                end

                for _, car in ipairs(cars) do
                    if not teleportActive then break end

                    local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
                    if vehicleSeat and vehicleSeat.Occupant == nil then
                        local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                        if success then
                            TeleportCarro:TeleportToVoid(car)
                            TeleportCarro:ExitCarAndReturn(originalPosition)
                            task.wait(1)
                        end
                    end
                end

                if teleportActive then
                    teleportActive = false
                    TeleportCarro:ToggleFallDamage(false)
                end
            end)
        else
            teleportActive = false
            TeleportCarro:ToggleFallDamage(false)
        end
    end
})

Tab5:AddSection({""})

-- Criar o dropdown
local Dropdown = Tab5:AddDropdown({
    Name = "Selecionar carro",
    Description = "Escolha um carro",
    Default = nil,
    Options = TeleportCarro:AtualizarListaCarros(),
    Callback = function(carroSelecionado)
        _G.SelectedVehicle = carroSelecionado
    end
})

-- Toggle para ver a câmera do carro selecionado
Tab5:AddToggle({
    Name = "  Carro",
    Description = "   Carro ",
    Default = false,
    Callback = function(state)
        if state then
            if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
                TeleportCarro:MostrarNotificacao("   !")
                return
            end

            local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
            if not vehiclesFolder then
                TeleportCarro:MostrarNotificacao("   !")
                return
            end

            local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
            if not vehicle then
                TeleportCarro:MostrarNotificacao("Carro   !")
                return
            end

            local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
            if not vehicleSeat then
                TeleportCarro:MostrarNotificacao(" Carro  !")
                return
            end

            -- Salvar o estado original da câmera
            TeleportCarro.OriginalCameraSubject = TeleportCarro.Camera.CameraSubject
            TeleportCarro.OriginalCameraType = TeleportCarro.Camera.CameraType

            -- Ajustar a câmera para o assento do carro, mesmo se ocupado
            TeleportCarro.Camera.CameraSubject = vehicleSeat
            TeleportCarro.Camera.CameraType = Enum.CameraType.Follow
            TeleportCarro:MostrarNotificacao("    Carro " .. _G.SelectedVehicle .. "!")
        else
            -- Restaurar a câmera ao estado original
            if TeleportCarro.OriginalCameraSubject then
                TeleportCarro.Camera.CameraSubject = TeleportCarro.OriginalCameraSubject
                TeleportCarro.Camera.CameraType = TeleportCarro.OriginalCameraType or Enum.CameraType.Custom
                TeleportCarro:MostrarNotificacao("  !")
                TeleportCarro.OriginalCameraSubject = nil
                TeleportCarro.OriginalCameraType = nil
            end
        end
    end
})

-- Atualizar o dropdown dinamicamente
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildAdded:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)
TeleportCarro.Workspace:WaitForChild("Vehicles").ChildRemoved:Connect(function()
    Dropdown:Set(TeleportCarro:AtualizarListaCarros())
end)

Tab5:AddSection({"Não  "})

-- Botão para destruir carro selecionado
Tab5:AddButton({
    Name = "Não Carro ",
    Description = " Carro  Void",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("   !")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("   !")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro   !")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao(" Carro  !")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("Não        !")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao(" Não  !")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToVoid(vehicle)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. "   Void!")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("   Carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer carro selecionado
Tab5:AddButton({
    Name = " Carro ",
    Description = " Carro  ",
    Callback = function()
        if not _G.SelectedVehicle or _G.SelectedVehicle == "" then
            TeleportCarro:MostrarNotificacao("   !")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("   !")
            return
        end

        local vehicle = vehiclesFolder:FindFirstChild(_G.SelectedVehicle)
        if not vehicle then
            TeleportCarro:MostrarNotificacao("Carro   !")
            return
        end

        local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
        if not vehicleSeat then
            TeleportCarro:MostrarNotificacao(" Carro  !")
            return
        end

        if vehicleSeat.Occupant then
            TeleportCarro:MostrarNotificacao("Não  Teleporte     !")
            return
        end

        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao(" Não  !")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local success = TeleportCarro:TeleportToSeat(vehicleSeat, vehicle)
        if success then
            TeleportCarro:TeleportToPlayer(vehicle, originalPos)
            TeleportCarro:MostrarNotificacao("Carro " .. _G.SelectedVehicle .. "  !")
            TeleportCarro:ExitCarAndReturn(originalPos)
        else
            TeleportCarro:MostrarNotificacao("   Carro!")
        end
        TeleportCarro:ToggleFallDamage(false)
    end
})

-- Botão para trazer todos os carros
Tab5:AddButton({
    Name = "Trazer todos os carros",
    Description = "Trazer os carros disponíveis",
    Callback = function()
        local originalPos
        if TeleportCarro.LocalPlayer.Character and TeleportCarro.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            originalPos = TeleportCarro.LocalPlayer.Character.HumanoidRootPart.Position
        else
            TeleportCarro:MostrarNotificacao(" Não  !")
            return
        end

        local vehiclesFolder = TeleportCarro.Workspace:FindFirstChild("Vehicles")
        if not vehiclesFolder then
            TeleportCarro:MostrarNotificacao("   !")
            return
        end

        local isFallDamageOff = TeleportCarro:ToggleFallDamage(true)
        local cars = {}
        for _, car in ipairs(vehiclesFolder:GetChildren()) do
            if car.Name:match("Car$") then
                table.insert(cars, car)
            end
        end

        for _, car in ipairs(cars) do
            local vehicleSeat = car:FindFirstChildWhichIsA("VehicleSeat", true)
            if vehicleSeat and vehicleSeat.Occupant == nil then
                local success = TeleportCarro:TeleportToSeat(vehicleSeat, car)
                if success then
                    TeleportCarro:TeleportToPlayer(car, originalPos)
                    TeleportCarro:ExitCarAndReturn(originalPos)
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. "  !")
                    task.wait(1)
                else
                    TeleportCarro:MostrarNotificacao("Falha ao sentar no carro " .. car.Name .. "!")
                end
            else
                if vehicleSeat then
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " :    !")
                else
                    TeleportCarro:MostrarNotificacao("Carro " .. car.Name .. " : Não  !")
                end
            end
        end

        TeleportCarro:ToggleFallDamage(false)
        if #cars == 0 then
            TeleportCarro:MostrarNotificacao("Não   !")
        end
    end
})

-- Manter o estado de dano de queda ao recarregar o personagem
local fallDamageDesativado = false
TeleportCarro.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    if fallDamageDesativado then
        humanoid:SetStateAtivado(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.GettingUp, true)
        humanoid.PlatformStand = false
    else
        humanoid:SetStateAtivado(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateAtivado(Enum.HumanoidStateType.Ragdoll, true)
    end
end)

Tab5:AddSection({"Carro - RGB"})
local function vehiclergb()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local player = Players.LocalPlayer
    local remote = player:WaitForChild("PlayerGui")
        :WaitForChild("MainGUIHandler")
        :WaitForChild("VehicleControl")
        :WaitForChild("UIColorPicker")
        :WaitForChild("SetColor")

    return RunService.RenderStepped:Connect(function()
        local color = Color3.fromRGB(
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255)
        )
        remote:FireServer(color)
    end)
end

local vehicleRgbConnection

Tab5:AddToggle({
    Name = "Carro RGB",
    Default = false,
    Callback = function(value)
        if value then
            if not vehicleRgbConnection then
                vehicleRgbConnection = vehiclergb()
            end
            print(" Ativar RGB ")
        else
            if vehicleRgbConnection then
                vehicleRgbConnection:Disconnect()
                vehicleRgbConnection = nil
            end
            print("  RGB ")
        end
    end
})
Tab5:AddSection({" Carro"})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local PlayHorn = Remotes:WaitForChild("PlayHorn")
local StopHorn = Remotes:WaitForChild("StopHorn")

Tab5:AddToggle({
    Name = " Não",
    Default = false,
    Callback = function(value)
        if value then
            PlayHorn:InvokeServer()
        else
            StopHorn:InvokeServer()
        end
    end
})

---------------------------------------------------------------------------------------------------------------------------------
                                                   -- ===  6: RGB === --
---------------------------------------------------------------------------------------------------------------------------------

local Section = Tab6:AddSection({""})




-- Velocidade controlada pelo slider (quanto maior, mais rápido)
local rgbSpeed = 1

Tab6:AddSlider({
    Name = " RGB",
    Description = "   RGB",
    Min = 1,
    Max = 5,
    Increase = 1,
    Default = 3,
    Callback = function(Value)
        rgbSpeed = Value
    end
})

-- Função para criar cor RGB suave com HSV
local function getRainbowColor(speedMultiplier)
    local h = (tick() * speedMultiplier % 5) / 5 -- gira o hue suavemente de 0 a 1
    return Color3.fromHSV(h, 1, 1)
end

-- Função para disparar eventos
local function fireServer(eventName, args)
    local event = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
    if event and event:FindFirstChild(eventName) then
        pcall(function()
            event[eventName]:FireServer(unpack(args))
        end)
    end
end

Tab6:AddSection({"RGB "})

-- Nome + Bio RGB  juntos
local nameBioRGBActive = false
Tab6:AddToggle({
    Name = "Não +  RGB",
    Default = false,
    Callback = function(state)
        nameBioRGBActive = state
        if state then
            task.spawn(function()
                while nameBioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    fireServer("1RPNam1eColo1r", { "PickingRPNameColor", color })
                    fireServer("1RPNam1eColo1r", { "PickingRPBioColor", color })
                    task.wait(0.03)
                end
            end)
        end
    end
})

local ToggleCorpo = Tab6:AddToggle({
    Name = " RGB",
    Description = " RGB  ",
    Default = false
})
ToggleCorpo:Callback(function(Value)
    getgenv().rgbCorpo = Value
    task.spawn(function()
        while getgenv().rgbCorpo do
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("ChangeBodyColor") then
                pcall(function()
                    remote.ChangeBodyColor:FireServer({
                        BrickColor.new(getRainbowColor(rgbSpeed))
                    })
                end)
            end
            task.wait(0.1)
        end
    end)
end)



local ToggleCabelo = Tab6:AddToggle({
    Name = " RGB",
    Description = " RGB  ",
    Default = false
})
ToggleCabelo:Callback(function(Value)
    getgenv().rgbCabelo = Value
    task.spawn(function()
        while getgenv().rgbCabelo do
            fireServer("1Max1y", {
                "ChangeHairColor2",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.5)
        end
    end)
end)



Tab6:AddSection({"Carro Casa"})



local ToggleCasa = Tab6:AddToggle({
    Name = " RGB",
    Description = " RGB  Casa",
    Default = false
})
ToggleCasa:Callback(function(Value)
    getgenv().rgbCasa = Value
    task.spawn(function()
        while getgenv().rgbCasa do
            fireServer("1Player1sHous1e", {
                "ColorPickHouse",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.1)
        end
    end)
end)


-- Carro RGB 
local carRGBActive = false
Tab6:AddToggle({
    Name = " RGB ()",
    Description = "  Carro  RGB.       !",
    Default = false,
    Callback = function(state)
        carRGBActive = state
        if state then
            task.spawn(function()
                while carRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    fireServer("1Player1sCa1r", { "PickingCarColor", color })
                    task.wait(0.03)
                end
            end)
        end
    end
})


local ToggleBicicleta = Tab6:AddToggle({
    Name = " RGB",
    Description = " RGB  ",
    Default = false
})
ToggleBicicleta:Callback(function(Value)
    getgenv().rgbBicicleta = Value
    task.spawn(function()
        while getgenv().rgbBicicleta do
            fireServer("1Player1sCa1r", {
                "NoMotorColor",
                getRainbowColor(rgbSpeed)
            })
            task.wait(0.1)
        end
    end)
end)



Tab6:AddSection({""})


-- NOVO TOGGLE: Rádio RGB
local radioRGBActive = false
Tab6:AddToggle({
    Name = " RGB",
    Description = "    RGB",
    Default = false,
    Callback = function(state)
        radioRGBActive = state
        if state then
            task.spawn(function()
                while radioRGBActive and LocalPlayer.Character do
                    local color = getRainbowColor(rgbSpeed)
                    local success, remote = pcall(function()
                        return LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ToolGui"):WaitForChild("ToolConfigurações"):WaitForChild("Configurações"):WaitForChild("PropsColor"):WaitForChild("SetColor")
                    end)
                    if success and remote then
                        pcall(function()
                            remote:FireServer(color)
                        end)
                    end
                    task.wait(0.03)
                end
            end)
        end
    end
})

local ToggleMegafone = Tab6:AddToggle({
    Name = "RGB Megafone",
    Description = "RGB  no megafone",
    Default = false
})
ToggleMegafone:Callback(function(Value)
    getgenv().rgbMegafone = Value
    task.spawn(function()
        while getgenv().rgbMegafone do
            local color = getRainbowColor(rgbSpeed)
            local gui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if gui then
                local btn = gui:FindFirstChild("ToolGui")
                if btn then
                    local settings = btn:FindFirstChild("ToolConfigurações")
                    if settings then
                        local props = settings:FindFirstChild("Configurações"):FindFirstChild("PropsColor")
                        if props and props:FindFirstChild("SetColor") then
                            pcall(function()
                                props.SetColor:FireServer(color)
                            end)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

local ToggleRosquinha = Tab6:AddToggle({
    Name = "RGB Rosquinha",
    Description = "RGB  na rosquinha",
    Default = false
})
ToggleRosquinha:Callback(function(Value)
    getgenv().rgbRosquinha = Value
    task.spawn(function()
        while getgenv().rgbRosquinha do
            local color = getRainbowColor(rgbSpeed)
            local gui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if gui then
                local btn = gui:FindFirstChild("ToolGui")
                if btn then
                    local settings = btn:FindFirstChild("ToolConfigurações")
                    if settings then
                        local props = settings:FindFirstChild("Configurações"):FindFirstChild("PropsColor")
                        if props and props:FindFirstChild("SetColor") then
                            pcall(function()
                                props.SetColor:FireServer(color)
                            end)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)




---------------------------------------------------------------------------------------------------------------------------------
                                                -- === Tab 7: Music All === --
---------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Função para tocar som globalmente via Remote
local function tocarGlobalmente(soundId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local args = {
                [1] = hrp,
                [2] = hrp,
                [3] = Vector3.new(0, -1, 0),
                [4] = Vector3.new(0, 0, 0),
                [5] = hrp,
                [6] = hrp,
                [7] = tostring(soundId),
                [8] = tostring(soundId),
                [9] = { [1] = true },
                [10] = {
                    [1] = 25,
                    [2] = Vector3.new(0.25, 0.25, 100),
                    [3] = BrickColor.new(24),
                    [4] = 0.25,
                    [5] = Enum.Material.SmoothPlastic,
                    [6] = 0.25
                },
                [11] = true,
                [12] = false
            }

            local remote = ReplicatedStorage:FindFirstChild("RE")
            if remote and remote:FindFirstChild("1Gu1n") then
                pcall(function()
                    remote["1Gu1n"]:FireServer(unpack(args))
                end)
            end
        end
    end
end

-- Variáveis
local loopAtivo = false
local InputID = ""

-- TextBox para inserir o ID
Tab7:AddTextBox({
    Name = "Insira o ID Audio All",
    Description = "Digite o ID do som que deseja tocar globalmente",
    PlaceholderText = "Exemplo: 1234567890",
    ClearTextOnFocus = true,
    Callback = function(text)
        InputID = tonumber(text)
    end
})

-- Botão para tocar o som
Tab7:AddButton({
    Name = "Tocar Som Global",
    Description = "Toca o áudio para todos os jogadores",
    Callback = function()
        if InputID then
            tocarGlobalmente(InputID)

            local globalSound = Instance.new("Sound")
            globalSound.Parent = Workspace
            globalSound.SoundId = "rbxassetid://" .. InputID
            globalSound.Volume = 3
            globalSound.Looped = false
            globalSound:Play()

            task.delay(5, function()
                globalSound:Destroy()
            end)
        end
    end
})

-- Toggle de Loop Global
Tab7:AddToggle({
    Name = "Repetir música global",
    Description = "Repetir som globalmente",
    Default = false,
    Callback = function(state)
        loopAtivo = state
        if loopAtivo then
            task.spawn(function()
                while loopAtivo do
                    if InputID then
                        tocarGlobalmente(InputID)

                        local globalSound = Instance.new("Sound")
                        globalSound.Parent = Workspace
                        globalSound.SoundId = "rbxassetid://" .. InputID
                        globalSound.Volume = 3
                        globalSound.Looped = false
                        globalSound:Play()

                        task.delay(5, function()
                            globalSound:Destroy()
                        end)
                    end
                    task.wait(3)
                end
            end)
        end
    end
})

Tab7:AddSection({ "" })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Função para tocar som globalmente via Remote
local function tocarGlobalmente(soundId)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local args = {
                [1] = hrp,
                [2] = hrp,
                [3] = Vector3.new(0, -1, 0),
                [4] = Vector3.new(0, 0, 0),
                [5] = hrp,
                [6] = hrp,
                [7] = tostring(soundId),
                [8] = tostring(soundId),
                [9] = { [1] = true },
                [10] = {
                    [1] = 25,
                    [2] = Vector3.new(0.25, 0.25, 100),
                    [3] = BrickColor.new(24),
                    [4] = 0.25,
                    [5] = Enum.Material.SmoothPlastic,
                    [6] = 0.25
                },
                [11] = true,
                [12] = false
            }

            local remote = ReplicatedStorage:FindFirstChild("RE")
            if remote and remote:FindFirstChild("1Gu1n") then
                pcall(function()
                    remote["1Gu1n"]:FireServer(unpack(args))
                end)
            end
        end
    end
end

-- Lista completa de sons de memes
local sonsMemes = {
    {name = "Trollface laugh", id = "73753120048787"},
    {name = "troll face sussy", id = "9098738774"},
    {name = "troll cut", id = "8389041427"},
    {name = "troll transition", id = "7705506391"},
    {name = "troll laugh", id = "7816195044"},
    {name = "Magic2", id = "9066733515"},
    {name = "homero brasileo", id = "115224076671067"},
    {name = "LOUD Youve been trolled", id = "6787686247"},
    {name = "Fart Meme Sound", id = "6454805792"},
    {name = "Metal Rattle 2 SFX", id = "9116788555"},
    {name = "Hentai wiaaaaan", id = "88332347208779"},
    {name = "iamete cunasai", id = "108494476595033"},
    {name = "dodichan onnn...", id = "134640594695384"},
    {name = "Toma jack", id = "132603645477541"},
    {name = "Toma jackV2", id = "100446887985203"},
    {name = "Toma jack no sol quente", id = "97476487963273"},
    {name = "ifood", id = "133843750864059"},
    {name = "pelo geito ela ta querendo ram", id = "94395705857835"},
    {name = "lula vai todo mundo", id = "136804576009416"},
    {name = "coringa", id = "84663543883498"},
    {name = "shoope", id = "8747441609"},
    {name = "quenojo", id = "103440368630269"},
    {name = "sai dai lava prato", id = "101232400175829"},
    {name = "se e loko numconpeça", id = "78442476709262"},
    {name = "mita sequer que eu too uma", id = "94889439372168"},
    {name = "Hoje vou ser tua mulher e tu", id = "90844637105538"},
    {name = "Deita aqui eu mandei vc deitar sirens", id = "100291188941582"},
    {name = "miau", id = "131804436682424"},
    {name = "skibidi", id = "128771670035179"},
    {name = "BIRULEIBI", id = "121569761604968"},
    {name = "sai", id = "121169949217007"},
    {name = "risada boa dms", id = "127589011971759"},
    {name = "vacilo perna de pau", id = "106809680656199"},
    {name = "gomo gomo no!!!", id = "137067472449625"},
    {name = "arroto", id = "140203378050178"},
    {name = "iraaaa", id = "136752451575091"},
    {name = "não fica se achando muito não", id = "101588606280167"},
    {name = "WhatsApp notificação", id = "107004225739474"},
    {name = "Samsung", id = "123767635061073"},
    {name = "Shiiii", id = "120566727202986"},
    {name = "ai_tomaa miku", id = "139770074770361"},
    {name = "kuru_kuru", id = "122465710753374"},
    {name = "PM ROCAM", id = "96161547081609"},
    {name = "cavalo!!", id = "78871573440184"},
    {name = "deixa os garoto brinca", id = "80291355054807"},
    {name = "flamengo", id = "137774355552052"},
    {name = "sai do mei satnas", id = "127944706557246"},
    {name = "namoral agora e a hora", id = "120677947987369"},
    {name = "n pode me chutar pq seu celebro e burro", id = "82284055473737"},
    {name = "vc ta fudido vou te pegar", id = "120214772725166"},
    {name = "deley", id = "102906880476838"},
    {name = "Tu e um beta", id = "130233956349541"},
    {name = "Porfavor n tira eu nao", id = "85321374020324"},
    {name = "Olá beleza vc pode me dá muitos", id = "74235334504693"},
    {name = "Discord sus", id = "122662798976905"},
    {name = "rojao apito", id = "6549021381"},
    {name = "off", id = "1778829098"},
    {name = "Kazuma kazuma", id = "127954653962405"},
    {name = "sometourado", id = "123592956882621"},
    {name = "Estouradoespad", id = "136179020015211"},
    {name = "Alaku bommm", id = "110796593805268"},
    {name = "busss", id = "139841197791567"},
    {name = "Estourado wItb", id = "137478052262430"},
    {name = "sla", id = "116672405522828"},
    {name = "HA HA HA", id = "138236682866721"}
}

-- Preparar dropdown
local nomesSons = {}
local mapaSons = {}
for _, v in ipairs(sonsMemes) do
    table.insert(nomesSons, v.name)
    mapaSons[v.name] = v.id
end

local loopDropdownAtivo = false
local somSelecionado = nil

-- Cria dropdown
Tab7:AddDropdown({
    Name = "Selecionar áudio",
    Description = "Escolha um áudio global",
    Default = nomesSons[1],
    Options = nomesSons,
    Callback = function(valor)
        somSelecionado = mapaSons[valor]
    end
})

-- Botão de tocar som
Tab7:AddButton({
    Name = "Tocar áudio global",
    Description = "Tocar o áudio selecionado",
    Callback = function()
        if somSelecionado then
            tocarGlobalmente(somSelecionado)
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. somSelecionado
            s.Volume = 3
            s.Looped = false
            s.Parent = Workspace
            s:Play()
            task.delay(5, function() s:Destroy() end)
        end
    end
})

-- Toggle loop global
Tab7:AddToggle({
    Name = "Repetir áudio global",
    Description = "Repetir o áudio selecionado",
    Default = false,
    Callback = function(estado)
        loopDropdownAtivo = estado
        if loopDropdownAtivo then
            task.spawn(function()
                while loopDropdownAtivo do
                    if somSelecionado then
                        tocarGlobalmente(somSelecionado)
                        local s = Instance.new("Sound")
                        s.SoundId = "rbxassetid://" .. somSelecionado
                        s.Volume = 3
                        s.Looped = false
                        s.Parent = Workspace
                        s:Play()
                        task.delay(5, function() s:Destroy() end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

---------------------------------------------------------------------------------------------------------------------------------
                                          -- ===  8: Música Troll === --
---------------------------------------------------------------------------------------------------------------------------------

local function tocarMusica(id)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Rádio (ToolMusicText)
    local argsRadio = {
        [1] = "ToolMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("PlayerToolEvent"):FireServer(unpack(argsRadio))
    
    -- Casa (PickHouseMusicText)
    local argsCasa = {
        [1] = "PickHouseMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sHous1e"):FireServer(unpack(argsCasa))

    -- Carro (PickingCarMusicText)
    local argsCarro = {
        [1] = "PickingCarMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r"):FireServer(unpack(argsCarro))

    -- Scooter (PickingScooterMusicText)
    local argsScooter = {
        [1] = "PickingScooterMusicText",
        [2] = id
    }
    ReplicatedStorage:WaitForChild("RE"):WaitForChild("1NoMoto1rVehicle1s"):FireServer(unpack(argsScooter))
end

local function isValidMusicId(value)
    return value and value ~= "" and value ~= "Option 1" and not value:match("novas musica adds") and not value:match("musica brasil") and not value:match("musica do meu interece") and not value:match("musica dls por elas") and not value:match("meme abaixo") and not value:match("estourada")
end

Tab8:AddTextBox({
    Name = "ID da música",
    PlaceholderText = "Digite o ID da música e pressione Enter",
    Callback = function(value)
        if value and value ~= "" then
            tocarMusica(tostring(value))
        end
    end
})

-- Dropdowns para Tab8
local function createMusicDropdown(title, musicOptions, defaultOption)
    local musicNames = {}
    local categoryMap = {}
    for category, sounds in pairs(musicOptions) do
        for _, music in ipairs(sounds) do
            if music.name ~= "" then
                table.insert(musicNames, music.name)
                categoryMap[music.name] = {id = music.id, category = category}
            end
        end
    end

    local function playMusic(soundId)
        tocarMusica(tostring(soundId)) -- Usa a função tocarMusica para tocar em todos os contextos
    end

    Tab8:AddDropdown({
        Name = title,
        Description = "Todos",
        Default = defaultOption,
        Multi = false,
        Options = musicNames,
        Callback = function(selectedSound)
            if selectedSound and categoryMap[selectedSound] then
                local soundId = categoryMap[selectedSound].id
                if soundId and soundId ~= "" and soundId ~= "4354908569" then
                    playMusic(soundId)
                end
            end
        end
    })
end

-- Dropdown "Forró"
createMusicDropdown("Forró", {
    ["forro"] = {
        {name = "forró ja cansou", id = "74812784884330"},
        {name = "GRELO E O FE", id = "72200166265935"},
        {name = "lenbro ate hoje", id = "71531533552899"},
        {name = "escolha certa", id = "107088620814881"},
        {name = "forró da rezenha", id = "120973520531216"},
        {name = "forró dudu", id = "74404168179733"},
        {name = "forró sao joao", id = "106364874935196"},
        {name = "forró engraçado paia", id = "76524290482399"},
        {name = "100% forro vaquejada", id = "92295159623916"},
        
        {name = "PASTOR MIRIM E A LÍNGUA DOS ANJOS", id = "71153532555470"},
        {name = "PARA NÃO ESQUECER QUEM SOMOS", id = "88937498361674"},
        {name = "Uno zero", id = "112959083808887"},
        {name = "Iate do neymar", id = "135738534706063"},
        {name = "Batidao na aldeia", id = "79953696595578"},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Músicas e Memes Aleatório"
createMusicDropdown("Músicas e Memes Aleatório", {
    ["forro"] = {
        {name = "GTA ESTOURADO", id = "109337680029292"},
        {name = "ANXIETY (Amapiano Re-fix)", id = "101483901475189"}, 
        {name = "Meu corpo, minhas regras", id = "127587901595282"},
        {name = "$$$$gg$$$$gg", id = "137471775091253"},
        {name = "Megalovania but its only the melodies", id = "104500091160463"},
        {name = "androphono strikes back", id = "78312089943968"},
        {name = "Bamm Bamm", id = "128730685516895"},
        {name = "chupa cabra", id = "132890273173295"},
        {name = "longe de mais", id = "124478512057763"},
        {name = "Garoto de Copacabana", id = "135648634110254"},
        {name = "CELL!", id = "117634275895085"},
        {name = "Boa vibe em Ubatuba", id = "139059061493558"},
        {name = "SLIP AWAY", id = "126152928520174"},
        {name = "Alone in Motion", id = "122379348696948"},
        {name = "Fade Away", id = "81002139735874"},
        {name = "Wounds & Wishes", id = "109347979566607"},
        {name = "Ascensão do Monarca", id = "101864243033211"},
        {name = "carro do ovo", id = "3148329638"},
        {name = "ingles bus (fling ou kill bus)", id = "123268013026823"},
        {name = "MIKU MIKU HATSUNE", id = "112783541496955"},
        {name = "Five Nights at Freddy's", id = "110733765539890"},
        {name = "Rat Dance", id = "133496635668044"},
        {name = "Escalando a Seleção Brasileira para a Copa", id = "116546457407236"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Funk"
createMusicDropdown("Funk", {
    ["Funk"] = {
        {name = "Vovo ta casado", id = "103336395794625"},
        {name = "VAI TOMANDO BBZETE", id = "130003026488939"},
        {name = "PURO LANCA", id = "128441181589899"},
        {name = "chairy", id = "130071638363509"},
        {name = "happy nation", id = "98426978148475"},
        {name = "Funk maria", id = "77993212146053"},
        {name = "Baile de FVL", id = "123841648463956"},
        {name = "Seu Pedreiro", id = "116272171755349"},
        {name = "sua mulher funk", id = "90844637105538"},
        {name = "fuga na viatura", id = "131891110268352"},
        {name = "funkphonk fumando verde", id = "112143944982807"},
        {name = "cauma xmara", id = "95664293972405"},
        {name = "que que sharke", id = "129546408528391"},
        {name = "Il Cacto Hipopotamo FUNK", id = "104491656009142"},
        {name = "Espressora Signora FUNK", id = "123394392737234"},
        {name = "trippi troop funk", id = "73049389767013"},
        {name = "bombini funkphonk", id = "88814770244609"},
        {name = "pre treino", id = "136869502216760"},
        {name = "CVRL", id = "124244582950595"},
        {name = "batida Brega Violino (Beat Brega Funk)", id = "99399643204701"},
        {name = "Dança do Canguru (Pke Gaz1nh)", id = "86876136192157"},
        {name = "espere 30segundos!! Ondas sonoras", id = "127757321382838"},
        {name = "MONTAGEM ARABIANA (Pke Gaz1nh)", id = "78076624091098"},
        {name = "Manda o papo (NGI)", id = "132642647937688"},
        {name = "Viver bem", id = "82805460494325"},
        {name = "Faixa estronda", id = "121187736532042"},
        {name = "Ritmo Pixelado", id = "93928823862203"},
        {name = "Viagem Sonora", id = "79349174602261"},
        {name = "Melodia Virtual", id = "139147474886402"},
        {name = "Melodia Serena", id = "97011217688307"},
        {name = "SENTA", id = "124085422276732"},
        {name = "TUNG TUNG TUNG TUNG SAHUR PHONK BRASILEIRO", id = "120353876640055"},
        {name = "crazy-lol", id = "106958630419629"},
        {name = "V7", id = "80348640826643"},
        {name = "UIUAH", id = "82894376737849"},
        {name = "meta ritmo", id = "110091098283354"},
        {name = "CAPPUCCINO ASSASSINO (SPEDUP)", id = "132733033157915"},
        {name = "haha (NGI)", id = "122114766584918"},
        {name = "DO PO", id = "114207745067816"},
        {name = "Pantanal", id = "94880156546772"},
        {name = "Bonde do discord reupado speed up", id = "106285676892349"},
        {name = "lin na sua", id = "74497576726788"},
        {name = "montagem extreminadora", id = "83287654397479"},
        {name = "bruxaria carnificina", id = "133252379616732"},
        {name = "montagem verticional", id = "91374876039851"},
        {name = "OLHA O BARULHINHO da cama", id = "83097306124709"},
        {name = "RITMO BALANÇA UMBRELLA DJ Menor 7", id = "97039031206276"},
        {name = "Vou comer seu cu no Uno", id = "82284832948222"},
        {name = "Uma japoneisinha", id = "94117536327675"},
        {name = "Fode com os Raul Bigode", id = "97124592340288"},
        {name = "Piui TicTac MC RD", id = "139239312760455"},
        {name = "Azul piscina mc livinho", id = "80512054525157"},
        {name = "Hylander", id = "117315167016622"},
        {name = "Fedida do Baile", id = "84868297478150"},
        {name = "Soltero eu to suave", id = "75633080501124"},
        {name = "Roça nos amigo", id = "78247020542222"},
        {name = "Veneno de Serpiente", id = "130514800784318"},
        {name = "Acostumada com a bagunça, tudo Puta", id = "98004410614889"},
        {name = "Vapo Vapo Vukadão", id = "134122746249005"},
        {name = "Beat da Felicidade", id = "105332772352314"},
        {name = "Montagem Sirene das Trevas", id = "88903509281084"},
        {name = "Aqui é Diadema", id = "70879171320134"},
        {name = "Senta no Bugalu", id = "112504619203183"},
        {name = "Quem não baforo não tranza", id = "125154299082694"},
        {name = "Montagem mágica 2", id = "81733205826673"},
        {name = "Quando eu tomo o gin de 10", id = "140191183373449"},
        {name = "Ligou na madrugada mc anjim", id = "118906056296419"},
        {name = "Sobe balão, desce Bct", id = "110023885558332"},
        {name = "Seu ex, ta nervoso de mais", id = "92999059792601"},
        {name = "Eu aplico o chá", id = "86866545861125"},
        {name = "Essa porr de idiotex", id = "87718475791945"},
        {name = "MTG Apocalíptica do bolsonaro DJ K", id = "94729386479038"},
        {name = "vira mortal na proka", id = "85464353244509"},
        {name = "toma tapão mc niack", id = "128589691105865"},
        {name = "Montagem na onda DJ C4", id = "80488815553151"},
        {name = "2024 DJ GP Da ZL", id = "104805334951010"},
        {name = "Caveirão", id = "80004227292865"},
        {name = "Montagem Passa alccol em gel na mão DJ Patrick R", id = "74660644507056"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

-- Dropdown "Phonk"
createMusicDropdown("Phonk", {
    ["phonk"] = {
        {name = "wyles", id = "85385155970460"},
        {name = "phonk kawai", id = "91502410121438"},
        {name = "querendo da a bucet@", id = "72720721570850"},
        {name = "vem no pocpoc", id = "102333419023382"},
        {name = "tatiu wim", id = "122871512353520"},
        {name = "novinha sapeca", id = "111668097052966"},
        {name = "novinha representa", id = "93786060174790"},
        {name = "phonk1", id = "77501611905348"},
        {name = "phonk2", id = "126887144190812"},
        {name = "phonk osadia", id = "88033569921555"},
        {name = "phonk sarra", id = "132436320685732"},
        {name = "relaionamento sem crush", id = "105832154444494"},
        {name = "phonk3", id = "90323407842935"},
        {name = "novinha dançapanpa", id = "132245626038510"},
        {name = "phonk sexoagreçivo", id = "111995323199676"},
        {name = "phonk4", id = "115016589376700"},
        {name = "phonk5", id = "118740708757685"},
        {name = "phonk6", id = "139435437308948"},
        {name = "phonk chapaquente", id = "109189438638906"},
        {name = "phonk rajada", id = "105126065014034"},
        {name = "rede globo", id = "138487820505005"},
        {name = "phonk indiano", id = "87968531262747"},
        {name = "vapo do vapo", id = "106317184644394"},
        {name = "tutatatutata", id = "112068892721408"},
        {name = "phonk slower", id = "122852029094656"},
        {name = "phonk9", id = "91760524161503"},
        {name = "phonk10", id = "73140398421340"},
        {name = "phonk11", id = "137962454483542"},
        {name = "phonk12", id = "84733736048142"},
        {name = "phonk13", id = "106322173003761"},
        {name = "phonk14", id = "94604796823780"},
        {name = "phonk15", id = "118063577904953"},
        {name = "phonk16", id = "115567432786512"},
        {name = "phonk toq", id = "71304501822029"},
        {name = "phonk hey", id = "132218979961283"},
        {name = "phonk17", id = "102708912256857"},
        {name = "phonk18", id = "140642559093189"},
        {name = "phonk neve", id = "13530439660"},
        {name = "phonk19", id = "87863924786534"},
        {name = "phonk20", id = "133135085604736"},
        {name = "phonk lento", id = "97258811783169"},
        {name = "phonk21", id = "92308400487695"},
        {name = "tipo wym", id = "88064647826500"},
        {name = "estouradassa1", id = "92175624643620"},
        {name = "estouradassa2", id = "108099943758978"},
        {name = "Naaaaa", id = "109784877184952"},
        {name = "trem", id = "114608169341947"},
        {name = "eoropa", id = "111346133543699"},
        {name = "atimosphekika", id = "77857496821844"},
        {name = "phonk ALL THE TIME", id = "123809083385992"},
        {name = "Lifelong Memory", id = "81929101024622"},
        {name = "Automotivo Blondie (Pke Gaz1nh)", id = "74564219749776"},
        {name = "สวัสดีคนไทย v2", id =  "118225359190317"},
        {name = "MTG TU VAI SENTAR (Pke Gaz1nh)", id = "115317874112657"},
        {name = "SARRA FUNK", id = "96249826607044"},
        {name = "Catuquanvan", id = "88038595663211"},
        {name = "F-D-1 (slowed)", id = "124958445624871"},
        {name = "Sucessagem", id = "88551699463723"},
        {name = "ILOVE phonksla", id = "82148953715595"},
        {name = "SPEED SLIDE", id = "118959437310311"},
        {name = "TOMA FUNK PHONK", id = "126291069838831"},
        {name = "PASSO BEM SOLTO X NEW JAZZ", id = "122706595087279"},
        {name = "MONTAGEM BIONICA DIAMANTE", id = "122338822665007"},
        {name = "BALA SELVAGEM!", id = "96180057167470"},
        {name = "Luz <3", id = "74281337525581"},
        {name = "COMO TU", id = "86928685812280"},
        {name = "MONTAGEM SOLAR TROPICANO (SPEED UP)", id = "116461681407294"},
        {name = "MONTAGEM SOLAR TROPICANO (SLOWED)", id = "109308273341422"},
        {name = "YO DE TI", id = "125181345407169"},
        {name = "Beauty, (Phonk), Super sped up", id = "71123357599630"},
        {name = "MONTAGEM BOOMBOX DO MALA FUNK", id = "86537505028256"},
        {name = "BRAZIL DO FUNK", id = "133498554139200"},
        {name = "BRR BRR PATAPIM FUNK", id = "117170901476451"},
        {name = "MONTAGEM TERRA BELA FUNK", id = "134770548505933"},
        {name = "FUNK DO RAVE 1.0", id = "137135395010424"},
        
        {name = " Portao Funk", id = "70900514961735"},
        {name = " Espaço Funk", id = "110519906029322"},
        {name = " FUTABA", id = "91834632690710"},
        {name = " Melódica Explosão De Melodia", id = "98371771055411"},
        {name = " RASGO", id = "98267810117949"},
        {name = " HIPNOTIZA", id = "117668905142866"},
        {name = "CRISTAL NOTURNO", id = "103695219371872"},
        {name = " SKY HIGH", id = "123517126955383"},
        {name = "MIKU top", id = "102771149931910"},
        {name = " ACABU SO FUNK", id = "127870227978818"},
        {name = "CREATIFE FUNK", id = "130525387712209"},
        {name = "GOTH FUNK", id = "97662362226511"},
        {name = "PORTUGESE FUNK", id = "125858109122379"},
        {name = "SUBURBANA", id = "139825057894568"},
        {name = "ESPERA LA NOCHE FUNK", id = "139768056738146"},
        {name = "SIN PERMISO FUNK", id = "92572896648274"},
        {name = "MONTAGEM DACE RAT", id = "98711199754623"},
        {name = " LOVELY FUNK", id = "130633105268814"},
        {name = "STORYMODECOOL", id = "87115976125426"},
        {name = "BLACK COFFEE FUNK", id = "82705137378395"},
        {name = "KOBALT", id = "79381341943021"},
        {name = " andante bacterial", id = "105882833374061"},
        {name = "ANGEL Speed Up", id = "139593870988593"},
        {name = "LUTA ÉPICA", id = "73966367524216"},
        {name = "MALDITA", id = "133814632960968"},
        {name = "DA ZONA NTJ VERSON", id = "105770593501071"},
        {name = "HIPNOTIZA", id = "132015050363205"},
        {name = "MIDZUKI speed up", id = "129151948619922"},
        
        {name = "movimenta funk", id = "114994598691121"},
        {name = "CRISTAL", id = "103445348511856"},
        {name = "Letero funkphonk", id = "99409598156364"},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""},
        {name = "", id = ""}
    }
}, "Option 1")

Tab8:AddButton({
    Name = "Parar música",
    Description = "Parar a música atual",
    Callback = function()
        tocarMusica("")
    end
})




---------------------------------------------------------------------------------------------------------------------------------
                                                   -- ===  9: Troll === --
-----------------------------------------------------------------------------------------------------------------------------------
local vu358 = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
if vu358 then
    vu358 = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gu1n")
end
local vu359 = game:GetService("Players")
local vu360 = vu359.LocalPlayer
local vu361 = game:GetService("ReplicatedStorage")
local vu362 = game:GetService("VirtualInputManager")
local vu363 = game:GetService("RunService")
local vu364 = workspace.CurrentCamera
local vu365 = nil
getgenv().Target = nil
local vu366 = vu360.Character
local vu367
if vu366 then
    vu367 = vu366:WaitForChild("Humanoid")
else
    vu367 = vu366
end
local vu368
if vu366 then
    vu368 = vu366:WaitForChild("HumanoidRootPart")
else
    vu368 = vu366
end
local function vu371()
    local v369 = vu360.Character
    local v370 = v369 and (v369:FindFirstChild("Chaos.Couch") or vu360.Backpack:FindFirstChild("Chaos.Couch"))
    if v370 then
        v370:Destroy()
    end
    vu361:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
end
vu360.CharacterAdded:Connect(function(p372)
    vu366 = p372
    vu367 = p372:WaitForChild("Humanoid")
    vu368 = p372:WaitForChild("HumanoidRootPart")
    vu371()
    vu367.Died:Connect(function()
        vu371()
    end)
end)
if vu367 then
    vu367.Died:Connect(function()
        vu371()
    end)
end
Tab9:AddSection({
    Name = "Troll"
})
local vu380 = Tab9:AddDropdown({
    Name = "Selecionar jogador",
    Options = (function()
        local v373 = vu359:GetPlayers()
        local v374, v375, v376 = ipairs(v373)
        local v377 = {}
        while true do
            local v378
            v376, v378 = v374(v375, v376)
            if v376 == nil then
                break
            end
            if v378 ~= vu360 then
                table.insert(v377, v378.Name)
            end
        end
        return v377
    end)(),
    Default = "",
    Callback = function(p379)
        vu365 = p379
        getgenv().Target = p379
        print("  Não: " .. tostring(p379))
    end
})
Tab9:AddButton({
    Name = "Atualizar lista de jogadores",
    Callback = function()
        local v381 = vu359:GetPlayers()
        local v382 = {}
        if vu380 and # v381 > 0 then
            local v383, v384, v385 = ipairs(v381)
            while true do
                local v386
                v385, v386 = v383(v384, v385)
                if v385 == nil then
                    break
                end
                if v386.Name ~= vu360.Name then
                    table.insert(v382, v386.Name)
                end
            end
            vu380:Set(v382)
            print("Lista de jogadores atualizada: ", table.concat(v382, ", "))
            if vu365 and not vu359:FindFirstChild(vu365) then
                vu365 = nil
                getgenv().Target = nil
                vu380:SetValue("...")
                print("Sele\195\167\195\163o resetada, jogador n\195\163o est\195\161 mais no servidor.")
            end
        else
            print("Erro: Dropdown n\195\163o encontrado ou nenhum jogador dispon\195\173vel.")
        end
    end
})
Tab9:AddButton({
    Name = "Teleportar até o jogador",
    Callback = function()
        if vu365 and vu359:FindFirstChild(vu365) then
            local v387 = vu360.Character
            if v387 then
                v387 = v387:FindFirstChild("HumanoidRootPart")
            end
            if v387 then
                local v388 = vu359:FindFirstChild(vu365)
                if v388 and v388.Character and v388.Character:FindFirstChild("HumanoidRootPart") then
                    v387.CFrame = v388.Character.HumanoidRootPart.CFrame
                else
                    print("Erro: Player alvo n\195\163o encontrado ou sem HumanoidRootPart")
                end
            else
                warn("Erro: HumanoidRootPart do jogador local n\195\163o encontrado")
            end
        else
            print("Erro: Player n\195\163o selecionado ou n\195\163o existe")
            return
        end
    end
})
Tab9:AddToggle({
    Name = "Seguir câmera do jogador",
    Default = false,
    Callback = function(pu389)
        local vu390 = workspace.CurrentCamera
        local function v394()
            if pu389 then
                local v391 = vu359:FindFirstChild(vu365)
                local v392 = v391 and v391.Character and v391.Character:FindFirstChild("Humanoid")
                if v392 then
                    vu390.CameraSubject = v392
                end
            else
                local v393 = vu360.Character and vu360.Character:FindFirstChild("Humanoid")
                if v393 then
                    vu390.CameraSubject = v393
                end
            end
        end
        if pu389 then
            if not getgenv().CameraConnection then
                getgenv().CameraConnection = vu363.Heartbeat:Connect(v394)
            end
        else
            if getgenv().CameraConnection then
                getgenv().CameraConnection:Disconnect()
                getgenv().CameraConnection = nil
            end
            v394()
        end
    end
})
Tab9:AddSection({
    Name = "Veículos"
})
Tab9:AddButton({
    Name = "Eliminar jogador com veículo",
    Callback = function()
        if vu365 then
            local vu395 = vu359:FindFirstChild(vu365)
            if vu395 and vu395.Character then
                local vu396 = vu360.Character
                if vu396 then
                    local vu397 = vu396:FindFirstChildOfClass("Humanoid")
                    local vu398 = vu396:FindFirstChild("HumanoidRootPart")
                    local v399 = vu395.Character
                    if v399 then
                        v399 = vu395.Character:FindFirstChild("HumanoidRootPart")
                    end
                    if vu397 and (vu398 and v399) then
                        local vu400 = vu398.Position
                        local vu401 = Vector3.new(145.51, - 350.09, 21.58)
                        vu361:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
                        task.wait(0.2)
                        vu361.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                        task.wait(0.3)
                        local v402 = vu360.Backpack:FindFirstChild("Couch")
                        if v402 then
                            v402.Parent = vu396
                        end
                        task.wait(0.1)
                        vu362:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.1)
                        vu397:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
                        vu397.PlatformStand = false
                        vu364.CameraSubject = vu395.Character:FindFirstChild("Head") or (v399 or vu397)
                        local vu403 = Instance.new("BodyPosition")
                        vu403.Name = "BringPosition"
                        vu403.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        vu403.D = 10
                        vu403.P = 30000
                        vu403.Position = vu398.Position
                        vu403.Parent = v399
                        task.spawn(function()
                            local v404 = tick()
                            local v405 = 0
                            while tick() - v404 < 5 and (vu395 and vu395.Character) and vu395.Character:FindFirstChildOfClass("Humanoid") do
                                local v406 = vu395.Character:FindFirstChildOfClass("Humanoid")
                                if not v406 or v406.Sit then
                                    break
                                end
                                local v407 = vu395.Character.HumanoidRootPart
                                local v408 = v407.Position + v407.Velocity / 1.5
                                v405 = v405 + 50
                                vu398.CFrame = CFrame.new(v408 + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(v405), 0, 0)
                                vu403.Position = vu398.Position + Vector3.new(2, 0, 0)
                                task.wait()
                            end
                            vu403:Destroy()
                            vu397:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                            vu397.PlatformStand = false
                            vu364.CameraSubject = vu397
                            local v409 = vu396
                            local v410, v411, v412 = pairs(v409:GetDescendants())
                            while true do
                                local v413
                                v412, v413 = v410(v411, v412)
                                if v412 == nil then
                                    break
                                end
                                if v413:IsA("BasePart") then
                                    v413.Velocity = Vector3.zero
                                    v413.RotVelocity = Vector3.zero
                                end
                            end
                            task.wait(0.1)
                            vu398.CFrame = CFrame.new(vu401)
                            task.wait(0.3)
                            local v414 = vu396:FindFirstChild("Couch")
                            if v414 then
                                v414.Parent = vu360.Backpack
                            end
                            task.wait(0.01)
                            vu361.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                            task.wait(0.2)
                            vu398.CFrame = CFrame.new(vu400)
                        end)
                    else
                        warn("Erro: Componentes necess\195\161rios n\195\163o encontrados")
                    end
                else
                    warn("Erro: Personagem do jogador local n\195\163o encontrado")
                    return
                end
            else
                warn("Erro: Jogador alvo n\195\163o encontrado ou sem personagem")
                return
            end
        else
            warn("Erro: Nenhum jogador selecionado")
            return
        end
    end
})
Tab9:AddButton({
    Name = "Trazer jogador até você",
    Callback = function()
        if vu365 then
            local vu415 = vu359:FindFirstChild(vu365)
            if vu415 and vu415.Character then
                local vu416 = vu360.Character
                if vu416 then
                    local vu417 = vu416:FindFirstChildOfClass("Humanoid")
                    local vu418 = vu416:FindFirstChild("HumanoidRootPart")
                    local v419 = vu415.Character
                    if v419 then
                        v419 = vu415.Character:FindFirstChild("HumanoidRootPart")
                    end
                    if vu417 and (vu418 and v419) then
                        local vu420 = vu418.Position
                        vu361:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
                        task.wait(0.2)
                        vu361.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                        task.wait(0.3)
                        local v421 = vu360.Backpack:FindFirstChild("Couch")
                        if v421 then
                            v421.Parent = vu416
                        end
                        task.wait(0.1)
                        vu362:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.1)
                        vu417:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
                        vu417.PlatformStand = false
                        vu364.CameraSubject = vu415.Character:FindFirstChild("Head") or (v419 or vu417)
                        local vu422 = Instance.new("BodyPosition")
                        vu422.Name = "BringPosition"
                        vu422.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        vu422.D = 10
                        vu422.P = 30000
                        vu422.Position = vu418.Position
                        vu422.Parent = v419
                        task.spawn(function()
                            local v423 = tick()
                            local v424 = 0
                            while tick() - v423 < 5 and (vu415 and vu415.Character) and vu415.Character:FindFirstChildOfClass("Humanoid") do
                                local v425 = vu415.Character:FindFirstChildOfClass("Humanoid")
                                if not v425 or v425.Sit then
                                    break
                                end
                                local v426 = vu415.Character.HumanoidRootPart
                                local v427 = v426.Position + v426.Velocity / 1.5
                                v424 = v424 + 50
                                vu418.CFrame = CFrame.new(v427 + Vector3.new(0, 2, 0)) * CFrame.Angles(math.rad(v424), 0, 0)
                                vu422.Position = vu418.Position + Vector3.new(2, 0, 0)
                                task.wait()
                            end
                            vu422:Destroy()
                            vu417:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                            vu417.PlatformStand = false
                            vu364.CameraSubject = vu417
                            local v428 = vu416
                            local v429, v430, v431 = pairs(v428:GetDescendants())
                            while true do
                                local v432
                                v431, v432 = v429(v430, v431)
                                if v431 == nil then
                                    break
                                end
                                if v432:IsA("BasePart") then
                                    v432.Velocity = Vector3.zero
                                    v432.RotVelocity = Vector3.zero
                                end
                            end
                            task.wait(0.1)
                            vu418.Anchored = true
                            vu418.CFrame = CFrame.new(vu420)
                            task.wait(0.001)
                            vu418.Anchored = false
                            task.wait(0.7)
                            local v433 = vu416:FindFirstChild("Couch")
                            if v433 then
                                v433.Parent = vu360.Backpack
                            end
                            task.wait(0.001)
                            vu361.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                        end)
                    else
                        warn("Erro: Componentes necess\195\161rios n\195\163o encontrados")
                    end
                else
                    warn("Erro: Personagem do jogador local n\195\163o encontrado")
                    return
                end
            else
                warn("Erro: Jogador alvo n\195\163o encontrado ou sem personagem")
                return
            end
        else
            warn("Erro: Nenhum jogador selecionado")
            return
        end
    end
})
Tab9:AddSection({
    Name = "Sofá sem ir até o alvo"
})
Tab9:AddButton({
    Name = "Eliminar com sofá",
    Callback = function()
        local v434 = vu359:FindFirstChild(getgenv().Target)
        if not v434 then
            warn("Erro: Nenhum jogador alvo selecionado")
            return
        end
        if not (v434.Character and v434.Character:FindFirstChild("HumanoidRootPart")) then
            warn("Erro: Jogador alvo sem personagem ou HumanoidRootPart")
            return
        end
        vu361.RE["1Clea1rTool1s"]:FireServer(unpack({
            "ClearAllTools"
        }))
        vu361.RE:FindFirstChild("1Too1l"):InvokeServer(unpack({
            "PickingTools",
            "Couch"
        }))
        local v435 = vu360.Backpack:WaitForChild("Couch", 2)
        if not v435 then
            warn("Erro: Sof\195\161 n\195\163o encontrado no Backpack")
            return
        end
        v435.Name = "Chaos.Couch"
        local v436 = v435:FindFirstChild("Seat1")
        local v437 = v435:FindFirstChild("Seat2")
        local v438 = v435:FindFirstChild("Handle")
        if not (v436 and (v437 and v438)) then
            warn("Erro: Componentes do sof\195\161 n\195\163o encontrados")
            return
        end
        v436.Desativado = true
        v437.Desativado = true
        v438.Name = "Handle "
        v435.Parent = vu360.Character
        local v439 = Instance.new("BodyVelocity", v436)
        v439.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v439.P = 1250
        v439.Velocity = Vector3.new(0, 0, 0)
        v439.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        while true do
            for _ = 1, 35 do
                local v440 = {
                    x = 0,
                    y = 0,
                    z = 0
                }
                local v441 = v434.Character
                if v441 then
                    v441 = v434.Character.HumanoidRootPart
                end
                if not v441 then
                end
                v440.x = v441.Position.X + v441.Velocity.X / 2
                v440.y = v441.Position.Y + v441.Velocity.Y / 2
                v440.z = v441.Position.Z + v441.Velocity.Z / 2
                v436.CFrame = CFrame.new(Vector3.new(v440.x, v440.y, v440.z)) * CFrame.new(- 2, 2, 0)
                task.wait()
            end
            v439:Destroy()
            v435.Parent = vu360.Backpack
            task.wait()
            v435:FindFirstChild("Handle ").Name = "Handle"
            task.wait(0.2)
            v435.Parent = vu360.Character
            task.wait()
            v435.Parent = vu360.Backpack
            v435.Handle.Name = "Handle "
            task.wait(0.2)
            v435.Parent = vu360.Character
            v439 = Instance.new("BodyVelocity", v436)
            v439.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            v439.P = 1250
            v439.Velocity = Vector3.new(0, 0, 0)
            v439.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
            if v434.Character and (v434.Character.Humanoid and v434.Character.Humanoid.Sit == true) then
                task.wait()
                v435.Parent = vu360.Backpack
                v436.CFrame = CFrame.new(Vector3.new(9999, - 450, 9999))
                v437.CFrame = CFrame.new(Vector3.new(9999, - 450, 9999))
                v435.Parent = vu360.Character
                task.wait(0.1)
                v435.Parent = vu360.Backpack
                task.wait(2)
                local v442 = v436:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W")
                if v442 then
                    v442:Destroy()
                end
                vu361.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
                return
            end
        end
    end
})
Tab9:AddButton({
    Name = "Fling com sofá",
    Callback = function()
        local v443 = vu359:FindFirstChild(getgenv().Target)
        if not v443 then
            warn("Erro: Nenhum jogador alvo selecionado")
            return
        end
        if not (v443.Character and v443.Character:FindFirstChild("HumanoidRootPart")) then
            warn("Erro: Jogador alvo sem personagem ou HumanoidRootPart")
            return
        end
        vu361.RE["1Clea1rTool1s"]:FireServer(unpack({
            "ClearAllTools"
        }))
        vu361.RE:FindFirstChild("1Too1l"):InvokeServer(unpack({
            "PickingTools",
            "Couch"
        }))
        local v444 = vu360.Backpack:WaitForChild("Couch", 2)
        if not v444 then
            warn("Erro: Sof\195\161 n\195\163o encontrado no Backpack")
            return
        end
        v444.Name = "Chaos.Couch"
        local v445 = v444:FindFirstChild("Seat1")
        local v446 = v444:FindFirstChild("Seat2")
        local v447 = v444:FindFirstChild("Handle")
        if not (v445 and (v446 and v447)) then
            warn("Erro: Componentes do sof\195\161 n\195\163o encontrados")
            return
        end
        v445.Desativado = true
        v446.Desativado = true
        v447.Name = "Handle "
        v444.Parent = vu360.Character
        local v448 = Instance.new("BodyVelocity", v445)
        v448.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        v448.P = 1250
        v448.Velocity = Vector3.new(0, 0, 0)
        v448.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        while true do
            for _ = 1, 35 do
                local v449 = {
                    x = 0,
                    y = 0,
                    z = 0
                }
                local v450 = v443.Character
                if v450 then
                    v450 = v443.Character.HumanoidRootPart
                end
                if not v450 then
                end
                v449.x = v450.Position.X + v450.Velocity.X / 2
                v449.y = v450.Position.Y + v450.Velocity.Y / 2
                v449.z = v450.Position.Z + v450.Velocity.Z / 2
                v445.CFrame = CFrame.new(Vector3.new(v449.x, v449.y, v449.z)) * CFrame.new(- 2, 2, 0)
                task.wait()
            end
            v448:Destroy()
            v444.Parent = vu360.Backpack
            task.wait()
            v444:FindFirstChild("Handle ").Name = "Handle"
            task.wait(0.2)
            v444.Parent = vu360.Character
            task.wait()
            v444.Parent = vu360.Backpack
            v444.Handle.Name = "Handle "
            task.wait(0.2)
            v444.Parent = vu360.Character
            v448 = Instance.new("BodyVelocity", v445)
            v448.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            v448.P = 1250
            v448.Velocity = Vector3.new(0, 0, 0)
            v448.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
            if v443.Character and (v443.Character.Humanoid and v443.Character.Humanoid.Sit == true) then
                task.wait()
                v448:Destroy()
                v444.Parent = vu360.Backpack
                task.wait()
                v444:FindFirstChild("Handle ").Name = "Handle"
                task.wait(0.3)
                v444.Parent = vu360.Character
                task.wait(0.3)
                v444.Grip = CFrame.new(Vector3.new(0, 0, 0))
                task.wait(0.3)
                vu361.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
                return
            end
        end
    end
})
Tab9:AddSection({
    Name = "Fling com veículo"
})
Tab9:AddButton({
    Name = "Eliminar com veículo",
    Callback = function()
        local vu451 = vu360.Character
        local vu452
        if vu451 then
            vu452 = vu451:FindFirstChild("HumanoidRootPart")
        else
            vu452 = vu451
        end
        if vu452 then
            local vu453 = vu452.CFrame
            local function v455()
                local v454 = game.Workspace:FindFirstChild("Vehicles")
                if v454 then
                    return v454:FindFirstChild(vu360.Name .. "Car")
                else
                    return nil
                end
            end
            local vu456 = v455()
            if not vu456 then
                vu452.CFrame = CFrame.new(1118.81, 75.998, - 1138.61)
                task.wait(0.5)
                local v457 = vu361:FindFirstChild("RE")
                if v457 and v457:FindFirstChild("1Ca1r") then
                    v457["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
                end
                task.wait(1)
                vu456 = v455()
            end
            if vu456 then
                local v458 = vu456:FindFirstChild("Body")
                if v458 then
                    v458 = vu456.Body:FindFirstChild("VehicleSeat")
                end
                if v458 and (vu451:FindFirstChildOfClass("Humanoid") and not vu451.Humanoid.Sit) then
                    repeat
                        vu452.CFrame = v458.CFrame * CFrame.new(0, 2, 0)
                        task.wait()
                    until vu451.Humanoid.Sit or not vu456.Parent
                    if vu451.Humanoid.Sit or not vu456.Parent then
                        local v459, v460, v461 = pairs(vu456.Body:GetChildren())
                        while true do
                            local v462
                            v461, v462 = v459(v460, v461)
                            if v461 == nil then
                                break
                            end
                            if v462:IsA("Seat") then
                                v462.CanTouch = true
                            end
                        end
                    end
                end
            end
            local function v470()
                while true do
                    if vu365 then
                        local v463 = vu359:FindFirstChild(vu365)
                        if v463 and v463.Character and v463.Character:FindFirstChild("HumanoidRootPart") then
                            local v464 = v463.Character:FindFirstChildOfClass("Humanoid")
                            if v464 and v464.Sit then
                                if vu451.Humanoid then
                                    vu456:SetPrimaryPartCFrame(CFrame.new(Vector3.new(9999, - 450, 9999)))
                                    print("Jogador sentou, levando \195\180nibus para o void!")
                                    task.wait(0.2);
                                    (function()
                                        local v465 = vu451
                                        if v465 then
                                            v465 = vu451:FindFirstChildWhichIsA("Humanoid")
                                        end
                                        if v465 then
                                            v465:ChangeState(Enum.HumanoidStateType.Jumping)
                                        end
                                    end)()
                                    print("Simulando pulo!")
                                    task.wait(0.5)
                                    vu452.CFrame = vu453
                                    print("Player voltou para a posi\195\167\195\163o inicial.")
                                end
                                return
                            end
                            local v466 = v463.Character.HumanoidRootPart
                            local v467 = tick() * 35
                            local v468 = math.sin(v467) * 4
                            local v469 = math.cos(v467) * 20
                            vu456:SetPrimaryPartCFrame(v466.CFrame * CFrame.new(v468, 0, v469))
                        end
                    end
                    vu363.RenderStepped:Wait()
                end
            end
            spawn(v470)
        else
            warn("Erro: HumanoidRootPart do jogador local n\195\163o encontrado")
        end
    end
})
Tab9:AddButton({
    Name = "Fling com carro",
    Callback = function()
        local vu471 = vu360.Character
        local v472
        if vu471 then
            v472 = vu471:FindFirstChild("HumanoidRootPart")
        else
            v472 = vu471
        end
        if v472 then
            local vu473 = v472.CFrame
            local function v475()
                local v474 = game.Workspace:FindFirstChild("Vehicles")
                if v474 then
                    return v474:FindFirstChild(vu360.Name .. "Car")
                else
                    return nil
                end
            end
            local vu476 = v475()
            if not vu476 then
                v472.CFrame = CFrame.new(1118.81, 75.998, - 1138.61)
                task.wait(0.5)
                local v477 = vu361:FindFirstChild("RE")
                if v477 and v477:FindFirstChild("1Ca1r") then
                    v477["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
                end
                task.wait(1)
                vu476 = v475()
            end
            if vu476 then
                local v478 = vu476:FindFirstChild("Body")
                if v478 then
                    v478 = vu476.Body:FindFirstChild("VehicleSeat")
                end
                if v478 and (vu471:FindFirstChildOfClass("Humanoid") and not vu471.Humanoid.Sit) then
                    repeat
                        v472.CFrame = v478.CFrame * CFrame.new(0, 2, 0)
                        task.wait()
                    until vu471.Humanoid.Sit or not vu476.Parent
                end
            end
            local function v485()
                while true do
                    if vu365 then
                        local v479 = vu359:FindFirstChild(vu365)
                        if v479 and v479.Character and v479.Character:FindFirstChild("HumanoidRootPart") then
                            local v480 = v479.Character:FindFirstChildOfClass("Humanoid")
                            if v480 and v480.Sit then
                                if vu471.Humanoid then
                                    vu476:SetPrimaryPartCFrame(vu473)
                                    task.wait(0.7)
                                    vu361.RE:FindFirstChild("1Ca1r"):FireServer(unpack({
                                        "DeleteAllVehicles"
                                    }))
                                end
                                return
                            end
                            local v481 = v479.Character.HumanoidRootPart
                            local v482 = tick() * 35
                            local v483 = math.sin(v482) * 4
                            local v484 = math.cos(v482) * 20
                            vu476:SetPrimaryPartCFrame(v481.CFrame * CFrame.new(v483, 0, v484))
                        end
                    end
                    vu363.RenderStepped:Wait()
                end
            end
            spawn(v485)
        else
            warn("Erro: HumanoidRootPart do jogador local n\195\163o encontrado")
        end
    end
})
Tab9:AddButton({
    Name = "Fling com veículo para todos",
    Callback = function()
        local vu486 = game:GetService("Players")
        local vu487 = game:GetService("Workspace")
        local vu488 = game:GetService("RunService")
        local vu489 = game:GetService("ReplicatedStorage")
        local vu490 = Vector3.new(145.51, - 374.09, 21.58)
        local vu491 = nil
        local function vu493()
            local v492 = vu487:FindFirstChild("Vehicles")
            if v492 then
                return v492:FindFirstChild(vu486.LocalPlayer.Name .. "Car")
            else
                return nil
            end
        end
        local function vu505(p494, p495)
            while true do
                if p494 then
                    local v496 = vu486:FindFirstChild(p494)
                    if v496 and v496.Character and v496.Character:FindFirstChild("HumanoidRootPart") then
                        local v497 = v496.Character:FindFirstChildOfClass("Humanoid")
                        if v497 and v497.Sit then
                            local v498 = vu493()
                            if v498 then
                                v498:SetPrimaryPartCFrame(CFrame.new(vu490))
                                print("Jogador sentou, levando \195\180nibus para o void!")
                                task.wait(0.2)
                                local function v500()
                                    local v499 = vu486.LocalPlayer.Character
                                    if v499 then
                                        v499 = vu486.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                                    end
                                    if v499 then
                                        v499:ChangeState(Enum.HumanoidStateType.Jumping)
                                    end
                                end
                                v500()
                                print("Simulando primeiro pulo!")
                                task.wait(0.4)
                                v500()
                                print("Simulando segundo pulo!")
                                task.wait(0.5)
                                if vu491 then
                                    vu486.LocalPlayer.Character.HumanoidRootPart.CFrame = vu491
                                    print("Player voltou para a posi\195\167\195\163o inicial Xique")
                                    task.wait(0.1)
                                    vu489:WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack({
                                        "DeleteAllVehicles"
                                    }))
                                    print("Todos os ve\195\173culos foram deletados!")
                                end
                            end
                            if p495 then
                                p495()
                            end
                            return
                        end
                        local v501 = v496.Character.HumanoidRootPart
                        local v502 = tick() * 35
                        local _ = math.sin(v502) * 10
                        local v503 = math.cos(v502) * 20
                        local v504 = vu493()
                        if v504 then
                            v504:SetPrimaryPartCFrame(v501.CFrame * CFrame.new(0, 0, v503))
                        end
                    end
                end
                vu488.RenderStepped:Wait()
            end
        end
        local function vu515(p506, pu507)
            local vu508 = p506
            local v509 = vu486.LocalPlayer
            local v510 = v509.Character or v509.CharacterAdded:Wait()
            local v511 = v510:WaitForChild("HumanoidRootPart")
            vu491 = v511.CFrame
            local v512 = vu493()
            if not v512 then
                v511.CFrame = CFrame.new(1118.81, 75.998, - 1138.61)
                task.wait(0.5)
                local v513 = vu489:FindFirstChild("RE")
                if v513 and v513:FindFirstChild("1Ca1r") then
                    v513["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
                end
                task.wait(1)
                v512 = vu493()
            end
            if v512 then
                local v514 = v512:FindFirstChild("Body")
                if v514 then
                    v514 = v512.Body:FindFirstChild("VehicleSeat")
                end
                if v514 and (v510:FindFirstChildOfClass("Humanoid") and not v510.Humanoid.Sit) then
                    repeat
                        v511.CFrame = v514.CFrame * CFrame.new(0, 2, 0)
                        task.wait()
                    until v510.Humanoid.Sit or not v512.Parent
                end
            end
            spawn(function()
                vu505(vu508, pu507)
            end)
        end
        local function vu517(pu516)
            if # pu516 ~= 0 then
                vu515(table.remove(pu516, 1).Name, function()
                    task.wait(0.5)
                    vu517(pu516)
                end)
            end
        end
        local v518 = vu486
        vu517(vu486.GetPlayers(v518))
    end
})
Tab9:AddSection({
    Name = "Canoa"
})
Tab9:AddButton({
    Name = "Fling com canoa",
    Callback = function()
        local v724 = getgenv().Target
        if v724 then
            local v725 = game.Players:FindFirstChild(v724)
            if v725 then
                local v726 = game.Players.LocalPlayer
                local vu727 = v726.Character or v726.CharacterAdded:Wait()
                local vu728 = vu727:WaitForChild("Humanoid")
                local vu729 = vu727:WaitForChild("HumanoidRootPart")
                if vu728.Sit then
                    vu728.Sit = false
                    task.wait(0.5)
                end
                vu729.CFrame = workspace.WorkspaceCom["001_CanoeCloneButton"].Button.CFrame
                task.wait(0.4)
                fireclickdetector(workspace.WorkspaceCom["001_CanoeCloneButton"].Button.ClickDetector, 0)
                task.wait(0.4)
                local vu730 = workspace.WorkspaceCom["001_CanoeStorage"].Canoe
                local vu731 = vu730:FindFirstChild("VehicleSeat")
                local v732
                if vu730.PrimaryPart then
                    v732 = 0
                else
                    vu730.PrimaryPart = vu731
                    v732 = 0
                end
                repeat
                    vu727:MoveTo(vu731.Position + Vector3.new(0, 3.5, 0))
                    task.wait(0.01)
                    vu731:Sit(vu728)
                    v732 = v732 + 1
                until vu728.Sit or 100 < v732
                if vu728.Sit then
                    local vu733 = v725.Character or v725.CharacterAdded:Wait()
                    local v734 = vu733
                    local vu735 = vu733.WaitForChild(v734, "HumanoidRootPart")
                    local v736 = vu733
                    local vu737 = vu733.WaitForChild(v736, "Humanoid")
                    local vu738 = Instance.new("BodyForce", vu730.PrimaryPart)
                    local vu739 = Instance.new("BodyAngularVelocity", vu730.PrimaryPart)
                    vu739.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    vu739.AngularVelocity = Vector3.new(5000, 25000, 5000)
                    vu739.P = 1000000000
                    local v740 = game:GetService("RunService")
                    local vu741 = true
                    local vu742 = 0
                    local vu743 = 5
                    local vu744 = 20
                    local vu745 = 10
                    local vu746 = 8
                    local vu747 = 50
                    local vu748 = nil
                    vu748 = v740.Heartbeat:Connect(function(p749)
                        if vu741 and (vu728.Sit and (vu733 and (vu737 and vu737.Health > 0))) then
                            vu742 = vu742 + p749
                            if vu737.SeatPart then
                                local v750 = CFrame.new(0, - 12000, 0)
                                for _ = 1, 30 do
                                    vu730:SetPrimaryPartCFrame(v750)
                                    vu727:SetPrimaryPartCFrame(v750)
                                    vu733:SetPrimaryPartCFrame(v750)
                                    task.wait()
                                end
                                if vu731 then
                                    vu731.Throttle = 0
                                    vu731.Steer = 0
                                end
                                if vu730:FindFirstChild("BodyVelocity") then
                                    vu730.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                                end
                                if vu730:FindFirstChild("BodyAngularVelocity") then
                                    vu730.BodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
                                end
                                if vu729.Position.Y < - 1000 then
                                    vu728.Sit = false
                                    task.wait(0.2)
                                    vu729.CFrame = CFrame.new(1118.81, 75.998, - 1138.61)
                                    task.wait(0.2)
                                    pcall(function()
                                        if vu730 and vu730.Parent then
                                            vu730:Destroy()
                                        end
                                    end)
                                end
                                vu741 = false
                                vu748:Disconnect()
                                vu739:Destroy()
                                vu738:Destroy()
                            else
                                local v751 = vu743 + math.sin(vu742 * 10) * (vu744 - vu743) / 2
                                local v752 = vu747 * vu742
                                local v753 = math.cos(v752) * v751
                                local v754 = math.sin(v752) * v751
                                local v755 = vu735.CFrame.LookVector * math.sin(vu742 * vu746) * vu745
                                local v756 = vu735.Position + Vector3.new(v753, 5, v754) + v755
                                vu730:SetPrimaryPartCFrame(CFrame.new(v756, vu735.Position))
                                vu738.Force = (vu735.Position - vu730.PrimaryPart.Position).Unit * 1000000 + Vector3.new(0, workspace.Gravity * vu730.PrimaryPart:GetMass(), 0)
                            end
                        else
                            vu748:Disconnect()
                            vu739:Destroy()
                            vu738:Destroy()
                            return
                        end
                    end)
                else
                    warn("Falhou em sentar no barco.")
                end
            else
                warn("Jogador n\195\163o encontrado.")
                return
            end
        else
            warn("Nenhum jogador definido.")
            return
        end
    end
})
Tab9:AddSection({
    Name = "Fling automático"
})
Tab9:AddToggle({
    Name = "Fling automático no alvo",
    Default = false,
    Callback = function(p765)
        if vu764 then
            vu764 = false
        elseif p765 then
            if not (vu365 and game.Players:FindFirstChild(vu365)) then
                warn("Nenhum jogador selecionado ou n\195\163o existe")
                return
            end
            local vu766 = game.Players.LocalPlayer
            local vu767 = vu766.Character
            local v768
            if vu767 then
                v768 = vu767:FindFirstChildOfClass("Humanoid")
            else
                v768 = vu767
            end
            if vu767 then
                vu767 = vu767:FindFirstChild("HumanoidRootPart")
            end
            local vu769 = game.Workspace:FindFirstChild("Vehicles")
            if not (v768 and vu767) then
                warn("Humanoid ou RootPart inv\195\161lido")
                return
            end
            local vu770 = vu769:FindFirstChild(vu766.Name .. "Car") or (function()
                vu767.CFrame = CFrame.new(1754, - 2, 58)
                task.wait(0.5)
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
                task.wait(1)
                return vu769:FindFirstChild(vu766.Name .. "Car")
            end)()
            if not vu770 then
                warn("Falha ao spawnar o barco")
                return
            end
            local v771 = vu770:FindFirstChild("Body")
            if v771 then
                v771 = vu770.Body:FindFirstChild("VehicleSeat")
            end
            if not v771 then
                warn("Assento n\195\163o encontrado")
                return
            end
            repeat
                task.wait(0.1)
                vu767.CFrame = v771.CFrame * CFrame.new(0, 1, 0)
            until v768.SeatPart == v771
            print("Barco spawnado!")
            local v772 = game.Players:FindFirstChild(vu365)
            if not (v772 and v772.Character) then
                warn("Jogador n\195\163o encontrado")
                return
            end
            local v773 = v772.Character
            local v774 = v773:FindFirstChildOfClass("Humanoid")
            local vu775 = v773:FindFirstChild("HumanoidRootPart")
            if not (vu775 and v774) then
                warn("Humanoid ou RootPart do alvo n\195\163o encontrado")
                return
            end
            local vu776 = Instance.new("BodyAngularVelocity")
            vu776.Name = "Spinning"
            vu776.Parent = vu770.PrimaryPart
            vu776.MaxTorque = Vector3.new(0, math.huge, 0)
            vu776.AngularVelocity = Vector3.new(0, 369, 0)
            print("Fling ativado!")
            local function vu779(p777, p778)
                if vu770 and vu770.PrimaryPart then
                    vu770:SetPrimaryPartCFrame(CFrame.new(p777.Position + p778))
                end
            end
            task.spawn(function()
                while vu770 and (vu770.Parent and (vu775 and vu775.Parent)) do
                    task.wait(0.01)
                    vu779(vu775, Vector3.new(0, 1, 0))
                    vu779(vu775, Vector3.new(0, - 2.25, 5))
                    vu779(vu775, Vector3.new(0, 2.25, 0.25))
                    vu779(vu775, Vector3.new(- 2.25, - 1.5, 2.25))
                    vu779(vu775, Vector3.new(0, 1.5, 0))
                    vu779(vu775, Vector3.new(0, - 1.5, 0))
                    if vu770 and vu770.PrimaryPart then
                        local v780 = CFrame.Angles(math.rad(math.random(- 369, 369)), math.rad(math.random(- 369, 369)), math.rad(math.random(- 369, 369)))
                        vu770:SetPrimaryPartCFrame(CFrame.new(vu775.Position + Vector3.new(0, 1.5, 0)) * v780)
                    end
                end
                if vu776 and vu776.Parent then
                    vu776:Destroy()
                    print("Fling desativado")
                end
            end)
        else
            local v781 = game.Players.LocalPlayer
            local v782 = v781.Character
            local v783
            if v782 then
                v783 = v782:FindFirstChild("HumanoidRootPart")
            else
                v783 = v782
            end
            if v782 then
                v782 = v782:FindFirstChildOfClass("Humanoid")
            end
            local v784 = game.Workspace:FindFirstChild("Vehicles")
            if not (v783 and v782) then
                warn("Nenhum RootPart ou Humanoid encontrado!")
                return
            end
            v782.PlatformStand = true
            print("Jogador paralisado para reduzir efeitos do spin.")
            local v785, v786, v787 = pairs(v783:GetChildren())
            while true do
                local v788
                v787, v788 = v785(v786, v787)
                if v787 == nil then
                    break
                end
                if v788:IsA("BodyAngularVelocity") or v788:IsA("BodyVelocity") then
                    v788:Destroy()
                end
            end
            print("Spin e for\195\167as removidas do jogador.")
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("DeleteAllVehicles")
            task.wait(0.5)
            if v784 then
                v784 = v784:FindFirstChild(v781.Name .. "Car")
            end
            if v784 and v784.PrimaryPart then
                local v789, v790, v791 = pairs(v784.PrimaryPart:GetChildren())
                while true do
                    local v792
                    v791, v792 = v789(v790, v791)
                    if v791 == nil then
                        break
                    end
                    if v792:IsA("BodyAngularVelocity") or v792:IsA("BodyVelocity") then
                        v792:Destroy()
                    end
                end
                print("Spin removido do barco.")
            end
            task.wait(1)
            local v793 = Vector3.new(0, 1000, 0)
            local v794 = Instance.new("BodyPosition", v783)
            v794.Position = v793
            v794.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local v795 = Instance.new("BodyGyro", v783)
            v795.CFrame = v783.CFrame
            v795.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            print("Jogador est\195\161 preso na coordenada segura.")
            task.wait(3)
            v794:Destroy()
            v795:Destroy()
            v782.PlatformStand = false
            print("Jogador liberado, seguro na posi\195\167\195\163o.")
        end
    end
})
print("Fling - Boat button created")
local vu796 = true
local vu797 = true
Tab9:AddToggle({
    Name = "Fling no caminhão",
    Default = false,
    Callback = function(p800)
        if vu796 then
            vu796 = false
        elseif p800 then
            vu687(vu365)
        else
            local v801 = game:GetService("Players").LocalPlayer.Character
            local v802 = v801:GetPivot()
            v801:PivotTo(CFrame.new(1109.56591796875, 93.420654296875, - 1236.69580078125))
            task.wait(0.5)
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack({
                "PickingCar",
                "TowTruck"
            }))
            task.wait(0.5)
            v801:PivotTo(v802)
        end
    end
})
local vu823 = true
Tab9:AddToggle({
    Name = "Fling na canoa",
    Description = "By Shelby",
    Default = false,
    Callback = function(p824)
        if vu823 then
            vu823 = false
        elseif p824 then
            local v825 = getgenv().Target
            if not v825 then
                warn("Nenhum jogador definido.")
                return
            end
            local v826 = game.Players:FindFirstChild(v825)
            if not v826 then
                warn("Jogador n\195\163o encontrado.")
                return
            end
            local v827 = game.Players.LocalPlayer
            local v828 = v827.Character or v827.CharacterAdded:Wait()
            local vu829 = v828:WaitForChild("Humanoid")
            local v830 = v828:WaitForChild("HumanoidRootPart")
            if vu829.Sit then
                vu829.Sit = false
                task.wait(0.5)
            end
            v830.CFrame = workspace.WorkspaceCom["001_CanoeCloneButton"].Button.CFrame
            task.wait(0.4)
            fireclickdetector(workspace.WorkspaceCom["001_CanoeCloneButton"].Button.ClickDetector, 0)
            task.wait(0.4)
            local vu831 = workspace.WorkspaceCom["001_CanoeStorage"].Canoe
            local v832 = vu831:FindFirstChild("VehicleSeat")
            local v833
            if vu831.PrimaryPart then
                v833 = 0
            else
                vu831.PrimaryPart = v832
                v833 = 0
            end
            repeat
                v828:MoveTo(v832.Position + Vector3.new(0, 3.5, 0))
                task.wait(0.01)
                v832:Sit(vu829)
                v833 = v833 + 1
            until vu829.Sit or 100 < v833
            if not vu829.Sit then
                warn("Falhou em sentar no barco.")
                return
            end
            local vu834 = v826.Character or v826.CharacterAdded:Wait()
            local v835 = vu834
            local vu836 = vu834.WaitForChild(v835, "HumanoidRootPart")
            local v837 = vu834
            local vu838 = vu834.WaitForChild(v837, "Humanoid")
            local vu839 = Instance.new("BodyForce", vu831.PrimaryPart)
            local vu840 = Instance.new("BodyAngularVelocity", vu831.PrimaryPart)
            vu840.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            vu840.AngularVelocity = Vector3.new(5000, 25000, 5000)
            vu840.P = 1000000000
            local v841 = game:GetService("RunService")
            local vu842 = true
            local vu843 = 0
            local vu844 = 5
            local vu845 = 20
            local vu846 = 35
            local vu847 = 35
            local vu848 = 50
            local vu849 = nil
            vu849 = v841.Heartbeat:Connect(function(p850)
                if vu842 and (vu829.Sit and (vu834 and (vu838 and vu838.Health > 0))) then
                    vu843 = vu843 + p850
                    local v851 = vu844 + math.sin(vu843 * 10) * (vu845 - vu844) / 2
                    local v852 = vu848 * vu843
                    local v853 = math.cos(v852) * v851
                    local v854 = math.sin(v852) * v851
                    local v855 = vu836.CFrame.LookVector * math.sin(vu843 * vu847) * vu846
                    local v856 = vu836.Position + Vector3.new(v853, 5, v854) + v855
                    vu831:SetPrimaryPartCFrame(CFrame.new(v856, vu836.Position))
                    vu839.Force = (vu836.Position - vu831.PrimaryPart.Position).Unit * 1000000 + Vector3.new(0, workspace.Gravity * vu831.PrimaryPart:GetMass(), 0)
                else
                    vu849:Disconnect()
                    vu840:Destroy()
                    vu839:Destroy()
                end
            end)
        else
            getgenv().FlingAtivo = false
            local v857 = game.Players.LocalPlayer
            local v858 = v857.Character or v857.CharacterAdded:Wait()
            local v859 = v858:FindFirstChild("Humanoid")
            local v860 = v858:FindFirstChild("HumanoidRootPart")
            if not (v859 and v860) then
                return
            end
            if v859.Sit then
                v859.Sit = false
                task.wait(0.3)
            end
            local v861 = workspace:FindFirstChild("WorkspaceCom")
            if v861 then
                local vu862 = v861:FindFirstChild("001_CanoeStorage")
                if vu862 and vu862:FindFirstChild("Canoe") then
                    pcall(function()
                        vu862.Canoe:Destroy()
                    end)
                end
            end
            local v863 = getgenv().RetornoPos or Vector3.new(1118.81, 75.998, - 1138.61)
            v860.CFrame = CFrame.new(v863)
            v859:ChangeState(Enum.HumanoidStateType.Physics)
            v860.Anchored = true
            v860.CFrame = CFrame.new(v863)
            v860.AssemblyLinearVelocity = Vector3.zero
            v860.AssemblyAngularVelocity = Vector3.zero
            print("Jogador teleportado para a posi\195\167\195\163o segura.");
            (function()
                local v864 = game.Players:FindFirstChild(getgenv().Target)
                if v864 and v864.Character then
                    local v865, v866, v867 = ipairs(v864.Character:GetDescendants())
                    while true do
                        local v868
                        v867, v868 = v865(v866, v867)
                        if v867 == nil then
                            break
                        end
                        if v868:IsA("BodyVelocity") or v868:IsA("Attachment") then
                            v868:Destroy()
                        end
                    end
                end
            end)()
            task.wait(2)
            v860.Anchored = false
            v859:ChangeState(Enum.HumanoidStateType.GettingUp)
            print("Jogador liberado com seguran\195\167a.")
        end
    end
})
Tab9:AddToggle({
    Name = "Fling com sofá",
    Default = false,
    Callback = function(p869)
        vu630 = p869
        if p869 and vu365 then
            local vu870 = vu713:FindFirstChild(vu365)
            if not (vu870 and vu870.Character) then
                return
            end
            local vu871 = vu628.Character
            if vu871 then
                vu871 = vu628.Character:FindFirstChild("HumanoidRootPart")
            end
            local v872 = vu870.Character
            if v872 then
                v872 = vu870.Character:FindFirstChild("HumanoidRootPart")
            end
            if not (vu871 and v872) then
                return
            end
            local vu873 = vu628.Character
            local vu874 = vu873:FindFirstChildOfClass("Humanoid")
            local vu875 = vu871.CFrame
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer(unpack({
                "ClearAllTools"
            }))
            task.wait(0.2)
            local vu876 = {
                "PickingTools",
                "Couch"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(vu876))
            task.wait(0.3)
            local v877 = vu628.Backpack:FindFirstChild("Couch")
            if v877 then
                v877.Parent = vu873
            end
            task.wait(0.2)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.25)
            workspace.FallenPartsDestroyHeight = 0 / 0
            local vu878 = Instance.new("BodyVelocity")
            vu878.Name = "FlingForce"
            vu878.Velocity = Vector3.new(900000000, 900000000, 900000000)
            vu878.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
            vu878.Parent = vu871
            vu874:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
            vu874.PlatformStand = false
            vu629.CameraSubject = vu870.Character:FindFirstChild("Head") or (v872 or vu874)
            task.spawn(function()
                local v879 = {
                    vu871
                }
                local v880 = 0
                while vu630 and (vu870 and vu870.Character) and (vu870.Character:FindFirstChildOfClass("Humanoid") and not vu870.Character:FindFirstChildOfClass("Humanoid").Sit) do
                    v880 = v880 + 50
                    local v881, v882, v883 = ipairs(v879)
                    while true do
                        local v884
                        v883, v884 = v881(v882, v883)
                        if v883 == nil then
                            break
                        end
                        local v885 = vu870.Character.HumanoidRootPart.Position.X
                        local v886 = vu870.Character.HumanoidRootPart.Position.Y
                        local v887 = vu870.Character.HumanoidRootPart.Position.Z
                        local v888 = v885 + vu870.Character.HumanoidRootPart.Velocity.X / 1.5
                        local v889 = v886 + vu870.Character.HumanoidRootPart.Velocity.Y / 1.5
                        local v890 = v887 + vu870.Character.HumanoidRootPart.Velocity.Z / 1.5
                        vu871.CFrame = CFrame.new(v888, v889, v890) * CFrame.Angles(math.rad(v880), 0, 0)
                    end
                    vu871.Velocity = Vector3.new(900000000, 900000000, 900000000)
                    vu871.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
                    task.wait()
                end
                vu630 = false
                vu878:Destroy()
                vu874:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                vu874.PlatformStand = false
                vu871.CFrame = vu875
                vu629.CameraSubject = vu874
                local v891 = vu873
                local v892, v893, v894 = pairs(v891:GetDescendants())
                while true do
                    local v895
                    v894, v895 = v892(v893, v894)
                    if v894 == nil then
                        break
                    end
                    if v895:IsA("BasePart") then
                        v895.Velocity = Vector3.zero
                        v895.RotVelocity = Vector3.zero
                    end
                end
                vu874:UnequipTools()
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(vu876))
            end)
        end
    end
})
Tab9:AddSection({
    Name = "Métodos de eliminar por clique"
})
Tab9:AddButton({
    Name = "Fling com sofá por clique (ferramenta)",
    Callback = function()
        local vu960 = game:GetService("Players")
        local vu961 = game:GetService("ReplicatedStorage")
        local v962 = game:GetService("UserInputService")
        local vu963 = vu960.LocalPlayer
        local vu964 = workspace.CurrentCamera
        local vu965 = true
        local vu966 = false
        local v967 = "Click Fling Couch"
        local v968 = vu963:WaitForChild("Backpack")
        if not (v968:FindFirstChild(v967) or vu963.Character and vu963.Character:FindFirstChild(v967)) then
            local v969 = Instance.new("Tool")
            v969.Name = v967
            v969.RequiresHandle = false
            v969.CanBeDropped = false
            v969.Equipped:Connect(function()
                vu966 = true
            end)
            v969.Unequipped:Connect(function()
                vu966 = false
            end)
            v969.Parent = v968
        end
        local function vu992(pu970)
            if vu966 then
                if pu970 and (pu970.Character and pu970 ~= vu963) then
                    local vu971 = true
                    local vu972 = vu963.Character
                    if vu972 then
                        vu972 = vu963.Character:FindFirstChild("HumanoidRootPart")
                    end
                    local v973 = pu970.Character
                    if v973 then
                        v973 = pu970.Character:FindFirstChild("HumanoidRootPart")
                    end
                    if vu972 and v973 then
                        local vu974 = vu963.Character
                        local vu975 = vu974:FindFirstChildOfClass("Humanoid")
                        local vu976 = vu972.CFrame
                        vu961:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
                        task.wait(0.2)
                        vu961.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                        task.wait(0.3)
                        local v977 = vu963.Backpack:FindFirstChild("Couch")
                        if v977 then
                            v977.Parent = vu974
                        end
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.25)
                        workspace.FallenPartsDestroyHeight = 0 / 0
                        local vu978 = Instance.new("BodyVelocity")
                        vu978.Name = "ForcaJogada"
                        vu978.Velocity = Vector3.new(900000000, 900000000, 900000000)
                        vu978.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        vu978.Parent = vu972
                        vu975:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
                        vu975.PlatformStand = false
                        vu964.CameraSubject = pu970.Character:FindFirstChild("Head") or (v973 or vu975)
                        task.spawn(function()
                            local v979 = {
                                vu972
                            }
                            local v980 = 0
                            while vu971 and (pu970 and pu970.Character) and (pu970.Character:FindFirstChildOfClass("Humanoid") and not pu970.Character:FindFirstChildOfClass("Humanoid").Sit) do
                                v980 = v980 + 50
                                local v981, v982, v983 = ipairs(v979)
                                while true do
                                    local v984
                                    v983, v984 = v981(v982, v983)
                                    if v983 == nil then
                                        break
                                    end
                                    local v985 = pu970.Character.HumanoidRootPart
                                    local v986 = v985.Position + v985.Velocity / 1.5
                                    vu972.CFrame = CFrame.new(v986) * CFrame.Angles(math.rad(v980), 0, 0)
                                end
                                vu972.Velocity = Vector3.new(900000000, 900000000, 900000000)
                                vu972.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
                                task.wait()
                            end
                            vu971 = false
                            vu978:Destroy()
                            vu975:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                            vu975.PlatformStand = false
                            vu972.CFrame = vu976
                            vu964.CameraSubject = vu975
                            local v987 = vu974
                            local v988, v989, v990 = pairs(v987:GetDescendants())
                            while true do
                                local v991
                                v990, v991 = v988(v989, v990)
                                if v990 == nil then
                                    break
                                end
                                if v991:IsA("BasePart") then
                                    v991.Velocity = Vector3.zero
                                    v991.RotVelocity = Vector3.zero
                                end
                            end
                            vu975:UnequipTools()
                            vu961.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                        end)
                        while vu971 do
                            task.wait()
                        end
                    end
                else
                    return
                end
            else
                return
            end
        end
        v962.TouchTap:Connect(function(p993, p994)
            if not p994 and (vu965 and vu966) then
                local v995 = p993[1]
                local v996 = vu964:ScreenPointToRay(v995.X, v995.Y)
                local v997 = workspace:Raycast(v996.Origin, v996.Direction * 1000)
                if v997 and v997.Instance then
                    local v998 = vu960:GetPlayerFromCharacter(v997.Instance:FindFirstAncestorOfClass("Model"))
                    if v998 and v998 ~= vu963 then
                        vu965 = false
                        vu992(v998)
                        task.delay(2, function()
                            vu965 = true
                        end)
                    end
                end
            end
        end)
    end
})
Tab9:AddButton({
    Name = "Eliminar com sofá por clique (ferramenta)",
    Callback = function()
        local vu1060 = game:GetService("Players")
        local vu1061 = game:GetService("ReplicatedStorage")
        local vu1062 = game:GetService("RunService")
        local vu1063 = game:GetService("Workspace")
        local v1064 = game:GetService("UserInputService")
        local vu1065 = vu1060.LocalPlayer
        local vu1066 = vu1063.CurrentCamera
        local v1067 = "Click Kill Couch"
        local vu1068 = false
        local vu1069 = nil
        local vu1070 = nil
        local vu1071 = false
        local vu1072 = nil
        local vu1073 = nil
        local vu1074 = nil
        local v1075 = vu1065:WaitForChild("Backpack")
        if not v1075:FindFirstChild(v1067) then
            local v1076 = Instance.new("Tool")
            v1076.Name = v1067
            v1076.RequiresHandle = false
            v1076.CanBeDropped = false
            v1076.Equipped:Connect(function()
                vu1068 = true
            end)
            v1076.Unequipped:Connect(function()
                vu1068 = false
                vu1069 = nil
                limparSofa()
            end)
            v1076.Parent = v1075
        end
        function limparSofa()
            if vu1070 then
                vu1070:Disconnect()
                vu1070 = nil
            end
            if vu1071 then
                local v1077 = vu1065.Character
                local v1078 = v1077 and v1077:FindFirstChild("Couch")
                if v1078 then
                    v1078.Parent = vu1065.Backpack
                    vu1071 = false
                end
            end
            if vu1072 then
                vu1072:Destroy()
                vu1072 = nil
            end
            if getgenv().AntiSit then
                getgenv().AntiSit:Set(false)
            end
            local v1079 = vu1065.Character
            if v1079 then
                v1079 = vu1065.Character:FindFirstChildOfClass("Humanoid")
            end
            if v1079 then
                v1079:SetStateAtivado(Enum.HumanoidStateType.Physics, true)
                v1079:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            if vu1073 and vu1074 then
                vu1074.CFrame = vu1073
                vu1073 = nil
            end
        end
        function pegarSofa()
            local v1080 = vu1065.Character
            if v1080 then
                local v1081 = vu1065.Backpack
                if not (v1081:FindFirstChild("Couch") or v1080:FindFirstChild("Couch")) then
                    vu1061.RE["1Too1l"]:InvokeServer(unpack({
                        "PickingTools",
                        "Couch"
                    }))
                    task.wait(0.1)
                end
                local v1082 = v1081:FindFirstChild("Couch") or v1080:FindFirstChild("Couch")
                if v1082 then
                    v1082.Parent = v1080
                    vu1071 = true
                end
            end
        end
        function posAleatoriaAbaixo(p1083)
            local v1084 = p1083:FindFirstChild("HumanoidRootPart")
            if not v1084 then
                return Vector3.new()
            end
            local v1085 = Vector3.new(math.random(- 2, 2), - 5.1, math.random(- 2, 2))
            return v1084.Position + v1085
        end
        function tpAbaixo(p1086)
            if p1086 and p1086.Character and p1086.Character:FindFirstChild("HumanoidRootPart") then
                local v1087 = vu1065.Character
                local v1088
                if v1087 then
                    v1088 = v1087:FindFirstChild("HumanoidRootPart")
                else
                    v1088 = v1087
                end
                if v1087 then
                    v1087 = v1087:FindFirstChildOfClass("Humanoid")
                end
                if v1088 and v1087 then
                    v1087:SetStateAtivado(Enum.HumanoidStateType.Physics, false)
                    if not vu1072 then
                        vu1072 = Instance.new("Part")
                        vu1072.Size = Vector3.new(10, 1, 10)
                        vu1072.Anchored = true
                        vu1072.CanCollide = true
                        vu1072.Transparency = 0.5
                        vu1072.Parent = vu1063
                    end
                    local v1089 = posAleatoriaAbaixo(p1086.Character)
                    vu1072.Position = v1089
                    v1088.CFrame = CFrame.new(v1089)
                    v1087:SetStateAtivado(Enum.HumanoidStateType.Physics, true)
                end
            else
                return
            end
        end
        function arremessarComSofa(p1090)
            if p1090 then
                vu1069 = p1090.Name
                local v1091 = vu1065.Character
                if v1091 then
                    local v1092 = v1091:FindFirstChild("HumanoidRootPart")
                    if v1092 then
                        v1092 = v1091.HumanoidRootPart.CFrame
                    end
                    vu1073 = v1092
                    vu1074 = v1091:FindFirstChild("HumanoidRootPart")
                    pegarSofa()
                    vu1070 = vu1062.Heartbeat:Connect(function()
                        local v1093 = vu1060:FindFirstChild(vu1069)
                        if v1093 and v1093.Character and v1093.Character:FindFirstChild("Humanoid") then
                            if getgenv().AntiSit then
                                getgenv().AntiSit:Set(true)
                            end
                            tpAbaixo(v1093)
                        else
                            limparSofa()
                        end
                    end)
                    task.spawn(function()
                        local v1094 = vu1060:FindFirstChild(vu1069)
                        while v1094 and v1094.Character and v1094.Character:FindFirstChild("Humanoid") do
                            task.wait(0.05)
                            if v1094.Character.Humanoid.SeatPart then
                                local v1095 = CFrame.new(265.46, - 450.83, - 59.93)
                                v1094.Character.HumanoidRootPart.CFrame = v1095
                                vu1065.Character.HumanoidRootPart.CFrame = v1095
                                task.wait(0.4)
                                limparSofa()
                                task.wait(0.2)
                                if vu1073 then
                                    vu1065.Character.HumanoidRootPart.CFrame = vu1073
                                end
                                break
                            end
                        end
                    end)
                end
            else
                return
            end
        end
        v1064.TouchTap:Connect(function(p1096, p1097)
            if vu1068 and not p1097 then
                local v1098 = p1096[1]
                local v1099 = vu1066:ScreenPointToRay(v1098.X, v1098.Y)
                local v1100 = vu1063:Raycast(v1099.Origin, v1099.Direction * 1000)
                if v1100 and v1100.Instance then
                    local v1101 = vu1060:GetPlayerFromCharacter((v1100.Instance:FindFirstAncestorOfClass("Model")))
                    if v1101 and v1101 ~= vu1065 then
                        arremessarComSofa(v1101)
                    end
                end
            end
        end)
    end
})
Tab9:AddSection({
    Name = "Caminhão"
})
Tab9:AddButton({
    Name = "Fling com caminhão para todos",
    Callback = function()
        local vu1102 = game:GetService("Players")
        local v1103 = game:GetService("RunService")
        local v1104, v1105, v1106 = pairs(vu1102:GetPlayers())
        while true do
            local v1107
            v1106, v1107 = v1104(v1105, v1106)
            if v1106 == nil then
                return
            end
            local v1108 = vu1102.LocalPlayer.Character or vu1102.LocalPlayer.CharacterAdded:Wait()
            v1108:WaitForChild("HumanoidRootPart")
            if table.find(Whitelist, target.Name) == nil then
                local v1109 = v1108:GetPivot()
                v1108:PivotTo(CFrame.new(1109.56591796875, 93.420654296875, - 1236.69580078125))
                task.wait(0.5)
                game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack({
                    "PickingCar",
                    "TowTruck"
                }))
                task.wait(0.5)
                v1108:PivotTo(v1109)
                local v1110 = v1107.Name
                local function v1118(p1111)
                    local v1112 = p1111:lower()
                    local v1113 = vu1102
                    local v1114, v1115, v1116 = ipairs(v1113:GetPlayers())
                    while true do
                        local v1117
                        v1116, v1117 = v1114(v1115, v1116)
                        if v1116 == nil then
                            break
                        end
                        if v1117 ~= vu1102.LocalPlayer and v1117.Name:lower():sub(1, # v1112) == v1112 then
                            return v1117
                        end
                    end
                    return nil
                end
                local v1119
                if v1110 == "" then
                    v1119 = false
                else
                    v1119 = v1118(v1110)
                end
                if not v1119 then
                    local v1120, v1121, v1122 = ipairs(vu1102:GetPlayers())
                    local v1123 = {}
                    while true do
                        local v1124
                        v1122, v1124 = v1120(v1121, v1122)
                        if v1122 == nil then
                            break
                        end
                        if v1124 ~= vu1102.LocalPlayer then
                            table.insert(v1123, v1124)
                        end
                    end
                    v1119 = # v1123 > 0 and v1123[math.random(1, # v1123)]
                    if not v1119 then
                        v1119 = nil
                    end
                end
                if not (v1119 and v1119.Character and v1119.Character:FindFirstChild("HumanoidRootPart")) then
                    warn("Alvo inv\195\161lido")
                    return
                end
                local v1125 = v1119.Character.HumanoidRootPart
                workspace.CurrentCamera.CameraSubject = v1119.Character:FindFirstChild("Humanoid")
                local v1126 = workspace:FindFirstChild("Vehicles")
                if v1126 then
                    v1126 = v1126:FindFirstChild(vu1102.LocalPlayer.Name .. "Car")
                end
                if v1126 then
                    v1126 = v1126:FindFirstChild("Body")
                end
                if v1126 then
                    v1126 = v1126:FindFirstChild("BodyPanels")
                end
                if v1126 then
                    v1126 = v1126:FindFirstChild("ModelMove2")
                end
                if not v1126 then
                    warn("ModelMove2 n\195\163o encontrado.")
                    return
                end
                local v1127, v1128, v1129 = ipairs(v1126:GetDescendants())
                local v1130 = {}
                while true do
                    local v1131
                    v1129, v1131 = v1127(v1128, v1129)
                    if v1129 == nil then
                        break
                    end
                    if v1131:IsA("BasePart") and (v1131.Size.Magnitude > 5 and (not v1131.Anchored and v1131.CanCollide)) then
                        v1131.Anchored = false
                        v1131.CanCollide = true
                        local v1132, v1133, v1134 = ipairs(v1131:GetChildren())
                        while true do
                            local v1135
                            v1134, v1135 = v1132(v1133, v1134)
                            if v1134 == nil then
                                break
                            end
                            if v1135:IsA("BodyVelocity") or v1135:IsA("BodyAngularVelocity") then
                                v1135:Destroy()
                            end
                        end
                        local v1136 = Instance.new("BodyVelocity")
                        v1136.MaxForce = Vector3.new(90000000000, 90000000000, 90000000000)
                        v1136.P = 90000000000
                        v1136.Velocity = Vector3.new()
                        v1136.Parent = v1131
                        local v1137 = Instance.new("BodyAngularVelocity")
                        v1137.MaxTorque = Vector3.new(900000000, 900000000, 900000000)
                        v1137.AngularVelocity = Vector3.new()
                        v1137.Parent = v1131
                        table.insert(v1130, {
                            part = v1131,
                            bv = v1136,
                            bav = v1137
                        })
                    end
                end
                if # v1130 == 0 then
                    warn("Nenhuma parte válida para Fling.")
                    return
                end
                local v1138 = os.time()
                local v1139 = 10000
                local v1140 = 25000
                local v1141 = 3750
                local v1142 = 1.5
                local function v1146(p1143, p1144, p1145)
                    return math.sin(p1143 * p1144) * p1145
                end
                while true do
                    local v1147 = tick()
                    local v1148 = v1125.Position
                    local v1149, v1150, v1151 = ipairs(v1130)
                    while true do
                        local v1152
                        v1151, v1152 = v1149(v1150, v1151)
                        if v1151 == nil then
                            break
                        end
                        local v1153 = v1152.part
                        local v1154 = v1152.bv
                        local v1155 = v1152.bav
                        local v1156 = v1147 * v1141 + v1151 * (2 * math.pi / # v1130)
                        local v1157 = v1148 + Vector3.new(math.cos(v1156) * v1142 + v1146(v1147 + v1151, 15, 0.5), math.sin(v1147 * v1141 * 0.8 + v1151) * 3 + v1146(v1147 * 10 + v1151, 20, 0.3), math.sin(v1156) * v1142 + v1146(v1147 + v1151 * 2, 12, 0.5))
                        local v1158 = v1157 - v1153.Position
                        local v1159 = v1158.Magnitude
                        local v1160 = math.clamp(v1159 * 150 + v1146(v1147 * 25 + v1151, 40, 100), 0, v1139)
                        v1154.Velocity = v1158.Unit * v1160
                        v1155.AngularVelocity = Vector3.new(math.sin(v1147 * 60 + v1151) * v1140, math.cos(v1147 * 90 + v1151) * v1140, math.sin(v1147 * 100 + v1151) * v1140)
                        v1153.CFrame = CFrame.new(v1157) * CFrame.Angles(math.sin(v1147 * 20 + v1151) * math.pi / 3, math.cos(v1147 * 15 + v1151) * math.pi / 3, math.sin(v1147 * 10 + v1151) * math.pi / 3)
                    end
                    v1103.Heartbeat:Wait()
                    if os.time() - v1138 >= 5 or v1125.Velocity.Magnitude >= 300 then
                    end
                end
            end
        end
    end
})
print("Kill All Truck button created")
Tab9:AddButton({
    Name = "Fling com barco para todos",
    Callback = function()
        local v1161 = game.Players.LocalPlayer
        local v1162 = v1161.Character
        local v1163 = v1162:FindFirstChildOfClass("Humanoid")
        local v1164 = v1162:FindFirstChild("HumanoidRootPart")
        local v1165 = game.Workspace:FindFirstChild("Vehicles")
        local v1166 = v1164.CFrame
        local vu1167 = 0
        if not v1165:FindFirstChild(v1161.Name .. "Car") and v1164 then
            v1164.CFrame = CFrame.new(1754, - 2, 58)
            task.wait(0.5)
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
            task.wait(0.5)
            local v1168 = v1165:FindFirstChild(v1161.Name .. "Car")
            task.wait(0.5)
            local v1169 = v1168:FindFirstChild("Body")
            if v1169 then
                v1169 = v1168.Body:FindFirstChild("VehicleSeat")
            end
            if v1169 then
                repeat
                    task.wait()
                    v1164.CFrame = v1169.CFrame * CFrame.new(0, math.random(- 1, 1), 0)
                until v1163.Sit
            end
        end
        task.wait(0.5)
        local vu1170 = v1165:FindFirstChild(v1161.Name .. "Car")
        if vu1170 and not v1163.Sit then
            local v1171 = vu1170:FindFirstChild("Body")
            if v1171 then
                v1171 = vu1170.Body:FindFirstChild("VehicleSeat")
            end
            if v1171 then
                repeat
                    task.wait()
                    v1164.CFrame = v1171.CFrame * CFrame.new(0, math.random(- 1, 1), 0)
                until v1163.Sit
            end
        end
        local v1172 = Instance.new("BodyGyro")
        v1172.Parent = vu1170.PrimaryPart
        v1172.MaxTorque = Vector3.new(10000000, 10000000, 10000000)
        v1172.P = 10000000
        v1172.CFrame = vu1170.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0)
        local function v1179(_, p1173, _)
            vu1167 = 0
            local v1174 = tick() + 1
            while tick() < v1174 do
                vu1167 = vu1167 + 100
                task.wait()
                local function v1178(p1175, p1176, p1177)
                    vu1170:SetPrimaryPartCFrame(CFrame.new(p1175.Position) * p1176 * p1177)
                end
                v1178(p1173, CFrame.new(0, 3, 0), CFrame.Angles(math.rad(vu1167), 0, 0))
                v1178(p1173, CFrame.new(0, - 1.5, 2), CFrame.Angles(math.rad(vu1167), 0, 0))
                v1178(p1173, CFrame.new(2, 1.5, 2.25), CFrame.Angles(math.rad(50), 0, 0))
                v1178(p1173, CFrame.new(- 2.25, - 1.5, 2.25), CFrame.Angles(math.rad(30), 0, 0))
                v1178(p1173, CFrame.new(0, 1.5, 0), CFrame.Angles(math.rad(vu1167), 0, 0))
                v1178(p1173, CFrame.new(0, - 1.5, 0), CFrame.Angles(math.rad(vu1167), 0, 0))
            end
        end
        local v1180, v1181, v1182 = pairs(game.Players:GetPlayers())
        while true do
            local v1183
            v1182, v1183 = v1180(v1181, v1182)
            if v1182 == nil then
                break
            end
            if v1183 ~= v1161 or table.find(Whitelist, target.Name) == nil then
                local v1184 = v1183.Character
                local v1185
                if v1184 then
                    v1185 = v1184:FindFirstChildOfClass("Humanoid")
                else
                    v1185 = v1184
                end
                local v1186
                if v1184 then
                    v1186 = v1184:FindFirstChild("HumanoidRootPart")
                else
                    v1186 = v1184
                end
                if v1184 and (v1185 and v1186) then
                    v1179(v1184, v1186, v1185)
                end
            end
        end
        task.wait(0.5)
        vu1170:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
        task.wait(0.5)
        v1163.Sit = false
        task.wait(0.5)
        v1164.CFrame = v1166
        v1172:Destroy()
    end
})
print("Fling Boat All button created")
Tab9:AddButton({
    Name = "Fling com sofá para todos",
    Callback = function()
        local v1187 = game:GetService("Players")
        local vu1188 = game:GetService("ReplicatedStorage")
        local vu1189 = v1187.LocalPlayer
        local vu1190 = workspace.CurrentCamera
        local function v1213(pu1191)
            if pu1191 and (pu1191.Character and (pu1191 ~= vu1189 and table.find(Whitelist, pu1191.Name) == nil)) then
                local vu1192 = true
                local vu1193 = vu1189.Character
                if vu1193 then
                    vu1193 = vu1189.Character:FindFirstChild("HumanoidRootPart")
                end
                local v1194 = pu1191.Character
                if v1194 then
                    v1194 = pu1191.Character:FindFirstChild("HumanoidRootPart")
                end
                if vu1193 and v1194 then
                    local vu1195 = vu1189.Character
                    local vu1196 = vu1195:FindFirstChildOfClass("Humanoid")
                    local vu1197 = vu1193.CFrame
                    vu1188:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
                    task.wait(0.2)
                    vu1188.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                    task.wait(0.3)
                    local v1198 = vu1189.Backpack:FindFirstChild("Couch")
                    if v1198 then
                        v1198.Parent = vu1195
                    end
                    task.wait(0.1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(0.25)
                    workspace.FallenPartsDestroyHeight = 0 / 0
                    local vu1199 = Instance.new("BodyVelocity")
                    vu1199.Name = "FlingForce"
                    vu1199.Velocity = Vector3.new(900000000, 900000000, 900000000)
                    vu1199.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    vu1199.Parent = vu1193
                    vu1196:SetStateAtivado(Enum.HumanoidStateType.Seated, false)
                    vu1196.PlatformStand = false
                    vu1190.CameraSubject = pu1191.Character:FindFirstChild("Head") or (v1194 or vu1196)
                    task.spawn(function()
                        local v1200 = {
                            vu1193
                        }
                        local v1201 = 0
                        while vu1192 and (pu1191 and pu1191.Character) and (pu1191.Character:FindFirstChildOfClass("Humanoid") and not pu1191.Character:FindFirstChildOfClass("Humanoid").Sit) do
                            v1201 = v1201 + 50
                            local v1202, v1203, v1204 = ipairs(v1200)
                            while true do
                                local v1205
                                v1204, v1205 = v1202(v1203, v1204)
                                if v1204 == nil then
                                    break
                                end
                                local v1206 = pu1191.Character.HumanoidRootPart
                                local v1207 = v1206.Position + v1206.Velocity / 1.5
                                vu1193.CFrame = CFrame.new(v1207) * CFrame.Angles(math.rad(v1201), 0, 0)
                            end
                            vu1193.Velocity = Vector3.new(900000000, 900000000, 900000000)
                            vu1193.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
                            task.wait()
                        end
                        vu1192 = false
                        vu1199:Destroy()
                        vu1196:SetStateAtivado(Enum.HumanoidStateType.Seated, true)
                        vu1196.PlatformStand = false
                        vu1193.CFrame = vu1197
                        vu1190.CameraSubject = vu1196
                        local v1208 = vu1195
                        local v1209, v1210, v1211 = pairs(v1208:GetDescendants())
                        while true do
                            local v1212
                            v1211, v1212 = v1209(v1210, v1211)
                            if v1211 == nil then
                                break
                            end
                            if v1212:IsA("BasePart") then
                                v1212.Velocity = Vector3.zero
                                v1212.RotVelocity = Vector3.zero
                            end
                        end
                        vu1196:UnequipTools()
                        vu1188.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
                    end)
                    while vu1192 do
                        task.wait()
                    end
                end
            else
                return
            end
        end
        local v1214, v1215, v1216 = ipairs(v1187:GetPlayers())
        while true do
            local v1217
            v1216, v1217 = v1214(v1215, v1216)
            if v1216 == nil then
                break
            end
            v1213(v1217)
        end
    end
})
print("Kill All Couch button created")

---------------------------------------------------------------------------------------------------------------------------------
                                                   -- ===  10: Mapa Troll === --
---------------------------------------------------------------------------------------------------------------------------------
Tab10:AddSection({ "Ferramentas do mapa" })
Tab10:AddButton({
 Name = "Abrir ferramenta do mapa",
 Callback = function()
   loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/qZkSict1retkqFIr/raw"))()
   end
})

local skyboxAtivado = false
local skyboxTrack = nil
local rigidTrack = nil
local savedNukeBody = {}

local function stopAllAnimations()
    if rigidTrack then
        pcall(function()
            rigidTrack:Stop()
            rigidTrack:Destroy()
        end)
        rigidTrack = nil
    end
    
    if skyboxTrack then
        pcall(function()
            skyboxTrack:Stop()
            skyboxTrack:Destroy()
        end)
        skyboxTrack = nil
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    if track.Animation then
                        local animId = track.Animation.AnimationId
                        if animId == "rbxassetid://70883871260184" or animId == "rbxassetid://3695333486" then
                            pcall(function()
                                track:Stop()
                            end)
                        end
                    end
                end
            end
        end
    end
end

Tab10:AddToggle({
    Name = "Ativar transformação do Skybox",
    Default = false,
    Callback = function(value)
        skyboxAtivado = value
        
        if value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local description = humanoid:GetAppliedDescription()
                    
                    savedNukeBody = {
                        Torso = description.Torso,
                        RightArm = description.RightArm,
                        LeftArm = description.LeftArm,
                        RightLeg = description.RightLeg,
                        LeftLeg = description.LeftLeg,
                        Head = description.Head
                    }
                    
                    task.wait(0.2)
                    
                    local args = {
                        [1] = 123402086843885,
                        [2] = 100839513065432,
                        [3] = 78300682916056,
                        [4] = 86276701020724,
                        [5] = 78409653958165,
                        [6] = 15093053680
                    }
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(args)
                    end)
                    
                    task.wait(0.3)
                    
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = "rbxassetid://70883871260184"
                    
                    skyboxTrack = humanoid:LoadAnimation(newAnim)
                    skyboxTrack.Priority = Enum.AnimationPriority.Action4
                    skyboxTrack:Play(0.1, 1, 0.01)
                    
                    task.wait(0.5)
                    
                    local plankAnim = Instance.new("Animation")
                    plankAnim.AnimationId = "rbxassetid://3695333486"
                    rigidTrack = humanoid:LoadAnimation(plankAnim)
                    rigidTrack.Priority = Enum.AnimationPriority.Movement
                    rigidTrack:Play(0.1, 1, 0)
                end
            end
        else
            stopAllAnimations()
            
            task.wait(0.2)
            
            if next(savedNukeBody) then
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local restoreBody = {
                            [1] = savedNukeBody.Torso,
                            [2] = savedNukeBody.RightArm,
                            [3] = savedNukeBody.LeftArm,
                            [4] = savedNukeBody.RightLeg,
                            [5] = savedNukeBody.LeftLeg,
                            [6] = savedNukeBody.Head
                        }
                        
                        local args = {
                            [1] = restoreBody
                        }
                        
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack(args))
                        end)
                        
                        savedNukeBody = {}
                    end
                end
            end
        end
    end
})

local nukeFlashAtivado = false
local nukeFlashTrack = nil
local flashRigidTrack = nil
local savedNukeFlashBody = {}

local function stopFlashAnimations()
    if flashRigidTrack then
        pcall(function()
            flashRigidTrack:Stop()
            flashRigidTrack:Destroy()
        end)
        flashRigidTrack = nil
    end
    
    if nukeFlashTrack then
        pcall(function()
            nukeFlashTrack:Stop()
            nukeFlashTrack:Destroy()
        end)
        nukeFlashTrack = nil
    end
end

Tab10:AddToggle({
    Name = " Não",
    Default = false,
    Callback = function(value)
        nukeFlashAtivado = value
        
        if value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local description = humanoid:GetAppliedDescription()
                    
                    savedNukeFlashBody = {
                        Torso = description.Torso,
                        RightArm = description.RightArm,
                        LeftArm = description.LeftArm,
                        RightLeg = description.RightLeg,
                        LeftLeg = description.LeftLeg,
                        Head = description.Head
                    }
                    
                    task.wait(0.2)
                    
                    local args = {
                        [1] = 123402086843885,
                        [2] = 100839513065432,
                        [3] = 78300682916056,
                        [4] = 86276701020724,
                        [5] = 78409653958165,
                        [6] = 15093053680
                    }
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(args)
                    end)
                    
                    task.wait(0.3)
                    
                    local newAnim = Instance.new("Animation")
                    newAnim.AnimationId = "rbxassetid://70883871260184"
                    
                    nukeFlashTrack = humanoid:LoadAnimation(newAnim)
                    nukeFlashTrack.Priority = Enum.AnimationPriority.Action4
                    nukeFlashTrack:Play(0.1, 1, 1)
                    
                    task.wait(0.1)
                    nukeFlashTrack:AdjustSpeed(5)
                    
                    task.wait(0.3)
                    
                    local plankAnim = Instance.new("Animation")
                    plankAnim.AnimationId = "rbxassetid://3695333486"
                    flashRigidTrack = humanoid:LoadAnimation(plankAnim)
                    flashRigidTrack.Priority = Enum.AnimationPriority.Movement
                    flashRigidTrack:Play(0.1, 1, 0)
                end
            end
        else
            stopFlashAnimations()
            
            task.wait(0.2)
            
            if next(savedNukeFlashBody) then
                local player = game.Players.LocalPlayer
                local character = player.Character
                
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local restoreBody = {
                            [1] = savedNukeFlashBody.Torso,
                            [2] = savedNukeFlashBody.RightArm,
                            [3] = savedNukeFlashBody.LeftArm,
                            [4] = savedNukeFlashBody.RightLeg,
                            [5] = savedNukeFlashBody.LeftLeg,
                            [6] = savedNukeFlashBody.Head
                        }
                        
                        local args = {
                            [1] = restoreBody
                        }
                        
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.ChangeCharacterBody:InvokeServer(unpack(args))
                        end)
                        
                        savedNukeFlashBody = {}
                    end
                end
            end
        end
    end
})

Tab10:AddSection({ "" })

Tab10:AddButton({

    Name = "[OP]  -  ",

    Callback = function()

local RS = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local TextChatService = game:GetService("TextChatService")

local Player = game.Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()

local Humanoid = Character:WaitForChild("Humanoid")

local RootPart = Character:WaitForChild("HumanoidRootPart")

local Vehicles = workspace:WaitForChild("Vehicles")



if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then 

    TextChatService.TextChannels.RBXGeneral:SendAsync(

        "hi\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\rTornado has appeared! Be careful..."

    )

else 

end



local selectedAudioID = 9068077052

local function playAudio()

    if not selectedAudioID then

        return

    end



    local args = {

        [1] = workspace,

        [2] = selectedAudioID,

        [3] = 1,

    }



    for i = 1, 5 do

        RS.RE:FindFirstChild("1Gu1nSound1s"):FireServer(unpack(args))



        local sound = Instance.new("Sound")

        sound.SoundId = "rbxassetid://" .. tostring(selectedAudioID)

        sound.Parent = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

        if sound.Parent then

            sound:Play()

        else

            break

        end



        task.wait(1.5)

        sound:Destroy()

    end

end



local function spawnBoat()

    RootPart.CFrame = CFrame.new(1754, -2, 58)

    task.wait(0.5)

    RS:WaitForChild("RE"):FindFirstChild("1Ca1r"):FireServer("PickingBoat", "PirateFree")

    task.wait(1)

    return Vehicles:FindFirstChild(Player.Name .. "Car")

end



local PCar = spawnBoat()

if not PCar then

    return

end



local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")

if not Seat then

    return

end



repeat

    task.wait(0.1)

    RootPart.CFrame = Seat.CFrame * CFrame.new(0, 1, 0)

until Humanoid.SeatPart == Seat



task.spawn(playAudio)



task.delay(4, function()

    if Humanoid.SeatPart then

        Humanoid.Sit = false

    end

    RootPart.CFrame = CFrame.new(0, 0, 0)

end)



local RE_Flip = RS:WaitForChild("RE"):WaitForChild("1Player1sCa1r")

task.spawn(function()

    while PCar and PCar.Parent do

        RE_Flip:FireServer("Flip")

        task.wait(0.5)

    end

end)



local waypoints = {

    Vector3.new(-16, 0, -47),

    Vector3.new(-110, 0, -45),

    Vector3.new(16, 0, -55)

}



local currentIndex = 1

local nextIndex = 2

local moveSpeed = 15

local rotationSpeed = math.rad(720)

local progress = 0

local currentRotation = 0



local function lerpCFrame(a, b, t)

    return a:lerp(b, t)

end



RunService.Heartbeat:Connect(function(dt)

    if not (PCar and PCar.PrimaryPart) then return end



    local startPos = waypoints[currentIndex]

    local endPos = waypoints[nextIndex]



    progress += (moveSpeed * dt) / (startPos - endPos).Magnitude

    if progress >= 1 then

        progress = 0

        currentIndex = nextIndex

        nextIndex = (nextIndex % #waypoints) + 1

    end



    local newPos = lerpCFrame(CFrame.new(startPos), CFrame.new(endPos), progress).p

    currentRotation += rotationSpeed * dt



    local cf = CFrame.new(newPos) * CFrame.Angles(0, currentRotation, 0)

    PCar:SetPrimaryPartCFrame(cf)

end)

end

})



Tab10:AddButton({

    Name = "Remover todos os veículos",

    Callback = function()

        local success, err = pcall(function()

            local args = { "DeleteAllVehicles" }

            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))

        end)



        if not success then

        else

        end

    end

})



Tab10:AddSection({ "Outros" })

Tab10:AddButton({

    Name = "Buraco negro",

    Description = "Ativar o efeito de buraco negro",

    Callback = function()

        local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local Workspace = game:GetService("Workspace")



local angle = 1

local radius = 10

local blackHoleActive = false



local function setupPlayer()

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")



    local Folder = Instance.new("Folder", Workspace)

    local Part = Instance.new("Part", Folder)

    local Attachment1 = Instance.new("Attachment", Part)

    Part.Anchored = true

    Part.CanCollide = false

    Part.Transparency = 1



    return humanoidRootPart, Attachment1

end



local humanoidRootPart, Attachment1 = setupPlayer()



if not getgenv().Network then

    getgenv().Network = {

        BaseParts = {},

        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)

    }



    Network.RetainPart = function(part)

        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then

            table.insert(Network.BaseParts, part)

            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

            part.CanCollide = false

        end

    end



    local function EnablePartControl()

        LocalPlayer.ReplicationFocus = Workspace

        RunService.Heartbeat:Connect(function()

            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

            for _, part in pairs(Network.BaseParts) do

                if part:IsDescendantOf(Workspace) then

                    part.Velocity = Network.Velocity

                end

            end

        end)

    end



    EnablePartControl()

end



local function ForcePart(v)

    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then

        for _, x in next, v:GetChildren() do

            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then

                x:Destroy()

            end

        end

        if v:FindFirstChild("Attachment") then

            v:FindFirstChild("Attachment"):Destroy()

        end

        if v:FindFirstChild("AlignPosition") then

            v:FindFirstChild("AlignPosition"):Destroy()

        end

        if v:FindFirstChild("Torque") then

            v:FindFirstChild("Torque"):Destroy()

        end

        v.CanCollide = false

        

        local Torque = Instance.new("Torque", v)

        Torque.Torque = Vector3.new(1000000, 1000000, 1000000)

        local AlignPosition = Instance.new("AlignPosition", v)

        local Attachment2 = Instance.new("Attachment", v)

        Torque.Attachment0 = Attachment2

        AlignPosition.MaxForce = math.huge

        AlignPosition.MaxVelocity = math.huge

        AlignPosition.Responsiveness = 500

        AlignPosition.Attachment0 = Attachment2

        AlignPosition.Attachment1 = Attachment1

    end

end



local function toggleBlackHole()

    blackHoleActive = not blackHoleActive

    if blackHoleActive then

        for _, v in next, Workspace:GetDescendants() do

            ForcePart(v)

        end



        Workspace.DescendantAdded:Connect(function(v)

            if blackHoleActive then

                ForcePart(v)

            end

        end)



        spawn(function()

            while blackHoleActive and RunService.RenderStepped:Wait() do

                angle = angle + math.rad(2)



                local offsetX = math.cos(angle) * radius

                local offsetZ = math.sin(angle) * radius



                Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)

            end

        end)

    else

        Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)

    end

end



LocalPlayer.CharacterAdded:Connect(function()

    humanoidRootPart, Attachment1 = setupPlayer()

    if blackHoleActive then

        toggleBlackHole()

    end

end)



local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()

local window = library:Window("Black Hole")



window:Slider("Radius Black Hole",1,100,10, function(Value)

   radius = Value

end)



window:Toggle("Toggle Black Hole", true, function(Value)

       if Value then

            toggleBlackHole()

        else

            blackHoleActive = false

        end

end)



spawn(function()

    while true do

        RunService.RenderStepped:Wait()

        if blackHoleActive then

            angle = angle + math.rad(angleSpeed)

        end

    end

end)



toggleBlackHole()

    end

})

Tab10:AddButton({

    Name = "Painel de controle",

    Description = "Abrir o painel de controle",

    Callback = function()

local Gui = Instance.new("ScreenGui")

local Main = Instance.new("Frame")

local Box = Instance.new("TextBox")

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

local Label = Instance.new("TextLabel")

local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")

local Button = Instance.new("TextButton")

local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")



Gui.Name = "Gui"

Gui.Parent = gethui()

Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling



Main.Name = "Main"

Main.Parent = Gui

Main.BackgroundColor3 = Color3.fromRGB(75, 75, 75)

Main.BorderColor3 = Color3.fromRGB(0, 0, 0)

Main.BorderSizePixel = 0

Main.Position = UDim2.new(0.335954279, 0, 0.542361975, 0)

Main.Size = UDim2.new(0.240350261, 0, 0.166880623, 0)

Main.Active = true

Main.Draggable = true



Box.Name = "Box"

Box.Parent = Main

Box.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Box.BorderColor3 = Color3.fromRGB(0, 0, 0)

Box.BorderSizePixel = 0

Box.Position = UDim2.new(0.0980926454, 0, 0.218712583, 0)

Box.Size = UDim2.new(0.801089942, 0, 0.364963502, 0)

Box.FontFace = Font.new("rbxasset://fonts/families/SourceSansSemibold.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

Box.PlaceholderText = "Nome do jogador..."

Box.Text = ""

Box.TextColor3 = Color3.fromRGB(255, 255, 255)

Box.TextScaled = true

Box.TextSize = 31.000

Box.TextWrapped = true



UITextSizeConstraint.Parent = Box

UITextSizeConstraint.MaxTextSize = 31



Label.Name = "Label"

Label.Parent = Main

Label.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Label.BorderColor3 = Color3.fromRGB(0, 0, 0)

Label.BorderSizePixel = 0

Label.Size = UDim2.new(1, 0, 0.160583943, 0)

Label.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

Label.Text = "Bring Parts"

Label.TextColor3 = Color3.fromRGB(255, 255, 255)

Label.TextScaled = true

Label.TextSize = 14.000

Label.TextWrapped = true



UITextSizeConstraint_2.Parent = Label

UITextSizeConstraint_2.MaxTextSize = 21



Button.Name = "Button"

Button.Parent = Main

Button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)

Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

Button.BorderSizePixel = 0

Button.Position = UDim2.new(0.183284417, 0, 0.656760991, 0)

Button.Size = UDim2.new(0.629427791, 0, 0.277372271, 0)

Button.Font = Enum.Font.Nunito

Button.Text = "Bring Parts (Off)"

Button.TextColor3 = Color3.fromRGB(255, 255, 255)

Button.TextScaled = true

Button.TextSize = 28.000

Button.TextWrapped = true



UITextSizeConstraint_3.Parent = Button

UITextSizeConstraint_3.MaxTextSize = 28



local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")



local character

local humanoidRootPart



mainStatus = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)

    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then

        mainStatus = not mainStatus

        Main.Visible = mainStatus

    end

end)



local Folder = Instance.new("Folder", Workspace)

local Part = Instance.new("Part", Folder)

local Attachment1 = Instance.new("Attachment", Part)

Part.Anchored = true

Part.CanCollide = false

Part.Transparency = 1



if not getgenv().Network then

    getgenv().Network = {

        BaseParts = {},

        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)

    }



    Network.RetainPart = function(Part)

        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then

            table.insert(Network.BaseParts, Part)

            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

            Part.CanCollide = false

        end

    end



    local function EnablePartControl()

        LocalPlayer.ReplicationFocus = Workspace

        RunService.Heartbeat:Connect(function()

            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

            for _, Part in pairs(Network.BaseParts) do

                if Part:IsDescendantOf(Workspace) then

                    Part.Velocity = Network.Velocity

                end

            end

        end)

    end



    EnablePartControl()

end



local function ForcePart(v)

    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then

        for _, x in ipairs(v:GetChildren()) do

            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then

                x:Destroy()

            end

        end

        if v:FindFirstChild("Attachment") then

            v:FindFirstChild("Attachment"):Destroy()

        end

        if v:FindFirstChild("AlignPosition") then

            v:FindFirstChild("AlignPosition"):Destroy()

        end

        if v:FindFirstChild("Torque") then

            v:FindFirstChild("Torque"):Destroy()

        end

        v.CanCollide = false

        local Torque = Instance.new("Torque", v)

        Torque.Torque = Vector3.new(100000, 100000, 100000)

        local AlignPosition = Instance.new("AlignPosition", v)

        local Attachment2 = Instance.new("Attachment", v)

        Torque.Attachment0 = Attachment2

        AlignPosition.MaxForce = math.huge

        AlignPosition.MaxVelocity = math.huge

        AlignPosition.Responsiveness = 200

        AlignPosition.Attachment0 = Attachment2

        AlignPosition.Attachment1 = Attachment1

    end

end



local blackHoleActive = false

local DescendantAddedConnection



local function toggleBlackHole()

    blackHoleActive = not blackHoleActive

    if blackHoleActive then

        Button.Text = "Bring Parts (On)"

        for _, v in ipairs(Workspace:GetDescendants()) do

            ForcePart(v)

        end



        DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)

            if blackHoleActive then

                ForcePart(v)

            end

        end)



        spawn(function()

            while blackHoleActive and RunService.RenderStepped:Wait() do

                Attachment1.WorldCFrame = humanoidRootPart.CFrame

            end

        end)

    else

        Button.Text = "Bring Parts (Off)"

        if DescendantAddedConnection then

            DescendantAddedConnection:Disconnect()

        end

    end

end



local function getPlayer(name)

    local lowerName = string.lower(name)

    for _, p in pairs(Players:GetPlayers()) do

        local lowerPlayer = string.lower(p.Name)

        if string.find(lowerPlayer, lowerName) then

            return p

        elseif string.find(string.lower(p.DisplayName), lowerName) then

            return p

        end

    end

end



local player = nil



local function VDOYZQL_fake_script() 

    local script = Instance.new('Script', Box)



    script.Parent.FocusLost:Connect(function(enterPressed)

        if enterPressed then

            player = getPlayer(Box.Text)

            if player then

                Box.Text = player.Name

            else

            end

        end

    end)

end

coroutine.wrap(VDOYZQL_fake_script)()

local function JUBNQKI_fake_script()

    local script = Instance.new('Script', Button)



    script.Parent.MouseButton1Click:Connect(function()

        if player then

            character = player.Character or player.CharacterAdded:Wait()

            humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            toggleBlackHole()

        else

        end

    end)

end

coroutine.wrap(JUBNQKI_fake_script)()

    end

})


----------------------------------------------------------------------------------------------------------------------------------------------
                                               -- ===  11: Scripts === --
----------------------------------------------------------------------------------------------------------------------------------------------

Tab11:AddSection({

    Name = "Scripts"

})

Tab11:AddSection({ "" })

Tab11:AddButton({
    Name = "Script extra 1",
    Callback = function()
        loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/qehrlb7Oh8oLOgu3/raw"))()
    end
})

Tab11:AddSection({ "" })

Tab11:AddButton({
    Name = "Script extra 2",
    Callback = function()
        loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/Ea8M7i7d78gC97Q8/raw"))()
    end
})

Tab11:AddSection({ "" })
Tab11:AddButton({
    Name = "Script Drone",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BRENOPOOF/drone/refs/heads/main/Main.txt"))()
    end
})

-----------------------------------------------------------------------------------------------------------------------------------------
                                          -- ===  12: Teleporte === --
-----------------------------------------------------------------------------------------------------------------------------------------




-- Tab12: Teleportes

local teleportPlayer = game.Players.LocalPlayer
local teleportLocation = "Local 1" -- Valor padrão

local locations = {
    ["Local 1"] = Vector3.new(-348.64, 65.94, -458.08),
    ["Local 2"] = Vector3.new(-26.17, 3.48, -0.93),
    ["Local 3"] = Vector3.new(1.99, 3.32, 236.65),
    ["Local 4"] = Vector3.new(-303.2, 3.40, 13.74),
    ["Local 5"] = Vector3.new(-354.65, 7.32, -102.16),
    ["Local 6"] = Vector3.new(-766.41, 2.92, -61.10),
    ["Local 7"] = Vector3.new(16.31, 3.32, -107.07),
    ["Local 8"] = Vector3.new(151.05, 3.52, -190.64),
    ["Local 9"] = Vector3.new(290.23, 4.32, 42.57),
    ["Local 10"] = Vector3.new(159.10, 3.32, 164.97),
    ["Local 11"] = Vector3.new(55.69, 2.94, -1403.60),
    ["Local 12"] = Vector3.new(42.39, 2.94, 1336.14)
}

Tab12:AddDropdown({
    Name = "Selecionar local",
    Description = "Escolha um local para teleportar",
    Default = teleportLocation,
    Multi = false,
    Options = {
        "Local 1",
        "Local 2",
        "Local 3",
        "Local 4",
        "Local 5",
        "Local 6",
        "Local 7",
        "Local 8",
        "Local 9",
        "Local 10",
        "Local 11",
        "Local 12"
    },
    Callback = function(value)
        teleportLocation = value
    end
})

Tab12:AddButton({
    Name = "Teleportar",
    Description = "Ir para o local selecionado",
    Callback = function()
        if teleportPlayer.Character and teleportPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = teleportPlayer.Character.HumanoidRootPart
            local humanoid = teleportPlayer.Character:FindFirstChildOfClass("Humanoid")
            local pos = locations[teleportLocation]
            if pos then
                pcall(function()
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        humanoid.WalkSpeed = 0
                    end
                    humanoidRootPart.Anchored = true
                    humanoidRootPart.CFrame = CFrame.new(pos)
                    task.wait(0.4)
                    humanoidRootPart.Anchored = false
                    if humanoid then
                        humanoid.WalkSpeed = 16
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
        end
    end
})

-----------------------------------------------------------------------------------------------------------------------------------------
                                          -- ===  13: Proteção === --
-----------------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local protections = {
    Canoe = false,
    Jet = false,
    Heli = false,
    Ball = false,
    Sit = false
}

task.spawn(function()
    while true do

        local char = LocalPlayer.Character
        local workspaceCom = Workspace:FindFirstChild("WorkspaceCom")

        if workspaceCom then

            -- Anti Canoe Fling
            if protections.Canoe then
                local canoeFolder = workspaceCom:FindFirstChild("001_CanoeStorage")
                if canoeFolder then
                    for _, canoe in ipairs(canoeFolder:GetChildren()) do
                        local owner = canoe:FindFirstChild("Owner")
                        if not owner or owner.Value ~= LocalPlayer then
                            canoe:Destroy()
                        end
                    end
                end
            end

            -- Anti Jet Fling
            if protections.Jet then
                local airport = workspaceCom:FindFirstChild("001_Airport")
                if airport then
                    local hanger = airport:FindFirstChild("AirportHanger")
                    if hanger then
                        local jetStorage = hanger:FindFirstChild("001_JetStorage")
                        if jetStorage then
                            local jetFolder = jetStorage:FindFirstChild("JetAirport")
                            if jetFolder then
                                for _, jet in ipairs(jetFolder:GetChildren()) do
                                    if jet.Name ~= LocalPlayer.Name then
                                        jet:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- Anti Helicopter Fling
            if protections.Heli then
                local heliStorage = workspaceCom:FindFirstChild("001_HeliStorage")
                if heliStorage then
                    local heliFolder = heliStorage:FindFirstChild("PoliceStationHeli")
                    if heliFolder then
                        for _, heli in ipairs(heliFolder:GetChildren()) do
                            if heli.Name ~= LocalPlayer.Name then
                                heli:Destroy()
                            end
                        end
                    end
                end
            end

            -- Anti Ball Fling
            if protections.Ball then
                local ballFolder = workspaceCom:FindFirstChild("001_SoccerBalls")
                if ballFolder then
                    for _, ball in ipairs(ballFolder:GetChildren()) do
                        ball:Destroy()
                    end
                end
            end

        end

        -- Anti Sit
        if protections.Sit and char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateAtivado(Enum.HumanoidStateType.Seated, false)

                if humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end

        task.wait(0.2)

    end
end)

-- Toggles

Tab13:AddToggle({
    Name = "Proteção contra Fling — Bola",
    Default = false,
    Callback = function(value)
        protections.Canoe = value
    end
})

Tab13:AddToggle({
    Name = "Proteção    Fling",
    Default = false,
    Callback = function(value)
        protections.Jet = value
    end
})

Tab13:AddToggle({
    Name = "Proteção    Fling",
    Default = false,
    Callback = function(value)
        protections.Heli = value
    end
})

Tab13:AddToggle({
    Name = "Proteção    Fling",
    Default = false,
    Callback = function(value)
        protections.Ball = value
    end
})

Tab13:AddToggle({
    Name = "Proteção Anti-Sentar",
    Default = false,
    Callback = function(value)
        protections.Sit = value
    end
})

-- Cat Hub | Cat Hub-- =========================================================================
-- CAT HUB ADMIN — PAINEL ADM SEPARADO
-- ================================================================
-- ADIÇÕES:
-- • Verificar Users do Cat Hub
-- • Tag Todos / Untag Todos
-- • Fire / Float / Ragdoll / UnRagdoll / Freeze / Bring
-- • Seleção de jogador incluindo o próprio usuário
-- • Aba TERROR com Jumpscare 1-4
--
-- As ações abaixo são feitas pelo cliente. Para afetarem/replicarem
-- para todos os jogadores em um jogo próprio, o servidor deve autorizar
-- as ações através de RemoteEvent/RemoteFunction.
-- ================================================================

task.spawn(function()
    task.wait(2.5)

    local AdminWhitelist = {
        ["samuel_mi244"] = true,
        ["v7z_0"] = true,
        ["roblox_user_5530552598"] = true,
        ["031_ruan2"] = true,
    }

    if not AdminWhitelist[player.Name] then
        return
    end

    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
        ))()
    end)

    if not success or not WindUI then
        warn("CAT HUB ADMIN: não foi possível carregar o WindUI.")
        return
    end

    local AdminWindow = WindUI:CreateWindow({
        Title = "CAT HUB • ADMIN",
        Author = "Vinícius Gabriel",
        Size = UDim2.fromOffset(580, 460),
        Theme = "Dark",
        Transparent = true
    })

    -- =========================================================
    -- UTILITÁRIOS
    -- =========================================================

    local function notify(title, content, duration)
        WindUI:Notify({
            Title = title or "CAT HUB",
            Content = content or "",
            Duration = duration or 3
        })
    end

    local function getPlayerList(includeSelf)
        local list = {}

        for _, p in ipairs(Players:GetPlayers()) do
            if includeSelf or p ~= player then
                table.insert(list, p.Name)
            end
        end

        table.sort(list, function(a, b)
            if a == player.Name then return true end
            if b == player.Name then return false end
            return a:lower() < b:lower()
        end)

        return list
    end

    local function findTarget(name)
        if not name then
            notify("CAT HUB • ADMIN", "Selecione um jogador primeiro!", 4)
            return nil
        end

        local target = Players:FindFirstChild(name)
        if not target then
            notify("CAT HUB • ADMIN", "Jogador não encontrado.", 4)
            return nil
        end

        return target
    end

    local function getRoot(target)
        return target
            and target.Character
            and target.Character:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid(target)
        return target
            and target.Character
            and target.Character:FindFirstChildOfClass("Humanoid")
    end

    -- =========================================================
    -- ABA 1 — ADMIN
    -- =========================================================

    local AdminTab = AdminWindow:Tab({
        Title = "Funções do Administrador",
        Icon = "users"
    })

    local adminTargetName = player.Name
    local adminPlayerNames = getPlayerList(true)

    local AdminDropdown = AdminTab:Dropdown({
        Title = "Selecionar jogador",
        Values = adminPlayerNames,
        Multi = false,
        Default = player.Name,

        Callback = function(Value)
            adminTargetName = Value
        end
    })

    local function updateAdminList()
        adminPlayerNames = getPlayerList(true)

        if adminTargetName and not Players:FindFirstChild(adminTargetName) then
            adminTargetName = player.Name
        end

        pcall(function()
            AdminDropdown:Refresh(adminPlayerNames)
        end)
    end

    Players.PlayerAdded:Connect(function()
        task.wait(0.25)
        updateAdminList()
    end)

    Players.PlayerRemoving:Connect(function()
        task.wait(0.25)
        updateAdminList()
    end)

    -- =========================================================
    -- VERIFICAR USERS CAT HUB
    -- =========================================================

    local HubTagName = "CatHubDonoTag"
    local GlobalTagName = "CatHubGlobalTag"

    local function playerHasCatHubTag(target)
        if not target or not target.Character then
            return false
        end

        local head = target.Character:FindFirstChild("Head")
        if not head then
            return false
        end

        return head:FindFirstChild(GlobalTagName) ~= nil
            or head:FindFirstChild(HubTagName) ~= nil
    end

    AdminTab:Button({
        Title = "🔎 Verificar Users Cat Hub",
        Callback = function()
            updateAdminList()

            local total = 0
            local using = 0
            local names = {}

            for _, target in ipairs(Players:GetPlayers()) do
                total += 1

                if target == player or playerHasCatHubTag(target) then
                    using += 1
                    table.insert(names, target.Name)
                end
            end

            local text = ("Cat Hub detectados: %d/%d"):format(using, total)

            if #names > 0 then
                text = text .. "\n" .. table.concat(names, ", ")
            end

            notify("CAT HUB • VERIFICAR USERS", text, 6)
        end
    })

    -- =========================================================
    -- TAG TODOS
    -- =========================================================

    local globalTagEnabled = false

    local function applyGlobalTag(target)
        if not target or not target.Character then
            return false
        end

        local head = target.Character:FindFirstChild("Head")
        if not head then
            return false
        end

        local old = head:FindFirstChild(GlobalTagName)
        if old then
            old:Destroy()
        end

        local gui = Instance.new("BillboardGui")
        gui.Name = GlobalTagName
        gui.Adornee = head
        gui.AlwaysOnTop = true
        gui.Size = UDim2.fromOffset(220, 38)
        gui.StudsOffset = Vector3.new(0, 3.25, 0)
        gui.MaxDistance = 300
        gui.Parent = head

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.GothamBold
        label.Text = "CAT HUB • " .. player.Name
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Parent = gui

        return true
    end

    local function removeGlobalTag(target)
        if not target or not target.Character then
            return
        end

        local head = target.Character:FindFirstChild("Head")
        if not head then
            return
        end

        local tag = head:FindFirstChild(GlobalTagName)
        if tag then
            tag:Destroy()
        end
    end

    AdminTab:Button({
        Title = "🏷️ Tag Todos",
        Callback = function()
            globalTagEnabled = true
            local count = 0

            for _, target in ipairs(Players:GetPlayers()) do
                if applyGlobalTag(target) then
                    count += 1
                end
            end

            notify(
                "CAT HUB • TAG",
                "Sua tag foi colocada em " .. tostring(count) .. " jogador(es).",
                4
            )
        end
    })

    AdminTab:Button({
        Title = "🏷️ Untag Todos",
        Callback = function()
            globalTagEnabled = false
            for _, target in ipairs(Players:GetPlayers()) do
                removeGlobalTag(target)
            end

            notify(
                "CAT HUB • TAG",
                "Sua tag foi desativada para todos.",
                4
            )
        end
    })

    -- Reaplica a tag no respawn sem alterar a tag DONO existente.
    local function bindGlobalTag(target)
        target.CharacterAdded:Connect(function()
            task.wait(0.7)
            if globalTagEnabled then
                applyGlobalTag(target)
            end
        end)
    end

    for _, target in ipairs(Players:GetPlayers()) do
        bindGlobalTag(target)
    end

    Players.PlayerAdded:Connect(bindGlobalTag)

    -- =========================================================
    -- FIRE
    -- =========================================================

    AdminTab:Button({
        Title = "🔥 Fire",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target or not target.Character then return end

            local root = getRoot(target)
            if not root then
                notify("Fire", "Personagem sem HumanoidRootPart.", 3)
                return
            end

            local old = root:FindFirstChild("CatHubFire")
            if old then old:Destroy() end

            local fire = Instance.new("Fire")
            fire.Name = "CatHubFire"
            fire.Size = 8
            fire.Heat = 8
            fire.Parent = root

            notify("🔥 Fire", "Fire executado em " .. target.Name .. ".", 3)
        end
    })

    -- =========================================================
    -- FLOAT
    -- =========================================================

    AdminTab:Button({
        Title = "🪶 Float",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target or not target.Character then return end

            local root = getRoot(target)
            if not root then return end

            local old = root:FindFirstChild("CatHubFloat")
            if old then old:Destroy() end

            local body = Instance.new("BodyPosition")
            body.Name = "CatHubFloat"
            body.MaxForce = Vector3.new(0, math.huge, 0)
            body.P = 9000
            body.D = 900
            body.Position = root.Position + Vector3.new(0, 7, 0)
            body.Parent = root

            notify("🪶 Float", target.Name .. " está flutuando.", 3)
        end
    })

    -- =========================================================
    -- RAGDOLL
    -- =========================================================

    AdminTab:Button({
        Title = "🫨 Ragdoll",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target or not target.Character then return end

            local humanoid = getHumanoid(target)
            if not humanoid then return end

            humanoid.PlatformStand = true
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end)

            notify("🫨 Ragdoll", "Ragdoll executado em " .. target.Name .. ".", 3)
        end
    })

    -- =========================================================
    -- UNRAGDOLL
    -- =========================================================

    AdminTab:Button({
        Title = "🧍 UnRagdoll",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target or not target.Character then return end

            local humanoid = getHumanoid(target)
            if not humanoid then return end

            humanoid.PlatformStand = false

            local root = getRoot(target)
            if root then
                local float = root:FindFirstChild("CatHubFloat")
                if float then
                    float:Destroy()
                end
            end

            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)

            notify("🧍 UnRagdoll", target.Name .. " voltou ao normal.", 3)
        end
    })

    -- =========================================================
    -- FREEZE
    -- =========================================================

    AdminTab:Button({
        Title = "🧊 Freeze",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target then return end

            local root = getRoot(target)
            if not root then
                notify("Freeze", "Personagem não encontrado.", 3)
                return
            end

            root.Anchored = true

            notify("🧊 Freeze", target.Name .. " foi congelado.", 3)
        end
    })

    -- =========================================================
    -- BRING
    -- =========================================================

    AdminTab:Button({
        Title = "📍 Bring",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target then return end

            local myRoot = getRoot(player)
            local targetRoot = getRoot(target)

            if not myRoot or not targetRoot then
                notify("Bring", "Seu personagem ou o alvo não foi encontrado.", 3)
                return
            end

            targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)

            notify("📍 Bring", target.Name .. " foi trazido até você.", 3)
        end
    })

    -- =========================================================
    -- KILL / RESET — MANTIDO
    -- =========================================================

    AdminTab:Button({
        Title = "Eliminar — Resetar Alvo",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target then return end

            local humanoid = getHumanoid(target)

            if humanoid then
                humanoid.Health = 0
                notify("Eliminar", target.Name .. " foi resetado.", 3)
            end
        end
    })

    -- =========================================================
    -- KICK — MANTIDO
    -- =========================================================

    AdminTab:Button({
        Title = "Expulsar — Kickar Jogador",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target then return end

            local ok = pcall(function()
                target:Kick("Você foi expulso por um administrador.")
            end)

            if ok then
                notify("Expulsar", target.Name .. " foi expulso.", 3)
            else
                notify(
                    "Expulsar",
                    "O Kick de outro jogador precisa de autoridade do servidor.",
                    4
                )
            end
        end
    })

    -- =========================================================
    -- JAIL — MANTIDO
    -- =========================================================

    AdminTab:Button({
        Title = "Prender — Colocar na Prisão",
        Callback = function()
            local target = findTarget(adminTargetName)
            if not target then return end

            local root = getRoot(target)
            if not root then
                notify("Prender", "Jogador sem personagem.", 3)
                return
            end

            local jailName = "KS_Jail_" .. target.Name
            local oldJail = Workspace:FindFirstChild(jailName)
            if oldJail then
                oldJail:Destroy()
            end

            local pos = root.Position
            local jailFolder = Instance.new("Folder")
            jailFolder.Name = jailName
            jailFolder.Parent = Workspace

            local function wall(cf, size)
                local part = Instance.new("Part")
                part.Name = "JailPart"
                part.Size = size
                part.CFrame = cf
                part.Anchored = true
                part.CanCollide = true
                part.Transparency = 0.4
                part.Material = Enum.Material.Glass
                part.Color = Color3.fromRGB(20, 20, 20)
                part.Parent = jailFolder
            end

            wall(CFrame.new(pos + Vector3.new(0, 0, 3)), Vector3.new(5, 7, 0.6))
            wall(CFrame.new(pos + Vector3.new(0, 0, -3)), Vector3.new(5, 7, 0.6))
            wall(CFrame.new(pos + Vector3.new(3, 0, 0)), Vector3.new(0.6, 7, 5))
            wall(CFrame.new(pos + Vector3.new(-3, 0, 0)), Vector3.new(0.6, 7, 5))
            wall(CFrame.new(pos + Vector3.new(0, 3.5, 0)), Vector3.new(5, 0.6, 5))
            wall(CFrame.new(pos + Vector3.new(0, -3.5, 0)), Vector3.new(5, 0.6, 5))

            notify("Prender", target.Name .. " foi preso.", 3)
        end
    })

    AdminTab:Button({
        Title = "Libertar — Remover Prisões",
        Callback = function()
            local removed = 0

            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Folder") and obj.Name:sub(1, 8) == "KS_Jail_" then
                    obj:Destroy()
                    removed += 1
                end
            end

            notify("Libertar", "Jaulas removidas: " .. tostring(removed), 3)
        end
    })

    AdminTab:Button({
        Title = "🔄 Atualizar Lista de Jogadores",
        Callback = function()
            updateAdminList()
            notify("CAT HUB • ADMIN", "Lista de jogadores atualizada.", 3)
        end
    })

    -- =========================================================
    -- ABA 2 — TERROR
    -- =========================================================

    local TerrorTab = AdminWindow:Tab({
        Title = "👹 TERROR",
        Icon = "skull"
    })

    local terrorTargetName = player.Name
    local terrorNames = getPlayerList(true)

    local TerrorDropdown = TerrorTab:Dropdown({
        Title = "Selecionar jogador",
        Values = terrorNames,
        Multi = false,
        Default = player.Name,

        Callback = function(Value)
            terrorTargetName = Value
        end
    })

    local function updateTerrorList()
        terrorNames = getPlayerList(true)

        if terrorTargetName and not Players:FindFirstChild(terrorTargetName) then
            terrorTargetName = player.Name
        end

        pcall(function()
            TerrorDropdown:Refresh(terrorNames)
        end)
    end

    Players.PlayerAdded:Connect(function()
        task.wait(0.25)
        updateTerrorList()
    end)

    Players.PlayerRemoving:Connect(function()
        task.wait(0.25)
        updateTerrorList()
    end)

    -- =========================================================
    -- JUMPSCARE — TESTE NO JOGADOR SELECIONADO
    -- =========================================================

    local jumpscareGui
    local jumpscareToken = 0

    local function stopJumpscare()
        jumpscareToken += 1

        if jumpscareGui then
            jumpscareGui:Destroy()
            jumpscareGui = nil
        end
    end

    local function jumpscareStyle(style)
        stopJumpscare()

        -- O efeito visual é exibido localmente.
        -- Para assustar outro jogador de verdade, o servidor do seu jogo
        -- deve receber a ordem e mandar o efeito ao cliente desse jogador.
        local target = findTarget(terrorTargetName)
        if not target then return end

        if target ~= player then
            notify(
                "👹 Jumpscare",
                "Para testar aqui, selecione seu próprio nome. Efeito em outro jogador requer o servidor.",
                4
            )
            return
        end

        local myGui = PlayerGui
        if not myGui then return end

        jumpscareToken += 1
        local token = jumpscareToken

        local gui = Instance.new("ScreenGui")
        gui.Name = "CatHubJumpscare"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999999
        gui.Parent = myGui
        jumpscareGui = gui

        local dark = Instance.new("Frame")
        dark.Size = UDim2.fromScale(1, 1)
        dark.BorderSizePixel = 0
        dark.BackgroundColor3 = style.bg
        dark.BackgroundTransparency = 0.04
        dark.Parent = gui

        local monster = Instance.new("TextLabel")
        monster.BackgroundTransparency = 1
        monster.AnchorPoint = Vector2.new(0.5, 0.5)
        monster.Position = UDim2.fromScale(0.5, 0.52)
        monster.Size = UDim2.fromScale(0.9, 0.78)
        monster.Font = Enum.Font.GothamBlack
        monster.Text = style.monster
        monster.TextColor3 = style.face
        monster.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        monster.TextStrokeTransparency = 0
        monster.TextScaled = true
        monster.Parent = gui

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.AnchorPoint = Vector2.new(0.5, 0)
        title.Position = UDim2.fromScale(0.5, 0.035)
        title.Size = UDim2.fromScale(0.92, 0.12)
        title.Font = Enum.Font.GothamBlack
        title.Text = style.title
        title.TextColor3 = style.face
        title.TextStrokeTransparency = 0
        title.TextScaled = true
        title.Parent = gui

        task.spawn(function()
            local started = os.clock()

            while gui.Parent
                and jumpscareToken == token
                and os.clock() - started < style.duration do

                local x = math.random(-45, 45)
                local y = math.random(-35, 35)
                local scale = 0.78 + math.random() * 0.28

                monster.Position = UDim2.new(0.5, x, 0.52, y)
                monster.Size = UDim2.fromScale(scale, scale * 0.86)
                monster.Rotation = math.random(-7, 7)

                if style.flash then
                    dark.BackgroundTransparency = math.random(0, 4) / 10
                end

                task.wait(0.045)
            end

            if jumpscareToken == token and gui.Parent then
                gui:Destroy()
                jumpscareGui = nil
            end
        end)
    end

    TerrorTab:Button({
        Title = "😱 Jumpscare 1",
        Callback = function()
            jumpscareStyle({
                bg = Color3.fromRGB(3, 3, 3),
                face = Color3.fromRGB(240, 240, 240),
                monster = "╔═══╗\n║ ◉ ◉ ║\n║  ▽  ║\n╚═══╝",
                title = "ELE ESTÁ ATRÁS DE VOCÊ",
                duration = 2.0,
                flash = true
            })
        end
    })

    TerrorTab:Button({
        Title = "👁️ Jumpscare 2",
        Callback = function()
            jumpscareStyle({
                bg = Color3.fromRGB(10, 0, 16),
                face = Color3.fromRGB(180, 120, 255),
                monster = "◉       ◉\n\n    ▽\n\n  ╱━━━╲",
                title = "NÃO OLHE PARA TRÁS",
                duration = 2.3,
                flash = true
            })
        end
    })

    TerrorTab:Button({
        Title = "👹 Jumpscare 3",
        Callback = function()
            jumpscareStyle({
                bg = Color3.fromRGB(22, 0, 0),
                face = Color3.fromRGB(255, 90, 90),
                monster = "████████\n██ ◉ ◉ ██\n██  ▽  ██\n████████",
                title = "CAT HUB • TERROR",
                duration = 2.6,
                flash = true
            })
        end
    })

    TerrorTab:Button({
        Title = "👾 Jumpscare 4",
        Callback = function()
            jumpscareStyle({
                bg = Color3.fromRGB(0, 0, 0),
                face = Color3.fromRGB(255, 255, 255),
                monster = "      ╱╲\n  ╱╲ ███ ╱╲\n ╱  █ ◉ █  ╲\n     █ ▽ █\n   ╱███████╲",
                title = "VOCÊ FOI ENCONTRADO",
                duration = 3.0,
                flash = true
            })
        end
    })

    TerrorTab:Button({
        Title = "✖️ Parar Jumpscare",
        Callback = function()
            stopJumpscare()
            notify("CAT HUB • TERROR", "Jumpscare encerrado.", 2)
        end
    })

    TerrorTab:Button({
        Title = "🔄 Atualizar Jogadores",
        Callback = function()
            updateTerrorList()
            notify("CAT HUB • TERROR", "Lista de jogadores atualizada.", 3)
        end
    })

    notify(
        "CAT HUB • ADMIN",
        "Painel Admin carregado com Verificar Users, Tag, controles e Terror.",
        5
    )
end)

-- CAT HUB • TAG DONO
do
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function aplicarTagDono(character)
        if not character then return end
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if not head then return end

        local antigo = head:FindFirstChild("CatHubDonoTag")
        if antigo then antigo:Destroy() end

        local gui = Instance.new("BillboardGui")
        gui.Name = "CatHubDonoTag"
        gui.Adornee = head
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 120, 0, 32)
        gui.StudsOffset = Vector3.new(0, 2.8, 0)
        gui.MaxDistance = 100
        gui.Parent = head

        local label = Instance.new("TextLabel")
        label.Name = "Dono"
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.GothamBold
        label.Text = "DONO"
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.fromRGB(255, 215, 0)
        label.Parent = gui
    end

    if LocalPlayer and LocalPlayer.Name == "031_ruan2" then
        if LocalPlayer.Character then
            task.defer(aplicarTagDono, LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            aplicarTagDono(character)
        end)
    end
end
