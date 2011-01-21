import Qt 4.7

import Qt 4.7

// Delegate for the detail list
Component {
    BorderImage {
        id: backgroundImage
        source: ma.pressed ? "pics/listitem_pressed.png" : "pics/listitem.png"
        width: ListView.view.width
        border.bottom: 5
        border.top: 5
        border.left: 5
        border.right: 30
        height:  visuals.height +5 //dscIt.height + 70
        Item {
            id: visuals
            height: childrenRect.height
            width: parent.width

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
                }


            }

            Text {
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                id: dscIt
                text: desc

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

            Text {
                id: tAuthor
                text: author + " on " + tTime
                anchors {
                    left: tCommentCount.right
                    top: tCommentCount.top

                }
                font.pixelSize: 8
                color: "gray"
            }

            Text {
                id: tTime

            }


        }

        MouseArea {
            id: ma

            anchors.fill: visuals
            onClicked: {
                linkSelected(index)
            }

        }

    }
}


