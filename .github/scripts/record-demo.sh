#!/usr/bin/env bash
# Runs the scripted tour and records the emulator screen once the app starts.
set -u
APP=com.dinakarnayak.landed

flutter test integration_test/demo_test.dart -d emulator-5554 > tour.log 2>&1 &
TEST_PID=$!

# Wait for the app to launch (the build and install happen first).
for i in $(seq 1 600); do
  if adb shell pidof "$APP" > /dev/null 2>&1; then break; fi
  sleep 1
done
sleep 1
adb shell "screenrecord --bit-rate 6000000 --time-limit 180 /sdcard/demo.mp4" &
REC_PID=$!

wait $TEST_PID
STATUS=$?
sleep 2
adb shell pkill -INT screenrecord || true
wait $REC_PID 2>/dev/null || true
sleep 3
adb pull /sdcard/demo.mp4 demo-raw.mp4
tail -30 tour.log
exit $STATUS
