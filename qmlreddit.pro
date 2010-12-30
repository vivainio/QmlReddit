# Add more folders to ship with the application, here
folder_01.source = qml/qmlreddit
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve Qml modules in Creator's code model
QML_IMPORT_PATH =

# Avoid auto screen rotation
#DEFINES += ORIENTATIONLOCK

# Needs to be defined for Symbian
DEFINES += NETWORKACCESS

symbian:TARGET.UID3 = 0xE7B91329

# Define QMLJSDEBUGGER to enable basic debugging (setting breakpoints etc)
# Define QMLOBSERVER for advanced features (requires experimental QmlInspector plugin!)
DEFINES += QMLJSDEBUGGER
# DEFINES += QMLOBSERVER

QT += xml network script
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    redditsession.cpp \
    redditmodel.cpp \
    roleitemmodel.cpp \
    platutil.cpp \
    rcookiejar.cpp \
    lifecycle.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

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
