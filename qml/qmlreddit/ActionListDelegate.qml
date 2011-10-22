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
        height:  visuals.height + 30 //dscIt.height + 70

        property bool hasThumbnail: !appState.lightMode && thumbnail.length > 0
        Item {
            id: visuals
            height: childrenRect.height
            width: parent.width

            Rectangle {
                x:2
                y:15
                id: thumbarea
                width: hasThumbnail ? 60 : 0
                height: 60
                visible: hasThumbnail
                color: mainview.theme.bg
                //border.width: hasThumbnail ? 1 : 0

                Image {
                    anchors.fill: parent
                    id: tnail
                    height: 60
                    width: 60
                    source: hasThumbnail ? thumbnail : ""

                }

            }

	    TText {
                id: dscIt
                text: modelData
                color: mainview.theme.fg

                font.pixelSize: 25
                anchors {
                    right: parent.right
                    left: thumbarea.right
                    leftMargin: backgroundImage.hasThumbnail ? 30 : 0
                    verticalCenter: thumbarea.verticalCenter
                    //top: thumbarea.top

                }
            }


        }

        MouseArea {
            id: ma

            anchors.fill: visuals
            onClicked: {
                itemSelected(modelData)
            }

        }

    }
}


