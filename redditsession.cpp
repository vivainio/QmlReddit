#include "redditsession.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QDebug>
#include <QScriptEngine>
#include <QScriptValue>
#include <QScriptValueIterator>

#include <QStringList>
#include <QXmlDefaultHandler>
#include <QXmlSimpleReader>
//#include "platutil.h"
#include <QFileInfo>
#include <QNetworkCookieJar>
#include <QNetworkCookie>
#include <QCoreApplication>

#include "rcookiejar.h"

#include "platutil.h"
#include <QSettings>

//#define RSTEST

RedditSession::RedditSession(QObject *parent) :
    QObject(parent)
{
    m_net = new QNetworkAccessManager(this);


    m_eng = new QScriptEngine;
    QCoreApplication::setOrganizationName("VilleSoft");
    QCoreApplication::setOrganizationDomain("unknown.domain");
    QCoreApplication::setApplicationName("QmlReddit");

    RCookieJar* cj = new RCookieJar(this);
    QSettings s;
    QVariant v = s.value("Auth/Cookies");
    if (v.isValid())
        cj->restore(v.toByteArray());

    m_net->setCookieJar(cj);
}


void RedditSession::start(const QString& cat, const QString& queryargs)
{

    QString url;
    if (cat.length() == 0) {
        url = QString("http://www.reddit.com/.json?%1").arg(queryargs);
    } else {
        url = QString("http://www.reddit.com/r/%1/.json?%2").arg(cat).arg(queryargs);
    }

    QNetworkRequest req(url);

    qDebug() << "req " << url;
    QNetworkReply* reply = m_net->get(req);

    connect(reply, SIGNAL(finished()), this, SLOT(linksFetched()));

    //login("qmtest", "qmtest");

}

QScriptValue RedditSession::parseJson(QString msg)
{
    msg.prepend("(");
    msg.append(")");
    QScriptValue sc = m_eng->evaluate(msg);
    if (m_eng->hasUncaughtException()) {
      QStringList bt = m_eng->uncaughtExceptionBacktrace();
      qDebug() << bt.join("\n");
    }
    return sc;
}

void RedditSession::linksFetched()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply)
        return;

    //qDebug() << "fetched";

    QByteArray ba = reply->readAll();
    //qDebug() << "data " << ba;
    QScriptValue sv = parseJson(ba);
    QScriptValue items = sv.property("data").property("children");
    //qDebug() << "chi " << items.toString();
    QScriptValueIterator it(items);
    m_ents.clear();
    while (it.hasNext()) {
        it.next();
        QScriptValue v = it.value().property("data");
        QString url = v.property("url").toString();
        QString title = v.property("title").toString();        
        QString tnail = v.property("thumbnail").toString();
        QString name = v.property("name").toString();        
        expandHtmlEntities(title);

        int score = v.property("score").toInt32();
        //qDebug() << v.toString() << title << " U " << url << " TN " << tnail;
        RedditEntry e;
        e.desc = title;
        e.url = url;
        e.permalink = v.property("permalink").toString();
        e.thumbnail = tnail;
        e.score = score;
        e.comments = v.property("num_comments").toString();
        e.name = name;
        if (title.length())
            m_ents.append(e);
    }
    emit linksAvailable();
    reply->deleteLater();
}

const QVector<RedditEntry>& RedditSession::getEntries()
{
    return m_ents;
}

void RedditSession::fetchComments(const QString &commentaddr)
{
    QString url = "http://www.reddit.com";
    url.append(commentaddr);
    url.append(".json");
    //qDebug() << "fetch " << url;
    QNetworkRequest req(url);
    QNetworkReply* reply = m_net->get(req);
    connect(reply, SIGNAL(finished()), this, SLOT(commentsFetched()));

}

#if 0
class CommentsParser : public QXmlDefaultHandler
{

    bool startElement(const QString& namespaceURI, const QString& localName, const QString& qName, const QXmlAttributes& atts)
    {
        //qDebug() << "start " << localName;
        if (localName == "description") {
            m_indesc = true;
            m_current = "";
        } else
        {
            m_indesc = false;
        }
        return true;

    }
    bool endElement(const QString& namespaceURI, const QString& localName, const QString& qName)
    {
        qDebug() << "end l" << localName << "n " << qName;
        RedditSession::expandHtmlEntities(m_current);
        //QString trans = m_current.replace("&quot;", "\"").replace("&amp;", "&").
        //        replace("&gt;",">").replace("&lt;", "<");
        if (localName == "description") {
            m_comments.append(m_current);
        }
        return true;

    }

    bool characters(const QString& ch)
    {
        if (m_indesc) {
            m_current.append(ch);
        }
        //qDebug() << "ch " << ch;
        return true;

    }

    QString m_current;
    bool m_indesc;

public:
    QStringList m_comments;

};
#endif
void RedditSession::commentsFetched()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply)
        return;

    QByteArray ba = reply->readAll();
    ba.prepend("(");
    ba.append(")");
    QString s = ba;
    expandHtmlEntities(s);

    emit commentsJsonAvailable(s);
#if 0
    //qDebug() << "data " << ba;
    QScriptValue sv = parseJson(ba);

    QScriptValue items = sv.property("data").property("children");
    qDebug() << "items" << items.toString();
    /*

    QXmlSimpleReader r;
    CommentsParser p;
    r.setContentHandler(&p);
    QXmlInputSource inp(reply);
    r.parse(&inp);
    m_comments = p.m_comments;
    */
    emit commentsAvailable();
