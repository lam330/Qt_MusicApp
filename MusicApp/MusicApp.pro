QT += quick

CONFIG += c++11
QT += qml quick
QT += widgets

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        dynamicentrymodel.cpp \
        imagemodel.cpp \
        main.cpp

RESOURCES += qml.qrc \
    Images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    dynamicentrymodel.h \
    imagemodel.h

DISTFILES += \
    fonts/OpenSans-Bold.ttf \
    fonts/OpenSans-BoldItalic.ttf \
    fonts/OpenSans-ExtraBold.ttf \
    fonts/OpenSans-ExtraBoldItalic.ttf \
    fonts/OpenSans-Italic.ttf \
    fonts/OpenSans-Light.ttf \
    fonts/OpenSans-LightItalic.ttf \
    fonts/OpenSans-Regular.ttf \
    fonts/OpenSans-Semibold.ttf \
    fonts/OpenSans-SemiboldItalic.ttf \
    gfx/background.png \
    gfx/bar.png \
    gfx/cover.png \
    gfx/cover_frame.png \
    gfx/cover_overlay.png \
    gfx/slider_background.png \
    gfx/slider_knob.png \
    gfx/slider_value_left.png \
    gfx/slider_value_right.png \
    icons/forward.png \
    icons/pause.png \
    icons/play.png \
    icons/rewind.png \
    icons/share.png \
    music/Counting-Stars-Houston.mp3 \
    music/Deep-Sea-Binz-Trixidy-Triple-D-3D-GVR-SpaceSpeakers.mp3 \
    music/Nothing-gona-change-my-love-for-you-Georgre-Benson.mp3 \
    music/Phi-Hanh-Gia-Renja-Slow-T-Lil-Wuyn-Kain-Sugar-Cane.mp3 \
    music/Yeu-5-Rhymastic.mp3
