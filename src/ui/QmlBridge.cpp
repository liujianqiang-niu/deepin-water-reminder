// QmlBridge.cpp
#include "QmlBridge.h"
#include "../app/AppContext.h"
#include "../core/ReminderEngine.h"
#include "../core/DrinkTracker.h"
#include "../animation/AnimationManager.h"
#include "../animation/AnimationLoader.h"
#include "../settings/SettingsManager.h"
#include <QDebug>
#include <QApplication>

QmlBridge::QmlBridge(AppContext *context, QObject *parent)
    : QObject(parent)
    , m_context(context)
{
    connect(m_context->reminderEngine(), &ReminderEngine::reminderTriggered, this, [this]() {
        qDebug() << "[QmlBridge] Reminder triggered, requesting overlay";
        QString path = m_context->animationManager()->previewTheme(
            m_context->animationManager()->currentTheme());
        emit overlayRequested(path);
    });

    connect(m_context->reminderEngine(), &ReminderEngine::pausedStateChanged, this, [this](bool p) {
        m_paused = p;
        emit pausedChanged(p);
    });

    connect(m_context->animationManager(), &AnimationManager::themeChanged, this, &QmlBridge::currentThemeChanged);
    connect(m_context->animationManager(), &AnimationManager::themesChanged, this, &QmlBridge::availableThemesChanged);
    connect(m_context->animationManager(), &AnimationManager::playRequested, this, [this](const QString &path) {
        qDebug() << "[QmlBridge] Play requested, path:" << path;
        if (!path.isEmpty()) {
            emit overlayRequested(path);
        }
    });

    connect(m_context->drinkTracker(), &DrinkTracker::todayCountChanged, this, &QmlBridge::todayDrinkCountChanged);
    connect(m_context->drinkTracker(), &DrinkTracker::weekCountChanged, this, &QmlBridge::weekDrinkCountChanged);

    connect(m_context->settingsManager(), &SettingsManager::intervalChanged, this, &QmlBridge::settingsChanged);
    connect(m_context->settingsManager(), &SettingsManager::themeChanged, this, &QmlBridge::settingsChanged);
    connect(m_context->settingsManager(), &SettingsManager::durationChanged, this, &QmlBridge::settingsChanged);
    connect(m_context->settingsManager(), &SettingsManager::autoStartChanged, this, &QmlBridge::settingsChanged);
}

QVariantMap QmlBridge::settings() const
{
    QVariantMap map;
    auto *s = m_context->settingsManager();
    map[QStringLiteral("intervalMinutes")] = s->intervalMinutes();
    map[QStringLiteral("animationTheme")] = s->animationTheme();
    map[QStringLiteral("animationDuration")] = s->animationDuration();
    map[QStringLiteral("autoStart")] = s->autoStart();
    map[QStringLiteral("availableIntervals")] = s->availableIntervals();
    return map;
}

QString QmlBridge::currentTheme() const
{
    return m_context->animationManager()->currentTheme();
}

QStringList QmlBridge::availableThemes() const
{
    return m_context->animationManager()->availableThemes();
}

int QmlBridge::todayDrinkCount() const
{
    return m_context->drinkTracker()->todayCount();
}

int QmlBridge::weekDrinkCount() const
{
    return m_context->drinkTracker()->weekCount();
}

bool QmlBridge::isPaused() const
{
    return m_paused;
}

void QmlBridge::saveSettings(const QVariantMap &newSettings)
{
    auto *s = m_context->settingsManager();
    if (newSettings.contains(QStringLiteral("intervalMinutes")))
        s->setIntervalMinutes(newSettings.value(QStringLiteral("intervalMinutes")).toInt());
    if (newSettings.contains(QStringLiteral("animationTheme"))) {
        QString theme = newSettings.value(QStringLiteral("animationTheme")).toString();
        s->setAnimationTheme(theme);
        m_context->animationManager()->setCurrentTheme(theme);
    }
    if (newSettings.contains(QStringLiteral("animationDuration")))
        s->setAnimationDuration(newSettings.value(QStringLiteral("animationDuration")).toInt());
    if (newSettings.contains(QStringLiteral("autoStart")))
        s->setAutoStart(newSettings.value(QStringLiteral("autoStart")).toBool());
    s->save();
    emit settingsChanged();
    qDebug() << "[QmlBridge] Settings saved";
}

void QmlBridge::loadSettings()
{
    m_context->settingsManager()->load();
    emit settingsChanged();
}

void QmlBridge::triggerReminder()
{
    m_context->reminderEngine()->triggerNow();
}

void QmlBridge::pauseReminder(int minutes)
{
    m_context->reminderEngine()->pause(minutes);
}

void QmlBridge::resumeReminder()
{
    m_context->reminderEngine()->resume();
}

void QmlBridge::playAnimation()
{
    m_context->animationManager()->play();
}

void QmlBridge::stopAnimation()
{
    m_context->animationManager()->stop();
}

void QmlBridge::setTheme(const QString &themeId)
{
    m_context->animationManager()->setCurrentTheme(themeId);
    m_context->settingsManager()->setAnimationTheme(themeId);
}

void QmlBridge::onAnimationFinished()
{
    m_context->animationManager()->stop();
    emit overlayHideRequested();
    qDebug() << "[QmlBridge] Animation finished";
}

void QmlBridge::onUserDismissed()
{
    m_context->animationManager()->stop();
    m_context->drinkTracker()->recordDrink();
    emit overlayHideRequested();
    qDebug() << "[QmlBridge] User dismissed animation, drink recorded";
}

void QmlBridge::recordDrink()
{
    m_context->drinkTracker()->recordDrink();
}

void QmlBridge::clearDrinkHistory()
{
    m_context->drinkTracker()->clearHistory();
    qDebug() << "[QmlBridge] Drink history cleared";
}

void QmlBridge::requestShowSettings()
{
    qDebug() << "[QmlBridge] Request show settings panel";
    emit settingsPanelRequested();
}

void QmlBridge::requestShowDrinkRecord()
{
    qDebug() << "[QmlBridge] Request show drink record panel";
    emit drinkRecordPanelRequested();
}

void QmlBridge::requestShowAbout()
{
    qDebug() << "[QmlBridge] Request show about panel";
    emit aboutPanelRequested();
}

void QmlBridge::quitApp()
{
    m_context->settingsManager()->save();
    qDebug() << "[QmlBridge] Quitting application";
    QApplication::quit();
}
