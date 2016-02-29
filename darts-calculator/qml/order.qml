import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQml.Models 2.2
import ru.lagner 1.0
import "qrc:///js/script.js" as Script


Page {
    property ListModel usersModel

    ListView {
        id: reorderList

        spacing: R.dp(10)
        clip: true
        anchors {
            margins: R.dp(12)
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footerButtons.top
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: usersModel

            delegate: Item {
                id: delegateRoot

                property int visualIndex: DelegateModel.itemsIndex
                property bool desided: false

                width: parent.width;
                height: R.dp(48)
//                drag.target: dragplace
//                onReleased: desided = !desided

                Item {
                    id: dragplace
                    width: reorderList.width
                    height: R.dp(48)
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

//                    Drag.active: delegateRoot.drag.active
//                    Drag.source: delegateRoot
                    Drag.active: draggingArea.drag.active
                    Drag.source: delegateRoot
                    Drag.hotSpot.x: reorderList.width / 2
                    Drag.hotSpot.y: height / 2
//                    Drag.hotSpot.x: draggingArea.width / 2

                    states: [
                        State {
                            when: dragplace.Drag.active
                            ParentChange {
                                target: dragplace
                                parent: reorderList
                            }

                            AnchorChanges {
                                target: dragplace;
                                anchors.horizontalCenter: undefined;
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]

                    Image {
                        id: _reorderIcon

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        width: R.dp(60)
                        height: R.dp(40)

                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl("qrc:///res/reorder.png")
                    }

                    Text {
                        anchors {
                            left: _reorderIcon.right
                            top: parent.top
                            right:  parent.right
                            bottom: parent.bottom
                        }

                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                        clip: true
                        text: name
                        font.pixelSize: delegateRoot.desided ? R.dp(28) :
                                                               R.dp(24)
                        color: delegateRoot.desided ? "darkgreen" :
                                                      "black"
                        font.weight: delegateRoot.desided ? Font.Bold :
                                                            Font.Normal
                    }

                    Connections {
                        target: launchButton
                        onStart: delegateRoot.desided = false
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "lightblue"
                        anchors.bottom: parent.bottom
                    }
                }

                MouseArea {
                    id: draggingArea
                    x: 0; y: 0
                    width: _reorderIcon.width
                    height: _reorderIcon.height

                    drag.target: dragplace
                    onReleased: delegateRoot.desided = !delegateRoot.desided
                }

                DropArea {
                    anchors { fill: parent; margins: R.dp(16) }
                    onEntered: usersModel.move(drag.source.visualIndex, delegateRoot.visualIndex, 1);
                }
            }

        }
    }

    Item {
        id: footerButtons

        height: R.dp(96)
        anchors {
            margins: R.dp(12)
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Button {
            text: "Автоматическая жеребьёвка!"
            width: parent.width
            anchors {
                top: parent.top
                bottom: emptySpace.top
            }
            onClicked: {
                for (var i = usersModel.count - 1; i > 0; --i) {
                    var j = Math.floor(Math.random() * (i + 1))
                    var tmpName = usersModel.get(i).name
                    usersModel.get(i).name = usersModel.get(j).name
                    usersModel.get(j).name = tmpName
                }
                footerButtons.startGame()
            }
        }

        Item {
            id: emptySpace
            width: parent.width
            height: R.dp(12)
            anchors.centerIn: parent
        }

        Button {
            id: launchButton

            signal start

            width: parent.width
            anchors {
                top: emptySpace.bottom
                bottom: parent.bottom
            }
            text: "Старт!"

            onClicked: {
                footerButtons.startGame()
            }
        }

        function startGame() {
            sceneManager.push({
                                         item: Qt.resolvedUrl("game.qml"),
                                         properties: { usersModel: usersModel }
                                     });
            launchButton.start();
        }
    }
}

