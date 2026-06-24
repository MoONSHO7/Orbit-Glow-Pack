-- Registers the bundled 30-frame two-layer flipbook glows with LibOrbitGlow; loads after Orbit so the lib is up.
local LCG = LibStub and LibStub("LibOrbitGlow-1.0", true)
if not (LCG and LCG.RegisterGlow) then return end

local BASE = "Interface\\AddOns\\Orbit-Glow-Pack\\Textures\\orbit-glow-"

local GLOWS = {
    "ants", "arc3", "arcs4", "beacon", "chase", "comet2",
    "cometdual", "cometrays", "cometwave", "dashdual", "dashfast", "dashpulse",
    "dashwave", "dual", "embers", "halo", "marchwide", "megaswirl",
    "neon", "orbittail", "pinarc", "pinchase", "pincomet", "pinneon",
    "pinstrobe", "pinswirl", "pinwave", "polyexpand", "pulse", "pulsewave",
    "radar", "rays", "raysfine", "raywave", "reticle", "ripplewave",
    "slowswirl", "sparkring", "spin", "spiral2", "strobe", "sweepfast",
    "swirl", "thinpulse", "tracer", "vortex",
}

for _, name in ipairs(GLOWS) do
    LCG:RegisterGlow(name, {
        layered = true,
        path = BASE .. name,
        rows = 6, cols = 5, frames = 30,
        shapes = { square = true },
        source = "Orbit-Glow-Pack",
    })
end
