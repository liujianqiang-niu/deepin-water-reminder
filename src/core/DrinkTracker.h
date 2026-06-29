// DrinkTracker.h
#pragma once
#include <QObject>
#include <QDate>
#include <QMap>

class DrinkTracker : public QObject {
    Q_OBJECT
    Q_PROPERTY(int todayCount READ todayCount NOTIFY todayCountChanged)
    Q_PROPERTY(int weekCount READ weekCount NOTIFY weekCountChanged)

public:
    explicit DrinkTracker(QObject *parent = nullptr);

    int todayCount() const;
    int weekCount() const;

public slots:
    void recordDrink();        // 记录一次喝水
    void clearHistory();       // 清除历史记录

signals:
    void todayCountChanged(int count);
    void weekCountChanged(int count);
    void drinkRecorded(const QDate &date, int totalCount);

private:
    void loadFromSettings();
    void saveToSettings();
    int countWeekDrinks() const;

    QMap<QDate, int> m_dailyRecords; // date -> count
    int m_todayCount = 0;
    int m_weekCount = 0;
};
