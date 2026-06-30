// DrinkTracker.h
#pragma once
#include <QObject>
#include <QDate>
#include <QMap>

class SettingsManager;

class DrinkTracker : public QObject {
    Q_OBJECT
    Q_PROPERTY(int todayCount READ todayCount NOTIFY todayCountChanged)
    Q_PROPERTY(int weekCount READ weekCount NOTIFY weekCountChanged)
    Q_PROPERTY(int todayProgress READ todayProgress NOTIFY todayProgressChanged)

public:
    explicit DrinkTracker(SettingsManager *settings = nullptr, QObject *parent = nullptr);

    int todayCount() const;
    int weekCount() const;
    int dailyGoal() const;
    int todayProgress() const;

public slots:
    void recordDrink();        // 记录一次喝水
    void clearHistory();       // 清除历史记录

signals:
    void todayCountChanged(int count);
    void weekCountChanged(int count);
    void todayProgressChanged(int progress);
    void drinkRecorded(const QDate &date, int totalCount);

private:
    void loadFromSettings();
    void saveToSettings();
    int countWeekDrinks() const;

    SettingsManager *m_settings = nullptr;
    QMap<QDate, int> m_dailyRecords; // date -> count
    int m_todayCount = 0;
    int m_weekCount = 0;
};
