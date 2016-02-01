// FISHING ROD

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local attachsound = Sound("buttons/lever7.wav")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent = ents.Create("fishing_rod")
	ent:SetPos(tr.HitPos + Vector(0,0,8))
	ent:Spawn()
	ent:Activate()
	ent:SetName("Fishing Rod")
	return ent
end

function ENT:Use(activator, ply)
end

function ENT:Think()
	// self.Entity:NextThink(1)
end	

function ENT:OnRemove()
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/harpoon002a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()

	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100)
	end
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end

function ENT:StartTouch( ent )
	if ( ent:GetClass() == "fishing_hook" and self.HasHook == nil and ent.IsAttached == nil) then		
		self.constraint, self.rope = constraint.Rope( self.Entity, ent,  
 											  0, 0,  -- Bones
 											  Vector(36,4,0), Vector(0,4,21), -- Vector pos  (rod, hook)
 											  0, 160, -- Length (forced), Lengthadd (max) 
 											  0,  -- Forcelimit
 											  0.1, -- Width 
 											  "cable/cable2",  
 											  nil ) -- Rigid
		self.Entity:EmitSound(attachsound,100,100)
 		ent.IsAttached = true
		ent.Rod = self
 		self.HasHook = true
 		self.Hook = ent
	end
end

function ENT:Touch()
end