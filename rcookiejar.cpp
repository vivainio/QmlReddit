#include "rcookiejar.h"
#include <QDebug>

RCookieJar::RCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
}

bool RCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    qDebug() << "Setting cookie for " << url << " : " <<cookieList;

    QNetworkCookieJar::setCookiesFromUrl(cookieList, url);

}

QVariantMap RCookieJar::cookies()
{
    QList<QNetworkCookie> cs = allCookies();
    QVariantMap res;
    foreach (const QNetworkCookie& c, cs) {
        res[c.name()] = c.value();

    }

    return res;
}

