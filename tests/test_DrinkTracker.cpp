// test_DrinkTracker.cpp
#include <QtTest>
#include <QSettings>
#include "../src/core/DrinkTracker.h"

class TestDrinkTracker : public QObject {
    Q_OBJECT

private slots:
    void initTestCase()
    {
        QSettings settings(QStringLiteral("deepin"), QStringLiteral("deepin-water-reminder"));
        settings.clear();
        settings.sync();
    }

    void testInitialState()
    {
        DrinkTracker tracker;
        QCOMPARE(tracker.todayCount(), 0);
        QCOMPARE(tracker.weekCount(), 0);
    }

    void testRecordDrink()
    {
        DrinkTracker tracker;
        QSignalSpy spy(&tracker, &DrinkTracker::todayCountChanged);

        tracker.recordDrink();
        QCOMPARE(spy.count(), 1);
        QVERIFY(tracker.todayCount() >= 1);
    }

    void testClearHistory()
    {
        DrinkTracker tracker;
        tracker.recordDrink();
        tracker.recordDrink();

        tracker.clearHistory();
        QCOMPARE(tracker.todayCount(), 0);
        QCOMPARE(tracker.weekCount(), 0);
    }
};

QTEST_MAIN(TestDrinkTracker)
#include "test_DrinkTracker.moc"
