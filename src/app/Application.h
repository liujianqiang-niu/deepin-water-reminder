// Application.h
#pragma once
#include <QApplication>
#include <memory>

class AppContext;
class QQmlApplicationEngine;
class QmlBridge;

class Application : public QApplication {
    Q_OBJECT
public:
    Application(int &argc, char **argv);
    ~Application() override;

    int run();

private:
    void initContext();       // 初始化全局上下文
    void initTray();          // 初始化系统托盘
    void initQmlEngine();     // 初始化 QML 引擎
    void registerQmlTypes();  // 注册 C++ 类型到 QML
    void loadSettings();      // 加载配置
    void connectSignals();    // 连接核心信号

    std::unique_ptr<AppContext> m_context;
    QQmlApplicationEngine      *m_qmlEngine = nullptr;
    QmlBridge                  *m_bridge = nullptr;
};
