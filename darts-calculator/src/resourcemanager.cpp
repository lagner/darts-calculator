#include <QQmlEngine>
#include <QJSEngine>
#include <QGuiApplication>
#include <QScreen>
#include <QQmlContext>
#include <QUrl>
#include <QDebug>
#include "resourcemanager.h"

namespace {
ResourceManager* instance_ = nullptr;

const int PHONE_MAX_WIDTH = 68;

}

ResourceManager* ResourceManager::instance() {
    Q_ASSERT(instance_);
    return instance_;
}

QObject* ResourceManager::instance(QQmlEngine* qEng, QJSEngine* jEng) {
    if (!instance_) {
        instance_ = new ResourceManager(qEng, jEng);
    }
    return instance_;
}

float getScaleFactor(ScreenDensity bucket) {
    switch (bucket) {
    case ScreenDensity::LDPI: 	return 0.75;
    case ScreenDensity::MDPI: 	return 1;
    case ScreenDensity::TVDPI: 	return 1.33;
    case ScreenDensity::HDPI: 	return 1.5;
    case ScreenDensity::XHDPI:	return 2;
    case ScreenDensity::XXHDPI: return 3;
    default:
        Q_ASSERT(false);
        return 1;
    }
}

QString getResFolder(ScreenDensity bucket)
{
    switch (bucket) {
    case ScreenDensity::LDPI: 	return QStringLiteral("ldpi");
    case ScreenDensity::MDPI: 	return QStringLiteral("mdpi");
    case ScreenDensity::TVDPI: 	return QStringLiteral("mdpi");
    case ScreenDensity::HDPI: 	return QStringLiteral("hdpi");
    case ScreenDensity::XHDPI: 	return QStringLiteral("xhdpi");
    case ScreenDensity::XXHDPI: return QStringLiteral("xxhdpi");
    default:
        Q_ASSERT(false);
        return QStringLiteral("mdpi");
    }
}

ResourceManager::ResourceManager(QQmlEngine* qEng, QJSEngine* jEng) :
    scaleFactor(1.0), density(ScreenDensity::MDPI), devType(DeviceType::PHONE) {

    Q_UNUSED(qEng);
    Q_UNUSED(jEng);

    QGuiApplication* app =
            dynamic_cast<QGuiApplication*>(QGuiApplication::instance());
    Q_ASSERT(app);

    QList<QScreen*> screens = app->screens();
    if (!screens.empty()) {
        QScreen* screen = screens.first();
        Q_ASSERT(screen);
        qreal dpi = screen->physicalDotsPerInch();

        /*
         *      --DPI--
            ldpi    100 140
            mdpi    141 199
            hdpi    200 319
            xhdpi   320 340
        */

        if (dpi < 140) {
            density = ScreenDensity::LDPI;
        } else if (dpi < 199) {
            density = ScreenDensity::MDPI;
        } else if (dpi < 319) {
            density = ScreenDensity::HDPI;
        } else if (dpi < 340) {
            density = ScreenDensity::XHDPI;
        } else {
            density = ScreenDensity::XXHDPI;
        }

        // get screen size in millimeters
        auto size = screen->physicalSize();
        if (size.width() > PHONE_MAX_WIDTH) {
            devType = DeviceType::TABLET;
        }
    }

    scaleFactor = getScaleFactor(density);
}

float ResourceManager::dp(int i) const {
    return i * scaleFactor;
}

QUrl ResourceManager::image(const QString &name) const
{
    // TODO: check if image exist

    static const QString path = QStringLiteral("qrc:///res/%1/%2");

    return path.arg(getResFolder(density), name);
}

bool ResourceManager::isTablet() const {
    return devType == DeviceType::TABLET;
}
