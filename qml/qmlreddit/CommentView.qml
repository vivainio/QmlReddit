import Qt 4.7

Rectangle {
    x: width + 200

    signal commentSelected
    signal reqPreview(string url)
    signal reqLinks
    /*
    Rectangle {
        color: "#9c5d5d"
        anchors.fill: parent    r

    }
    */

    Component {

        id: dlgComments

        Rectangle {
            width: parent.width
            height: txtCom.height + 30

            Text {
                x: 3
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
