local function CMSG(text)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = text,
        Font = Enum.Font.Gotham,
		Color = Color3.fromRGB(255, 255, 255),
		TextSize = 16,
	});
end

function Chat(Message)
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Message, "All")
end


local players = game:GetService("Players")
local plr = players.LocalPlayer

local function getChar()
    return plr.Character
end

local function getBp()
    return plr.Backpack
end

local function getPlr(str)
    for i,v in pairs(players:GetPlayers()) do
        if v.Name:lower():match(str) or v.DisplayName:lower():match(str) then
            return v
        end
    end
end

local netless_Y = Vector3.new(0, 26, 0)
local v3_101 = Vector3.new(1, 0, 1)
local inf = math.huge
local v3_0 = Vector3.new(0,0,0)
local function getNetlessVelocity(realPartVelocity) --edit this if you have a better netless method
    if (realPartVelocity.Y > 1) or (realPartVelocity.Y < -1) then
        return realPartVelocity * (25.1 / realPartVelocity.Y)
    end
    realPartVelocity = realPartVelocity * v3_101
    local mag = realPartVelocity.Magnitude
    if mag > 1 then
        realPartVelocity = realPartVelocity * 100 / mag
    end
    return realPartVelocity + netless_Y
end

local function align(Part0, Part1, p, r)
	Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)
    Part0.CFrame = Part1.CFrame
	local att0 = Instance.new("Attachment", Part0)
	att0.Orientation = r or v3_0
	att0.Position = v3_0
	att0.Name = "att0_" .. Part0.Name
	local att1 = Instance.new("Attachment", Part1)
	att1.Orientation = v3_0 
	att1.Position = p or v3_0
	att1.Name = "att1_" .. Part1.Name

	local apd = Instance.new("AlignPosition", att0)
	apd.ApplyAtCenterOfMass = false
	apd.MaxForce = inf
	apd.MaxVelocity = inf
	apd.ReactionForceEnabled = false
	apd.Responsiveness = 200
	apd.Attachment1 = att1
	apd.Attachment0 = att0
	apd.Name = "AlignPositionRfalse"
	apd.RigidityEnabled = false

	local ao = Instance.new("AlignOrientation", att0)
	ao.MaxAngularVelocity = inf
	ao.MaxTorque = inf
	ao.PrimaryAxisOnly = false
	ao.ReactionTorqueEnabled = false
	ao.Responsiveness = 200
	ao.Attachment1 = att1
	ao.Attachment0 = att0
	ao.RigidityEnabled = false
    
	if type(getNetlessVelocity) == "function" then
	    local realVelocity = Vector3.new(0,30,0)
        local steppedcon = game:GetService("RunService").Stepped:Connect(function()
            Part0.Velocity = realVelocity
        end)
        local heartbeatcon = game:GetService("RunService").Heartbeat:Connect(function()
            realVelocity = Part0.Velocity
            Part0.Velocity = getNetlessVelocity(realVelocity)
        end)
        Part0.Destroying:Connect(function()
            Part0 = nil
            steppedcon:Disconnect()
            heartbeatcon:Disconnect()
        end)
	end
	
    att0.Orientation = r or v3_0
	att0.Position = v3_0
	att1.Orientation = v3_0 
	att1.Position = p or v3_0
	Part0.CFrame = Part1.CFrame
end

local function attachTool(tool,cf)
    for i,v in pairs(tool:GetDescendants()) do
        if not (v:IsA("BasePart") or v:IsA("Mesh") or v:IsA("SpecialMesh")) then
            v:Destroy()
        end
    end
    local rgrip1 = Instance.new("Weld")
	rgrip1.Name = "RightGrip"
	rgrip1.Part0 = getChar()["Right Arm"]
	rgrip1.Part1 = tool.Handle
	rgrip1.C0 = cf
	rgrip1.C1 = tool.Grip
	rgrip1.Parent = getChar()["Right Arm"]
    tool.Parent = getBp()
    tool.Parent = getChar().Humanoid
    tool.Parent = getChar()
    tool.Handle:BreakJoints()
    tool.Parent = getBp()
    tool.Parent = getChar().Humanoid
    local rgrip2 = Instance.new("Weld")
	rgrip2.Name = "RightGrip"
	rgrip2.Part0 = getChar()["Right Arm"]
	rgrip2.Part1 = tool.Handle
	rgrip2.C0 = cf
	rgrip2.C1 = tool.Grip
	rgrip2.Parent = getChar()["Right Arm"]
    return rgrip2
end

local nc = false
local ncLoop
ncLoop = game:GetService("RunService").Stepped:Connect(function()
	if nc and getChar() ~= nil then
		for _, v in pairs(getChar():GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == true then
				v.CanCollide = false
			end
		end
    end
end)

local netsleepTargets = {}
local nsLoop
nsLoop = game:GetService("RunService").Stepped:Connect(function()
    if #netsleepTargets == 0 then return end
    for i,v in pairs(netsleepTargets) do
        if v.Character then
            for i,v in pairs(v.Character:GetChildren()) do
                if v:IsA("BasePart") == false and v:IsA("Accessory") == false then continue end
                if v:IsA("BasePart") then
                    sethiddenproperty(v,"NetworkIsSleeping",true)
                elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    sethiddenproperty(v.Handle,"NetworkIsSleeping",true)
                end
            end
        end
    end
end)

local cc;cc = plr.Chatted:Connect(function(msg)
    local spaceSplit = msg:split(" ")

scriptcmds = {
    --// Starting with reanimations
    ["r6"] =  function()
        CMSG(" > Making You R6!")     
	loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/CONVERTWARE/main/convertware/Reanimation/Mizt%20Reanimation.lua',true))()  
    end,
    
    ["touchfling"] =  function()
        CMSG(" > Making You TouchFling Players!")       
        loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/CONVERTWARE/main/convertware/Reanimation/Mizt%20Flings.lua',true))() 
    end,

    ["god"] =  function()
        CMSG(" > Giving GodMode!")
	loadstring(game:HttpGet('https://raw.githubusercontent.com/specowos/CONVERTWARE/main/convertware/Reanimation/Mizt%20Perma%20Death.lua',true))()     
    end,
	
    --// And finally converts
    ["btools"] =  function()
        CMSG(" > Giving You Btools!")  
        loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
    end,

    ["chatscript"] =  function()
        CMSG(" > Chatting Script Please Wait!")  
        wait(0.5)
       Chat("This Player Is Using A FE Admin Script Which You Can Buy At tubers93#4764 pt")
       Chat("Also This Script Has 92 Commands! Script Version Is 4.0.1")
    
    ["toolflingall"] =  function()
        CMSG(" > Starting Tool Fling Reset Or Re To Stop!")  
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DigitalityScripts/roblox-scripts/main/Tool%20Loop%20Fling%20All"))()
    end,
    
    ["loopflingall"] =  function()
        CMSG(" > Starting Loop Fling Reset Or Re To Stop")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DigitalityScripts/roblox-scripts/main/loop%20fling%20all"))()
    end,

}
