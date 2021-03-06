local debug = GLOBAL.debug
local function EventCallBackInjection(inst)
	print("PlayerSetu1p\n\n\n\n")
	print(inst)
	print(inst.components.health)
	print(inst.components.sanity)
	print(inst.components.talker)
	local event_function
	local prefab_name = inst.prefab
end

--Player custom setup
local function PlayerSetup(inst)
	print("0PlayerSetup\n\n")
	-- back-up OnLoad function to call back
	local old_onload = inst.OnLoad
	-- back-up OnNewSpawn function to call back
	local old_onnewspawn = inst.OnNewSpawn
	-- inject code to OnLoad
	inst.OnLoad = function(inst, data)
		old_onload(inst, data)
		EventCallBackInjection(inst)
	end

	-- inject code to OnNewSpawn
	inst.OnNewSpawn = function(inst, data)
		if old_onnewspawn then
				old_onnewspawn(inst, data)
		end
		EventCallBackInjection(inst)
	end
	print(inst.OnLoad)
end

AddPlayerPostInit(function(inst)
	-- Put the code snippet here.
end)