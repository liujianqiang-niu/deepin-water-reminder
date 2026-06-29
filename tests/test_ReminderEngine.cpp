// test_ReminderEngine.cpp
#include <QtTest>
#include <QSettings>
#include "../src/core/ReminderEngine.h"
#include "../src/settings/SettingsManager.h"

class TestReminderEngine : public QObject {
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
        SettingsManager settings;
        ReminderEngine engine(&settings);

        QCOMPARE(engine.isActive(), false);
        QCOMPARE(engine.intervalMinutes(), 60); // default
    }

    void testStartStop()
    {
        SettingsManager settings;
        ReminderEngine engine(&settings);

        engine.start();
        QCOMPARE(engine.isActive(), true);

        engine.stop();
        QCOMPARE(engine.isActive(), false);
    }

    void testInterval()
    {
        SettingsManager settings;
        ReminderEngine engine(&settings);

        engine.setIntervalMinutes(30);
        QCOMPARE(engine.intervalMinutes(), 30);
    }

    void testTriggerSignal()
    {
        SettingsManager settings;
        ReminderEngine engine(&settings);

        QSignalSpy spy(&engine, &ReminderEngine::reminderTriggered);

        engine.triggerNow();
        QCOMPARE(spy.count(), 1);
    }

    void testPauseResume()
    {
        SettingsManager settings;
        ReminderEngine engine(&settings);

        // We can't fully test timing here, just API
        engine.start();
        engine.pause(1);  // 1 minute pause
        QCOMPARE(engine.isActive(), false);

        engine.resume();
        QCOMPARE(engine.isActive(), true);
    }
};

QTEST_MAIN(TestReminderEngine)
#include "test_ReminderEngine.moc"
