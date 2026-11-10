#!/usr/bin/env bash
set -euo pipefail

mkdir -p evidence
package=com.unifranz.medicontrol
device="$(adb devices | awk '/^emulator-[0-9]+[[:space:]]+device$/ {print $1; exit}')"
test -n "$device"
export ANDROID_SERIAL="$device"

capture_final() {
  adb logcat -d -t 1500 > evidence/android-logcat.txt 2>&1 || true
  adb shell dumpsys activity activities | tail -n 100 > evidence/activity.txt 2>&1 || true
}
trap capture_final EXIT

adb logcat -c
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell pm clear "$package"
adb shell am start -W -n "$package/.MainActivity" | tee evidence/apk-launch.txt
sleep 8
adb shell pidof "$package" | tee evidence/apk-process.txt
test -s evidence/apk-process.txt
adb exec-out screencap -p > evidence/00-original-apk-launch.png
adb shell am force-stop "$package"
adb shell pm clear "$package"

timeout 12m flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/android_smoke_test.dart \
  --device-id="$device" \
  2>&1 | tee evidence/integration.log

adb shell am force-stop "$package"
