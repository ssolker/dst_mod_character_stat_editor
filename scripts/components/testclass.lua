local TestClass = Class(function(self, inst)
	self.inst = inst
	self.inst:ListenForEvent(
		"printhealth",
		function()
				print("PRINT HEALTH EVENT LSITERNET")
				self:PrintHealth()
		end
)
end)

function TestClass:GetComponents()
	print("GET COMPONENTS")
end

function TestClass:Loaded()
	-- self.inst.components.hunger.current = self.inst.components.hunger.max
	-- self.inst.components.health.current = self.inst.components.health.maxhealth
	-- self.inst.components.sanity.current = self.inst.components.sanity.max
	-- self.health = self.inst.components.hunger.current
end

function TestClass:Print()
	print("TEST CLASS PRINT")
	for k,v in pairs(self.inst.components.testclass.inst) do
		print(k,v)
	end
end

function TestClass:Another()
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

function TestClass:PrintHealth(inst)
	print("TEST HEALTH PRINT")
	self:Another()
end

function TestClass:TestingRPC(inst)
	for k,v in pairs(inst.components) do
		print(k,v)
	end
end

function TestClass:PrintStatus(inst)
	for k,v in pairs(self.inst.components) do
		if (v.current) then			
			print(k,v.current)
		end
	end
end

function TestClass:FillStatus(inst)
	inst.components.hunger.current = inst.components.hunger.max
	inst.components.health.current = inst.components.health.maxhealth
	inst.components.sanity.current = inst.components.sanity.max
end

return TestClass