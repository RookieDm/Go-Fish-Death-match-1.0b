// GAMEMODE SHARED

DeriveGamemode( "base" )

GM.Name 	= "Go Fish: Deathmatch"
GM.Author 	= "Modded and edited by Rookie assistance from Philxyz - Original creators G3X and ReaperSWE"
GM.Version	= "Deatmatch 1.0"

TEAM_FISHING = 1
TEAM_DEAD = 2
team.SetUp (TEAM_FISHING, "Fishermen", Color (50, 178, 255, 255))
team.SetUp (TEAM_DEAD, "Fishfood", Color (150, 0, 0, 255))
