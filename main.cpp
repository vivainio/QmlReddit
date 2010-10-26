#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "redditmodel.h"
#include <QNetworkProxy>

#include <QDeclarativeContext>

//#define THANK_YOU_NOKIA

void setNokesProxy()
{
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpCachingProxy);
    proxy.setHostName("192.168.220.6");
    proxy.setPort((8080));
    QNetworkProxy::setApplicationProxy(proxy);
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

#ifdef THANK_YOU_NOKIA
    setNokesProxy();
#endif

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
