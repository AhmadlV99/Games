local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:SetNotificationLower(true)
WindUI:SetFont("rbxassetid://12187365364") -- Gotham Black

WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b",
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa",
})
WindUI:SetTheme("Dark")

getgenv()._CH = _CH or {}
_CH.scriptdata = {loadedbuttons=false,currentversion='v1.1.2.6'}
_CH.candyhub = _CH.candyhub or {
    autoplant=false,autocollect=false,collectrate=500,tpcollect=false,tprate=10,
    autobuy=false,selectedseeds={"Carrot"},autosell=false,sellonfruits=50,salefocus=false,
    superdupe=false,autoevent1=false
}

local sellcords = CFrame.new(61.589, 3, 0.426, -0.002275, 8.04e-08, -0.999997, -3.37e-12, 1, 8.04e-08, 0.999997, 1.86e-10, -0.002275)

local function getinv()
    return game.Players.LocalPlayer.Backpack:GetChildren()
end

local function getsellables()
    local sellables = {}
    local currentitem = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    for _, item in game.Players.LocalPlayer.Backpack:GetChildren() do
        if string.find(item.Name, "kg") and not item:GetAttribute("Favorite") then
            table.insert(sellables,item.Name)
        end
    end
    if currentitem and string.find(currentitem.Name, "kg") and not currentitem:GetAttribute("Favorite") then
        table.insert(sellables,currentitem.Name)
    end
    return sellables
end

local function getseeds()
    local seeds = {}
    for _, item in game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren() do
        if item:FindFirstChild("Main_Frame") then
            table.insert(seeds,item.Name)
        end
    end
    return seeds
end

local function getgears()
    local gears = {}
    for _, item in game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren() do
        if item:FindFirstChild("Main_Frame") then
            table.insert(gears,item.Name)
        end
    end
    return gears
end

local function geteaster()
    local seeds = {}
    for _, item in game:GetService("Players").LocalPlayer.PlayerGui.Easter_Shop.Frame.ScrollingFrame:GetChildren() do
        if item:FindFirstChild("Main_Frame") then
            table.insert(seeds,item.Name)
        end
    end
    return seeds
end

local function getgardenaall()
    for _, garden in workspace.Farm:GetChildren() do
        local data = garden:FindFirstChild("Important") and garden.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == game.Players.LocalPlayer.Name then
            return garden
        end
    end
end

local garden = getgardenaall()

