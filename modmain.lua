----------------------------
-- Imports and Widgets
----------------------------

local Controls = GLOBAL.require("widgets/controls")
local ModScreen = GLOBAL.require("screens/modscreen")


----------------------------
-- variables
----------------------------

local EditorOptions = nil
local handlersApplied = false
local eventsApplied = false
local isOpen = false
local isPressed = false
local local_controls = nil
local local_player = nil
local listener = nil

----------------------------
-- Methods
----------------------------
-- local function IsDefaultScreen()
-- 	local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
-- 	return ((screen and type(screen.name) == "string") and screen.name or ""):find("HUD") ~= nil
-- 		and not(GLOBAL.ThePlayer.HUD:IsControllerCraftingOpen() or GLOBAL.ThePlayer.HUD:IsControllerInventoryOpen())
-- end

--RPC Function
local function FillStatus(inst)
	inst.components.modcharacterstats:FillStatus(inst)
end
local function FillStatusFunction()
	GLOBAL.SendModRPCToServer(MOD_RPC["modscreen"]["fillstatus"], GLOBAL.ThePlayer)
end


local function FillHealth(inst)
	inst.components.modcharacterstats:FillHealth(inst)
end
local function FillHealthCB(inst)
	GLOBAL.SendModRPCToServer(MOD_RPC["modscreen"]["health"], GLOBAL.ThePlayer)
end

local function FillHunger(inst)
	inst.components.modcharacterstats:FillHunger(inst)
end
local function FillHungerCB(inst)
	GLOBAL.SendModRPCToServer(MOD_RPC["modscreen"]["hunger"], GLOBAL.ThePlayer)
end

local function FillSanity(inst)
	inst.components.modcharacterstats:FillSanity(inst)
end
local function FillSanityCB(inst)
	GLOBAL.SendModRPCToServer(MOD_RPC["modscreen"]["sanity"], GLOBAL.ThePlayer)
end


local function ShowModScreen()
	if (local_controls and local_controls.modScreen) then
		SetModHUDFocus("ModScreen", true)
		local_controls.modScreen:Show()
	end
end

local function HideModScreen()
	if (local_controls and local_controls.modScreen) then
		SetModHUDFocus("ModScreen", false)
		local_controls.modScreen:Hide()		
	end
end


local function AddModScreen(controls)
	-- print("AddModScreen\n")
	local_controls = controls
	if (not local_player) then
		local_player = GLOBAL.ThePlayer
	end
	if local_controls.modScreen == nil then
		local_controls.modScreen = local_controls:AddChild(ModScreen(local_player, EditorOptions))
		--callbacks
		local_controls.modScreen:SetFillStatus(FillStatusFunction)
		--init
		local_controls.modScreen:Init()
		--hidden by default
		HideModScreen()
	end
end

--Player loaded
--Local and Client inst.
--User Server inst for character class init.
local function CharacterSetup(inst)
	local old_onload = inst.OnLoad	
	if GLOBAL.TheWorld.ismastersim then --Server
		inst:AddComponent("modcharacterstats") --from components folder
		inst.OnLoad = function(inst, data)
			old_onload(inst, data)
			-- inst.components.modcharacterstats:Loaded()
		end
		local_player = inst	
	-- else --Client
	-- 	print(inst.replica.modcharacterstats)
	end
end

----------------------------
--key pressed events
----------------------------
local function keyDown()
	if not isPressed then
		isPressed = true
		if not isOpen then
			isOpen = true
			ShowModScreen()			
		else 
			isOpen = false
			HideModScreen()						
		end
	end
	return true
end

-- let it know key was let go
local function keyUp()
	isPressed = false
	return true
end

----------------------------
-- Setup & Handlers & Events
----------------------------
KEYBOARDTOGGLEKEY = GetModConfigData("KEYBOARDTOGGLEKEY") or "P"
if type(KEYBOARDTOGGLEKEY) == "string" then
	KEYBOARDTOGGLEKEY = KEYBOARDTOGGLEKEY:lower():byte()
end

if not handlersApplied then
	GLOBAL.TheInput:AddKeyDownHandler(KEYBOARDTOGGLEKEY, keyDown)
	GLOBAL.TheInput:AddKeyUpHandler(KEYBOARDTOGGLEKEY, keyUp)
	handlersApplied = true
end

----------------------------
-- Main
----------------------------

