import Qt 4.7

Rectangle {
    //id: progressInd
    id: root

    property string waitText : "Loading"
    opacity: 0
    function show(t) {
        progressInd.state = "shown"
        if (t) {
            waitText = t
        } else {
            waitText = "Loading"
        }

    }

    function hide() {
        progressInd.state = ""
        waitText = "Loading"

    }

    TText {
        id: tInd
        text: waitText
        anchors.centerIn: parent
        color: "white"

    }

    width: tInd.width + 20
    height: tInd.height + 20
    color: "gray"
    states: [
        State {
            name: "shown"
            PropertyChanges {
                target: progressInd
                opacity: 1


            }
        }
    ]

    transitions: [

        Transition {
            to: "shown"
            ParallelAnimation {
                NumberAnimation {

                    properties: "opacity"
                    duration: 800
                    //easing.type: Easing.OutBounce
                }

            }
        },
        Transition {
            from: "shown"
            NumberAnimation {

                properties: "opacity"
                duration: 200
            }

        }

    ]

}

