// SettingsManager.h
#pragma once
#include <QObject>
#include <QSettings>
#include <QStringList>

class SettingsManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int intervalMinutes READ intervalMinutes WRITE setIntervalMinutes NOTIFY intervalChanged)
    Q_PROPERTY(QString animationTheme READ animationTheme WRITE setAnimationTheme NOTIFY themeChanged)
    Q_PROPERTY(int animationDuration READ animationDuration WRITE setAnimationDuration NOTIFY durationChanged)
    Q_PROPERTY(bool autoStart READ autoStart WRITE setAutoStart NOTIFY autoStartChanged)
    Q_PROPERTY(bool showQuotes READ showQuotes WRITE setShowQuotes NOTIFY showQuotesChanged)
    Q_PROPERTY(int dailyGoal READ dailyGoal WRITE setDailyGoal NOTIFY dailyGoalChanged)
    Q_PROPERTY(QString reminderMessage READ reminderMessage WRITE setReminderMessage NOTIFY reminderMessageChanged)
    Q_PROPERTY(bool soundEnabled READ soundEnabled WRITE setSoundEnabled NOTIFY soundEnabledChanged)
    Q_PROPERTY(int textAnimationStyle READ textAnimationStyle WRITE setTextAnimationStyle NOTIFY textAnimationStyleChanged)

public:
    explicit SettingsManager(QObject *parent = nullptr);

    int intervalMinutes() const;
    void setIntervalMinutes(int mins);

    QString animationTheme() const;
    void setAnimationTheme(const QString &theme);

    int animationDuration() const;
    void setAnimationDuration(int seconds);

    bool autoStart() const;
    void setAutoStart(bool enabled);

    bool showQuotes() const;
    void setShowQuotes(bool enabled);

    int dailyGoal() const;
    void setDailyGoal(int goal);

    QString reminderMessage() const;
    void setReminderMessage(const QString &msg);

    bool soundEnabled() const;
    void setSoundEnabled(bool enabled);

    int textAnimationStyle() const;
    void setTextAnimationStyle(int style);

    QStringList availableIntervals() const;

    void save();
    void load();

signals:
    void intervalChanged(int minutes);
    void themeChanged(const QString &theme);
    void durationChanged(int seconds);
    void autoStartChanged(bool enabled);
    void showQuotesChanged(bool enabled);
    void dailyGoalChanged(int goal);
    void reminderMessageChanged(const QString &msg);
    void soundEnabledChanged(bool enabled);
    void textAnimationStyleChanged(int style);

private:
    QSettings m_settings;
    int m_intervalMinutes = 60;
    QString m_animationTheme = QStringLiteral("skeleton");
    int m_animationDuration = 6;
    bool m_autoStart = false;
    bool m_showQuotes = true;
    int m_dailyGoal = 8;
    QString m_reminderMessage;
    bool m_soundEnabled = true;
    int m_textAnimationStyle = 0;
};
