
-- Vars
local intOffsetY = 0
local intMaxW = ScrW()
local intMaxH = ScrH()

local intBarW = 40
local intBarH = 195
local intBarX = intMaxW - intBarW - 20
local intBarY = intMaxH - intBarH - 20

local ply = LocalPlayer
local Health = Health
local getDarkRPVar = getDarkRPVar
local Armor = Armor
local GetActiveWeapon = GetActiveWeapon
local Clip1 = Clip1
local GetPrintName = GetPrintName
local IsValid = IsValid
local ScreenScale = ScreenScale
local draw = draw
local Lerp = Lerp
local GetAmmoCount = GetAmmoCount
local GetPrimaryAmmoType = GetPrimaryAmmoType
local GetSecondaryAmmoType = GetSecondaryAmmoType

-- Lerps
local lerpHealth = 0
local lerpHunger = 0
local lerpArmor = 0

-- Colors
local tBlueGrey = Color(52, 73, 94)
local tLightRed = Color(231, 76, 60)
local tLightOrange = Color(230, 126, 34)
local tLightBlue = Color(52, 152, 219)

-- Functions
local function RespX(x) return x/1920*intMaxW end
local function RespY(y) return y/1080*intMaxH end

hook.Add("HUDPaint", "HUD::HudNew", function()
    lerpHealth = Lerp( 0.05, lerpHealth, math.Clamp( ply():Health() * intBarH / 100, 1, intBarH + 1 ) )
    lerpHunger = Lerp( 0.05, lerpHunger, math.Clamp( ply():getDarkRPVar("Energy") * intBarH / 100, 1, intBarH + 1 ) )
    lerpArmor = Lerp( 0.05, lerpArmor, math.Clamp( ply():Armor() * intBarH / 100, 1, intBarH + 1 ) )
    --vie
    draw.RoundedBox(8, RespX(17), RespY(980), RespX(200), RespY(20), tBlueGrey)
    draw.RoundedBox(8, RespX(19), RespY(983), RespX(lerpHealth), RespY(15), tLightRed)

    --faim
    draw.RoundedBox(8, RespX(17), RespY(1010), RespX(200), RespY(20), tBlueGrey)
    draw.RoundedBox(8, RespX(19), RespY(1012), RespX(lerpHunger), RespY(15), tLightOrange)

    if ply():Armor() >= 1 then
        --Armure
        draw.RoundedBox(8, RespX(17), RespY(1040), RespY(200), RespY(20), tBlueGrey)
        draw.RoundedBox(8, RespX(19), RespY(1042), RespY(lerpArmor), RespY(15), tLightBlue)
    else
        draw.RoundedBox(8, RespX(17), RespY(1040), RespX(200), RespY(20), tBlueGrey)
        draw.DrawText("Pas d'armure", "Trebuchet18", RespX(115), RespY(1042), tLightRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    draw.RoundedBox(8, ScreenScale(565), ScreenScale(325), ScreenScale(70), ScreenScale(30), tBlueGrey)
    --draw.DrawText(LocalPlayer():GetAmmo(), "Trebuchet24", ScreenScale(55), ScreenScale(350), Color(231, 76, 60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    local swp = ply():GetActiveWeapon()
    if not IsValid(swp) then return end

    draw.DrawText(swp:GetPrintName(), "Trebuchet24", ScreenScale(600), ScreenScale(330), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local ammoFunc = swp:Clip1().. "/"..ply():GetAmmoCount(swp:GetPrimaryAmmoType())
    local ammoFuncElse = ply():GetAmmoCount(swp:GetPrimaryAmmoType())
    local AmmoSecond = ply():GetAmmoCount(swp:GetSecondaryAmmoType())
    if(swp:Clip1() != -1) then
        draw.DrawText("Munitions: "..ammoFunc, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)    
    else
        draw.DrawText("Munitions: "..ammoFuncElse, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if (ply:GetAmmoCount(swp:GetSecondaryAmmoType()) > 0) then
        draw.DrawText("Secondaire: "..AmmoSecond, "Trebuchet24", ScreenScale(600), ScreenScale(340), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end


end)

hook.Add( "OnScreenSizeChanged", "HUD::WhenSizeIsChanged", function()
    intMaxW = ScrW()
    intMaxH = ScrH()
end )

hook.Add( "HUDDrawTargetID", "HUD::HidePlayerInfo", function()
    return false -- désactiver les infos de bases
end )

local HideElementsTable = {
    ["DarkRP_HUD"]            = true,
    ["DarkRP_ZombieInfo"]     = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"]      = true,
    ["DarkRP_Agenda"]         = true,
    ["CHudHealth"]            = true,
    ["CHudBattery"]           = true,
    ["CHudSuitPower"]         = true,
    ["CHudAmmo"]              = true,
    ["CHudSecondaryAmmo"]     = true
}
local function HideElements( element )
    if HideElementsTable[ element ] then
        return false
    end
end
hook.Add( "HUDShouldDraw", "HUD::HideElements", HideElements )

