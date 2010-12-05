import Qt 4.7

Rectangle {
    id: rrect
    width: parent.width
    x: -parent.width - 20
    height: 62
    color: "green"
    anchors {
        top: parent.top
        left: parent.left
    }

    property alias title : btitle.text

    Text {
        id: btitle
    }

    Timer {
        id: tmDismiss
        interval: 5000; running: false; repeat: false
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



}
