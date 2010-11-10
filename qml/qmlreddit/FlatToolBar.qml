import Qt 4.7

Rectangle {
    width: 80
    height: 80
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
        }

        ListView {

            anchors.left: parent.left
            id: listview
            orientation: "Horizontal"

            delegate: dlgbutton
            width: 400


        }

        Rectangle {
            anchors.right: parent.right
            width: 100
            height: 100

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
                width: 400

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