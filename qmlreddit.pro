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

# Needs to be defined for Symbian

symbian {
    TARGET.CAPABILITY += NetworkServices
    # just in case..
    DEFINES -= IS_MEEGO_TABLET
}

symbian:TARGET.UID3 = 0xE7B91329

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
    roleitemmodel.cpp \
    platutil.cpp \
    rcookiejar.cpp \
    lifecycle.cpp




# /opt/PACKAGENAME should do no harm on maemo either...

PACKAGENAME = info.vivainio.qmlreddit

# Please do not modify the following two lines. Required for deployment.
QMLJSDEBUGGER_PATH=

contains(DEFINES, IS_MEEGO_TABLET) {
    FORCE_SVG_ICON = qmlreddit.svg
}

# note that I use a forked version 
include(qmlapplicationviewer/myqmlapplicationviewer.pri)
qtcAddDeployment()

include (installicons.pri)

OTHER_FILES += \
    debian/compat \
    debian/control \
    debian/copyright \
    debian/README \
    debian/rules

HEADERS += \
    redditsession.h \
    redditmodel.h \
    roleitemmodel.h \
    platutil.h \
    rcookiejar.h \
    lifecycle.h
