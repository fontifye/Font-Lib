local FontLibrary={}
local TS=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local CG=game:GetService("CoreGui")

local SG,Main,Dragging,DragStart,StartPos

local function Tween(o,p,t)
 TS:Create(o,TweenInfo.new(t or .25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play()
end

local function Init()
 if SG then return end
 SG=Instance.new("ScreenGui")
 SG.Name="FontLibrary"
 SG.ResetOnSpawn=false
 if gethui then SG.Parent=gethui() else SG.Parent=CG end

 Main=Instance.new("Frame",SG)
 Main.Size=UDim2.fromOffset(520,360)
 Main.Position=UDim2.fromScale(.5,.5)
 Main.AnchorPoint=Vector2.new(.5,.5)
 Main.BackgroundColor3=Color3.fromRGB(20,20,20)
 Main.BorderSizePixel=0
 Main.Name="Main"

 local UIC=Instance.new("UICorner",Main)
 UIC.CornerRadius=UDim.new(0,10)

 local Top=Instance.new("Frame",Main)
 Top.Size=UDim2.new(1,0,0,40)
 Top.BackgroundTransparency=1
 Top.Name="Top"

 UIS.InputChanged:Connect(function(i)
  if Dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
   local d=i.Position-DragStart
   Main.Position=UDim2.new(StartPos.X.Scale,StartPos.X.Offset+d.X,StartPos.Y.Scale,StartPos.Y.Offset+d.Y)
  end
 end)

 Top.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.MouseButton1 then
   Dragging=true
   DragStart=i.Position
   StartPos=Main.Position
   i.Changed:Once(function() Dragging=false end)
  end
 end)
end

function FontLibrary:CreateWindow(c)
 Init()

 local Title=Instance.new("TextLabel",Main)
 Title.Size=UDim2.new(1,0,0,40)
 Title.BackgroundTransparency=1
 Title.Text=c.Name or "Window"
 Title.TextColor3=Color3.new(1,1,1)
 Title.Font=Enum.Font.GothamBold
 Title.TextSize=16

 local Tabs=Instance.new("Frame",Main)
 Tabs.Position=UDim2.fromOffset(10,50)
 Tabs.Size=UDim2.fromOffset(140,300)
 Tabs.BackgroundTransparency=1

 local Pages=Instance.new("Frame",Main)
 Pages.Position=UDim2.fromOffset(160,50)
 Pages.Size=UDim2.fromOffset(350,300)
 Pages.BackgroundTransparency=1

 local TL=Instance.new("UIListLayout",Tabs)
 TL.Padding=UDim.new(0,6)

 local Window={}
 local CurrentPage

 function Window:CreateTab(name)
  local Tab={}
  local Btn=Instance.new("TextButton",Tabs)
  Btn.Size=UDim2.new(1,0,0,32)
  Btn.Text=name
  Btn.BackgroundColor3=Color3.fromRGB(30,30,30)
  Btn.TextColor3=Color3.new(1,1,1)
  Btn.Font=Enum.Font.Gotham
  Btn.TextSize=14
  Btn.BorderSizePixel=0
  Instance.new("UICorner",Btn).CornerRadius=UDim.new(0,6)

  local Page=Instance.new("Frame",Pages)
  Page.Size=UDim2.new(1,0,1,0)
  Page.Visible=false
  Page.BackgroundTransparency=1

  local PL=Instance.new("UIListLayout",Page)
  PL.Padding=UDim.new(0,6)

  Btn.MouseButton1Click:Connect(function()
   if CurrentPage then CurrentPage.Visible=false end
   CurrentPage=Page
   Page.Visible=true
  end)

  if not CurrentPage then
   CurrentPage=Page
   Page.Visible=true
  end

  function Tab:CreateSection(text)
   local L=Instance.new("TextLabel",Page)
   L.Size=UDim2.new(1,0,0,28)
   L.Text=text
   L.TextXAlignment=Left
   L.BackgroundTransparency=1
   L.TextColor3=Color3.fromRGB(180,180,180)
   L.Font=Enum.Font.GothamBold
   L.TextSize=14
  end

  function Tab:CreateLabel(text)
   local L=Instance.new("TextLabel",Page)
   L.Size=UDim2.new(1,0,0,24)
   L.Text=text
   L.TextWrapped=true
   L.BackgroundTransparency=1
   L.TextColor3=Color3.new(1,1,1)
   L.Font=Enum.Font.Gotham
   L.TextSize=13
  end

  function Tab:CreateButton(c)
   local B=Instance.new("TextButton",Page)
   B.Size=UDim2.new(1,0,0,32)
   B.Text=c.Name or "Button"
   B.BackgroundColor3=Color3.fromRGB(35,35,35)
   B.TextColor3=Color3.new(1,1,1)
   B.Font=Enum.Font.Gotham
   B.TextSize=14
   B.BorderSizePixel=0
   Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)

   B.MouseButton1Click:Connect(function()
    if c.Callback then task.spawn(c.Callback) end
   end)
  end

  return Tab
 end

 return Window
end

function FontLibrary:Destroy()
 if SG then SG:Destroy() SG=nil end
end

return FontLibrary
