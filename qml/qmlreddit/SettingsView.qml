import Qt 4.7
import "Toolbar"

Rectangle {
    id: container
    //anchors.fill: parent

    signal dismiss

    width: parent.width
    height: parent.height
    x: width + 200

    HeaderView {
        id: headerView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        applicationName: "Toolbar"

        onBackstep: {
            dismiss()

        }
    }

    Toolbar {
        id: toolbar
        anchors {
            top: headerView.bottom
            bottom: parent.bottom
        }


        ToolbarView {
            toolbarItemTitle: "Login"
            toolbarItemIcon: "pics/star.png"
            clip: true
            backsteppingExits: false

            LoginView {
                anchors.fill: parent

            }

        }
        ToolbarView {
            toolbarItemTitle: "Misc"

            Text {

                text: "Nothing here yet"
            }

        }
    }



}
