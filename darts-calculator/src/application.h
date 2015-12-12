#ifndef APPLICATION_H
#define APPLICATION_H

#include <QNetworkReply>

class QQmlEngine;
class QJSEngine;

class Application : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString version READ version CONSTANT)

public:
    enum class PlatformType {
        APP_LINUX,
        APP_ANDROID,
        APP_IOS,
        APP_WINRT,
        APP_OTHER
    };
    Q_ENUMS(PlatformType)

public:
    static Application* instance();
    static QObject* instance(QQmlEngine*, QJSEngine*);

    static const char* const APP_NAME;
    static const char* const APP_VERSION;
    static const char* const ORG_DOMAIN;
    static const char* const ORG_NAME;

    static void registerSubClasses();

    static PlatformType platform();

public:
    QString version() const;

    QNetworkAccessManager& networkManager() const;

signals:

public slots:

private slots:

private:
    Application(QQmlEngine*, QJSEngine*);

    QQmlEngine* 	qEng_ = nullptr;
    QJSEngine* 		jEng_ = nullptr;
};

#endif // APPLICATION_H
