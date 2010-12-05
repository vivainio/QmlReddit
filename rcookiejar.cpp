#include "rcookiejar.h"
#include <QDebug>

RCookieJar::RCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
}

bool RCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    QNetworkCookieJar::setCookiesFromUrl(cookieList, url);
}
