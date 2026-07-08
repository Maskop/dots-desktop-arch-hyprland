-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- bezier = name,x1,y1,x2,y2  ->  hl.curve(name, { type = "bezier", points = ... })
-- animation = leaf,on,speed,curve[,style]  ->  hl.animation({ ... })

hl.config({
    animations = { enabled = true },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },     { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 },  { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },        { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },    { 0.75, 1.0 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },     { 0.1, 1 } } })
hl.curve("backAndForth",   { type = "bezier", points = { { 0.68, -0.55 }, { 0.27, 1.55 } } }) -- defined but unused, kept from original

hl.animation({ leaf = "global",      enabled = true, speed = 10,   bezier = "default" })

hl.animation({ leaf = "border",      enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 20,   bezier = "easeOutQuint" })

hl.animation({ leaf = "windows",     enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })

hl.animation({ leaf = "fadeIn",      enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3.03, bezier = "quick" })

hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

hl.animation({ leaf = "workspaces",    enabled = true, speed = 1, bezier = "easeInOutCubic", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1, bezier = "easeInOutCubic", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "easeInOutCubic", style = "slide" })
