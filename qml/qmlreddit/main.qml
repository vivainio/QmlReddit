import Qt 4.7

Rectangle {
    width: 640
    height: 480
    id: mainview;

    /*
    Flipable {
        id: fl
        anchors.fill: parent
        back: LinkView { id: linkview; anchors.fill: parent }
        front: CommentView {
            id: commentview; width: parent.width; height: parent.height
            onCommentSelected: {
                console.log("sel")
            }

        }


    }
    */



    LinkView { id: linkview }
    CommentView {
        id: commentview
        width: parent.width
        height: parent.height
        Behavior on x {
            NumberAnimation {
                    duration: 500
        }

        }

        //anchors.fill: parent

        onCommentSelected: mainview.state = "LinkState"
    }
    state: "CommentsState"
    states: [
        State {

            name: "LinkState"

            StateChangeScript {

                script: console.log("tolinks");


            }

            PropertyChanges {
                target: linkview
                x: 0


            }

        },

        State {
            name: "CommentsState"
            PropertyChanges {
                target: commentview
                x: 0
            }

        }


    ]

}
