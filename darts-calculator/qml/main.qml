import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtMultimedia 5.0

ApplicationWindow {
    title: qsTr("Darts Calculator")
    width: 480
    height: 800
    visible: true

    Item {
        anchors.fill: parent
        focus: true

        Keys.onReleased: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
                event.accepted = true;
                if (sceneManager.depth == 1) {
                    Qt.quit();
                } else {
                    sceneManager.pop();
                }
            }
        }

        StackView {
            id: sceneManager
            anchors.fill: parent

            initialItem: Rectangle {
                color: "black"
            }

            Component.onCompleted: {
                sceneManager.push({
                                      item: Qt.resolvedUrl("users.qml"),
                                      replace: true,
                                      immediate: true
                                  });
            }

            MediaPlayer {
                id: soundsPlayer
            }

            function playSoundEffect(src) {
                if (soundsPlayer.playbackState != MediaPlayer.StoppedState)
                    soundsPlayer.stop();

                soundsPlayer.source = src;
                soundsPlayer.play();
            }
        }
    }
}
