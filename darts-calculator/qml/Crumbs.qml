import QtQuick 2.4
import QtQuick.Controls 1.3
import ru.lagner 1.0


Item {
    QtObject {
        id: __phoneStyles
        readonly property int cellMargin: R.dp(8)
        readonly property int cellWidth: R.dp(36)
    }

    QtObject {
        id: __tabletStyles
        readonly property int cellMargin: R.dp(18)
        readonly property int cellWidth: R.dp(48)
    }

    property int breadMax: 5
    property int breadCurrent: 0
    property int requiredWidth: styles.cellWidth + (styles.cellMargin + styles.cellWidth) * breadMax;

    readonly property QtObject styles: R.isTablet() ? __tabletStyles : __phoneStyles

    signal crumbsSelected(int num)

    implicitHeight: R.dp(48)

    Row {
        id: container
        anchors.fill: parent

        Item {
            height: parent.height
            width: styles.cellWidth
        }

        Repeater {
            id: _repeater
            model: breadMax

            Item {
                id: _repItem
                height: parent.height
                width: styles.cellWidth + styles.cellMargin

                Image {
                    width: R.dp(40)
                    height: R.dp(40)
                    anchors.verticalCenter: parent.verticalCenter
                    source: breadCurrent > index ? Qt.resolvedUrl("qrc:///res/bread.png") :
                                                   Qt.resolvedUrl("qrc:///res/bread_light.png")
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            var w = styles.cellWidth;
            var x = mouse.x - w;
            if (x <= 0) {
                // first elem. Empty items
                return crumbsSelected(0);
            }

            w = w + styles.cellMargin;
            var i = parseInt(x / w + 1, 10);
            if (i > breadMax)
                i = breadMax;

            crumbsSelected(i);
        }
    }
}

