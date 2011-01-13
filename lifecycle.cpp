#include "lifecycle.h"
#include <QDeclarativeView>

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
