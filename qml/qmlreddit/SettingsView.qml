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
        applicationName: "Settings"

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
            toolbarItemTitle: "About"
            backsteppingExits: false

            Text {
                textFormat: Text.RichText
                text: "<h1>QmlReddit</h1><p>Development version, expect continuous improvements</p> "

            }

        }
    }



}
