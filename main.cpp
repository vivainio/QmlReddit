#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "redditmodel.h"

#include <QDeclarativeContext>
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QmlApplicationViewer viewer;
    RedditModel mdl;
    QDeclarativeContext *ctxt = viewer.rootContext();

    RedditModel* m = new RedditModel;
    m->setup(ctxt);

    viewer.setOrientation(QmlApplicationViewer::Auto);
    viewer.setMainQmlFile(QLatin1String("qml/qmlreddit/main.qml"));
    viewer.show();

    return app.exec();
}
