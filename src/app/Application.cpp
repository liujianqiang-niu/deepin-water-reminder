// Application.cpp
#include "Application.h"
#include "AppContext.h"
#include "../core/ReminderEngine.h"
#include "../core/DrinkTracker.h"
#include "../core/QuoteManager.h"
#include "../core/SoundManager.h"
#include "../animation/AnimationManager.h"
#include "../animation/AnimationLoader.h"
#include "../settings/SettingsManager.h"
#include "../tray/TrayManager.h"
#include "../ui/QmlBridge.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>
#include <QPalette>
#include <QStyleHints>
#include <QTimer>
#include <QTime>

Application::Application(int &argc, char **argv)
    : QApplication(argc, argv)
{
    setApplicationName(QStringLiteral("deepin-water-reminder"));
    setApplicationDisplayName(QStringLiteral("喝水提醒"));
    setApplicationVersion(QStringLiteral("1.0.0"));
    setOrganizationName(QStringLiteral("deepin"));
    setOrganizationDomain(QStringLiteral("deepin.org"));
    setWindowIcon(QIcon(QStringLiteral(":/icons/deepin-water-reminder.svg")));

    // 禁用 QML 磁盘缓存，避免源码更新后加载到旧缓存导致运行时错误
    qputenv("QML_DISABLE_DISK_CACHE", "1");

    // 确保不因窗口关闭而退出应用
    setQuitOnLastWindowClosed(false);

    // 跟随系统主题色（light/dark）— 通过环境变量让 Qt Quick Controls 自动适配
    // 不设置 style，让平台自动选择可用的样式（UOS/Deepin 上使用系统默认）
    if (QPalette().window().color().lightness() < 128) {
        qputenv("QT_QUICK_CONTROLS_DARK_THEME", "1");
    }
}

Application::~Application()
{
    if (m_context) {
        m_context->settingsManager()->save();
    }
    delete m_qmlEngine;
}

int Application::run()
{
    qDebug() << "[Application] Starting Deepin Water v1.0.0";

    initContext();
    loadSettings();

    m_context->animationManager()->setCurrentTheme(
        m_context->settingsManager()->animationTheme());

    if (m_context->animationManager()->currentTheme() !=
        m_context->settingsManager()->animationTheme()) {
        m_context->settingsManager()->setAnimationTheme(
            m_context->animationManager()->currentTheme());
        m_context->settingsManager()->save();
        qDebug() << "[Application] Migrated to default theme:"
                 << m_context->animationManager()->currentTheme();
    }

    registerQmlTypes();
    initQmlEngine();
    connectSignals();
    initTray();

    // 启动提醒引擎
    m_context->reminderEngine()->start();
    m_context->trayManager()->show();

    qDebug() << "[Application] Running...";

    return exec();
}

void Application::initContext()
{
    m_context = std::make_unique<AppContext>();
    qDebug() << "[Application] Context initialized";
}

void Application::initTray()
{
    auto *tray = m_context->trayManager();
    tray->show();
    qDebug() << "[Application] Tray initialized";
}

void Application::initQmlEngine()
{
    m_qmlEngine = new QQmlApplicationEngine(this);

    // 创建 QmlBridge 并暴露给 QML
    m_bridge = new QmlBridge(m_context.get(), this);
    m_qmlEngine->rootContext()->setContextProperty(QStringLiteral("bridge"), m_bridge);
    m_qmlEngine->rootContext()->setContextProperty(QStringLiteral("appVersion"), applicationVersion());

    // 加载主 QML
    m_qmlEngine->load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    qDebug() << "[Application] QML Engine initialized";
}

void Application::registerQmlTypes()
{
    // 注册 C++ 类型到 QML（如需要）
    qDebug() << "[Application] QML types registered";
}

void Application::loadSettings()
{
    m_context->settingsManager()->load();
    qDebug() << "[Application] Settings loaded";
}

void Application::connectSignals()
{
    auto *tray = m_context->trayManager();

    connect(tray, &TrayManager::triggerNowClicked, this, [this]() {
        m_context->reminderEngine()->triggerNow();
    });

    connect(tray, &TrayManager::pauseRequested, this, [this](int minutes) {
        m_context->reminderEngine()->pause(minutes);
        m_context->trayManager()->setPausedIcon();
        m_context->trayManager()->showMessage(
            QStringLiteral("喝水提醒"),
            QStringLiteral("已暂停 %1 分钟").arg(minutes));
    });

    connect(tray, &TrayManager::settingsRequested, m_bridge, &QmlBridge::requestShowSettings);
    connect(tray, &TrayManager::drinkRecordRequested, m_bridge, &QmlBridge::requestShowDrinkRecord);
    connect(tray, &TrayManager::aboutRequested, m_bridge, &QmlBridge::requestShowAbout);
    connect(tray, &TrayManager::resumeRequested, m_context->reminderEngine(), &ReminderEngine::resume);

    connect(tray, &TrayManager::quitRequested, this, [this]() {
        m_context->settingsManager()->save();
        qDebug() << "[Application] Quitting...";
        QApplication::quit();
    });

    connect(m_context->reminderEngine(), &ReminderEngine::pausedStateChanged, this, [this](bool paused) {
        m_context->trayManager()->setPaused(paused);
    });

    connect(m_context->reminderEngine(), &ReminderEngine::reminderTriggered, this, [this]() {
        if (m_context->settingsManager()->soundEnabled()) {
            m_context->soundManager()->playDrinkReminder();
        }
    });

    // 桌面通知回退：提醒触发后启动 500ms 计时，若 overlay 未成功请求则回退到托盘通知。
    // overlayRequested 以 QueuedConnection 连接，确保在 reminderTriggered 同步发射后
    // 才执行 stop()——因为 QmlBridge 在 reminderTriggered 槽内同步发射 overlayRequested。
    QTimer *fallbackTimer = new QTimer(this);
    fallbackTimer->setSingleShot(true);
    fallbackTimer->setInterval(500);
    connect(fallbackTimer, &QTimer::timeout, this, [this]() {
        QString time = QTime::currentTime().toString(QStringLiteral("HH:mm"));
        m_context->trayManager()->showMessage(
            QStringLiteral("该喝水了！"),
            QStringLiteral("现在时间 %1，记得喝水").arg(time));
        qDebug() << "[Application] Notification fallback fired at" << time;
    });
    connect(m_context->reminderEngine(), &ReminderEngine::reminderTriggered, this, [fallbackTimer]() {
        fallbackTimer->start();
    });
    connect(m_bridge, &QmlBridge::overlayRequested, this, [fallbackTimer](const QString &path) {
        if (!path.isEmpty()) {
            fallbackTimer->stop();
        }
    }, Qt::QueuedConnection);

    qDebug() << "[Application] Signals connected";
}
