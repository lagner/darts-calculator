import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.2
import QtQml.Models 2.2
import QtMultimedia 5.0
import ru.lagner 1.0
import "qrc:///js/script.js" as Script


Page {
    property ListModel usersModel

    Stack.onStatusChanged: {
        if (Stack.status === Stack.Active) {
            visualModel.reorderPlayers();
        }
    }

    DelegateModel {
        id: visualModel
        model: usersModel

        function reorderPlayers() {
            var offset = 0;
            for (var i = 0; i < usersModel.count; i++) {
                var item = usersModel.get(i);
                if (item.fails >= 5) {
                    item.gameStatus = Script.GROUP_LOSERS;
                    visualModel.items.move(i - offset, usersModel.count - 1);
                    offset++;
                } else {
                    item.gameStatus = Script.GROUP_IN_GAME;
                }
            }
        }

        delegate: Rectangle {
            id: delegateRoot
            property int visualIndex: DelegateModel.itemsIndex

            width: parent.width
            height: R.dp(48)
            color: "white"

            Text {
                anchors {
                    left: parent.left
                    right: breads.left
                    top: parent.top
                    bottom: parent.bottom
                }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                clip: true
                text: name
                font.pixelSize: R.dp(24)
            }

            Crumbs {
                id: breads
                width: breads.requiredWidth
                anchors {
                    right: parent.right
                }
                breadCurrent: fails
                anchors.verticalCenter: parent.verticalCenter

                onCrumbsSelected: {
                    var item = usersModel.get(index);

                    item.fails = num;
                    breadCurrent = num;

                    if (num >= 5) {
                        item.gameStatus = Script.GROUP_LOSERS;
                        // Moving to bottom
                        visualModel.items.move(delegateRoot.visualIndex, usersModel.count - 1);
                        playSoundEffect(Qt.resolvedUrl("qrc:///res/sounds/womp-womp.mp3"));
                    }
                }
            }

            Connections {
                target: confirmDialog
                onResetCrumbs: {
                    var item = usersModel.get(index);
                    item.fails = 0;
                    breads.breadCurrent = 0;
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

    ListView {
        spacing: R.dp(10)
        clip: true
        anchors {
            margins: R.dp(12)
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footerButtons.top
        }

        section.property: "gameStatus"
        section.delegate: Item {
            width: parent.width
            height: R.dp(48)

            Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: R.dp(26)
                font.weight: Font.Bold
                text: section
                color: section === Script.GROUP_IN_GAME ? "green" :
                                                          "lightpink"
            }
        }

        model: visualModel
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
            text: "А давай еще одну"

            onClicked: confirmDialog.show("Точно сбросить все булки?");
        }
    }

    MessageDialog {
        id: confirmDialog

        signal resetCrumbs;

        standardButtons: StandardButton.Ok | StandardButton.Cancel

        title: "Continue"

        function show(caption) {
            text = caption;
            open();
        }

        onAccepted: {
            resetCrumbs();
            visualModel.reorderPlayers();
        }
    }
}

