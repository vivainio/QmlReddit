#ifndef REDDITMODEL_H
#define REDDITMODEL_H

#include <QObject>

class QDeclarativeContext;

class RedditSession;
class QStandardItemModel;

class RoleItemModel;




#include <QStandardItemModel>
#include <QVariantMap>


// QStandardItemModel declares setRoleNames as protected,
// work around that insanity w/ this class


class RedditModel : public QObject
{
    Q_OBJECT
public:
    explicit RedditModel(QObject *parent = 0);
    void setup(QDeclarativeContext* ctx);

public Q_SLOTS:
    void start(const QString& cat);
    void fetchComments(const QString& permalink);

    QVariantMap getComment(int index);

signals:

public slots:

    QVariantMap getLink(int index);
private slots:
    void doPopulateLinks();


    void doPopulateComments();
private:
    RedditSession* m_ses;
    RoleItemModel* m_linksmodel;
    RoleItemModel* m_commentsmodel;    
    RoleItemModel* m_cats;
};

#endif // REDDITMODEL_H
