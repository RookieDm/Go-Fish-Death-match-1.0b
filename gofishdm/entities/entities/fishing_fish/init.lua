// FISHING FISH

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:SpawnFunction(ply, tr)
	return false
end

function ENT:Makeit()
	self.TheHook.HasCatch = nil

 	local NPC = ents.Create( Catchphrase[self.SelectedCatch][1] )
 	if ( !IsValid( NPC ) ) then return end 
   
 	NPC:SetPos( self.Entity:GetPos() + Vector(0,0,32)) 
 	
 	if NPC:IsNPC() then
		local SpawnFlags = bit.bor(SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK, SF_NPC_NO_WEAPON_DROP)
		NPC:SetKeyValue( "spawnflags", SpawnFlags )
		
		if NPC:GetClass() == "npc_citizen" then
			NPC:SetKeyValue( "citizentype", math.random(1,3) )
		end
		if NPC:GetClass() == "npc_seagull" or NPC:GetClass() == "npc_pigeon" or NPC:GetClass() == "npc_crow" then
			NPC:SetKeyValue( "target", "airtrack1" )
		end
		if NPC:GetClass() == "npc_combinedropship" or NPC:GetClass() == "npc_combinegunship" or NPC:GetClass() == "npc_helicopter" then
			NPC:SetKeyValue( "target", "airpath1" )
		end
		
			
		if ( Catchphrase[self.SelectedCatch][3] != nil ) then
			NPC:SetKeyValue( "additionalequipment", Catchphrase[self.SelectedCatch][3][math.random(1,table.getn(Catchphrase[self.SelectedCatch][3]))] )
		end
		
		NPC:SetName("Enemy")

		if math.random(0,100) <= 30 then
			NPC:SetName("Friendly")
			NPC:SetColor(50,255,50,255)
		end
		
		NPC:SetPos( self.Entity:GetPos() + Vector(0,0,256))
		
		for k,v in pairs(ents.FindByClass("npc_*")) do
			if v:GetName() == "Friendly" and v:IsValid() then
				v:AddRelationship("Player D_LI 99")
				v:AddRelationship("Enemy D_HT 99")
				v:AddRelationship("Friendly D_LI 99")
			elseif v:GetName() == "Enemy" and v:IsValid() then
			
				v:AddRelationship("Player D_HT 99")
				v:AddRelationship("Enemy D_LI 99")
				v:AddRelationship("Friendly D_HT 99")
			end
			if v:GetClass() == "npc_headcrab_black" and v:GetName() != "Friendly" and v:GetName() != "Enemy" then
				v:SetName("Enemy")
				v:AddRelationship("Player D_HT 99")
				v:AddRelationship("Enemy D_LI 99")
				v:AddRelationship("Friendly D_HT 99")
			end
		end
	
	else
		NPC:SetModel( Catchphrase[self.SelectedCatch][2] )
	end
	
	
 	NPC:Spawn() 
 	NPC:Activate()
	
 	if NPC:GetClass() == "npc_combinegunship" then
		NPC:SetModel("models/gunship.mdl")
	end
	if NPC:GetModel() != tostring( Catchphrase[self.SelectedCatch][2] ) then
		ErrorNoHalt( "ERROR: ".. tostring( NPC:GetModel() ) .." was supposed to be ".. tostring( Catchphrase[self.SelectedCatch][2] ) .."!\n" )
	end
	--NPC:SetOwner(self.owner) -- This causes the owner not to collide with the object
	NPC.fishowner = self.fishowner
	self.fishowner:AddScore( 1 )
	self:Remove()
end

function ENT:Use(activator, ply)
	self:Makeit()
end

function ENT:Think()
	self.Entity:NextThink(CurTime() + 10) -- Think only once a second instead of once per tick.
	if self.Entity:WaterLevel() >= 3 and self.pron != nil then
		self.TheHook.HasCatch = nil
		self:Remove()
	end
	self.pron = true
	return true
end	

function ENT:OnRemove()
end

function ENT:Initialize()
	self.SelectedCatch = math.random( 1, table.getn(Catchphrase))
	
	self.Entity:SetModel( Catchphrase[self.SelectedCatch][2] )
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
end

function ENT:StartTouch( ent )
	if ent:IsPlayer()  then
		self:Makeit()
	end
end

function ENT:Touch( ent )

end

