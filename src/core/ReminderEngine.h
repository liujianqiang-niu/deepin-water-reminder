// ReminderEngine.h
#pragma once
#include <QObject>
#include <QTimer>

class SettingsManager;

class ReminderEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool active READ isActive NOTIFY activeChanged)
    Q_PROPERTY(int intervalMinutes READ intervalMinutes
               WRITE setIntervalMinutes NOTIFY intervalChanged)

public:
    explicit ReminderEngine(SettingsManager *settings,
                            QObject *parent = nullptr);

    bool isActive() const;
    int  intervalMinutes() const;

public slots:
    void start();                     // 启动定时器
    void stop();                      // 停止定时器
    void pause(int durationMinutes);  // 暂停指定分钟
    void resume();                    // 恢复
    void triggerNow();               // 立即触发提醒
    void setIntervalMinutes(int mins);

signals:
    void reminderTriggered();         // 提醒触发信号 → 动画弹出
    void activeChanged(bool active);
    void intervalChanged(int minutes);
    void pausedStateChanged(bool paused);

private slots:
    void onTimeout();

private:
    void resetTimer();

    QTimer          *m_timer;
    SettingsManager *m_settings;
    bool             m_paused = false;
    QTimer          *m_pauseTimer = nullptr;
};
