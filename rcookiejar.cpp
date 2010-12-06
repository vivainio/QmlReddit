#include "rcookiejar.h"
#include <QDebug>
#include <QSettings>
#include <QDataStream>
#include <QByteArray>
// nicked from arora
static const unsigned int JAR_VERSION = 23;

QT_BEGIN_NAMESPACE
QDataStream &operator<<(QDataStream &stream, const QList<QNetworkCookie> &list)
{
    stream << JAR_VERSION;
    stream << quint32(list.size());
    for (int i = 0; i < list.size(); ++i)
        stream << list.at(i).toRawForm();
    return stream;
}

QDataStream &operator>>(QDataStream &stream, QList<QNetworkCookie> &list)
{
    list.clear();

    quint32 version;
    stream >> version;

    if (version != JAR_VERSION)
        return stream;

    quint32 count;
    stream >> count;
    for (quint32 i = 0; i < count; ++i) {
        QByteArray value;
        stream >> value;
        QList<QNetworkCookie> newCookies = QNetworkCookie::parseCookies(value);
        if (newCookies.count() == 0 && value.length() != 0) {
            qWarning() << "CookieJar: Unable to parse saved cookie:" << value;
        }
        for (int j = 0; j < newCookies.count(); ++j)
            list.append(newCookies.at(j));
        if (stream.atEnd())
            break;
    }
    return stream;
}
QT_END_NAMESPACE


RCookieJar::RCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
}

bool RCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    qDebug() << "Setting cookie for " << url << " : " <<cookieList;

    return QNetworkCookieJar::setCookiesFromUrl(cookieList, url);

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

QByteArray RCookieJar::store()
{
    QByteArray arr;
    QDataStream ds(&arr, QIODevice::WriteOnly);
    ds << allCookies();
    return arr;
}

void RCookieJar::restore(const QByteArray &stored)
{

    QDataStream ds(stored);
    QList<QNetworkCookie> l;
    ds >> l;
    setAllCookies(l);

}

