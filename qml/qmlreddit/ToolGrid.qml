import Qt 4.7

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


    Component {
        id: dlgbutton
        RButton {
            id: te
            buttonLabel: label
            width: 100
            height: 100
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
