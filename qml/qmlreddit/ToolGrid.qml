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


    }


    function itemSelected(itemName) {
        state = ""
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
