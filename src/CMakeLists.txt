# Collect all source files
set(CORE_SOURCES
    core/ReminderEngine.cpp
    core/DrinkTracker.cpp
    core/QuoteManager.cpp
    core/SoundManager.cpp
)

set(ANIMATION_SOURCES
    animation/AnimationLoader.cpp
    animation/AnimationManager.cpp
)

set(SETTINGS_SOURCES
    settings/SettingsManager.cpp
)

set(TRAY_SOURCES
    tray/TrayManager.cpp
)

set(UI_SOURCES
    ui/QmlBridge.cpp
)

set(APP_SOURCES
    app/AppContext.cpp
    app/Application.cpp
)

set(ALL_SOURCES
    main.cpp
    ${CORE_SOURCES}
    ${ANIMATION_SOURCES}
    ${SETTINGS_SOURCES}
    ${TRAY_SOURCES}
    ${UI_SOURCES}
    ${APP_SOURCES}
)

# Resource files
set(RESOURCE_FILES
    ${CMAKE_SOURCE_DIR}/resources/qml.qrc
)

# Create executable
qt_add_executable(deepin-water-reminder
    ${ALL_SOURCES}
    ${RESOURCE_FILES}
)

# Include directories
target_include_directories(deepin-water-reminder PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link Qt6 libraries
target_link_libraries(deepin-water-reminder PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    Qt6::Svg
    Qt6::Network
    Qt6::Multimedia
)

# Set output name
set_target_properties(deepin-water-reminder PROPERTIES
    OUTPUT_NAME "deepin-water-reminder"
)

# Install rules
install(TARGETS deepin-water-reminder
    RUNTIME DESTINATION bin
)

install(FILES
    ${CMAKE_SOURCE_DIR}/resources/icons/deepin-water-reminder.svg
    DESTINATION share/icons/hicolor/scalable/apps
    RENAME deepin-water-reminder.svg
)

install(FILES
    ${CMAKE_SOURCE_DIR}/resources/icons/tray-default.svg
    ${CMAKE_SOURCE_DIR}/resources/icons/tray-reminding.svg
    ${CMAKE_SOURCE_DIR}/resources/icons/tray-paused.svg
    DESTINATION share/deepin-water-reminder/icons
)

# Desktop file
install(FILES
    ${CMAKE_SOURCE_DIR}/debian/deepin-water-reminder.desktop
    DESTINATION share/applications
)
