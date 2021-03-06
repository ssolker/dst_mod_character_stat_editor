local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Button = require "widgets/button"
local Menu = require "widgets/menu"
local ImageButton = require "widgets/imagebutton"
local ScrollableList = require "widgets/scrollablelist"
local TEMPLATES = require "widgets/templates"

local ModScreen = Class(Widget, function(self, player)
  Widget._ctor(self, "ModScreen") -- constructor
  self.player = player
  self.fillStatus = nil
end)

function ModScreen:SetFillStatus(fillStatusFunction)
  self.fillStatus = fillStatusFunction
end

local function CreateTextWidget(widgetTitle, text, x, y)
  local titleW = Widget(widgetTitle)
  local title = titleW:AddChild(Text(TALKINGFONT, 32))
  title:SetPosition(x,y,0)
  title:SetString(text)
  return titleW
end

function ModScreen:CreateRowWidget()
  local rowWidget = Widget("RowWidget")
  local label = rowWidget:AddChild(Text(TALKINGFONT, 32))
  label:SetPosition(0,0,0)
  label:SetString("Label")
  local buttons = {}

  table.insert(buttons, {text="Button", cb=self.fillStatus })
  local menu = rowWidget:AddChild(Menu(buttons, 0, false, nil, nil, 32))
  menu:SetPosition(380, 0, 0)
  print(rowWidget)
  return rowWidget
end

function ModScreen:PrintInfo()
  print(self)
  if (self.root ~= nil) then
    print(self.root:GetPosition())
    print(self.root:GetScale())
  end
end

function ModScreen:Print(text)
  print(text)
  for k,v in pairs(text) do
    print(k,v)
  end
end

function ModScreen:Init()
  print("Init\n")
  -- Resolution is 640 x 480
  if not self.root then
    print("root\n")
    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetVAnchor(ANCHOR_MIDDLE)
  end
  -- self:PrintInfo()
  
  if not self.bg then
    print("bg\n")
    self.bg = self.root:AddChild(Image( "images/scoreboard.xml", "scoreboard_frame.tex" ))
    self.bg:SetScale(.96,.9)
    -- self.bg:SetScale(1,1)
  end

  if not self.title then
    print("title\n")
    self.title = self.root:AddChild(Text(UIFONT,45))
    self.title:SetColour(1,1,1,1)
    self.title:SetString("Mod Screen")
    self.title:SetPosition(0,215)
  end

  local items = {}
  -- for i = 1, 20, 1 do
  --   table.insert( items,i,CreateTextWidget("WidgetName"..i, "TextField"..i, 0, 0))
  -- end
  table.insert( items, 1, self:CreateRowWidget() )

  self.scroll_list = self.root:AddChild(ScrollableList(
    items, -- items
    380,                 -- listwidth
    370,                 -- listheight
    60,                  -- itemheight
    5,                  -- itempadding
    nil,                 -- updatefn
    nil,                 -- widgetstoupdate
    nil,                 -- widgetXOffset
    nil,                 -- always_show_static
    nil,                 -- starting_offset
    10,                  -- yInit
    nil,                 -- bar_width_scale_factor
    nil,                 -- bar_height_scale_factor
    "GOLD"               -- scrollbar_style
  ))
  self.scroll_list:SetPosition(0,-10, 0)

end

return ModScreen
