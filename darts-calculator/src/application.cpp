#include <QtQml/qqml.h>
#include <QQmlEngine>
#include <QJSEngine>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QThreadPool>
#include <QThread>
#include <QUrl>
#include "application.h"
#include "resourcemanager.h"

const char* const Application::APP_NAME		= "DartsCounter";
const char* const Application::APP_VERSION	= "1.0";
const char* const Application::ORG_DOMAIN 	= "ru.lagner";
const char* const Application::ORG_NAME		= "LSNS";

namespace {

Application* instance_ = nullptr;

}

Application* Application::instance() {
    Q_ASSERT(instance_);
    return instance_;
}

QObject* Application::instance(QQmlEngine* qeng, QJSEngine* jeng) {
    if (!instance_) {
        instance_ = new Application(qeng, jeng);
    }
    return instance_;
}

void Application::registerSubClasses()
{
    // @uri ru.lagner
    qmlRegisterSingletonType<ResourceManager>
            (Application::ORG_DOMAIN, 1, 0, "R",
             &ResourceManager::instance);
}

Application::PlatformType Application::platform()
{
#ifdef Q_OS_ANDROID
    return PlatformType::APP_ANDROID;
#endif
#ifdef Q_OS_LINUX
    return PlatformType::APP_LINUX;
#endif
#ifdef Q_OS_IOS
    return PlatformType::APP_IOS;
#endif
#if defined(Q_OS_WINPHONE) || defined(Q_OS_WINRT)
    return PlatformType::APP_WINRT;
#endif
    return PlatformType::APP_OTHER;
}


// ------------------------------------------------------------------------------------- Non static


Application::Application(QQmlEngine* qeng, QJSEngine* jeng) :
    qEng_(qeng), jEng_(jeng) {
}

QString Application::version() const
{
    return QString::fromUtf8("ru.lagner.dartscounter 1.0");
}

QNetworkAccessManager& Application::networkManager() const
{
    QNetworkAccessManager* nm = qEng_->networkAccessManager();
    if (!nm)
        throw std::runtime_error("networkAccessManager wasn't initialized");

    return *nm;
}
