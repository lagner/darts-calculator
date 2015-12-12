import QtQuick 2.4
import QtQuick.Controls 1.3
import "qrc:///js/script.js" as Script


Page {
    color: "lightyellow"

    ListView {
        anchors.fill: parent
        anchors.margins: 40

        width: 100
        height: 300
        focus: true
        model: Script.users

        delegate: Component {

            Rectangle {
                width: parent.width
                height: 30

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    text: name
                }
            }
        }

        highlight: Rectangle {
            color: "lightblue"
        }
    }


    Button {
        anchors {
            margins: 30
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        text: "WAzaap"

        onClicked: {
            sceneManager.pop(sceneManager.get(0));
        }
    }


    Item {
        anchors {
            bottom: parent.bottom
            margins: R.dp(24)
        }
        height: R.dp(36)

        Button {
        }
    }
}
