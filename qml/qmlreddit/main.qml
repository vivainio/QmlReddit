import Qt 4.7

Rectangle {
    width: 640
    height: 480
    id: mainview;
    LinkView { id: linkview; x : 0; anchors.fill: parent }
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
        /*
        function doCom() {
            console.debug("com sel")
            mainview.state = "LinkState"
            commentview.color = "green";
        }
        */

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
                x : 0
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
