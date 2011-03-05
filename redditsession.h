#ifndef REDDITSESSION_H
#define REDDITSESSION_H

#include <QObject>

#include <QVector>
#include <QStringList>
#include <QVariantMap>

class QNetworkAccessManager;
class QNetworkReply;
class QNetworkRequest;

class QScriptEngine;
class QScriptValue;
class QSettings;
class RCookieJar;

struct RedditEntry {

    enum RedditRoles {
        UrlRole = Qt::UserRole + 1,
        DescRole,
        ScoreRole,
        CommentsRole,
        PermalaLinkRole,
        ThumbnailRole,
        NameRole,
        VoteRole,
        AuthorRole,
        TimeRole,
        SubredditRole
    };

    QString url;
    QString desc;
    QString permalink;
    QString thumbnail;
    int score;
    QString comments;
    QString name;
    QString author;
    uint time;
    QString subreddit;
    int vote; // 1,0,-1
};

typedef QVector<RedditEntry> REList;


class RedditSession : public QObject
{
Q_OBJECT

public:
    explicit RedditSession(QObject *parent = 0);

public slots:

    void start(const QString& url, const QString& queryargs);
    void fetchComments(const QString& commentaddr);

    const QVector<RedditEntry>& getEntries();
    const QStringList& comments() { return m_comments; }

    QStringList getCategories();
    static void expandHtmlEntities(QString& text);

    void login(const QString& user, const QString& passwd);

    void logout();

    void setModhash(const QString& modhash);
    QVariantMap cookies();
    void vote(const QString& thing, int votedir);
    void getMyReddits();
    void saveCookies();
    void setLinkSelection(const QString& selection);
    void setIncognito(bool val);
    void setSwRendering(bool val);

signals:
    void linksAvailable();
    void commentsAvailable();   
    void commentsJsonAvailable(const QString& comments);
    void loginResponse(const QString& response);
    void categoriesUpdated();
    void loggedOut();

private slots:
      void linksFetched();
      void commentsFetched();
      void loginFinished();
      void getMyRedditsFinished();



public:
      QNetworkAccessManager* m_net;

      QStringList m_comments;

private:
    QScriptValue parseJson(QString msg);
    RCookieJar* cookieJar();

    void prepareRequest(QNetworkRequest& req);


    QVector<RedditEntry> m_ents;
    QScriptEngine* m_eng;
    QStringList m_myreddits;
    QString m_modhash;
    QString m_linkSelection;
    bool m_incognito;

};

#endif // REDDITSESSION_H
