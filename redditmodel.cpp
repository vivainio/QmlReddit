#include "redditmodel.h"

#include "redditsession.h"
#include <QDeclarativeContext>

#include <QStandardItemModel>
#include <QDebug>
#include <QDesktopServices>

#include "roleitemmodel.h"
#include "platutil.h"
#include <QProcess>

#include <QDesktopServices>

RedditModel::RedditModel(QObject *parent) :
    QObject(parent)
{
    m_enableRestricted = false;
    m_ses = new RedditSession;
    connect(m_ses, SIGNAL(linksAvailable()), this, SLOT(doPopulateLinks()));

    connect(m_ses, SIGNAL(commentsAvailable()), this, SLOT(doPopulateComments()));

    connect(m_ses, SIGNAL(commentsJsonAvailable(QString)), this,
            SIGNAL(commentsJsonAvailable(QString)));

    connect(m_ses, SIGNAL(categoriesUpdated()), this, SLOT(refreshCategories()));

    QHash<int, QByteArray> roleNames;
    roleNames[RedditEntry::UrlRole] =  "url";
    roleNames[RedditEntry::DescRole] = "desc";
    roleNames[RedditEntry::ScoreRole] = "score";
    roleNames[RedditEntry::PermalaLinkRole] = "permalink";
    roleNames[RedditEntry::ThumbnailRole] = "thumbnail";
    roleNames[RedditEntry::CommentsRole] = "comments";
    roleNames[RedditEntry::NameRole] = "name";


    m_linksmodel = new RoleItemModel(roleNames);

    roleNames.clear();
    roleNames[Qt::UserRole] = "commentText";

    //m_commentsmodel = new RoleItemModel(roleNames);
    //m_linksmodel->setRoleNames(roleNames);

    roleNames.clear();

    roleNames[Qt::UserRole] = "catName";

    m_cats = new RoleItemModel(roleNames);


    refreshCategories();

}


void RedditModel::setup(QDeclarativeContext *ctx)
{    
    ctx->setContextProperty("mdlReddit", this);
    ctx->setContextProperty("mdlLinks", m_linksmodel);
    //ctx->setContextProperty("mdlComments", m_commentsmodel);
    ctx->setContextProperty("mdlCategories", m_cats);
    ctx->setContextProperty("mdlRedditSession", m_ses);

    start("");

}

void RedditModel::start(const QString &cat)
{
    m_ses->start(cat);
}

void RedditModel::doPopulateLinks()
{
    m_linksmodel->clear();
    foreach (const RedditEntry& e, m_ses->getEntries()) {

        if (e.desc.isEmpty()) {
            continue;
            // todo debug properly
        }
        QStandardItem* it = new QStandardItem();
        it->setData(e.desc, RedditEntry::DescRole);
        it->setData(e.score, RedditEntry::ScoreRole);
        it->setData(e.permalink, RedditEntry::PermalaLinkRole);
        it->setData(e.url, RedditEntry::UrlRole);
        it->setData(e.thumbnail, RedditEntry::ThumbnailRole);
        it->setData(e.comments, RedditEntry::CommentsRole);

        m_linksmodel->appendRow(it);

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

#if 0
QVariantMap RedditModel::getComment(int index)
{
    QVariantMap res = RoleItemModel::getModelData(m_commentsmodel, index);
    //qDebug() << "getc" << res;
    return res;
}
#endif

QVariantMap RedditModel::getLink(int index)
{
    QVariantMap res = RoleItemModel::getModelData(m_linksmodel, index);
    //qDebug() << "getlink" << res;
    return res;
}

void RedditModel::refreshCategories()
{
    QStringList cats = m_ses->getCategories();
    if (m_enableRestricted) {
        // adult content (to ensure commercial success for the app ;-)
        cats << "nsfw" << "gonewild" << "adult" << "sex";
    }

    cats.removeDuplicates();

    m_cats->clear();
    foreach (QString c, cats) {
        QStandardItem* it = new QStandardItem();
        it->setData(c, Qt::UserRole);
        m_cats->appendRow(it);
    }
}

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


