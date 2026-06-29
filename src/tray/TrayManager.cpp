// TrayManager.cpp
#include "TrayManager.h"
#include <QApplication>
#include <QIcon>
#include <QMenu>
#include <QAction>
#include <QCursor>
#include <QDebug>

TrayManager::TrayManager(QObject *parent)
    : QObject(parent)
{
    m_trayIcon = new QSystemTrayIcon(this);
    setupTrayIcon();

    connect(m_trayIcon, &QSystemTrayIcon::activated, this, [this](QSystemTrayIcon::ActivationReason reason) {
        if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick) {
            qDebug() << "[TrayManager] Tray icon clicked";
        } else if (reason == QSystemTrayIcon::Context) {
            showContextMenu();
        }
    });
}

TrayManager::~TrayManager()
{
    if (m_trayIcon) {
        m_trayIcon->hide();
    }
}

bool TrayManager::isVisible() const
{
    return m_trayIcon && m_trayIcon->isVisible();
}

void TrayManager::show()
{
    if (m_trayIcon) {
        m_trayIcon->show();
        emit visibleChanged(true);
        qDebug() << "[TrayManager] Tray icon shown";
    }
}

void TrayManager::hide()
{
    if (m_trayIcon) {
        m_trayIcon->hide();
        emit visibleChanged(false);
        qDebug() << "[TrayManager] Tray icon hidden";
    }
}

void TrayManager::setDefaultIcon()
{
    QIcon icon = QIcon::fromTheme(QStringLiteral("deepin-water-reminder"),
                                   QIcon(QStringLiteral(":/icons/tray-default.svg")));
    m_trayIcon->setIcon(icon);
}

void TrayManager::setRemindingIcon()
{
    QIcon icon = QIcon::fromTheme(QStringLiteral("deepin-water-reminder-reminding"),
                                   QIcon(QStringLiteral(":/icons/tray-reminding.svg")));
    m_trayIcon->setIcon(icon);
}

void TrayManager::setPausedIcon()
{
    QIcon icon = QIcon::fromTheme(QStringLiteral("deepin-water-reminder-paused"),
                                   QIcon(QStringLiteral(":/icons/tray-paused.svg")));
    m_trayIcon->setIcon(icon);
    m_paused = true;
}

void TrayManager::setPaused(bool paused)
{
    m_paused = paused;
    if (paused) {
        setPausedIcon();
    } else {
        setDefaultIcon();
    }
}

void TrayManager::showMessage(const QString &title, const QString &message)
{
    if (m_trayIcon && QSystemTrayIcon::supportsMessages()) {
        m_trayIcon->showMessage(title, message, QSystemTrayIcon::Information, 3000);
    }
}

void TrayManager::setupTrayIcon()
{
    setDefaultIcon();
    m_trayIcon->setToolTip(QStringLiteral("喝水提醒 - Deepin Water"));
}

void TrayManager::showContextMenu()
{
    QMenu menu;

    QAction *triggerNow  = menu.addAction(QStringLiteral("▸ 立即喝一杯"));

    if (m_paused) {
        QAction *resume = menu.addAction(QStringLiteral("▶ 恢复提醒"));
        QAction *chosen = menu.exec(QCursor::pos());

        if (chosen == triggerNow) {
            emit triggerNowClicked();
        } else if (chosen == resume) {
            qDebug() << "[TrayManager] Resume clicked";
            emit resumeRequested();
        }
        return;
    }

    QAction *pauseAction = menu.addAction(QStringLiteral("⏸ 暂停提醒"));
    menu.addSeparator();
    QAction *settings    = menu.addAction(QStringLiteral("⚙ 设置..."));
    QAction *drinkRecord = menu.addAction(QStringLiteral("📊 饮水记录"));
    menu.addSeparator();
    QAction *about       = menu.addAction(QStringLiteral("ℹ 关于..."));
    QAction *quit        = menu.addAction(QStringLiteral("✖ 退出"));

    QAction *chosen = menu.exec(QCursor::pos());

    if (chosen == triggerNow) {
        qDebug() << "[TrayManager] Trigger now clicked";
        emit triggerNowClicked();
    } else if (chosen == pauseAction) {
        qDebug() << "[TrayManager] Pause clicked";
        emit pauseRequested(0);
    } else if (chosen == quit) {
        qDebug() << "[TrayManager] Quit clicked";
        emit quitRequested();
    } else if (chosen == settings) {
        qDebug() << "[TrayManager] Settings clicked";
        emit settingsRequested();
    } else if (chosen == drinkRecord) {
        qDebug() << "[TrayManager] Drink record clicked";
        emit drinkRecordRequested();
    } else if (chosen == about) {
        qDebug() << "[TrayManager] About clicked";
        emit aboutRequested();
    }
}