#endif
    reply->deleteLater();
}


/*
void RedditSession::commentsFetched()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply)
        return;

    QXmlSimpleReader r;
    CommentsParser p;
    r.setContentHandler(&p);
    QXmlInputSource inp(reply);
    r.parse(&inp);
    m_comments = p.m_comments;
    emit commentsAvailable();
    reply->deleteLater();

}
*/

QStringList RedditSession::getCategories()
{
    //return QStringList() << "programming" << "pics";

    QStringList cats;

    cats << m_myreddits;

    QString cf = PlatUtil::configFile();
    //qDebug() << "Config " << cf;
    QFileInfo fi(cf);


    if (!fi.exists()) {
        QFile f(cf);
        f.open(QFile::WriteOnly);
        QStringList defaults(QStringList() << "programming" << "pics" << "technology" << "funny"
                             << "news" << "comics" << "python" << "wtf" << "gaming" <<
                             "IAmA" << "maemo" << "meego" << "science" << "bestof" << "gadgets" <<
                             "music" << "hardware" << "worldnews" << "linux" << "offbeat" << "sports"
                             );
        QString joined = defaults.join("\n") + "\n";
        f.write(joined.toUtf8());
        f.close();
    }

    QFile f(cf);
    bool r = f.open(QFile::ReadOnly);
    Q_ASSERT(r);

    QTextStream ts(&f);
    for (;;) {
        if (ts.atEnd())
            break;
        QString line = ts.readLine().simplified();
        if (line.startsWith('#'))
            continue;
        if (line.length())
            cats.append(line);

    }
    f.close();
    // "easy" way to reset - just delete all lines
    if (cats.empty()) {
        f.remove();
        cats = getCategories();

    }

    cats.removeDuplicates();

    return cats;

}

void RedditSession::expandHtmlEntities(QString &text)
{
    text.replace("&quot;", "\"").replace("&amp;", "&").
            replace("&gt;",">").replace("&lt;", "<");

}

void RedditSession::login(const QString &user, const QString &passwd)
{
    QString url = "http://www.reddit.com/api/login";

    QNetworkRequest req(url);

    //req.setHeader(QNetworkRequest::CookieSaveControlAttribute, QVariant());


    QUrl params;
    params.addQueryItem("user", user);
    params.addQueryItem("passwd", passwd);

    QByteArray postcont = params.toEncoded();
    postcont.remove(0,1);
    qDebug() << "posting " << postcont;
    QNetworkReply* reply = m_net->post(req, postcont);

    connect(reply, SIGNAL(finished()), this, SLOT(loginFinished()));


}

void RedditSession::loginFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply)
        return;

    // the session id gets saved to cookies
    // modhash to be digged up later

    QByteArray resp = reply->readAll();
    QString s = resp;
    emit loginResponse(s);
    qDebug() << "loginfinish " << s;

    saveCookies();

}

void RedditSession::getMyRedditsFinished()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply)
        return;

    QByteArray ba = reply->readAll();
    //qDebug() << "data " << ba;
    QScriptValue sv = parseJson(ba);
    m_modhash = sv.property("data").property("modhash").toString();
    qDebug() << "modhash " << m_modhash;
    QScriptValue items = sv.property("data").property("children");
    QScriptValueIterator it(items);
    m_myreddits.clear();
    while (it.hasNext()) {
        it.next();
        QScriptValue v = it.value().property("data");
        QString dname = v.property("display_name").toString();
        m_myreddits.append(dname);
        qDebug() << "my " << dname;
    }
    emit categoriesUpdated();

}

QVariantMap RedditSession::cookies()
{
    RCookieJar* jar = qobject_cast<RCookieJar*> (m_net->cookieJar());
    if (!jar)
        return QVariantMap();

    return jar->cookies();

}

void RedditSession::setModhash(const QString &modhash)
{
    m_modhash = modhash;

}

void RedditSession::vote(const QString &thing, int votedir)
{
    /*
    Vote:
    www.reddit.com/api/vote
    cookie required
    POSTDATA: id=t1_abc1010&dir=1&r=android&uh=f0f0f0f0f0f0f0f0f0f0f0
    id is “thing id” of thing you’re voting for.
    dir = 1, 0, or -1. “direction” of vote.
    r = subreddit name
    uh = user modhash

    */

    QString url = "http://www.reddit.com/api/vote";

    QNetworkRequest req(url);

    QUrl params;
    params.addQueryItem("id", thing);
    params.addQueryItem("dir", QString::number(votedir));
    params.addQueryItem("uh", m_modhash);

    QByteArray postcont = params.toEncoded();
    postcont.remove(0,1);
    qDebug() << "posting " << postcont;
    QNetworkReply* reply = m_net->post(req, postcont);
    Q_UNUSED(reply);
}

void RedditSession::getMyReddits()
{

    QNetworkRequest getMine(QUrl("http://www.reddit.com/reddits/mine/.json"));
    QNetworkReply* reply2 = m_net->get(getMine);

    connect(reply2, SIGNAL(finished()), this, SLOT(getMyRedditsFinished()));


}

void RedditSession::logout()
{
    cookieJar()->clear();
    saveCookies();
    m_myreddits.clear();
    emit loggedOut();

}

RCookieJar * RedditSession::cookieJar()
{
    RCookieJar* cj = qobject_cast<RCookieJar*>(m_net->cookieJar());
    return cj;
}

void RedditSession::saveCookies()
{

    QSettings setts;
    setts.setValue("Auth/Cookies", cookieJar()->store());

}


