import Qt 4.7

Item {

    visible: false

    anchors.fill: parent

    property variant comment

    function setComment(elem) {
        console.log("Comment is", elem)
        heading.text = elem.body
        comment = elem

    }

    Rectangle {
        color: "white"
        anchors.fill: parent
        opacity: 0.9
        MouseArea {
            anchors.fill: parent
        }
    }

    function  doVote(vote) {
        mdlRedditSession.vote(comment.name, vote)
        visible = false
        infoBanner.show("Comment vote: " + vote)
    }

    Column {
        anchors.fill: parent


        Row {
            spacing: 20

            RButton {
                buttonLabel: "+"
                onClicked: {
                    doVote(1)


                }
            }

            RButton {
                buttonLabel: "0"
                onClicked: doVote(0)
            }

            RButton {
                buttonLabel: "-"
                onClicked: doVote(-1)
            }
        }

        Text {
            text: "hed"
            id: heading
            height: 40
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: parent.width
        }

    }


}
