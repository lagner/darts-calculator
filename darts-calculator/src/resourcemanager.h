#ifndef RESOURCEMANAGER_H
#define RESOURCEMANAGER_H

#include <QObject>
#include <QUrl>

class QQmlEngine;
class QJSEngine;

enum class ScreenDensity {
    NODPI	= 0,
    LDPI	= 120,
    MDPI	= 160,
    TVDPI	= 213,
    HDPI	= 240,
    XHDPI	= 320,
    XXHDPI	= 480,
};

enum class ScreenSize {
    SMALL,
    NORMALL,
    LARGE,
    XLARGE
};

enum class DeviceType {
    PHONE,
    TABLET
};

class ResourceManager : public QObject {
    Q_OBJECT
public:
    static ResourceManager* instance();
    static QObject* instance(QQmlEngine*, QJSEngine*);

    Q_INVOKABLE float dp(int) const;

    Q_INVOKABLE QUrl image(const QString& name) const;

    Q_INVOKABLE bool isTablet() const;

signals:

public slots:

private:
    ResourceManager(QQmlEngine*, QJSEngine*);

    float scaleFactor;
    ScreenDensity density;
    DeviceType devType;
};

#endif // RESOURCEMANAGER_H
