import Qt 4.7


Rectangle {
    id: root

    property alias buttonLabel : tf.text
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
        id: ma
        anchors.fill: parent
        onClicked: parent.clicked()

    }

    states: [
        State {
            name: "pressed"
            when: ma.pressed
            PropertyChanges {
                target: root
                color: "green"

            }
        }
    ]

}
