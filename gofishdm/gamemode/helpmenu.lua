local PANEL = {}
function PANEL:Init()
 	self:SetTitle( GAMEMODE.Name .." by ".. GAMEMODE.Author .." - ".. GAMEMODE.Version  )
	self:SetSize(420,230)
	
	self.text = vgui.Create( "DLabel", self ) 
	local xchar = '"'
	self.text:SetWrap( true )
	self.text:SetAutoStretchVertical( true ) 
self.text:SetText( [[How to build a Fishing rod:
Press and hold the Spawnmenu key. ("Q" by default)
Click on the picture of a Rod to create a rod.
Create a fishing hook and attach it to your rod by touching the rod against it.
Then create some bait and put it on the hook.

How to Fish:
Pickup your fishing rod and swing it to throw out the baited hook into the water.
Patience.
If you catch something, you can take it off the hook by touching it. ("E" by default)

Points:
You gain points for being a successful fisher.
You also gain points for killing enemies.
Killing friendlies or killing yourself will deduct points.]] )

	
	self.text:SetTextColor( color_white )
	
	self:InvalidateLayout( true ) 
end

function PANEL:Paint()
	local w,h = self:GetWide(), self:GetTall()
	draw.RoundedBox(12, 0, 0, w, h, Color(150, 150, 150, 255))
	
	draw.RoundedBox(8, 3, 3, w-20-6-3, 19, Color(50/3, 178/3, 255/3, 255)) -- Title
	draw.RoundedBox(8, w-23, 3, 20, 19, Color(50/3, 178/3, 255/3, 255)) -- Title
	
	draw.RoundedBox(8, 3, 25, w-6, h-22-6, Color(50, 50, 50, 255))

end

function PANEL:PerformLayout() 
	self.text:SetPos(8,20+8)
	self.text:SetWide(self:GetWide()-8-8)
	DFrame.PerformLayout( self )
end 
local vGUIWindow = vgui.RegisterTable( PANEL, "DFrame" ) -- Makes a new panel type with DFrame as base?  vgui.RegisterTable( mtable, base ) )

local DermaExample = nil 
local function OpenTestWindow() 
	if ( DermaExample && DermaExample:IsValid() ) then return end -- Don't open a new window if one is already up.
	
 	DermaExample = vgui.CreateFromTable( vGUIWindow ) 
 	DermaExample:MakePopup() 
 	DermaExample:Center() 
end

concommand.Add("gofishhelp", OpenTestWindow)
print("LOADED HELPMENU")