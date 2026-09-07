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

if [ -z "$AIRTABLE_PAT" ]; then
  echo "ci_post_clone: AIRTABLE_PAT not set — building in local-first mode."
  exit 0
fi

CONFIG_FILE="$CI_PRIMARY_REPOSITORY_PATH/iOS/Bindu Mandala/Config.local.xcconfig"

printf 'AIRTABLE_PAT = %s\n' "$AIRTABLE_PAT" > "$CONFIG_FILE"
echo "ci_post_clone: wrote Config.local.xcconfig (AIRTABLE_PAT injected)."
