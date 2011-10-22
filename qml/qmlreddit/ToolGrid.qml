import Qt 4.7

import "redditengine.js" as RE


Item {

    Rectangle {
        anchors.fill: parent
        opacity: 0.8
        color: mainview.theme.bg
    }

    ListModel {
        id: toolsModel
        ListElement {
            thumbnail: "pics/system-shutdown.svg"
            name: "quit"
            modelData: "Quit"

        }

        ListElement {
            thumbnail: "pics/accessories-dictionary.svg"
            name: "cat"
            modelData: "Category"
        }
        ListElement {

            thumbnail: "pics/applications-internet.svg"
            name: "browser"
            modelData: "Show in browser"
        }
        ListElement {
            thumbnail: "pics/preferences-other.svg"
            name: "prefs"
            modelData: "Preferences"
        }

        ListElement {
            thumbnail : "pics/twitter_logo.svg"
            name: "twitter"
            modelData: "Tweet"
        }
    }


    Component {
        id: dlgbutton
        ImgButton {
            id: te
            buttonImage: label
            //buttonLabel: label
            width: 100
            height: 100
            color: mainview.theme.bg
            bgOpacity: 1
            pressedColor: "green"
            borderColor: "yellow"

            onClicked: {
                itemSelected(name)

                //root.state = "small"
            }

        }
    }

    ListView {
        id: tglv
        model: toolsModel
        delegate: ActionListDelegate {}
        anchors.centerIn: parent
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds        
    }


    Component {
        id: cExcSelector
        RButton {
            property string sel : ""

            buttonLabel: sel
            selected: appState.linkSelection == sel
            onClicked: {
                appState.linkSelection = sel
            }
        }

    }


    Grid {
        anchors.bottom: parent.bottom
        columns: 3
        spacing: 5
        Repeater {
            model: ["Hot", "New", "Top", "Saved", "Contr"]
            RButton {
                buttonLabel: modelData
                selected: appState.linkSelection == modelData

                onClicked: {
                    appState.linkSelection = modelData                    
                    //RE.eng().fetchLinks()
                }

            }
        }

    }

    function itemSelected(itemName) {
        toolgrid.state = ""

        console.log("Toolgrid is " + itemName)
        //appState.childMode = true

        if (itemName == "Category") {
            if (appState.childMode) {
                infoBanner.show("Not available in child mode")
                promptCustomSubreddit()
                return
            }

            if (!priv.myRedditsFetched) {
                mdlRedditSession.getMyReddits()
                priv.myRedditsFetched = true
            }
            viewSwitcher.switchView(categoryselector, true)
            mainview.state = "SelectCategory"

        }
        if (itemName == "Quit") {
            Qt.quit()
        }
        if (itemName == "Show in browser") {
            var lnk = RE.eng().currentLink()
            if (lnk.permalink) {
                mainview.openUrl("http://www.reddit.com" + lnk.permalink)

            } else {
                mainview.openUrl("http://www.reddit.com")
            }
        }
        if (itemName == "Preferences") {
            viewSwitcher.switchView(settingsview, true)
            mainview.state = "SettingsState"

        }

        if (itemName == "viewsize") {
            lifecycle.toggleState()
        }

        if (itemName == "Tweet") {
            var lnk = RE.eng().currentLink()
            if (!lnk || !lnk.url) {
                infoBanner.show("No link selected")
                return
            }


            var cookedurl = "";
            var cookeddesc = ""
            if (hostOs == "maemo5") {
                cookedurl = lnk.url
                cookeddesc = lnk.desc

            } else {
                cookedurl = escape(lnk.url)
                //cookedurl = lnk.url
                cookeddesc = escape(lnk.desc)
            }


            var u;

            if (hostOs == "symbian") {
                u = "http://twitter.com/share?via=qmlreddit&url=" + cookedurl
            } else {
              var u = "http://twitter.com/share?url=" + cookedurl+"&text=" + cookeddesc + "&via=qmlreddit"
            }

            //console.log("Launch " + u)
            mainview.openUrl(u)

            //mdlReddit.browser("http://twitter.com/home?status=" + msg)

        }

        //console.log("Select item ", itemName)
    }

}
