// AnimationDescriptor.h
#pragma once
#include <QString>
#include <QSize>

enum class AnimationType {
    Lottie,       // Lottie JSON 动画
    QmlSprite,    // QML SpriteSequence 序列帧
    QmlCustom,    // 自定义 QML 组件
    GifLike       // GIF 风格帧序列
};

struct AnimationDescriptor {
    QString   id;
    QString   displayName;       // e.g. "骷髅舞动"
    QString   resourcePath;      // QML file or Lottie JSON
    AnimationType type;
    QSize     nativeSize;
    int       defaultDurationMs; // default playback ms
    bool      loop;
    int       maxLoops;          // 0 = until user dismisses
};
