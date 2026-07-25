@echo off
setlocal EnableDelayedExpansion

REM ============================================================================
REM run_with_reverse.bat
REM
REM Durable wrapper for `flutter run` that fixes the recurring
REM "Connection refused (errno = 111)" issue caused by Android Studio AVD
REM restarts wiping `adb reverse` rules.
REM
REM What it does, in order:
REM   0. cd into the Flutter project root (the script lives at scripts/).
REM   1. Pick the first connected emulator-* device (or use the one passed in).
REM   2. Re-establish `adb reverse tcp:5000 tcp:5000` so localhost:5000
REM      inside the device maps to localhost:5000 on the host (where the
REM      Node backend listens).
REM   3. Invoke `flutter run` with --dart-define=API_BASE_URL=<host-url>.
REM
REM Usage:
REM   scripts\run_with_reverse.bat                  (auto-pick first emulator)
REM   scripts\run_with_reverse.bat emulator-5554    (target a specific device)
REM   scripts\run_with_reverse.bat emulator-5554 --release
REM
REM Override the backend URL via env var (optional):
REM   set API_BASE_URL=http://192.168.1.20:5000
REM   scripts\run_with_reverse.bat
REM
REM Requirements:
REM   * adb     on PATH (Android platform-tools)
REM   * flutter on PATH
REM   * Backend listening on the host's localhost:5000 (or whatever
REM     API_BASE_URL is set to)
REM ============================================================================

REM --- 0. cd to Flutter project root ----------------------------------------
cd /d "%~dp0\.."
echo [run_with_reverse] Project root: %cd%

REM --- 1. Pick target device ------------------------------------------------
set "DEVICE=%~1"
if not "%DEVICE%"=="" goto :device_set

REM No device on the command line — auto-pick the first emulator-* device.
for /f "tokens=1" %%d in ('adb devices ^| findstr /R "^emulator-"') do (
  set "DEVICE=%%d"
  goto :device_set
)

REM No emulator found — fall back to any attached device.
for /f "tokens=1" %%d in ('adb devices ^| findstr /R "device$"') do (
  set "DEVICE=%%d"
  goto :device_set
)

echo [run_with_reverse] No devices attached. Start an AVD first.
exit /b 1

:device_set
echo [run_with_reverse] Using device: !DEVICE!

REM --- 2. Re-establish adb reverse -----------------------------------------
echo [run_with_reverse] Setting adb reverse tcp:5000 tcp:5000 ...
adb -s !DEVICE! reverse tcp:5000 tcp:5000
if errorlevel 1 (
  echo [run_with_reverse] adb reverse failed. Is the emulator fully booted?
  exit /b 1
)
echo [run_with_reverse] Current reverse rules:
adb -s !DEVICE! reverse --list

REM --- 3. Pick backend URL -------------------------------------------------
if defined API_BASE_URL (
  set "BASE_URL=!API_BASE_URL!"
) else (
  set "BASE_URL=http://localhost:5000"
)

REM --- 4. Launch flutter run -----------------------------------------------
REM Skip the first arg (device name) so the rest flows through to flutter run
shift
echo [run_with_reverse] Starting flutter run with API_BASE_URL=!BASE_URL! ...
flutter run --dart-define=API_BASE_URL=!BASE_URL! %*
endlocal