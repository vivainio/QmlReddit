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
#include "platutil.h"

//#define RSTEST

RedditSession::RedditSession(QObject *parent) :
    QObject(parent)
{
    m_net = new QNetworkAccessManager(this);
    m_eng = new QScriptEngine;

}

void RedditSession::start(const QString& cat)
{

    QString url;
    if (cat.length() == 0) {
        url = "http://www.reddit.com/.json";
    } else {
        url = QString("http://www.reddit.com/r/%1/.json").arg(cat);
    }

    QNetworkRequest req(url);

    QNetworkReply* reply = m_net->get(req);
    connect(reply, SIGNAL(finished()), this, SLOT(linksFetched()));

}

QScriptValue RedditSession::parseJson(QString msg)
{
    msg.prepend("(");
    msg.append(")");
    QScriptValue sc = m_eng->evaluate(msg);
    if (m_eng->hasUncaughtException()) {
      QStringList bt = m_eng->uncaughtExceptionBacktrace();
      //qDebug() << bt.join("\n");
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


        int score = v.property("score").toInt32();
        //qDebug() << v.toString() << title << " U " << url << " TN " << tnail;
        RedditEntry e;
        e.desc = title;
        e.url = url;
        e.permalink = v.property("permalink").toString();
        e.thumbnail = tnail;
        e.score = score;
        e.comments = v.property("num_comments").toString();
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
    url.append(".xml");
    //qDebug() << "fetch " << url;
    QNetworkRequest req(url);
    QNetworkReply* reply = m_net->get(req);
    connect(reply, SIGNAL(finished()), this, SLOT(commentsFetched()));

}

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
        //qDebug() << "end" << localName;
        QString trans = m_current.replace("&quot;", "\"").replace("&amp;", "&").
                replace("&gt;",">").replace("&lt;", "<");
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

QStringList RedditSession::getCategories()
{
    //return QStringList() << "programming" << "pics";

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

    QStringList cats;
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

    return cats;

}

