import Qt 4.7

Item {
    id: root

    property alias buttonImage : img.source
    signal clicked;
    property alias color : bgRect.color
    property alias bgOpacity: bgRect.opacity

    property string pressedColor: color
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
        //width: 64
        //height: 64
        //sourceSize: {
        //    width: 64
        //    height: 64
        //}
        anchors.centerIn: parent

    }

    MouseArea {
        id: ma
        anchors.fill: parent
        anchors.topMargin: -15
        anchors.leftMargin: -15
        anchors.rightMargin: -15
        anchors.bottomMargin: -15

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
                color: pressedColor
            }
        }
    ]

}
