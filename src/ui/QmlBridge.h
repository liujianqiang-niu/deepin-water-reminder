// QmlBridge.h
#pragma once
#include <QObject>
#include <QVariantMap>

class AppContext;

class QmlBridge : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantMap settings READ settings NOTIFY settingsChanged)
    Q_PROPERTY(QString currentTheme READ currentTheme NOTIFY currentThemeChanged)
    Q_PROPERTY(QStringList availableThemes READ availableThemes NOTIFY availableThemesChanged)
    Q_PROPERTY(QStringList availableThemeNames READ availableThemeNames NOTIFY availableThemesChanged)
    Q_PROPERTY(int todayDrinkCount READ todayDrinkCount NOTIFY todayDrinkCountChanged)
    Q_PROPERTY(int weekDrinkCount READ weekDrinkCount NOTIFY weekDrinkCountChanged)
    Q_PROPERTY(bool paused READ isPaused NOTIFY pausedChanged)
    Q_PROPERTY(QString currentQuote READ currentQuote NOTIFY currentQuoteChanged)
    Q_PROPERTY(bool showQuotes READ showQuotes WRITE setShowQuotes NOTIFY showQuotesChanged)
    Q_PROPERTY(bool soundEnabled READ soundEnabled WRITE setSoundEnabled NOTIFY soundEnabledChanged)

public:
    explicit QmlBridge(AppContext *context, QObject *parent = nullptr);

    QVariantMap settings() const;
    QString currentTheme() const;
    QStringList availableThemes() const;
    QStringList availableThemeNames() const;
    int todayDrinkCount() const;
    int weekDrinkCount() const;
    bool isPaused() const;
    QString currentQuote() const;
    bool showQuotes() const;
    bool soundEnabled() const;

public slots:
    void saveSettings(const QVariantMap &newSettings);
    void loadSettings();

    void triggerReminder();
    void pauseReminder(int minutes);
    void resumeReminder();

    void playAnimation();
    void stopAnimation();
    void setTheme(const QString &themeId);
    void onAnimationFinished();
    void onUserDismissed();

    void recordDrink();
    void clearDrinkHistory();

    void setShowQuotes(bool enabled);
    void setSoundEnabled(bool enabled);

    void requestShowSettings();
    void requestShowDrinkRecord();
    void requestShowAbout();

    void quitApp();

signals:
    void settingsChanged();
    void currentThemeChanged();
    void availableThemesChanged();
    void todayDrinkCountChanged();
    void weekDrinkCountChanged();
    void pausedChanged(bool paused);
    void currentQuoteChanged();
    void showQuotesChanged(bool enabled);
    void soundEnabledChanged(bool enabled);
    void overlayRequested(const QString &animationPath);
    void overlayHideRequested();
    void settingsPanelRequested();
    void drinkRecordPanelRequested();
    void aboutPanelRequested();

private:
    AppContext *m_context;
    bool m_paused = false;
    QString m_currentQuote;
};
