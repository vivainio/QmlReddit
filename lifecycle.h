#ifndef LIFECYCLE_H
#define LIFECYCLE_H

#include <QObject>

class QWidget;
class QDeclarativeView;

class LifeCycle : public QObject
{
    Q_OBJECT
public:
    explicit LifeCycle(QObject *parent = 0);

    void setView(QDeclarativeView* w);

signals:

public slots:

    void toggleState();

private:
    QDeclarativeView* m_mainWindow;
};

#endif // LIFECYCLE_H
