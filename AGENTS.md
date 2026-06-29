# AGENTS.md — deepin-water-reminder

## Build & Test

```bash
# Configure + build
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

# Build with tests enabled
cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=ON
cmake --build .
ctest

# Run a single test binary (from build/)
./test_ReminderEngine
./test_DrinkTracker
./test_SettingsManager

# Debian package
dpkg-buildpackage -us -uc -b
```

- Tests are **off by default**; must pass `-DBUILD_TESTS=ON`.
- `debian/rules` hardcodes `-DBUILD_TESTS=OFF` for package builds.

## Architecture

Qt6 C++17 + QML hybrid app. Entry: `src/main.cpp` → `Application::run()`.

| Directory | Purpose |
|---|---|
| `src/app/` | `Application` (QApplication subclass, lifecycle), `AppContext` (DI container holding all managers) |
| `src/core/` | `ReminderEngine` (timer), `DrinkTracker` (history), `AnimationDescriptor` (data struct) |
| `src/animation/` | `AnimationLoader` (reads `manifest.json`), `AnimationManager` (plays animations) |
| `src/settings/` | `SettingsManager` (QSettings persistence) |
| `src/tray/` | `TrayManager` (system tray icon + menu) |
| `src/ui/` | `OverlayWindow` (transparent borderless window), `QmlBridge` (C++↔QML bridge) |
| `resources/qml/` | QML UI files loaded via `qml.qrc` |
| `resources/animations/` | 5 QML animation themes + `manifest.json` |
| `resources/icons/` | SVG icons for app and tray states (default/ reminding/paused) |

- `AppContext` owns all manager singletons; created once in `Application::initContext()`.
- C++ objects exposed to QML via `QmlBridge` as `bridge` context property.
- App does **not quit on window close** (`setQuitOnLastWindowClosed(false)`); tray quit triggers explicit save + exit.
- Animation themes are defined in `resources/animations/manifest.json`; adding a theme requires a QML file + manifest entry + `qml.qrc` entry.

## Conventions

- UI language: Chinese (zh_CN primary), i18n via `resources/translations/*.ts`.
- Desktop file Exec name is `deepin-water` (shorter than binary name `deepin-water-reminder`) — keep in sync.
- CMake uses `AUTOMOC`, `AUTORCC`, `AUTOUIC` — no manual moc invocations needed.
