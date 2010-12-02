import Qt 4.7

Rectangle {
    id: container
    //anchors.fill: parent
    width: parent.width
    height: parent.height
    x: width + 200

    signal linkSelected(int selIndex);

    // hidden by default

    /*
    Behavior on x {
        NumberAnimation {
            duration: 200
            easing.type: "InOutBounce"
        }
    }
    */

    /*
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
    */

    ListView {

        id: lvLinks
        anchors.fill: parent

        model: mdlLinks
        //delegate: deLinks
        delegate: LinkViewDelegate {}
        footer: Rectangle {
            height: 60
        }

        //focus: true

        /*
        highlight: Rectangle {
            color: "#5989ad"
            width: container.width
            height: container.height
        }
        */

        /*
        MouseArea {
            anchors.fill: lvLinks
            onClicked: {

                var idx = lvLinks.indexAt(mouse.x, mouse.y);
                container.linkSelected(idx)
                console.log("click ", lvLinks.index, " at ", mouse.y, " , ", mouse.x)

            }
        }
        */


    }

    Component {
        id: deLinks
        Rectangle {
            id: rrect
            height: childrenRect.height  + 10
            width: lvLinks.width
            Rectangle {
                x:0
                y:0
                id: thumbarea
                width: thumbnail.length > 0 ? 60 : 0
                height: 60                
                border.width: 1
                Image {
                    anchors.fill: parent
                    id: tnail
                    height: 60
                    width: 60
                    source: thumbnail
                    //source: "http://upload.wikimedia.org/wikipedia/en/thumb/9/99/Question_book-new.svg/50px-Question_book-new.svg.png"
                }


            }

            Text {
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                id: dscIt
                text: desc
                //width: lvLinks.width - thumbarea.width - 100

                anchors.right: rrect.right
                anchors.rightMargin: 50
                anchors.left: thumbarea.right
                anchors.leftMargin: 4
            }

            Text {
                id: txtIt
                text: score
                //scale: 0.7
                y: 0
                color: score > 100 ? "red" : "black"

                anchors.right: rrect.right
                anchors.rightMargin: 10

            }

            Text {
                id: tCommentCount
                //scale: 0.7
                anchors.left: thumbarea.right
                anchors.leftMargin: 10
                y: dscIt.height + 2
                text: comments
                color: "blue"



            }


            /*r
            Rectangle {
                border.width: 3
                anchors.fill: tnail
            }
            */


            MouseArea {
                id: ma
                width: rrect.width
                height: dscIt.height + txtIt.height + 10

                //anchors.fill: parent
                onClicked: {
                    //console.log("index ", index)
                    linkSelected(index)
                }

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
