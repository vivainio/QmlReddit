import Qt 4.7

Rectangle {
    id: rrect
    width: parent.width
    x: -parent.width - 20
    height: 62
    color: "green"
    anchors {
        top: parent.top
    }

    property alias title : btitle.text

    TText {
        id: btitle
        anchors.centerIn: parent
        color: "yellow"
    }

    Timer {
        id: tmDismiss
        interval: 2000; running: false; repeat: false
        onTriggered: rrect.state = "";
    }

    function show(text) {
        rrect.state = "visible"
        rrect.title = text
        tmDismiss.start()
    }

    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: rrect
                x: 0

            }
        }
    ]
    transitions: [
        Transition {
            to: "visible"
            PropertyAnimation {
                target: rrect
                properties: "x"
                duration: 200

            }

        },
        Transition {
            from: "visible"
            PropertyAnimation {
                target: rrect
                properties: "x"
                duration: 100

            }

        }

    ]



}
