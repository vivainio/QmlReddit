import Qt 4.7
Rectangle {
    //id: progressInd
    x:  -200
    id: root
    anchors.verticalCenter: parent.verticalCenter

    function show() {
        progressInd.state = "shown"

    }

    function hide() {
        progressInd.state = ""
    }

    Text {
        id: tInd
        text: "Loading"
        anchors.centerIn: parent
        color: "yellow"

    }

    width: tInd.width + 20
    height: tInd.height + 20
    color: "red"
    states: [
        State {
            name: "shown"
            PropertyChanges {
                target: progressInd
                x: root.parent.width / 2 - width/2

            }
        }
    ]

    transitions: [

        Transition {
            to: "shown"
            ParallelAnimation {
                NumberAnimation {

                    properties: "x"
                    duration: 400
                    //easing.type: Easing.OutBounce
                }

            }
        },
        Transition {
            from: "shown"
            NumberAnimation {

                properties: "x"
                duration: 200
            }
        }

    ]

}

