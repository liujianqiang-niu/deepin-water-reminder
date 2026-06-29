// main.cpp
#include "app/Application.h"
#include <QLockFile>
#include <QDebug>
#include <QDir>
#include <QMessageBox>

int main(int argc, char *argv[])
{
    QString lockPath = QDir::tempPath() + QStringLiteral("/deepin-water-reminder.lock");
    QLockFile lockFile(lockPath);

    if (!lockFile.tryLock(100)) {
        qWarning() << "Another instance is already running, exiting.";
        return 0;
    }

    Application app(argc, argv);
    return app.run();
}
