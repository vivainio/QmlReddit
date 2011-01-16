import Qt 4.7

import "redditengine.js" as RE

Rectangle {
    width: 360
    height: 640
    anchors.fill: parent
    id: mainview;

    //property variant eng

    ViewSwitcher {
        id: viewSwitcher
        root: mainview
    }

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
        viewSwitcher.switchView(linkview, true)
        RE.eng().setModels(mdlReddit, mdlRedditSession)
        commentview.focus = true

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

            viewSwitcher.switchView(linkview, false)
            mainview.state = "LinkState"

            if (itemName != '+' && itemName != 'Cancel') {
                RE.eng().catSelected(itemName)
                linkview.start()
                RE.eng().fetchLinks()
                //mdlReddit.start(itemName, 0)
            }
        }
    }

    ViewLoader {
        id: toolgrid
        //width: parent.width
        //height: parent.height
        //x : width + 100
        //y : 0
        z: 20
        viewSource: "ToolGrid.qml"
        visible: false
        states: [
            State {
                name: "exposed"
                PropertyChanges {
                    target: toolgrid
                    opacity: 1
                    x : 0
                    visible: true

                }
            }
        ]

    }


    ImgButton {
        id: toolbar
        anchors.right: mainview.right
        anchors.bottom: mainview.bottom

        visible: false
        z : toolgrid.z + 1
        buttonImage: toolgrid.state == "" ? "pics/document-properties.svg" : "pics/process-stop.svg"
        onClicked: {
            if (toolgrid.state == "") {
                toolgrid.loadView()
                toolgrid.state =  "exposed"
            }
            else {

                toolgrid.state = ""
            }
        }

    }

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

            var directpreview = !eng.shouldShowComments(lnk)
            if (!directpreview) {
                viewSwitcher.switchView(commentview, false)
                mainview.state = "CommentsState"                


            } else {
               viewSwitcher.switchView(webpreview, false)
               mainview.state = "PreviewState"
            }


            //console.log("f ", eng)
            //RE.dump(eng)
            eng.linkSelected(lnk)
            //RE.doLinkSelected(eng, lnk);
            //console.log(lnk)
            var url = lnk["permalink"]
            //console.log("url ", url)

            if (appState.lightMode && directpreview) {
                console.log("light mode, don't load comments for direct preview")
                webpreview.setUrl(lnk.url)

            } else {
                mdlReddit.fetchComments(url)
            }
            commentview.setLink(lnk)
            // in light mode, no preview loaded by default
            if (!appState.lightMode) {
                webpreview.setUrl(lnk.url)
            }
        }


    }
    CommentView {
        id: commentview
        width: parent.width
        height: parent.height
        //focus: true

        //anchors.fill: parent

        //onCommentSelected: mainview.state = "LinkState"
        onReqPreview: {
            var lnk = RE.eng().currentLink()
            viewSwitcher.switchView(webpreview, false)
            mainview.state = "PreviewState"
            //console.log("prev ", lnk)

            // in light mode, web page rendered at this time
            if (appState.lightMode)
                webpreview.setUrl(lnk.url)
            //RE.dump(lnk)
        }
        onReqLinks: {
            viewSwitcher.switchView(linkview, true)
            mainview.state = "LinkState"
        }
    }

    WebPreview {
        id: webpreview
        onReqBack: {
            viewSwitcher.switchView(commentview, true)
            mainview.state = "CommentsState"

        }
    }

    ViewLoader {
        id: settingsview
        viewSource: "SettingsView.qml"
        keepLoaded: false

    }

    /*
    SettingsView {
        id: settingsview
        onDismiss: {
            viewSwitcher.switchView(linkview, false)
            mainview.state = "LinkState"
        }
    }
    */


    InfoBanner {
        id: infoBanner

    }

    state: "LinkState"
    states: [
        State {

            name: "LinkState"

            /*
            PropertyChanges {
                target: linkview
                x: 0

            }
            */
            PropertyChanges {
                target:  toolbar
                visible: true

            }
            StateChangeScript {

                script: {
                    webpreview.setUrl("about:blank")
                    //commentview.clear()
                    //viewSwitcher.switchView(linkview, true)
                }

            }

        },

        State {
            name: "CommentsState"

            PropertyChanges {
                target: toolbar
                visible: true

            }
            StateChangeScript {
                script: {
                    //viewSwitcher.switchView(commentview, true)
                    commentview.focus = true
                }
            }

            /*
            PropertyChanges {
                target: commentview
                x: 0
            }

            PropertyChanges {
                target: linkview
                x : 1000

            }
            */
            AnchorChanges {
                target: toolbar
                anchors.top: mainview.top
                anchors.bottom: undefined
                anchors.right: mainview.right

            }

        },
        State {
            name: "PreviewState"
            /*
            PropertyChanges {
                target: webpreview
                x : 0
            }
            */
            StateChangeScript {
                script: {
                    //viewSwitcher.switchView(webpreview, true)
                    //console.log("to preview")
                }
            }
        },
        State {
            name: "SelectCategory"
            /*
            PropertyChanges {
                target: categoryselector
                x : 0
            }
            */
        },
        State {
            name: "SettingsState"
            /*
            PropertyChanges {
                target: settingsview
                x : 0
            }
            */

        }

    ]

    transitions: [
      Transition {
           /*
          from: "*"; to: "*"
          PropertyAnimation {
              target: commentview
              properties: "x"; duration: 200
          }
          PropertyAnimation {
              target: linkview
              properties: "x"; duration: 200
          }
          */
          AnchorAnimation {
              targets: [toolbar]
                duration: 300
          }
      } ]


}
