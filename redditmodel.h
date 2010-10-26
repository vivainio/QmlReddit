#ifndef REDDITMODEL_H
#define REDDITMODEL_H

#include <QObject>

class QDeclarativeContext;

class RedditSession;
class QStandardItemModel;
#include <QStandardItemModel>


// QStandardItemModel declares setRoleNames as protected,
// work around that insanity w/ this class

class SaneItemModel : public QStandardItemModel
{
public:
    SaneItemModel(const QHash<int, QByteArray> &roleNames);

};

class RedditModel : public QObject
{
    Q_OBJECT
public:
    explicit RedditModel(QObject *parent = 0);
    void setup(QDeclarativeContext* ctx);

public Q_SLOTS:
    void start(const QString& cat);
    void fetchComments(const QString& permalink);


signals:

public slots:

private slots:
    void doPopulateLinks();


    void doPopulateComments();
private:
    RedditSession* m_ses;
    SaneItemModel* m_linksmodel;
    SaneItemModel* m_commentsmodel;

};

#endif // REDDITMODEL_H
