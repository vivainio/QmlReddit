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

public Q_INVOKABLE:
    void start(const QString& cat);

signals:

public slots:

private slots:
    void doPopulateLinks();


private:
    RedditSession* m_ses;
    QStandardItemModel* m_linksmodel;
};

#endif // REDDITMODEL_H
