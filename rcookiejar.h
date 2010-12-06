#ifndef RCOOKIEJAR_H
#define RCOOKIEJAR_H

#include <QNetworkCookieJar>
#include <QVariantMap>

#include <QByteArray>

class RCookieJar : public QNetworkCookieJar
{
    Q_OBJECT
public:
    explicit RCookieJar(QObject *parent = 0);

    virtual bool setCookiesFromUrl ( const QList<QNetworkCookie> & cookieList, const QUrl & url );

    QByteArray store();
    void restore(const QByteArray& stored);
    void clear();
signals:

public slots:
    QVariantMap cookies();


};

#endif // RCOOKIEJAR_H
