local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ==========================================
-- ЧАСТЬ 1: ТАЙМЕРЫ ДЛЯ БАРЬЕРОВ (16 и 25 СЕКУНД)
-- ==========================================
local barrierTimers = {}

local function createBarrierGui1()
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MyBarrierTimer1"
	billboard.Size = UDim2.new(0, 40, 0, 20) 
	-- Высота первого таймера (16)
	billboard.StudsOffset = Vector3.new(0, 5, 0) 
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0) 
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.SizeOffset = Vector2.new(0, 0) 
	billboard.Parent = Workspace

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TimerText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "16"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.TextScaled = false
	textLabel.TextSize = 20 
	textLabel.Font = Enum.Font.RobotoMono
	textLabel.Parent = billboard

	return billboard, textLabel
end

local function createBarrierGui2()
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MyBarrierTimer2"
	billboard.Size = UDim2.new(0, 40, 0, 20) 
	-- Высота второго таймера (25), чуть выше первого
	billboard.StudsOffset = Vector3.new(0, 7.5, 0) 
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0) 
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.SizeOffset = Vector2.new(0, 0) 
	billboard.Parent = Workspace

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TimerText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "25"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.TextScaled = false
	textLabel.TextSize = 20 
	textLabel.Font = Enum.Font.RobotoMono
	textLabel.Parent = billboard

	return billboard, textLabel
end

local function attachBarrierTimer(barrier)
	-- Привязываемся строго к детали Main (она по центру)
	local anchorPart = barrier:FindFirstChild("Main")
	
	if not anchorPart then
		for _, child in pairs(barrier:GetChildren()) do
			if child:IsA("BasePart") then
				anchorPart = child
				break
			end
		end
	end
	
	if not anchorPart then return end

	local gui1, label1 = createBarrierGui1()
	gui1.Adornee = anchorPart
	
	local gui2, label2 = createBarrierGui2()
	gui2.Adornee = anchorPart
	
	local timeLeft1 = 16
	local timeLeft2 = 25
	
	local connection = RunService.Heartbeat:Connect(function(dt)
		if not barrier or not barrier.Parent then
			gui1:Destroy()
			gui2:Destroy()
			connection:Disconnect()
			barrierTimers[barrier] = nil
			return
		end
		
		timeLeft1 -= dt
		local num1 = math.ceil(timeLeft1)
		
		if num1 >= 0 and num1 <= 16 then
			label1.Text = tostring(num1)
			if num1 <= 3 then
				label1.TextColor3 = Color3.fromRGB(255, 50, 50)
			else
				label1.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
		
		timeLeft2 -= dt
		local num2 = math.ceil(timeLeft2)
		
		if num2 >= 0 and num2 <= 25 then
			label2.Text = tostring(num2)
			if num2 <= 3 then
				label2.TextColor3 = Color3.fromRGB(255, 50, 50)
			else
				label2.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end)
	
	barrierTimers[barrier] = {gui1 = gui1, gui2 = gui2, connection = connection}
end

task.spawn(function()
	while true do
		task.wait(0.5)
		
		local map = Workspace:FindFirstChild("Map")
		if map then
			for _, descendant in pairs(map:GetDescendants()) do
				if descendant.Name == "Barrier" and descendant.Parent and descendant.Parent.Name == "Bottom" then
					if not barrierTimers[descendant] then
						attachBarrierTimer(descendant)
					end
				end
			end
		end
		
		for barrier, data in pairs(barrierTimers) do
			if not barrier or not barrier.Parent then
				if data.gui1 then data.gui1:Destroy() end
				if data.gui2 then data.gui2:Destroy() end
				if data.connection then data.connection:Disconnect() end
				barrierTimers[barrier] = nil
			end
		end
	end
end)


-- ==========================================
-- ЧАСТЬ 2: ТАЙМЕР ДЛЯ ПОРТАЛА (5 СЕКУНД)
-- ==========================================
local gateTimers = {}

local function createGateGui()
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MyGateTimer"
	billboard.Size = UDim2.new(0, 40, 0, 20) 
	billboard.StudsOffset = Vector3.new(0, 6, 0) 
	billboard.StudsOffsetWorldSpace = Vector3.new(0, 0, 0) 
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.SizeOffset = Vector2.new(0, 0) 
	billboard.Parent = Workspace

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TimerText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "5"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.TextScaled = false
	textLabel.TextSize = 20 
	textLabel.Font = Enum.Font.RobotoMono
	textLabel.Parent = billboard

	return billboard, textLabel
end

local function attachGateTimer(gateModel)
	local anchorPart = gateModel:FindFirstChild("gate")
	if not anchorPart then
		for _, child in pairs(gateModel:GetChildren()) do
			if child:IsA("BasePart") then
				anchorPart = child
				break
			end
		end
	end
	
	if not anchorPart then return end

	local gui, label = createGateGui()
	gui.Adornee = anchorPart
	
	local timeLeft = 5
	
	local connection = RunService.Heartbeat:Connect(function(dt)
		if not gateModel or not gateModel.Parent then
			gui:Destroy()
			connection:Disconnect()
			gateTimers[gateModel] = nil
			return
		end
		
		timeLeft -= dt
		local num = math.ceil(timeLeft)
		
		if num >= 0 and num <= 5 then
			label.Text = tostring(num)
			if num <= 3 then
				label.TextColor3 = Color3.fromRGB(255, 50, 50)
			else
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end)
	
	gateTimers[gateModel] = {gui = gui, connection = connection}
end

task.spawn(function()
	while true do
		task.wait(0.2)
		
		local gateModel = Workspace:FindFirstChild("gate")
		
		if gateModel and gateModel:IsA("Model") then
			if not gateTimers[gateModel] then
				attachGateTimer(gateModel)
			end
		end
		
		for gate, data in pairs(gateTimers) do
			if not gate or not gate.Parent then
				if data.gui then data.gui:Destroy() end
				if data.connection then data.connection:Disconnect() end
				gateTimers[gate] = nil
			end
		end
	end
end)

-------
task.spawn(function()
	while true do
		task.wait(0.5)
		
		local lobby = Workspace:FindFirstChild("Lobby")
		if lobby then
			local pumpkin = lobby:FindFirstChild("Pumpkin3")
			if pumpkin then
				local shell = pumpkin:FindFirstChild("shell")
				local inside = pumpkin:FindFirstChild("inside")
				
				if shell and shell.Transparency ~= 1 then
					shell.Transparency = 1
				end
				
				if inside and inside.Transparency ~= 1 then
					inside.Transparency = 1
				end
			end
		end
	end
end)
