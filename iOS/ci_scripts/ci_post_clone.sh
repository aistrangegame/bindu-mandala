#!/bin/sh
# NOTE: ci_scripts/ must sit beside "Bindu Mandala.xcodeproj" (here, under iOS/) — Xcode Cloud only runs hooks adjacent to the project.
#
# Xcode Cloud post-clone hook.
#
# The Airtable PAT lives in Config.local.xcconfig, which is gitignored and so
# never reaches the cloud. This hook recreates it from a workflow environment
# variable named AIRTABLE_PAT (add it as a *secret* in the Xcode Cloud workflow:
# App Store Connect → Xcode Cloud → your workflow → Environment → Variables).
#
# When AIRTABLE_PAT is not set the build still succeeds — the app simply runs in
# local-first mode (the 16 bootstrap Karṣiṇīs, no remote sync). That is a valid,
# non-failing build, so this script never fails the pipeline.
#
# The token value is never echoed, so it stays out of the build logs.

set -e

# ---------------------------------------------------------------------------
# The Metal toolchain is NOT part of Xcode any more.
#
# Since Xcode 16 the Metal compiler ships as a separately-downloaded component
# (a MobileAsset cryptex — on a developer's Mac it resolves to
# `…/com.apple.MobileAsset.MetalToolchain-*/Metal.xctoolchain/usr/bin/metal`).
# A fresh Xcode Cloud runner does not have it, so the first build that has to
# compile a shader dies with
#
#     Command CompileMetalFile failed with a nonzero exit code
#
# and NO diagnostics file, because the compiler was never there to write one.
# This bit us the moment `RoomLightPass.metal` — the SwiftUI shader pass the
# renderer ruling chose — reached Cloud for the first time (build of d689e5f);
# every earlier Cloud build was green only because the project had no shaders.
#
# Downloading is idempotent and a no-op when the component is already present.
# It is deliberately NOT fatal: if it fails we let the build proceed so the log
# shows the real Metal error rather than this hook's exit code.
# ---------------------------------------------------------------------------
echo "ci_post_clone: ensuring the Metal toolchain is present…"
if xcodebuild -downloadComponent MetalToolchain; then
  echo "ci_post_clone: Metal toolchain ready."
else
  echo "ci_post_clone: WARNING — could not download the Metal toolchain (exit $?)."
  echo "ci_post_clone: continuing so the build surfaces the real shader error."
fi

if [ -z "$AIRTABLE_PAT" ]; then
  echo "ci_post_clone: AIRTABLE_PAT not set — building in local-first mode."
  exit 0
fi

CONFIG_FILE="$CI_PRIMARY_REPOSITORY_PATH/iOS/Bindu Mandala/Config.local.xcconfig"

printf 'AIRTABLE_PAT = %s\n' "$AIRTABLE_PAT" > "$CONFIG_FILE"
echo "ci_post_clone: wrote Config.local.xcconfig (AIRTABLE_PAT injected)."
