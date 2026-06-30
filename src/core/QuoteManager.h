// QuoteManager.h
#pragma once
#include <QObject>
#include <QString>
#include <QVector>

class QuoteManager : public QObject {
    Q_OBJECT

public:
    explicit QuoteManager(QObject *parent = nullptr);

    // 加载内置趣味话语（硬编码，不依赖外部文件）
    void loadQuotes();

    // 随机返回一条话语，使用不重复轮换算法（全部轮完一遍后才重复）
    QString randomQuote();

signals:
    void quoteChanged(const QString &quote);

private:
    // 重建打乱顺序（Fisher-Yates shuffle），保证一轮内不重复
    void rebuildShuffleOrder();

    QVector<QString> m_quotes;       // 内置话语列表
    QVector<int>     m_shuffleOrder; // 当前轮换顺序（m_quotes 的索引）
    int              m_currentPos = 0; // 在 m_shuffleOrder 中的当前位置
};
