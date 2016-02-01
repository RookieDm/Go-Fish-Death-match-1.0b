// GAMEMODE INIT

util.AddNetworkString("msg1")

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "spawnicon.lua" )
AddCSLuaFile( "helpmenu.lua" )

include( 'shared.lua' )

resource.AddFile([[sound/gofish/music.mp3]])
resource.AddFile([[sound/gofish/Sound made by Pk191 aka Kemp.tmp]])

local function addmeta()
	local meta = FindMetaTable( "Player" ) 
	if (!meta) then return end 
	
	function meta:AddScore(x) -- bogus function to control AddFrags
		umsg.Start("ScoreChanged", self)
			umsg.Short( x )
		umsg.End()
		return self:AddFrags(x)
	end 
end
addmeta()

function cleanupafter( ply )
	for k,v in pairs(ents.FindByClass("npc_*")) do
		if v:IsValid() and v.fishowner == ply then
			v:Remove()
		end
	end
	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do
		if v:IsValid() and v.fishowner == ply then
			v:Remove()
		end
	end
	for k,v in pairs(ents.FindByClass("fishing_hook")) do
		if v:IsValid() and v.fishowner == ply then
			v:Remove()
		end
	end
	for k,v in pairs(ents.FindByClass("fishing_bait")) do
		if v:IsValid() and v.fishowner == ply then
			v:Remove()
		end
	end
	for k,v in pairs(ents.FindByClass("fishing_rod")) do
		if v:IsValid() and v.fishowner == ply then
			v:Remove()
		end
	end
end

function GM:PlayerDisconnected( ply )
	cleanupafter(ply)
end

function Loadout( ply )
	ply:Give("weapon_physcannon")
	--ply:Give("weapon_physgun") -- For dev tests
	ply:SelectWeapon("weapon_physcannon")
	return true
end

function gravgunPunt( userid, ent )
	/*if 	ent:GetModel() == "models/props_c17/oildrum001_explosive.mdl" or
		ent:GetClass() == "npc_grenade_frag" then
		return true
	end*/
	return true
end

hook.Add( "GravGunPunt", "gravgunPunt", gravgunPunt ) 

function gravgunPickup( ply, ent )
	if not ent:IsValid() then return false end
	
	if ent:GetName() == "Friendly" or ent:GetClass() == "npc_turret_floor" then
		return true
	elseif ent:GetName() == "Enemy" then
		return false
	end
	return true
end
hook.Add("GravGunPickupAllowed", "gravgunPickup", gravgunPickup)

function GM:PlayerShouldTakeDamage( ply, attacker )
		return true
end

function GM:ShowHelp( ply ) 
 	ply:ConCommand( "gofishhelp" ) 
end

function StartNoise( ply )
	timer.Simple(1,function()
		umsg.Start("startthebloodynoise", ply)
			umsg.Entity( ply )
		umsg.End()
		end
	)
end
hook.Add( "PlayerInitialSpawn", "StartNoise", StartNoise ); 

function PlayerSpawns( ply )
	ply:SetTeam(TEAM_FISHING)
end
hook.Add( "PlayerSpawn", "PlayerSpawns", PlayerSpawns )  

function NPCGotKilled( victim, killer, weapon )
	if not killer:IsPlayer() then return end
	if victim:GetName() == "Enemy" then
		killer:AddScore(1)
	elseif victim:GetName() == "Friendly" then
		killer:AddScore(-1)
	end
end
hook.Add("OnNPCKilled","NPCGotKilled",NPCGotKilled)

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	SendMessageToClient("You Got Killed! Better Luck Next Time!", ply)
	ply:CreateRagdoll()
	ply:AddDeaths(1)
	ply:SetTeam(TEAM_DEAD)
	local infl = dmginfo:GetInflictor()

	if attacker:IsValid() then
		if attacker:IsPlayer() then
			if attacker == ply then
				attacker:AddScore( -10 ) -- You killed yourself
			else
				attacker:AddScore( 15 ) -- Someone else killed you
				if IsValid(infl) then
					if infl:IsOnFire() then
						attacker:AddScore( 15 ) -- If object is on fire and you die +15 Points
					end
					infl:Remove()
				end
			end
		end
	end
end

