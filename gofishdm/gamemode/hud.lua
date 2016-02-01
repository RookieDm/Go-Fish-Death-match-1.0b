function hud()
	local client = LocalPlayer()
	
	if !client:Alive() then
		return
	end
	
	draw.RoundedBox(0, 0, ScrH() - 100, 250, 100, Color(30, 30, 30, 230))
	draw.SimpleText("Health: "..client:Health().."%", "DermaDefaultBold", 10, ScrH() - 90, Color(255, 255 ,255, 255), 0, 0)
	--[[draw.RoundedBox(0, 10, ScrH() - 75, 100 * 2.25, 15, Color(255, 0, 0, 30))
	draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 15, Color(255, 0, 0, 255))
	draw.RoundedBox(0, 10, ScrH() - 75, math.Clamp(client:Health(), 0, 100) * 2.25, 5, Color(255, 30, 30, 255))
	
	draw.SimpleText("Armor: "..client:Armor().."%", "DermaDefaultBold", 10, ScrH() - 45, Color(255, 255 ,255, 255), 0, 0)
	draw.RoundedBox(0, 10, ScrH() - 30, 100 * 2.25, 15, Color(0, 0, 255, 30))
	draw.RoundedBox(0, 10, ScrH() - 30, math.Clamp(client:Armor(), 0, 100) * 2.25, 15, Color(255, 0, 0, 255))
	draw.RoundedBox(0, 10, ScrH() - 30, math.Clamp(client:Armor(), 0, 100) * 2.25, 5, Color(255, 30, 30, 255))
	
	draw.RoundedBox(0, 255, ScrH() - 70, 125, 70, Color(30, 30, 30, 230))]]
end
hook.Add("HudPaint", "Hud", hud)

function HideHud(name)
	for k, v in pairs("CHudHealth", "CHudBattery") do
		if name == v then
			return false
		end
	end
end
hook.Add("HudShouldDraw", "HideDefaultHud", HideHud)
