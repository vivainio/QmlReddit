import Qt 4.7
import "Toolbar"

Rectangle {
    id: container
    //anchors.fill: parent

    signal dismiss

    color: mainview.theme.bg
    //anchors { top: parent.top; bottom : parent.bottom }
    //width: parent.width
    //height: parent.height
    //x: width + 200

    HeaderView {
        id: headerView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        applicationName: "Settings"

        onBackstep: {
            viewSwitcher.switchView(linkview, false)
            mainview.state = "LinkState"
        }
    }

    Toolbar {
        id: toolbar
        anchors {
            top: headerView.bottom
            bottom: parent.bottom
        }
        current: 2


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

            TText {
                anchors.fill: parent

                color: mainview.theme.fg

                textFormat: Text.RichText                
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "<h1>QmlReddit</h1><p>Copyright (c) 2011 by Ville M. Vainio</p>"
            }
	    Image {
		id: flattrpic
		source: "pics/flattr-badge-large.png"

		anchors {
		    right:  parent.right
		    rightMargin: 50
		    bottom: parent.bottom
		    bottomMargin: 50
		}
		MouseArea {
		    anchors.fill: parent
		    onClicked: {
			infoBanner.show("Opening Flattr in browser")
			Qt.openUrlExternally("http://flattr.com/thing/147608/QmlReddit")
		    }
		}
	    }



        }

        ToolbarView {
            toolbarItemTitle: "Settings"
            backsteppingExits: false

            Rectangle {
                anchors.fill: parent
                color: mainview.theme.bg
                Flow {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 30
                    width: parent.width


                    RButton {
                        width: 200
                        buttonLabel: "Top comments"
                        selected: appState.topCommentsMode
                        onClicked: {
                            appState.topCommentsMode = !appState.topCommentsMode
                        }

                    }

                    RButton {
                        width: 200
                        buttonLabel: "Light mode"
                        selected:  appState.lightMode
                        onClicked: {
                            appState.lightMode = !appState.lightMode
                        }
                    }
                    RButton {
                        width: 200

                        buttonLabel: "Incognito mode"
                        selected:  appState.incognitoMode
                        onClicked: {
                            appState.incognitoMode = !appState.incognitoMode
                        }
                    }
                    RButton {
                        width: 200

                        buttonLabel: "Lock landscape"
                        selected:  appState.lockOrientation
                        onClicked: {
                            appState.lockOrientation = !appState.lockOrientation
                        }
                    }
                    RButton {
                        width: 200
                        buttonLabel: "Alt browser"
                        selected: appState.altBrowser
                        onClicked:  {
                            appState.altBrowser = !appState.altBrowser
                        }
                    }

                    /*
                    RButton {
                        width: 200

                        buttonLabel: "Force sw rendering"
                        selected:  appState.swRender
                        onClicked: {
                            appState.swRender = !appState.swRender
                        }
                    }
                    */


                }
            }

        }
    }



}
