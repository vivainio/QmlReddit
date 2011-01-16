import Qt 4.7

Rectangle {
    Text {
        anchors.horizontalCenter:  parent.horizontalCenter
        font.pixelSize: 40
        id: name
        text: "QmlReddit"
    }
    Image {

        anchors.horizontalCenter: parent.horizontalCenter
        y: 45
        source: "pics/qmlreddit.png"

    }
}