AddPlayerPostInit(CharacterSetup)

-- AddModRPCHandler("modscreen", "fillstatus", FillStatus)

EditorOptions = {
	health = {
		desc = "Health",
		type = "button",
		buttonDesc = "Fill",
		action = FillHealthCB,
		rpcHandler = FillHealth
	},
	hunger = {
		desc = "Hunger",
		type = "button",
		buttonDesc = "Fill",
		action = FillHungerCB,
		rpcHandler = FillHunger
	},
	sanity = {
		desc = "Sanity",
		type = "button",
		buttonDesc = "Fill",
		action = FillSanityCB,
		rpcHandler = FillSanity
	}
}

for k,v in pairs(EditorOptions) do
	AddModRPCHandler("modscreen", k, v.rpcHandler)
end

-- AddModRPCHandler("modscreen", "health", FillHealth)
-- AddModRPCHandler("modscreen", "hunger", FillHunger)
-- AddModRPCHandler("modscreen", "sanity", FillSanity)
AddClassPostConstruct( "widgets/controls", AddModScreen)



----------------------------
-- Notes
----------------------------
-- Global makes use of any global scripts. Input
-- print(ThePlayer)
-- print(TheInput)
-- SERVER MOD IF NOT JUST UI


-- if owner then
-- 	owner:ListenForEvent("mycustomevent", function(inst, text)
-- 		print("mycustomevent ran")
-- 		print(text)
-- 		text()
-- 	end)
-- end
-- if owner then
-- 	-- owner:PushEvent("mycustomevent", {text="string"})
-- 	owner:PushEvent("mycustomevent", myCustomFunction)
-- 	owner:PushEvent("mycustomevent", myCustomFunction, {text="string"})
	
-- end
----------------------------------------------------
-- 1. Lua Notes.
----------------------------------------------------
-- This is a variable in lua, variables are global by default.
-- variableName = 12 specify local
-- 10 all numbers are doubles
-- local testVariable = "Hello World"
-- this is how to print
-- print(testVariable)

-- set nil undefines var, garbage collections (Clean up memory used)
-- local len = 1
-- while len < 10 do
-- 	len = len + 1
-- 	print(len)
-- end
-- ~= not nil
-- nil and false are falsy, 0 and '' are true
-- print("this is len\n")
-- print(len)
-- if (len > 5) then 
-- 	print("Len is greater than 5")
-- elseif (len < 5) then
-- 	print("Len is greater than 5")
-- else
-- 	print("equal to 5")
-- end
-- short circuit or and a?b:c
-- local test = true and len < 5 or len > 5

-- index, total, add
-- for i = 1, 10, 1 do
-- end

-- iterate a table
-- for index, value in ipairs(t) do
-- end

-- loop through table kvp
-- for key, value in pairs(t) do
-- end
--repeat until

----------------------------------------------------
-- 2. Functions.
----------------------------------------------------
-- ORder matters
-- global needs Caps first ie. FunctionName, lcoal = functionName
-- function Fib(n)
--   if n < 2 then return 1 end
--   return Fib(n - 2) + Fib(n - 1)
-- end

-- -- Closures and anonymous functions are ok:
-- function adder(x)
--   -- The returned function is created when adder is
--   -- called, and remembers the value of x:
-- 	return function (y) 
-- 		return x + y end
-- end

----------------------------------------------------
-- 3. Tables. Only datastruct, Objects.
----------------------------------------------------
-- Dict literals have string keys by default:
-- t = {key1 = 'value1', key2 = false}, setting a field to nil removes, t.newKey = {}

-- 1. Dog acts like a class; it's really a table.
-- 2. function tablename:fn(...) is the same as
--    function tablename.fn(self, ...)
--    The : just adds a first arg called self.
--    Read 7 & 8 below for how self gets its value.
-- 3. newObj will be an instance of class Dog.
-- 4. self = the class being instantiated. Often
--    self = Dog, but inheritance can change it.
--    newObj gets self's functions when we set both
--    newObj's metatable and self's __index to self.
-- 5. Reminder: setmetatable returns its first arg.
-- 6. The : works as in 2, but this time we expect
--    self to be an instance instead of a class.
-- 7. Same as Dog.new(Dog), so self = Dog in new().
-- 8. Same as mrDog.makeSound(mrDog); self = mrDog.
