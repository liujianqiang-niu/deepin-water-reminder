// SoundManager.cpp
#include "SoundManager.h"
#include <QSoundEffect>
#include <QUrl>
#include <QDebug>
#include <QFileInfo>

SoundManager::SoundManager(QObject *parent)
    : QObject(parent)
{
    m_effect = new QSoundEffect(this);
    m_loaded = loadFallbackSource();
    if (!m_loaded) {
        qDebug() << "[SoundManager] No audio source available; playDrinkReminder() will be a no-op";
    }
}

void SoundManager::playDrinkReminder()
{
    if (!m_available || !m_effect) {
        return;
    }
    if (!m_loaded) {
        m_loaded = loadFallbackSource();
    }
    if (!m_loaded) {
        return;
    }
    if (m_effect->status() == QSoundEffect::Error) {
        qDebug() << "[SoundManager] QSoundEffect in error state, skipping playback";
        return;
    }
    m_effect->stop();
    m_effect->play();
    qDebug() << "[SoundManager] Drink reminder sound played";
}

bool SoundManager::loadFallbackSource()
{
    if (!m_available || !m_effect) {
        return false;
    }

    // 优先尝试 deepin 系统提示音
    static const char *kCandidates[] = {
        "/usr/share/sounds/deepin/stereo/message.wav",
        "/usr/share/sounds/freedesktop/stereo/complete.oga",
        "/usr/share/sounds/freedesktop/stereo/message.oga"
    };
    for (const char *path : kCandidates) {
        QFileInfo info(QString::fromLatin1(path));
        if (info.exists() && info.isReadable()) {
            m_effect->setSource(QUrl::fromLocalFile(info.filePath()));
            m_effect->setVolume(0.7f);
            qDebug() << "[SoundManager] Loaded sound source:" << info.filePath();
            return true;
        }
    }
    return false;
}
