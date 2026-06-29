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
    qDebug() << "[SettingsManager] Settings loaded:" << m_intervalMinutes << "min, theme:" << m_animationTheme;
}
