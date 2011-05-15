import Qt 4.7

Rectangle {

    property alias model : gv.model

    color: mainview.theme.bg

    ListModel {
        id: testmodel1
        ListElement { catName : 'cat1'  }
        ListElement { catName : 'cat2' }
    }

    ListModel {
        id: testmodel2
        ListElement { catName: 'Cancel' }
        ListElement { catName: 'Other' }

    }

    signal itemSelected(string itemName)

    GridView {
        id : gv
        model:  testmodel1
        cellWidth: 180
        //y: 100
        //anchors.fill: parent
        width: parent.width
        //height: parent.height
        anchors { bottom: parent.bottom; top: parent.top }

        boundsBehavior: Flickable.StopAtBounds

        //anchors.verticalCenter: parent.verticalCenter
        delegate: Component {
            RButton {
                buttonLabel: catName    
                width: 150
                height: 80
                onClicked: {
                    itemSelected(catName)
                }
            }
        }

        footer: Component {
            Column {
                RButton {
		    //visible: appState.loggedIn
                    id: nsfwbutton
                    buttonLabel: "Enable NSFW channels";
                    width: 300
                    height: 80
                    onClicked: {                    
			if (!appState.loggedIn) {
			    infoBanner.show("Login required to see NSFW content!")
			    return
			}

                        infoBanner.show("Double click to confirm age >= 18")
                    }

                    onDoubleClicked: {
			if (!appState.loggedIn) {
			    infoBanner.show("Login required to see NSFW content!")
			    return
			}

                        //infoBanner.show("Entering incognito mode")
                        //appState.incognitoMode = true
                        mdlReddit.enableRestricted(true);
                        mdlReddit.refreshCategories()
                        nsfwbutton.visible = false

                    }

                }

                Item {
                    width: 1
                    height: 120
                }
            }
        }
    }
    Grid {

        id: lv

        spacing: 20
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //anchors.top: gv.bottom
        anchors.left: parent.left
        height: 90

        Repeater {
            //boundsBehavior: Flickable.StopAtBounds
            model: testmodel2

            delegate: Component {
                RButton {
                    border.color: "yellow"
                    color: "green"
                    pressedColor: "blue"
                    buttonLabel: catName
                    width: 100
                    height: 80
                    onClicked: {
                        itemSelected(catName)
                    }
                }
            }
        }

    }

}