local spawnsound = Sound("ui/buttonclickrelease.wav")
function ProcessChat( ply, text )
	local thingies = {
		{"!rod", "fishing_rod"},
		{"!bait", "fishing_bait"},
		{"!hook", "fishing_hook"}
	}
	
	for _,m in pairs(thingies) do
		if string.find(text, m[1]) == 1 then
		
			local sent = scripted_ents.GetStored( m[2] )
 			if ( sent ) then
 				local sent = sent.t
				local trace = {}
				trace.start = ply:GetShootPos()
				trace.endpos = trace.start + (ply:GetAimVector() * 1024)
				trace.filter = ply
				local tr = util.TraceLine( trace ) 
 				
 				local entity = sent:SpawnFunction( ply, tr )
				entity.fishowner = ply
 					
 					if ply:GetVar( "gofish_".. m[2], nil ) != nil and ply:GetVar( "gofish_".. m[2], nil ):IsValid() then
 						ply:GetVar( "gofish_".. m[2], nil ):Remove()
 					end
 					ply:SetVar( "gofish_".. m[2], entity )
 			end
 			ply:EmitSound( spawnsound, 100, 100 )
 			
			return "" -- Don't say anything
		end
	end
end
hook.Add ( "PlayerSay", "ProcessChat", ProcessChat ) 

function Notice(...)
	for k,v in pairs(player:GetAll()) do
		v:PrintMessage( HUD_PRINTTALK, tostring(...) ) 
	end
end
hook.Add( "PlayerLoadout", "gravAndShot", Loadout)

Catchphrase = {

		// ITEMS & AMMO
		{"item_battery", 			"models/Items/battery.mdl"}, -- Armor Kit
		{"item_healthkit", 			"models/Items/HealthKit.mdl"}, -- Health Kit
		{"item_healthvial", 		"models/healthvial.mdl"},		-- Health Vial
		{"item_ammo_pistol", "models/Items/BoxSRounds.mdl"},
		{"item_box_buckshot", "models/Items/BoxBuckshot.mdl"},
		{"item_ammo_357", "models/Items/357ammo.mdl"},
		
		// PROPS
		{"prop_physics_multiplayer",	"models/props_c17/oildrum001_explosive.mdl"}, -- Explosive Barrel
		{"prop_physics_multiplayer",	"models/props_wasteland/laundry_cart002.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/Shoe001a.mdl"}, -- Boot ;)
		{"prop_physics_multiplayer",	"models/props_junk/PlasticCrate01a.mdl"}, -- Plastic Crate
		{"prop_physics_multiplayer",	"models/props_junk/watermelon01.mdl"}, -- Watermelon
		{"prop_physics_multiplayer",	"models/props_junk/MetalBucket01a.mdl"}, -- Metal Bucket
		{"prop_physics_multiplayer",	"models/props_c17/doll01.mdl"}, -- Babeh
		{"prop_physics_multiplayer",	"models/Gibs/wood_gib01a.mdl"}, -- Wooden Gib 1
		{"prop_physics_multiplayer",	"models/props_c17/metalPot002a.mdl"}, -- Metal Pot 1
		{"prop_physics_multiplayer",	"models/props_c17/metalPot001a.mdl"}, -- Metal Pot 2
		{"prop_physics_multiplayer",	"models/props_c17/streetsign001c.mdl"}, -- Sign 1
		{"prop_physics_multiplayer",	"models/props_c17/SuitCase001a.mdl"}, -- Suitcase
		{"prop_physics_multiplayer",	"models/props_junk/cardboard_box003b.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/cardboard_box002b.mdl"},
		{"prop_physics_multiplayer",	"models/props_lab/kennel_physics.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/wood_crate001a_damaged.mdl"},
		{"prop_physics_multiplayer",	"models/props_interiors/SinkKitchen01a.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/garbage_metalcan001a.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/garbage_plasticbottle002a.mdl"},
		{"prop_physics_multiplayer",	"models/props_vehicles/carparts_door01a.mdl"},
		{"prop_physics_multiplayer",	"models/props_junk/Wheebarrow01a.mdl"},
		{"prop_physics_multiplayer",	"models/props_c17/TrapPropeller_Blade.mdl"},

	    // WEAPONS
		{"weapon_357", "models/weapons/w_357.mdl"},
		{"weapon_pistol", "models/weapons/w_pistol.mdl"},
		{"weapon_shotgun", "models/weapons/w_shotgun.mdl"},

	}
	for k,v in pairs(Catchphrase) do
		print("Precaching "..v[2])
		util.PrecacheModel( v[2] )
		resource.AddFile( v[2] )
		if v[3] then resource.AddFile( v[3] ) end
	end
	

