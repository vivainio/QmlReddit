#include "redditmodel.h"

#include "redditsession.h"
#include <QDeclarativeContext>

#include <QStandardItemModel>
#include <QDebug>

SaneItemModel::SaneItemModel(const QHash<int, QByteArray> &roleNames)
{
    setRoleNames(roleNames);
}

RedditModel::RedditModel(QObject *parent) :
    QObject(parent)
{
    m_ses = new RedditSession;
    connect(m_ses, SIGNAL(linksAvailable()), this, SLOT(doPopulateLinks()));

    QHash<int, QByteArray> roleNames;
    roleNames[RedditEntry::UrlRole] =  "url";
    roleNames[RedditEntry::DescRole] = "desc";
    roleNames[RedditEntry::ScoreRole] = "score";
    roleNames[RedditEntry::PermalaLinkRole] = "permalink";
    m_linksmodel = new SaneItemModel(roleNames);
    //m_linksmodel->setRoleNames(roleNames);


}

void RedditModel::setup(QDeclarativeContext *ctx)
{
    ctx->setContextProperty("mdlReddit", this);
    ctx->setContextProperty("mdlLinks", m_linksmodel);
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
        QStandardItem* it = new QStandardItem();
        it->setData(e.desc, RedditEntry::DescRole);
        it->setData(e.score, RedditEntry::ScoreRole);
        it->setData(e.permalink, RedditEntry::PermalaLinkRole);

        m_linksmodel->appendRow(it);

    }

    qDebug() << "populating";

}
