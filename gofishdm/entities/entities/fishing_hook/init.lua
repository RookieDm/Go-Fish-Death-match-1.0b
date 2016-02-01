// FISHING HOOK

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
local attachsound = Sound("weapons/bugbait/bugbait_squeeze3.wav")

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/meathook001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	

	local phys = self.Entity:GetPhysicsObject()
	self.TimerRunnin = false
	self.NextTimer = CurTime()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
	end
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent = ents.Create("fishing_hook")
	ent:SetPos(tr.HitPos + Vector(0,0,24))
	ent:Spawn()
	ent:Activate()
	ent:SetName("Fishing Hook")
	return ent
end

function ENT:Use(activator, ply)

end

function ENT:OnRemove()
end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "fishing_bait" and ent.IsAttached == nil and self.HasCatch == nil and self.HasBait == nil ) then

		ent:SetPos(self.Entity:LocalToWorld( Vector(0,-4,-18) )) -- Put it ON the hook.
		
		--ent:PhysicsInit(SOLID_NONE)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetSolid(SOLID_NONE)
		
		ent:SetParent(self.Entity)
		self.Entity:EmitSound(attachsound,100,100)
	
		ent.IsAttached = true
		ent.Hook = self
		
		self.Bait = ent
		self.HasBait = true
	end
end 

function ENT:OnRemove()
	if self.Rod == nil then return end
	self.Rod.HasHook = nil
	self.Rod.Hook = nil
end

function ENT:Touch()
end

function ENT:CatchSumthin()
	self.TimerRunnin = false

	self.CatchEnt = ents.Create("fishing_fish")
	self.CatchEnt.fishowner = self.fishowner
	self.CatchEnt:SetPos( self.Entity:LocalToWorld( Vector(0,-5,-18) ) )
	self.CatchEnt:SetAngles( self.Entity:GetAngles() )
	self.CatchEnt:SetParent(self.Entity)
	self.CatchEnt:Spawn()
	self.CatchEnt:Activate()
	self.CatchEnt.TheHook = self
	self.HasCatch = true
	self.HasBait = nil
	if (self.Bait) then
		self.Bait:Remove()
	end
end

function ENT:Think()
	self.Entity:NextThink(CurTime() + 1) -- Think only once a second instead of once per tick.
	
	if CurTime() >= self.NextTimer and self.TimerRunnin == true and self.Entity:WaterLevel() >= 3 then
		self.TimerRunnin = false
		if self.IsAttached == true then
			self:CatchSumthin()
		else
			if (self.Bait) then
				self.Bait:Remove()
			end
		end
		return true
	end	
	if ( self.Entity:WaterLevel() >= 3 and self.HasBait == true ) then
		if self.TimerRunnin == false  then
			self.TimerRunnin = true
			self.NextTimer = CurTime() + math.Rand(5,60)
		end
	end
	return true
end
