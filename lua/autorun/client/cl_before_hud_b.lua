
local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end
-- Vars
local intMaxW = ScrW()
local intMaxH = ScrH()

local intOffsetY = 0

-- Lerps
local lerpHealth = 0
local lerpHunger = 0
local lerpArmor = 0
local ourMat = Material( "materials/icons/logotrans2.png" )


hook.Add("HUDPaint", "Before::HudNew", function()

    local intBarW = 40
    local intBarH = 195
    local intBarX = intMaxW - intBarW - 20
    local intBarY = intMaxH - intBarH - 20




    lerpHealth = Lerp( 0.05, lerpHealth, math.Clamp( LocalPlayer():Health() * intBarH / 100, 1, intBarH + 1 ) )
    lerpHunger = Lerp( 0.05, lerpHunger, math.Clamp( LocalPlayer():getDarkRPVar("Energy") * intBarH / 100, 1, intBarH + 1 ) )
    lerpArmor = Lerp( 0.05, lerpArmor, math.Clamp( LocalPlayer():Armor() * intBarH / 100, 1, intBarH + 1 ) )
    --vie
    draw.RoundedBox(8, RespX(17), RespY(980), RespX(200), RespY(20), Color(52, 73, 94))
    draw.RoundedBox(8, RespX(19), RespY(983), RespX(lerpHealth), RespY(15), Color(231, 76, 60))

    --faim
    draw.RoundedBox(8, RespX(17), RespY(1010), RespX(200), RespY(20), Color(52, 73, 94))
    draw.RoundedBox(8, RespX(19), RespY(1012), RespX(lerpHunger), RespY(15), Color(230, 126, 34))

    if LocalPlayer():Armor() >= 1 then
        --Armure
        draw.RoundedBox(8, RespX(17), RespY(1040), RespY(200), RespY(20), Color(52, 73, 94))
        draw.RoundedBox(8, RespX(19), RespY(1042), RespY(lerpArmor), RespY(15), Color(52, 152, 219))
    else
        draw.RoundedBox(8, RespX(17), RespY(1040), RespX(200), RespY(20), Color(52, 73, 94))
        draw.DrawText("Pas d'armure", "Trebuchet18", RespX(115), RespY(1042), Color(231, 76, 60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    draw.RoundedBox(8, ScreenScale(565), ScreenScale(325), ScreenScale(70), ScreenScale(30), Color(52, 73, 94))
    --draw.DrawText(LocalPlayer():GetAmmo(), "Trebuchet24", ScreenScale(55), ScreenScale(350), Color(231, 76, 60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local swp = ply:GetActiveWeapon()
    if not IsValid(swp) then return end

    draw.DrawText(swp:GetPrintName(), "Trebuchet24", ScreenScale(600), ScreenScale(330), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local ammoFunc = swp:Clip1().. "/"..ply:GetAmmoCount(swp:GetPrimaryAmmoType())
    local ammoFuncElse = ply:GetAmmoCount(swp:GetPrimaryAmmoType())
    local AmmoSecond = ply:GetAmmoCount(swp:GetSecondaryAmmoType())
    if(swp:Clip1() != -1) then
        draw.DrawText("Munitions: "..ammoFunc, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    
    else
        draw.DrawText("Munitions: "..ammoFuncElse, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if (ply:GetAmmoCount(swp:GetSecondaryAmmoType()) > 0) then
        draw.DrawText("Secondaire: "..AmmoSecond, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
    surface.SetMaterial( ourMat ) -- Use our cached material
    surface.DrawTexturedRect( RespX(10), RespY(880), RespX(128), RespY(128) ) -- Actually draw the rectangle

end)

hook.Add( "HUDDrawTargetID", "HidePlayerInfo", function()
    return false -- désactiver les infos de bases
end )

local HideElementsTable = {
    ["DarkRP_HUD"]                = true,
    ["DarkRP_ArrestedHUD"]        = false,
    ["DarkRP_EntityDisplay"]     = false,
    ["DarkRP_ZombieInfo"]         = true,
    ["DarkRP_LocalPlayerHUD"]     = true,
    ["DarkRP_Hungermod"]         = true,
    ["DarkRP_Agenda"]             = true,
    ["CHudHealth"]                = true,
    ["CHudBattery"]                = true,
    ["CHudSuitPower"]            = true,
    ["CHudAmmo"]                 = true,
    ["CHudSecondaryAmmo"]        = true
}
local function HideElements( element )
    if HideElementsTable[ element ] then
        return false
    end
end
hook.Add( "HUDShouldDraw", "HideElements", HideElements )

local function DisplayNotify(msg) local txt = msg:ReadString() GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong()) surface.PlaySound("buttons/lightswitch2.wav") -- Log to client console MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)


