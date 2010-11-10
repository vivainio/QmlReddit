#ifndef PLATUTIL_H
#define PLATUTIL_H

class QWidget;
class QString;

class PlatUtil
{
public:
    PlatUtil();
    //static void configureWindow(QWidget* wdg);
    //static void toggleBusy(QWidget* wdg, bool busy);
    static QString configFile();
};

#endif // PLATUTIL_H
