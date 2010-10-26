import Qt 4.7

Rectangle {
    x: 1000
    signal commentSelected
    signal reqPreview(string url)
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
                id: txtCom
                text: commentText
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                width: parent.width
            }

        }

    }

    ListView {
        anchors.fill: parent
        model: mdlComments
        delegate: dlgComments
    }

    Rectangle {
        id: imgNext
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 60
        height: 20
        color: "#ca6262"
        Text {
            text: "Preview"
        }


    }
    MouseArea {
        anchors.fill:  imgNext
        onClicked: reqPreview("url")
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
