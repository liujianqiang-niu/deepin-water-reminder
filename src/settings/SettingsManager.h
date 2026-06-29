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

    QStringList availableIntervals() const;

    void save();
    void load();

signals:
    void intervalChanged(int minutes);
    void themeChanged(const QString &theme);
    void durationChanged(int seconds);
    void autoStartChanged(bool enabled);

private:
    QSettings m_settings;
    int m_intervalMinutes = 60;
    QString m_animationTheme = QStringLiteral("skeleton");
    int m_animationDuration = 6;
    bool m_autoStart = false;
};
