import Qt 4.7

import "../"

Rectangle {
    id: headerView
    property string applicationName: ""

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 50
    color: "black"

    function backsteppingImage() {
        var source

        if (toolbar.views[toolbar.current].backsteppingExits) {
            if (backsteppingArea.pressed) {
                source = "pics/close_pressed.png"
            } else {
                source = "pics/close.png"
            }
        } else {
            if (backsteppingArea.pressed) {
                source = "pics/back_pressed.png"
            } else {
                source = "pics/back.png"
            }
        }
        return source
    }

    Image {
        anchors.fill: parent
        source: "pics/toolbaritem.png"
    }

    TText {
        anchors.centerIn: parent
        font.pixelSize: Math.round(headerView.height / 2.5)
        color: "lightgray"
        text: applicationName
    }

    Image {
        id: backstepping
        source: backsteppingImage()
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            id: backsteppingArea

            // Make mouse area bigger than the button to make it easier
            // to hit with a finger
            anchors.centerIn: parent
            width: parent.width + 20
            height: parent.height + 20

            onClicked: {
                if (toolbar.views[toolbar.current].backsteppingExits) {
                    Qt.quit()
                } else {
                    backstep()
                }
            }
        }
    }

    signal backstep()
}
