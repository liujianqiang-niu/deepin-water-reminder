// SoundManager.h
#pragma once
#include <QObject>

class QSoundEffect;

class SoundManager : public QObject {
    Q_OBJECT
public:
    explicit SoundManager(QObject *parent = nullptr);

    // 播放喝水提醒音效。无音源或加载失败时静默降级，不崩溃。
    void playDrinkReminder();

private:
    bool loadFallbackSource();
    QSoundEffect *m_effect = nullptr;
    bool m_loaded = false;
    bool m_available = true;
};
