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
                anchors.fill: parent

                textFormat: Text.RichText                
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "<h1>QmlReddit</h1><p>Version 0.9</p><p>Click on score to vote on comment. 't' to show top comments. 'l' for light mode"
            }

        }

        ToolbarView {
            toolbarItemTitle: "Settings"
            backsteppingExits: false

            Rectangle {
                anchors.fill: parent
                Grid {
                    anchors.fill: parent
                    spacing: 30
                    columns: 2
                    RButton {
                        width: 120
                        buttonLabel: "Top comments"
                        selected: appState.topCommentsMode
                        onClicked: {
                            appState.topCommentsMode = !appState.topCommentsMode
                        }

                    }

                    RButton {
                        width: 120
                        buttonLabel: "Light mode"
                        selected:  appState.lightMode
                        onClicked: {
                            appState.lightMode = !appState.lightMode
                        }
                    }
                    RButton {
                        width: 120
                        buttonLabel: "Incognito mode"
                        selected:  appState.incognitoMode
                        onClicked: {
                            appState.incognitoMode = !appState.incognitoMode
                        }
                    }
                }
            }

        }
    }



}
