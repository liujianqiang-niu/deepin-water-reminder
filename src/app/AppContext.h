// AppContext.h
#pragma once
#include <QObject>
#include <memory>

class ReminderEngine;
class AnimationManager;
class SettingsManager;
class TrayManager;
class DrinkTracker;
class AnimationLoader;
class QuoteManager;
class SoundManager;

class AppContext : public QObject {
    Q_OBJECT
public:
    explicit AppContext(QObject *parent = nullptr);

    ReminderEngine*   reminderEngine()   const;
    AnimationManager* animationManager() const;
    SettingsManager*  settingsManager()  const;
    TrayManager*      trayManager()      const;
    DrinkTracker*     drinkTracker()     const;
    AnimationLoader*  animationLoader()  const;
    QuoteManager*     quoteManager()     const;
    SoundManager*     soundManager()     const;

private:
    std::unique_ptr<ReminderEngine>   m_reminderEngine;
    std::unique_ptr<AnimationManager> m_animationManager;
    std::unique_ptr<SettingsManager>  m_settingsManager;
    std::unique_ptr<TrayManager>      m_trayManager;
    std::unique_ptr<DrinkTracker>     m_drinkTracker;
    std::unique_ptr<AnimationLoader>  m_animationLoader;
    std::unique_ptr<QuoteManager>     m_quoteManager;
    std::unique_ptr<SoundManager>     m_soundManager;
};
