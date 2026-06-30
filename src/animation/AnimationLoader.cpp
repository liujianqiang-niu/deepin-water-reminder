// AnimationLoader.cpp
#include "AnimationLoader.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

AnimationLoader::AnimationLoader(const QString &manifestPath, QObject *parent)
    : QObject(parent)
    , m_manifestPath(manifestPath)
{
    loadAll();
}

static AnimationType typeFromString(const QString &str)
{
    if (str == QLatin1String("lottie")) return AnimationType::Lottie;
    if (str == QLatin1String("qml-sprite")) return AnimationType::QmlSprite;
    if (str == QLatin1String("qml-custom")) return AnimationType::QmlCustom;
    if (str == QLatin1String("gif")) return AnimationType::GifLike;
    return AnimationType::QmlCustom;
}

AnimationDescriptor AnimationLoader::parseJson(const QJsonObject &obj)
{
    AnimationDescriptor desc;
    desc.id = obj.value(QStringLiteral("id")).toString();
    desc.displayName = obj.value(QStringLiteral("displayName")).toString();
    desc.resourcePath = obj.value(QStringLiteral("resourcePath")).toString();
    desc.type = typeFromString(obj.value(QStringLiteral("type")).toString());

    QJsonObject sizeObj = obj.value(QStringLiteral("nativeSize")).toObject();
    desc.nativeSize = QSize(
        sizeObj.value(QStringLiteral("width")).toInt(300),
        sizeObj.value(QStringLiteral("height")).toInt(400)
    );
    desc.defaultDurationMs = obj.value(QStringLiteral("defaultDurationMs")).toInt(6000);
    desc.loop = obj.value(QStringLiteral("loop")).toBool(true);
    desc.maxLoops = obj.value(QStringLiteral("maxLoops")).toInt(2);
    return desc;
}

QVector<AnimationDescriptor> AnimationLoader::loadAll()
{
    m_descriptors.clear();

    QFile file(m_manifestPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "[AnimationLoader] Cannot open manifest:" << m_manifestPath;
        emit loadingError(QString(), QStringLiteral("Cannot open manifest file"));
        return m_descriptors;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "[AnimationLoader] JSON parse error:" << parseError.errorString();
        emit loadingError(QString(), parseError.errorString());
        return m_descriptors;
    }

    QJsonObject root = doc.object();
    QJsonArray animations = root.value(QStringLiteral("animations")).toArray();

    for (const QJsonValue &val : animations) {
        QJsonObject animObj = val.toObject();
        AnimationDescriptor desc = parseJson(animObj);
        if (!desc.id.isEmpty()) {
            m_descriptors.append(desc);
            qDebug() << "[AnimationLoader] Loaded animation:" << desc.id << "-" << desc.displayName;
        }
    }

    qDebug() << "[AnimationLoader] Total animations loaded:" << m_descriptors.size();
    return m_descriptors;
}

AnimationDescriptor AnimationLoader::loadById(const QString &id)
{
    for (const auto &desc : m_descriptors) {
        if (desc.id == id) {
            return desc;
        }
    }
    qWarning() << "[AnimationLoader] Animation not found:" << id;
    emit loadingError(id, QStringLiteral("Animation not found"));
    return AnimationDescriptor();
}

QStringList AnimationLoader::listThemeIds() const
{
    QStringList ids;
    for (const auto &desc : m_descriptors) {
        ids.append(desc.id);
    }
    return ids;
}

QStringList AnimationLoader::listThemeDisplayNames() const
{
    QStringList names;
    for (const auto &desc : m_descriptors) {
        names.append(desc.displayName);
    }
    return names;
}

bool AnimationLoader::isValid(const QString &id) const
{
    for (const auto &desc : m_descriptors) {
        if (desc.id == id) return true;
    }
    return false;
}
