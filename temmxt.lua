local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:SetNotificationLower(true)
WindUI:SetFont("rbxassetid://font-id-here")
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
_CH.candyhub = _CH.candyhub or {autoplant=false,autocollect=false,collectrate=500,tpcollect=false,tprate=10,autobuy=false,selectedseeds={"Carrot"},autosell=false,sellonfruits=50,salefocus=false,dupeamount=100,superdupe=false,autoevent1=false}
local sellcords=CFrame.new(61.589,3,0.426,-0.002275,8.04e-08,-0.999997,-3.37e-12,1,8.04e-08,0.999997,1.86e-10,-0.002275)
local function getinv()return game.Players.LocalPlayer.Backpack:GetChildren()end
local function getsellables()local s={}local c=game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")for _,i in game.Players.LocalPlayer.Backpack:GetChildren()do if string.find(i.Name,"kg")and not i:GetAttribute("Favorite")then table.insert(s,i.Name)end end if c and string.find(c.Name,"kg")and not c:GetAttribute("Favorite")then table.insert(s,c.Name)end return s end
local function getseeds()local s={}for _,i in game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren()do if i:FindFirstChild("Main_Frame")then table.insert(s,i.Name)end end return s end
local function getgears()local g={}for _,i in game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren()do if i:FindFirstChild("Main_Frame")then table.insert(g,i.Name)end end return g end
local function geteaster()local s={}for _,i in game:GetService("Players").LocalPlayer.PlayerGui.Easter_Shop.Frame.ScrollingFrame:GetChildren()do if i:FindFirstChild("Main_Frame")then table.insert(s,i.Name)end end return s end
local function getgardenaall()for _,g in workspace.Farm:GetChildren()do local d=g:FindFirstChild("Important")and g.Important:FindFirstChild("Data")if d and d:FindFirstChild("Owner")and d.Owner.Value==game.Players.LocalPlayer.Name then return g end end end
local garden=getgardenaall()
local function collectall(r)local p=garden.Important.Plants_Physical for _,pl in ipairs(p:GetDescendants())do if pl:IsA("Part")and pl:FindFirstChildOfClass("ProximityPrompt")then if(pl.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude<r then fireproximityprompt(pl:FindFirstChildOfClass("ProximityPrompt"))end end end end
local function sellinv(a)local o=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame if #getsellables()>=1 then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=sellcords repeat task.wait()if a then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=sellcords end game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()until #getsellables()==0 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=o end end
local Window=WindUI:CreateWindow({Title="Grow a Garden Hub [".._CH.scriptdata.currentversion.."]",Icon="leaf",Author="Celeste",Folder="GrowAGardenHub",Size=UDim2.fromOffset(520,420),Transparent=true,Theme="Dark",Resizable=true,SideBarWidth=200,HideSearchBar=false,ScrollBarEnabled=true})
local mainTab=Window:Tab({Title="Main",Icon="home"})
local miscTab=Window:Tab({Title="Misc",Icon="settings"})
local wipeTab=Window:Tab({Title="Wipe",Icon="trash"})
local secAuto=mainTab:Section({Title="Auto Farm",Opened=true})
secAuto:Toggle({Title="Auto Plant",Default=_CH.candyhub.autoplant,Callback=function(v)_CH.candyhub.autoplant=v end})
secAuto:Toggle({Title="Auto Collect",Default=_CH.candyhub.autocollect,Callback=function(v)_CH.candyhub.autocollect=v while _CH.candyhub.autocollect and task.wait(_CH.candyhub.collectrate/1000)do if _CH.candyhub.tpcollect then for _,pl in ipairs(garden.Important.Plants_Physical:GetDescendants())do if pl:IsA("Part")and pl:FindFirstChildOfClass("ProximityPrompt")then local o=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=pl.CFrame task.wait(_CH.candyhub.tprate/1000)collectall(17)task.wait(_CH.candyhub.tprate/1000)game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=o end end else collectall(17)end end end})
secAuto:Slider({Title="Collect Rate (ms)",Min=100,Max=3000,Default=_CH.candyhub.collectrate,Callback=function(v)_CH.candyhub.collectrate=v end})
secAuto:Toggle({Title="Transport Collect",Default=_CH.candyhub.tpcollect,Callback=function(v)_CH.candyhub.tpcollect=v end})
secAuto:Slider({Title="Transport Rate (ms)",Min=1,Max=1000,Default=_CH.candyhub.tprate,Callback=function(v)_CH.candyhub.tprate=v end})
local secSeed=mainTab:Section({Title="Seed & Gear Sniper",Opened=true})
secSeed:Dropdown({Title="Seeds",Options=getseeds(),Multi=true,Default=_CH.candyhub.selectedseeds,Callback=function(v)_CH.candyhub.selectedseeds=v end})
secSeed:Toggle({Title="Auto Buy Seeds",Default=_CH.candyhub.autobuy,Callback=function(v)_CH.candyhub.autobuy=v while _CH.candyhub.autobuy and task.wait(1)do for _,f in _CH.candyhub.selectedseeds do game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(f)end end end})
secSeed:Dropdown({Title="Gears",Options=getgears(),Multi=true,Default={},Callback=function(v)_CH.candyhub.selectedgears=v end})
secSeed:Toggle({Title="Auto Buy Gears",Default=_CH.candyhub.autobuygear,Callback=function(v)_CH.candyhub.autobuygear=v while _CH.candyhub.autobuygear and task.wait(1)do for _,g in _CH.candyhub.selectedgears do local a={[1]=g,[2]=g=="WateringCan"and 10 or 0}game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(unpack(a))end end end})
local secSell=mainTab:Section({Title="Auto Sell",Opened=true})
secSell:Toggle({Title="Auto Sell",Default=_CH.candyhub.autosell,Callback=function(v)_CH.candyhub.autosell=v while _CH.candyhub.autosell and task.wait(1)do if _CH.candyhub.sellonfruits~=0 and #getinv()>=_CH.candyhub.sellonfruits then sellinv(_CH.candyhub.salefocus)end end end})
secSell:Toggle({Title="Sale Focus (AFK)",Default=_CH.candyhub.salefocus,Callback=function(v)_CH.candyhub.salefocus=v end})
secSell:Slider({Title="Sell On Fruits",Min=0,Max=200,Default=_CH.candyhub.sellonfruits,Callback=function(v)_CH.candyhub.sellonfruits=v end})
secSell:Button({Title="Sell All Once",Callback=function()sellinv()end})
local secEvent=miscTab:Section({Title="Events",Opened=true})
secEvent:Toggle({Title="Auto Give Gold Plants",Default=_CH.candyhub.autoevent1,Callback=function(v)_CH.candyhub.autoevent1=v end})
secEvent:Toggle({Title="Auto DupeBuy Supers",Default=_CH.candyhub.superdupe,Callback=function(v)_CH.candyhub.superdupe=v while _CH.candyhub.superdupe and task.wait(1)do for i=1,5 do game:GetService("ReplicatedStorage").GameEvents.EasterShopService:FireServer("PurchaseSeed",i)end end end})
local secEaster=miscTab:Section({Title="Easter Sniper",Opened=true})
secEaster:Dropdown({Title="Easter Seeds",Options=geteaster(),Multi=true,Default={},Callback=function(v)_CH.candyhub.selectedeaster=v end})
secEaster:Toggle({Title="Auto Buy Easter Seeds",Default=_CH.candyhub.easterautobuy,Callback=function(v)_CH.candyhub.easterautobuy=v while _CH.candyhub.easterautobuy and task.wait(1)do for _,f in _CH.candyhub.selectedeaster do game:GetService("ReplicatedStorage").GameEvents.BuyEasterStock:FireServer(f)end end end})
local secGui=miscTab:Section({Title="GUI Unlockers",Opened=true})
secGui:Button({Title="Easter Seeds GUI",Callback=function()game:GetService("Players").LocalPlayer.PlayerGui.Easter_Shop.Enabled=true end})
secGui:Button({Title="Normal Seeds GUI",Callback=function()game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Enabled=true end})
secGui:Button({Title="Gear GUI",Callback=function()game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Enabled=true end})
secGui:Button({Title="Quest GUI",Callback=function()game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI.Enabled=true end})
local secWipePlots=wipeTab:Section({Title="Plots",Opened=true})
secWipePlots:Button({Title="Wipe All Plots",Callback=function()for _,p in pairs(workspace.Farm:GetChildren())do if p:FindFirstChild("Important")and p.Important:FindFirstChild("Data")and p.Important.Data.Owner.Value==game.Players.LocalPlayer.Name then p:Destroy()end end end})
local secWipeInv=wipeTab:Section({Title="Inventory",Opened=true})
secWipeInv:Button({Title="Wipe Inventory",Callback=function()for _,i in pairs(game.Players.LocalPlayer.Backpack:GetChildren())do i:Destroy()end end})
