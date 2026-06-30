// test_SettingsManager.cpp
#include <QtTest>
#include <QSettings>
#include "../src/settings/SettingsManager.h"

class TestSettingsManager : public QObject {
    Q_OBJECT

private slots:
    void initTestCase()
    {
        QSettings settings(QStringLiteral("deepin"), QStringLiteral("deepin-water-reminder"));
        settings.clear();
        settings.sync();
    }

    void testDefaults()
    {
        SettingsManager settings;
        QCOMPARE(settings.intervalMinutes(), 60);
        QCOMPARE(settings.animationTheme(), QStringLiteral("skeleton"));
        QCOMPARE(settings.animationDuration(), 6);
        QCOMPARE(settings.autoStart(), false);
    }

    void testNewDefaults()
    {
        SettingsManager settings;
        QCOMPARE(settings.showQuotes(), true);
        QCOMPARE(settings.dailyGoal(), 8);
        QCOMPARE(settings.reminderMessage(), QString());
        QCOMPARE(settings.soundEnabled(), true);
    }

    void testSetShowQuotes()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::showQuotesChanged);

        settings.setShowQuotes(false);
        QCOMPARE(settings.showQuotes(), false);
        QCOMPARE(spy.count(), 1);
    }

    void testSetDailyGoal()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::dailyGoalChanged);

        settings.setDailyGoal(10);
        QCOMPARE(settings.dailyGoal(), 10);
        QCOMPARE(spy.count(), 1);
    }

    void testSetReminderMessage()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::reminderMessageChanged);

        settings.setReminderMessage(QStringLiteral("该喝水了！"));
        QCOMPARE(settings.reminderMessage(), QStringLiteral("该喝水了！"));
        QCOMPARE(spy.count(), 1);
    }

    void testSetSoundEnabled()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::soundEnabledChanged);

        settings.setSoundEnabled(false);
        QCOMPARE(settings.soundEnabled(), false);
        QCOMPARE(spy.count(), 1);
    }

    void testSetInterval()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::intervalChanged);

        settings.setIntervalMinutes(90);
        QCOMPARE(settings.intervalMinutes(), 90);
        QCOMPARE(spy.count(), 1);
    }

    void testSetTheme()
    {
        SettingsManager settings;
        QSignalSpy spy(&settings, &SettingsManager::themeChanged);

        settings.setAnimationTheme(QStringLiteral("lion"));
        QCOMPARE(settings.animationTheme(), QStringLiteral("lion"));
        QCOMPARE(spy.count(), 1);
    }

    void testAvailableIntervals()
    {
        SettingsManager settings;
        QStringList intervals = settings.availableIntervals();
        QVERIFY(intervals.contains(QStringLiteral("15")));
        QVERIFY(intervals.contains(QStringLiteral("60")));
        QVERIFY(intervals.contains(QStringLiteral("120")));
    }
};

QTEST_MAIN(TestSettingsManager)
#include "test_SettingsManager.moc"
