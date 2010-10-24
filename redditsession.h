#ifndef REDDITSESSION_H
#define REDDITSESSION_H

#include <QObject>

#include <QVector>
#include <QStringList>

class QNetworkAccessManager;
class QNetworkReply;

class QScriptEngine;
class QScriptValue;

struct RedditEntry {

    enum RedditRoles {
        UrlRole = Qt::UserRole + 1,
        DescRole,
        ScoreRole,
        CommentsRole,
        PermalaLinkRole
    };

    QString url;
    QString desc;
    QString permalink;
    QString thumbnail;
    int score;
    QString comments;
};

typedef QVector<RedditEntry> REList;


class RedditSession : public QObject
{
Q_OBJECT

public:
    explicit RedditSession(QObject *parent = 0);

public Q_INVOKABLE:

    void start(const QString& url);
    void fetchComments(const QString& commentaddr);

    const QVector<RedditEntry>& getEntries();
    const QStringList& comments() { return m_comments; }

    QStringList getCategories();


signals:
    void linksAvailable();
    void commentsAvailable();

public slots:

private slots:
      void linksFetched();
      void commentsFetched();

public:
      QNetworkAccessManager* m_net;


private:
    QScriptValue parseJson(QString msg);

    QVector<RedditEntry> m_ents;
    QStringList m_comments;


    QScriptEngine* m_eng;

};

#endif // REDDITSESSION_H
