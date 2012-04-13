# TODO - remove hardcoded config specific defines from here asap

# should use for harmattan as well...

DEFINES += IS_MEEGO_TABLET

# Add more folders to ship with the application, here
folder_01.source = qml/qmlreddit
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve Qml modules in Creator's code model
QML_IMPORT_PATH =

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

#DEFINES += IS_HARMATTAN

# Needs to be defined for Symbian

symbian {
    TARGET.CAPABILITY += NetworkServices
    # just in case..
    DEFINES -= IS_MEEGO_TABLET
    ICON=qmlreddit.svg
}

symbian {
    TARGET.UID3 = 0x200476ED
    #TARGET.UID3 = 0xE00476ED

    vendorinfo = "%{\"Ville M. Vainio\"}" ":\"Ville M. Vainio\""

    my_deployment.pkg_prerules += vendorinfo

    DEPLOYMENT += my_deployment

    DEPLOYMENT.display_name += QmlReddit
}

maemo5 {
    QT+=dbus
    DEFINES -= IS_MEEGO_TABLET
}

# Define QMLJSDEBUGGER to enable basic debugging (setting breakpoints etc)
# Define QMLOBSERVER for advanced features (requires experimental QmlInspector plugin!)
# DEFINES += QMLJSDEBUGGER
# DEFINES += QMLOBSERVER

QT += xml network script

contains(DEFINES, IS_MEEGO_TABLET) {
  QT += opengl
  DEFINES += HAVE_GLWIDGET
}

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    redditsession.cpp \
    redditmodel.cpp \
    platutil.cpp \
    rcookiejar.cpp \
    lifecycle.cpp \
    quickmodel.cpp




# /opt/PACKAGENAME should do no harm on maemo either...

PACKAGENAME = info.vivainio.qmlreddit

# Please do not modify the following two lines. Required for deployment.
QMLJSDEBUGGER_PATH=

#contains(DEFINES, IS_MEEGO_TABLET) {
#    FORCE_SVG_ICON = qmlreddit.svg
#}

# note that I use a forked version 
include(qmlapplicationviewer/myqmlapplicationviewer.pri)
qtcAddDeployment()

include (installicons.pri)

OTHER_FILES += \
    debian/compat \
    debian/control \
    debian/copyright \
    debian/README \
    debian/rules \
    info.vivainio.qmlreddit.yaml \
    debian/changelog \
    android/AndroidManifest.xml \
    android/res/drawable/icon.png \
    android/res/drawable/logo.png \
    android/res/drawable-hdpi/icon.png \
    android/res/drawable-ldpi/icon.png \
    android/res/drawable-mdpi/icon.png \
    android/res/layout/splash.xml \
    android/res/values/libs.xml \
    android/res/values/strings.xml \
    android/res/values-de/strings.xml \
    android/res/values-el/strings.xml \
    android/res/values-es/strings.xml \
    android/res/values-et/strings.xml \
    android/res/values-fa/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/values-nb/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/values-pl/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-ru/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/origo/QtActivity.java \
    android/src/org/kde/necessitas/origo/QtApplication.java

HEADERS += \
    redditsession.h \
    redditmodel.h \
    platutil.h \
    rcookiejar.h \
    lifecycle.h \
    quickmodel.h


