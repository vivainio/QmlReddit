import Qt 4.7


Rectangle {
    id: root

    property alias buttonLabel : tf.text
    property bool selected : false
    signal clicked;
    signal doubleClicked;

    width: 80
    height: 60
    border.width: 3
    border.color: selected ? mainview.theme.bg : mainview.theme.fg
    //color: selected ? "yellow" : "#ca6262"
    //color: mainview.theme.bg
    color: selected ? mainview.theme.fg : mainview.theme.bg
    Text {
        color: root.border.color
        id: tf
        anchors.centerIn: parent
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: parent.clicked()
        onDoubleClicked: parent.doubleClicked()

    }

    states: [
        State {
            name: "pressed"
            when: ma.pressed
            PropertyChanges {
                target: root
                color: "green"

            }
        }
    ]

}
