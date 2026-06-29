// DrinkTracker.cpp
#include "DrinkTracker.h"
#include <QSettings>
#include <QDebug>

DrinkTracker::DrinkTracker(QObject *parent)
    : QObject(parent)
{
    loadFromSettings();
}

int DrinkTracker::todayCount() const
{
    return m_todayCount;
}

int DrinkTracker::weekCount() const
{
    return m_weekCount;
}

void DrinkTracker::recordDrink()
{
    QDate today = QDate::currentDate();
    m_dailyRecords[today]++;

    m_todayCount = m_dailyRecords.value(today, 0);
    m_weekCount = countWeekDrinks();

    saveToSettings();

    qDebug() << "[DrinkTracker] Recorded drink on" << today << "count:" << m_todayCount;
    emit todayCountChanged(m_todayCount);
    emit weekCountChanged(m_weekCount);
    emit drinkRecorded(today, m_todayCount);
}

void DrinkTracker::clearHistory()
{
    m_dailyRecords.clear();
    m_todayCount = 0;
    m_weekCount = 0;
    saveToSettings();
    emit todayCountChanged(0);
    emit weekCountChanged(0);
}

void DrinkTracker::loadFromSettings()
{
    QSettings settings(QStringLiteral("deepin"), QStringLiteral("deepin-water-reminder"));
    int size = settings.beginReadArray(QStringLiteral("drinkRecords"));
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        QDate date = QDate::fromString(settings.value(QStringLiteral("date")).toString(), Qt::ISODate);
        int count = settings.value(QStringLiteral("count"), 0).toInt();
        if (date.isValid()) {
            m_dailyRecords[date] = count;
        }
    }
    settings.endArray();

    m_todayCount = m_dailyRecords.value(QDate::currentDate(), 0);
    m_weekCount = countWeekDrinks();
}

void DrinkTracker::saveToSettings()
{
    QSettings settings(QStringLiteral("deepin"), QStringLiteral("deepin-water-reminder"));
    settings.beginWriteArray(QStringLiteral("drinkRecords"));
    int i = 0;
    // 只保留最近30天的记录
    QDate cutoff = QDate::currentDate().addDays(-30);
    for (auto it = m_dailyRecords.begin(); it != m_dailyRecords.end(); ++it) {
        if (it.key() >= cutoff) {
            settings.setArrayIndex(i++);
            settings.setValue(QStringLiteral("date"), it.key().toString(Qt::ISODate));
            settings.setValue(QStringLiteral("count"), it.value());
        }
    }
    settings.endArray();
}

int DrinkTracker::countWeekDrinks() const
{
    QDate today = QDate::currentDate();
    QDate weekStart = today.addDays(-(today.dayOfWeek() - 1)); // Monday
    int total = 0;
    for (auto it = m_dailyRecords.begin(); it != m_dailyRecords.end(); ++it) {
        if (it.key() >= weekStart && it.key() <= today) {
            total += it.value();
        }
    }
    return total;
}