game.ConsoleCommand( "sk_max_alyxgun 25\n")
game.ConsoleCommand( "sk_npc_dmg_alyxgun 1.5\n")
game.ConsoleCommand( "sk_plr_dmg_alyxgun 2.5\n")
game.ConsoleCommand( "sk_barnacle_health 35\n")
game.ConsoleCommand( "sk_barney_health 35\n")
game.ConsoleCommand( "sk_bullseye_health 35\n")
game.ConsoleCommand( "sk_citizen_health 15\n")
game.ConsoleCommand( "sk_combine_s_health 50\n")
game.ConsoleCommand( "sk_combine_s_kick 20\n")
game.ConsoleCommand( "sk_combine_guard_health 70\n")
game.ConsoleCommand( "sk_combine_guard_kick 30\n")
game.ConsoleCommand( "sk_strider_health 350\n")
game.ConsoleCommand( "sk_strider_num_missiles1 5\n")
game.ConsoleCommand( "sk_strider_num_missiles2 7\n")
game.ConsoleCommand( "sk_strider_num_missiles3 7\n")
game.ConsoleCommand( "sk_headcrab_health 10\n")
game.ConsoleCommand( "sk_headcrab_melee_dmg 5\n")
game.ConsoleCommand( "sk_headcrab_fast_health 10\n")
game.ConsoleCommand( "sk_headcrab_poison_health 35\n")
game.ConsoleCommand( "sk_manhack_health 25\n")
game.ConsoleCommand( "sk_manhack_melee_dmg 30\n")
game.ConsoleCommand( "sk_metropolice_health 40\n")
game.ConsoleCommand( "sk_metropolice_stitch_reaction 1.0\n")
game.ConsoleCommand( "sk_metropolice_stitch_tight_hitcount 2\n")
game.ConsoleCommand( "sk_metropolice_stitch_at_hitcount 1\n")
game.ConsoleCommand( "sk_metropolice_stitch_behind_hitcount 3\n")
game.ConsoleCommand( "sk_metropolice_stitch_along_hitcount 2\n")
game.ConsoleCommand( "sk_rollermine_shock 20\n")
game.ConsoleCommand( "sk_rollermine_stun_delay 3\n")
game.ConsoleCommand( "sk_rollermine_vehicle_intercept 2\n")
game.ConsoleCommand( "sk_scanner_health 30\n")
game.ConsoleCommand( "sk_scanner_dmg_dive 25\n")
game.ConsoleCommand( "sk_stalker_health 50\n")
game.ConsoleCommand( "sk_stalker_melee_dmg 10\n")
game.ConsoleCommand( "sk_vortigaunt_health 100\n")
game.ConsoleCommand( "sk_vortigaunt_dmg_claw 10\n")
game.ConsoleCommand( "sk_vortigaunt_dmg_rake 25\n")
game.ConsoleCommand( "sk_vortigaunt_dmg_zap 50\n")
game.ConsoleCommand( "sk_vortigaunt_armor_charge 30\n")
game.ConsoleCommand( "sk_zombie_health 50\n")
game.ConsoleCommand( "sk_zombie_dmg_one_slash 25\n")
game.ConsoleCommand( "sk_zombie_dmg_both_slash 50\n")
game.ConsoleCommand( "sk_zombie_poison_health 175\n")
game.ConsoleCommand( "sk_zombie_poison_dmg_spit 20\n")
game.ConsoleCommand( "sk_antlion_health 30\n")
game.ConsoleCommand( "sk_antlion_swipe_damage 5\n")
game.ConsoleCommand( "sk_antlion_jump_damage 5\n")
game.ConsoleCommand( "sk_antlionguard_health 500\n")
game.ConsoleCommand( "sk_antlionguard_dmg_charge 20\n")
game.ConsoleCommand( "sk_antlionguard_dmg_shove 10\n")
game.ConsoleCommand( "sk_ichthyosaur_health 200\n")
game.ConsoleCommand( "sk_ichthyosaur_melee_dmg 8\n")
game.ConsoleCommand( "sk_gunship_burst_size 15\n")
game.ConsoleCommand( "sk_gunship_health_increments 5\n")
game.ConsoleCommand( "sk_npc_dmg_gunship 40\n")
game.ConsoleCommand( "sk_npc_dmg_gunship_to_plr 5\n")
game.ConsoleCommand( "sk_npc_dmg_helicopter  6\n")
game.ConsoleCommand( "sk_npc_dmg_helicopter_to_plr 4\n")
game.ConsoleCommand( "sk_helicopter_grenadedamage 30\n")
game.ConsoleCommand( "sk_helicopter_grenaderadius 275\n")
game.ConsoleCommand( "sk_helicopter_grenadeforce 55000\n")
game.ConsoleCommand( "sk_npc_dmg_dropship 2\n")
game.ConsoleCommand( "sk_apc_health 750\n")

function GM:PlayerSetModel( ply )
	ply:SetModel( "models/player/corpse1.mdl" )
end

function SendMessageToClient(text, ply)
	net.Start("msg1")
	net.WriteString(text)
	net.Send(ply)
end
