#include <QtGui/QApplication>


#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "redditmodel.h"
#include <QNetworkProxy>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>
#include <QSettings>
#include "lifecycle.h"

#ifdef HAVE_GLWIDGET
#include <QGLWidget>
#endif

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


    //QApplication::setGraphicsSystem("raster");

    QSettings s("VilleSoft", "QmlReddit" );
    QString gs = s.value("startup/graphicssystem", "").toString();

    if (gs == "raster") {
        QApplication::setGraphicsSystem("raster");
        //qDebug() << "Using 'raster' graphics system as requested";
    }

    QApplication app(argc, argv);

    QCoreApplication::setOrganizationName("VilleSoft");
    QCoreApplication::setOrganizationDomain("unknown.domain");
    QCoreApplication::setApplicationName("QmlReddit");


    app.setProperty("NoMStyle", true);

    //app.setStyle("motif");

#ifdef THANK_YOU_NOKIA
    setNokesProxy();
#endif

    QmlApplicationViewer viewer;    

    QString os = "unknown";
#ifdef Q_WS_MAEMO_5
    os = "maemo5";
#endif


#ifdef IS_MEEGO_TABLET
    os = "meegotablet";
#endif


#ifdef IS_HARMATTAN
    os = "harmattan";

#endif

#ifdef Q_OS_SYMBIAN
    os = "symbian";
#endif


#ifdef HAVE_GLWIDGET
    QGLWidget *glWidget = new QGLWidget(&viewer);
    viewer.setViewport(glWidget);
#endif

    viewer.setAttribute(Qt::WA_NoSystemBackground);
    viewer.setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    viewer.viewport()->setAttribute(Qt::WA_NoSystemBackground);

    RedditModel mdl;
    QDeclarativeContext *ctxt = viewer.rootContext();

    RedditModel* m = new RedditModel;
    m->setup(ctxt);

    LifeCycle* lc = new LifeCycle(&viewer);
    lc->setView(&viewer);
    ctxt->setContextProperty("lifecycle", lc);


    ctxt->setContextProperty("hostOs", os);

    if (os == "harmattan") {
        viewer.setMainQmlFile(QLatin1String("qml/qmlreddit/MainHarmattan.qml"));
    } else {
        viewer.setMainQmlFile(QLatin1String("qml/qmlreddit/MainRawQml.qml"));
    }
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

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

#ifdef IS_MEEGO_TABLET
    viewer.showFullScreen();
#endif

    return app.exec();
}
