#include "lifecycle.h"
#include <QDeclarativeView>

#ifdef Q_WS_MAEMO_5
#include <QDBusConnection>
#include <QDBusMessage>
#endif

#include <QDesktopServices>
#include <QProcess>
LifeCycle::LifeCycle(QObject *parent) :
    QObject(parent)
{
}

void LifeCycle::setView(QmlApplicationViewer* w)
{
    m_mainWindow = w;
}

void LifeCycle::toggleState()
{
    if (!m_mainWindow->isFullScreen()) {
        m_mainWindow->showFullScreen();
    } else {
        m_mainWindow->showMaximized();
    }
}

void LifeCycle::setOrientation(const QString &orient)
{
    if (orient == "auto") {
        m_mainWindow->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    } else if (orient == "landscape") {
        m_mainWindow->setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    }

}



void LifeCycle::exitAppView()
{
#ifdef Q_WS_MAEMO_5
    QDBusConnection bus = QDBusConnection::sessionBus();

    QDBusMessage message = QDBusMessage::createSignal("/", "com.nokia.hildon_desktop", "exit_app_view");
        bus.send(message);
#endif

}

bool LifeCycle::getHaveExitButton() const
{
#ifdef Q_WS_MAEMO_5
    return true;
#else
    return false;
#endif
}

void LifeCycle::launchAltBrowser(const QString &url)
{
#ifdef IS_MEEGO_TABLET
    QByteArray cmd = "operamobile " + url.toLocal8Bit();
    QProcess* p = new QProcess(this);
    p->start(cmd);

#else
    QDesktopServices::openUrl(url);
#endif

}

