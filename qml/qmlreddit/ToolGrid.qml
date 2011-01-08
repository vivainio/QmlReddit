import Qt 4.7

import "redditengine.js" as RE


Item {

    //width: parent.width
    //height: parent.height
    //color: "blue"

    Rectangle {
        anchors.fill: parent
        opacity: 0.8

    }


    ListModel {
        id: toolsModel
        ListElement {
            label: "pics/system-shutdown.svg"
            name: "quit"

        }

        ListElement {
            label: "pics/accessories-dictionary.svg"
            name: "cat"
        }
        ListElement {

            label: "pics/applications-internet.svg"
            name: "browser"
        }
        ListElement {
            label: "pics/preferences-other.svg"
            name: "prefs"
        }

        ListElement {
            label: "pics/view-fullscreen.svg"
            name: "viewsize"
        }
        ListElement {
            label : "pics/twitter_logo.svg"
            name: "twitter"
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
            color: "yellow"
            bgOpacity: 0.9
            onClicked: {
                itemSelected(name)

                //root.state = "small"
            }

        }
    }

    GridView {
        model: toolsModel
        delegate: dlgbutton
        anchors.centerIn: parent
        anchors.fill: parent
        cellWidth: 150
        cellHeight: 120
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
                    mdlRedditSession.setLinkSelection(modelData)
                    RE.eng().fetchLinks()
                }

            }
        }

    }

    function itemSelected(itemName) {
        state = ""
        if (itemName == "cat") {
            if (!priv.myRedditsFetched) {
                mdlRedditSession.getMyReddits()
                priv.myRedditsFetched = true
            }
            viewSwitcher.switchView(categoryselector, true)
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
            viewSwitcher.switchView(settingsview, true)
            mainview.state = "SettingsState"

        }

        if (itemName == "viewsize") {
            lifecycle.toggleState()
        }

        if (itemName == "twitter") {
            var lnk = RE.eng().currentLink()
            var msg = "Reading " + lnk.url
            Qt.openUrlExternally("http://twitter.com/home?status=" + msg)
            //mdlReddit.browser("http://twitter.com/home?status=" + msg)

        }

        //console.log("Select item ", itemName)
    }

}
