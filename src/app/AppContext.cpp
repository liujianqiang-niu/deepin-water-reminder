// AppContext.cpp
#include "AppContext.h"
#include "../core/ReminderEngine.h"
#include "../core/DrinkTracker.h"
#include "../animation/AnimationManager.h"
#include "../animation/AnimationLoader.h"
#include "../settings/SettingsManager.h"
#include "../tray/TrayManager.h"

AppContext::AppContext(QObject *parent)
    : QObject(parent)
{
    m_settingsManager = std::make_unique<SettingsManager>();
    m_animationLoader = std::make_unique<AnimationLoader>(
        QStringLiteral(":/animations/manifest.json"));
    m_animationManager = std::make_unique<AnimationManager>(m_animationLoader.get());
    m_drinkTracker = std::make_unique<DrinkTracker>();
    m_reminderEngine = std::make_unique<ReminderEngine>(m_settingsManager.get());
    m_trayManager = std::make_unique<TrayManager>();
}

ReminderEngine* AppContext::reminderEngine() const
{
    return m_reminderEngine.get();
}

AnimationManager* AppContext::animationManager() const
{
    return m_animationManager.get();
}

SettingsManager* AppContext::settingsManager() const
{
    return m_settingsManager.get();
}

TrayManager* AppContext::trayManager() const
{
    return m_trayManager.get();
}

DrinkTracker* AppContext::drinkTracker() const
{
    return m_drinkTracker.get();
}

AnimationLoader* AppContext::animationLoader() const
{
    return m_animationLoader.get();
}
