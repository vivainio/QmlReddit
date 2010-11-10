import Qt 4.7


Rectangle {
    property alias label : tf.text
    signal clicked;

    width: 80
    height: 60
    border.width: 1
    border.color: "blue"
    color: "#ca6262"
    Text {
        id: tf
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()

    }



}
