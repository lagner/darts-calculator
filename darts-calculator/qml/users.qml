import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtMultimedia 5.0
import Qt.labs.settings 1.0
import ru.lagner 1.0
import "qrc:///js/script.js" as Script


Page {

    Settings {
        property string names: "[]"

        id: playersSettings
        category: "users"

        Component.onCompleted: {
            usersModel.clear();
            try {
                var players = JSON.parse(names);

                for (var i = 0; i < players.length; i++)
                    usersModel.append(new Script.User(players[i]));

            } catch (ex) {
                console.error("serialized players array was corrupted. Drop it");
                names = "[]";
            }
        }
    }

    ListModel {
        id: usersModel

        Component.onDestruction: {
            var names = [];
            for (var i = 0; i < count; i++) {
                var name = get(i).name;
                if (name)
                    names.push(get(i).name);
            }
            playersSettings.names = JSON.stringify(names);
        }
    }


    // ----------------------------------------------------------------------

    Item {
        id: headerNewName

        height: R.dp(54)
        anchors {
            margins: R.dp(12)
            top: parent.top
            left: parent.left
            right: parent.right
        }

        TextField {
            id: newUserName
            height: parent.height
            anchors {
                left: parent.left
                right: parent.right
            }
            placeholderText: "Enter new name"

            onAccepted: {
                var text = newUserName.text;
                if (text) {
                    for (var i = 0; i < usersModel.count; i++) {
                        var username = usersModel.get(i).name;
                        if (username && username === text) {
                            console.log("name not unique");
                            return;
                        }
                    }
                    usersModel.append(new Script.User(text));
                    newUserName.text = "";
                }
            }
        }
    }

    ListView {
        anchors {
            margins: R.dp(12)
            top: headerNewName.bottom
            left: parent.left
            right: parent.right
            bottom: footerButtons.top
        }

        model: usersModel
        spacing: R.dp(10)
        clip: true

        delegate: Component {

            Rectangle {
                width: parent.width
                height: R.dp(48)
                color: "transparent"

                Text {
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        right: removeButton.left
                    }
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    text: name
                    font.pixelSize: R.dp(24)
                }

                Button {
                    id: removeButton

                    width: R.dp(36)
                    height: R.dp(36)

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        usersModel.remove(index, 1)
                        playSoundEffect(Qt.resolvedUrl("qrc:///res/sounds/dropping.mp3"));
                    }

                    style: ButtonStyle {
                        background: Image {
                            source: control.pressed ? Qt.resolvedUrl("qrc:///res/trash_pressed.png") :
                                                      Qt.resolvedUrl("qrc:///res/trash.png")
                        }
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "lightblue"
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    Item {
        id: footerButtons

        height: R.dp(54)
        anchors {
            margins: R.dp(12)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Button {
            anchors.fill: parent
            text: "Погнали на вход!"

            onClicked: sceneManager.push({
                                             item: Qt.resolvedUrl("order.qml"),
                                             properties: { usersModel: usersModel }
                                         });
        }
    }
}

