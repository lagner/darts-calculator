#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml/qqml.h>
#include <QAbstractItemModel>
#include <QDebug>
#include "application.h"


int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    app.setApplicationName(Application::APP_NAME);
    app.setApplicationVersion(Application::APP_VERSION);
    app.setOrganizationName(Application::ORG_NAME);
    app.setOrganizationDomain(Application::ORG_DOMAIN);

    QQmlApplicationEngine engine;

    Application::registerSubClasses();

    qmlRegisterSingletonType<Application>
            (Application::ORG_DOMAIN, 1, 0, "App",
            &Application::instance);

    try {
        engine.load(QUrl("qrc:///qml/main.qml"));
        return app.exec();

    } catch (const std::exception& ex) {
        qDebug() << "unexpected exception: " << ex.what();
    } catch (...) {
        qDebug() << "FATAL error";
    }
    return 1;
}
