local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ==========================================
-- ЧАСТЬ 1: ТАЙМЕР ДЛЯ БАРЬЕРОВ (15 СЕКУНД)
-- ==========================================
local barrierTimers = {}

local function createBarrierGui()
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MyBarrierTimer"
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
	textLabel.Text = "15"
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

	local gui, label = createBarrierGui()
	gui.Adornee = anchorPart
	
	local timeLeft = 15
	
	local connection = RunService.Heartbeat:Connect(function(dt)
		if not barrier or not barrier.Parent then
			gui:Destroy()
			connection:Disconnect()
			barrierTimers[barrier] = nil
			return
		end
		
		timeLeft -= dt
		local num = math.ceil(timeLeft)
		
		if num >= 1 and num <= 15 then
			label.Text = tostring(num)
			if num <= 3 then
				label.TextColor3 = Color3.fromRGB(255, 50, 50)
			else
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end)
	
	barrierTimers[barrier] = {gui = gui, connection = connection}
end

-- Поток для барьеров
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
				if data.gui then data.gui:Destroy() end
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
		
		if num >= 1 and num <= 5 then
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

-- Поток для порталов
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
