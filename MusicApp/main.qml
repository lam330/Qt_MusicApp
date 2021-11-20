import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtMultimedia 5.14
import QtQuick.Dialogs 1.3

// our module
import org.example 1.0

ApplicationWindow {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: "Music app"

    //Connections for image + timer
    Connections {
        target: CppSignalSender

        onCppTimer: {
            //console.log("onCppTimer")
            mainImage.source = imageModel.getImageUrl()
        }
    }

    ImageModel {
        id: imageModel
    }

    DynamicEntryModel {
        id: dynamic
        onCountChanged: {
            // we print out count and the last entry when count is changing
            print('new count: ' + count);
            print('last entry: ' + get(count-1));
        }
    }

    Image {
        id: background
        source: "gfx/background.png"
        anchors.fill: parent
    }

    //right
    Dial {
        id: dialId
        anchors.left: mainImage.right
        anchors.leftMargin: 60
        anchors.verticalCenter: mainImage.verticalCenter
        from: 0
        to: 1
        value: 0.5
        wrap: true

        property real volume:  QtMultimedia.convertVolume(dialId.value, 0, 1)

        onValueChanged: {
            console.log("Current value: " + volume)
        }
    }

    Label {
        text: "volume"
        font.pointSize: 10
        anchors.horizontalCenter: dialId.horizontalCenter
        anchors.top: dialId.bottom
    }

    //left

    // Search function
    //Function send input to Cpp
    function sendInputToCpp(param) {
        console.log("sendInputToCpp")
        return "" + param
    }

    RowLayout {
        anchors.bottom: filesFrame.top
        anchors.bottomMargin: 10
        anchors.left: filesFrame.left
        TextField {
            id: textFieldId
            Layout.fillWidth: true
        }
        Button {
            text: "Find"
            onClicked: {
                //Send input to C++
                //QmlCaller.cppMethod(textFieldId.text)
                QmlCaller.getQmlValue(textFieldId.text)
                console.log(QmlCaller.test())
                //reset model
                dynamic.resetQmlModel()
                listSongId.model = dynamic

            }
        }
    }

    Frame {
        id: filesFrame
        leftPadding: 1
        rightPadding: 1
        width: 300
        height: 300
        anchors.right: mainImage.left
        anchors.rightMargin: 30
        anchors.bottom: foreground.top
        anchors.bottomMargin: 40

        //List song
        ListView {
            id: listSongId
            clip: true
            anchors.fill: parent

            model: dynamic
            delegate:  ItemDelegate {
                id: itemDelegateId
                text: "" + model.fileName
                font.pointSize: 10
                width: parent.width
                //
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listSongId.currentIndex = index
                        playLogic.setIndex(index)
                    }
                }
            }

            highlight: Rectangle {
                width: filesFrame.width
                color: "blue"
                radius: 15
                border.color: "yellowgreen"
                z: 3
                opacity: 0.1
            }

            ScrollBar.vertical: ScrollBar {
                parent: filesFrame
                policy: ScrollBar.AlwaysOn
                anchors.top: parent.top
                anchors.topMargin: filesFrame.topPadding
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: filesFrame.bottomPadding
            }
        }
    }

    FileDialog {
        id  : fileDialogId
        title: "Choose file or folder"
        selectFolder: false //false => choose file, true => choose folder
        selectMultiple: true
        folder: "file:///C:/Users/ADMIN/Desktop/lamle/MusicApp/MusicApp/addedFile"

        onAccepted: {
            textId.text = fileUrls[0] //QUrl

            //add list from dialog
            for( var i = 0; i < fileUrls.length; i++) {
                console.log("File " + i + " is: " + fileUrls[i] )
                //dynamic.append(fileUrl[i])
                playLogic.items.append(fileUrls[i])
            }
        }
        onRejected: {

        }
    }

    Text {
        id: textId
        anchors.top: addButton.bottom
        text: "User hasn't choosen yet"
        wrapMode: Text.Wrap
    }

    //Button fileDialog
    RowLayout {
        spacing: 40
        anchors.top: filesFrame.bottom
        anchors.topMargin: 10
        anchors.left: filesFrame.left
        anchors.leftMargin: 20
        Button {
            id: addButton
            text: "Add"
            onClicked: {
                fileDialogId.open()
            }
        }
        Button {
            id: removeButton
            text: "Remove"
            onClicked: {
                playLogic.items.remove(listSongId.currentIndex);
            }
        }
    }

    //middle
    //main Image => image show

    Image {
        id: mainImage
        source: imageModel.getImageUrl()
        anchors.bottom: foreground.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: mainWindow.height - foreground.height
        width: foreground.width - 200

    }    

    //example

    MediaPlayer {
        id: player
        volume: dialId.volume
    }

    //Playlogic
    Item {
        id: playLogic

        property int index: -1
        property MediaPlayer mediaPlayer: player
        property DynamicEntryModel items: dynamic

        function init(){
            if(mediaPlayer.playbackState===1){
                mediaPlayer.pause();
                //CppSignalSender.cppSlot();
            }else if(mediaPlayer.playbackState===2){
                mediaPlayer.play();
            }else{
                setIndex(0);
            }
        }

        function setIndex(i)
        {
            index = i;

            if (index < 0 || index >= items.count)
            {
                index = -1;
                mediaPlayer.source = "";
            }
            else{

                mediaPlayer.source = items.get(index)
                console.log(mediaPlayer.source)
                mediaPlayer.play();
            }
        }

        function next(){
            setIndex(index + 1);
        }

        function previous(){
            setIndex(index - 1);
        }

        function msToTime(duration) {
            var seconds = parseInt((duration/1000)%60);
            var minutes = parseInt((duration/(1000*60))%60);

            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;

            return minutes + ":" + seconds;
        }
        //Connection for media
        Connections {
            target: playLogic.mediaPlayer

            onPaused: {
                playPause.source = "icons/play.png";
            }

            onPlaying: {
                playPause.source = "icons/pause.png";
            }

            onStopped: {
                playPause.source = "icons/play.png";
                if (playLogic.mediaPlayer.status == MediaPlayer.EndOfMedia)
                    playLogic.next();
            }

            onError: {
                console.log(error+" error string is "+errorString);
            }

            onMediaObjectChanged: {
                if (playLogic.mediaPlayer.mediaObject)
                    playLogic.mediaPlayer.mediaObject.notifyInterval = 50;
            }
        }
    }

    FontLoader {
        id: appFont
        name: "OpenSans-Regular"
        source: "fonts/OpenSans-Regular.ttf"
    }

    Image {
        id: foreground
        source: "gfx/bar.png"
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.verticalCenter: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: 750
        //height:

        ColumnLayout{
            id: container
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: foreground.implicitWidth - 130
            height: foreground.implicitHeight - 60

            RowLayout {
                id: wrapper
                anchors.fill: parent

                Rectangle {
                    id: leftWapper
                    height: 126
                    width: 126
                    radius: 7

                    BorderImage {
                        id: coverBorder
                        source: "gfx/cover_overlay.png"
                        anchors.fill: parent
                        anchors.margins: 4
                        border { left: 10; top: 10; right: 10; bottom: 10 }
                        horizontalTileMode: BorderImage.Stretch
                        verticalTileMode: BorderImage.Stretch

                        Image {
                            id: coverPic
                            source: player.metaData.coverArtUrlLarge ? player.metaData.coverArtUrlLarge : "gfx/cover.png"
                            anchors.fill: coverBorder
                            anchors.margins: 2
                        }
                    }

                }

                ColumnLayout {
                    id: rightWapper
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    RowLayout {
                        id: upperWrap
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        Layout.leftMargin: 20
                        spacing: 25

                        Image {
                            id: prevTrack
                            source: "icons/rewind.png"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 20
                            state: "none"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    listSongId.currentIndex -= 1
                                    playLogic.previous()
                                }
                                onPressed: prevTrack.state = "pressed"
                                onReleased: prevTrack.state = "none"
                            }
                            states: State {
                                name: "pressed"
                                when: mouseArea.pressed
                                PropertyChanges { target: prevTrack; scale: 0.8 }
                            }
                            transitions: Transition {
                                NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                            }
                        }

                        Rectangle{
                            width: 30
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                id: playPause
                                source: "icons/play.png"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                state: "none"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: playLogic.init();
                                    onPressed: playPause.state = "pressed"
                                    onReleased: playPause.state = "none"
                                }
                                states: State {
                                    name: "pressed"
                                    when: mouseArea.pressed
                                    PropertyChanges { target: playPause; scale: 0.8 }
                                }
                                transitions: Transition {
                                    NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                                }
                            }
                        }

                        Image {
                            id: nextTrack
                            source: "icons/forward.png"
                            anchors.verticalCenter: parent.verticalCenter
                            state: "none"

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    playLogic.next()
                                    listSongId.currentIndex += 1
                                }

                                onPressed: nextTrack.state = "pressed"
                                onReleased: nextTrack.state = "none"
                            }
                            states: State {
                                name: "pressed"
                                when: mouseArea.pressed
                                PropertyChanges { target: nextTrack; scale: 0.8 }
                            }
                            transitions: Transition {
                                NumberAnimation { properties: "scale"; duration: 100; easing.type: Easing.InOutQuad }
                            }
                        }

                        //name track
                        Item {
                            Layout.fillWidth: true

                            ColumnLayout {
                                anchors.verticalCenter: parent.verticalCenter
                                Layout.fillWidth: true

                                Text {
                                    id: trackTitle
                                    text: playLogic.items.getName(listSongId.currentIndex)
                                    color: "#eeeeee"
                                    font.family: appFont.name
                                    font.pointSize: 17
                                    font.bold: true
                                    style: Text.Raised
                                    styleColor: "#111111"
                                    wrapMode: Text.Wrap
                                }
                            }
                        }

                    }

                    RowLayout {
                        id: lowerWrap
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        Layout.leftMargin: 20
                        spacing: 15

                        Text {
                            id: currentTime
                            text: playLogic.msToTime(player.position)
                            font.family: appFont.name
                            color: "#dedede"
                            font.pointSize: 18
                        }

                        SliderBar{
                            Layout.fillWidth: true
                            audioPlayer: player
                            bgImg: "gfx/slider_background.png"
                            bufferImg: "gfx/slider_value_right.png"
                            progressImg: "gfx/slider_value_left.png"
                            knobImg: "gfx/slider_knob.png"
                        }

                        Text {
                            id: totalTime
                            text: playLogic.msToTime(player.duration)
                            font.family: appFont.name
                            color: "#dedede"
                            font.pointSize: 18
                        }
                    }

                }

            }

        }

    }
}




