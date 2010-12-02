import Qt 4.7

Rectangle {
    x: width + 200

    signal commentSelected
    signal reqPreview(string url)
    signal reqLinks

    Component {

        id: dlgComments


        BorderImage {
            //width: parent.width
            height: txtCom.height + 20

            id: backgroundImage
            source: "pics/listitem.png"
            //width: ListView.view.width
            width: ListView.view.width
            border.bottom: 5
            border.top: 5
            border.left: 5
            border.right: 30

            Text {
                x: 3
                y: 10
                id: txtCom
                text: commentText
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                width: parent.width - 5
            }

        }

    }

    ListView {
        anchors.fill: parent
        model: mdlComments
        delegate: dlgComments
        spacing: 5
        footer: Rectangle {
            height: imgNext.height
        }
    }

    RButton {
        id: imgNext
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        buttonLabel: "Preview"
        onClicked: reqPreview("url")
        opacity: 0.8

    }

    RButton {
        id: imgPrev
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        buttonLabel: "Links"
        onClicked: reqLinks()
        opacity: 0.8
    }

    // we overlay back / preview button over listview...



    /*
    Text {
        anchors.fill: parent
        text: "hello comments"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                commentSelected()
                console.log("doeoehdhd")
                //commentSelected()
            }
        }

    }
    */
}
