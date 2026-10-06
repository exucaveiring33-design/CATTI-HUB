-- ================================================================
-- CAT HUB • TAG DONO PREMIUM + AVATAR
--
-- Este bloco substitui a antiga seção "CAT HUB • TAG DONO" do arquivo.
-- A imagem é obtida automaticamente do avatar atual do LocalPlayer.
-- Dono autorizado: 031_ruan2
-- ================================================================
do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer

    local DONO_USER_NAME = "031_ruan2"

    local function aplicarTagDono(character)
        if not character then return end

        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if not head then return end

        local antigo = head:FindFirstChild("CatHubDonoTag")
        if antigo then
            antigo:Destroy()
        end

        local gui = Instance.new("BillboardGui")
        gui.Name = "CatHubDonoTag"
        gui.Adornee = head
        gui.AlwaysOnTop = true
        gui.Size = UDim2.new(0, 210, 0, 72)
        gui.StudsOffset = Vector3.new(0, 3.35, 0)
        gui.MaxDistance = 150
        gui.ResetOnSpawn = false
        gui.Parent = head

        -- Card principal
        local card = Instance.new("Frame")
        card.Name = "DonoCard"
        card.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.Size = UDim2.fromScale(1, 1)
        card.Parent = gui

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 14)
        cardCorner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Name = "GoldStroke"
        stroke.Color = Color3.fromRGB(255, 205, 65)
        stroke.Thickness = 2
        stroke.Transparency = 0.05
        stroke.Parent = card

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 24, 12)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 17)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 8))
        })
        gradient.Rotation = 25
        gradient.Parent = card

        -- Avatar real do Roblox
        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        avatar.BorderSizePixel = 0
        avatar.Position = UDim2.new(0, 7, 0.5, -26)
        avatar.Size = UDim2.new(0, 52, 0, 52)
        avatar.Image = ""
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.Parent = card

        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatar

        local avatarStroke = Instance.new("UIStroke")
        avatarStroke.Color = Color3.fromRGB(255, 215, 80)
        avatarStroke.Thickness = 2
        avatarStroke.Parent = avatar

        -- Carrega o retrato do avatar atual
        task.spawn(function()
            local ok, content = pcall(function()
                local image, ready = Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size150x150
                )
                return image, ready
            end)

            if ok and content then
                avatar.Image = content
            end
        end)

        -- Coroa
        local crown = Instance.new("TextLabel")
        crown.Name = "Crown"
        crown.BackgroundTransparency = 1
        crown.Position = UDim2.new(0, 4, 0, -13)
        crown.Size = UDim2.new(0, 58, 0, 26)
        crown.Font = Enum.Font.GothamBlack
        crown.Text = "♛"
        crown.TextColor3 = Color3.fromRGB(255, 215, 65)
        crown.TextScaled = true
        crown.TextStrokeColor3 = Color3.fromRGB(60, 40, 0)
        crown.TextStrokeTransparency = 0.2
        crown.Parent = card

        -- Título
        local title = Instance.new("TextLabel")
        title.Name = "Dono"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 68, 0, 10)
        title.Size = UDim2.new(1, -76, 0, 28)
        title.Font = Enum.Font.GothamBlack
        title.Text = "DONO"
        title.TextColor3 = Color3.fromRGB(255, 220, 80)
        title.TextScaled = true
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        title.TextStrokeTransparency = 0.15
        title.Parent = card

        -- Nome do dono
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "OwnerName"
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 69, 0, 39)
        nameLabel.Size = UDim2.new(1, -78, 0, 20)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.Text = "@" .. LocalPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
        nameLabel.TextScaled = true
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = card

        -- Pequeno selo
        local verified = Instance.new("TextLabel")
        verified.Name = "Verified"
        verified.BackgroundTransparency = 1
        verified.Position = UDim2.new(1, -28, 0, 12)
        verified.Size = UDim2.new(0, 20, 0, 20)
        verified.Font = Enum.Font.GothamBlack
        verified.Text = "✓"
        verified.TextColor3 = Color3.fromRGB(255, 215, 70)
        verified.TextScaled = true
        verified.Parent = card

        -- Brilho sutil no contorno
        task.spawn(function()
            while gui.Parent do
                local tween1 = TweenService:Create(
                    stroke,
                    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = 0.35}
                )
                tween1:Play()
                tween1.Completed:Wait()

                if not gui.Parent then break end

                local tween2 = TweenService:Create(
                    stroke,
                    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = 0.02}
                )
                tween2:Play()
                tween2.Completed:Wait()
            end
        end)
    end

    if LocalPlayer and LocalPlayer.Name == DONO_USER_NAME then
        if LocalPlayer.Character then
            task.defer(aplicarTagDono, LocalPlayer.Character)
        end

        LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            aplicarTagDono(character)
        end)
    end
end
