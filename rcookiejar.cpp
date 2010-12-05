#include "rcookiejar.h"
#include <QDebug>

RCookieJar::RCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
}

bool RCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    qDebug() << "set for url " << url;

    foreach (const QNetworkCookie& c, cookieList) {
        qDebug() << " have c" << c;

    }
    QNetworkCookieJar::setCookiesFromUrl(cookieList, url);

    //int a =1;
}
