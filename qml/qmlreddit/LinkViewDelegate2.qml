import Qt 4.7


Component {    
    BorderImage {
        id: backgroundImage
        source: ma.pressed ? "pics/listitem_pressed.png" : "pics/listitem.png"
        width: mainview.width
        border.bottom: 5
        border.top: 5
        border.left: 5
        border.right: 30
        height:  visuals.height +5 //dscIt.height + 70

        property bool hasThumbnail: !appState.lightMode && thumbnail.length > 0
        Item {
            id: visuals
            height: childrenRect.height
            width: parent.width

            TText {
                id: tAuthor
                text: author.substr(0,13) + " / " + subreddit.substr(0,13)

                anchors {
                    left: parent.left

                    top: parent.top
                    leftMargin: 20

                }
                //font.pixelSize: 12
                color: "gray"
            }


            Rectangle {
                id: thumbarea

                anchors.top: tAuthor.bottom
                x:2
                width: hasThumbnail ? 60 : 0
                height: 60
                visible: hasThumbnail
                color: mainview.theme.bg
                //border.width: hasThumbnail ? 1 : 0

                Image {
                    anchors.fill: parent
                    id: tnail
                    sourceSize.height: 60
                    sourceSize.width: 60
                    height: 60
                    width: 60
                    source: hasThumbnail ? thumbnail : ""

                }

            }

	    TText {
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                id: dscIt
                text: desc
                color: mainview.theme.fg

                anchors {
                    right: parent.right
                    rightMargin: 60
                    left: thumbarea.right
                    leftMargin: 4
                    top: thumbarea.top
                }
            }

	    TText {
                id: txtIt
                text: score > 0 ? "+" +score : score

                color: "green" // score > 100 ? "red" : mainview.theme.fg
                anchors.top: dscIt.bottom
                anchors.topMargin: hasThumbnail && dscIt.height < 60 ? 40 : 10

            }

	    TText {
                id: tCommentCount
                //scale: 0.7
                anchors.top: txtIt.top
                anchors.right: parent.right
                anchors.rightMargin: 10
                //y: dscIt.height + 4
                text: comments + " COMMENTS"
                color: "cyan"

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


