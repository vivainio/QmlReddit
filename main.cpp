#include <QtGui/QApplication>
#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "redditmodel.h"
#include <QNetworkProxy>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>

#include "lifecycle.h"

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
//#ifdef Q_OS_SYMBIAN
//    QApplication::setGraphicsSystem("openvg");
//#endif
    QApplication app(argc, argv);

    //app.setStyle("motif");

#ifdef THANK_YOU_NOKIA
    setNokesProxy();
#endif

    QmlApplicationViewer viewer;

    RedditModel mdl;
    QDeclarativeContext *ctxt = viewer.rootContext();
    //ctxt->engine()->setOfflineStoragePath("/home/ville/offline");


    RedditModel* m = new RedditModel;
    m->setup(ctxt);

    LifeCycle* lc = new LifeCycle(&viewer);
    lc->setView(&viewer);
    ctxt->setContextProperty("lifecycle", lc);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/qmlreddit/main.qml"));
    viewer.show();
#ifdef Q_WS_SIMULATOR
    viewer.showFullScreen();
#endif

#ifdef Q_WS_MAEMO_5
    viewer.showFullScreen();
#endif

#ifdef Q_OS_SYMBIAN
    viewer.showFullScreen();
#endif

    return app.exec();
}
