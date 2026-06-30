// AnimationLoader.h
#pragma once
#include <QObject>
#include <QVector>
#include "../core/AnimationDescriptor.h"

class AnimationLoader : public QObject {
    Q_OBJECT
public:
    explicit AnimationLoader(const QString &manifestPath,
                            QObject *parent = nullptr);
    QVector<AnimationDescriptor> loadAll();
    AnimationDescriptor          loadById(const QString &id);
    QStringList                  listThemeIds() const;
    QStringList                  listThemeDisplayNames() const;
    bool                         isValid(const QString &id) const;

signals:
    void loadingError(const QString &themeId, const QString &error);

private:
    AnimationDescriptor parseJson(const QJsonObject &obj);
    QVector<AnimationDescriptor> m_descriptors;
    QString m_manifestPath;
};
