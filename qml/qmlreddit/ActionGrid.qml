import Qt 4.7

Rectangle {

    property alias model : gv.model

    ListModel {
        id: testmodel1
        ListElement { catName : 'cat1'  }
        ListElement { catName : 'cat2' }
    }

    ListModel {
        id: testmodel2
        ListElement { catName: 'Cancel' }

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
        anchors { bottom: lv.top; top: parent.top }

        boundsBehavior: Flickable.StopAtBounds

        //anchors.verticalCenter: parent.verticalCenter
        delegate: Component {
            RButton {
                buttonLabel: catName
                color: "yellow"
                width: 150
                height: 80
                onClicked: {
                    itemSelected(catName)
                }
            }
        }

        footer: Component {
            RButton {
                id: nsfwbutton
                buttonLabel: "Enable NSFW channels";
                color: "yellow"
                width: 300
                height: 80
                onClicked: {
                    infoBanner.show("Double click to confirm age >= 18")
                }

                onDoubleClicked: {
                    infoBanner.show("Entering incognito mode")
                    appState.incognitoMode = true
                    mdlReddit.enableRestricted(true);
                    mdlReddit.refreshCategories()
                    nsfwbutton.visible = false

                }               

            }
        }
    }
    ListView {
        id: lv
        model: testmodel2
        orientation: "Horizontal"

        spacing: 20
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        //anchors.top: gv.bottom
        anchors.left: parent.left
        height: 90

        boundsBehavior: Flickable.StopAtBounds
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

    }

}
