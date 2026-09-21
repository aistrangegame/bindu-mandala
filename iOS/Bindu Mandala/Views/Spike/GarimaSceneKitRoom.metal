// The light pass for `GarimaSceneKitRoom.swift`, and nothing else.
//
// Spike apparatus. It is named after the one Swift file that uses it and has no
// other caller; when the renderer decision is taken, this file leaves with that
// file. It carries no figure and no glyph — it is a gradient, a set of shafts and
// a bloom, which is to say light, which is what a room is made of.
//
// Every colour it is handed comes from `Theme/Atmosphere.swift` through Swift. It
// derives no hue of its own: `tint` and `bright` are `Atmosphere.accent` and
// `Atmosphere.accentBright` for khaḍgamālā position 4, and this shader only says
// where they fall and how hard.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

namespace garima {

    // A cheap deterministic hash, so the grain is the same grain on every run and
    // on every machine. Her position seeds it from Swift.
    inline float hash21(float2 p) {
        float3 q = fract(float3(p.xyx) * float3(0.1031, 0.1030, 0.0973));
        q += dot(q, q.yzx + 33.33);
        return fract((q.x + q.y) * q.z);
    }

    // smoothstep(0,1,·) with the ends clamped — Design's `smooth`, in Metal.
    inline float smooth01(float t) {
        t = saturate(t);
        return t * t * (3.0 - 2.0 * t);
    }
}

/// Garimā's light, laid over the SceneKit render.
///
/// - `size`        the layer, in points.
/// - `ember`       where the palm's mark sits on screen, in points; Swift projects it.
/// - `rake`        the unit direction the raking light travels across the frame.
/// - `state`       x: the first adaptation (0→1 over 62 s)
///                 y: the second adaptation (0→1 over the 120 s after 227 s)
///                 z: her altitude — feet 0.94, crown 0.10, straight off her card's
///                    bodily location, so the room's gravity sits where she is felt
///                 w: her deterministic phase, from the khaḍgamālā hash
/// - `gem`         x: her āvaraṇa's gem diffusion (ring 1, topaz, 0.20)
///                 y: the ember's radius in points at the room's opening
///                 z, w: spare, held at 0 so the signature does not churn
/// - `tint`        `Atmosphere.accent`
/// - `bright`      `Atmosphere.accentBright`
///
/// The layer is composited with `.screen`, so the shader may only ever *add*
/// light and can never drive a pixel past white — the contrast floor in Design's
/// invariant 7, enforced by the blend rather than by hoping.
[[ stitchable ]] half4 garimaLightPass(float2 pos,
                                       half4 color,
                                       float2 size,
                                       float2 ember,
                                       float2 rake,
                                       float4 state,
                                       float4 gem,
                                       half4 tint,
                                       half4 bright) {
    float2 uv = pos / size;

    const float k     = saturate(state.x);   // the first adaptation
    const float b     = saturate(state.y);   // the second
    const float alt   = saturate(state.z);   // her altitude, 0 crown → 1 feet
    const float phase = state.w;
    const float diffusion = saturate(gem.x);

    // ── the rake ────────────────────────────────────────────────────────────
    // A directional wash across the frame, in the same direction the SceneKit
    // key light travels. It is at its hardest when you arrive and softens as the
    // mass comes down — Design's `raking.intensity = 3.6 - k * 2.0`, as light in
    // the air rather than light on the stone.
    const float2 d = normalize(rake + float2(1e-5, 0.0));
    const float along = dot(uv - 0.5, d);
    float wash = garima::smooth01(along * 0.9 + 0.55);
    wash *= (1.0 - 0.55 * k);

    // Shafts. A tight gem throws few, hard bars; a diffuse one throws none. Ring 1
    // is topaz at 0.20, so the bars are there and they are narrow.
    const float bars = pow(max(0.0, sin(along * 9.0 + phase * 6.2831853)), 26.0);
    const float sharpness = 1.0 - diffusion;
    // They live in the air above the floor, never striping the strata themselves.
    const float air = garima::smooth01((0.62 - uv.y) * 2.4);
    const float shafts = bars * sharpness * air * (1.0 - 0.7 * k);

    // ── the ember ───────────────────────────────────────────────────────────
    // The mark the palm left, still glowing. Design: its emission goes 1.4 → 4.8
    // and its scale 1 → 2.8 across the second adaptation, so the bloom widens and
    // hardens as the room reverses.
    const float radius = gem.y * (1.0 + 1.8 * b) * (1.0 + 0.9 * diffusion);
    const float dist = length(pos - ember);
    const float bloom = exp(-dist / max(radius, 1.0)) * (0.32 + 0.52 * b + 0.14 * k);

    // ── where the weight sits ───────────────────────────────────────────────
    // Her bodily location is the soles and the Mūlādhāra. The room is therefore
    // lit from low down and darkens upward, and there is no arrangement of this
    // gradient that would suit a Śakti felt at the crown.
    const float toward = 1.0 - garima::smooth01(abs(uv.y - alt) * 1.35);
    // Past the second adaptation the light has changed address: it is no longer
    // raking in from the side, it is coming up out of what you are standing on.
    const float fromBelow = garima::smooth01((uv.y - (alt - 0.42)) * 1.9);
    const float ground = mix(toward, fromBelow, b) * (0.30 + 0.55 * k);

    // ── assembly ────────────────────────────────────────────────────────────
    const float3 accent = float3(tint.rgb);
    const float3 hot = float3(bright.rgb);

    // Light, not paint. The first pass laid the wash on at 0.16 and the room came
    // out a flat brown field with the strata barely under it — the shader was doing
    // the SceneKit render's job. The geometry's own shading carries the room; this
    // pass only adds what is in the air.
    float3 lit = accent * (wash * 0.09 + ground * 0.16);
    lit += hot * (shafts * 0.34);
    lit += mix(accent, hot, saturate(0.35 + 0.65 * b)) * bloom;

    // Grain, so the strata do not band in the dark. Keyed to her phase.
    const float grain = (garima::hash21(pos + phase * 512.0) - 0.5) * 0.014;
    lit += grain;

    // The rake retreats as the room reverses; the ground light replaces it, and
    // the total never climbs — the reversal is a change of source, not a swell.
    lit *= (1.0 - 0.22 * b);

    lit = clamp(lit, 0.0, 0.86);

    return half4(half3(lit), 1.0h);
}
