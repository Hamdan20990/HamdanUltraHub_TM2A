-- HamdanEliteESP Script - 💯 Animal Detection & ESP UI

local players = game:GetService("Players")
local collectionService = game:GetService("CollectionService")
local localPlayer = players.LocalPlayer or players:GetPlayers()[1]

local eggChances = {
    ["Common Egg"] = { ["Dog"] = 33.33, ["Bunny"] = 33.33, ["Golden Lab"] = 33.33 },
    ["Dinosaur Egg"] = {
        ["Raptor"] = 35, ["Triceratops"] = 32.5, ["Stegosaurus"] = 28,
        ["Pterodactyl"] = 3, ["Brontosaurus"] = 1, ["T-Rex"] = 0.5
    },
    ["Bee Egg"] = {
        ["Bee"] = 65, ["Honey Bee"] = 25, ["Bear Bee"] = 5,
        ["Petal Bee"] = 4, ["Queen Bee"] = 1
    },
    ["Bug Egg"] = {
        ["Caterpillar"] = 40, ["Snail"] = 30, ["Giant Ant"] = 25,
        ["Preying Mantis"] = 4, ["Dragonfly"] = 1
    },
    ["Mythical Egg"] = {
        ["Grey Mouse"] = 36, ["Squirrel"] = 27, ["Brown Mouse"] = 27,
        ["Red Giant Ant"] = 8.5, ["Red Fox"] = 1.5
    },
    ["Night Egg"] = {
        ["Hedgehog"] = 49, ["Mole"] = 22, ["Frog"] = 14,
        ["Echo Frog"] = 10, ["Night Owl"] = 4, ["Raccoon"] = 1
    },
    ["Anti Bee Egg"] = {
        ["Wasp"] = 55, ["Tarantula Hawk"] = 30, ["Moth"] = 13.75,
        ["Butterfly"] = 1, ["Disco Bee"] = 0.25
    },
    ["Premium Primal Egg"] = {
        ["Parasaurolophus"] = 42.55, ["Iguanodon"] = 42.55, ["Dilophosaurus"] = 20,
        ["Ankylosaurus"] = 1, ["Spinosaurus"] = 0.5
    },
    ["Rare Summer Egg"] = {
        ["Flamingo"] = 30, ["Toucan"] = 25, ["Sea Turtle"] = 20,
        ["Orangutan"] = 15, ["Seal"] = 10
    },
    ["Oasic Egg"] = {
        ["Meerkat"] = 45, ["Sand Snake"] = 34.5, ["Axolotl"] = 15,
        ["Hyacinth Macaw"] = 5, ["Fennec Fox"] = 0.5
    },
    ["Paradise Egg"] = {
        ["Ostrich"] = 40, ["Peacock"] = 30, ["Capybara"] = 21,
        ["Eagle Mouse"] = 8, ["Mimic Octopus"] = 1
    },
    ["Common Summer Egg"] = {
        ["Starfish"] = 50, ["Crab"] = 25, ["Seagull"] = 25
    }
}

local displayedEggs = {}
local autoStopOn = true

local function getHighestChancePet(pool)
    local maxPet, maxChance = nil, 0
    for pet, chance in pairs(pool) do
        if chance > maxChance then
            maxPet, maxChance = pet, chance
        end
    end
    return maxPet
end

local function createEspGui(object, labelText)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PetESP"
    billboard.Adornee = object:FindFirstChildWhichIsA("BasePart") or object.PrimaryPart or object
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText
    label.Parent = billboard

    billboard.Parent = object
    return billboard
end

local function addESP(egg)
    if egg:GetAttribute("OWNER") ~= localPlayer.Name then return end
    local eggName = egg:GetAttribute("EggName")
    local objectId = egg:GetAttribute("OBJECT_UUID")
    if not eggName or not objectId or displayedEggs[objectId] then return end

    local petName = getHighestChancePet(eggChances[eggName] or {}) or "?"
    local labelText = eggName .. " | " .. petName

    local espGui = createEspGui(egg, labelText)
    displayedEggs[objectId] = {
        egg = egg,
        gui = espGui,
        label = espGui:FindFirstChild("TextLabel"),
        eggName = eggName
    }
end

local function removeESP(egg)
    local objectId = egg:GetAttribute("OBJECT_UUID")
    if objectId and displayedEggs[objectId] then
        displayedEggs[objectId].gui:Destroy()
        displayedEggs[objectId] = nil
    end
end

for _, egg in collectionService:GetTagged("PetEggServer") do
    addESP(egg)
end

collectionService:GetInstanceAddedSignal("PetEggServer"):Connect(addESP)
collectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(removeESP)

-- GUI Buttons
local gui = Instance.new("ScreenGui")
gui.Name = "HamdanUI"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local stopBtn = Instance.new("TextButton", gui)
stopBtn.Size = UDim2.new(0, 150, 0, 40)
stopBtn.Position = UDim2.new(1, -190, 0, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Text = "[A] Auto Stop: ON"
stopBtn.TextScaled = true

stopBtn.MouseButton1Click:Connect(function()
    autoStopOn = not autoStopOn
    stopBtn.Text = autoStopOn and "[A] Auto Stop: ON" or "[A] Auto Stop: OFF"
end)

local info = Instance.new("TextButton", gui)
info.Size = UDim2.new(0, 30, 0, 40)
info.Position = UDim2.new(1, -35, 0, 0)
info.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
info.TextColor3 = Color3.new(1, 1, 1)
info.Text = "?"
info.TextScaled = true

info.MouseButton1Click:Connect(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Info",
            Text = "Auto Stop when found: Disco Bee, T-Rex, Raccoon, Red Fox, Queen Bee, Dragonfly, Spinosaurus",
            Duration = 6
        })
    end)
end)

local autoBtn = Instance.new("TextButton", gui)
autoBtn.Size = UDim2.new(0, 150, 0, 40)
autoBtn.Position = UDim2.new(1, -190, 0, 45)
autoBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Text = "[B] Reroll Pet Display"
autoBtn.TextScaled = true

autoBtn.MouseButton1Click:Connect(function()
    for objectId, data in pairs(displayedEggs) do
        local petName = getHighestChancePet(eggChances[data.eggName] or {}) or "?"
        if data.label then
            data.label.Text = data.eggName .. " | " .. petName
        end
    end
end)

