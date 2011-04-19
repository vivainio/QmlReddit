#ifndef LIFECYCLE_H
#define LIFECYCLE_H

#include <QObject>

class QWidget;


#include "qmlapplicationviewer.h"

// xxx bad class name, rename
class LifeCycle : public QObject
{
    Q_OBJECT
public:
    explicit LifeCycle(QObject *parent = 0);

    void setView(QmlApplicationViewer* w);

    Q_PROPERTY (bool haveExitButton READ getHaveExitButton)


    bool getHaveExitButton() const;

signals:

public slots:

    // "auto" or "landscape"
    void setOrientation(const QString& orient);
    void toggleState();
    void exitAppView();
    void launchAltBrowser(const QString& url);


private:
    QmlApplicationViewer* m_mainWindow;
};

#endif // LIFECYCLE_H
