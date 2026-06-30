// QuoteManager.cpp
#include "QuoteManager.h"
#include <QDebug>
#include <QRandomGenerator>
#include <algorithm>

QuoteManager::QuoteManager(QObject *parent)
    : QObject(parent)
{
    loadQuotes();
}

void QuoteManager::loadQuotes()
{
    // 硬编码话语列表（健康、搞笑、励志三类），不依赖外部文件，简化部署
    m_quotes = {
        // —— 健康类 ——
        QStringLiteral("水是生命之源，喝起来！"),
        QStringLiteral("每天八杯水，健康一辈子"),
        QStringLiteral("电充满、尿喝白、事干黄"),
        QStringLiteral("喝水不积极，思想有问题"),
        QStringLiteral("多喝水，少生病"),
        QStringLiteral("肾脏排毒，全靠你喝"),
        // —— 搞笑类 ——
        QStringLiteral("喝完这杯还有三杯"),
        QStringLiteral("我已经在喝了，别催了！"),
        QStringLiteral("喝水使我快乐，是真的"),
        QStringLiteral("再不喝水，就要变成咸鱼了"),
        QStringLiteral("杯子已就位，开喝！"),
        QStringLiteral("喝水打卡，今日第N杯"),
        // —— 励志类 ——
        QStringLiteral("坚持喝水，是一种自律"),
        QStringLiteral("每一口水，都是对身体的投资"),
        QStringLiteral("今天也要元气满满地喝水"),
        QStringLiteral("喝下去的是水，流出来的是力量"),
        QStringLiteral("小水滴汇聚成大海"),
        QStringLiteral("你喝的不是水，是健康")
    };

    // 重建轮换顺序
    rebuildShuffleOrder();
    m_currentPos = 0;

    qDebug() << "[QuoteManager] Loaded" << m_quotes.size() << "quotes";
}

QString QuoteManager::randomQuote()
{
    // 防御性：确保已加载
    if (m_quotes.isEmpty()) {
        loadQuotes();
    }
    if (m_shuffleOrder.isEmpty() || m_currentPos >= m_shuffleOrder.size()) {
        // 一轮结束，重新打乱
        rebuildShuffleOrder();
        m_currentPos = 0;
    }

    int idx = m_shuffleOrder.at(m_currentPos);
    ++m_currentPos;

    QString quote = m_quotes.value(idx);
    emit quoteChanged(quote);
    return quote;
}

void QuoteManager::rebuildShuffleOrder()
{
    int n = m_quotes.size();
    if (n <= 0) {
        m_shuffleOrder.clear();
        return;
    }

    // Fisher-Yates shuffle：生成 [0, n) 的随机排列
    m_shuffleOrder.resize(n);
    for (int i = 0; i < n; ++i) {
        m_shuffleOrder[i] = i;
    }
    for (int i = n - 1; i > 0; --i) {
        int j = QRandomGenerator::global()->bounded(i + 1);
        std::swap(m_shuffleOrder[i], m_shuffleOrder[j]);
    }
}
