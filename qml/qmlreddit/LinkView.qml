import Qt 4.7

Rectangle {
    id: container
    width: 864
    height: 480
    x: 1000
    // hidden by defaul

    signal selected

    /*
    Behavior on x {
        NumberAnimation {
            duration: 200
            easing.type: "InOutBounce"
        }
    }
    */

    Rectangle {
        id: rCat
        x: 200
        y: 0
        height: 17
        anchors.right: parent.right
        anchors.rightMargin: 30
        Text {
            x: 6
            y: 0
            color: "#1f6e7a"
            text: "Cat"
            //anchors.right: parent.right
            //x: parent.width - 20

        }
    }

    ListView {

        id: lvLinks
        anchors.fill: parent

        model: mdlLinks
        delegate: deLinks
        focus: true
        highlight: Rectangle {
            color: "#5989ad"
            width: container.width
            height: container.height
        }

    }

    Component {
        id: deLinks
        Rectangle {
            height: dscIt.height + txtIt.height + 10
            Text {
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                id: dscIt
                text: desc
                width: 600

                //anchors.left: parent.left
            }

            Text {
                id: txtIt
                text: score
                scale: 0.7
                //anchors.right: parent.right
                //anchors.verticalCenter: dscIt.verticalCenter
                //anchors.top: dscIt.anchors.bottom
                //anchors.rightMargin: 30
                x: 2
                y: dscIt.height + 2

            }
        }

    }

    /*
    ListModel {
        id: mdlLinks
        ListElement { url:  "google.com"; desc : "search engine"; score : 3 }
        ListElement { url: "slashdot.org"; desc: "gossip site"; score : 12 }
    }
    */

}
