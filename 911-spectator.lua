-- ✅ Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- ✅ UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPtoolsGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- ✅ Style helper
local function makeButton(name, size, pos, text, color)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = size
	btn.Position = pos
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = color
	btn.AutoButtonColor = true
	btn.Parent = screenGui

	btn.BackgroundTransparency = 0.1
	btn.BorderSizePixel = 0
	btn.ClipsDescendants = true
	btn.TextScaled = true
	btn.AnchorPoint = Vector2.new(0.5,0.5)

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(1,0)

	local shadow = Instance.new("UIStroke", btn)
	shadow.Thickness = 1.5
	shadow.Color = Color3.fromRGB(40,40,40)

	return btn
end
local mainButton = makeButton("MainTP", UDim2.new(0,45,0,45), UDim2.new(0,80,0.3,0), "TP", Color3.fromRGB(0,120,255))
mainButton.Active = true
mainButton.Draggable = true
local frButton = makeButton("FR", UDim2.new(0,40,0,40), UDim2.new(0,80,0.38,0), "FR", Color3.fromRGB(0,200,100))
local tpButton = makeButton("TPto", UDim2.new(0,40,0,40), UDim2.new(0,80,0.46,0), "TP", Color3.fromRGB(200,100,0))
frButton.Visible = false
tpButton.Visible = false
local upButton = makeButton("Up", UDim2.new(0,40,0,40), UDim2.new(1,-70,1,-120), "+", Color3.fromRGB(0,180,0))
local downButton = makeButton("Down", UDim2.new(0,40,0,40), UDim2.new(1,-70,1,-70), "-", Color3.fromRGB(180,0,0))
upButton.Visible = false
downButton.Visible = false
local controllingBall = false
local ball
local ballSpeed = 60
local verticalMove = 0
local function spawnBall()
	if ball then ball:Destroy() end
	ball = Instance.new("Part")
	ball.Shape = Enum.PartType.Ball
	ball.Size = Vector3.new(2,2,2)
	ball.Color = Color3.fromRGB(255,255,255)
	ball.Material = Enum.Material.Neon
	ball.Anchored = false
	ball.CanCollide = false
	ball.Position = hrp.Position + Vector3.new(0,3,0)
	ball.Parent = workspace

	local att = Instance.new("Attachment", ball)
	local lv = Instance.new("LinearVelocity", ball)
	lv.Attachment0 = att
	lv.MaxForce = 1e9
	lv.VectorVelocity = Vector3.zero
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
end
mainButton.MouseButton1Click:Connect(function()
	frButton.Visible = not frButton.Visible
	tpButton.Visible = frButton.Visible
end)
frButton.MouseButton1Click:Connect(function()
	controllingBall = not controllingBall
	if controllingBall then
		spawnBall()
		Camera.CameraSubject = ball
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		upButton.Visible = true
		downButton.Visible = true
	else
		if ball then ball:Destroy() end
		Camera.CameraSubject = humanoid
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
		upButton.Visible = false
		downButton.Visible = false
		verticalMove = 0
	end
end)
tpButton.MouseButton1Click:Connect(function()
	if ball and ball.Parent then
		hrp.CFrame = CFrame.new(ball.Position)
	end
end)
upButton.MouseButton1Down:Connect(function() verticalMove = 1 end)
upButton.MouseButton1Up:Connect(function() verticalMove = 0 end)
downButton.MouseButton1Down:Connect(function() verticalMove = -1 end)
downButton.MouseButton1Up:Connect(function() verticalMove = 0 end)
RunService.RenderStepped:Connect(function()
	if controllingBall and ball and ball:FindFirstChild("LinearVelocity") then
		local moveDir = humanoid.MoveDirection
		local horizontal = Vector3.new(moveDir.X,0,moveDir.Z)
		local vertical = Vector3.new(0,verticalMove,0)
		local final = horizontal + vertical

		if final.Magnitude > 0 then
			ball.LinearVelocity.VectorVelocity = final.Unit * ballSpeed
		else
			ball.LinearVelocity.VectorVelocity = Vector3.zero
		end
	end
end)
