import Qt 4.7

import "redditengine.js" as RE

Rectangle {
    width: 360
    height: 640
    anchors.fill: parent
    id: mainview;

    //property variant eng

    QtObject {
        id: priv
        property bool myRedditsFetched : false
    }

    AppState {
        id: appState
    }

    Connections {
        target: mdlReddit
        onCommentsJsonAvailable: {
            //console.log('got json ', json)
            commentview.populate(json)

        }
    }
    Connections {
        target: mdlRedditSession
        onLoggedOut: {
            mdlReddit.refreshCategories()
        }

    }

    function startup() {
        //infoBanner.show("Loading")
        linkview.start()
        RE.eng().setModels(mdlReddit, mdlRedditSession)

    }

    Component.onCompleted: startup();

    ActionGrid {
        id: categoryselector
        x : parent.width + 200
        anchors.verticalCenter: parent.verticalCenter

        model: mdlCategories
        width: parent.width
        height: parent.height
        onItemSelected: {
            if (itemName == '+') {
                mdlReddit.editConfig()
            }

            mainview.state = "LinkState"

            if (itemName != '+' && itemName != 'Cancel') {
                RE.eng().catSelected(itemName)
                linkview.start()
                RE.eng().fetchLinks()
                //mdlReddit.start(itemName, 0)
            }
        }
    }


    ToolGrid {
        id: toolgrid
        width: parent.width
        height: parent.height
        x : width + 100
        y : 0
        z: 20
        states: [
            State {
                name: "exposed"
                PropertyChanges {
                    target: toolgrid
                    x :0

                }
            }
        ]

    }

    ImgButton {
        id: toolbar
        anchors.right: linkview.right
        anchors.bottom: linkview.bottom

        z : toolgrid.z + 1
        buttonImage: toolgrid.state == "" ? "pics/document-properties.svg" : "pics/process-stop.svg"
        onClicked: {
            if (toolgrid.state == "") {
                toolgrid.state =  "exposed"
            }
            else {

                toolgrid.state = ""
            }
        }

    }

    /*
    FlatToolBar {
        id: toolbar
        anchors.right: linkview.right
        anchors.bottom: linkview.bottom
        orientation: mainview.height > mainview.width ? ListView.Vertical : ListView.Horizontal
        z: 10
        model: ListModel {
            ListElement {
                label: "Quit"
                name: "quit"

            }

            ListElement {
                label: "Cat"
                name: "cat"
            }
            ListElement {

                label: "Browser"
                name: "browser"
            }
            ListElement {
                label: "Prefs"
                name: "prefs"
            }
        }
        onItemSelected: {
            if (itemName == "cat") {
                if (!priv.myRedditsFetched) {
                    mdlRedditSession.getMyReddits()
                    priv.myRedditsFetched = true
                }

                mainview.state = "SelectCategory"

            }
            if (itemName == "quit") {
                Qt.quit()
            }
            if (itemName == "browser") {
                var lnk = RE.eng().currentLink()                
                if (lnk.permalink) {
                    mdlReddit.browser("http://www.reddit.com" + lnk.permalink)
                } else {
                    mdlReddit.browser("http://www.reddit.com")
                }


            }
            if (itemName == "prefs") {
                mainview.state = "SettingsState"
            }

            //console.log("Select item ", itemName)
        }
    }
    */


    LinkView  {
        id: linkview
        width: parent.width
        height: parent.height
        onLinkSelected: {

            var eng = RE.eng()
            //console.log("sig ", selIndex, " m ", mdlReddit.fetchComments)

            //var lnk = mdlReddit.getLink(selIndex)
            var lnk = eng.getLink(selIndex)
            //console.log("have vote", lnk.vote)
            if (eng.shouldShowComments(lnk)) {
                mainview.state = "CommentsState"                

            } else {
               mainview.state = "PreviewState"
            }


            //console.log("f ", eng)
            //RE.dump(eng)
            eng.linkSelected(lnk)
            //RE.doLinkSelected(eng, lnk);
            //console.log(lnk)
            var url = lnk["permalink"]
            //console.log("url ", url)

            mdlReddit.fetchComments(url);
            commentview.setLink(lnk)
            webpreview.url = lnk.url            
        }


    }
    CommentView {
        id: commentview
        width: parent.width
        height: parent.height

        //anchors.fill: parent

        //onCommentSelected: mainview.state = "LinkState"
        onReqPreview: {
            var lnk = RE.eng().currentLink()
            mainview.state = "PreviewState"
            //console.log("prev ", lnk)
            webpreview.url = lnk.url
            //RE.dump(lnk)
        }
        onReqLinks: mainview.state = "LinkState"
    }

    WebPreview {
        id: webpreview
        onReqBack: {
            mainview.state = "CommentsState"

        }
    }
    SettingsView {
        id: settingsview
        onDismiss: {
            mainview.state = "LinkState"
        }

    }


    InfoBanner {
        id: infoBanner

    }

    state: "LinkState"
    states: [
        State {

            name: "LinkState"

            PropertyChanges {
                target: linkview
                x: 0

            }

            StateChangeScript {
                script: {
                    webpreview.url = "about:blank"
                    commentview.clear()
                }

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
            //StateChangeScript {
                //script: console.log("to preview")
            //}
        },
        State {
            name: "SelectCategory"
            PropertyChanges {
                target: categoryselector
                x : 0
            }
        },
        State {
            name: "SettingsState"
            PropertyChanges {
                target: settingsview
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
