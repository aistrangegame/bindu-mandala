// The prismatic pass that lies over every room's SceneKit render.
//
// The renderer ruling names this file and names why it is here rather than in
// `Views/Spike/`: *"It is production code the moment this ruling lands."* The
// canvas spike found the constraint it rests on and could not engineer around
// it — `ShaderLibrary` builds only from a compiled `.metallib`, there is no
// from-source initialiser, and a `.metal` file cannot be `#if DEBUG`-ed out of
// a target. So a SwiftUI shader needs a real `.metal` file in the shipping
// target, and this is it. The project uses `PBXFileSystemSynchronizedRootGroup`,
// so placing it in the app folder is the whole of the wiring;
// `RoomCaptureTests` asserts it actually reached `default.metallib` rather than
// trusting that it did.
//
// WHAT THIS PASS IS, AND WHAT IT IS NOT
//
// Everything on the material is SceneKit's: the key's real shading, the real
// shadow the canopy throws across the ground, the ember's real falloff, the
// real emission coming out of the marks she has made. What this adds is the
// part that is on no surface at all — the light standing in the air, the bloom
// around her mark, and the gradient that says where in the body this room is.
//
// It is composited with `.screen`, so it may only ever *add* light and can
// never drive a pixel past white. That is Design's invariant 7 enforced by the
// blend rather than by hoping.
//
// ANICONIC, BY CONSTRUCTION. It carries no glyph, no figure and no sampled
// image: it is a wash, a set of shafts, a bloom and a grain. Every colour it is
// handed comes from `Theme/Atmosphere.swift` through `HomeGem` in Swift — it
// derives no hue of its own and knows no gemstone's name.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

namespace room {

    // A cheap deterministic hash, so the grain is the same grain on every run
    // and on every machine. Her khaḍgamālā position seeds it from Swift.
    inline float hash21(float2 p) {
        float3 q = fract(float3(p.xyx) * float3(0.1031, 0.1030, 0.0973));
        q += dot(q, q.yzx + 33.33);
        return fract((q.x + q.y) * q.z);
    }

    // Design's `smooth` — clamp, then smoothstep.
    inline float smooth01(float t) {
        t = saturate(t);
        return t * t * (3.0 - 2.0 * t);
    }
}

/// The light in the air of one room.
///
/// - `size`   the layer, in points.
/// - `mark`   where her mark sits on screen, in points; `RoomUnits` projects it.
/// - `rake`   the unit direction the key travels across the frame. **Held at
///            (0, 0) in a sourceless room**, which is how this shader learns
///            that the seventh āvaraṇa has no direction to be lit from — the
///            same single fact `RoomLightRig` expresses as a nil light, rather
///            than a second flag that could disagree with it.
/// - `state`  x: the first adaptation, 0→1 over 62 s
///            y: the second, 0→1 over the 120 s after 227 s
///            z: her body altitude — soles 0.94, crown 0.10 — so the room's
///               gravity sits where she is felt
///            w: her deterministic phase, from the khaḍgamālā hash
/// - `gem`    x: her āvaraṇa's gem diffusion (topaz 0.20 … pearl 0.95)
///            y: the mark's bloom radius in points at the room's opening
///            z: the world's veil, 0 at the Bhūpura to 1 at the Bindu
///            w: spare, held at 0 so the signature does not churn
/// - `tint`   her accent, from `Atmosphere`
/// - `bright` her accent lifted, from `Atmosphere`
[[ stitchable ]] half4 roomLightPass(float2 pos,
                                     half4 color,
                                     float2 size,
                                     float2 mark,
                                     float2 rake,
                                     float4 state,
                                     float4 gem,
                                     half4 tint,
                                     half4 bright) {
    const float2 uv = pos / size;

    const float k     = saturate(state.x);
    const float b     = saturate(state.y);
    const float alt   = saturate(state.z);
    const float phase = state.w;
    const float diffusion = saturate(gem.x);
    const float veil      = saturate(gem.z);

    // A room with no source hands in a zero direction. There is no branch on a
    // ring number anywhere in this file: sourcelessness arrives as the absence
    // of a direction, which is what it is.
    const float directed = step(1e-4, length(rake));

    // ── the light that has a direction ──────────────────────────────────────
    // A wash across the frame, travelling the way the key travels. It is at its
    // hardest when the walker arrives and softens as the eye settles.
    const float2 d = normalize(rake + float2(1e-5, 0.0));
    const float along = dot(uv - 0.5, d);
    float wash = room::smooth01(along * 0.9 + 0.55) * (1.0 - 0.55 * k) * directed;

    // Shafts. A tight gem throws few, hard bars; a diffuse one throws none, so
    // the Crown would have none even if it had a direction.
    const float bars = pow(max(0.0, sin(along * 9.0 + phase * 6.2831853)), 26.0);
    const float air = room::smooth01((0.62 - uv.y) * 2.4);
    const float shafts = bars * (1.0 - diffusion) * air * (1.0 - 0.7 * k) * directed;

    // ── the light that has none ─────────────────────────────────────────────
    // Luminous air: what a wholly diffuse gem gives instead of a rake, and the
    // only light in the air of a sourceless room. It rises with the veil,
    // because a veiled world is one where the air itself is what you see.
    const float suspended = (0.35 + 0.45 * veil) * diffusion
                          * (0.55 + 0.45 * room::smooth01(1.0 - abs(uv.y - 0.5) * 1.6));

    // ── her mark ────────────────────────────────────────────────────────────
    // Design's §4.4: past the second adaptation the mark stops being a thing
    // held apart from the room, so its bloom widens and softens rather than
    // hardening into a lamp.
    const float radius = gem.y * (1.0 + 1.8 * b) * (1.0 + 0.9 * diffusion);
    const float bloom = exp(-length(pos - mark) / max(radius, 1.0))
                      * (0.30 + 0.46 * b + 0.14 * k);

    // ── where in the body this room is ──────────────────────────────────────
    // Her altitude, as the room's own gravity. There is no arrangement of this
    // gradient that suits both the soles and the crown, which is the point.
    const float toward = 1.0 - room::smooth01(abs(uv.y - alt) * 1.35);
    // And past the second adaptation the light changes address: it is no longer
    // arriving across the room, it is coming out of what she has marked.
    const float fromHer = room::smooth01((uv.y - (alt - 0.42)) * 1.9);
    const float gravity = mix(toward, fromHer, b) * (0.30 + 0.55 * k);

    // ── assembly ────────────────────────────────────────────────────────────
    // Light, not paint. The geometry's own shading carries the room; this pass
    // adds only what is in the air. The spike learned the other way round: a
    // wash laid on at 0.16 turned the room into a flat field with the material
    // barely readable under it.
    const float3 accent = float3(tint.rgb);
    const float3 hot = float3(bright.rgb);

    float3 lit = accent * (wash * 0.09 + gravity * 0.16 + suspended * 0.10);
    lit += hot * (shafts * 0.34);
    lit += mix(accent, hot, saturate(0.35 + 0.65 * b)) * bloom;

    // Grain, so a dark room does not band. Keyed to her phase.
    lit += (room::hash21(pos + phase * 512.0) - 0.5) * 0.014;

    // The rake retreats as the room reverses and her mark replaces it; the
    // total never climbs, because the reversal is a change of source and not
    // a swell.
    lit *= (1.0 - 0.22 * b);

    lit = clamp(lit, 0.0, 0.86);
    return half4(half3(lit), 1.0h);
}
