// AnimationManager.h
#pragma once
#include <QObject>
#include <QStringList>
#include "../core/AnimationDescriptor.h"

class AnimationLoader;

class AnimationManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentTheme READ currentTheme
               WRITE setCurrentTheme NOTIFY themeChanged)
    Q_PROPERTY(QStringList availableThemes READ availableThemes
               NOTIFY themesChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)

public:
    explicit AnimationManager(AnimationLoader *loader,
                              QObject *parent = nullptr);

    bool isPlaying() const;
    QString currentTheme() const;
    QStringList availableThemes() const;

public slots:
    void play();                                    // 播放当前主题动画
    void stop();                                    // 停止动画
    void setCurrentTheme(const QString &themeId);   // 切换主题
    QString previewTheme(const QString &themeId);   // 预览指定主题,返回资源路径

signals:
    void playRequested(const QString &animationPath);
    void stopRequested();
    void themeChanged(const QString &themeId);
    void themesChanged();
    void playingChanged(bool playing);

private:
    void loadThemeList();

    AnimationLoader *m_loader;
    QString          m_currentTheme;
    QStringList      m_availableThemes;
    bool             m_playing = false;
};
