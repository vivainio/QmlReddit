import Qt 4.7

Rectangle {
    width: 80
    height: 80
    color: "black"

    opacity: 0.3
    id: root

    signal itemSelected(string itemName)

    property alias model: listview.model

    Text {
        id: tooltext
        anchors.centerIn: parent
        text: "Tools"
        color: "red"
    }


    Rectangle {
        id: expandedcontent
        anchors.fill: parent
        opacity: 0.0

        Component {
            id: dlgbutton
            RButton {
                id: te
                buttonLabel: label
                width: 100
                height: 100
                onClicked: {
                    itemSelected(name)
                    root.state = "small"
                }

            }

            /*
            Rectangle {
                border.width: 5
                border.color: "blue"
                color: "lightblue"
                width: 150
                height: 100
                Text {
                    id: te
                    text: label

                }
            }
            */
        }



        ListView {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            id: listview
            orientation: "Horizontal"

            boundsBehavior: Flickable.StopAtBounds

            delegate: dlgbutton
            width: 600
            height: 100
            spacing: 10


        }

        Rectangle {
            anchors.right: parent.right
            width: 100
            height: 100
            anchors.bottom: parent.bottom

           //anchors.verticalCenter: parent.verticalCenter
            //anchors.bottom: parent.bottom

            color: "red"
            Text {
                anchors.centerIn: parent
                id: name
                text: ">"
            }

            MouseArea {
                id: maContract
                anchors.fill: parent
                onClicked: {
                    //console.log("cl")
                    root.state = "small"
                }

            }
        }

    }

    MouseArea {
        id: maExpand
        anchors.fill: parent
        onClicked: {
            //console.log('clexp')
            if (root.state == "small") {
                root.state = "expanded"
            }

        }

    }

    state: "small"

    states: [
        State {
            name: "expanded"
            PropertyChanges {
                target: root
                width: 600
                opacity: 1.0
            }

            PropertyChanges {
                target: tooltext
                opacity: 0.0


            }
            PropertyChanges {
                target: expandedcontent
                opacity: 1.0

            }

            PropertyChanges {
                target: maExpand
                enabled: false
            }
        }
    ]
}
