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

    ActionGrid {
        id: categoryselector
        x : parent.width + 200
        anchors.verticalCenter: parent.verticalCenter


        model: mdlCategories
        width: parent.width
        height: parent.height
        onItemSelected: {
            mainview.state = "LinkState"
            mdlReddit.start(itemName)
        }
    }

    FlatToolBar {
        id: toolbar
        anchors.right: linkview.right
        anchors.bottom: linkview.bottom
        z: 10
        model: ListModel {
            ListElement {
                label: "Quit"
                name: "quit"

            }
            /*
            ListElement {
                label: "Back"
                name: "back"
            }
           */
            ListElement {
                label: "Cat"
                name: "cat"
            }
        }
        onItemSelected: {
            if (itemName == "cat") {
                mainview.state = "SelectCategory"

            }
            if (itemName == "quit") {
                Qt.quit()
            }

            console.log("Select item ", itemName)
        }
    }

    LinkView  {
        id: linkview
        width: parent.width
        height: parent.height
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
            webpreview.url = lnk.url

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
            webpreview.url = lnk.url
            RE.dump(lnk)
        }
        onReqLinks: mainview.state = "LinkState"
    }

    WebPreview {
        id: webpreview
        onReqBack: {
            mainview.state = "CommentsState"

        }
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

            AnchorChanges {
                target: toolbar
                anchors.top: commentview.top
                anchors.bottom: undefined
                anchors.right: commentview.right

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
        },
        State {
            name: "SelectCategory"
            PropertyChanges {
                target: categoryselector
                x : 0
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
          AnchorAnimation {
              targets: [toolbar]
                duration: 200
          }
      } ]


}
