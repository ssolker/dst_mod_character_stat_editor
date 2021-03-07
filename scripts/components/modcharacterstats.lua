local ModCharacterStats = Class(function(self, inst)
	self.inst = inst
	self.inst:ListenForEvent(
		"printhealth",
		function()
				print("PRINT HEALTH EVENT LSITERNET")
				self:PrintHealth()
		end
)
end)

function ModCharacterStats:GetComponents()
	print("GET COMPONENTS")
end

function ModCharacterStats:Loaded()
	-- self.inst.components.hunger.current = self.inst.components.hunger.max
	-- self.inst.components.health.current = self.inst.components.health.maxhealth
	-- self.inst.components.sanity.current = self.inst.components.sanity.max
	-- self.health = self.inst.components.hunger.current
end

function ModCharacterStats:Print()
	print("TEST CLASS PRINT")
	for k,v in pairs(self.inst.components.modcharacterstats.inst) do
		print(k,v)
	end
end

function ModCharacterStats:Another()
	if (self.inst.components.health) then
		print(self.inst.components.health.current)
		self.inst.components.health.current = self.inst.components.health.maxhealth
	else
		print("NOT HEALTH")
	end
	for k,v in pairs(self.inst.components) do
		print(k,v)
	end
end

function ModCharacterStats:PrintHealth(inst)
	print("TEST HEALTH PRINT")
	self:Another()
end

function ModCharacterStats:PrintStatus(inst)
	for k,v in pairs(self.inst.components) do
		if (v.current) then			
			print(k,v.current)
		end
	end
end

function ModCharacterStats:FillStatus(inst)
	inst.components.hunger.current = inst.components.hunger.max
	inst.components.health.current = inst.components.health.maxhealth
	inst.components.sanity.current = inst.components.sanity.max
end

function ModCharacterStats:FillHealth(inst) 
	inst.components.health.current = inst.components.health.maxhealth
end

function ModCharacterStats:FillHunger(inst) 
	inst.components.hunger.current = inst.components.hunger.max
end

function ModCharacterStats:FillSanity(inst) 
	inst.components.sanity.current = inst.components.sanity.max
end

return ModCharacterStats