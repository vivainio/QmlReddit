#include "redditmodel.h"

#include "redditsession.h"
#include <QDeclarativeContext>

#include <QStandardItemModel>
#include <QDebug>
#include <QDesktopServices>

#include "platutil.h"
#include <QProcess>

#include <QDesktopServices>
#include "quickmodel.h"

RedditModel::RedditModel(QObject *parent) :
    QObject(parent)
{
    m_enableRestricted = false;
    m_ses = new RedditSession;
    connect(m_ses, SIGNAL(linksAvailable()), this, SLOT(doPopulateLinks()));

    connect(m_ses, SIGNAL(commentsAvailable()), this, SLOT(doPopulateComments()));

    connect(m_ses, SIGNAL(commentsJsonAvailable(QString)), this,
            SIGNAL(commentsJsonAvailable(QString)));

    //connect(m_ses, SIGNAL(categoriesUpdated()), this, SLOT(refreshCategories()));
    connect(m_ses, SIGNAL(categoriesUpdated()), this, SIGNAL(categoriesAvailable()));

    QHash<int, QByteArray> roleNames;
    /*
    roleNames[RedditEntry::UrlRole] =  "url";
    roleNames[RedditEntry::DescRole] = "desc";
    roleNames[RedditEntry::ScoreRole] = "score";
    roleNames[RedditEntry::PermalaLinkRole] = "permalink";
    roleNames[RedditEntry::ThumbnailRole] = "thumbnail";
    roleNames[RedditEntry::CommentsRole] = "comments";
    roleNames[RedditEntry::NameRole] = "name";
    roleNames[RedditEntry::VoteRole] = "vote";
    roleNames[RedditEntry::AuthorRole] = "author";
    roleNames[RedditEntry::TimeRole] = "time";
    roleNames[RedditEntry::SubredditRole] = "subreddit";
    */
    m_linksmodel = new QuickModel(); //RoleItemModel(roleNames);
    QStringList fields;
    fields << "url" << "desc" << "score" << "permalink" << "thumbnail" << "comments" << "name" << "vote"  << "author" << "time" << "subreddit";

    m_linksmodel->setFields(fields);


    //roleNames[Qt::UserRole] = "catName";

    //m_cats = new QuickModel;
    //m_cats->setFields(QStringList() << "catName");

    //RoleItemModel(roleNames);

    //refreshCategories();
}


void RedditModel::setup(QDeclarativeContext *ctx)
{    
    ctx->setContextProperty("mdlReddit", this);
    ctx->setContextProperty("mdlLinks", m_linksmodel);
    //ctx->setContextProperty("mdlComments", m_commentsmodel);
    //ctx->setContextProperty("mdlCategories", m_cats);
    ctx->setContextProperty("mdlRedditSession", m_ses);

    //start("", 0);

}

void RedditModel::start(const QString &cat, const QString& queryargs)
{
    m_ses->start(cat, queryargs);
}

void RedditModel::doPopulateLinks()
{
    m_linksmodel->clear();
    foreach (const RedditEntry& e, m_ses->getEntries()) {

        if (e.desc.isEmpty()) {
            continue;
            // todo debug properly
        }
        QVariantMap m;
        m["desc"] = e.desc;
        m["score"] = e.score;
        m["permalink"] = e.permalink;
        m["url"] = e.url;
        m["thumbnail"] = e.thumbnail;
        m["comments"] = e.comments;
        m["name"]  = e.name;
        m["vote"] = e.vote;
        m["author"] = e.author;
        m["time"] = e.time;
        m["subreddit"] = e.subreddit;

        m_linksmodel->append(m);

        //fields << "url" << "desc" << "score" << "permalink" << "thumbnail" << "comments" << "name" << "vote"  << "author" << "time" << "subreddit";
        /*
        QStandardItem* it = new QStandardItem();
        it->setData(e.desc, RedditEntry::DescRole);
        it->setData(e.score, RedditEntry::ScoreRole);
        it->setData(e.permalink, RedditEntry::PermalaLinkRole);
        it->setData(e.url, RedditEntry::UrlRole);
        it->setData(e.thumbnail, RedditEntry::ThumbnailRole);
        it->setData(e.comments, RedditEntry::CommentsRole);
        it->setData(e.name, RedditEntry::NameRole);
        it->setData(e.vote, RedditEntry::VoteRole);
        it->setData(e.author, RedditEntry::AuthorRole);
        it->setData(e.time, RedditEntry::TimeRole);
        it->setData(e.subreddit, RedditEntry::SubredditRole);

        m_linksmodel->appendRow(it);
        */


    }

    //qDebug() << "populating";

}

void RedditModel::doPopulateComments()
{
#if 0
    m_commentsmodel->clear();
    foreach (const QString& s, m_ses->m_comments) {
        QStandardItem* it = new QStandardItem;
        it->setData(s, Qt::UserRole);
        m_commentsmodel->appendRow(it);
    }
#endif

}

void RedditModel::fetchComments(const QString &permalink)
{
    m_ses->fetchComments(permalink);

}


QVariantMap RedditModel::getLink(int index)
{
    QVariantMap res = m_linksmodel->get(index);
            //RoleItemModel::getModelData(m_linksmodel, index);
    qDebug() << "getlink" << res;
    return res;
}


/*
void RedditModel::refreshCategories()
{
    QStringList cats = m_ses->getCategories();
    if (m_enableRestricted) {
        // adult content (to ensure commercial success for the app ;-)
        cats << "nsfw" << "gonewild" << "adult" << "sex" << "PrettyGirls" <<
                "gonewildstories";
    }

    cats.removeDuplicates();

    //m_cats->clear();
    foreach (QString c, cats) {
        QVariantMap m;
        m["catName"] = c;
        //QStandardItem* it = new QStandardItem();
        //it->setData(c, Qt::UserRole);
        //m_cats->append(m);
        //m_cats->appendRow(it);
    }
}
*/

void RedditModel::editConfig()
{
    QString cf = PlatUtil::configFile();

#ifdef Q_WS_MAEMO_5

    QString cmd = QString("/usr/bin/osso-xterm -e \"vi %1\"").arg(cf);
#else
    QString cmd = QString("/usr/bin/gedit \"vi %1\"").arg(cf);
#endif

    QProcess* p = new QProcess(this);
    p->start(cmd);
    p->waitForFinished();
    delete p;

}

void RedditModel::browser(const QString &url)
{
    //qDebug() << "browser " << url;
    if (url.isEmpty()) {
        QDesktopServices::openUrl(QUrl("http://reddit.com"));
    } else {
        QDesktopServices::openUrl(url);
    }

}

void RedditModel::enableRestricted(bool val)
{
    m_enableRestricted = val;
}

QString RedditModel::lastName()
{
    const QVector<RedditEntry>& ents  = m_ses->getEntries();
    if (ents.empty()) {
        return "";
    }
    return ents.last().name;
}

QVariantList RedditModel::categories()
{
    QStringList cats = m_ses->getCategories();

    QMap<QString, QString> strMap;
    foreach ( QString str, cats ) {
      strMap.insert( str.toLower(), str );
    }
    cats = strMap.values();

    if (m_enableRestricted) {
        // adult content (to ensure commercial success for the app ;-)
        cats << "nsfw" << "gonewild" << "adult" << "sex" << "PrettyGirls" <<
                "gonewildstories";
    }

    cats.removeDuplicates();

    QVariantList r;
    foreach (QString s, cats) {
        if (s.length() == 0) {
            continue;


        }
        r.append(s);
    }

    return r;


}


