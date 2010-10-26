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



    LinkView  {
        id: linkview
        onLinkSelected: {
            console.log("sig ", selIndex, " m ", mdlReddit.fetchComments)
            mainview.state = "CommentsState"

            var lnk = mdlReddit.getLink(selIndex)
            console.log(lnk)
            var url = lnk["permalink"]
            console.log("url ", url)

            mdlReddit.fetchComments(url);



        }
        Behavior on x {
            NumberAnimation {
                    duration: 500
            }

        }

    }
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
    state: "LinkState"
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

            PropertyChanges {
                target: linkview
                x : 1000

            }

        }


    ]
    transitions: [
      Transition {
          from: "*"; to: "*"
          PropertyAnimation {
              target: commentview
              properties: "x"; duration: 1000
          }
          PropertyAnimation {
              target: linkview
              properties: "x"; duration: 1000
          }
      } ]


}
