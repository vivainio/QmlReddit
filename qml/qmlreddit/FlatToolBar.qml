import Qt 4.7

// this class is bogus, total rewrite is needed
Rectangle {
    width: 80
    height: 80
    color: "black"

    opacity: 0.3
    id: root

    property alias orientation: listview.orientation


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
            //orientation: "

            boundsBehavior: Flickable.StopAtBounds

            delegate: dlgbutton
            width: orientation == ListView.Vertical ? 100 : 600
            height: orientation == ListView.Vertical ? 600 : 100
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
                width: listview.orientation == ListView.Horizontal ? 600 : 100
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
