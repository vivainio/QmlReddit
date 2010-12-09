import Qt 4.7

import "redditengine.js" as RE

Rectangle {
    width: 800
    height: 440
    anchors.fill: parent
    id: mainview;

    //property variant eng

    QtObject {
        id: priv
        property bool myRedditsFetched : false


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
        infoBanner.show("Loading")


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
                mdlReddit.start(itemName)
            }
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

    LinkView  {
        id: linkview
        width: parent.width
        height: parent.height
        onLinkSelected: {

            var eng = RE.eng()
            //console.log("sig ", selIndex, " m ", mdlReddit.fetchComments)




            var lnk = mdlReddit.getLink(selIndex)
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

        onCommentSelected: mainview.state = "LinkState"
        onReqPreview: {
            var lnk = RE.eng().currentLink()
            mainview.state = "PreviewState"
            //console.log("prev ", lnk)
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
