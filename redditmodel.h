#ifndef REDDITMODEL_H
#define REDDITMODEL_H

#include <QObject>

class QDeclarativeContext;

class RedditSession;
class QStandardItemModel;

class RoleItemModel;

class QuickModel;



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
    void start(const QString& cat, const QString& queryargs);
    void fetchComments(const QString& permalink);

    //QVariantMap getComment(int index);
    void editConfig();
    void browser(const QString& url);

    QString lastName();

signals:

    void commentsJsonAvailable(const QString& json);
    void categoriesAvailable();

public slots:

    QVariantMap getLink(int index);
    //void refreshCategories();
    void enableRestricted(bool val);
    QVariantList categories();
private slots:
    void doPopulateLinks();


    void doPopulateComments();
private:
    RedditSession* m_ses;
    QuickModel* m_linksmodel;
    //RoleItemModel* m_linksmodel;
    //RoleItemModel* m_commentsmodel;
    //QuickModel* m_cats;

    //RoleItemModel* m_cats;

    bool m_enableRestricted;
};

#endif // REDDITMODEL_H
