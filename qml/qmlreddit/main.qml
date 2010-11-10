import Qt 4.7

import "redditengine.js" as RE

Rectangle {
    width: 800
    height: 450
    anchors.fill: parent
    id: mainview;

    //property variant eng

    //Component.onCompleted: eng = RE.create()

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
            //console.log("f ", eng)
            //RE.dump(eng)
            RE.eng().linkSelected(lnk)
            //RE.doLinkSelected(eng, lnk);
            console.log(lnk)
            var url = lnk["permalink"]
            console.log("url ", url)

            mdlReddit.fetchComments(url);
        }


    }
    CommentView {
        id: commentview
        width: parent.width
        height: parent.height

        //anchors.fill: parent

        onCommentSelected: mainview.state = "LinkState"
        onReqPreview: {
            var lnk = RE.eng().currentLink()
            mainview.state = "PreviewState"
            console.log("prev ", lnk)
            RE.dump(lnk)
        }
        onReqLinks: mainview.state = "LinkState"
    }

    WebPreview {
        id: webpreview
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

        },
        State {
            name: "PreviewState"
            PropertyChanges {
                target: webpreview
                x : 0
            }
            StateChangeScript {
                script: console.log("to preview")
            }
        }
    ]


    transitions: [
      Transition {
          from: "*"; to: "*"
          PropertyAnimation {
              target: commentview
              properties: "x"; duration: 200
          }
          PropertyAnimation {
              target: linkview
              properties: "x"; duration: 200
          }
      } ]


}
