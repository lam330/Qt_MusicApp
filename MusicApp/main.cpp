#include <QGuiApplication>
#include <QtQml>
#include <QApplication>
//#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "dynamicentrymodel.h"
#include "imagemodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);


    // register the type DataEntryModel & ImageModel
    qmlRegisterType<DynamicEntryModel>("org.example", 1, 0, "DynamicEntryModel");
    qmlRegisterType<ImageModel>("org.example", 1, 0, "ImageModel");

    QQmlApplicationEngine engine;
    //cppSignal => for slideShow
    ImageModel sender;
    engine.rootContext()->setContextProperty("CppSignalSender", &sender);

    DynamicEntryModel qmlCaller;
    engine.rootContext()->setContextProperty("QmlCaller", &qmlCaller);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    //for search    
    if (engine.rootObjects().isEmpty()){
       return -1;
    }else{
        //Should make sure this is SET
        qmlCaller.setQmlRootObject(engine.rootObjects().first());
    }

    return app.exec();
}
