import Qt 4.7

Rectangle {
    x: 1000
    signal commentSelected
    Rectangle {
        color: "#9c5d5d"
        anchors.fill: parent

    }

    Text {
        anchors.fill: parent
        text: "hello comments"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                commentSelected()
                console.log("doeoehdhd")
                //commentSelected()
            }
        }

    }

}
