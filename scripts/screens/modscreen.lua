local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Button = require "widgets/button"
local Menu = require "widgets/menu"
local Grid = require "widgets/grid"
local Spinner = require "widgets/spinner"
local NumericSpinner = require "widgets/numericspinner"
local spinner_width = 180
local spinner_height = 36 --nil -- use default
local spinner_scale_x = .76
local spinner_scale_y = .68


local ImageButton = require "widgets/imagebutton"
local ScrollableList = require "widgets/scrollablelist"
local TEMPLATES = require "widgets/templates"


local ModScreen = Class(Widget, function(self, player, editoroptions, actionCallback)
  Widget._ctor(self, "ModScreen") -- constructor
  self.player = player
  self.actionCallback = actionCallback
  self.editorOptions = editoroptions
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

-- option {desc, type, action}
function ModScreen:CreateRowWidget(option)
  print("OPTIOUNS")
  for k,v in pairs(option) do
    print(k,v)
  end
  local rowWidget = Widget("RowWidget")
  local label = rowWidget:AddChild(Text(TALKINGFONT, 32))
  label:SetPosition(0,0,0)
  label:SetString(option.desc)
  local buttons = {}

  local callback = function() self.actionCallback(option.data) end
  table.insert(buttons, {text=option.buttonDesc, cb=callback})
  local menu = rowWidget:AddChild(Menu(buttons, 0, false, nil, nil, 32))
  menu:SetPosition(380, 0, 0)
  return rowWidget
end

function ModScreen:CreateNumericSpinnerRow()
  local rowWidget = Widget("RowWidgetSpinner")
  local grid = rowWidget:AddChild(Grid())
  grid:SetPosition(0, 0, 0)
  grid:InitSize(2, 10, 440, -40)

  local numericspinners = {}
	local spinner = NumericSpinner( 40, 100, spinner_width, spinner_height, nil, nil, nil, nil, true, nil, nil, spinner_scale_x, spinner_scale_y )
	spinner.OnChanged =
		function( _, data )
      print("SPinner on change")
      print(data)
      local d = {
        action = "setrunspeed",
        value = data
      }
      self.actionCallback(d)
		end
  table.insert( numericspinners, { "SPINNER", spinner } )

	for k,v in ipairs(numericspinners) do
		grid:AddItem(self:CreateSpinnerGroup(v[1], v[2]), 1, k)
	end

  return rowWidget

end

function ModScreen:CreateSpinnerGroup( text, spinner )
	local label_width = 200
	spinner:SetTextColour(0,0,0,1)
	local group = Widget( "SpinnerGroup" )
	local bg = group:AddChild(Image("images/ui.xml", "single_option_bg.tex"))
	bg:SetSize(380, 40)
	bg:SetPosition(50, 0, 0)

	local label = group:AddChild( Text( NEWFONT, 26, text ) )
	label:SetPosition( -label_width/2 + 55, 0, 0 )
	label:SetRegionSize( label_width, 50 )
	label:SetHAlign( ANCHOR_RIGHT )
	label:SetColour(0,0,0,1)
	
	group:AddChild( spinner )
	spinner:SetPosition( 148, 0, 0 )
	spinner:SetTextSize(22)

	--pass focus down to the spinner
	group.focus_forward = spinner
	return group
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
  -- Resolution is 640 x 480
  if not self.root then
    self.root = self:AddChild(Widget("ROOT"))
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetVAnchor(ANCHOR_MIDDLE)
  end
  
  if not self.bg then
    self.bg = self.root:AddChild(Image( "images/scoreboard.xml", "scoreboard_frame.tex" ))
    self.bg:SetScale(.96,.9)
    -- self.bg:SetScale(1,1)
  end

  if not self.title then
    print("title\n")
    self.title = self.root:AddChild(Text(UIFONT,45))
    self.title:SetColour(1,1,1,1)
    self.title:SetString("Character Stat Editor")
    self.title:SetPosition(0,215)
  end

  local items = {}
  -- for i = 1, 20, 1 do
  --   table.insert( items,i,CreateTextWidget("WidgetName"..i, "TextField"..i, 0, 0))
  -- end
  -- table.insert( items, 1, self:CreateRowWidget() )

  local pos = 1
  for key, val in pairs(self.editorOptions) do
    if (val) then
      table.insert( items, pos, self:CreateRowWidget(val) )
      pos = pos + 1
    end
  end

  table.insert(items, 4, self:CreateNumericSpinnerRow())

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
