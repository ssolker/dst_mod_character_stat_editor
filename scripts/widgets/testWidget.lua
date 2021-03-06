-- name
-- Widget has children components
local Widget = require "widgets/widget"
-- self, font, size, text, colour
local Text = require "widgets/text"

-- GRID 
local Grid = require "widgets/grid"
-- Need to play with scrollable list
-- (self, items, listwidth, listheight, itemheight, itempadding, updatefn, widgetstoupdate, widgetXOffset, always_show_static, starting_offset, yInit, bar_width_scale_factor, bar_height_scale_factor, scrollbar_style
local ScrollableList = require "widgets/scrollablelist"

local TEMPLATES = require "widgets/templates"

local TestWidget = Class(Widget, function(self, x)
  Widget._ctor(self, "TestWidget") -- constructor
  self.root = self:AddChild(Widget("ROOT"))
  -- self.root:SetPosition(0,0,0) --x, y, z, 
  self.root:SetPosition(0,0,0) --x, y, z, 
  self.built = false
  self.settled = false
  print("\nLayout\n")
  self:Layout()
  print("\nHide\n")
  self:Hide()
end)

-- Menu

local function Test()
  print("Test")
end

local function CreateTextWidget(widgetTitle, text)
  local titleW = Widget(widgetTitle)
  local title = titleW:AddChild(Text(TALKINGFONT, 32))
  title:SetPosition(0,0,0)
  title:SetString(text)
  return titleW
end

function TestWidget:Layout()
  self.zeroPosition = self.root:AddChild(Text(TALKINGFONT, 64))
  self.zeroPosition:SetPosition(0,0,0)
  self.zeroPosition:SetString("THIS IS ZERO OF WIDGET")

  -- (sizeX, sizeY, scaleX, scaleY, topCrownOffset, bottomCrownOffset, xOffset)
  self.frame = self.root:AddChild(TEMPLATES.CurlyWindow(130, 540, .6, .6, 39, -25))
  -- self.frame = self.root:AddChild(TEMPLATES.CurlyWindow(200, 200, 0, 0, 0, 0))
  self.frame:SetPosition(0, 20)

  self.frame_bg = self.frame:AddChild(Image("images/fepanel_fills.xml", "panel_fill_tall.tex"))
  self.frame_bg:SetScale(.51, .74)
  self.frame_bg:SetPosition(5, 7)
-- (self, items, listwidth, listheight, itemheight, itempadding, updatefn, widgetstoupdate, widgetXOffset, always_show_static, starting_offset, yInit, bar_width_scale_factor, bar_height_scale_factor, scrollbar_style
  -- self.scroll_list = self.list_root:AddChild(ScrollableList(ClientObjs, 380, 370, 60, 5, UpdatePlayerListing, self.player_widgets, nil, nil, nil, -15))
  local items = {}

  for i = 1, 20, 1 do
    table.insert( items,i,CreateTextWidget("WidgetName"..i, "TextField"..i))
  end

  self.scroll_list = self.frame:AddChild(ScrollableList(
    items, -- items
    130,                 -- listwidth
    540,                 -- listheight
    30,                  -- itemheight
    10,                  -- itempadding
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
  self.scroll_list:SetPosition(0,0,0)

  -- self.grid = self.root:AddChild(Grid())
  -- Grid:InitSize(c,r, coffset, roffset)
  -- self.grid:InitSize(2, 10, 260, -40)
  -- self.grid:SetPosition(-130,270,0)
  -- self.grid:AddItem(title, 1, 1)
  -- local titleW1 = Widget("GridTitle1")
  -- local title1 = titleW:AddChild(Text(TALKINGFONT, 32))
  -- title:SetPosition(0,0,0)
  -- title1:SetString("Col2Row1")
  -- self.grid:AddItem(title1, 2, 1)

  print(self.scroll_list:GetNumberOfItems())
end


return TestWidget