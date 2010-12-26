import Qt 4.7

Rectangle {
    id: root

    property alias buttonImage : img.source
    signal clicked;

    width: 64
    height: 64
    border.width: 1
    border.color: "blue"
    color: "#ca6262"
    Image {
        id: img
        sourceSize: {
            width: 64
            height: 64
        }
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
