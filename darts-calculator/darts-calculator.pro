TEMPLATE = app

QT += qml quick multimedia

CONFIG += c++11
RESOURCES += qml.qrc res.qrc

# Default rules for deployment.
include(deploy.pri)

DISTFILES += \
    $PWD/../android/AndroidManifest.xml \
    $PWD/../android/gradle/wrapper/gradle-wrapper.jar \
    $PWD/../android/gradlew \
    $PWD/../android/res/values/libs.xml \
    $PWD/../android/build.gradle \
    $PWD/../android/gradle/wrapper/gradle-wrapper.properties \
    $PWD/../android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/../android

HEADERS += \
    src/application.h \
    src/resourcemanager.h

SOURCES += \
    src/main.cpp \
    src/application.cpp \
    src/resourcemanager.cpp

