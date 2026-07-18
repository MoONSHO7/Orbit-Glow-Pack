-- Registers the bundled 30-frame two-layer flipbook glows with LibOrbitGlow; loads after Orbit so the lib is up.
local LCG = LibStub and LibStub("LibOrbitGlow-1.0", true)
if not (LCG and LCG.RegisterGlow) then return end

local BASE = "Interface\\AddOns\\Orbit-Glow-Pack\\Textures\\orbit-glow-"
local BURST = BASE .. "burst-"      -- one shared start/end lifecycle, played by every glow (see .scripts/make-glow-burst.py)

-- Per-type loop (shape bakes: square/soft/softer/round ring corners matching Orbit's icon mask styles) + one universal proc start/end for every glow — motes onto the border in, border-to-center swirl out; the burst is radial, so it exists only as -square regardless of requested shape.
local function Resolver(name)
    return function(phase, shape, suffix)
        if phase == "loop" then return BASE .. name .. "-loop-" .. shape .. suffix .. ".tga" end
        return BURST .. phase .. "-square" .. suffix .. ".tga"
    end
end

-- Radial emanation designs (no border ring): one square bake fits every corner style, so the lib's shape fallback keeps them on -square.
local SQUARE_ONLY = { embers = true, polyexpand = true, reticle = true, ripplewave = true }
local ALL_SHAPES = { square = true, soft = true, softer = true, round = true }
local SQUARE = { square = true }

local GLOWS = {
    "arcs4", "beacon", "chase", "comet2",
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
        resolve = Resolver(name),
        rows = 6, cols = 5, frames = 30,
        shapes = SQUARE_ONLY[name] and SQUARE or ALL_SHAPES,
        source = "Orbit-Glow-Pack",
    })
end
