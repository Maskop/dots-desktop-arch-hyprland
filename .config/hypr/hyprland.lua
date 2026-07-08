-- Converted from hyprland.conf (hyprlang) to the native Lua config
-- introduced in Hyprland 0.55. Docs: https://wiki.hypr.land/Configuring/Start/
--
-- NOTE: if ~/.config/hypr/hyprland.lua exists, Hyprland ignores hyprland.conf
-- entirely (checked once at startup).

----------------
--- MONITORS ---
----------------

-- All monitor definitions live in hyprland/monitors.lua as a global
-- `monitors` table -- edit that one file when the setup changes.
-- Required first so the table is available to everything below.
require("hyprland/monitors")

-------------------
--- MY PROGRAMS ---
-------------------

-- Globals (not `local`) on purpose: require()'d files run in separate
-- scopes but share _G, so these stay visible in keybinds.lua etc.
terminal    = "kitty"
fileManager = "dolphin"
menu        = "wofi"

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24") -- was set twice in the original, deduped
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-------------------
--- PERMISSIONS ---
-------------------

-- Same as before: these only take effect if ecosystem.enforce_permissions
-- is enabled, and permission changes require a full Hyprland restart.
hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------
--- SOURCING ---
----------------

-- require() paths are relative to this file's directory.
-- Each require() runs in its own scope, so an error in one file
-- doesn't kill the others.
require("hyprland/autostart")
require("hyprland/keybinds")
require("hyprland/look")
require("hyprland/input")
require("hyprland/windows-workspaces")
require("hyprland/plugins")
