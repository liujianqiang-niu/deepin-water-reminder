# Test targets
find_package(Qt6 REQUIRED COMPONENTS Test)

set(TEST_SOURCES
    ${CMAKE_SOURCE_DIR}/src/core/ReminderEngine.h
    ${CMAKE_SOURCE_DIR}/src/core/ReminderEngine.cpp
    ${CMAKE_SOURCE_DIR}/src/core/DrinkTracker.h
    ${CMAKE_SOURCE_DIR}/src/core/DrinkTracker.cpp
    ${CMAKE_SOURCE_DIR}/src/core/AnimationDescriptor.h
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.h
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.cpp
)

# ReminderEngine test
qt_add_executable(test_ReminderEngine
    test_ReminderEngine.cpp
    ${TEST_SOURCES}
)
target_include_directories(test_ReminderEngine PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_ReminderEngine PRIVATE Qt6::Core Qt6::Test)
add_test(NAME test_ReminderEngine COMMAND test_ReminderEngine)

# DrinkTracker test
qt_add_executable(test_DrinkTracker
    test_DrinkTracker.cpp
    ${CMAKE_SOURCE_DIR}/src/core/DrinkTracker.h
    ${CMAKE_SOURCE_DIR}/src/core/DrinkTracker.cpp
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.h
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.cpp
)
target_include_directories(test_DrinkTracker PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_DrinkTracker PRIVATE Qt6::Core Qt6::Test)
add_test(NAME test_DrinkTracker COMMAND test_DrinkTracker)

# SettingsManager test
qt_add_executable(test_SettingsManager
    test_SettingsManager.cpp
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.h
    ${CMAKE_SOURCE_DIR}/src/settings/SettingsManager.cpp
)
target_include_directories(test_SettingsManager PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_SettingsManager PRIVATE Qt6::Core Qt6::Test)
add_test(NAME test_SettingsManager COMMAND test_SettingsManager)
