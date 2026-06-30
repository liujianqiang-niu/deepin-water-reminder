// SettingsManager.cpp
#include "SettingsManager.h"
#include <QDebug>

static const char* kOrganization = "deepin";
static const char* kAppName = "deepin-water-reminder";

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
    , m_settings(QString::fromLatin1(kOrganization), QString::fromLatin1(kAppName))
{
    load();
}

int SettingsManager::intervalMinutes() const
{
    return m_intervalMinutes;
}

void SettingsManager::setIntervalMinutes(int mins)
{
    if (m_intervalMinutes != mins) {
        m_intervalMinutes = mins;
        m_settings.setValue(QStringLiteral("intervalMinutes"), mins);
        emit intervalChanged(mins);
    }
}

QString SettingsManager::animationTheme() const
{
    return m_animationTheme;
}

void SettingsManager::setAnimationTheme(const QString &theme)
{
    if (m_animationTheme != theme) {
        m_animationTheme = theme;
        m_settings.setValue(QStringLiteral("animationTheme"), theme);
        emit themeChanged(theme);
    }
}

int SettingsManager::animationDuration() const
{
    return m_animationDuration;
}

void SettingsManager::setAnimationDuration(int seconds)
{
    if (m_animationDuration != seconds) {
        m_animationDuration = seconds;
        m_settings.setValue(QStringLiteral("animationDuration"), seconds);
        emit durationChanged(seconds);
    }
}

bool SettingsManager::autoStart() const
{
    return m_autoStart;
}

void SettingsManager::setAutoStart(bool enabled)
{
    if (m_autoStart != enabled) {
        m_autoStart = enabled;
        m_settings.setValue(QStringLiteral("autoStart"), enabled);
        emit autoStartChanged(enabled);
    }
}

bool SettingsManager::showQuotes() const
{
    return m_showQuotes;
}

void SettingsManager::setShowQuotes(bool enabled)
{
    if (m_showQuotes != enabled) {
        m_showQuotes = enabled;
        m_settings.setValue(QStringLiteral("showQuotes"), enabled);
        emit showQuotesChanged(enabled);
    }
}

int SettingsManager::dailyGoal() const
{
    return m_dailyGoal;
}

void SettingsManager::setDailyGoal(int goal)
{
    if (m_dailyGoal != goal) {
        m_dailyGoal = goal;
        m_settings.setValue(QStringLiteral("dailyGoal"), goal);
        emit dailyGoalChanged(goal);
    }
}

QString SettingsManager::reminderMessage() const
{
    return m_reminderMessage;
}

void SettingsManager::setReminderMessage(const QString &msg)
{
    if (m_reminderMessage != msg) {
        m_reminderMessage = msg;
        m_settings.setValue(QStringLiteral("reminderMessage"), msg);
        emit reminderMessageChanged(msg);
    }
}

bool SettingsManager::soundEnabled() const
{
    return m_soundEnabled;
}

void SettingsManager::setSoundEnabled(bool enabled)
{
    if (m_soundEnabled != enabled) {
        m_soundEnabled = enabled;
        m_settings.setValue(QStringLiteral("soundEnabled"), enabled);
        emit soundEnabledChanged(enabled);
    }
}

int SettingsManager::textAnimationStyle() const
{
    return m_textAnimationStyle;
}

void SettingsManager::setTextAnimationStyle(int style)
{
    if (m_textAnimationStyle != style) {
        m_textAnimationStyle = style;
        m_settings.setValue(QStringLiteral("textAnimationStyle"), style);
        emit textAnimationStyleChanged(style);
    }
}

QStringList SettingsManager::availableIntervals() const
{
    return {QStringLiteral("15"), QStringLiteral("30"), QStringLiteral("45"),
            QStringLiteral("60"), QStringLiteral("90"), QStringLiteral("120")};
}

void SettingsManager::save()
{
    m_settings.sync();
    qDebug() << "[SettingsManager] Settings saved";
}

void SettingsManager::load()
{
    m_intervalMinutes = m_settings.value(QStringLiteral("intervalMinutes"), 60).toInt();
    m_animationTheme = m_settings.value(QStringLiteral("animationTheme"), QStringLiteral("skeleton")).toString();
    m_animationDuration = m_settings.value(QStringLiteral("animationDuration"), 6).toInt();
    m_autoStart = m_settings.value(QStringLiteral("autoStart"), false).toBool();
    m_showQuotes = m_settings.value(QStringLiteral("showQuotes"), true).toBool();
    m_dailyGoal = m_settings.value(QStringLiteral("dailyGoal"), 8).toInt();
    m_reminderMessage = m_settings.value(QStringLiteral("reminderMessage"), QString()).toString();
    m_soundEnabled = m_settings.value(QStringLiteral("soundEnabled"), true).toBool();
    m_textAnimationStyle = m_settings.value(QStringLiteral("textAnimationStyle"), 0).toInt();
    qDebug() << "[SettingsManager] Settings loaded:" << m_intervalMinutes << "min, theme:" << m_animationTheme;
}
