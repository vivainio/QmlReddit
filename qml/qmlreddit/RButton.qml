import Qt 4.7


Rectangle {
    id: root

    property alias buttonLabel : tf.text
    property bool selected : false
    property color pressedColor: "green"
    signal clicked;
    signal doubleClicked;
    signal repeated;

    radius: 10


    width: 80
    height: 60
    border.width: 3
    border.color: selected ? mainview.theme.bg : mainview.theme.fg
    //color: selected ? "yellow" : "#ca6262"
    //color: mainview.theme.bg
    color: selected ? mainview.theme.fg : mainview.theme.bg
    Timer {
        id: tRepeat
        repeat: true
        onTriggered: {
            //console.log("repeat!")

            repeated()
        }
        interval: 500

    }

    TText {
        color: root.border.color
        id: tf
        anchors.centerIn: parent
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: parent.clicked()
        onDoubleClicked: parent.doubleClicked()
        onPressed: tRepeat.start()
        onReleased: tRepeat.stop()


    }

    states: [
        State {
            name: "pressed"
            when: ma.pressed
            PropertyChanges {
                target: root
                color: pressedColor

            }
        }
    ]

}
