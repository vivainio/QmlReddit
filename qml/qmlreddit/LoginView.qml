import Qt 4.7

Rectangle {

    Column {
        anchors.centerIn: parent
        Row {
            Text {
                text: "Username"

            }

            Item { width: 20; height: 1 }

            TextInput {

                id: inpUserName

                width: 200
                Rectangle {
                    border.width: 1
                    z: parent.z - 1
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

        Item {
            height: 20
            width: 1
        }

        Row {
            Text {
                text: "Password"
            }
            Item { width: 20; height: 1 }

            TextInput {
                id: inpPassword
                width: 200
                echoMode: TextInput.Password
                Rectangle {
                    border.width: 1
                    z: parent.z - 1
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

    }

    RButton {
        anchors {
            right: parent.right
            bottom: parent.bottom

            rightMargin: 40
            bottomMargin: 30
        }

        buttonLabel: "Login"

        onClicked: {
        }

    }


}