local function collectall(range)
    local plants = garden.Important.Plants_Physical
    for _, plant in ipairs(plants:GetDescendants()) do
        if plant:IsA("Part") and plant:FindFirstChildOfClass("ProximityPrompt") then
            if (plant.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < range then
                fireproximityprompt(plant:FindFirstChildOfClass("ProximityPrompt"))
            end
        end
    end
end

local function sellinv(atp)
    local oldcords = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    if #getsellables() >= 1 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sellcords
        repeat
            task.wait()
            if atp then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sellcords
            end
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        until #getsellables() == 0
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcords
    end
end

local Window = WindUI:CreateWindow({
    Title = "Grow a Garden Hub [".._CH.scriptdata.currentversion.."]",
    Icon = "leaf",
    Author = "Celeste",
    Folder = "GrowAGardenHub",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 180,
    HideSearchBar = false,
    ScrollBarEnabled = true
})

local mainTab = Window:Tab({Title="Main", Icon="home"})
local miscTab = Window:Tab({Title="Misc", Icon="settings"})
local wipeTab = Window:Tab({Title="Wipe", Icon="trash"})

-- MAIN TAB
mainTab:Toggle({Title="Auto Plant", Default=_CH.candyhub.autoplant, Callback=function(v)
    _CH.candyhub.autoplant = v
end})

mainTab:Toggle({Title="Auto Collect", Default=_CH.candyhub.autocollect, Callback=function(v)
    _CH.candyhub.autocollect = v
    while _CH.candyhub.autocollect and task.wait(_CH.candyhub.collectrate/1000) do
        if _CH.candyhub.tpcollect then
            for _, plant in ipairs(garden.Important.Plants_Physical:GetDescendants()) do
                if plant:IsA("Part") and plant:FindFirstChildOfClass("ProximityPrompt") then
                    local oldc = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plant.CFrame
                    task.wait(_CH.candyhub.tprate/1000)
                    collectall(17)
                    task.wait(_CH.candyhub.tprate/1000)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldc
                end
            end
        else
            collectall(17)
        end
    end
end})

mainTab:Slider({Title="Collect Rate (ms)", Min=100, Max=3000, Default=_CH.candyhub.collectrate, Callback=function(v)
    _CH.candyhub.collectrate = v
end})

mainTab:Toggle({Title="Transport Collect", Default=_CH.candyhub.tpcollect, Callback=function(v)
    _CH.candyhub.tpcollect = v
end})

mainTab:Slider({Title="Transport Rate (ms)", Min=1, Max=1000, Default=_CH.candyhub.tprate, Callback=function(v)
    _CH.candyhub.tprate = v
end})

mainTab:Dropdown({Title="Seeds", Options=getseeds(), Multi=true, Default=_CH.candyhub.selectedseeds, Callback=function(v)
    _CH.candyhub.selectedseeds = v
end})

mainTab:Toggle({Title="Auto Buy Seeds", Default=_CH.candyhub.autobuy, Callback=function(v)
    _CH.candyhub.autobuy = v
    while _CH.candyhub.autobuy and task.wait(1) do
        for _, fruit in _CH.candyhub.selectedseeds do
            game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(fruit)
        end
    end
end})

mainTab:Toggle({Title="Auto Sell", Default=_CH.candyhub.autosell, Callback=function(v)
    _CH.candyhub.autosell = v
    while _CH.candyhub.autosell and task.wait(1) do
        if _CH.candyhub.sellonfruits ~= 0 and #getinv() >= _CH.candyhub.sellonfruits then
            sellinv(_CH.candyhub.salefocus)
        end
    end
end})

mainTab:Toggle({Title="Sale Focus (AFK)", Default=_CH.candyhub.salefocus, Callback=function(v)
    _CH.candyhub.salefocus = v
end})

mainTab:Slider({Title="Sell On Fruits", Min=0, Max=200, Default=_CH.candyhub.sellonfruits, Callback=function(v)
    _CH.candyhub.sellonfruits = v
end})

mainTab:Button({Title="Sell All Once", Callback=function()
    sellinv()
end})

-- MISC TAB
miscTab:Toggle({Title="Auto Give Gold Plants", Default=_CH.candyhub.autoevent1, Callback=function(v)
    _CH.candyhub.autoevent1 = v
end})

miscTab:Toggle({Title="Auto DupeBuy Supers", Default=_CH.candyhub.superdupe, Callback=function(v)
    _CH.candyhub.superdupe = v
    while _CH.candyhub.superdupe and task.wait(1) do
        for i=1,5 do
            game:GetService("ReplicatedStorage").GameEvents.EasterShopService:FireServer("PurchaseSeed", i)
        end
    end
end})

miscTab:Dropdown({Title="Easter Seeds", Options=geteaster(), Multi=true, Default={}, Callback=function(v)
    _CH.candyhub.selectedeaster = v
end})

miscTab:Toggle({Title="Auto Buy Easter Seeds", Default=_CH.candyhub.easterautobuy, Callback=function(v)
    _CH.candyhub.easterautobuy = v
    while _CH.candyhub.easterautobuy and task.wait(1) do
        for _, fruit in _CH.candyhub.selectedeaster do
            game:GetService("ReplicatedStorage").GameEvents.BuyEasterStock:FireServer(fruit)
        end
    end
end})

miscTab:Button({Title="Easter Seeds GUI", Callback=function()
    game:GetService("Players").LocalPlayer.PlayerGui.Easter_Shop.Enabled = true
end})

miscTab:Button({Title="Normal Seeds GUI", Callback=function()
    game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Enabled = true
end})

miscTab:Button({Title="Gear GUI", Callback=function()
    game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Enabled = true
end})

miscTab:Button({Title="Quest GUI", Callback=function()
    game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI.Enabled = true
end})

-- WIPE TAB
wipeTab:Button({Title="Wipe All Plots", Callback=function()
    for _, plot in pairs(workspace.Farm:GetChildren()) do
        if plot:FindFirstChild("Important") and plot.Important:FindFirstChild("Data") and plot.Important.Data.Owner.Value == game.Players.LocalPlayer.Name then
            plot:Destroy()
        end
    end
end})

wipeTab:Button({Title="Wipe Inventory", Callback=function()
    for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        item:Destroy()
    end
end})
