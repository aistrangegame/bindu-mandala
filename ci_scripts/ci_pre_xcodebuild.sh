#!/bin/sh
#
# Xcode Cloud pre-xcodebuild hook.
#
# TestFlight rejects a build whose number collides with one already uploaded
# for the same marketing version. `CURRENT_PROJECT_VERSION` is committed as a
# fixed value, so left alone every Xcode Cloud build would upload the same
# number and only the first would be accepted.
#
# Xcode Cloud provides `CI_BUILD_NUMBER` — a monotonically increasing integer
# per workflow. Stamp it into the project's build number here so every build
# from `main` becomes a fresh, accepted TestFlight build automatically. The
# marketing version (`MARKETING_VERSION`) is left untouched and bumped by hand
# when a release deserves a new version.
#
# Runs before every xcodebuild invocation; idempotent (sets the same value each
# time). No secret is touched, nothing is echoed but the number itself.

set -e

if [ -z "$CI_BUILD_NUMBER" ]; then
  echo "ci_pre_xcodebuild: CI_BUILD_NUMBER not set — leaving build number as-is."
  exit 0
fi

PROJECT="$CI_PRIMARY_REPOSITORY_PATH/iOS/Bindu Mandala.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT" ]; then
  echo "ci_pre_xcodebuild: project.pbxproj not found at expected path — skipping."
  exit 0
fi

sed -i '' -E "s/CURRENT_PROJECT_VERSION = [0-9]+;/CURRENT_PROJECT_VERSION = ${CI_BUILD_NUMBER};/g" "$PROJECT"
echo "ci_pre_xcodebuild: set CURRENT_PROJECT_VERSION = ${CI_BUILD_NUMBER}."
