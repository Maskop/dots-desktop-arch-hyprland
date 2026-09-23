------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "DP-2",
	mode = "3440x1440@180.00Hz",
	position = "0x0",
	scale = 1,
	transform = 0,
	disabled = false,
	bitdepth = 10,
	vrr = 1,
})

hl.monitor({
	output = "HDMI-A-2",
	mode = "1440x900@74.98Hz",
	position = "3440x0",
	scale = 1,
	transform = 1,
	disabled = false,
	cm = "srgb",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60.00Hz",
	position = "4340x0",
	scale = 1,
	transform = 0,
	disabled = true,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "wofi"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch- ")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("HYPRSHOT_DIR", "/home/maskop/Pictures/Screenshots")
-----------------------
----- PERMISSIONS -----
-----------------------

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

--------------------
----- SOURCING -----
--------------------

require("hyprland/autostart")
require("hyprland/keybinds")
require("hyprland/look")
require("hyprland/input")
require("hyprland/windows-workspaces")
-- require("hyprland/plugins")
