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
            commentview.loadView()
            commentview.item.populate(json)

        }
    }


    Connections {
        target: mdlRedditSession
        onLoggedOut: {
            mdlReddit.refreshCategories()
        }
        onLinksAvailable: {
            progressInd.hide()
            viewSwitcher.switchView(linkview, true)

        }

    }

    Connections {
        target: appState

        onIncognitoModeChanged: {
            mdlRedditSession.setIncognito(appState.incognitoMode)
        }

        onLockOrientationChanged: {
            var or = appState.lockOrientation ? "landscape" : "auto"
            lifecycle.setOrientation(or)

        }

        onLinkSelectionChanged: {
            //console.log('lsel')
            mdlRedditSession.setLinkSelection(appState.linkSelection)
            RE.eng().fetchLinks()

        }

    }

    function startup() {
        //linkview.start()
        //viewSwitcher.switchView(linkview, true)
        RE.eng().setModels(mdlReddit, mdlRedditSession)
        //commentview.focus = true
        progressInd.show()
        viewSwitcher.duration = 0
        viewSwitcher.switchView(splash, true, "instant")
        viewSwitcher.duration = 700
        if (appState.linkSelection == "Hot") {
           RE.eng().fetchLinks()
        }

    }

    Component.onCompleted: startup();

    ViewLoader {
        id: splash
        viewSource: "SplashScreen.qml"
        keepLoaded: false
    }

    ViewLoader {
        id: prompter
        viewSource: "Prompter.qml"

    }

    ViewLoader {
        id: categoryselector

        viewSource: "ActionGrid.qml"
        function onItemSelected(itemName) {


            mainview.state = "LinkState"

            if (itemName == "Other") {
                prompter.loadView()
                function doOtherSubreddit(sr) {
                    console.log("other " + sr)
                    RE.eng().catSelected(sr)
                    linkview.item.start()
                    RE.eng().fetchLinks()
                }

                prompter.item.launch("Enter subreddit", linkview, doOtherSubreddit)

                viewSwitcher.switchView(prompter, true)

            }

            else if (itemName != 'Cancel') {
                RE.eng().catSelected(itemName)
                linkview.item.start()
                RE.eng().fetchLinks()
            } else {
                viewSwitcher.switchView(linkview, false)
            }
        }


        onLoaded: {
            item.model = mdlCategories
            item.itemSelected.connect(onItemSelected)
        }

    }

    ViewLoader {
        id: toolgrid
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

    ViewLoader {
        viewSource: "LinkView.qml"
        id: linkview

        function onLinkSelected(selIndex) {
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
            commentview.loadView()
            commentview.item.setLink(lnk)
            // in light mode, no preview loaded by default
            if (!appState.lightMode) {
                webpreview.setUrl(lnk.url)
            }
        }
        onLoaded: {
            item.linkSelected.connect(onLinkSelected)
        }



    }

    ViewLoader {
        id: commentview
        viewSource: "CommentView.qml"
        function onReqPreview() {
            var lnk = RE.eng().currentLink()
            viewSwitcher.switchView(webpreview, false)
            mainview.state = "PreviewState"
            //console.log("prev ", lnk)

            // in light mode, web page rendered at this time
            if (appState.lightMode)
                webpreview.setUrl(lnk.url)
            //RE.dump(lnk)
        }
        function onReqLinks() {
            viewSwitcher.switchView(linkview, true)
            mainview.state = "LinkState"
        }

        onLoaded: {
            item.reqPreview.connect(onReqPreview)
            item.reqLinks.connect(onReqLinks)
            item.focus = true
        }

    }

    ViewLoader {
        id: webpreview
        viewSource: "WebPreview.qml"
        function setUrl(u) {
            webpreview.loadView()
            item.setUrl(u)
        }

        function goBack() {
            viewSwitcher.switchView(commentview, true)
            mainview.state = "CommentsState"

        }

        onLoaded: {
            item.reqBack.connect(goBack)
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

    ProgressInd {
        id: progressInd
    }


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
