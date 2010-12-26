import Qt 4.7

import Qt 4.7

// Delegate for the detail list
Component {
    BorderImage {
        id: backgroundImage
        source: ma.pressed ? "pics/listitem_pressed.png" : "pics/listitem.png"
        //width: ListView.view.width
        width: ListView.view.width
        border.bottom: 5
        border.top: 5
        border.left: 5
        border.right: 30
        //height: visuals.height
        height:  visuals.height +5 //dscIt.height + 70
        //height: childrenRect.height  + 10
        //width: lvLinks.width
        Item {
            id: visuals
            height: childrenRect.height
            width: parent.width
            //color: "red"

            Rectangle {
                x:2
                y:4
                id: thumbarea
                width: thumbnail.length > 0 ? 60 : 0
                height: 60

                border.width: thumbnail.length > 0 ? 1 : 0

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

                anchors {
                    right: parent.right
                    rightMargin: 60
                    left: thumbarea.right
                    leftMargin: 4
                    top: thumbarea.top
                }
            }

            Text {
                id: txtIt
                text: score
                //scale: 0.7
                y: 0
                color: score > 100 ? "red" : "black"

                anchors.right: parent.right
                anchors.rightMargin: 5

            }

            Text {
                id: tCommentCount
                //scale: 0.7
                anchors.left: thumbarea.right
                anchors.leftMargin: 10
                y: dscIt.height + 4
                text: comments
                color: "blue"

            }


            /*
            Rectangle {
                border.width: 3
                anchors.fill: tnail
            }
            */

        }

        MouseArea {
            id: ma
            //width: parent.width
            //height: dscIt.height + txtIt.height + 10


            anchors.fill: visuals
            onClicked: {
                //console.log("index ", index)
                linkSelected(index)
            }

        }

        /*

        MouseArea {
           id: listViewMouseArea
           anchors.fill: parent

           onClicked: {
               // Switch to details view
               listView.currentIndex = index
               detailViewImage.source = photo
               detailViewName.text = name
               detailViewNumber.text = number
               detailListView.switchState()
           }
        }
        */
    }
}


