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
# The Metal toolchain is NOT part of Xcode any more, and on Xcode Cloud it
# arrives DOWNLOADED BUT NOT INSTALLED.
#
# Since Xcode 16 the Metal compiler ships as a separately-downloaded component.
# The first Cloud build that ever had to compile a shader (build 56, of
# 5cec97f) died with
#
#     error: cannot execute tool 'metal' due to missing Metal Toolchain;
#            use: xcodebuild -downloadComponent MetalToolchain
#     Command CompileMetalFile failed with a nonzero exit code
#
# and no diagnostics file, because the compiler was never there to write one.
# Every Cloud build since the shaders landed on 09-21 failed this way; the last
# green ones are from 09-07, when the project had no .metal files at all.
#
# The trap is that `-downloadComponent` does NOT fix it there. The runner
# already holds the asset and the command refuses with exit 70:
#
#     error: Metal Toolchain is already imported at
#       /Users/local/Library/Developer/DVTDownloads/Assets/MetalToolchain/
#       MetalToolchain-27A266a.exportedBundle
#
# Note *exportedBundle*: downloaded and exported, never imported, so `metal` is
# still not on the toolchain path. `-importComponent` is what installs it. The
# bundle carries the Xcode build version in its name, so it is globbed rather
# than hard-coded, and both the runner's home and /Users/local are searched.
#
# `xcrun metal --version` is the only honest test — `-showComponent` can report
# an asset that the build still cannot execute. Nothing here is fatal: if it
# cannot be fixed we let the build run so the log shows the real shader error
# rather than this hook's exit code.
# ---------------------------------------------------------------------------
metal_works() { xcrun metal --version >/dev/null 2>&1; }

if metal_works; then
  echo "ci_post_clone: Metal toolchain already usable."
else
  echo "ci_post_clone: metal not executable — installing the toolchain…"
  xcodebuild -downloadComponent MetalToolchain || true

  if ! metal_works; then
    BUNDLE=""
    for root in "$HOME/Library/Developer/DVTDownloads/Assets/MetalToolchain" \
                "/Users/local/Library/Developer/DVTDownloads/Assets/MetalToolchain"; do
      for candidate in "$root"/*.exportedBundle; do
        [ -e "$candidate" ] && BUNDLE="$candidate" && break 2
      done
    done

    if [ -n "$BUNDLE" ]; then
      echo "ci_post_clone: importing $BUNDLE"
      xcodebuild -importComponent MetalToolchain -importPath "$BUNDLE" || true
    else
      echo "ci_post_clone: no exported MetalToolchain bundle found to import."
    fi
  fi

  if metal_works; then
    echo "ci_post_clone: Metal toolchain ready — $(xcrun metal --version 2>&1 | head -1)"
  else
    echo "ci_post_clone: WARNING — metal is still not executable."
    echo "ci_post_clone: continuing so the build surfaces the real shader error."
  fi
fi

if [ -z "$AIRTABLE_PAT" ]; then
  echo "ci_post_clone: AIRTABLE_PAT not set — building in local-first mode."
  exit 0
fi

CONFIG_FILE="$CI_PRIMARY_REPOSITORY_PATH/iOS/Bindu Mandala/Config.local.xcconfig"

printf 'AIRTABLE_PAT = %s\n' "$AIRTABLE_PAT" > "$CONFIG_FILE"
echo "ci_post_clone: wrote Config.local.xcconfig (AIRTABLE_PAT injected)."
