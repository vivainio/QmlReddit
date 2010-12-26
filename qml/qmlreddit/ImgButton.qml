import Qt 4.7

Item {
    id: root

    property alias buttonImage : img.source
    signal clicked;
    property alias color : bgRect.color
    width: 64
    height: 64
    Rectangle {
        id: bgRect
        border.width: 1
        border.color: "blue"

        anchors.fill: parent
        color: "#ca6262"
        opacity: 0.2
    }


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
            //PropertyChanges {
            //    target: root
            //    color: "green"

            //}
            PropertyChanges {
                target: bgRect
                opacity: 1.0

            }
        }
    ]

}
