import Qt 4.7

Item {

    visible: false

    Rectangle {
        color: "white"
        anchors.fill: parent
        opacity: 0.8
    }

    Column {
        Text {
            id: heading
            height: 40
        }


        Row {
            RButton {
                buttonLabel: "+"
            }

            RButton {
                buttonLabel: "0"
            }

            RButton {
                buttonLabel: "-"
            }
        }
    }


}
