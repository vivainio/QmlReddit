import Qt 4.7

import "redditengine.js" as RE

Rectangle {

    //property bool loggedIn: false

    color: mainview.theme.bg
    Component.onCompleted: {

        appState.checkLogin()

    }

    QtObject {
        id: priv
        property string lastAttempt: ""
    }

    Connections {
        target: mdlRedditSession
        onLoginResponse: {
            //console.log("Resp is ", response)
            appState.checkLogin()
            if (appState.loggedIn) {
                appState.lastLogin = priv.lastAttempt
                inpPassword.text = ""

            } else {
                aLoginBounce.start()

            }
            btnLogin.opacity = 1

        }
    }

    TText {
        anchors {
            left : parent.left
            top : parent.top
        }

        text: "User: " + appState.lastLogin
        color: mainview.theme.fg
        visible: appState.lastLogin.length > 0


    }
    Grid {
        anchors.centerIn: parent
        columns: 2
        rows: 2
        spacing: 20
        TText {
            color: mainview.theme.fg
            text: "Username"

        }
        TextInput {

            id: inpUserName
            text: ""
            width: 200
            height: 50
	    font.pointSize: mainview.theme.defaultTextSize
            //color: focus ? "blue" : "white"
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Rectangle {
                border.width: 1
                z: parent.z - 1
                color: inpUserName.activeFocus ? "lightblue" : "white"
                anchors {
                    fill: parent
                    topMargin: -1
                    bottomMargin: -1
                    leftMargin: -1
                    rightMargin: -1
                }

            }

        }

        TText {
            text: "Password"
            color: mainview.theme.fg
        }

        TextInput {
            id: inpPassword
            text: ""
            width: 200
            height: 50
            //color: focus ? "blue" : "white"

	    font.pointSize: mainview.theme.defaultTextSize
            echoMode: TextInput.PasswordEchoOnEdit
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Rectangle {
                border.width: 1
                z: parent.z - 1
                color: inpPassword.activeFocus ? "lightblue" : "white"
                anchors {
                    fill: parent
                    topMargin: -1
                    bottomMargin: -1
                    leftMargin: -1
                    rightMargin: -1
                }

            }
        }


    }

    Column {
        anchors.centerIn: parent
        Row {

            Item { width: 20; height: 1 }


        }

        Item {
            height: 20
            width: 1
        }

        Row {
        }

    }

    RButton {
        id: btnLogin
        anchors {
            right: parent.right
            bottom: parent.bottom

            rightMargin: 40
            bottomMargin: 30
        }

        buttonLabel: appState.loggedIn? "Logout" : "Login"
        color: appState.loggedIn ? "blue" : "red"

        onClicked: {
            mdlRedditSession.logout()

            if (!appState.loggedIn) {
                btnLogin.opacity = 0.2
                priv.lastAttempt = inpUserName.text
                mdlRedditSession.login( inpUserName.text, inpPassword.text)
            }
            appState.loggedIn = false
            appState.lastLogin = ""


        }

    }
    SequentialAnimation {
        id: aLoginBounce

        running: false

        PropertyAnimation {
            target: btnLogin
            property: "anchors.bottomMargin"
            to: 100

            duration: 400
            easing.type: Easing.InQuad
        }
        PropertyAnimation {
            target: btnLogin
            property: "anchors.bottomMargin"
            to: 30

            duration: 400
            easing.type: Easing.InQuad

        }
    }


}
