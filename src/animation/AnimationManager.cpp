// AnimationManager.cpp
#include "AnimationManager.h"
#include "AnimationLoader.h"
#include <QDebug>

AnimationManager::AnimationManager(AnimationLoader *loader, QObject *parent)
    : QObject(parent)
    , m_loader(loader)
{
    loadThemeList();
}

bool AnimationManager::isPlaying() const
{
    return m_playing;
}

QString AnimationManager::currentTheme() const
{
    return m_currentTheme;
}

QStringList AnimationManager::availableThemes() const
{
    return m_availableThemes;
}

QStringList AnimationManager::availableThemeNames() const
{
    return m_loader->listThemeDisplayNames();
}

void AnimationManager::play()
{
    if (m_currentTheme.isEmpty()) {
        qWarning() << "[AnimationManager] No theme selected";
        return;
    }

    AnimationDescriptor desc = m_loader->loadById(m_currentTheme);
    if (desc.id.isEmpty()) {
        qWarning() << "[AnimationManager] Cannot load theme:" << m_currentTheme;
        return;
    }

    m_playing = true;
    emit playingChanged(true);
    emit playRequested(desc.resourcePath);
    qDebug() << "[AnimationManager] Playing:" << m_currentTheme << "path:" << desc.resourcePath;
}

void AnimationManager::stop()
{
    if (!m_playing) return;
    m_playing = false;
    emit playingChanged(false);
    emit stopRequested();
    qDebug() << "[AnimationManager] Stopped";
}

void AnimationManager::setCurrentTheme(const QString &themeId)
{
    if (m_currentTheme == themeId) return;

    if (!m_loader->isValid(themeId)) {
        qWarning() << "[AnimationManager] Invalid theme:" << themeId;
        return;
    }

    m_currentTheme = themeId;
    emit themeChanged(themeId);
    qDebug() << "[AnimationManager] Theme changed to:" << themeId;
}

QString AnimationManager::previewTheme(const QString &themeId)
{
    AnimationDescriptor desc = m_loader->loadById(themeId);
    if (desc.id.isEmpty()) {
        return QString();
    }
    return desc.resourcePath;
}

void AnimationManager::loadThemeList()
{
    m_availableThemes = m_loader->listThemeIds();
    if (!m_availableThemes.isEmpty() && m_currentTheme.isEmpty()) {
        m_currentTheme = m_availableThemes.first();
    }
    emit themesChanged();
}
