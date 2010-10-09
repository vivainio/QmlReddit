import Qt 4.7

Rectangle {
    id: container
    width: 864
    height: 480


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
            width: 500
            height: deLinks.height

        }

    }

    Component {
        id: deLinks
        Rectangle {
            height: 50
            Text {
                wrapMode: "WordWrap"
                id: dscIt
                text: desc

                //anchors.left: parent.left
            }

            Text {
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
