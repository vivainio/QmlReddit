#include "platutil.h"
#include <QWidget>
#include <QDesktopServices>
#include <QString>

PlatUtil::PlatUtil()
{
}

#if 0
void PlatUtil::configureWindow(QWidget *wdg)
{
#ifdef Q_WS_MAEMO_5
    wdg->setAttribute(Qt::WA_Maemo5StackedWindow);
    //wdg->setAttribute(Qt::WA_Maemo5AutoOrientation);
#endif
}

void PlatUtil::toggleBusy(QWidget *wdg, bool busy)
{
#ifdef Q_WS_MAEMO_5
    wdg->setAttribute(Qt::WA_Maemo5ShowProgressIndicator, busy);
#endif
}

#endif

QString PlatUtil::configFile()
{
    QString path;
#ifdef Q_WS_MAEMO_5
    path =  QDesktopServices::storageLocation(QDesktopServices::HomeLocation);
#else
    path = "/tmp";

#endif
    return path + "/.qreddit";

}
