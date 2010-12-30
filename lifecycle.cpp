#include "lifecycle.h"
#include <QDeclarativeView>

LifeCycle::LifeCycle(QObject *parent) :
    QObject(parent)
{
}

void LifeCycle::setView(QDeclarativeView *w)
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
