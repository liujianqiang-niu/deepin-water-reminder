# Deepin Water — 桌面喝水提醒助手

> 趣味化、非侵入式的桌面喝水提醒应用

## 功能特性

- **沉浸式动画提醒**：碧海潮生、星河璀璨、极光幻境、雷暴来袭、烈焰涅槃 5 种动画主题，多层次粒子效果
- **透明无边框窗口**：全屏透明覆盖层，不遮挡桌面内容，不抢夺焦点，点击即可关闭
- **系统托盘驻留**：后台静默运行，右键菜单快捷操作（立即喝一杯、暂停/恢复提醒、设置、饮水记录、关于、退出）
- **灵活的提醒间隔**：15/30/45/60/90/120 分钟可选
- **暂停提醒**：支持暂停提醒，暂停后托盘图标变化，可随时恢复
- **饮水记录**：按日/周统计饮水量，支持手动记录喝水和重置记录
- **动画主题切换**：设置面板可选择主题并实时预览，展示时长 3~20 秒可调
- **开机自启**：可选配置开机自动启动

## 构建与运行

### 依赖

- Qt 6.5+
- CMake 3.20+
- C++17

### 编译

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 运行

```bash
./deepin-water-reminder
```

### 打包 (Debian/Deepin)

```bash
dpkg-buildpackage -us -uc -b
```

### 运行测试

```bash
cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTS=ON
cmake --build .
ctest
```

## 架构

Qt6 C++17 + QML 混合应用。入口：`src/main.cpp` → `Application::run()`。

| 目录 | 职责 |
|------|------|
| `src/app/` | Application（QApplication 子类，生命周期）、AppContext（DI 容器持有所有管理器） |
| `src/core/` | ReminderEngine（定时调度）、DrinkTracker（饮水记录持久化）、AnimationDescriptor（动画数据结构） |
| `src/animation/` | AnimationLoader（解析 manifest.json）、AnimationManager（主题切换与播放调度） |
| `src/settings/` | SettingsManager（QSettings 持久化配置） |
| `src/tray/` | TrayManager（系统托盘图标 + 右键菜单） |
| `src/ui/` | QmlBridge（C++ ↔ QML 桥接对象） |
| `resources/qml/` | QML 界面文件：main.qml、TransparentOverlay.qml、SettingsPanel.qml、DrinkRecordPanel.qml、AboutPanel.qml |
| `resources/animations/` | 5 个 QML 动画主题（ocean/galaxy/aurora/storm/inferno）+ manifest.json |
| `resources/icons/` | SVG 图标（应用图标、托盘默认/提醒/暂停状态） |

## 许可证

GPL-3.0-or-later
