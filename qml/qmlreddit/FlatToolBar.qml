import Qt 4.7

Rectangle {
    width: 50
    height: 50
    color: "black"

    id: root

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
            Rectangle {
                width: te.width + 10
                height: 20
                Text {
                    id: te
                    text: label

                }
            }
        }

        ListView {

            anchors.left: parent.left
            id: listview
            orientation: "Horizontal"

            delegate: dlgbutton
            width: 150


        }

        Rectangle {

            anchors.left: listview.right
            width: 30
            height: 20

            anchors.verticalCenter: parent.verticalCenter

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
                    console.log("cl")
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
                width: 200

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
