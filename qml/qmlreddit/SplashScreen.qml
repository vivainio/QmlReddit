import Qt 4.7

Rectangle {
    color: mainview.theme.bg
    TText {
        anchors.horizontalCenter:  parent.horizontalCenter
        font.pixelSize: 40
        id: name
        text: "QmlReddit"
        color: mainview.theme.fg
    }
    Image {

        anchors.horizontalCenter: parent.horizontalCenter
        y: 45
        source: "pics/qmlreddit.png"
    }
}
