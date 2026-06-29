// TrayManager.h
#pragma once
#include <QObject>
#include <QSystemTrayIcon>

class TrayManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool visible READ isVisible NOTIFY visibleChanged)

public:
    explicit TrayManager(QObject *parent = nullptr);
    ~TrayManager() override;

    bool isVisible() const;
    void show();
    void hide();

public slots:
    void setDefaultIcon();
    void setRemindingIcon();
    void setPausedIcon();
    void setPaused(bool paused);
    void showMessage(const QString &title, const QString &message);

signals:
    void visibleChanged(bool visible);
    void triggerNowClicked();
    void pauseRequested(int minutes);
    void resumeRequested();
    void settingsRequested();
    void drinkRecordRequested();
    void aboutRequested();
    void quitRequested();

private:
    void setupTrayIcon();
    void showContextMenu();

    QSystemTrayIcon *m_trayIcon = nullptr;
    bool m_paused = false;
};
