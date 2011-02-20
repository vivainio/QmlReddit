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
        color: mainview.theme.bg
        anchors.fill: parent
        opacity: 0.95
        MouseArea {
            anchors.fill: parent
        }

    }

    function  doVote(vote) {
        mdlRedditSession.vote(comment.name, vote)
        visible = false
        infoBanner.show("Comment vote: " + vote)
    }


    Text {
        text: "hed"
        id: heading
        color: mainview.theme.fg
        height: 40
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 80
    }



    Row {
        anchors.centerIn: parent
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



}
