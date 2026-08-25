# Orbit Glow Pack

A **media pack** of animated icon glows for [Orbit](../Orbit) and any other **LibOrbitGlow-1.0** consumer. It contains no engine code: Orbit-Glow-Pack *provides* media, while a consumer-provided LibOrbitGlow *plays* it.

## How it works

`Register.lua` registers immediately when a consumer has already provided LibOrbitGlow. When the pack loads first, it watches `ADDON_LOADED` and registers as soon as any later addon provides the library, then removes its watcher. It has no dependency on Orbit or any other specific consumer.

```lua
LCG:RegisterGlow("rimchase", {
    layered = true,                                              -- body (BLEND) + core (ADD) two-layer
    loopOnly = true,                                             -- starts directly on the loop and clears immediately
    resolve = Resolver("rimchase"),                              -- resolves only this type's loop atlas
    rows = 6, cols = 5, frames = 30,                             -- 30-frame 5x6 flipbook (Blizzard layout)
    shapes  = { square = true, soft = true, softer = true, round = true },  -- corner shapes shipped for this glow
    source  = "Orbit-Glow-Pack",
})
```

Every pack glow is **loop-only**. `Proc:Start` begins the selected loop immediately, while `Proc:Stop` clears it immediately; there are no shared lifecycle flourishes or hidden start/end paths. The `Resolver(name)` closure in `Register.lua` resolves only the loop phase, and `loopOnly = true` makes that contract explicit to LibOrbitGlow. Consumers may use either lifecycle-shaped calls or the direct loop API:

```lua
local proc = LibStub("LibOrbitGlow-1.0").Proc
proc:Loop(frame, { glow = "rimchase", color = {r,g,b,a} })
proc:Clear(frame, { glow = "rimchase" })
```

If this pack isn't installed, those glow names simply aren't registered — LibOrbitGlow falls back to its built-in baseline (`blizzard`, the WoW proc atlas), so callers degrade gracefully.

## Textures

`Textures/orbit-glow-<type>-loop-<shape>[-core].tga` — the 36 shape-aware border/edge glow types ship 4 corner shapes (`square`, `soft`, `softer`, `round` — ring corner radii matching Orbit's `orbit-soft/softer/round` icon mask styles at the 40px reference icon), and the 4 radial emanation types (`embers`, `polyexpand`, `reticle`, `ripplewave`) ship `square` only (no border ring — one bake fits every corner style via the lib's shape fallback). That is 36×4×2 + 4×2 = 296 files. Every texture is a 30-frame `5×6` flipbook with 128px cells and straight-alpha white RGB so LibOrbitGlow recolours it via `SetVertexColor`. Legacy border loops come from `.scripts/make-glow-pack.py`, radial loops from `make-glow-pack2.py`, and Fine Edge from `make-fine-edge-flipbooks.py`.

The Fine Edge additions are `rimchase`, `twincomet`, `dashwave`, `halobreathe`, `ripplepair`, and `comettail`. `dashwave` keeps its existing registry key while replacing the older bake, so saved selections continue to resolve. All three generators now share the same visual contract: a restrained tintable bloom/body in the BLEND sheet and a narrow synchronized hot pass in the additive `-core` sheet. Legacy border motion follows true rounded-perimeter distance instead of polar angle, keeping dashes and comets uniform through corners.

Orbit routes the shape automatically — and size-aware: mask corners render at fixed px radii (5/10/14) while glow art stretches with the icon, so `GlowController` picks the baked corner-radius *fraction* nearest `maskRadiusPx / iconSize` (e.g. a 40px icon in Round uses the `round` bake, an 80px icon in Round uses `soft`). A user picks one glow and the art follows both their corner style and each icon's size.

## Adding a glow

Generate its `orbit-glow-<name>-loop-square[-core].tga` pair into `Textures/` (and every additional shape declared for it), then add `"<name>"` to the `GLOWS` list in `Register.lua`. All registrations remain loop-only.
