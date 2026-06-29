// ReminderEngine.cpp
#include "ReminderEngine.h"
#include "../settings/SettingsManager.h"
#include <QDebug>

ReminderEngine::ReminderEngine(SettingsManager *settings, QObject *parent)
    : QObject(parent)
    , m_settings(settings)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &ReminderEngine::onTimeout);

    m_pauseTimer = new QTimer(this);
    m_pauseTimer->setSingleShot(true);
    connect(m_pauseTimer, &QTimer::timeout, this, [this]() {
        m_paused = false;
        emit pausedStateChanged(false);
        resetTimer();
        qDebug() << "[ReminderEngine] Pause expired, resuming";
    });
}

bool ReminderEngine::isActive() const
{
    return m_timer->isActive();
}

int ReminderEngine::intervalMinutes() const
{
    return m_settings->intervalMinutes();
}

void ReminderEngine::start()
{
    if (m_paused) {
        qDebug() << "[ReminderEngine] Cannot start while paused";
        return;
    }
    resetTimer();
    qDebug() << "[ReminderEngine] Started with interval:" << intervalMinutes() << "min";
}

void ReminderEngine::stop()
{
    m_timer->stop();
    m_pauseTimer->stop();
    m_paused = false;
    emit activeChanged(false);
    emit pausedStateChanged(false);
    qDebug() << "[ReminderEngine] Stopped";
}

void ReminderEngine::pause(int durationMinutes)
{
    m_timer->stop();
    m_paused = true;
    if (durationMinutes > 0) {
        m_pauseTimer->start(durationMinutes * 60 * 1000);
        qDebug() << "[ReminderEngine] Paused for" << durationMinutes << "min";
    } else {
        m_pauseTimer->stop();
        qDebug() << "[ReminderEngine] Paused indefinitely";
    }
    emit activeChanged(false);
    emit pausedStateChanged(true);
}

void ReminderEngine::resume()
{
    if (!m_paused) return;
    m_pauseTimer->stop();
    m_paused = false;
    emit pausedStateChanged(false);
    resetTimer();
    qDebug() << "[ReminderEngine] Resumed";
}

void ReminderEngine::triggerNow()
{
    qDebug() << "[ReminderEngine] Manual trigger";
    emit reminderTriggered();
    // 重置定时器
    if (!m_paused) {
        resetTimer();
    }
}

void ReminderEngine::setIntervalMinutes(int mins)
{
    m_settings->setIntervalMinutes(mins);
    emit intervalChanged(mins);
    if (isActive() && !m_paused) {
        resetTimer();
    }
}

void ReminderEngine::onTimeout()
{
    qDebug() << "[ReminderEngine] Timeout - triggering reminder";
    emit reminderTriggered();
    // 重新开始计时
    resetTimer();
}

void ReminderEngine::resetTimer()
{
    m_timer->stop();
    int ms = intervalMinutes() * 60 * 1000;
    m_timer->start(ms);
    if (!m_paused) {
        emit activeChanged(true);
    }
}
