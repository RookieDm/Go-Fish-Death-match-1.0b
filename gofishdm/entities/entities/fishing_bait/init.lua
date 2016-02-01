// FISHING BAIT

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent = ents.Create("fishing_bait")
	ent:SetPos(tr.HitPos + Vector(0,0,8))
	ent:Spawn()
	ent:Activate()
	ent:SetName("Fishing Bait")
	return ent
end

function ENT:OnRemove()
	if self.Hook == nil then return end
	self.Hook.Bait = nil
	self.Hook.HasBait = nil
end

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_bugbait.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetMaterial("models/flesh")
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
	end
end

function ENT:Touch()
end

function ENT:StartTouch()
end