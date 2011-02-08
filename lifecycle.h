#ifndef LIFECYCLE_H
#define LIFECYCLE_H

#include <QObject>

class QWidget;


#include "qmlapplicationviewer.h"

class LifeCycle : public QObject
{
    Q_OBJECT
public:
    explicit LifeCycle(QObject *parent = 0);

    void setView(QmlApplicationViewer* w);

signals:

public slots:

    // "auto" or "landscape"
    void setOrientation(const QString& orient);
    void toggleState();
    void exitAppView();

private:
    QmlApplicationViewer* m_mainWindow;
};

#endif // LIFECYCLE_H
